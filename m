From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 4/5] vfs: freeze protect overlay inode on file_start_write()
Date: Tue, 31 Jan 2017 10:34:58 +0200
Message-ID: <1485851699-25313-5-git-send-email-amir73il@gmail.com>
References: <1485851699-25313-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35102 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750906AbdAaIf2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jan 2017 03:35:28 -0500
In-Reply-To: <1485851699-25313-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Before writing to overlay file, need to check if either overlay
or upper fs are frozen.
This allows freezing overlayfs mount independently of freezing
underlying fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/fs.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 78c81e6..8a4dbc6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2534,14 +2534,26 @@ static inline void file_start_write(struct file *file)
 {
 	if (!S_ISREG(file_inode(file)->i_mode))
 		return;
+	__sb_start_write(locks_inode(file)->i_sb, SB_FREEZE_WRITE, true);
+	if (likely(locks_inode(file) == file_inode(file)))
+		return;
 	__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);
+
 }
 
 static inline bool file_start_write_trylock(struct file *file)
 {
+	int ret;
+
 	if (!S_ISREG(file_inode(file)->i_mode))
 		return true;
-	return __sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, false);
+	ret = __sb_start_write(locks_inode(file)->i_sb, SB_FREEZE_WRITE, false);
+	if (!ret || likely(locks_inode(file) == file_inode(file)))
+		return ret;
+	ret = __sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, false);
+	if (!ret)
+		__sb_end_write(locks_inode(file)->i_sb, SB_FREEZE_WRITE);
+	return ret;
 }
 
 static inline void file_end_write(struct file *file)
@@ -2549,6 +2561,9 @@ static inline void file_end_write(struct file *file)
 	if (!S_ISREG(file_inode(file)->i_mode))
 		return;
 	__sb_end_write(file_inode(file)->i_sb, SB_FREEZE_WRITE);
+	if (likely(locks_inode(file) == file_inode(file)))
+		return;
+	__sb_end_write(locks_inode(file)->i_sb, SB_FREEZE_WRITE);
 }
 
 static inline int do_clone_file_range(struct file *file_in, loff_t pos_in,
-- 
2.7.4
