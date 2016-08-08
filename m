From: <zhangaihua1@huawei.com>
Subject: [PATCH] ovl: whiteout of lower dir should't dispaly in merge dir.
Date: Mon, 8 Aug 2016 17:18:42 +0800
Message-ID: <1470647922-23721-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
Cc: Aihua Zhang <zhangaihua1@huawei.com>
List-Id: linux-unionfs@vger.kernel.org

From: Aihua Zhang <zhangaihua1@huawei.com>

mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,workdir=/workdir  /merge
ls /lower/test_dir
whiteout

ls /merge/test_dir
whiteout   ------should't display here

this patch fixed it.

Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
---
 fs/overlayfs/readdir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index cf37fc7..21cd5a4 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -362,7 +362,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 	if (!ctx->pos)
 		ovl_dir_reset(file);
 
-	if (od->is_real)
+	if ((od->is_real) && (od->is_upper))
 		return iterate_dir(od->realfile, ctx);
 
 	if (!od->cache) {
-- 
1.7.1
