From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v10 11/18] ovl: Set OVL_UPPERDATA flag during ovl_lookup()
Date: Mon, 22 Jan 2018 13:39:57 -0500
Message-ID: <20180122184004.26026-12-vgoyal@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1670 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751174AbeAVSkO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:40:14 -0500
In-Reply-To: <20180122184004.26026-1-vgoyal@redhat.com>
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
 fs/overlayfs/namei.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 5b834abde37a..d4ad9408749f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -25,6 +25,59 @@ struct ovl_lookup_data {
 	char *redirect;
 };
 
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
+/* err < 0, 0 if upper does not have metacopy, 1 if metacopy found */
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
+		 * Found a dentry with metacopy set but at the same time
+		 * there is no corresponding lower data dentry. Something is
+		 * not right.
+		 */
+		return -ESTALE;
+	}
+
+	if (!ofs->config.metacopy) {
+		/*
+		 * Do not follow metacopy origin if metacopy feature is not
+		 * enabled. This can be a security issue (Like redirect).
+		 */
+		pr_warn_ratelimited("overlay: refusing to follow metacopy origin for (%pd2)\n", dentry);
+		return -EPERM;
+	}
+
+	return metacopy;
+}
+
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 			      size_t prelen, const char *post)
 {
@@ -624,6 +677,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	bool metacopy = false;
 	bool origin_chain = ofs->config.metacopy ? true : false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
@@ -666,6 +720,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 					       origin_chain);
 			if (err)
 				goto out_put_upper;
+
+			err = ovl_check_metacopy(ofs, upperdentry, ctr);
+			metacopy = err;
+			if (err < 0)
+				goto out_put_upper;
 		}
 
 		if (d.redirect) {
@@ -766,6 +825,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
