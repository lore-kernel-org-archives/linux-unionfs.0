From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 16/17] ovl: wire up NFS export support
Date: Thu,  4 Jan 2018 19:20:48 +0200
Message-ID: <1515086449-26563-17-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41847 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752447AbeADRU5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:57 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Enable NFS export support if the "verify" feature is enabled.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Kconfig | 2 ++
 fs/overlayfs/super.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 0e4764ed4e23..c63473677c95 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -67,6 +67,8 @@ config OVERLAY_FS_VERIFY
 
 	  The verify feature prevents multiple redirects to the same lower dir
 	  and prevents broken hardlinks from using the same inode number.
+	  The verify feature is required for exporting an overlay filesystem
+	  subtree as an NFS share.
 
 	  Note, that verify feature is not backward compatible.  That is,
 	  mounting an overlay with verification index entries on a kernel
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1bc37bc23e89..28596d0a53d2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1316,6 +1316,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		ofs->config.verify = false;
 	}
 
+	/*
+	 * NFS export requires that all layers support file handles and that
+	 * all files and dirs are indexed on copy up (verify=on). We already
+	 * check that all layers support file handles for enabling index.
+	 */
+	if (ofs->config.verify)
+		sb->s_export_op = &ovl_export_operations;
+
 	/* Never override disk quota limits or use reserved space */
 	cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
 
-- 
2.7.4
