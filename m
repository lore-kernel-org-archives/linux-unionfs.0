From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 09/23] ovl: cram dentry state booleans into type flags
Date: Wed, 14 Jun 2017 10:26:28 +0300
Message-ID: <1497425202-16270-10-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36145 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754344AbdFNH0q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:26:46 -0400
Received: by mail-wr0-f193.google.com with SMTP id 77so6377248wrb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:26:45 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Like the other type flags, 'opaque' and 'impure' are states discovered in
lookup, set on certain ops (e.g.: create, rename) and never cleared.

We would like to add more state info to ovl_entry soon (indexed) and
and this state info would be added as type flags. It makes little sense
to have the 'opaque' and 'impure' states occupy a boolean each, so store
these states as type flags.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 15 +++++++--------
 fs/overlayfs/overlayfs.h |  4 ++++
 fs/overlayfs/ovl_entry.h |  2 --
 fs/overlayfs/super.c     |  7 +++----
 fs/overlayfs/util.c      | 25 ++++++++++++++++---------
 5 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 198dde797a53..402e52a98c1a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -402,8 +402,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *upperdir, *upperdentry = NULL;
 	unsigned int ctr = 0;
 	struct inode *inode = NULL;
-	bool upperopaque = false;
-	bool upperimpure = false;
+	enum ovl_path_type type = 0;
 	char *upperredirect = NULL;
 	struct dentry *this;
 	unsigned int i;
@@ -457,9 +456,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			if (d.redirect[0] == '/')
 				poe = roe;
 		}
-		upperopaque = d.opaque;
-		if (upperdentry && d.is_dir)
-			upperimpure = ovl_is_impuredir(upperdentry);
+		if (d.opaque)
+			type |= __OVL_PATH_OPAQUE;
+		if (upperdentry && d.is_dir && ovl_is_impuredir(upperdentry))
+			type |= __OVL_PATH_IMPURE;
 	}
 
 	if (!d.stop && poe->numlower) {
@@ -527,8 +527,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	revert_creds(old_cred);
-	oe->opaque = upperopaque;
-	oe->impure = upperimpure;
+	oe->__type = type;
 	oe->redirect = upperredirect;
 	oe->__upperdentry = upperdentry;
 	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
@@ -569,7 +568,7 @@ bool ovl_lower_positive(struct dentry *dentry)
 	 * whiteout.
 	 */
 	if (!dentry->d_inode)
-		return oe->opaque;
+		return OVL_TYPE_OPAQUE(oe->__type);
 
 	/* Negative upper -> positive lower */
 	if (!oe->__upperdentry)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 66ee4116f93b..c4bc1c3ea4e2 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -14,11 +14,15 @@ enum ovl_path_type {
 	__OVL_PATH_UPPER	= (1 << 0),
 	__OVL_PATH_MERGE	= (1 << 1),
 	__OVL_PATH_ORIGIN	= (1 << 2),
+	__OVL_PATH_OPAQUE	= (1 << 3),
+	__OVL_PATH_IMPURE	= (1 << 4),
 };
 
 #define OVL_TYPE_UPPER(type)	((type) & __OVL_PATH_UPPER)
 #define OVL_TYPE_MERGE(type)	((type) & __OVL_PATH_MERGE)
 #define OVL_TYPE_ORIGIN(type)	((type) & __OVL_PATH_ORIGIN)
+#define OVL_TYPE_OPAQUE(type)	((type) & __OVL_PATH_OPAQUE)
+#define OVL_TYPE_IMPURE(type)	((type) & __OVL_PATH_IMPURE)
 
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index e94fa2638faf..6de8725cc38a 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -50,8 +50,6 @@ struct ovl_entry {
 		struct {
 			u64 version;
 			const char *redirect;
-			bool opaque;
-			bool impure;
 			bool copying;
 		};
 		struct rcu_head rcu;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7a41648ee285..13f2ed09c025 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1129,10 +1129,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	mntput(workpath.mnt);
 	kfree(lowertmp);
 
-	if (upperpath.dentry) {
-		oe->__upperdentry = upperpath.dentry;
-		oe->impure = ovl_is_impuredir(upperpath.dentry);
-	}
+	oe->__upperdentry = upperpath.dentry;
+	if (upperpath.dentry && ovl_is_impuredir(upperpath.dentry))
+		oe->__type |= __OVL_PATH_IMPURE;
 	for (i = 0; i < numlower; i++) {
 		oe->lowerstack[i].dentry = stack[i].dentry;
 		oe->lowerstack[i].mnt = ufs->lower_mnt[i];
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8e743c76aa03..9d2f3bb70e61 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -199,15 +199,12 @@ void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache)
 
 bool ovl_dentry_is_opaque(struct dentry *dentry)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
-	return oe->opaque;
+	return OVL_TYPE_OPAQUE(ovl_path_type(dentry));
 }
 
 bool ovl_dentry_is_impure(struct dentry *dentry)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
-
-	return oe->impure;
+	return OVL_TYPE_IMPURE(ovl_path_type(dentry));
 }
 
 bool ovl_dentry_is_whiteout(struct dentry *dentry)
@@ -219,7 +216,18 @@ void ovl_dentry_set_opaque(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	oe->opaque = true;
+	spin_lock(&dentry->d_lock);
+	oe->__type |= __OVL_PATH_OPAQUE;
+	spin_unlock(&dentry->d_lock);
+}
+
+static void ovl_dentry_set_impure(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	spin_lock(&dentry->d_lock);
+	oe->__type |= __OVL_PATH_IMPURE;
+	spin_unlock(&dentry->d_lock);
 }
 
 bool ovl_redirect_dir(struct super_block *sb)
@@ -372,9 +380,8 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 {
 	int err;
-	struct ovl_entry *oe = dentry->d_fsdata;
 
-	if (oe->impure)
+	if (ovl_dentry_is_impure(dentry))
 		return 0;
 
 	/*
@@ -384,7 +391,7 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 	err = ovl_check_setxattr(dentry, upperdentry, OVL_XATTR_IMPURE,
 				 "y", 1, 0);
 	if (!err)
-		oe->impure = true;
+		ovl_dentry_set_impure(dentry);
 
 	return err;
 }
-- 
2.7.4
