From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/4] ovl: fix dput() of ERR_PTR in ovl_cleanup_index()
Date: Mon, 25 Sep 2017 12:36:20 +0300
Message-ID: <1506332181-19319-4-git-send-email-amir73il@gmail.com>
References: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32772 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934391AbdIYJfy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2017 05:35:54 -0400
In-Reply-To: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 13" <stable@vger.kernel.org>

Fixes: caf70cb2ba5d ("ovl: cleanup orphan index entries")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/util.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 117794582f9f..a1bf81d352b4 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -430,7 +430,7 @@ void ovl_inuse_unlock(struct dentry *dentry)
 	}
 }
 
-/* Called must hold OVL_I(inode)->oi_lock */
+/* Caller must hold OVL_I(inode)->lock */
 static void ovl_cleanup_index(struct dentry *dentry)
 {
 	struct inode *dir = ovl_indexdir(dentry->d_sb)->d_inode;
@@ -466,9 +466,12 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	inode_lock_nested(dir, I_MUTEX_PARENT);
 	/* TODO: whiteout instead of cleanup to block future open by handle */
 	index = lookup_one_len(name.name, ovl_indexdir(dentry->d_sb), name.len);
-	err = PTR_ERR(index);
-	if (!IS_ERR(index))
+	if (!IS_ERR(index)) {
 		err = ovl_cleanup(dir, index);
+	} else {
+		err = PTR_ERR(index);
+		index = NULL;
+	}
 	inode_unlock(dir);
 	if (err)
 		goto fail;
-- 
2.7.4
