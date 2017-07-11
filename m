From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 02/10] ovl: fix random return value on mount
Date: Tue, 11 Jul 2017 15:58:35 +0300
Message-ID: <1499777923-29410-3-git-send-email-amir73il@gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 7" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On failure to prepare_creds(), mount fails with a random
return value, as err was last set to an integer cast of
a valid lower mnt pointer or set to 0 if inodes index feature
is enabled.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 3fe6e52f0626 ("ovl: override creds with the ones from ...")
Cc: <stable@vger.kernel.org> # v4.7
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 44dc2d6ffe0f..1cf5d3538309 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1090,6 +1090,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else
 		sb->s_d_op = &ovl_dentry_operations;
 
+	err = -ENOMEM;
 	ufs->creator_cred = cred = prepare_creds();
 	if (!cred)
 		goto out_put_indexdir;
-- 
2.7.4
