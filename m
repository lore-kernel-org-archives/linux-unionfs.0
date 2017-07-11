From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 07/10] ovl: mount overlay read-only on failure to verify index dir
Date: Tue, 11 Jul 2017 15:58:40 +0300
Message-ID: <1499777923-29410-8-git-send-email-amir73il@gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:32883 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755615AbdGKM6n (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 08:58:43 -0400
Received: by mail-wr0-f193.google.com with SMTP id x23so32114833wrb.0
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2017 05:58:42 -0700 (PDT)
In-Reply-To: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Just like on failure to create work dir or index dir, when
index dir verification or cleanup fails, mount the overlay
read-only with a warning instead of failing the mount.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 215b6d23d944..fbb317ad55f6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1066,19 +1066,21 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			/* Verify upper root is index dir origin */
 			err = ovl_verify_origin(ufs->indexdir, ufs->upper_mnt,
 						upperpath.dentry, true, true);
-			if (err)
-				pr_err("overlayfs: failed to verify index dir origin\n");
-
 			/* Cleanup bad/stale/orphan index entries */
 			if (!err)
 				err = ovl_indexdir_cleanup(ufs->indexdir,
 							   ufs->upper_mnt,
 							   stack, numlower);
+			if (err)
+				pr_warn("overlayfs: failed to verify index dir (err=%i); mounting read-only\n",
+					err);
+		}
+		if (err || !ufs->indexdir) {
+			pr_warn("overlayfs: delete index dir or mount with '-o index=off' to disable inodes index.\n");
+			sb->s_flags |= MS_RDONLY;
+			dput(ufs->indexdir);
+			ufs->indexdir = NULL;
 		}
-		if (err || !ufs->indexdir)
-			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
-		if (err)
-			goto out_put_indexdir;
 	}
 
 	if (remote)
-- 
2.7.4
