From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL for 4.8] consolidate vfs API for overlayfs
Date: Thu, 30 Jun 2016 00:09:53 +0100
Message-ID: <20160629230952.GE14480@ZenIV.linux.org.uk>
References: <20160628081810.GB2388@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35114 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbcF2XMV (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 29 Jun 2016 19:12:21 -0400
Content-Disposition: inline
In-Reply-To: <20160628081810.GB2388@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Tue, Jun 28, 2016 at 10:18:10AM +0200, Miklos Szeredi wrote:
> Hi Al,
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git d_real
> 
> This consolidates the d_real/d_select_inode API as well as some documentation
> cleanups.

Two notes:

1) you have 4 places with identical "if DCACHE_OP_REAL is there,
call ->d_real(dentry, ..., ...), otherwise return dentry".  And you have
exactly one place where d_real() wrapper is called.  Looks like we would
be better off with the calling conventions for wrapper updated as well.

2) while we can't turn dentry argument into const struct dentry * (due to
ovl_copy_up()), could we at least do that to the inode one?

IOW, how about this, on top of that branch?  Or fold it into the commit
changing the arguments of ->d_real(), for that matter...

Make the signature of d_real() match that of ->d_real() again.

... and constify the inode argument, while we are at it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 2c60d31..4f38062 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -930,7 +930,7 @@ struct dentry_operations {
 	char *(*d_dname)(struct dentry *, char *, int);
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(struct dentry *, bool);
-	struct dentry *(*d_real)(struct dentry *, struct inode *, unsigned int);
+	struct dentry *(*d_real)(struct dentry *, const struct inode *, unsigned int);
 };
 
   d_revalidate: called when the VFS needs to revalidate a dentry. This
diff --git a/fs/open.c b/fs/open.c
index a4c6a71..a7d44d4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -831,15 +831,6 @@ char *file_path(struct file *filp, char *buf, int buflen)
 }
 EXPORT_SYMBOL(file_path);
 
-static struct dentry *open_select_dentry(struct dentry *dentry,
-					 unsigned int open_flags)
-{
-	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
-		return dentry->d_op->d_real(dentry, NULL, open_flags);
-	else
-		return dentry;
-}
-
 /**
  * vfs_open - open the file at the given path
  * @path: path to open
@@ -849,7 +840,7 @@ static struct dentry *open_select_dentry(struct dentry *dentry,
 int vfs_open(const struct path *path, struct file *file,
 	     const struct cred *cred)
 {
-	struct dentry *dentry = open_select_dentry(path->dentry, file->f_flags);
+	struct dentry *dentry = d_real(path->dentry, NULL, file->f_flags);
 
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c76807e..1ccd7f8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -295,7 +295,8 @@ static void ovl_dentry_release(struct dentry *dentry)
 	}
 }
 
-static struct dentry *ovl_d_real(struct dentry *dentry, struct inode *inode,
+static struct dentry *ovl_d_real(struct dentry *dentry,
+				 const struct inode *inode,
 				 unsigned int open_flags)
 {
 	struct dentry *real;
@@ -328,9 +329,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry, struct inode *inode,
 		return real;
 
 	/* Handle recursion */
-	if (real->d_flags & DCACHE_OP_REAL)
-		return real->d_op->d_real(real, inode, open_flags);
-
+	return d_real(real, inode, open_flags);
 bug:
 	WARN(1, "ovl_d_real(%pd4, %s:%lu\n): real dentry not found\n", dentry,
 	     inode ? inode->i_sb->s_id : "NULL", inode ? inode->i_ino : 0);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 241eed6..758509b 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -160,7 +160,7 @@ struct dentry_operations {
 	char *(*d_dname)(struct dentry *, char *, int);
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(struct dentry *, bool);
-	struct dentry *(*d_real)(struct dentry *, struct inode *, unsigned int);
+	struct dentry *(*d_real)(struct dentry *, const struct inode *, unsigned int);
 } ____cacheline_aligned;
 
 /*
@@ -561,10 +561,12 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
  * If dentry is on an union/overlay, then return the underlying, real dentry.
  * Otherwise return the dentry itself.
  */
-static inline struct dentry *d_real(struct dentry *dentry)
+static inline struct dentry *d_real(struct dentry *dentry,
+				    const struct inode *inode,
+				    unsigned int flags)
 {
 	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
-		return dentry->d_op->d_real(dentry, NULL, 0);
+		return dentry->d_op->d_real(dentry, inode, flags);
 	else
 		return dentry;
 }
@@ -578,7 +580,7 @@ static inline struct dentry *d_real(struct dentry *dentry)
  */
 static inline struct inode *d_real_inode(struct dentry *dentry)
 {
-	return d_backing_inode(d_real(dentry));
+	return d_backing_inode(d_real(dentry, NULL, 0));
 }
 
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index befa0fe..f3b1396 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1243,12 +1243,7 @@ static inline struct inode *file_inode(const struct file *f)
 
 static inline struct dentry *file_dentry(const struct file *file)
 {
-	struct dentry *dentry = file->f_path.dentry;
-
-	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
-		return dentry->d_op->d_real(dentry, file_inode(file), 0);
-	else
-		return dentry;
+	return d_real(file->f_path.dentry, file_inode(file), 0);
 }
 
 static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
