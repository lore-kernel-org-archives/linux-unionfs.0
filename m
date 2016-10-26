From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: update S_ISGID when setting posix ACLs
Date: Wed, 26 Oct 2016 20:10:40 +0300
Message-ID: <1477501840-25066-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Since operations on upper are performed using mounter's credentials,
we need to call posix_acl_update_mode() with user credentials on
overlay inode to possibly copy-up and clear setgid bit, before setting
extended attributes on upper inode.

This change fixes xfstest generic/375, which failed to clear the
setgid bit in the following test case over overlayfs:

  touch $testfile
  chown 100:100 $testfile
  chmod 2755 $testfile
  _runas -u 100 -g 101 -- setfacl -m u::rwx,g::rwx,o::rwx $testfile

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 30263a5..16cc844 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -522,6 +522,22 @@ static unsigned int ovl_split_lowerdirs(char *str)
 	return ctr;
 }
 
+static int
+ovl_set_mode(struct dentry *dentry, umode_t mode)
+{
+	struct iattr iattr;
+	int err;
+
+	if (mode == d_inode(dentry)->i_mode)
+		return 0;
+
+	iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
+	iattr.ia_mode = mode;
+	iattr.ia_ctime = current_time(d_inode(dentry));
+
+	return ovl_setattr(dentry, &iattr);
+}
+
 static int __maybe_unused
 ovl_posix_acl_xattr_get(const struct xattr_handler *handler,
 			struct dentry *dentry, struct inode *inode,
@@ -560,6 +576,18 @@ ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
 	if (!inode_owner_or_capable(inode))
 		goto out_acl_release;
 
+	if (handler->flags == ACL_TYPE_ACCESS) {
+		umode_t mode;
+		struct posix_acl *newacl = acl;
+
+		err = posix_acl_update_mode(inode, &mode, &newacl);
+		if (err)
+			goto out_acl_release;
+		err = ovl_set_mode(dentry, mode);
+		if (err)
+			goto out_acl_release;
+	}
+
 	posix_acl_release(acl);
 
 	err = ovl_xattr_set(dentry, handler->name, value, size, flags);
-- 
2.7.4

