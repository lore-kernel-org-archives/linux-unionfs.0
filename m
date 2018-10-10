Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix error handling in ovl_verify_set_fh()
Date: Wed, 10 Oct 2018 19:10:06 +0300
Message-Id: <20181010161006.2673-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

We hit a BUG on kfree of an ERR_PTR()...

Reported-by: syzbot+ff03fe05c717b82502d0@syzkaller.appspotmail.com
Fixes: 8b88a2e64036 ("ovl: verify upper root dir matches lower root dir")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 9c0ca6a7becf..efd372312ef1 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -422,8 +422,10 @@ int ovl_verify_set_fh(struct dentry *dentry, const char *name,
 
 	fh = ovl_encode_real_fh(real, is_upper);
 	err = PTR_ERR(fh);
-	if (IS_ERR(fh))
+	if (IS_ERR(fh)) {
+		fh = NULL;
 		goto fail;
+	}
 
 	err = ovl_verify_fh(dentry, name, fh);
 	if (set && err == -ENODATA)
-- 
2.17.1
