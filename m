From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 05/28] ovl: Copy up only metadata during copy up where it makes sense
Date: Tue, 29 May 2018 16:45:49 +0200
Message-ID: <20180529144612.16675-6-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

If it makes sense to copy up only metadata during copy up, do it.  This is
done for regular files which are not opened for WRITE.

Right now ->metacopy is set to 0 always.  Last patch in the series will
remove the hard coded statement and enable metacopy feature.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index c072a4c0cf08..38cfd1acc196 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -388,6 +388,7 @@ struct ovl_copy_up_ctx {
 	bool tmpfile;
 	bool origin;
 	bool indexed;
+	bool metacopy;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -507,7 +508,7 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
-	if (S_ISREG(c->stat.mode)) {
+	if (S_ISREG(c->stat.mode) && !c->metacopy) {
 		struct path upperpath;
 
 		ovl_path_upper(c->dentry, &upperpath);
@@ -660,6 +661,26 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
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
@@ -681,6 +702,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (err)
 		return err;
 
+	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
+
 	if (parent) {
 		ovl_path_upper(parent, &parentpath);
 		ctx.destdir = parentpath.dentry;
-- 
2.14.3
