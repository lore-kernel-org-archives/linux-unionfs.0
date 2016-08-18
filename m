From: Colin King <colin.king@canonical.com>
Subject: [PATCH] ovl: fix spelling mistake: "directries" -> "directories"
Date: Thu, 18 Aug 2016 16:58:35 +0100
Message-ID: <1471535915-15918-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in pr_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0f824f5..92eb43d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1132,7 +1132,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	err = -EINVAL;
 	stacklen = ovl_split_lowerdirs(lowertmp);
 	if (stacklen > OVL_MAX_STACK) {
-		pr_err("overlayfs: too many lower directries, limit is %d\n",
+		pr_err("overlayfs: too many lower directories, limit is %d\n",
 		       OVL_MAX_STACK);
 		goto out_free_lowertmp;
 	} else if (!ufs->config.upperdir && stacklen == 1) {
-- 
2.8.1
