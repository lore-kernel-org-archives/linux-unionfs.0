Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 06/30] ovl: Copy up only metadata during copy up where it makes sense
Date: Mon,  7 May 2018 13:40:38 -0400
Message-Id: <20180507174102.24086-7-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

If it makes sense to copy up only metadata during copy up, do it. This
is done for regular files which are not opened for WRITE.

Right now ->metacopy is set to 0 always. Last patch in the series will
remove the hard coded statement and enable metacopy feature.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 7e2dc41ad693..38b332d7c7e4 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -416,6 +416,7 @@ struct ovl_copy_up_ctx {
 	bool tmpfile;
 	bool origin;
 	bool indexed;
+	bool metacopy;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -553,7 +554,7 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
-	if (S_ISREG(c->stat.mode)) {
+	if (S_ISREG(c->stat.mode) && !c->metacopy) {
 		struct path upperpath;
 
 		ovl_path_upper(c->dentry, &upperpath);
@@ -708,6 +709,26 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 	return err;
 }
 
+static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
+				  int flags)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+
+	/* TODO: Will enable metacopy in last patch of series */
+	return false;
+
+	if (!ofs->config.metacopy)
+		return false;
+
+	if (!S_ISREG(mode))
+		return false;
+
+	if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
+		return false;
+
+	return true;
+}
+
 static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			   int flags)
 {
@@ -729,6 +750,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (err)
 		return err;
 
+	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
+
 	if (parent) {
 		ovl_path_upper(parent, &parentpath);
 		ctx.destdir = parentpath.dentry;
-- 
2.13.6
