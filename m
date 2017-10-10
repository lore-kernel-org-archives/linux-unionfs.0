From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 8/9] ovl: Set OVL_METACOPY flag during ovl_lookup()
Date: Tue, 10 Oct 2017 11:32:23 -0400
Message-ID: <1507649544-4539-9-git-send-email-vgoyal@redhat.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932293AbdJJPcj (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2017 11:32:39 -0400
In-Reply-To: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com, ebiederm@xmission.com

During lookup, check for presence of OVL_XATTR_METACOPY and if present,
set OVL_METACOPY bit in flags.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 654bea1a5ac9..85328e1088d8 100644
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
@@ -592,6 +610,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	bool metacopy = false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
 		.is_dir = false,
@@ -632,6 +651,12 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
@@ -717,6 +742,19 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
+				goto out_put_inode;
+			}
+			ovl_set_flag(OVL_METACOPY, inode);
+		}
 	}
 
 	revert_creds(old_cred);
@@ -727,6 +765,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	return NULL;
 
+out_put_inode:
+	iput(inode);
 out_free_oe:
 	dentry->d_fsdata = NULL;
 	kfree(oe);
-- 
2.13.5
