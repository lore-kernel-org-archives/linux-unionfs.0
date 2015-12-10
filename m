From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] overlayfs: include linux/pagemap.h for PAGE_CACHE_SIZE
Date: Thu, 10 Dec 2015 16:10:18 +0100
Message-ID: <7380785.3TF39KbbER@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-unionfs@vger.kernel.org

The overlayfs has started enforcing a maximum file size, but is missing
the header file that defines the PAGE_CACHE_SIZE constant in some
configurations.

fs/overlayfs/super.c: In function 'ovl_fill_super':
fs/overlayfs/super.c:939:29: error: 'PAGE_CACHE_SIZE' undeclared (first use in this function)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 7b1746cac878 ("ovl: setattr: check permissions before copy-up")
Cc: <stable@vger.kernel.org>
---
The patch that introduced this was marked for stable, so I'm marking this
the same way.

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ea94e50a3473..a4cbdf9824c7 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -9,6 +9,7 @@
 
 #include <linux/fs.h>
 #include <linux/namei.h>
+#include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
 #include <linux/mount.h>
