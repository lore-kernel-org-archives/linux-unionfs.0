From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 10/11] ovl: whiteout orphan index entries on mount
Date: Tue, 17 Oct 2017 19:00:21 +0300
Message-ID: <1508256022-10267-11-git-send-email-amir73il@gmail.com>
References: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:57109 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936673AbdJQQAB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:00:01 -0400
Received: by mail-wm0-f65.google.com with SMTP id l68so4906199wmd.5
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 09:00:01 -0700 (PDT)
In-Reply-To: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Invalid index entries and stale non-dir index entries are
removed on mount.

Non-dir index entries that have no more linked aliases
need to be whited out on mount to block future open by handle.

When dir index has a stale origin fh to upper dir, we assume
that upper dir was removed and we treat the dir index as orphan
entry that needs to be whited out.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 27 ++++++++++++++++++++++++---
 fs/overlayfs/overlayfs.h |  5 +++--
 fs/overlayfs/readdir.c   | 46 ++++++++++++++++++++++++++++++++++------------
 fs/overlayfs/super.c     |  5 ++---
 4 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index aba57d31d850..1ec65dfbf1bb 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -174,8 +174,14 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 				    bytes >> 2, (int)fh->type,
 				    ovl_acceptable, mnt);
 	if (IS_ERR(origin)) {
-		/* Treat stale file handle as "origin unknown" */
-		if (origin == ERR_PTR(-ESTALE))
+		/*
+		 * Treat stale file handle to lower file as "origin unknown".
+		 * upper file handle could become stale when upper file is
+		 * unlinked and this information is needed to handle stale
+		 * index entries correctly.
+		 */
+		if (origin == ERR_PTR(-ESTALE) &&
+		    !(fh->flags & OVL_FH_FLAG_PATH_UPPER))
 			origin = NULL;
 		goto out;
 	}
@@ -465,6 +471,14 @@ int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
 	upper = ovl_index_upper(index, mnt);
 	if (IS_ERR(upper)) {
 		err = PTR_ERR(upper);
+		/*
+		 * Invalid index entries and stale non-dir index entries need
+		 * to be removed.  When dir index has a stale origin fh to upper
+		 * dir, we assume that upper dir was removed and we treat the
+		 * dir index as orphan entry that needs to be whited out.
+		 */
+		if (err == -ESTALE)
+			goto orphan;
 		if (err)
 			goto fail;
 	}
@@ -482,7 +496,7 @@ int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
 	/* Check if index is orphan and don't warn before cleaning it */
 	if (!d_is_dir(index) && d_inode(index)->i_nlink == 1 &&
 	    ovl_get_nlink(index, origin.dentry, 0) == 0)
-		err = -ENOENT;
+		goto orphan;
 
 out:
 	dput(origin.dentry);
@@ -494,6 +508,13 @@ int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
 	pr_warn_ratelimited("overlayfs: failed to verify index (%pd2, ftype=%x, err=%i)\n",
 			    index, d_inode(index)->i_mode & S_IFMT, err);
 	goto out;
+
+orphan:
+	pr_warn_ratelimited("overlayfs: orphan index entry (%pd2, ftype=%x, nlink=%u)\n",
+			    index, d_inode(index)->i_mode & S_IFMT,
+			    d_inode(index)->i_nlink);
+	err = -ENOENT;
+	goto out;
 }
 
 /*
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 17c039485dc9..18ea89deb040 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -279,8 +279,9 @@ void ovl_dir_cache_free(struct inode *inode);
 int ovl_check_d_type_supported(struct path *realpath);
 void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 			 struct dentry *dentry, int level);
-int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
-			 struct path *lowerstack, unsigned int numlower);
+struct ovl_fs;
+int ovl_indexdir_cleanup(struct ovl_fs *ofs, struct path *lowerstack,
+			 unsigned int numlower);
 
 /* inode.c */
 int ovl_set_nlink_upper(struct dentry *dentry);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 479ce47ba411..ce8cdbb4c7d9 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -17,6 +17,7 @@
 #include <linux/cred.h>
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
+#include "ovl_entry.h"
 
 struct ovl_cache_entry {
 	unsigned int len;
@@ -1019,13 +1020,16 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 	}
 }
 
-int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
-			 struct path *lowerstack, unsigned int numlower)
+int ovl_indexdir_cleanup(struct ovl_fs *ofs, struct path *lowerstack,
+			 unsigned int numlower)
 {
 	int err;
+	struct dentry *workdir = ofs->workdir;
+	struct dentry *indexdir = ofs->indexdir;
+	struct vfsmount *mnt = ofs->upper_mnt;
 	struct dentry *index = NULL;
-	struct inode *dir = dentry->d_inode;
-	struct path path = { .mnt = mnt, .dentry = dentry };
+	struct inode *dir = indexdir->d_inode;
+	struct path path = { .mnt = mnt, .dentry = indexdir };
 	LIST_HEAD(list);
 	struct rb_root root = RB_ROOT;
 	struct ovl_cache_entry *p;
@@ -1041,7 +1045,6 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 	if (err)
 		goto out;
 
-	inode_lock_nested(dir, I_MUTEX_PARENT);
 	list_for_each_entry(p, &list, l_node) {
 		if (p->name[0] == '.') {
 			if (p->len == 1)
@@ -1049,25 +1052,44 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			if (p->len == 2 && p->name[1] == '.')
 				continue;
 		}
-		index = lookup_one_len(p->name, dentry, p->len);
+
+		err = ovl_lock_rename_workdir(workdir, indexdir);
+		if (err)
+			break;
+
+		index = lookup_one_len(p->name, indexdir, p->len);
 		if (IS_ERR(index)) {
 			err = PTR_ERR(index);
 			index = NULL;
 			break;
 		}
 		err = ovl_verify_index(index, mnt, lowerstack, numlower);
-		if (err) {
-			if (err == -EROFS)
-				break;
+		if (!err || err == -EROFS || err == -ENOMEM) {
+			/*
+			 * Abort mount to avoid corrupting the index if
+			 * an incompatible index entry was found or on out
+			 * of memory.
+			 */
+			goto unlock;
+		} else if (err == -ENOENT) {
+			/*
+			 * Whiteout orphan index to block future open by
+			 * handle after overlay nlink dropepd to zero.
+			 */
+			err = ovl_cleanup_and_whiteout(workdir, dir, index);
+		} else {
+			/* Cleanup stale and invalid index entries */
 			err = ovl_cleanup(dir, index);
-			if (err)
-				break;
 		}
+
+unlock:
+		unlock_rename(workdir, indexdir);
 		dput(index);
 		index = NULL;
+		if (err)
+			break;
 	}
 	dput(index);
-	inode_unlock(dir);
 out:
 	ovl_cache_free(&list);
 	if (err)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 24fac7d987a3..0db59616c840 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1100,9 +1100,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 			/* Cleanup bad/stale/orphan index entries */
 			if (!err)
-				err = ovl_indexdir_cleanup(ufs->indexdir,
-							   ufs->upper_mnt,
-							   stack, numlower);
+				err = ovl_indexdir_cleanup(ufs, stack,
+							   numlower);
 		}
 		if (err || !ufs->indexdir)
 			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
-- 
2.7.4
