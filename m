From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 1/4] vfs: update documentation for inode operation locking rules
Date: Sat, 12 Nov 2016 21:36:01 +0200
Message-ID: <1478979364-10355-2-git-send-email-amir73il@gmail.com>
References: <1478979364-10355-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34009 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966793AbcKLTgi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 12 Nov 2016 14:36:38 -0500
In-Reply-To: <1478979364-10355-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

- Remove obsolete truncate operation prototype
- Reorder prototypes mostly by their order in inode_operations struct
- Match locking rules order to prototypes order
- Add missing rule for set_acl operation
- Fix indentation

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/Locking | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 14cdc10..0e35b16 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -42,8 +42,11 @@ d_real		no		no		yes 		no
 
 --------------------------- inode_operations --------------------------- 
 prototypes:
-	int (*create) (struct inode *,struct dentry *,umode_t, bool);
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
+	int (*permission) (struct inode *, int);
+	int (*readlink) (struct dentry *, char __user *,int);
+	const char *(*get_link) (struct dentry *, struct inode *, void **);
+	int (*create) (struct inode *,struct dentry *,umode_t, bool);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
@@ -52,11 +55,6 @@ prototypes:
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *, unsigned int);
-	int (*readlink) (struct dentry *, char __user *,int);
-	const char *(*get_link) (struct dentry *, struct inode *, void **);
-	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int, unsigned int);
-	int (*get_acl)(struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *, struct dentry *, struct kstat *);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
@@ -66,30 +64,33 @@ prototypes:
 				struct file *, unsigned open_flag,
 				umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
+	int (*set_acl) (struct inode *, struct posix_acl *, int);
+	struct posix_acl *(*get_acl)(struct inode *, int);
 
 locking rules:
 	all may block
 		i_mutex(inode)
 lookup:		yes
+permission:	no (may not block if called in rcu-walk mode)
+readlink:	no
+get_link:	no
 create:		yes
 link:		yes (both)
-mknod:		yes
+unlink:		yes (both)
 symlink:	yes
 mkdir:		yes
-unlink:		yes (both)
 rmdir:		yes (both)	(see below)
-rename:	yes (all)	(see below)
-readlink:	no
-get_link:	no
+mknod:		yes
+rename:		yes (all)	(see below)
 setattr:	yes
-permission:	no (may not block if called in rcu-walk mode)
-get_acl:	no
 getattr:	no
 listxattr:	no
 fiemap:		no
 update_time:	no
 atomic_open:	yes
 tmpfile:	no
+set_acl:	yes
+get_acl:	no
 
 
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
-- 
2.7.4
