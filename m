Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v12 11/17] ovl: Fix ovl_getattr() to get number of blocks from lower
Date: Tue,  6 Mar 2018 15:54:02 -0500
Message-Id: <20180306205408.23383-12-vgoyal@redhat.com>
In-Reply-To: <20180306205408.23383-1-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
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

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c     | 17 ++++++++++++++++-
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 16 ++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 165e1b52f619..150929a1fcdf 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -76,6 +76,9 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
 	bool samefs = ovl_same_sb(dentry->d_sb);
 	int err;
+	bool metacopy = false;
+
+	metacopy = ovl_is_metacopy_dentry(dentry);
 
 	type = ovl_path_real(dentry, &realpath);
 	old_cred = ovl_override_creds(dentry->d_sb);
@@ -93,7 +96,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	if (!is_dir || samefs) {
 		if (OVL_TYPE_ORIGIN(type)) {
 			struct kstat lowerstat;
-			u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
+			u32 lowermask = STATX_INO | STATX_BLOCKS |
+					(!is_dir ? STATX_NLINK : 0);
 
 			ovl_path_lower(dentry, &realpath);
 			err = vfs_getattr(&realpath, &lowerstat,
@@ -126,6 +130,17 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			else
 				stat->dev = ovl_get_pseudo_dev(dentry);
 		}
+		if (metacopy) {
+			struct kstat lowerdatastat;
+			u32 lowermask = STATX_BLOCKS;
+
+			ovl_path_lowerdata(dentry, &realpath);
+			err = vfs_getattr(&realpath, &lowerdatastat,
+					  lowermask, flags);
+			if (err)
+				goto out;
+			stat->blocks = lowerdatastat.blocks;
+		}
 		if (samefs) {
 			/*
 			 * When all layers are on the same fs, all real inode
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d999813f9aeb..2d682923252e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -272,6 +272,7 @@ bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
+bool ovl_is_metacopy_dentry(struct dentry *dentry);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 22df74cb1def..274bbfc855e0 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -754,3 +754,19 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
 	pr_err("overlayfs: failed to lock workdir+upperdir\n");
 	return -EIO;
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
+		if (!ovl_has_upperdata(dentry))
+			return true;
+		return false;
+	}
+
+	return (oe->numlower > 1);
+}
-- 
2.13.6
