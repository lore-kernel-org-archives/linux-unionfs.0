Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A40DC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 03:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76BAD615A2
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 03:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347927AbhI3DOk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 29 Sep 2021 23:14:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13002 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347683AbhI3DOk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Sep 2021 23:14:40 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKdZ05CRlzVmSq;
        Thu, 30 Sep 2021 11:11:36 +0800 (CST)
Received: from dggema766-chm.china.huawei.com (10.1.198.208) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 11:12:56 +0800
Received: from localhost.localdomain (10.175.127.227) by
 dggema766-chm.china.huawei.com (10.1.198.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 30 Sep 2021 11:12:56 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <miklos@szeredi.hu>, <amir73il@gmail.com>,
        <jiufei.xue@linux.alibaba.com>
CC:     <linux-unionfs@vger.kernel.org>, <yangerkun@huawei.com>,
        <yukuai3@huawei.com>
Subject: [PATCH 0/2] ovl: bugfix for ovl_aio_req
Date:   Thu, 30 Sep 2021 11:22:26 +0800
Message-ID: <20210930032228.3199690-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.31.1
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

yangerkun (2):
  ovl: factor out ovl_get_aio_req
  ovl: fix UAF for ovl_aio_req

 fs/overlayfs/file.c | 51 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 14 deletions(-)

-- 
2.31.1

