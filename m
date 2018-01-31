From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v11 10/18] ovl: Set OVL_UPPERDATA flag during ovl_lookup()
Date: Wed, 31 Jan 2018 16:13:21 -0500
Message-ID: <20180131211329.16328-11-vgoyal@redhat.com>
References: <20180131211329.16328-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751759AbeAaVNn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 16:13:43 -0500
In-Reply-To: <20180131211329.16328-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
set OVL_UPPERDATA bit in flags.

OVL_UPPERDATA flag is set unconditionally if upper inode exists.

Do not follow metacopy origin if we find a metacopy only inode and metacopy
feature is not enabled for that mount. Like redirect, this can have security
implications where an attacker could hand craft upper and try to gain
access to file on lower which it should not have to begin with.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index beb945e1963c..27a069cd2bf4 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -182,6 +182,60 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	goto out;
 }
 
+/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
+static int ovl_check_metacopy_xattr(struct dentry *dentry)
+{
+	int res;
+
+	/* Only regular files can have metacopy xattr */
+	if (!S_ISREG(d_inode(dentry)->i_mode))
+		return 0;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_METACOPY, NULL, 0);
+	if (res < 0) {
+		if (res == -ENODATA || res == -EOPNOTSUPP)
+			return 0;
+		goto out;
+	}
+
+	return 1;
+out:
+	pr_warn_ratelimited("overlayfs: failed to get metacopy (%i)\n", res);
+	return res;
+}
+
+static int ovl_check_metacopy(struct ovl_fs *ofs, struct dentry *dentry,
+			      unsigned int ctr)
+{
+	int metacopy;
+
+	metacopy = ovl_check_metacopy_xattr(dentry);
+	if (metacopy <= 0 )
+		return metacopy;
+
+	if (!ctr) {
+		/*
+		 * Found a upper dentry with metacopy set but at the same
+		 * time there is no corresponding origin dentry. Something
+		 * is not right.
+		 */
+		return -ESTALE;
+	}
+
+	if (!ofs->config.metacopy) {
+		/*
+		 * Do not follow metacopy origin if metacopy feature
+		 * is not enabled. This can be a security issue (Like
+		 * redirect).
+		 */
+		pr_warn_ratelimited("overlay: refusing to follow metacopy"
+				    " origin for (%pd2)\n", dentry);
+		return -EPERM;
+	}
+
+	return metacopy;
+}
+
 static bool ovl_is_opaquedir(struct dentry *dentry)
 {
 	return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
@@ -602,6 +656,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	bool metacopy = false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
 		.is_dir = false,
@@ -642,6 +697,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 					       roe->numlower, &stack, &ctr);
 			if (err)
 				goto out_put_upper;
+
+			err = ovl_check_metacopy(ofs, upperdentry, ctr);
+			metacopy = err;
+			if (err < 0)
+				goto out_put_upper;
 		}
 
 		if (d.redirect) {
@@ -742,6 +802,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		OVL_I(inode)->redirect = upperredirect;
 		if (index)
 			ovl_set_flag(OVL_INDEX, inode);
+
+		if (upperdentry && !metacopy)
+			ovl_set_flag(OVL_UPPERDATA, inode);
 	}
 
 	revert_creds(old_cred);
-- 
2.13.6
