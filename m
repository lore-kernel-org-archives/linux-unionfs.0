From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH] ovl: remove unused macro
Date: Tue, 21 Jan 2020 18:25:41 +0800
Message-ID: <1579602341-57131-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

OVL_NLINK_ADD_UPPER macro is never used from it was introduced. Better
to remove it.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu> 
Cc: linux-unionfs@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 fs/overlayfs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b045cf1826fc..7138561f955a 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -627,8 +627,6 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev,
  * upper inode where the nlink xattr can be stored before the copied up upper
  * entry is unlink.
  */
-#define OVL_NLINK_ADD_UPPER	(1 << 0)
-
 /*
  * On-disk format for indexed nlink:
  *
-- 
1.8.3.1
