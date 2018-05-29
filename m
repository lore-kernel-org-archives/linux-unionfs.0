From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 20/28] ovl: Add an inode flag OVL_CONST_INO
Date: Tue, 29 May 2018 16:46:04 +0200
Message-ID: <20180529144612.16675-21-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Add an ovl_inode flag OVL_CONST_INO.  This flag signifies if inode number
will remain constant over copy up or not.  This flag does not get updated
over copy up and remains unmodifed after setting once.

Next patch in the series will make use of this flag.  It will basically
figure out if dentry is of type ORIGIN or not.  And this can be derived by
this flag.

ORIGIN = (upperdentry && ovl_test_flag(OVL_CONST_INO, inode)).

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c     | 3 +++
 fs/overlayfs/overlayfs.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index d4e643e9098b..ac1d2a581a6e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -883,6 +883,9 @@ struct inode *ovl_get_inode(struct super_block *sb,
 
 	OVL_I(inode)->redirect = oip->redirect;
 
+	if (bylower)
+		ovl_set_flag(OVL_CONST_INO, inode);
+
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
 		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index dcd600201ec8..bde352e414e7 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -38,6 +38,8 @@ enum ovl_inode_flag {
 	OVL_WHITEOUTS,
 	OVL_INDEX,
 	OVL_UPPERDATA,
+	/* Inode number will remain constant over copy up. */
+	OVL_CONST_INO,
 };
 
 enum ovl_entry_flag {
-- 
2.14.3
