From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 5/5] ovl: support freeze/thaw super
Date: Tue, 31 Jan 2017 10:34:59 +0200
Message-ID: <1485851699-25313-6-git-send-email-amir73il@gmail.com>
References: <1485851699-25313-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:36573 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdAaIf2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jan 2017 03:35:28 -0500
In-Reply-To: <1485851699-25313-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 346f668..cb85eeb 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -179,6 +179,16 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 	return ret;
 }
 
+static int ovl_freeze(struct super_block *sb)
+{
+	return 0;
+}
+
+static int ovl_unfreeze(struct super_block *sb)
+{
+	return 0;
+}
+
 /**
  * ovl_statfs
  * @sb: The overlayfs super block
@@ -242,6 +252,8 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
 	.sync_fs	= ovl_sync_fs,
+	.freeze_fs	= ovl_freeze,
+	.unfreeze_fs	= ovl_unfreeze,
 	.statfs		= ovl_statfs,
 	.show_options	= ovl_show_options,
 	.remount_fs	= ovl_remount,
-- 
2.7.4
