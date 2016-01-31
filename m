From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [PATCH] ovl: detect distributed fs also by looking into default
 dentry operations
Date: Sun, 31 Jan 2016 16:22:27 +0300
Message-ID: <145424654711.10854.12396689961212056269.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

For example fuse root dentry has no dentry operations.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Fixes: 7c03b5d45b8e ("ovl: allow distributed fs as lower layer")
---
 fs/overlayfs/super.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1a354840f262..7a236865d56c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -365,6 +365,14 @@ static bool ovl_dentry_remote(struct dentry *dentry)
 		(DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
 }
 
+static bool ovl_path_remote(const struct path *path)
+{
+	const struct dentry_operations *d_op = path->dentry->d_sb->s_d_op;
+
+	return ovl_dentry_remote(path->dentry) ||
+		(d_op && (d_op->d_revalidate || d_op->d_weak_revalidate));
+}
+
 static bool ovl_dentry_weird(struct dentry *dentry)
 {
 	return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
@@ -837,7 +845,7 @@ static int ovl_mount_dir(const char *name, struct path *path)
 		err = ovl_mount_dir_noesc(tmp, path);
 
 		if (!err)
-			if (ovl_dentry_remote(path->dentry)) {
+			if (ovl_path_remote(path)) {
 				pr_err("overlayfs: filesystem on '%s' not supported as upperdir\n",
 				       tmp);
 				path_put(path);
@@ -866,7 +874,7 @@ static int ovl_lower_dir(const char *name, struct path *path, long *namelen,
 	*namelen = max(*namelen, statfs.f_namelen);
 	*stack_depth = max(*stack_depth, path->mnt->mnt_sb->s_stack_depth);
 
-	if (ovl_dentry_remote(path->dentry))
+	if (ovl_path_remote(path))
 		*remote = true;
 
 	return 0;
