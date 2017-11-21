From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH] ovl: unbless lower st_ino of files inside redirected parent dir
Date: Tue, 21 Nov 2017 14:54:03 +0200
Message-ID: <1511268843-32512-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36692 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbdKUMxT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Nov 2017 07:53:19 -0500
Received: by mail-wr0-f195.google.com with SMTP id y42so11221629wrd.3
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Nov 2017 04:53:19 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

On a malformed overlay, several redirected dirs can point to the same
dir on a lower layer. This presents a similar challenge as broken
hardlinks, because different objects in the overlay can return the same
st_ino/st_dev pair from stat(2).

For broken hardlinks, we do not provide constant st_ino on copy up to
avoid this inconsistency. Apply the same logic to files nested under
redirected parent dirs.

Until index for directories is implemented, every redirected dir is a
suspect of multiply referenced lower dir.

Multiple non-dir upper can also point at a single non-hardlink lower by
origin xattr causing the same challenge, but this patch doesn't address
this case.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

I am currently working on 'verify_dir' feature.
With 'verify_dir=on', directories are indexed on copy up and index is
checked on lookup of directories.

'verify_dir' can guaranty (*) that:
1. At most one upper dir points to the same merge dir lower
2. st_ino/st_dev of merge dir is unique
3. decode_fh(encode_fh(dir)) is idempotent
4. Stale 'origin' is permanently corrected on lookup by setting 'opaque'
5. Mismatch 'origin' is permanently corrected on lookup by setting 'redirect'

At the moment, the introduction of 'redirect_dir' feature and commit
72b608f08528 ("ovl: constant st_ino/st_dev across copy up") leave
overlayfs exposed to breaking consistency rules #2 above.

I wanted to know where stand w.r.t to the this issue:
- Not a kernel problem - should be addressed by fsck.overlayfs?
- Patch should be applied to stable v4.12 with another patch to address
  non-dir rename?
- Problem should be addressed only when opting-in to verify_dir=on,
  along with the rest of the listed consistency guaranties?

(*) At this time, I have no solution for rules #1, #2, #5 when
    numlower > 1, so I plan to emit a warning on mount with verify_dir=on
    and excersize best effort w.r.t those rules.

Thought and comments are welcome.

Thanks,
Amir.

 fs/overlayfs/inode.c     |  6 +++++-
 fs/overlayfs/namei.c     |  4 ++++
 fs/overlayfs/overlayfs.h |  4 ++++
 fs/overlayfs/util.c      | 30 ++++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 00b6b294272a..625a31821517 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -105,11 +105,15 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			 * Lower hardlinks may be broken on copy up to different
 			 * upper files, so we cannot use the lower origin st_ino
 			 * for those different files, even for the same fs case.
+			 * Similarly, several redirected dirs can point to the
+			 * same dir on a lower layer, so we cannot use the lower
+			 * origin st_ino, if any parent is redirected.
 			 * With inodes index enabled, it is safe to use st_ino
 			 * of an indexed hardlinked origin. The index validates
 			 * that the upper hardlink is not broken.
 			 */
-			if (is_dir || lowerstat.nlink == 1 ||
+			if (((is_dir || lowerstat.nlink == 1) &&
+			     !ovl_dentry_is_renamed(dentry)) ||
 			    ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 				stat->ino = lowerstat.ino;
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b6564f1a6d48..4a5c23260473 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -724,6 +724,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
index 13eab09a6b6f..5daa1a84f217 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -33,7 +33,10 @@ enum ovl_flag {
 	OVL_IMPURE,
 	/* Non-merge dir that may contain whiteout entries */
 	OVL_WHITEOUTS,
+	/* Found index entry for origin inode */
 	OVL_INDEX,
+	/* Merge dir in path was redirected or non-dir renamed */
+	OVL_RENAMED,
 };
 
 /*
@@ -218,6 +221,7 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry);
 bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
+bool ovl_dentry_is_renamed(struct dentry *dentry);
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 		    struct dentry *lowerdentry);
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index d6bb1c9f5e7a..2876492a86e5 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -249,6 +249,36 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
 
 	kfree(oi->redirect);
 	oi->redirect = redirect;
+	/* Descentandt are marekd RENAMED lazily by ovl_dentry_is_renamed() */
+	ovl_set_flag(OVL_RENAMED, d_inode(dentry));
+}
+
+/*
+ * Check if any component in path has been renamed.
+ *
+ * TODO: lookup non-indexed non-dir upper with non-hardlink origin in lower
+ *       layers and mark it RENAMED if origin not found.
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
