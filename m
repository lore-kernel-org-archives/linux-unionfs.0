From: <zhangaihua1@huawei.com>
Subject: [PATCH] fix error: a bin file can truncate itself while running at overlayfs.
Date: Mon, 20 Jun 2016 10:51:29 +0800
Message-ID: <1466391089-17404-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
Cc: Aihua Zhang <zhangaihua1@huawei.com>
List-Id: linux-unionfs@vger.kernel.org

From: Aihua Zhang <zhangaihua1@huawei.com>

I wrote a testcase to truncate a bin file while it is running at overlayfs.
the result as below:

Bus error (core dumped)

I think it's not appropriate for filesystem, and fixed it by this patch.
after the patch, result as below:

status:-1
errno:26
ETXTBSY:26
PASS

This is because the inode is not correct ,it should point to overlayfs rather
than the upper filesystem.

Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
---
 include/linux/fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd28814..54fdbf9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2589,7 +2589,7 @@ static inline int get_write_access(struct inode *inode)
 }
 static inline int deny_write_access(struct file *file)
 {
-	struct inode *inode = file_inode(file);
+	struct inode *inode = d_inode(file->f_path.dentry);
 	return atomic_dec_unless_positive(&inode->i_writecount) ? 0 : -ETXTBSY;
 }
 static inline void put_write_access(struct inode * inode)
-- 
1.7.1

