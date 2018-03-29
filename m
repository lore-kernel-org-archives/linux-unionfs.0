Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v9 7/7] ovl: update documentation w.r.t "xino" feature
Date: Thu, 29 Mar 2018 17:18:53 +0300
Message-Id: <1522333133-24772-8-git-send-email-amir73il@gmail.com>
In-Reply-To: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt | 39 ++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 6ea1e64d1464..0cd4eab24899 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -14,9 +14,13 @@ The result will inevitably fail to look exactly like a normal
 filesystem for various technical reasons.  The expectation is that
 many use cases will be able to ignore these differences.
 
-This approach is 'hybrid' because the objects that appear in the
-filesystem do not all appear to belong to that filesystem.  In many
-cases an object accessed in the union will be indistinguishable
+
+Overlay objects
+---------------
+
+The overlay filesystem approach is 'hybrid', because the objects that
+appear in the filesystem do not always appear to belong to that filesystem.
+In many cases, an object accessed in the union will be indistinguishable
 from accessing the corresponding object from the original filesystem.
 This is most obvious from the 'st_dev' field returned by stat(2).
 
@@ -34,6 +38,19 @@ make the overlay mount more compliant with filesystem scanners and
 overlay objects will be distinguishable from the corresponding
 objects in the original filesystem.
 
+On 64bit systems, even if all overlay layers are not on the same
+underlying filesystem, the same compliant behavior could be achieved
+with the "xino" feature.  The "xino" feature composes a unique object
+identifier from the real object st_ino and an underlying fsid index.
+If all underlying filesystems support NFS file handles and export file
+handles with 32bit inode number encoding (e.g. ext4), overlay filesystem
+will use the high inode number bits for fsid.  Even when the underlying
+filesystem uses 64bit inode numbers, users can still enable the "xino"
+feature with the "-o xino" overlay mount option.  That is useful for the
+case of underlying filesystems like xfs and tmpfs, which use 64bit inode
+numbers, but are very unlikely to use the high inode number bit.
+
+
 Upper and Lower
 ---------------
 
@@ -290,10 +307,19 @@ Non-standard behavior
 ---------------------
 
 The copy_up operation essentially creates a new, identical file and
-moves it over to the old name.  The new file may be on a different
-filesystem, so both st_dev and st_ino of the file may change.
+moves it over to the old name.  Any open files referring to this inode
+will access the old data.
+
+The new file may be on a different filesystem, so both st_dev and st_ino
+of the real file may change.  The values of st_dev and st_ino returned by
+stat(2) on an overlay object are often not the same as the real file
+stat(2) values to prevent the values from changing on copy_up.
 
-Any open files referring to this inode will access the old data.
+Unless "xino" feature is enabled, when overlay layers are not all on the
+same underlying filesystem, the value of st_dev may be different for two
+non-directory objects in the same overlay filesystem and the value of
+st_ino for directory objects may be non persistent and could change even
+while the overlay filesystem is still mounted.
 
 Unless "inode index" feature is enabled, if a file with multiple hard
 links is copied up, then this will "break" the link.  Changes will not be
@@ -302,6 +328,7 @@ propagated to other names referring to the same inode.
 Unless "redirect_dir" feature is enabled, rename(2) on a lower or merged
 directory will fail with EXDEV.
 
+
 Changes to underlying filesystems
 ---------------------------------
 
-- 
2.7.4
