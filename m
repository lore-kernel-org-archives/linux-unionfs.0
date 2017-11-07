From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/3] ovl: recover from whiteouts in impure dir iteration
Date: Tue,  7 Nov 2017 23:39:00 +0200
Message-ID: <1510090740-7216-4-git-send-email-amir73il@gmail.com>
References: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:53516 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964823AbdKGViV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 16:38:21 -0500
Received: by mail-wr0-f195.google.com with SMTP id u40so565023wrf.10
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 13:38:21 -0800 (PST)
In-Reply-To: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

A merge dir iteration builds the list of files and removes whiteous
from the list before exposing the list to user.

An impure dir iteration is just a translation layer, so it cannot remove
entries from real dir list.

When we find a whiteout when starting impure dir iteration, we abort
impure dir iteration, mark that dir has whiteouts by setting the
'whiteouts' inode flag and fall back to merge dir iteration to filter
out the whiteouts.  If dir is upper and xattr supported, we set a
'null' origin xattr, so the 'whiteouts' flag will be set when loading
inode from disk.

If we find a whiteout in the middle of non-merge dir iteration, this
is very strange, because whiteout cannot apear in a non-merge dir, so
return ESTALE to caller. In that case, next iteration will be merge dir
iteration.

For pure upper with xattr support, error will be healed permanently.
For pure lower dir or no xattr support, error will be healed for as long
as dir inode remains in cache.

Note that under certain conditions, we will not have a reason to start
impure dir iteration on a non-merge dir and therefore, whiteouts will
be exposed. Here is an example for such conditions:
An upper dir was copied up with kernel < v4.12, all files in it are
either pure or were copied up with kernel < v4.12, whiteouts in it were
created with kernel <= v4.14.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/readdir.c   | 41 ++++++++++++++++++++++++++++++++++++++---
 fs/overlayfs/util.c      | 21 +++++++++++++++++++++
 3 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index df925188394f..5fb2d434cff3 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -235,6 +235,7 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       const char *name, const void *value, size_t size,
 		       int xerr);
 int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
+int ovl_set_whiteouts(struct dentry *dentry);
 void ovl_set_flag(unsigned long flag, struct inode *inode);
 void ovl_clear_flag(unsigned long flag, struct inode *inode);
 bool ovl_test_flag(unsigned long flag, struct inode *inode);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 5397ceafc4ac..1e27b9eb389d 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -498,6 +498,9 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 			this = NULL;
 			goto fail;
 		}
+		/* Nothing there? assume this is a whiteout */
+		if (p->type == DT_CHR)
+			p->is_whiteout = true;
 		goto out;
 	}
 
@@ -577,7 +580,15 @@ static int ovl_dir_read_impure(struct path *path,  struct list_head *list,
 			if (err)
 				return err;
 		}
-		if (p->ino == p->real_ino) {
+		if (p->is_whiteout) {
+			/*
+			 * Found a leftover whiteout in non-merge dir from a
+			 * time it was upper of merge dir? abort impure dir
+			 * iteration and fall back to merge dir iteration to
+			 * filter out whiteouts.
+			 */
+			return -ESTALE;
+		} else if (p->ino == p->real_ino) {
 			list_del(&p->l_node);
 			kfree(p);
 		} else {
@@ -724,9 +735,33 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		    (ovl_same_sb(dentry->d_sb) &&
 		     (ovl_test_flag(OVL_IMPURE, d_inode(dentry)) ||
 		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
-			return ovl_iterate_real(file, ctx);
+			err = ovl_iterate_real(file, ctx);
+			/*
+			 * If we found a whiteout leftover when starting
+			 * non-merge dir iteration (pos == 0), we fall back to
+			 * merge dir iteration after setting the OVL_WHITEOUTS
+			 * inode flag.  If we found a whiteout in the middle of
+			 * non-merge dir iteration, this is very strange,
+			 * because whiteout cannot apear in a non-merge dir,
+			 * so return ESTALE to caller in that case. Next
+			 * iteration will be merge dir iteration.
+			 *
+			 * For pure upper with xattr support, the OVL_WHITEOUTS
+			 * flag is stored as a 'null' origin, so error will be
+			 * healed permanently. For pure lower dir or no xattr
+			 * support, error will be healed for as long as dir
+			 * inode stays in cache.
+			 */
+			if (err == -ESTALE) {
+				ovl_set_whiteouts(dentry);
+				if (!ctx->pos)
+					ovl_dir_reset(file);
+			}
+			if (od->is_real)
+				return err;
+		} else {
+			return iterate_dir(od->realfile, ctx);
 		}
-		return iterate_dir(od->realfile, ctx);
 	}
 
 	if (!od->cache) {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 255ae337fc46..cf46da8bfa08 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -426,6 +426,27 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 	return err;
 }
 
+int ovl_set_whiteouts(struct dentry *dentry)
+{
+	struct dentry *upper = ovl_dentry_upper(dentry);
+
+	if (ovl_test_flag(OVL_WHITEOUTS, d_inode(dentry)))
+		return 0;
+
+	/*
+	 * Mark that pure dir has whiteouts by setting a the 'whiteouts' flag,
+	 * so we are protected from exposing whiteouts while inode remains in
+	 * cache.  If dir is upper and xattr supported, set a 'null' origin fh
+	 * so the 'whiteouts' flag will be set when loading inode from disk.
+	 */
+	ovl_set_flag(OVL_WHITEOUTS, d_inode(dentry));
+
+	if (!upper)
+		return 0;
+
+	return ovl_check_setxattr(dentry, upper, OVL_XATTR_ORIGIN, "", 0, 0);
+}
+
 void ovl_set_flag(unsigned long flag, struct inode *inode)
 {
 	set_bit(flag, &OVL_I(inode)->flags);
-- 
2.7.4
