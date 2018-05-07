Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752449AbeEGRlM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 13:41:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 14/30] ovl: Fix ovl_getattr() to get number of blocks from lower
Date: Mon,  7 May 2018 13:40:46 -0400
Message-Id: <20180507174102.24086-15-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

If an inode has been copied up metadata only, then we need to query the
number of blocks from lower and fill up the stat->st_blocks.

We need to be careful about races where we are doing stat on one cpu and
data copy up is taking place on other cpu. We want to return
stat->st_blocks either from lower or stable upper and not something in
between. Hence, ovl_has_upperdata() is called first to figure out whether
block reporting will take place from lower or upper.

We now support metacopy dentries in middle layer. That means number of
blocks reporting needs to come from lowest data dentry and this could
be different from lower dentry. Hence we end up making a separate
vfs_getxattr() call for metacopy dentries to get number of blocks.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c     | 35 ++++++++++++++++++++++++++++++++++-
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 16 ++++++++++++++++
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 83b276ce0240..5d461cd57b48 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -145,6 +145,9 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	bool samefs = ovl_same_sb(dentry->d_sb);
 	struct ovl_layer *lower_layer = NULL;
 	int err;
+	bool metacopy_blocks = false;
+
+	metacopy_blocks = ovl_is_metacopy_dentry(dentry);
 
 	type = ovl_path_real(dentry, &realpath);
 	old_cred = ovl_override_creds(dentry->d_sb);
@@ -166,7 +169,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			lower_layer = ovl_layer_lower(dentry);
 		} else if (OVL_TYPE_ORIGIN(type)) {
 			struct kstat lowerstat;
-			u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
+			u32 lowermask = STATX_INO | STATX_BLOCKS |
+					(!is_dir ? STATX_NLINK : 0);
 
 			ovl_path_lower(dentry, &realpath);
 			err = vfs_getattr(&realpath, &lowerstat,
@@ -195,6 +199,35 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 				stat->ino = lowerstat.ino;
 				lower_layer = ovl_layer_lower(dentry);
 			}
+
+			/*
+			 * If we are querying a metacopy dentry and lower
+			 * dentry is data dentry, then use the blocks we
+			 * queried just now. We don't have to do additional
+			 * vfs_getattr(). If lower itself is metacopy, then
+			 * additional vfs_getattr() is unavoidable.
+			 */
+			if (metacopy_blocks &&
+			    realpath.dentry == ovl_dentry_lowerdata(dentry)) {
+				stat->blocks = lowerstat.blocks;
+				metacopy_blocks = false;
+			}
+		}
+
+		if (metacopy_blocks) {
+			/*
+			 * If lower is not same as lowerdata or if there was
+			 * no origin on upper, we can end up here.
+			 */
+			struct kstat lowerdatastat;
+			u32 lowermask = STATX_BLOCKS;
+
+			ovl_path_lowerdata(dentry, &realpath);
+			err = vfs_getattr(&realpath, &lowerdatastat,
+					  lowermask, flags);
+			if (err)
+				goto out;
+			stat->blocks = lowerdatastat.blocks;
 		}
 	}
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index a38aa95f4795..6d64796e0060 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -278,6 +278,7 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 int ovl_check_metacopy_xattr(struct dentry *dentry);
+bool ovl_is_metacopy_dentry(struct dentry *dentry);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 873d4e56e21b..7b7d4623df16 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -840,3 +840,19 @@ int ovl_check_metacopy_xattr(struct dentry *dentry)
 	pr_warn_ratelimited("overlayfs: failed to get metacopy (%i)\n", res);
 	return res;
 }
+
+bool ovl_is_metacopy_dentry(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	if (!d_is_reg(dentry))
+		return false;
+
+	if (ovl_dentry_upper(dentry)) {
+		if (!ovl_has_upperdata(d_inode(dentry)))
+			return true;
+		return false;
+	}
+
+	return (oe->numlower > 1);
+}
-- 
2.13.6

