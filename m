From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH] vfs: rename: check backing inode being equal
Date: Tue, 22 Mar 2016 14:17:42 +0100
Message-ID: <20160322131742.GC11906@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33453 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663AbcCVNQY (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 22 Mar 2016 09:16:24 -0400
Received: by mail-wm0-f41.google.com with SMTP id l68so192218271wml.0
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Mar 2016 06:16:23 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

If a file is renamed to a hardlink of itself POSIX specifies that rename(2)
should do nothing and return success.

This condition is checked in vfs_rename().  However it won't detect hard
links on overlayfs where these are given separate inodes on the overlayfs
layer.

Overlayfs itself detects this condition and returns success without doing
anything, but then vfs_rename() will proceed as if this was a successful
rename (detach_mounts(), d_move()).

The correct thing to do is to detect this condition before even calling
into overlayfs.  This patch does this by checking for
DCACHE_OP_SELECT_INODE and getting the underlying inode in that case.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: <stable@vger.kernel.org> # v4.2+
---
 fs/namei.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4150,6 +4150,17 @@ SYSCALL_DEFINE2(link, const char __user
 	return sys_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
+static struct inode *backing_inode(struct dentry *dentry)
+{
+	struct inode *inode = d_inode(dentry);
+
+	if (inode && dentry->d_flags & DCACHE_OP_SELECT_INODE) {
+		inode = dentry->d_op->d_select_inode(dentry, 0);
+		WARN_ON(IS_ERR(inode));
+	}
+	return inode;
+}
+
 /**
  * vfs_rename - rename a filesystem object
  * @old_dir:	parent of source
@@ -4211,7 +4222,7 @@ int vfs_rename(struct inode *old_dir, st
 	bool new_is_dir = false;
 	unsigned max_links = new_dir->i_sb->s_max_links;
 
-	if (source == target)
+	if (backing_inode(old_dentry) == backing_inode(new_dentry))
 		return 0;
 
 	error = may_delete(old_dir, old_dentry, is_dir);
