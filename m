From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/6] ovl: check if all layers are on the same fs
Date: Wed, 29 Mar 2017 17:36:03 +0300
Message-ID: <1490798166-22310-4-git-send-email-amir73il@gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33653 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbdC2OgG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Mar 2017 10:36:06 -0400
Received: by mail-wr0-f195.google.com with SMTP id u18so3564766wrc.0
        for <linux-unionfs@vger.kernel.org>; Wed, 29 Mar 2017 07:36:05 -0700 (PDT)
In-Reply-To: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Some features can only work when all layers are on the same fs.
Check that during mount time, so features can test it later.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/ovl_entry.h | 3 ++-
 fs/overlayfs/super.c     | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 12c4922..0e159c3 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -27,7 +27,8 @@ struct ovl_fs {
 	struct ovl_config config;
 	/* creds of process who forced instantiation of super block */
 	const struct cred *creator_cred;
-	bool tmpfile;
+	bool tmpfile;	/* upper supports O_TMPFILE */
+	bool samefs;	/* all layers on same fs */
 	wait_queue_head_t copyup_wq;
 };
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 6d9766f..b8a83e8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -876,6 +876,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ufs->lower_mnt = kcalloc(numlower, sizeof(struct vfsmount *), GFP_KERNEL);
 	if (ufs->lower_mnt == NULL)
 		goto out_put_workdir;
+
+	ufs->samefs = true;
 	for (i = 0; i < numlower; i++) {
 		struct vfsmount *mnt = clone_private_mount(&stack[i]);
 
@@ -892,6 +894,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 		ufs->lower_mnt[ufs->numlower] = mnt;
 		ufs->numlower++;
+
+		/* Check if all layers on same sb */
+		if ((ufs->upper_mnt && ufs->upper_mnt->mnt_sb != mnt->mnt_sb) ||
+		    (i > 0 && ufs->lower_mnt[0]->mnt_sb != mnt->mnt_sb))
+			ufs->samefs = false;
 	}
 
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
-- 
2.7.4
