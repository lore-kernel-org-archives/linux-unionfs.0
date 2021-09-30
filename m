Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01A7C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 03:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A337761452
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 03:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347683AbhI3DOk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 29 Sep 2021 23:14:40 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13855 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347787AbhI3DOk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Sep 2021 23:14:40 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKdVB1Lztz8yrM;
        Thu, 30 Sep 2021 11:08:18 +0800 (CST)
Received: from dggema766-chm.china.huawei.com (10.1.198.208) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 11:12:57 +0800
Received: from localhost.localdomain (10.175.127.227) by
 dggema766-chm.china.huawei.com (10.1.198.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 30 Sep 2021 11:12:56 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <miklos@szeredi.hu>, <amir73il@gmail.com>,
        <jiufei.xue@linux.alibaba.com>
CC:     <linux-unionfs@vger.kernel.org>, <yangerkun@huawei.com>,
        <yukuai3@huawei.com>
Subject: [PATCH 1/2] ovl: factor out ovl_get_aio_req
Date:   Thu, 30 Sep 2021 11:22:27 +0800
Message-ID: <20210930032228.3199690-2-yangerkun@huawei.com>
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

Factor out a common function to remove duplicate code in
ovl_read_iter/ovl_write_iter.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/overlayfs/file.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index d081faa55e83..4ac3cd698c7d 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -282,6 +282,23 @@ static void ovl_aio_rw_complete(struct kiocb *iocb, long res, long res2)
 	orig_iocb->ki_complete(orig_iocb, res, res2);
 }
 
+static struct ovl_aio_req *ovl_get_aio_req(struct kiocb *iocb, struct fd *real, int ifl)
+{
+	struct ovl_aio_req *req;
+
+	req = kmem_cache_zalloc(ovl_aio_request_cachep, GFP_KERNEL);
+	if (!req)
+		return NULL;
+
+	req->fd = *real;
+	real->flags = 0;
+	req->orig_iocb = iocb;
+	kiocb_clone(&req->iocb, iocb, real->file);
+	req->iocb.ki_flags = ifl;
+	req->iocb.ki_complete = ovl_aio_rw_complete;
+	return req;
+}
+
 static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
@@ -304,15 +321,10 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		struct ovl_aio_req *aio_req;
 
 		ret = -ENOMEM;
-		aio_req = kmem_cache_zalloc(ovl_aio_request_cachep, GFP_KERNEL);
+		aio_req = ovl_get_aio_req(iocb, &real, iocb->ki_flags);
 		if (!aio_req)
 			goto out;
 
-		aio_req->fd = real;
-		real.flags = 0;
-		aio_req->orig_iocb = iocb;
-		kiocb_clone(&aio_req->iocb, iocb, real.file);
-		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
 		ret = vfs_iocb_iter_read(real.file, &aio_req->iocb, iter);
 		if (ret != -EIOCBQUEUED)
 			ovl_aio_cleanup_handler(aio_req);
@@ -364,7 +376,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		struct ovl_aio_req *aio_req;
 
 		ret = -ENOMEM;
-		aio_req = kmem_cache_zalloc(ovl_aio_request_cachep, GFP_KERNEL);
+		aio_req = ovl_get_aio_req(iocb, &real, ifl);
 		if (!aio_req)
 			goto out;
 
@@ -372,12 +384,6 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		/* Pacify lockdep, same trick as done in aio_write() */
 		__sb_writers_release(file_inode(real.file)->i_sb,
 				     SB_FREEZE_WRITE);
-		aio_req->fd = real;
-		real.flags = 0;
-		aio_req->orig_iocb = iocb;
-		kiocb_clone(&aio_req->iocb, iocb, real.file);
-		aio_req->iocb.ki_flags = ifl;
-		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
 		ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
 		if (ret != -EIOCBQUEUED)
 			ovl_aio_cleanup_handler(aio_req);
-- 
2.31.1

