From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 01/39] vfs: dedpue: return loff_t
Date: Tue, 29 May 2018 16:43:01 +0200
Message-ID: <20180529144339.16538-2-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

f_op->dedupe_file_range() gets a u64 length to dedup and returns an ssize_t
actual length deduped.  This breaks badly on 32bit archs since the returned
length will be truncated and possibly overflow into the sign bit (xfs and
ocfs2 are affected, btrfs limits actual length to 16MiB).

Returning loff_t should be good, since clone_verify_area() makes sure that
the supplied length doesn't overflow.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/btrfs/ctree.h   |  4 ++--
 fs/btrfs/ioctl.c   |  6 +++---
 fs/ocfs2/file.c    | 10 +++++-----
 fs/read_write.c    |  2 +-
 fs/xfs/xfs_file.c  |  2 +-
 include/linux/fs.h |  2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d422c9908b8..990e011c9f0c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3271,8 +3271,8 @@ void btrfs_get_block_group_info(struct list_head *groups_list,
 				struct btrfs_ioctl_space_info *space);
 void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
 			       struct btrfs_ioctl_balance_args *bargs);
-ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
-			   struct file *dst_file, u64 dst_loff);
+loff_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
+			    struct file *dst_file, u64 dst_loff);
 
 /* file.c */
 int __init btrfs_auto_defrag_init(void);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 632e26d6f7ce..1b5cc5fd4868 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3194,13 +3194,13 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 
 #define BTRFS_MAX_DEDUPE_LEN	SZ_16M
 
-ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
-				struct file *dst_file, u64 dst_loff)
+loff_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
+			       struct file *dst_file, u64 dst_loff)
 {
 	struct inode *src = file_inode(src_file);
 	struct inode *dst = file_inode(dst_file);
 	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
-	ssize_t res;
+	int res;
 
 	if (olen > BTRFS_MAX_DEDUPE_LEN)
 		olen = BTRFS_MAX_DEDUPE_LEN;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6ee94bc23f5b..4a81d82ab7f6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2537,11 +2537,11 @@ static int ocfs2_file_clone_range(struct file *file_in,
 					 len, false);
 }
 
-static ssize_t ocfs2_file_dedupe_range(struct file *src_file,
-				       u64 loff,
-				       u64 len,
-				       struct file *dst_file,
-				       u64 dst_loff)
+static loff_t ocfs2_file_dedupe_range(struct file *src_file,
+				      u64 loff,
+				      u64 len,
+				      struct file *dst_file,
+				      u64 dst_loff)
 {
 	int error;
 
diff --git a/fs/read_write.c b/fs/read_write.c
index c4eabbfc90df..c41e2a1eb7c7 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1976,7 +1976,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	u16 count = same->dest_count;
 	struct file *dst_file;
 	loff_t dst_off;
-	ssize_t deduped;
+	loff_t deduped;
 
 	if (!(file->f_mode & FMODE_READ))
 		return -EINVAL;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e70fb8ccecea..cf51d47efdb6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -872,7 +872,7 @@ xfs_file_clone_range(
 				     len, false);
 }
 
-STATIC ssize_t
+STATIC loff_t
 xfs_file_dedupe_range(
 	struct file	*src_file,
 	u64		loff,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4f637a9b213d..8e49defc7aab 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1738,7 +1738,7 @@ struct file_operations {
 			loff_t, size_t, unsigned int);
 	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
 			u64);
-	ssize_t (*dedupe_file_range)(struct file *, u64, u64, struct file *,
+	loff_t (*dedupe_file_range)(struct file *, u64, u64, struct file *,
 			u64);
 } __randomize_layout;
 
-- 
2.14.3
