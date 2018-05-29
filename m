From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 12/28] ovl: Fix ovl_getattr() to get number of blocks from lower
Date: Tue, 29 May 2018 16:45:56 +0200
Message-ID: <20180529144612.16675-13-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

If an inode has been copied up metadata only, then we need to query the
number of blocks from lower and fill up the stat->st_blocks.

We need to be careful about races where we are doing stat on one cpu and
data copy up is taking place on other cpu.  We want to return
stat->st_blocks either from lower or stable upper and not something in
between.  Hence, ovl_has_upperdata() is called first to figure out whether
block reporting will take place from lower or upper.

We now support metacopy dentries in middle layer.  That means number of
blocks reporting needs to come from lowest data dentry and this could be
different from lower dentry.  Hence we end up making a separate
vfs_getxattr() call for metacopy dentries to get number of blocks.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c     | 35 ++++++++++++++++++++++++++++++++++-
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 16 ++++++++++++++++
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 350e38c5ce7d..6a6693150c37 100644
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
index 13b2151cf4df..ae06fd531b75 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -271,6 +271,7 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 int ovl_check_metacopy_xattr(struct dentry *dentry);
+bool ovl_is_metacopy_dentry(struct dentry *dentry);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7c7b95d5da1f..4f9c2ecee74c 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -825,3 +825,19 @@ int ovl_check_metacopy_xattr(struct dentry *dentry)
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
2.14.3
