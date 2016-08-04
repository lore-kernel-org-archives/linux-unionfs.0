From: Derek McGowan <dmcg@drizz.net>
Subject: [PATCH] ovl: fix copy up opaque directory
Date: Thu,  4 Aug 2016 12:04:37 -0700
Message-ID: <1470337477-7297-1-git-send-email-dmcg@drizz.net>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35857 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692AbcHDTFD (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 4 Aug 2016 15:05:03 -0400
Received: by mail-pf0-f193.google.com with SMTP id y134so18719291pfg.3
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Aug 2016 12:05:01 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Derek McGowan <dmcg@drizz.net>

When a copy up of a directory occurs which has the opaque xattr set, the
xattr remains in the upper directory. The immediate behavior with overlayfs
is that the upper directory is not treated as opaque, however after a
remount the opaque flag is used and upper directory is treated as opaque.
This causes files created in the lower layer to be hidden when using
multiple lower directories. This change fixes the behavior to remove the
opaque flag when an opaque directory is copied up.

Script to reproduce and verify
#!/bin/sh
cd $(mktemp -d)
mkdir -p lower1/lib
touch lower1/lib/hidden
mkdir -p lower2/lib
touch lower2/lib/not-hidden
setfattr -n trusted.overlay.opaque -v y lower2/lib
mkdir upper
mkdir work
mkdir merged
mount -t overlay overlay -o lowerdir=lower2:lower1,upperdir=upper,workdir=work merged
ls merged/lib # shows only "not-hidden"
touch merged/lib/newfile
ls merged/lib # shows both "not-hidden" and "newfile"
getfattr -n trusted.overlay.opaque upper/lib # should not be set
umount merged
mount -t overlay overlay -o lowerdir=lower2:lower1,upperdir=upper,workdir=work merged
ls merged/lib # should show not-hidden" and "newfile"
umount merged

Signed-off-by: Derek McGowan <dmcg@drizz.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=151291
---
 fs/overlayfs/copy_up.c   | 3 +++
 fs/overlayfs/dir.c       | 2 +-
 fs/overlayfs/overlayfs.h | 4 ++++
 fs/overlayfs/super.c     | 2 +-
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index cc514da..1baab7b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -281,6 +281,9 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out_cleanup;
 
+	if (ovl_is_opaquedir(newdentry))
+		ovl_remove_opaque(newdentry);
+
 	inode_lock(newdentry->d_inode);
 	err = ovl_set_attr(newdentry, stat);
 	inode_unlock(newdentry->d_inode);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index b3fc0a3..02b20ad 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -121,7 +121,7 @@ static int ovl_set_opaque(struct dentry *upperdentry)
 	return ovl_do_setxattr(upperdentry, OVL_XATTR_OPAQUE, "y", 1, 0);
 }
 
-static void ovl_remove_opaque(struct dentry *upperdentry)
+void ovl_remove_opaque(struct dentry *upperdentry)
 {
 	int err;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6a7090f..6e53acb 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -194,6 +194,7 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct kstat *stat, const char *link,
 		    struct dentry *hardlink, bool debug);
 void ovl_cleanup(struct inode *dir, struct dentry *dentry);
+void ovl_remove_opaque(struct dentry *upperdentry);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
@@ -201,3 +202,6 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		    struct path *lowerpath, struct kstat *stat);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
+
+/* super.c */
+bool ovl_is_opaquedir(struct dentry *dentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 791235e..1f3d907 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -265,7 +265,7 @@ bool ovl_is_whiteout(struct dentry *dentry)
 	return inode && IS_WHITEOUT(inode);
 }
 
-static bool ovl_is_opaquedir(struct dentry *dentry)
+bool ovl_is_opaquedir(struct dentry *dentry)
 {
 	int res;
 	char val;
-- 
2.5.5
