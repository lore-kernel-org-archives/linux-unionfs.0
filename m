From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 2/2] ovl: cram opaque boolean into type flags
Date: Tue, 21 Mar 2017 12:16:45 -0400
Message-ID: <1490113005-28787-3-git-send-email-amir73il@gmail.com>
References: <1490113005-28787-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35513 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757307AbdCUQQr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Mar 2017 12:16:47 -0400
Received: by mail-qt0-f196.google.com with SMTP id r5so22025639qtb.2
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Mar 2017 09:16:46 -0700 (PDT)
In-Reply-To: <1490113005-28787-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Like the other type flags, 'opaque' is a state discovered in lookup,
set on certain ops (e.g.: create, rename) and never cleared.

We would like to add more state info to ovl_entry soon (for const ino)
and this state info would be added as type flags. It makes little sense
to have the 'opaque' state occupy a boolean, so drop the boolean member
of ovl_entry and use a type bit to represent opaqueness.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 9 +++++----
 fs/overlayfs/overlayfs.h | 2 ++
 fs/overlayfs/ovl_entry.h | 1 -
 fs/overlayfs/util.c      | 5 +++--
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c230ee1..ac6dc9c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -356,7 +356,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *upperdir, *upperdentry = NULL;
 	unsigned int ctr = 0;
 	struct inode *inode = NULL;
-	bool upperopaque = false;
+	enum ovl_path_type type = 0;
 	char *upperredirect = NULL;
 	struct dentry *this;
 	unsigned int i;
@@ -404,7 +404,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			poe = dentry->d_sb->s_root->d_fsdata;
 			d.by_name = false;
 		}
-		upperopaque = d.opaque;
+		if (d.opaque)
+			type |= __OVL_PATH_OPAQUE;
 	}
 
 	if (!d.stop && poe->numlower) {
@@ -474,7 +475,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	revert_creds(old_cred);
-	oe->opaque = upperopaque;
+	oe->type = type;
 	oe->redirect = upperredirect;
 	oe->__upperdentry = upperdentry;
 	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
@@ -515,7 +516,7 @@ bool ovl_lower_positive(struct dentry *dentry)
 	 * whiteout.
 	 */
 	if (!dentry->d_inode)
-		return oe->opaque;
+		return OVL_TYPE_OPAQUE(oe->type);
 
 	/* Negative upper -> positive lower */
 	if (!oe->__upperdentry)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d37ec4c..bb8861c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -12,10 +12,12 @@
 enum ovl_path_type {
 	__OVL_PATH_UPPER	= (1 << 0),
 	__OVL_PATH_MERGE	= (1 << 1),
+	__OVL_PATH_OPAQUE	= (1 << 2),
 };
 
 #define OVL_TYPE_UPPER(type)	((type) & __OVL_PATH_UPPER)
 #define OVL_TYPE_MERGE(type)	((type) & __OVL_PATH_MERGE)
+#define OVL_TYPE_OPAQUE(type)	((type) & __OVL_PATH_OPAQUE)
 
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b07c29f..985e706 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -43,7 +43,6 @@ struct ovl_entry {
 		struct {
 			u64 version;
 			const char *redirect;
-			bool opaque;
 			bool copying;
 		};
 		struct rcu_head rcu;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f9693a8..95cbc3d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -167,7 +167,8 @@ void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache)
 bool ovl_dentry_is_opaque(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-	return oe->opaque;
+
+	return OVL_TYPE_OPAQUE(oe->type);
 }
 
 bool ovl_dentry_is_whiteout(struct dentry *dentry)
@@ -179,7 +180,7 @@ void ovl_dentry_set_opaque(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	oe->opaque = true;
+	oe->type |= __OVL_PATH_OPAQUE;
 }
 
 bool ovl_redirect_dir(struct super_block *sb)
-- 
2.7.4
