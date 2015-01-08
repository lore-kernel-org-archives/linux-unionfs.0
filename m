From: Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] ovl: Fix condition check for workdir
Date: Thu,  8 Jan 2015 21:41:20 +0900
Message-ID: <1420720880-28459-1-git-send-email-waydi1@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

When file system is mounted read-only workdir is not needed.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/overlayfs/super.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 84f3144..4e50617 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -30,6 +30,7 @@ struct ovl_config {
 	char *lowerdir;
 	char *upperdir;
 	char *workdir;
+	bool is_rw;
 };
 
 /* private information held for overlayfs's superblock */
@@ -515,10 +516,11 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	struct ovl_fs *ufs = sb->s_fs_info;
 
 	seq_printf(m, ",lowerdir=%s", ufs->config.lowerdir);
-	if (ufs->config.upperdir) {
+	if (ufs->config.upperdir)
 		seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
+	if (ufs->config.is_rw)
 		seq_printf(m, ",workdir=%s", ufs->config.workdir);
-	}
+
 	return 0;
 }
 
@@ -822,16 +824,27 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_stack_depth = 0;
 	if (ufs->config.upperdir) {
-		/* FIXME: workdir is not needed for a R/O mount */
+		err = ovl_mount_dir(ufs->config.upperdir, &upperpath);
+		if (err)
+			goto out_free_config;
+
+		sb->s_stack_depth = upperpath.mnt->mnt_sb->s_stack_depth;
+	}
+
+	/* If the upper fs is r/o or nonexistent, we mark overlayfs r/o too */
+	if (!upperpath.mnt || (upperpath.mnt->mnt_sb->s_flags & MS_RDONLY)) {
+		ufs->config.is_rw = false;
+		sb->s_flags |= MS_RDONLY;
+	} else {
+		ufs->config.is_rw = true;
+	}
+
+	if (ufs->config.is_rw) {
 		if (!ufs->config.workdir) {
 			pr_err("overlayfs: missing 'workdir'\n");
 			goto out_free_config;
 		}
 
-		err = ovl_mount_dir(ufs->config.upperdir, &upperpath);
-		if (err)
-			goto out_free_config;
-
 		err = ovl_mount_dir(ufs->config.workdir, &workpath);
 		if (err)
 			goto out_put_upperpath;
@@ -844,8 +857,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			pr_err("overlayfs: workdir and upperdir must be separate subtrees\n");
 			goto out_put_workpath;
 		}
-		sb->s_stack_depth = upperpath.mnt->mnt_sb->s_stack_depth;
 	}
+
 	err = -ENOMEM;
 	lowertmp = kstrdup(ufs->config.lowerdir, GFP_KERNEL);
 	if (!lowertmp)
@@ -884,7 +897,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			pr_err("overlayfs: failed to clone upperpath\n");
 			goto out_put_lowerpath;
 		}
+	}
 
+	if (ufs->config.is_rw) {
 		ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
 		err = PTR_ERR(ufs->workdir);
 		if (IS_ERR(ufs->workdir)) {
@@ -914,10 +929,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		ufs->numlower++;
 	}
 
-	/* If the upper fs is r/o or nonexistent, we mark overlayfs r/o too */
-	if (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
-		sb->s_flags |= MS_RDONLY;
-
 	sb->s_d_op = &ovl_dentry_operations;
 
 	err = -ENOMEM;
-- 
2.2.1

