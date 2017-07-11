From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 04/10] ovl: remove unneeded check for IS_ERR()
Date: Tue, 11 Jul 2017 15:58:37 +0300
Message-ID: <1499777923-29410-5-git-send-email-amir73il@gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36483 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755465AbdGKM6k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 08:58:40 -0400
Received: by mail-wr0-f193.google.com with SMTP id 77so32034866wrb.3
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2017 05:58:39 -0700 (PDT)
In-Reply-To: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

ovl_workdir_create() returns a valid index dentry or NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1cf5d3538309..c88493b01d8d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1058,10 +1058,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 		ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
 						   OVL_INDEXDIR_NAME, true);
-		err = PTR_ERR(ufs->indexdir);
-		if (IS_ERR(ufs->indexdir))
-			goto out_put_lower_mnt;
-
 		if (ufs->indexdir) {
 			/* Verify upper root is index dir origin */
 			err = ovl_verify_origin(ufs->indexdir, ufs->upper_mnt,
-- 
2.7.4
