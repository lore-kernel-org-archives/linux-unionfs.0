From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 1/4] ovl: Fix OVL_XATTR_PREFIX
Date: Mon, 22 Aug 2016 20:06:31 +0200
Message-ID: <1471889194-31218-2-git-send-email-agruenba@redhat.com>
References: <1471889194-31218-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755285AbcHVSGj (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Aug 2016 14:06:39 -0400
In-Reply-To: <1471889194-31218-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>

Make sure ovl_own_xattr_handler only matches attribute names starting
with "overlay.", not "overlayXXX".

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/overlayfs/inode.c     | 5 ++---
 fs/overlayfs/overlayfs.h | 4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1b885c1..859e42c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -193,9 +193,8 @@ static int ovl_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 
 static bool ovl_is_private_xattr(const char *name)
 {
-#define OVL_XATTR_PRE_NAME OVL_XATTR_PREFIX "."
-	return strncmp(name, OVL_XATTR_PRE_NAME,
-		       sizeof(OVL_XATTR_PRE_NAME) - 1) == 0;
+	return strncmp(name, OVL_XATTR_PREFIX,
+		       sizeof(OVL_XATTR_PREFIX) - 1) == 0;
 }
 
 int ovl_setxattr(struct dentry *dentry, struct inode *inode,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e4f5c95..77fd667 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -24,8 +24,8 @@ enum ovl_path_type {
 	(OVL_TYPE_MERGE(type) || !OVL_TYPE_UPPER(type))
 
 
-#define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay"
-#define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX ".opaque"
+#define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
+#define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
 
 #define OVL_ISUPPER_MASK 1UL
 
-- 
2.7.4
