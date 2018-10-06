Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: disable new features for deprecated upper fs
Date: Sat,  6 Oct 2018 09:10:09 +0300
Message-Id: <20181006061009.8150-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Overlayfs works sub-optimally with upper fs that has no
xattr/d_type/O_TMPFILE support. We should basically deprecate
support for those filesystems, but so far, we only issue a warning
and don't fail the mount for the sake of backward compat.
Some features are already being disabled with no xattr support.

Such configurations, if they exist in the wild at all, get very
little to no testing coverage for new features, so disable all new
features for all of these untested configurations.

For example, when upper fs is created with mkfs.xfs -m crc=0 -n ftype=0
and all overlayfs features are enalbed by default, mount emits the
following warnings:

 overlayfs: upper fs needs to support d_type.
 ...upper fs missing required features, falling back to redirect_dir=off.
 ...upper fs missing required features, falling back to index=off.
 ...upper fs missing required features, falling back to xino=off.
 ...upper fs missing required features, falling back to metacopy=off.
 ...NFS export requires "index=on", falling back to nfs_export=off.

[backport hint: The new features started rolling in since kernel v4.10
 so different stable kernels will need different versions of this patch]

Cc: <stable@vger.kernel.org> # v4.10
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
Miklos,

I reccon we want this applied this to old stable kernels.
If you accpet this patch, I will prepare a backport version for LTS
4.14.

Thanks,
Amir.

 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 38 ++++++++++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ec237035333a..0ca6bb86eba3 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -60,6 +60,7 @@ struct ovl_fs {
 	struct ovl_config config;
 	/* creds of process who forced instantiation of super block */
 	const struct cred *creator_cred;
+	bool d_type;
 	bool tmpfile;
 	bool noxattr;
 	/* Did we take the inuse lock? */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 333bba83074f..7d7008267ed0 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -468,6 +468,16 @@ static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
 	return 0;
 }
 
+static int ovl_set_redirect_mode(struct ovl_config *config, const char *mode)
+{
+	kfree(config->redirect_mode);
+	config->redirect_mode = kstrdup(mode, GFP_KERNEL);
+	if (!config->redirect_mode)
+		return -ENOMEM;
+
+	return ovl_parse_redirect_mode(config, mode);
+}
+
 static int ovl_parse_opt(char *opt, struct ovl_config *config)
 {
 	char *p;
@@ -1037,7 +1047,8 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	 * We allowed this configuration and don't want to break users over
 	 * kernel upgrade. So warn instead of erroring out.
 	 */
-	if (!err)
+	ofs->d_type = err;
+	if (!ofs->d_type)
 		pr_warn("overlayfs: upper fs needs to support d_type.\n");
 
 	/* Check if upper/work fs supports O_TMPFILE */
@@ -1054,14 +1065,33 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	err = ovl_do_setxattr(ofs->workdir, OVL_XATTR_OPAQUE, "0", 1, 0);
 	if (err) {
 		ofs->noxattr = true;
-		ofs->config.index = false;
-		ofs->config.metacopy = false;
-		pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off and metacopy=off.\n");
+		pr_warn("overlayfs: upper fs does not support xattr.\n");
 		err = 0;
 	} else {
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
 	}
 
+	if (!ofs->d_type || !ofs->tmpfile || ofs->noxattr) {
+		if (ofs->config.redirect_dir) {
+			err = ovl_set_redirect_mode(&ofs->config, "off");
+			if (err)
+				goto out;
+			pr_warn("overlayfs: upper fs missing required features, falling back to redirect_dir=off.\n");
+		}
+		if (ofs->config.index) {
+			ofs->config.index = false;
+			pr_warn("overlayfs: upper fs missing required features, falling back to index=off.\n");
+		}
+		if (ofs->config.xino != OVL_XINO_OFF) {
+			ofs->config.xino = OVL_XINO_OFF;
+			pr_warn("overlayfs: upper fs missing required features, falling back to xino=off.\n");
+		}
+		if (ofs->config.metacopy) {
+			ofs->config.metacopy = false;
+			pr_warn("overlayfs: upper fs missing required features, falling back to metacopy=off.\n");
+		}
+	}
+
 	/* Check if upper/work fs supports file handles */
 	fh_type = ovl_can_decode_fh(ofs->workdir->d_sb);
 	if (ofs->config.index && !fh_type) {
-- 
2.17.1
