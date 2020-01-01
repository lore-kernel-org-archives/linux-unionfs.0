Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7/7] ovl: document xino expected behavior
Date: Wed,  1 Jan 2020 19:58:14 +0200
Message-Id: <20200101175814.14144-8-amir73il@gmail.com>
In-Reply-To: <20200101175814.14144-1-amir73il@gmail.com>
References: <20200101175814.14144-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Summarize the inode properties of different configurations in a table.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 38 +++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index e443be7928db..fcd8537b8402 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -40,13 +40,46 @@ On 64bit systems, even if all overlay layers are not on the same
 underlying filesystem, the same compliant behavior could be achieved
 with the "xino" feature.  The "xino" feature composes a unique object
 identifier from the real object st_ino and an underlying fsid index.
+
 If all underlying filesystems support NFS file handles and export file
 handles with 32bit inode number encoding (e.g. ext4), overlay filesystem
 will use the high inode number bits for fsid.  Even when the underlying
 filesystem uses 64bit inode numbers, users can still enable the "xino"
 feature with the "-o xino=on" overlay mount option.  That is useful for the
 case of underlying filesystems like xfs and tmpfs, which use 64bit inode
-numbers, but are very unlikely to use the high inode number bit.
+numbers, but are very unlikely to use the high inode number bits.  In case
+the underlying inode number does overflow into the high xino bits, overlay
+filesystem will fall back to the non xino behavior for that inode.
+
+The following table summarizes what can be expected in different overlay
+configurations.
+
+Inode properties
+````````````````
+
++--------------+------------+------------+-----------------+----------------+
+|Configuration | Persistent | Uniform    | st_ino == d_ino | d_ino == i_ino |
+|              | st_ino     | st_dev     |                 | [*]            |
++==============+=====+======+=====+======+========+========+========+=======+
+|              | dir | !dir | dir | !dir |  dir   +  !dir  |  dir   | !dir  |
++--------------+-----+------+-----+------+--------+--------+--------+-------+
+| All layers   |  Y  |  Y   |  Y  |  Y   |  Y     |   Y    |  Y     |  Y    |
+| on same fs   |     |      |     |      |        |        |        |       |
++--------------+-----+------+-----+------+--------+--------+--------+-------+
+| Layers not   |  N  |  Y   |  Y  |  N   |  N     |   Y    |  N     |  Y    |
+| on same fs,  |     |      |     |      |        |        |        |       |
+| xino=off     |     |      |     |      |        |        |        |       |
++--------------+-----+------+-----+------+--------+--------+--------+-------+
+| xino=on/auto |  Y  |  Y   |  Y  |  Y   |  Y     |   Y    |  Y     |  Y    |
+|              |     |      |     |      |        |        |        |       |
++--------------+-----+------+-----+------+--------+--------+--------+-------+
+| xino=on/auto,|  N  |  Y   |  Y  |  N   |  N     |   Y    |  N     |  Y    |
+| ino overflow |     |      |     |      |        |        |        |       |
++--------------+-----+------+-----+------+--------+--------+--------+-------+
+
+[*] nfsd v3 readdirplus verifies d_ino == i_ino. i_ino is exposed via several
+/proc files, such as /proc/locks and /proc/self/fdinfo/<fd> of an inotify
+file descriptor.
 
 
 Upper and Lower
@@ -383,7 +416,8 @@ guarantee that the values of st_ino and st_dev returned by stat(2) and the
 value of d_ino returned by readdir(3) will act like on a normal filesystem.
 E.g. the value of st_dev may be different for two objects in the same
 overlay filesystem and the value of st_ino for directory objects may not be
-persistent and could change even while the overlay filesystem is mounted.
+persistent and could change even while the overlay filesystem is mounted, as
+summarized in the `Inode properties`_ table above.
 
 
 Changes to underlying filesystems
-- 
2.17.1
