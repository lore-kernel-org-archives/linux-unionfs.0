From: <zhangaihua1@huawei.com>
Subject: [PATCH] fix error: a bin file can truncate itself while running on overlayfs
Date: Wed, 22 Jun 2016 18:13:08 +0800
Message-ID: <1466590388-4914-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:6914 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbcFVKLi (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 22 Jun 2016 06:11:38 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
Cc: Aihua Zhang <zhangaihua1@huawei.com>

From: Aihua Zhang <zhangaihua1@huawei.com>

I wrote a testcase to truncate a bin file while it is running on overlayfs.

the mount:
/dev/mapper/fedora-home on /home type ext4 (rw,relatime,data=ordered)
overlay on /tmp type overlay (rw,relatime,lowerdir=/home/zah/lower,
		upperdir=/home/zah/upper,workdir=/home/zah/workdir)

the code cpp:
int main(int argc, char *argv[])
{
int status;
pthread_t thread;
int err;
char *ptr;

ptr = basename(argv[0]);
printf("%s\n",ptr);
errno = 0;

status = truncate(ptr, 4096);
printf("status:%d\n",status);
printf("errno:%d\n",errno);
printf("ETXTBSY:%d\n",ETXTBSY);

if ((-1 == status) && (ETXTBSY == errno))
{
printf("PASS\n");
return 0;
}

err = errno;
printf("err = %d\n", err);
printf("FAIL\n");
return 1;
}

I running the test on overlayfs, the result as below:
Bus error (core dumped)

and running the test on ext4, the result as below:
status:-1
errno:26
ETXTBSY:26
PASS

I add some log, and I find the inode is not correct on overlayfs,
and the inode->i_writecount is not correct also called by vfs_truncate->
get_write_access(), the log as below:

Jun 22 09:50:38 kernel: [131.872920] deny_write_access: inode ino 64104618
Jun 22 09:50:38 kernel: [131.873109] deny_write_access: inode ino 64104618
Jun 22 09:50:38 kernel: [131.873110] __vma_link_file: inode ino 64104618
Jun 22 09:50:38 kernel: [131.873112] allow_write_access: inode ino 64104618
Jun 22 09:50:38 kernel: [131.873114] deny_write_access: inode ino 64104618
Jun 22 09:50:38 kernel: [131.873115] __vma_link_file: inode ino 64104618
Jun 22 09:50:38 kernel: [131.873116] allow_write_access: inode ino 64104618
Jun 22 09:50:38 kernel: [131.873162] allow_write_access: inode ino 64104618
Jun 22 09:50:38 kernel: [131.873947] __vma_link_file: inode ino 64104618
Jun 22 09:50:38 kernel: [131.874039] vfs_truncate: inode ino:24061     

before vfs_truncate, the inode is point to upper filesystem(ext4),
and in vfs_truncate the inode is point to overlayfs.

So, I fix it by geting the real inode via ovl_d_select_inode.

Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
---
 fs/open.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 93ae3cd..43b17d1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -67,10 +67,16 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 
 long vfs_truncate(const struct path *path, loff_t length)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode;
 	long error;
 
-	inode = path->dentry->d_inode;
+	if (dentry->d_flags & DCACHE_OP_SELECT_INODE) {
+		inode = dentry->d_op->d_select_inode(dentry, O_TRUNC);
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
+	} else
+		inode = dentry->d_inode;
 
 	/* For directories it's -EISDIR, for other non-regulars - -EINVAL */
 	if (S_ISDIR(inode->i_mode))
@@ -106,7 +112,7 @@ long vfs_truncate(const struct path *path, loff_t length)
 	if (!error)
 		error = security_path_truncate(path);
 	if (!error)
-		error = do_truncate(path->dentry, length, 0, NULL);
+		error = do_truncate(dentry, length, 0, NULL);
 
 put_write_and_out:
 	put_write_access(inode);
-- 
1.7.1
