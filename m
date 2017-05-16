From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/3] ovl: check on mount time if upper fs supports setting xattr
Date: Wed, 17 May 2017 00:12:40 +0300
Message-ID: <1494969161-30267-3-git-send-email-amir73il@gmail.com>
References: <1494969161-30267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36670 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753038AbdEPVMd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 17:12:33 -0400
Received: by mail-wm0-f66.google.com with SMTP id u65so39970500wmu.3
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2017 14:12:33 -0700 (PDT)
In-Reply-To: <1494969161-30267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

xattr are needed by overlayfs for setting opaque dir, redirect dir
and copy up origin.

Check at boot time by trying to set the overlay.opaque xattr on the
workdir and if that fails issue a warning message.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 34 ++++++++++++++++++++++++----------
 fs/overlayfs/overlayfs.h |  5 +++++
 fs/overlayfs/ovl_entry.h |  2 +-
 fs/overlayfs/super.c     |  6 ++++++
 fs/overlayfs/util.c      |  7 +++++++
 5 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 051323d..071b547 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -280,6 +280,26 @@ static struct ovl_fh *ovl_encode_fh(struct dentry *lower, uuid_be *uuid)
 	return fh;
 }
 
+int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
+		       const char *name, const void *value, size_t size,
+		       int xerr)
+{
+	int err;
+
+	if (ofs->noxattr)
+		return xerr;
+
+	err = ovl_do_setxattr(upperdentry, name, value, size, 0);
+
+	if (err == -EOPNOTSUPP) {
+		pr_warn("overlayfs: cannot set %s xattr on upper\n", name);
+		ofs->noxattr = true;
+		return xerr;
+	}
+
+	return err;
+}
+
 static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 			  struct dentry *upper)
 {
@@ -289,7 +309,7 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	int err;
 
-	if (ofs->nooriginxattr)
+	if (ofs->noxattr)
 		return 0;
 
 	/*
@@ -304,18 +324,12 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 			return PTR_ERR(fh);
 	}
 
-	err = ovl_do_setxattr(upper, OVL_XATTR_ORIGIN, fh, fh ? fh->len : 0, 0);
-	kfree(fh);
-
 	/*
 	 * Do not fail when upper doesn't support xattrs.
 	 */
-	if (err == -EOPNOTSUPP) {
-		pr_warn("overlayfs: cannot set " OVL_XATTR_ORIGIN " xattr on upper\n");
-		ofs->nooriginxattr = true;
-		return 0;
-	}
-
+	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh,
+				 fh ? fh->len : 0, 0);
+	kfree(fh);
 	return err;
 }
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8b86bf7..c723895 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -208,6 +208,7 @@ bool ovl_dentry_is_impure(struct dentry *dentry);
 bool ovl_dentry_is_whiteout(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry);
 void ovl_dentry_set_impure(struct dentry *dentry);
+bool ovl_noxattr(struct super_block *sb);
 bool ovl_redirect_dir(struct super_block *sb);
 void ovl_clear_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
@@ -282,3 +283,7 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
+struct ovl_fs;
+int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
+		       const char *name, const void *value, size_t size,
+		       int xerr);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b3d9cd6..34bc4a9 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -28,7 +28,7 @@ struct ovl_fs {
 	/* creds of process who forced instantiation of super block */
 	const struct cred *creator_cred;
 	bool tmpfile;
-	bool nooriginxattr;
+	bool noxattr;
 	wait_queue_head_t copyup_wq;
 	/* sb common to all layers */
 	struct super_block *same_sb;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9828b7d..d4cc189 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -891,6 +891,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 				dput(temp);
 			else
 				pr_warn("overlayfs: upper fs does not support tmpfile.\n");
+
+			/* Check if upper/work fs supports trusted xattr */
+			err = ovl_check_setxattr(ufs, ufs->workdir,
+						 OVL_XATTR_OPAQUE, "y", 1, 1);
+			if (err)
+				pr_warn("overlayfs: upper fs does not support xattr.\n");
 		}
 	}
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6c3a7aa..ce37cf4 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -201,6 +201,13 @@ void ovl_dentry_set_impure(struct dentry *dentry)
 	oe->impure = true;
 }
 
+bool ovl_noxattr(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->noxattr;
+}
+
 bool ovl_redirect_dir(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
-- 
2.7.4
