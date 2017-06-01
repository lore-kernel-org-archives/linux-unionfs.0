From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 5/5] ovl: document the 'verify_lower' feature
Date: Thu,  1 Jun 2017 20:01:54 +0300
Message-ID: <1496336514-11000-6-git-send-email-amir73il@gmail.com>
References: <1496336514-11000-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35128 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbdFARBs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 13:01:48 -0400
In-Reply-To: <1496336514-11000-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

The 'verify_lower' feature provides the following:
1. Verify on mount that upper root origin matches lower root
2. Verify on lookup that upper dir origin matches lower dir

The feature is needed for upcoming overlayfs features:
- Prevent breaking hardlinks on copy up
- NFS export support
- Overlayfs snapshots

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt | 48 +++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index c9e884b52698..e82c4fb4871d 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -201,6 +201,40 @@ rightmost one and going left.  In the above example lower1 will be the
 top, lower2 the middle and lower3 the bottom layer.
 
 
+Sharing and copying layers
+--------------------------
+
+Lower layers may be shared among several overlay mounts and that is indeed
+a very common practice.  An overlay mounts may use the same lower layer
+path as another overlay mount and it may use a lower layer path that is
+beneath or above the path of another overlay lower layer path.
+
+Using an upper layer path and/or a workdir path that are already used by
+another overlay mount is not allowed and will fail with EBUSY.  Using
+partially overlapping paths is not allowed but will not fail with EBUSY.
+
+Mounting an overlay using an upper layer path, where the upper layer path
+was previously used by another mounted overlay in combination with a
+different lower layer path, is allowed, unless the "verify_lower" mount
+option is used.
+
+With the "verify_lower" feature, on the first time mount, an NFS file
+handle of the lower layer root directory, along with the UUID of the lower
+filesystem, are encoded and stored in the "trusted.overlay.origin" extended
+attribute on the upper layer root directory.  On subsequent mount attempts,
+the lower root directory file handle and lower filesystem UUID are compared
+to the stored origin in upper root directory.  On failure to verify the
+lower root origin, mount will fail with ESTALE.  A "verify_lower" mount
+will fail with EOPNOTSUPP if the lower filesystem does not support NFS
+export, lower filesystem does not have a valid UUID or if the upper
+filesystem does not support extended attributes.
+
+It is quite a common practice to copy overlay layers to a different
+directory tree on the same or different underlying filesystem, and even
+to a different machine.  With the "verify_lower" feature, trying to mount
+the copied layers will fail the verification of the lower root file handle.
+
+
 Non-standard behavior
 ---------------------
 
@@ -228,6 +262,20 @@ filesystem are not allowed.  If the underlying filesystem is changed,
 the behavior of the overlay is undefined, though it will not result in
 a crash or deadlock.
 
+When the lower filesystem supports NFS export, overlay mount can be made
+more resilient to offline and online changes of the underlying lower layer.
+On every copy_up, an NFS file handle of the lower inode, along with the
+UUID of the lower filesystem, are encoded and stored in an extended
+attribute "trusted.overlay.origin" on the upper inode.
+
+With the "verify_lower" feature, a lookup of a merged directory, that found
+a lower directory at the lookup path or at the path pointed to by the
+"trusted.overlay.redirect" extended attribute, will verify that the found
+lower directory file handle and lower filesystem UUID match the origin
+that was stored at copy_up time.  If a found lower directory does not match
+the stored origin, that directory will be not be merged with the upper
+directory.
+
 Testsuite
 ---------
 
-- 
2.7.4
