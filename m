Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 21/31] ovl: Add an inode flag OVL_CONST_INO
Date: Thu, 26 Apr 2018 15:10:03 -0400
Message-Id: <20180426191013.13219-22-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Add an ovl_inode flag OVL_CONST_INO. This flag signifies if inode number
will remain constant over copy up or not. This flag does not get updated
over copy up and remains unmodifed after setting once.

Next patch in the series will make use of this flag. It will basically
figure out if dentry is of type ORIGIN or not. And this can be derived
by this flag.

ORIGIN = (upperdentry && ovl_test_flag(OVL_CONST_INO, inode)).

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c     | 3 +++
 fs/overlayfs/overlayfs.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a6cd57741a1f..19e96d4717bd 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -881,6 +881,9 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 
 	OVL_I(inode)->redirect = redirect;
 
+	if (bylower)
+		ovl_set_flag(OVL_CONST_INO, inode);
+
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
 		if (((upperdentry && lowerdentry) || numlower > 1) ||
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e24af484967f..e2c6a2f5addf 100644
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
2.13.6
