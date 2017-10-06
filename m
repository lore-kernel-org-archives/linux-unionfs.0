From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 6/8] ovl: Set OVL_METACOPY flag during ovl_lookup()
Date: Fri,  6 Oct 2017 13:47:15 -0400
Message-ID: <1507312037-30909-7-git-send-email-vgoyal@redhat.com>
References: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42488 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752451AbdJFRrY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:47:24 -0400
In-Reply-To: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

During lookup, check for presence of OVL_XATTR_METACOPY and if present,
set OVL_METACOPY bit in flags.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c3addd1114f1..f139596b13f0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -26,6 +26,24 @@ struct ovl_lookup_data {
 	char *redirect;
 };
 
+/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
+static int ovl_check_metacopy(struct dentry *dentry)
+{
+	int res;
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
@@ -591,6 +609,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	bool metacopy = false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
 		.is_dir = false,
@@ -631,6 +650,12 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 					       roe->numlower, &stack, &ctr);
 			if (err)
 				goto out;
+
+			err = ovl_check_metacopy(upperdentry);
+			if (err < 0)
+				goto out;
+			if (err == 1)
+				metacopy = true;
 		}
 
 		if (d.redirect) {
@@ -716,6 +741,19 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		OVL_I(inode)->redirect = upperredirect;
 		if (index)
 			ovl_set_flag(OVL_INDEX, inode);
+
+		if (metacopy) {
+			/*
+			 * Found an upper with metacopy set but at the same
+			 * time there is no lower dentry. Something is not
+			 * right.
+			 */
+			if (!ctr) {
+				err = -ESTALE;
+				goto out_free_oe;
+			}
+			ovl_set_flag(OVL_METACOPY, inode);
+		}
 	}
 
 	revert_creds(old_cred);
-- 
2.13.5
