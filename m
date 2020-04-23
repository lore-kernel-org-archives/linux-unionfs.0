Return-Path: <SRS0=+0RS=6H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF98C55186
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 11:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF62E2076C
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 11:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgDWLG6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 07:06:58 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:46940 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726805AbgDWLG6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 23 Apr 2020 07:06:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TwQawG0_1587640016;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0TwQawG0_1587640016)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Apr 2020 19:06:56 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        amir73il@gmail.com
Cc:     joseph.qi@linux.alibaba.com
Subject: [PATCH v2] overlayfs: inherit SB_NOSEC flag from upperdir
Date:   Thu, 23 Apr 2020 19:06:55 +0800
Message-Id: <1587640015-117044-1-git-send-email-jefflexu@linux.alibaba.com>
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

Inherit the SB_NOSEC flag from upperdir. Since then xattr lookup would be
done only once on the first write. Unixbench fstime gets a ~20% performance
gain with this patch.

[1] https://lore.kernel.org/lkml/20180606150905.GC9426@magnolia/T/
[2] https://www.spinics.net/lists/linux-unionfs/msg07153.html

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 fs/overlayfs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 732ad54..1934f71 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1052,6 +1052,10 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 	upper_mnt->mnt_flags &= ~(MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME);
 	ofs->upper_mnt = upper_mnt;
 
+	/* inherit SB_NOSEC flag from upperdir */
+	if (upper_mnt->mnt_sb->s_flags & SB_NOSEC)
+		sb->s_flags |= SB_NOSEC;
+
 	if (ovl_inuse_trylock(ofs->upper_mnt->mnt_root)) {
 		ofs->upperdir_locked = true;
 	} else {
-- 
1.8.3.1

