Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752581AbeEGRlM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 13:41:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 22/30] ovl: Add an inode flag OVL_CONST_INO
Date: Mon,  7 May 2018 13:40:54 -0400
Message-Id: <20180507174102.24086-23-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 3 +++
 fs/overlayfs/overlayfs.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 949ddc7c6f59..3ac5a684798c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -874,6 +874,9 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
 
 	OVL_I(inode)->redirect = oip->redirect;
 
+	if (bylower)
+		ovl_set_flag(OVL_CONST_INO, inode);
+
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
 		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2dabe5f11d22..ea2cf5b6bb85 100644
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

