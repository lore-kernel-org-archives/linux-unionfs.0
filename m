Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 6/6] vfs: fix sync_file_range syscall on an overlayfs file
Date: Sun, 26 Aug 2018 19:25:17 +0300
Message-Id: <1535300717-26686-7-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

For an overlayfs file/inode, page io is operating on the real underlying
file, so sync_file_range() should operate on the real underlying file
mapping to take affect.

Fixes: d1d04ef8572b ("ovl: stack file ops")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/sync.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index b54e0541ad89..28a26333844d 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -286,6 +286,7 @@ int ksys_sync_file_range(int fd, loff_t offset, loff_t nbytes,
 {
 	int ret;
 	struct fd f;
+	struct file *file;
 	struct address_space *mapping;
 	loff_t endbyte;			/* inclusive */
 	umode_t i_mode;
@@ -330,16 +331,21 @@ int ksys_sync_file_range(int fd, loff_t offset, loff_t nbytes,
 	if (!f.file)
 		goto out;
 
-	i_mode = file_inode(f.file)->i_mode;
+	/*
+	 * XXX: We need to use file_real() for overlayfs stacked file because
+	 * page io is operating on the real underlying file/inode.
+	 */
+	file = file_real(f.file);
+	i_mode = file_inode(file)->i_mode;
 	ret = -ESPIPE;
 	if (!S_ISREG(i_mode) && !S_ISBLK(i_mode) && !S_ISDIR(i_mode) &&
 			!S_ISLNK(i_mode))
 		goto out_put;
 
-	mapping = f.file->f_mapping;
+	mapping = file->f_mapping;
 	ret = 0;
 	if (flags & SYNC_FILE_RANGE_WAIT_BEFORE) {
-		ret = file_fdatawait_range(f.file, offset, endbyte);
+		ret = file_fdatawait_range(file, offset, endbyte);
 		if (ret < 0)
 			goto out_put;
 	}
@@ -352,7 +358,7 @@ int ksys_sync_file_range(int fd, loff_t offset, loff_t nbytes,
 	}
 
 	if (flags & SYNC_FILE_RANGE_WAIT_AFTER)
-		ret = file_fdatawait_range(f.file, offset, endbyte);
+		ret = file_fdatawait_range(file, offset, endbyte);
 
 out_put:
 	fdput(f);
-- 
2.7.4
