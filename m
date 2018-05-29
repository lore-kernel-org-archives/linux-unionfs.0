From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 08/39] vfs: export vfs_dedupe_file_range_one() to modules
Date: Tue, 29 May 2018 16:43:08 +0200
Message-ID: <20180529144339.16538-9-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This is needed by the stacked dedupe implementation in overlayfs.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/read_write.c    | 6 +++---
 include/linux/fs.h | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 82a53c44c0aa..4d61375a0de4 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1964,9 +1964,8 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 }
 EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 
-static s64 vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
-				     struct file *dst_file, loff_t dst_pos,
-				     u64 len)
+s64 vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
+			      struct file *dst_file, loff_t dst_pos, u64 len)
 {
 	s64 ret;
 
@@ -2001,6 +2000,7 @@ static s64 vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 
 	return ret;
 }
+EXPORT_SYMBOL(vfs_dedupe_file_range_one);
 
 int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 598c60092c11..6961feda6915 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1817,6 +1817,10 @@ extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 loff_t len, bool *is_same);
 extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
+extern s64 vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
+				     struct file *dst_file, loff_t dst_pos,
+				     u64 len);
+
 
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
-- 
2.14.3
