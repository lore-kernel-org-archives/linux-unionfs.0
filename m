From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 08/23] ovl: unbless lower st_ino of files under unverified redirected dir
Date: Thu,  4 Jan 2018 18:40:03 +0200
Message-ID: <1515084018-25134-9-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45385 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753395AbeADQji (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:38 -0500
Received: by mail-wr0-f193.google.com with SMTP id o15so2006868wrf.12
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:37 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

On a malformed overlay, several redirected dirs can point to the same
dir on a lower layer. This presents a similar challenge as broken
hardlinks, because different objects in the overlay can return the same
st_ino/st_dev pair from stat(2).

For broken hardlinks, we do not provide constant st_ino on copy up to
avoid this inconsistency. When "verify" feature is enabled, apply
the same logic to files nested under unverified redirected dirs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 18 ++++++++++++++----
 fs/overlayfs/namei.c     |  4 ++++
 fs/overlayfs/overlayfs.h |  4 ++++
 fs/overlayfs/util.c      | 27 +++++++++++++++++++++++++++
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 00b6b294272a..1b53755bd86c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -105,12 +105,22 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			 * Lower hardlinks may be broken on copy up to different
 			 * upper files, so we cannot use the lower origin st_ino
 			 * for those different files, even for the same fs case.
+			 *
+			 * Similarly, several redirected dirs can point to the
+			 * same dir on a lower layer. With the "verify" feature,
+			 * we do not use the lower origin st_ino, if any parent
+			 * is redirected and we haven't verified that this
+			 * redirect is unique.
+			 *
 			 * With inodes index enabled, it is safe to use st_ino
-			 * of an indexed hardlinked origin. The index validates
-			 * that the upper hardlink is not broken.
+			 * of an indexed origin. The index validates that the
+			 * upper hardlink is not broken and that a redirected
+			 * dir is the only redirect to that origin.
 			 */
-			if (is_dir || lowerstat.nlink == 1 ||
-			    ovl_test_flag(OVL_INDEX, d_inode(dentry)))
+			if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) ||
+			    ((is_dir || lowerstat.nlink == 1) &&
+			     (!ovl_verify(dentry->d_sb) ||
+			      !ovl_dentry_is_renamed(dentry))))
 				stat->ino = lowerstat.ino;
 
 			if (samefs)
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 56deb2785af7..8aa4724d4fb0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -811,6 +811,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out_free_oe;
 
 		OVL_I(inode)->redirect = upperredirect;
+		/* OVL_RENAMED indicates rename in any layer/path component */
+		if (d.redirect ||
+		    ovl_test_flag(OVL_RENAMED, d_inode(dentry->d_parent)))
+			ovl_set_flag(OVL_RENAMED, inode);
 		if (index)
 			ovl_set_flag(OVL_INDEX, inode);
 	}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 379bb349acc4..46f9f097e822 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -33,7 +33,10 @@ enum ovl_flag {
 	OVL_IMPURE,
 	/* Non-merge dir that may contain whiteout entries */
 	OVL_WHITEOUTS,
+	/* Found index entry for origin inode */
 	OVL_INDEX,
+	/* Merge dir in path was redirected */
+	OVL_RENAMED,
 };
 
 /*
@@ -219,6 +222,7 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry);
 bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
+bool ovl_dentry_is_renamed(struct dentry *dentry);
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 		    struct dentry *lowerdentry);
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index fb0b561b0568..42809eae0992 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -256,6 +256,33 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
 
 	kfree(oi->redirect);
 	oi->redirect = redirect;
+	/* Descendant are marked RENAMED lazily by ovl_dentry_is_renamed() */
+	ovl_set_flag(OVL_RENAMED, d_inode(dentry));
+}
+
+/*
+ * Check if any component in path has been renamed.
+ */
+bool ovl_dentry_is_renamed(struct dentry *dentry)
+{
+	struct dentry *d, *tmp;
+	bool renamed;
+
+	for (d = dget(dentry); !IS_ROOT(d);) {
+		if (ovl_test_flag(OVL_RENAMED, d_inode(d)))
+			break;
+
+		tmp = dget_parent(d);
+		dput(d);
+		d = tmp;
+	}
+
+	renamed = !IS_ROOT(d);
+	dput(d);
+
+	if (renamed)
+		ovl_set_flag(OVL_RENAMED, d_inode(dentry));
+	return renamed;
 }
 
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
-- 
2.7.4
