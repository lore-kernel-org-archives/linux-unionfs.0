From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 28/39] ovl: fix documentation of non-standard behavior
Date: Tue, 29 May 2018 16:43:28 +0200
Message-ID: <20180529144339.16538-29-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

We can now drop description of the ro/rw inconsistency from the
documentation.

Also clarify, that now fully standard compliant behavior can be enabled
with kernel/module/mount options.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/overlayfs.txt | 60 +++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 72615a2c0752..f087bc40c6a5 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -10,10 +10,6 @@ union-filesystems).  An overlay-filesystem tries to present a
 filesystem which is the result over overlaying one filesystem on top
 of the other.
 
-The result will inevitably fail to look exactly like a normal
-filesystem for various technical reasons.  The expectation is that
-many use cases will be able to ignore these differences.
-
 
 Overlay objects
 ---------------
@@ -306,27 +302,49 @@ the copied layers will fail the verification of the lower root file handle.
 Non-standard behavior
 ---------------------
 
-The copy_up operation essentially creates a new, identical file and
-moves it over to the old name.  Any open files referring to this inode
-will access the old data.
+Overlayfs can now act as a POSIX compliant filesystem with the following
+features turned on:
+
+1) "redirect_dir"
+
+Enabled with the mount option or module option: "redirect_dir=on" or with
+the kernel config option CONFIG_OVERLAY_FS_REDIRECT_DIR=y.
+
+If this feature is disabled, then rename(2) on a lower or merged directory
+will fail with EXDEV ("Invalid cross-device link").
+
+2) "inode index"
+
+Enabled with the mount option or module option "index=on" or with the
+kernel config option CONFIG_OVERLAY_FS_INDEX=y.
+
+If this feature is disabled and a file with multiple hard links is copied
+up, then this will "break" the link.  Changes will not be propagated to
+other names referring to the same inode.
+
+3) "xino"
+
+Enabled with the mount option "xino=auto" or "xino=on", with the module
+option "xino_auto=on" or with the kernel config option
+CONFIG_OVERLAY_FS_XINO_AUTO=y.  Also implicitly enabled by using the same
+underlying filesystem for all layers making up the overlay.
 
-The new file may be on a different filesystem, so both st_dev and st_ino
-of the real file may change.  The values of st_dev and st_ino returned by
-stat(2) on an overlay object are often not the same as the real file
-stat(2) values to prevent the values from changing on copy_up.
+If this feature is disabled or the underlying filesystem doesn't have
+enough free bits in the inode number, then overlayfs will not be able to
+guarantee that the values of st_ino and st_dev returned by stat(2) and the
+value of d_ino returned by readdir(3) will act like on a normal filesystem.
+E.g. the value of st_dev may be different for two objects in the same
+overlay filesystem and the value of st_ino for directory objects may not be
+persistent and could change even while the overlay filesystem is mounted.
 
-Unless "xino" feature is enabled, when overlay layers are not all on the
-same underlying filesystem, the value of st_dev may be different for two
-non-directory objects in the same overlay filesystem and the value of
-st_ino for directory objects may be non persistent and could change even
-while the overlay filesystem is still mounted.
+4) "copy_up_shared"
 
-Unless "inode index" feature is enabled, if a file with multiple hard
-links is copied up, then this will "break" the link.  Changes will not be
-propagated to other names referring to the same inode.
+Enabled with the mount option or module option "copy_up_shared=on" or with
+the kernel config option CONFIG_OVERLAY_FS_COPY_UP_SHARED=y.
 
-Unless "redirect_dir" feature is enabled, rename(2) on a lower or merged
-directory will fail with EXDEV.
+If this feature is disabled, then a memory mapping created with MAP_SHARED
+might contain stale data if the file has been copied up and modified in the
+meantime.
 
 
 Changes to underlying filesystems
-- 
2.14.3
