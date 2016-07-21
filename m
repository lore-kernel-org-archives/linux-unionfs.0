From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH v2 3/3] vfs: do get_write_access() on upper layer of overlayfs
Date: Thu, 21 Jul 2016 15:53:36 +0200
Message-ID: <1469109216-24353-4-git-send-email-mszeredi@redhat.com>
References: <1469109216-24353-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38760 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbcGUNxo (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 21 Jul 2016 09:53:44 -0400
Received: by mail-wm0-f50.google.com with SMTP id o80so26289723wme.1
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Jul 2016 06:53:43 -0700 (PDT)
In-Reply-To: <1469109216-24353-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

The problem with writecount is: we want consistent handling of it for
underlying filesystems as well as overlayfs.  Making sure i_writecount is
correct on all layers is difficult.  Instead this patch makes sure that
when write access is acquired, it's always done on the underlying writable
layer (called the upper layer).  We must also make sure to look at the
writecount on this layer when checking for conflicting leases.

Open for write already updates the upper layer's writecount.  Leaving only
truncate.

For truncate copy up must happen before get_write_access() so that the
writecount is updated on the upper layer.  Problem with this is if
something fails after that, then copy-up was done needlessly.  E.g. if
break_lease() was interrupted.  Probably not a big deal in practice.

Another interesting case is if there's a denywrite on a lower file that is
then opened for write or truncated.  With this patch these will succeed,
which is somewhat counterintuitive.  But I think it's still acceptable,
considering that the copy-up does actually create a different file, so the
old, denywrite mapping won't be touched.

On non-overlayfs d_real() is an identity function and d_real_inode() is
equivalent to d_inode() so this patch doesn't change behavior in that case.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/locks.c |  3 ++-
 fs/open.c  | 15 +++++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index c1656cff53ee..b242d5b99589 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1618,7 +1618,8 @@ check_conflicting_open(const struct dentry *dentry, const long arg, int flags)
 	if (flags & FL_LAYOUT)
 		return 0;
 
-	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
+	if ((arg == F_RDLCK) &&
+	    (atomic_read(&d_real_inode(dentry)->i_writecount) > 0))
 		return -EAGAIN;
 
 	if ((arg == F_WRLCK) && ((d_count(dentry) > 1) ||
diff --git a/fs/open.c b/fs/open.c
index 451fed14a843..76d8d97b5136 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -68,6 +68,7 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 long vfs_truncate(const struct path *path, loff_t length)
 {
 	struct inode *inode;
+	struct dentry *upperdentry;
 	long error;
 
 	inode = path->dentry->d_inode;
@@ -90,7 +91,17 @@ long vfs_truncate(const struct path *path, loff_t length)
 	if (IS_APPEND(inode))
 		goto mnt_drop_write_and_out;
 
-	error = get_write_access(inode);
+	/*
+	 * If this is an overlayfs then do as if opening the file so we get
+	 * write access on the upper inode, not on the overlay inode.  For
+	 * non-overlay filesystems d_real() is an identity function.
+	 */
+	upperdentry = d_real(path->dentry, NULL, O_WRONLY);
+	error = PTR_ERR(upperdentry);
+	if (IS_ERR(upperdentry))
+		goto mnt_drop_write_and_out;
+
+	error = get_write_access(upperdentry->d_inode);
 	if (error)
 		goto mnt_drop_write_and_out;
 
@@ -109,7 +120,7 @@ long vfs_truncate(const struct path *path, loff_t length)
 		error = do_truncate(path->dentry, length, 0, NULL);
 
 put_write_and_out:
-	put_write_access(inode);
+	put_write_access(upperdentry->d_inode);
 mnt_drop_write_and_out:
 	mnt_drop_write(path->mnt);
 out:
-- 
2.5.5
