From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] ovl: properly implement sync_filesystem()
Date: Thu, 19 Jan 2017 14:13:28 +0200
Message-ID: <1484828008-27507-3-git-send-email-amir73il@gmail.com>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33439 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbdASMN4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 19 Jan 2017 07:13:56 -0500
In-Reply-To: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

overlayfs syncs all inode pages on sync_filesystem(), but it also
needs to call s_op->sync_fs() of upper fs for metadata sync.

This should fix correctness of syncfs(2) and fsfreeze(8).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0f8a9c8..5dc1d42 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -160,6 +160,25 @@ static void ovl_put_super(struct super_block *sb)
 	kfree(ufs);
 }
 
+static int ovl_sync_fs(struct super_block *sb, int wait)
+{
+	struct ovl_fs *ufs = sb->s_fs_info;
+	struct super_block *upper_sb;
+	int ret;
+
+	if (!ufs->upper_mnt)
+		return 0;
+	upper_sb = ufs->upper_mnt->mnt_sb;
+	if (!upper_sb->s_op->sync_fs)
+		return 0;
+
+	/* real inodes have already been synced by sync_filesystem(ovl_sb) */
+	down_read(&upper_sb->s_umount);
+	ret = upper_sb->s_op->sync_fs(upper_sb, wait);
+	up_read(&upper_sb->s_umount);
+	return ret;
+}
+
 static int ovl_freeze(struct super_block *sb)
 {
 	struct ovl_fs *ufs = sb->s_fs_info;
@@ -236,6 +255,7 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
+	.sync_fs	= ovl_sync_fs,
 	.freeze_fs	= ovl_freeze,
 	.unfreeze_fs	= ovl_unfreeze,
 	.statfs		= ovl_statfs,
-- 
2.7.4
