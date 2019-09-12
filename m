From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Subject: [PATCH V2] ovl: Fix dereferencing possible ERR_PTR()
Date: Thu, 12 Sep 2019 13:18:31 +0800
Message-ID: <1568265511-1622-1-git-send-email-dingxiang@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
List-Id: linux-unionfs@vger.kernel.org

if ovl_encode_real_fh() fails, no memory was allocated
and the error in the error-valued pointer should be returned.

V1->V2: fix SHA1 length problem

Fixes: 9b6faee07470 ("ovl: check ERR_PTR() return value from ovl_encode_fh()")
Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
---
 fs/overlayfs/export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index cb8ec1f..50ade19 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -229,7 +229,7 @@ static int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
 				ovl_dentry_upper(dentry), !enc_lower);
 	err = PTR_ERR(fh);
 	if (IS_ERR(fh))
-		goto fail;
+		return err;
 
 	err = -EOVERFLOW;
 	if (fh->len > buflen)
-- 
1.9.1
