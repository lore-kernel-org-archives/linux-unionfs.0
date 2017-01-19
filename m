From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] ovl: support freeze/thaw super
Date: Thu, 19 Jan 2017 14:13:27 +0200
Message-ID: <1484828008-27507-2-git-send-email-amir73il@gmail.com>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36066 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbdASMNu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 19 Jan 2017 07:13:50 -0500
In-Reply-To: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

freeze/thaw of upper is all that is needed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 6792bb7..0f8a9c8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -160,6 +160,20 @@ static void ovl_put_super(struct super_block *sb)
 	kfree(ufs);
 }
 
+static int ovl_freeze(struct super_block *sb)
+{
+	struct ovl_fs *ufs = sb->s_fs_info;
+
+	return ufs->upper_mnt ? freeze_super(ufs->upper_mnt->mnt_sb) : 0;
+}
+
+static int ovl_unfreeze(struct super_block *sb)
+{
+	struct ovl_fs *ufs = sb->s_fs_info;
+
+	return ufs->upper_mnt ? thaw_super(ufs->upper_mnt->mnt_sb) : 0;
+}
+
 /**
  * ovl_statfs
  * @sb: The overlayfs super block
@@ -222,6 +236,8 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
+	.freeze_fs	= ovl_freeze,
+	.unfreeze_fs	= ovl_unfreeze,
 	.statfs		= ovl_statfs,
 	.show_options	= ovl_show_options,
 	.remount_fs	= ovl_remount,
-- 
2.7.4
