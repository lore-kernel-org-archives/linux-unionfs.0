From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] ovl: Select EXPORTFS for exportfs_{en,de}code_fh
Date: Fri, 12 May 2017 19:17:57 -0700
Message-ID: <20170513021757.2356-1-f.fainelli@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36556 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdEMCSC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 May 2017 22:18:02 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: amir73il@gmail.com, Florian Fainelli <f.fainelli@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>

fs/overlayfs/namei.c now calls exportfs_decode_fh() and
fs/overlayfs/copy_up.c calls exportfs_encode_fh() but misses an EXPORTFS
select which results in the following build error:

fs/built-in.o: In function `ovl_get_origin':
/home/florian/dev/linux/fs/overlayfs/namei.c:141: undefined reference to
`exportfs_decode_fh'
fs/built-in.o: In function `ovl_encode_fh':
/home/florian/dev/linux/fs/overlayfs/copy_up.c:253: undefined reference
to `exportfs_encode_fh'
Makefile:997: recipe for target 'vmlinux' failed

Fixes: a9d019573e88 ("ovl: lookup non-dir copy-up-origin by file handle")
Fixes: 3a1e819b4e80 ("ovl: store file handle of lower inode on copy up")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
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
2.11.0
