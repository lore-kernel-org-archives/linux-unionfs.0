From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] fs: overlayfs: Fix a possible null-pointer dereference in ovl_free_fs()
Date: Thu, 25 Jul 2019 16:57:32 +0800
Message-ID: <20190725085732.15674-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

In ovl_fill_super(), there is an if statement on line 1607 to check
whether ofs->upper_mnt is NULL:
    if (!ofs->upper_mnt)

When ofs->upper_mnt is NULL and d_make_root() on line 1654 fails,
ovl_free_fs() on line 1683 is executed.
In ovl_free_fs(), ofs->upper_mnt is used on line 224:
    ovl_inuse_unlock(ofs->upper_mnt->mnt_root);

Thus, a possible null-pointer dereference may occur.

To fix this bug, ofs->upper_mnt is checked before being used in
ovl_free_fs().

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b368e2e102fa..1d7c3d280834 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -220,7 +220,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	if (ofs->workdir_locked)
 		ovl_inuse_unlock(ofs->workbasedir);
 	dput(ofs->workbasedir);
-	if (ofs->upperdir_locked)
+	if (ofs->upperdir_locked && ofs->upper_mnt)
 		ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
 	mntput(ofs->upper_mnt);
 	for (i = 0; i < ofs->numlower; i++) {
-- 
2.17.0
