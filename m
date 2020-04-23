Return-Path: <SRS0=+0RS=6H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20690C2BA19
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 06:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5CD521556
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 06:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgDWG5V (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 02:57:21 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:50878 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725562AbgDWG5V (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 23 Apr 2020 02:57:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TwPNldu_1587625038;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0TwPNldu_1587625038)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Apr 2020 14:57:19 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        amir73il@gmail.com
Cc:     jefflexu@linux.alibaba.com, joseph.qi@linux.alibaba.com
Subject: [PATCH] overlayfs: set MS_NOSEC flag for overlayfs
Date:   Thu, 23 Apr 2020 14:57:18 +0800
Message-Id: <1587625038-55484-1-git-send-email-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Since the stacking of regular file operations [1], the overlayfs
edition of write_iter() is called when writing regular files.

Since then, xattr lookup is needed on every write since file_remove_privs()
is called from ovl_write_iter(), which would become the performance
bottleneck when writing small chunks of data. In my test case,
file_remove_privs() would consume ~15% CPU when running fstime of
unixbench (the workload is repeadly writing 1 KB to the same file) [2].

Set the MS_NOSEC flag for overlayfs superblock. Since then xattr lookup
would be done only once on the first write. Unixbench fstime gets a ~20%
performance gain with this patch.

[1] https://lore.kernel.org/lkml/20180606150905.GC9426@magnolia/T/
[2] https://www.spinics.net/lists/linux-unionfs/msg07153.html

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 732ad54..0b047ce 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1817,7 +1817,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
 	sb->s_xattr = ovl_xattr_handlers;
 	sb->s_fs_info = ofs;
-	sb->s_flags |= SB_POSIXACL;
+	sb->s_flags |= (SB_POSIXACL | SB_NOSEC);
 
 	err = -ENOMEM;
 	root_dentry = ovl_get_root(sb, upperpath.dentry, oe);
-- 
1.8.3.1

