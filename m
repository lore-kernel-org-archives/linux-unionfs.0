Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:14116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbeJYKvJ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Oct 2018 06:51:09 -0400
From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH] tmpfs: let lseek return ENXIO with a negative offset
Date: Thu, 25 Oct 2018 10:22:56 +0800
Message-ID: <1540434176-14349-1-git-send-email-yuyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-unionfs-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, hughd@google.com
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

For now, the others filesystems, such as ext4, f2fs, ubifs,
all of them return ENXIO when lseek with a negative offset.
It is better to let tmpfs return ENXIO too. After that, tmpfs
can also pass generic/448.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 mm/shmem.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0376c124..f37bf06 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2608,9 +2608,7 @@ static loff_t shmem_file_llseek(struct file *file, loff_t offset, int whence)
 	inode_lock(inode);
 	/* We're holding i_mutex so we can access i_size directly */
 
-	if (offset < 0)
-		offset = -EINVAL;
-	else if (offset >= inode->i_size)
+	if (offset < 0 || offset >= inode->i_size)
 		offset = -ENXIO;
 	else {
 		start = offset >> PAGE_SHIFT;
-- 
2.7.4
