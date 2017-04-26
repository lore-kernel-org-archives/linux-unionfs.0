From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 10/16] ovl: set the COPYUP type flag for non-dirs
Date: Thu, 27 Apr 2017 00:35:12 +0300
Message-ID: <1493242518-15266-11-git-send-email-amir73il@gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33887 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030885AbdDZVfh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:37 -0400
In-Reply-To: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

For directory entries, non zero oe->numlower implies OVL_TYPE_MERGE.
Define a new type flag OVL_TYPE_COPYUP to indicate that an entry is
a target of a copy up.

For directory entries COPYUP = MERGE && UPPER. For non-dir entries
non zero oe->numlower implies COPYUP, but COPYUP does not imply
non zero oe->numlower.  COPYUP can also be set on lookup when detecting
an overlay.fh xattr on a non-dir, even if that fh cannot be followed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     |  3 +++
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/util.c      | 12 ++++++++----
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ad2c784..3ebde1b 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -457,6 +457,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 		if (d.opaque)
 			type |= __OVL_PATH_OPAQUE;
+		/* overlay.fh xattr implies this is a copy up */
+		if (d.fh)
+			type |= __OVL_PATH_COPYUP;
 	}
 
 	/*
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index ea23bef..d9633b3 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -13,11 +13,13 @@ enum ovl_path_type {
 	__OVL_PATH_UPPER	= (1 << 0),
 	__OVL_PATH_MERGE	= (1 << 1),
 	__OVL_PATH_OPAQUE	= (1 << 2),
+	__OVL_PATH_COPYUP	= (1 << 3),
 };
 
 #define OVL_TYPE_UPPER(type)	((type) & __OVL_PATH_UPPER)
 #define OVL_TYPE_MERGE(type)	((type) & __OVL_PATH_MERGE)
 #define OVL_TYPE_OPAQUE(type)	((type) & __OVL_PATH_OPAQUE)
+#define OVL_TYPE_COPYUP(type)	((type) & __OVL_PATH_COPYUP)
 
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index a36ca7b..931d199 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -101,11 +101,15 @@ enum ovl_path_type ovl_update_type(struct dentry *dentry, bool is_dir)
 	if (oe->__upperdentry) {
 		type |= __OVL_PATH_UPPER;
 		/*
-		 * Non-dir dentry can hold lower dentry from before
-		 * copy-up.
+		 * oe->numlower implies a copy up, but copy up does not imply
+		 * oe->numlower.  It can also be set on lookup when detecting
+		 * an overlay.fh xattr on a non-dir that cannot be followed.
 		 */
-		if (oe->numlower && is_dir)
-			type |= __OVL_PATH_MERGE;
+		if (oe->numlower) {
+			type |= __OVL_PATH_COPYUP;
+			if (is_dir)
+				type |= __OVL_PATH_MERGE;
+		}
 	} else {
 		if (oe->numlower > 1)
 			type |= __OVL_PATH_MERGE;
-- 
2.7.4
