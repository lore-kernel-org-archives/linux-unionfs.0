Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30415C77B7F
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 May 2023 12:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjEEM0P (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 May 2023 08:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjEEM0M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 May 2023 08:26:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943C41CFEC;
        Fri,  5 May 2023 05:26:07 -0700 (PDT)
Received: from kwepemm600013.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QCVFv6CFvzLndx;
        Fri,  5 May 2023 20:23:15 +0800 (CST)
Received: from huawei.com (10.175.127.227) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 5 May
 2023 20:26:03 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <miklos@szeredi.hu>, <amir73il@gmail.com>, <brauner@kernel.org>
CC:     <linux-unionfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] ovl: Fix null ptr dereference at realinode in rcu-walk
Date:   Fri, 5 May 2023 20:24:50 +0800
Message-ID: <20230505122452.405661-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Zhihao Cheng (2):
  ovl: get_acl: Fix null pointer dereference at realinode in rcu-walk
    mode
  ovl: ovl_permission: Fix null pointer dereference at realinode in
    rcu-walk mode

 fs/overlayfs/inode.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

-- 
2.31.1

