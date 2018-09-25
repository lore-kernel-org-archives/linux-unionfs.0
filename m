Return-Path: <weiyongjun1@huawei.com>
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] ovl: make symbol 'ovl_aops' static
Date: Tue, 25 Sep 2018 14:57:42 +0000
Message-ID: <1537887462-35160-1-git-send-email-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-unionfs@vger.kernel.org, kernel-janitors@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Fixes the following sparse warning:

fs/overlayfs/inode.c:507:39: warning:
 symbol 'ovl_aops' was not declared. Should it be static?

Fixes: 5b910bd615ba ("ovl: fix GPF in swapfile_activate of file from overlayfs over xfs")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 fs/overlayfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b6ac545..3b7ed5d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -504,7 +504,7 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	.update_time	= ovl_update_time,
 };
 
-const struct address_space_operations ovl_aops = {
+static const struct address_space_operations ovl_aops = {
 	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
 	.direct_IO		= noop_direct_IO,
 };
