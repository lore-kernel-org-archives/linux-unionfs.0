Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/5] ovl: enforce 'strict' upper fs requirements with metacopy=on
Date: Thu,  1 Nov 2018 02:48:11 +0200
Message-Id: <20181101004813.31349-4-amir73il@gmail.com>
In-Reply-To: <20181101004813.31349-1-amir73il@gmail.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Overlayfs works sub-optimally with upper fs that has no
xattr/d_type/O_TMPFILE/RENAME_WHITEOUT support. We should basically
deprecate support for those filesystems, but so far, we only issue a
warning and don't fail the mount for the sake of backward compat.
Some features are already being disabled with no xattr support.

when user asks explicitly via mount option to enable the new metacopy
feature, we do not need to worry about backward compatibility and we
can fail the mount if upper fs is a sub-optimal filesystem.

Fixes: d5791044d2e5 ("ovl: Provide a mount option metacopy=on/off...")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 65 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 20135dd28192..4aca0cc67455 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1054,10 +1054,50 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
 	return err;
 }
 
+static int ovl_check_rename_whiteout(struct dentry *workdir)
+{
+	struct inode *dir = d_inode(workdir);
+	struct dentry *whiteout;
+	struct dentry *temp;
+	int err;
+
+	/* FIXME */
+	return 1;
+
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+
+	temp = ovl_create_temp(workdir, OVL_CATTR(S_IFREG | 0));
+	err = PTR_ERR(temp);
+	if (IS_ERR(temp))
+		goto out_unlock;
+
+	whiteout = ovl_create_temp(workdir, OVL_CATTR(S_IFREG | 0));
+	err = PTR_ERR(whiteout);
+	if (IS_ERR(whiteout))
+		goto out_cleanup_temp;
+
+	err = ovl_do_rename(dir, whiteout, dir, temp, RENAME_WHITEOUT);
+	if (!err && ovl_is_whiteout(whiteout))
+		err = 1;
+
+	/* Best effort cleanup of temp files from workdir */
+	ovl_cleanup(dir, whiteout);
+	dput(whiteout);
+out_cleanup_temp:
+	ovl_cleanup(dir, temp);
+	dput(temp);
+out_unlock:
+	inode_unlock(dir);
+
+	return err;
+}
+
 static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 {
 	struct vfsmount *mnt = ofs->upper_mnt;
 	struct dentry *temp;
+	bool rename_whiteout;
+	bool d_type;
 	int fh_type;
 	int err;
 
@@ -1079,11 +1119,8 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	if (err < 0)
 		goto out;
 
-	/*
-	 * We allowed this configuration and don't want to break users over
-	 * kernel upgrade. So warn instead of erroring out.
-	 */
-	if (!err)
+	d_type = err;
+	if (!d_type)
 		pr_warn("overlayfs: upper fs needs to support d_type.\n");
 
 	/* Check if upper/work fs supports O_TMPFILE */
@@ -1094,6 +1131,16 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	else
 		pr_warn("overlayfs: upper fs does not support tmpfile.\n");
 
+
+	/* Check if upper/work fs supports RENAME_WHITEOUT */
+	err = ovl_check_rename_whiteout(ofs->workdir);
+	if (err < 0)
+		goto out;
+
+	rename_whiteout = err;
+	if (!rename_whiteout)
+		pr_warn("overlayfs: upper fs does not support RENAME_WHITEOUT.\n");
+
 	/*
 	 * Check if upper/work fs supports trusted.overlay.* xattr
 	 */
@@ -1105,6 +1152,14 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
 	}
 
+	/* With 'strict' policy, sub-optimal upper fs are not allowed */
+	if (ofs->config.strict &&
+	    (!d_type || !ofs->tmpfile || !rename_whiteout || ofs->noxattr)) {
+		pr_err("overlayfs: upper fs missing required features, mount with '-o strict=off' to override strict features check.\n");
+		err = -EINVAL;
+		goto out;
+	}
+
 	/* metacopy depends on redirect_dir which depend on xattr */
 	err = ovl_feature_check(&ofs->config, &ofs->config.metacopy,
 				!ofs->noxattr, "metadata only copy up",
-- 
2.17.1
