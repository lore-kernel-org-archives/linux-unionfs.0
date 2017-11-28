From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v8 12/15] ovl: Set OVL_UPPERDATA flag during ovl_lookup()
Date: Tue, 28 Nov 2017 10:59:56 -0500
Message-ID: <20171128155959.20114-13-vgoyal@redhat.com>
References: <20171128155959.20114-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753166AbdK1QAM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:00:12 -0500
In-Reply-To: <20171128155959.20114-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
set OVL_UPPERDATA bit in flags.

OVL_UPPERDATA flag is set unconditionally if upper inode exists.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a11d77361bef..11340262df6e 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -25,6 +25,28 @@ struct ovl_lookup_data {
 	char *redirect;
 };
 
+/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
+static int ovl_check_metacopy(struct dentry *dentry)
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
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 			      size_t prelen, const char *post)
 {
@@ -602,6 +624,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	bool metacopy = false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
 		.is_dir = false,
@@ -642,6 +665,20 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 					       roe->numlower, &stack, &ctr);
 			if (err)
 				goto out_put_upper;
+
+			err = ovl_check_metacopy(upperdentry);
+			metacopy = err;
+			if (err < 0)
+				goto out_put_upper;
+			if (metacopy && !ctr) {
+				/*
+				 * Found an upper with metacopy set but
+				 * at the same time there is no lower
+				 * dentry. Something is not right.
+				 */
+				err = -ESTALE;
+				goto out_put_upper;
+			}
 		}
 
 		if (d.redirect) {
@@ -726,6 +763,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
