Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E4FC4338F
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Aug 2021 09:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E6C60F43
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Aug 2021 09:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244493AbhHFJn2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:43:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12461 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242680AbhHFJn2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Aug 2021 05:43:28 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gh0n33x5wzckT3;
        Fri,  6 Aug 2021 17:39:35 +0800 (CST)
Received: from dggema761-chm.china.huawei.com (10.1.198.203) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 17:43:09 +0800
Received: from huawei.com (10.175.127.227) by dggema761-chm.china.huawei.com
 (10.1.198.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 6 Aug
 2021 17:43:09 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <miklos@szeredi.hu>, <amir73il@gmail.com>
CC:     <linux-unionfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chengzhihao1@huawei.com>, <yukuai3@huawei.com>
Subject: [PATCH] ovl: nfs_export: Parse index inode's nlink when 'd_inode(lowerdentry)->i_nlink == 1'
Date:   Fri, 6 Aug 2021 17:53:54 +0800
Message-ID: <20210806095354.2336263-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema761-chm.china.huawei.com (10.1.198.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

For overlayfs mounted by "nfs_export=on", all files/directories will be
indexed regardless of whether 'nlink > 1' satisfies. Following process
may cause breaking hard links on copy up:

  mkdir low upper work merge
  touch low/file
  mount -t overlay over
    -oupperdir=upper,lowerdir=low,workdir=work,nfs_export=on merge
  chmod +x merge/file
  #  Now nlink of upper/file's correspoding index file equals to 2,
     and we have xattr "trusted.overlay.nlink=U-1" on upper/file
  echo 3 > /proc/sys/vm/drop_caches
  # merge/file's nlink changes to 2

For nfs_export enabled overlayfs, don't ignore parsing index inode's nlink
when 'd_inode(lowerdentry)->i_nlink == 1'.

Fixes: f168f1098dd9038 ("ovl: add support for "nfs_export" configuration")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 fs/overlayfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5e828a1c98a8..75a61243371c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -832,7 +832,8 @@ unsigned int ovl_get_nlink(struct ovl_fs *ofs, struct dentry *lowerdentry,
 	char buf[13];
 	int err;
 
-	if (!lowerdentry || !upperdentry || d_inode(lowerdentry)->i_nlink == 1)
+	if (!lowerdentry || !upperdentry ||
+		(!ofs->config.nfs_export && d_inode(lowerdentry)->i_nlink == 1))
 		return fallback;
 
 	err = ovl_do_getxattr(ofs, upperdentry, OVL_XATTR_NLINK,
-- 
2.31.1

