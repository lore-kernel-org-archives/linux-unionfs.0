Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9353EC77B7F
	for <linux-unionfs@archiver.kernel.org>; Tue, 16 May 2023 14:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjEPOTo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 16 May 2023 10:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbjEPOTY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2023 10:19:24 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3459B7ED9;
        Tue, 16 May 2023 07:19:18 -0700 (PDT)
Received: from kwepemm600013.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QLJH80NGNzLm9T;
        Tue, 16 May 2023 22:17:56 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 16 May
 2023 22:19:15 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <miklos@szeredi.hu>, <brauner@kernel.org>, <amir73il@gmail.com>
CC:     <linux-unionfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/3] ovl: Fix null ptr dereference at realinode in rcu-walk
Date:   Tue, 16 May 2023 22:16:16 +0800
Message-ID: <20230516141619.2160800-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.67]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

v1->v2:
  Extract a helper to get realpath and real inode from ovl inode.
  Get realinode from realpath in do_ovl_get_acl().
v2->v3:
  Modify original helper ovl_i_path_real() to return the realinode.

Zhihao Cheng (3):
  ovl: Let helper ovl_i_path_real() return the realinode
  ovl: ovl_permission: Fix null pointer dereference at realinode in
    rcu-walk mode
  ovl: get_acl: Fix null pointer dereference at realinode in rcu-walk
    mode

 fs/overlayfs/inode.c     | 17 ++++++++---------
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/util.c      |  7 ++++---
 3 files changed, 13 insertions(+), 13 deletions(-)

-- 
2.39.2

