From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 30/39] Revert "ovl: fix may_write_real() for overlayfs directories"
Date: Tue, 29 May 2018 16:43:30 +0200
Message-ID: <20180529144339.16538-31-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This reverts commit 954c736f865d6c0c68ae4263a2f3502ee7c447a3.

Overlayfs no longer relies on the vfs for checking writability of files.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/namespace.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5f75969adff1..c3f7152a8419 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -468,9 +468,7 @@ static inline int may_write_real(struct file *file)
 
 	/* File refers to upper, writable layer? */
 	upperdentry = d_real(dentry, NULL, 0, D_REAL_UPPER);
-	if (upperdentry &&
-	    (file_inode(file) == d_inode(upperdentry) ||
-	     file_inode(file) == d_inode(dentry)))
+	if (upperdentry && file_inode(file) == d_inode(upperdentry))
 		return 0;
 
 	/* Lower layer: can't write to real file, sorry... */
-- 
2.14.3
