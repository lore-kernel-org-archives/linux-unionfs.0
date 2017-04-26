From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 02/16] ovl: cram opaque boolean into type flags
Date: Thu, 27 Apr 2017 00:35:04 +0300
Message-ID: <1493242518-15266-3-git-send-email-amir73il@gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35388 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030841AbdDZVfS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:18 -0400
In-Reply-To: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

We are going to add more state info to ovl_entry soon (for const ino)
and this state info would be added as type flags.

It makes sense to treat 'opaque' in a similar way, so instead of using
a boolean member in ovl_entry use a type bit to represent opaqueness.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 9 +++++----
 fs/overlayfs/overlayfs.h | 2 ++
 fs/overlayfs/ovl_entry.h | 1 -
 fs/overlayfs/util.c      | 5 +++--
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 8788fd7..d660177 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -224,7 +224,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *upperdir, *upperdentry = NULL;
 	unsigned int ctr = 0;
 	struct inode *inode = NULL;
-	bool upperopaque = false;
+	enum ovl_path_type type = 0;
 	char *upperredirect = NULL;
 	struct dentry *this;
 	unsigned int i;
@@ -261,7 +261,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			if (d.redirect[0] == '/')
 				poe = dentry->d_sb->s_root->d_fsdata;
 		}
-		upperopaque = d.opaque;
+		if (d.opaque)
+			type |= __OVL_PATH_OPAQUE;
 	}
 
 	if (!d.stop && poe->numlower) {
@@ -331,7 +332,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	revert_creds(old_cred);
-	oe->opaque = upperopaque;
+	oe->__type = type;
 	oe->redirect = upperredirect;
 	oe->__upperdentry = upperdentry;
 	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
@@ -372,7 +373,7 @@ bool ovl_lower_positive(struct dentry *dentry)
 	 * whiteout.
 	 */
 	if (!dentry->d_inode)
-		return oe->opaque;
+		return OVL_TYPE_OPAQUE(oe->__type);
 
 	/* Negative upper -> positive lower */
 	if (!oe->__upperdentry)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e90a548..9420101 100644
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
index 293be5f..12c4922 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -41,7 +41,6 @@ struct ovl_entry {
 		struct {
 			u64 version;
 			const char *redirect;
-			bool opaque;
 			bool copying;
 		};
 		struct rcu_head rcu;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index bbd6074..88cfc2a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -181,7 +181,8 @@ void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache)
 bool ovl_dentry_is_opaque(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-	return oe->opaque;
+
+	return OVL_TYPE_OPAQUE(oe->__type);
 }
 
 bool ovl_dentry_is_whiteout(struct dentry *dentry)
@@ -193,7 +194,7 @@ void ovl_dentry_set_opaque(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	oe->opaque = true;
+	oe->__type |= __OVL_PATH_OPAQUE;
 }
 
 bool ovl_redirect_dir(struct super_block *sb)
-- 
2.7.4
