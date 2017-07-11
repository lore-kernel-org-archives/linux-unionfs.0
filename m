From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 09/10] ovl: verify origin of merge dir lower
Date: Tue, 11 Jul 2017 15:58:42 +0300
Message-ID: <1499777923-29410-10-git-send-email-amir73il@gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35349 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932158AbdGKM6p (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 08:58:45 -0400
Received: by mail-wr0-f193.google.com with SMTP id z45so32273568wrb.2
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2017 05:58:45 -0700 (PDT)
In-Reply-To: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When inodes index feature is enabled, verify that lower merge dir found
by name matches the origin file handle stored in xattr on upper dir.
If origin xattr does not exist, update it with the lower found by name.

If lower dir does not match the origin fh stored in upper dir, do not
merge the lower dir and treat upper dir as pure upper.  This behavior
is not friendy to the use case of copied overlay layers, where origin
file handles are broken, but trying to mount an overlay with inodes
index enabled is going to fail anyway for copied layers.

Setting the origin xattr on the upper merge dir also serves as an
indication that this dir may contain whiteouts, which is going to be
used to prevent exposing whiteouts to readdir() in case lower dir was
removed while overlay was offline.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt | 16 ++++++++++++++++
 fs/overlayfs/namei.c                    | 10 ++++++++++
 2 files changed, 26 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 36f528a7fdd6..9b9e8efc3977 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -262,6 +262,22 @@ filesystem are not allowed.  If the underlying filesystem is changed,
 the behavior of the overlay is undefined, though it will not result in
 a crash or deadlock.
 
+When the underlying filesystems supports NFS export, overlay mount can be
+made more resilient to offline and online changes of the underlying lower
+layer by enabling the "inodes index" feature.
+
+On every copy_up, an NFS file handle of the lower inode, along with the
+UUID of the lower filesystem, are encoded and stored in an extended
+attribute "trusted.overlay.origin" on the upper inode.
+
+With the "inodes index" feature, a lookup of a merged directory, that
+found a lower directory at the lookup path or at the path pointed to by
+the "trusted.overlay.redirect" extended attribute, will verify that the
+found lower directory file handle and lower filesystem UUID match the
+origin file handle that was stored at copy_up time.  If a found lower
+directory does not match the stored origin, that directory will be not be
+merged with the upper directory.
+
 Testsuite
 ---------
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 86f09230a3db..ec81d27b12be 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -648,6 +648,16 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (!this)
 			continue;
 
+		/* Verify that uppermost lower matches the copy up origin fh */
+		if (this && upperdentry && !ctr && ovl_indexdir(dentry->d_sb)) {
+			err = ovl_verify_origin(upperdentry, lowerpath.mnt,
+						this, false, true);
+			if (err) {
+				dput(this);
+				break;
+			}
+		}
+
 		stack[ctr].dentry = this;
 		stack[ctr].mnt = lowerpath.mnt;
 		ctr++;
-- 
2.7.4
