From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH v2 1/3] vfs: freeze protect overlay inode on file_start_write()
Date: Mon, 23 Jan 2017 14:32:20 +0200
Message-ID: <1485174742-15866-2-git-send-email-amir73il@gmail.com>
References: <1485174742-15866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35482 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdAWMdM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Jan 2017 07:33:12 -0500
In-Reply-To: <1485174742-15866-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Before writing to overlay file, need to check if either overlay
or upper fs are frozen.
This allows freezing overlayfs mount independently of freezing
underlying fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/fs.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4a7f3cc..71811be 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2547,14 +2547,26 @@ static inline void file_start_write(struct file *file)
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
@@ -2562,6 +2574,9 @@ static inline void file_end_write(struct file *file)
 	if (!S_ISREG(file_inode(file)->i_mode))
 		return;
 	__sb_end_write(file_inode(file)->i_sb, SB_FREEZE_WRITE);
+	if (likely(locks_inode(file) == file_inode(file)))
+		return;
+	__sb_end_write(locks_inode(file)->i_sb, SB_FREEZE_WRITE);
 }
 
 /*
-- 
2.7.4
