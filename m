From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: [PATCH REGRESSION 4.12-rc1] ovl: add missing CONFIG_EXPORTFS dependency
Date: Tue, 16 May 2017 12:11:39 +0200
Message-ID: <20170516101139.29847-1-ralph.sennhauser@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32888 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbdEPKLw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 06:11:52 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Ralph Sennhauser <ralph.sennhauser@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

The source files namei.c and copy_up.c in overlayfs new use
exportfs_decode_fh which depends on CONFIG_EXPORTFS being set. Select it
in Kconfig.

Fixes: a9d019573e88 ("ovl: lookup non-dir copy-up-origin by file handle")
Fixes: 3a1e819b4e80 ("ovl: store file handle of lower inode on copy up")
Signed-off-by: Ralph Sennhauser <ralph.sennhauser@gmail.com>
---
 fs/overlayfs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 0daac51..c0c9683 100644
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
2.10.2
