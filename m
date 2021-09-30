Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CB4C433FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 03:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB2061452
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 03:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347787AbhI3DOl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 29 Sep 2021 23:14:41 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13856 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347891AbhI3DOk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Sep 2021 23:14:40 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKdVB4jwhz8ytZ;
        Thu, 30 Sep 2021 11:08:18 +0800 (CST)
Received: from dggema766-chm.china.huawei.com (10.1.198.208) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 11:12:57 +0800
Received: from localhost.localdomain (10.175.127.227) by
 dggema766-chm.china.huawei.com (10.1.198.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 30 Sep 2021 11:12:57 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <miklos@szeredi.hu>, <amir73il@gmail.com>,
        <jiufei.xue@linux.alibaba.com>
CC:     <linux-unionfs@vger.kernel.org>, <yangerkun@huawei.com>,
        <yukuai3@huawei.com>
Subject: [PATCH 2/2] ovl: fix UAF for ovl_aio_req
Date:   Thu, 30 Sep 2021 11:22:28 +0800
Message-ID: <20210930032228.3199690-3-yangerkun@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930032228.3199690-1-yangerkun@huawei.com>
References: <20210930032228.3199690-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema766-chm.china.huawei.com (10.1.198.208)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Our testcase trigger follow UAF:

[  153.939147] ==================================================================
[  153.942199] BUG: KASAN: use-after-free in ext4_dio_read_iter+0xcc/0x1a0
[  153.943331] Read of size 8 at addr ffff88803b7f1500 by task fsstress/726
[  153.948182] Call Trace:
[  153.948628]  ? dump_stack_lvl+0x73/0x9f
[  153.950255]  ? ext4_dio_read_iter+0xcc/0x1a0
[  153.950972]  ? ext4_dio_read_iter+0xcc/0x1a0
[  153.951693]  ? kasan_report.cold+0x81/0x165
[  153.952429]  ? ext4_dio_read_iter+0xcc/0x1a0
[  153.953190]  ? __asan_load8+0x74/0x110
[  153.953856]  ? ext4_dio_read_iter+0xcc/0x1a0
[  153.954612]  ? ext4_file_read_iter+0x1df/0x2a0
[  153.955394]  ? ext4_dio_read_iter+0x1a0/0x1a0
[  153.956159]  ? vfs_iocb_iter_read+0xd5/0x330
[  153.956916]  ? ovl_read_iter+0x15f/0x270
[  153.957605]  ? ovl_aio_cleanup_handler+0x2a0/0x2a0
[  153.958436]  ? aio_setup_rw+0xbf/0xe0
[  153.959101]  ? aio_read+0x190/0x2d0
[  153.959750]  ? aio_write+0x3e0/0x3e0
[  153.960404]  ? __kasan_check_read+0x1d/0x30
[  153.961167]  ? ext4_file_getattr+0x116/0x1b0
[  153.961978]  ? __put_user_ns+0x40/0x40
[  153.962714]  ? kasan_poison+0x40/0x90
[  153.963384]  ? set_alloc_info+0x46/0x70
[  153.964102]  ? __kasan_check_write+0x20/0x30
[  153.964856]  ? __fget_files+0x106/0x180
[  153.965571]  ? io_submit_one+0xaa7/0x1480
[  153.966325]  ? aio_poll_complete_work+0x590/0x590
[  153.967713]  ? ioctl_file_clone+0x110/0x110
[  153.969008]  ? vfs_getattr_nosec+0x14a/0x190
[  153.970539]  ? __do_sys_newfstat+0xd6/0xf0
[  153.971713]  ? __ia32_compat_sys_newfstat+0x40/0x40
[  153.973005]  ? __x64_sys_io_submit+0x125/0x3b0
[  153.974282]  ? __ia32_sys_io_submit+0x390/0x390
[  153.975575]  ? __kasan_check_read+0x1d/0x30
[  153.976749]  ? do_syscall_64+0x35/0x80
[  153.978034]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[  153.979436]
[  153.979738] Allocated by task 726:
[  153.980352]  kasan_save_stack+0x23/0x60
[  153.981054]  set_alloc_info+0x46/0x70
[  153.981745]  __kasan_slab_alloc+0x4c/0x90
[  153.982492]  kmem_cache_alloc+0x153/0x750
[  153.983953]  ovl_read_iter+0x13b/0x270
[  153.984689]  aio_read+0x190/0x2d0
[  153.985332]  io_submit_one+0xaa7/0x1480
[  153.986060]  __x64_sys_io_submit+0x125/0x3b0
[  153.986878]  do_syscall_64+0x35/0x80
[  153.987590]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  153.988516]
[  153.988824] Freed by task 750:
[  153.989417]  kasan_save_stack+0x23/0x60
[  153.990140]  kasan_set_track+0x24/0x40
[  153.990871]  kasan_set_free_info+0x30/0x60
[  153.991639]  __kasan_slab_free+0x137/0x210
[  153.992390]  kmem_cache_free+0xf8/0x590
[  153.993303]  ovl_aio_cleanup_handler+0x1ae/0x2a0
[  153.994205]  ovl_aio_rw_complete+0x31/0x60
[  153.995043]  iomap_dio_complete_work+0x4b/0x60
[  153.995898]  iomap_dio_bio_end_io+0x23d/0x270
[  153.996742]  bio_endio+0x40d/0x440
[  153.997376]  blk_update_request+0x38f/0x820
[  153.998160]  scsi_end_request+0x56/0x320
[  153.998872]  scsi_io_completion+0x10a/0xb60
[  153.999655]  scsi_finish_command+0x194/0x2b0
[  154.000464]  scsi_complete+0xd7/0x1f0
[  154.001184]  blk_complete_reqs+0x92/0xb0
[  154.001930]  blk_done_softirq+0x29/0x40
[  154.002696]  __do_softirq+0x133/0x57f

