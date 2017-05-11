From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ovl: select EXPORTFS
Date: Thu, 11 May 2017 13:34:29 +0200
Message-ID: <20170511113437.2564112-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

We get a link error when EXPORTFS is not enabled:

ERROR: "exportfs_encode_fh" [fs/overlayfs/overlay.ko] undefined!
ERROR: "exportfs_decode_fh" [fs/overlayfs/overlay.ko] undefined!

This adds a Kconfig 'select' statement for overlayfs, the same way that
it is done for the other users of exportfs.

Fixes: 3a1e819b4e80 ("ovl: store file handle of lower inode on copy up")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/overlayfs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 0daac5112f7a..c0c9683934b7 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -1,5 +1,6 @@
 config OVERLAY_FS
 	tristate "Overlay filesystem support"
+	select EXPORTFS
 	help
 	  An overlay filesystem combines two filesystems - an 'upper' filesystem
 	  and a 'lower' filesystem.  When a name exists in both filesystems, the
-- 
2.9.0
