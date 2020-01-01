Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/7] ovl: fix out of date comment and unreachable code
Date: Wed,  1 Jan 2020 19:58:09 +0200
Message-Id: <20200101175814.14144-3-amir73il@gmail.com>
In-Reply-To: <20200101175814.14144-1-amir73il@gmail.com>
References: <20200101175814.14144-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

ovl_inode_update() is no longer called from create object code path.

Fixes: 01b39dcc9568 ("ovl: use inode_insert5() to hash a newly...")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 8 +++++---
 fs/overlayfs/util.c  | 2 --
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 9d2fff7d747d..9ed94c70e3cb 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -571,9 +571,11 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev,
 	 * bits to encode layer), set the same value used for st_ino to i_ino,
 	 * so inode number exposed via /proc/locks and a like will be
 	 * consistent with d_ino and st_ino values. An i_ino value inconsistent
-	 * with d_ino also causes nfsd readdirplus to fail.  When called from
-	 * ovl_new_inode(), ino arg is 0, so i_ino will be updated to real
-	 * upper inode i_ino on ovl_inode_init() or ovl_inode_update().
+	 * with d_ino also causes nfsd readdirplus to fail.
+	 *
+	 * When called from ovl_create_object() => ovl_new_inode(), with
+	 * ino = 0, i_ino will be updated to consistent value later on in
+	 * ovl_get_inode() => ovl_fill_inode().
 	 */
 	if (ovl_same_dev(inode->i_sb)) {
 		inode->i_ino = ino;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 256f166b4a17..b28ccede1da9 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -418,8 +418,6 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 	smp_wmb();
 	OVL_I(inode)->__upperdentry = upperdentry;
 	if (inode_unhashed(inode)) {
-		if (!inode->i_ino)
-			inode->i_ino = upperinode->i_ino;
 		inode->i_private = upperinode;
 		__insert_inode_hash(inode, (unsigned long) upperinode);
 	}
-- 
2.17.1
