From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 02/39] vfs: dedupe: rationalize args
Date: Tue, 29 May 2018 16:43:02 +0200
Message-ID: <20180529144339.16538-3-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Clean up f_op->dedupe_file_range() interface.

1) Use loff_t for offsets and length instead of u64
2) Order the arguments the same way as {copy|clone}_file_range().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/btrfs/ctree.h   | 5 +++--
 fs/btrfs/ioctl.c   | 5 +++--
 fs/ocfs2/file.c    | 6 +++---
 fs/read_write.c    | 4 ++--
 fs/xfs/xfs_file.c  | 6 +++---
 include/linux/fs.h | 4 ++--
 6 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 990e011c9f0c..5968ba5aa0d1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3271,8 +3271,9 @@ void btrfs_get_block_group_info(struct list_head *groups_list,
 				struct btrfs_ioctl_space_info *space);
 void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
 			       struct btrfs_ioctl_balance_args *bargs);
-loff_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
-			    struct file *dst_file, u64 dst_loff);
+loff_t btrfs_dedupe_file_range(struct file *src_file, loff_t loff,
+			       struct file *dst_file, loff_t dst_loff,
+			       loff_t olen);
 
 /* file.c */
 int __init btrfs_auto_defrag_init(void);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1b5cc5fd4868..70eac76804df 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3194,8 +3194,9 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 
 #define BTRFS_MAX_DEDUPE_LEN	SZ_16M
 
-loff_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
-			       struct file *dst_file, u64 dst_loff)
+loff_t btrfs_dedupe_file_range(struct file *src_file, loff_t loff,
+			       struct file *dst_file, loff_t dst_loff,
+			       loff_t olen)
 {
 	struct inode *src = file_inode(src_file);
 	struct inode *dst = file_inode(dst_file);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4a81d82ab7f6..a024715cd227 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2538,10 +2538,10 @@ static int ocfs2_file_clone_range(struct file *file_in,
 }
 
 static loff_t ocfs2_file_dedupe_range(struct file *src_file,
-				      u64 loff,
-				      u64 len,
+				      loff_t loff,
 				      struct file *dst_file,
-				      u64 dst_loff)
+				      loff_t dst_loff,
+				      loff_t len)
 {
 	int error;
 
diff --git a/fs/read_write.c b/fs/read_write.c
index c41e2a1eb7c7..1818581cadf6 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -2046,8 +2046,8 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 			info->status = -EINVAL;
 		} else {
 			deduped = dst_file->f_op->dedupe_file_range(file, off,
-							len, dst_file,
-							info->dest_offset);
+							dst_file,
+							info->dest_offset, len);
 			if (deduped == -EBADE)
 				info->status = FILE_DEDUPE_RANGE_DIFFERS;
 			else if (deduped < 0)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cf51d47efdb6..75704edfba82 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -875,10 +875,10 @@ xfs_file_clone_range(
 STATIC loff_t
 xfs_file_dedupe_range(
 	struct file	*src_file,
-	u64		loff,
-	u64		len,
+	loff_t		loff,
 	struct file	*dst_file,
-	u64		dst_loff)
+	loff_t		dst_loff,
+	loff_t		len)
 {
 	struct inode	*srci = file_inode(src_file);
 	u64		max_dedupe;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8e49defc7aab..b0f290944220 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1738,8 +1738,8 @@ struct file_operations {
 			loff_t, size_t, unsigned int);
 	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
 			u64);
-	loff_t (*dedupe_file_range)(struct file *, u64, u64, struct file *,
-			u64);
+	loff_t (*dedupe_file_range)(struct file *, loff_t,
+				    struct file *, loff_t, loff_t);
 } __randomize_layout;
 
 struct inode_operations {
-- 
2.14.3
