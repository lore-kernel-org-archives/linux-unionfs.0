Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0BCEB64DD
	for <linux-unionfs@archiver.kernel.org>; Mon, 17 Jul 2023 03:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjGQDLO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 16 Jul 2023 23:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjGQDLM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Jul 2023 23:11:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2793AE41;
        Sun, 16 Jul 2023 20:11:08 -0700 (PDT)
Received: from kwepemm600013.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R46TG148ZzNmPY;
        Mon, 17 Jul 2023 11:07:46 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 17 Jul
 2023 11:11:04 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <amir73il@gmail.com>, <gregkh@linuxfoundation.org>,
        <miklos@szeredi.hu>
CC:     <linux-unionfs@vger.kernel.org>, <stable@vger.kernel.org>,
        <sashal@kernel.org>
Subject: [PATCH 6.1 0/2] ovl: fix null pointer dereference in ovl_get_acl rcu path
Date:   Mon, 17 Jul 2023 11:09:02 +0800
Message-ID: <20230717030904.1669754-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Zhihao Cheng (2):
  ovl: let helper ovl_i_path_real() return the realinode
  ovl: fix null pointer dereference in ovl_get_acl_rcu()

 fs/overlayfs/inode.c     | 12 ++++++------
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/util.c      |  7 ++++---
 3 files changed, 11 insertions(+), 10 deletions(-)

-- 
2.39.2

