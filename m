From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 16/16] ovl: update documentation w.r.t. constant inode numbers
Date: Thu, 27 Apr 2017 00:35:18 +0300
Message-ID: <1493242518-15266-17-git-send-email-amir73il@gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33618 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030837AbdDZVfl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:41 -0400
In-Reply-To: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 634d03e..437e38d 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -21,11 +21,17 @@ from accessing the corresponding object from the original filesystem.
 This is most obvious from the 'st_dev' field returned by stat(2).
 
 While directories will report an st_dev from the overlay-filesystem,
-all non-directory objects will report an st_dev from the lower or
-upper filesystem that is providing the object.  Similarly st_ino will
-only be unique when combined with st_dev, and both of these can change
-over the lifetime of a non-directory object.  Many applications and
-tools ignore these values and will not be affected.
+non-directory objects may report an st_dev from the lower or upper
+filesystem that is providing the object.  Similarly st_ino will only
+be unique when combined with st_dev.  Many applications and tools
+ignore these values and will not be affected.
+
+In the special case of all overlay layers on the same underlying
+filesystem, all objects will report an st_dev from the overlay
+filesystem and st_ino from the underlying filesystem.  This will
+make the overlay mount more comliant with filesystem scanners and
+overlay objects will be distinguishable from the corresponding
+objects from the original filesystem.
 
 Upper and Lower
 ---------------
@@ -198,8 +204,7 @@ Non-standard behavior
 ---------------------
 
 The copy_up operation essentially creates a new, identical file and
-moves it over to the old name.  The new file may be on a different
-filesystem, so both st_dev and st_ino of the file may change.
+moves it over to the old name.
 
 Any open files referring to this inode will access the old data.
 
-- 
2.7.4