ext4_dio_read_iter
  ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0)
  file_accessed(iocb->ki_filp) <== this trigger UAF

Ret can be -EIOCBQUEUED which means we will not wait for io completion in
iomap_dio_rw. So the release for ovl_aio_req will be done when io
completion routine call ovl_aio_rw_complete(or ovl_aio_cleanup_handler
in ovl_read_iter will do this). But once io finish soon, we may already
release ovl_aio_req before we call file_access in ext4_dio_read_iter.
This can trigger the upper UAF.

Fix it by introduce refcount in ovl_aio_req like what aio_kiocb has did.

Fixes: 2406a307ac7d ("ovl: implement async IO routines")
Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/overlayfs/file.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 4ac3cd698c7d..0a0acab3bf2b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -17,6 +17,7 @@
 
 struct ovl_aio_req {
 	struct kiocb iocb;
+	refcount_t ref;
 	struct kiocb *orig_iocb;
 	struct fd fd;
 };
@@ -252,6 +253,17 @@ static rwf_t ovl_iocb_to_rwf(int ifl)
 	return flags;
 }
 
+static inline void ovl_aio_put(struct ovl_aio_req *aio_req)
+{
+	if (refcount_dec_and_test(&aio_req->ref))
+		kmem_cache_free(ovl_aio_request_cachep, aio_req);
+}
+
+static inline void ovl_aio_get(struct ovl_aio_req *aio_req)
+{
+	refcount_inc(&aio_req->ref);
+}
+
 static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 {
 	struct kiocb *iocb = &aio_req->iocb;
@@ -269,7 +281,7 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 
 	orig_iocb->ki_pos = iocb->ki_pos;
 	fdput(aio_req->fd);
-	kmem_cache_free(ovl_aio_request_cachep, aio_req);
+	ovl_aio_put(aio_req);
 }
 
 static void ovl_aio_rw_complete(struct kiocb *iocb, long res, long res2)
@@ -296,6 +308,7 @@ static struct ovl_aio_req *ovl_get_aio_req(struct kiocb *iocb, struct fd *real,
 	kiocb_clone(&req->iocb, iocb, real->file);
 	req->iocb.ki_flags = ifl;
 	req->iocb.ki_complete = ovl_aio_rw_complete;
+	refcount_set(&req->ref, 1);
 	return req;
 }
 
@@ -325,7 +338,9 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		if (!aio_req)
 			goto out;
 
+		ovl_aio_get(aio_req);
 		ret = vfs_iocb_iter_read(real.file, &aio_req->iocb, iter);
+		ovl_aio_put(aio_req);
 		if (ret != -EIOCBQUEUED)
 			ovl_aio_cleanup_handler(aio_req);
 	}
@@ -384,7 +399,9 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		/* Pacify lockdep, same trick as done in aio_write() */
 		__sb_writers_release(file_inode(real.file)->i_sb,
 				     SB_FREEZE_WRITE);
+		ovl_aio_get(aio_req);
 		ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
+		ovl_aio_put(aio_req);
 		if (ret != -EIOCBQUEUED)
 			ovl_aio_cleanup_handler(aio_req);
 	}
-- 
2.31.1

