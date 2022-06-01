Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3092AC433F5
	for <linux-unionfs@archiver.kernel.org>; Wed,  1 Jun 2022 02:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349177AbiFAC2X (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 31 May 2022 22:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiFAC2W (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 May 2022 22:28:22 -0400
Received: from out199-7.us.a.mail.aliyun.com (out199-7.us.a.mail.aliyun.com [47.90.199.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C489A66C93;
        Tue, 31 May 2022 19:28:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VEyjSoC_1654050495;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VEyjSoC_1654050495)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Jun 2022 10:28:15 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] ovl: Fix some kernel-doc comments
Date:   Wed,  1 Jun 2022 10:28:14 +0800
Message-Id: <20220601022814.122620-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Remove warnings found by running scripts/kernel-doc,
which is caused by using 'make W=1'.
fs/overlayfs/super.c:311: warning: Function parameter or member 'dentry'
not described in 'ovl_statfs'
fs/overlayfs/super.c:311: warning: Excess function parameter 'sb'
description in 'ovl_statfs'
fs/overlayfs/super.c:357: warning: Function parameter or member 'm' not
described in 'ovl_show_options'
fs/overlayfs/super.c:357: warning: Function parameter or member 'dentry'
not described in 'ovl_show_options'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/overlayfs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e0a2e0468ee7..9282296dc4c9 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -301,7 +301,7 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 
 /**
  * ovl_statfs
- * @sb: The overlayfs super block
+ * @dentry: The dentry to query
  * @buf: The struct kstatfs to fill in with stats
  *
  * Get the filesystem statistics.  As writes always target the upper layer
@@ -349,6 +349,8 @@ static inline int ovl_xino_def(void)
 
 /**
  * ovl_show_options
+ * @m: the seq_file handle
+ * @dentry: The dentry to query
  *
  * Prints the mount options for a given superblock.
  * Returns zero; does not fail.
-- 
2.20.1.7.g153144c

