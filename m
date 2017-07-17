From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [4.13-rc1 regression] copyup crashes kernel when initializing
 selinux
Date: Mon, 17 Jul 2017 13:25:03 +0200
Message-ID: <20170717112503.GB5256@veci.piliscsaba.szeredi.hu>
References: <20170717093741.GP2478@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34755 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdGQLZH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Jul 2017 07:25:07 -0400
Received: by mail-wr0-f196.google.com with SMTP id w4so858604wrb.1
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Jul 2017 04:25:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170717093741.GP2478@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>

On Mon, Jul 17, 2017 at 05:37:41PM +0800, Eryu Guan wrote:
> Hi all,
> 
> I hit a kernel crash with 4.13-rc1 kernel when running fstests
> overlay/005. And git bisect pointed first bad to this commit
> 
> commit 09d8b586731bf589655c2ac971532c14cf272b63
> Author: Miklos Szeredi <mszeredi@redhat.com>
> Date:   Tue Jul 4 22:03:16 2017 +0200
> 
>     ovl: move __upperdentry to ovl_inode
> 
>     Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> 
> inode_doinit_with_dentry wants to read the upper inode's xattr to get
> selinux information, and ovl_xattr_get() calls ovl_dentry_real(), which
> depends on dentry->d_inode, but d_inode is null and not initialized yet
> at this moment.
> 
> Mount overlay without selinux context mount option and trigger copyup
> could reproduce the crash reliably. (The crash log I appended is from a
> bisect run, so the kernel version is not exact 4.13-rc1.)

Could you please test following patch?

Thanks,
Miklos

---
 fs/overlayfs/inode.c     |   32 +++++++++++++++++---------------
 fs/overlayfs/overlayfs.h |    7 ++++---
 fs/overlayfs/super.c     |    8 ++++----
 fs/overlayfs/util.c      |    7 ++++++-
 4 files changed, 31 insertions(+), 23 deletions(-)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -202,37 +202,38 @@ bool ovl_is_private_xattr(const char *na
 		       sizeof(OVL_XATTR_PREFIX) - 1) == 0;
 }
 
-int ovl_xattr_set(struct dentry *dentry, const char *name, const void *value,
-		  size_t size, int flags)
+int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
+		  const void *value, size_t size, int flags)
 {
 	int err;
-	struct path realpath;
-	enum ovl_path_type type = ovl_path_real(dentry, &realpath);
+	struct dentry *upperdentry = ovl_i_dentry_upper(inode);
+	struct dentry *realdentry = upperdentry ?: ovl_dentry_lower(dentry);
 	const struct cred *old_cred;
 
 	err = ovl_want_write(dentry);
 	if (err)
 		goto out;
 
-	if (!value && !OVL_TYPE_UPPER(type)) {
-		err = vfs_getxattr(realpath.dentry, name, NULL, 0);
+	if (!value && !upperdentry) {
+		err = vfs_getxattr(realdentry, name, NULL, 0);
 		if (err < 0)
 			goto out_drop_write;
 	}
 
-	err = ovl_copy_up(dentry);
-	if (err)
-		goto out_drop_write;
+	if (!upperdentry) {
+		err = ovl_copy_up(dentry);
+		if (err)
+			goto out_drop_write;
 
-	if (!OVL_TYPE_UPPER(type))
-		ovl_path_upper(dentry, &realpath);
+		realdentry = ovl_dentry_upper(dentry);
+	}
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	if (value)
-		err = vfs_setxattr(realpath.dentry, name, value, size, flags);
+		err = vfs_setxattr(realdentry, name, value, size, flags);
 	else {
 		WARN_ON(flags != XATTR_REPLACE);
-		err = vfs_removexattr(realpath.dentry, name);
+		err = vfs_removexattr(realdentry, name);
 	}
 	revert_creds(old_cred);
 
@@ -242,12 +243,13 @@ int ovl_xattr_set(struct dentry *dentry,
 	return err;
 }
 
-int ovl_xattr_get(struct dentry *dentry, const char *name,
+int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 		  void *value, size_t size)
 {
-	struct dentry *realdentry = ovl_dentry_real(dentry);
 	ssize_t res;
 	const struct cred *old_cred;
+	struct dentry *realdentry =
+		ovl_i_dentry_upper(inode) ?: ovl_dentry_lower(dentry);
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	res = vfs_getxattr(realdentry, name, value, size);
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -199,6 +199,7 @@ enum ovl_path_type ovl_path_real(struct
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
+struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
 struct inode *ovl_inode_lower(struct inode *inode);
 struct inode *ovl_inode_real(struct inode *inode);
@@ -270,9 +271,9 @@ int ovl_setattr(struct dentry *dentry, s
 int ovl_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int flags);
 int ovl_permission(struct inode *inode, int mask);
-int ovl_xattr_set(struct dentry *dentry, const char *name, const void *value,
-		  size_t size, int flags);
-int ovl_xattr_get(struct dentry *dentry, const char *name,
+int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
+		  const void *value, size_t size, int flags);
+int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 		  void *value, size_t size);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
 struct posix_acl *ovl_get_acl(struct inode *inode, int type);
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -692,7 +692,7 @@ ovl_posix_acl_xattr_get(const struct xat
 			struct dentry *dentry, struct inode *inode,
 			const char *name, void *buffer, size_t size)
 {
-	return ovl_xattr_get(dentry, handler->name, buffer, size);
+	return ovl_xattr_get(dentry, inode, handler->name, buffer, size);
 }
 
 static int __maybe_unused
@@ -742,7 +742,7 @@ ovl_posix_acl_xattr_set(const struct xat
 			return err;
 	}
 
-	err = ovl_xattr_set(dentry, handler->name, value, size, flags);
+	err = ovl_xattr_set(dentry, inode, handler->name, value, size, flags);
 	if (!err)
 		ovl_copyattr(ovl_inode_real(inode), inode);
 
@@ -772,7 +772,7 @@ static int ovl_other_xattr_get(const str
 			       struct dentry *dentry, struct inode *inode,
 			       const char *name, void *buffer, size_t size)
 {
-	return ovl_xattr_get(dentry, name, buffer, size);
+	return ovl_xattr_get(dentry, inode, name, buffer, size);
 }
 
 static int ovl_other_xattr_set(const struct xattr_handler *handler,
@@ -780,7 +780,7 @@ static int ovl_other_xattr_set(const str
 			       const char *name, const void *value,
 			       size_t size, int flags)
 {
-	return ovl_xattr_set(dentry, name, value, size, flags);
+	return ovl_xattr_set(dentry, inode, name, value, size, flags);
 }
 
 static const struct xattr_handler __maybe_unused
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -157,9 +157,14 @@ struct dentry *ovl_dentry_real(struct de
 	return ovl_dentry_upper(dentry) ?: ovl_dentry_lower(dentry);
 }
 
+struct dentry *ovl_i_dentry_upper(struct inode *inode)
+{
+	return ovl_upperdentry_dereference(OVL_I(inode));
+}
+
 struct inode *ovl_inode_upper(struct inode *inode)
 {
-	struct dentry *upperdentry = ovl_upperdentry_dereference(OVL_I(inode));
+	struct dentry *upperdentry = ovl_i_dentry_upper(inode);
 
 	return upperdentry ? d_inode(upperdentry) : NULL;
 }
