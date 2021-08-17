Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A27C4338F
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Aug 2021 05:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B4B660F35
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Aug 2021 05:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbhHQFly (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbhHQFlt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Aug 2021 01:41:49 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A90C061764
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Aug 2021 22:41:17 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c17so18265997plz.2
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Aug 2021 22:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=yQcCnm71POKPspvsCR8hPl9CQM1ZzKCtB7/29ffYXws=;
        b=zcXwDtAoAGAKI5sLfzNsFhs1A1ULfSRoyO26GxwHxPRq7+JljLRc+p6UT5sQVsUoRR
         yr5q/VHr/ia/32yfuji3UyBfC6YZpZ65i0Opjyt+diYsXgsaCHLJHYwEVYpIPoFwNXtj
         Jm3t9UTjyRdsc4tr+cHxxcqnhHXlfxAMk9WBjh9X0cu7VHQvXiCHi5UCGA0k9hUMnGu1
         hQ5qB4dDYJVXGeyHnRVnDFasMtaXkb5lowufMqw7lHhXbcLIrQTDuVAqQScClGVA/A0j
         W1c6/iQs+hoAYOxJ3uKkewDZP0CZQ7950yuUTnLPE6UUJ+YJNpZCCc+YZiDNfnyn/h71
         QzeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=yQcCnm71POKPspvsCR8hPl9CQM1ZzKCtB7/29ffYXws=;
        b=BaitNH+HXMp9gTczDC7qD1LxV4Wo/eQEwn9rxbKXCMiZYD4Rrf6gjGIgKfe6mwqD4I
         R6TyI/1Wca7dipawHN6bUuIlIrP8vDf4dD2huRQfc1KfB/qodVL/H5DLl+SZEmr2frky
         SlHMBr98OHjP5XWiBr0LzZtZxoNgNpdV4dt1jN43qgn6byWLosYNativZ5yJ+H58nCTx
         DUGWVNlkTn7+Mxd2LvMesJWUCt2ZMYvYBhC7jC3PHPHvSrXxOQtC3Md+ROokUWdsfVya
         sL0+WGG35RLFwHyBuKQOfP/ngSrUSPW3SA8sHNZ3h7bEQq0MU49PjcN5HutS/xEiDf/r
         XgrQ==
X-Gm-Message-State: AOAM530fGmb+zUDLnwyw9oqsOfyWDUJ+IpUNAlufj4RrYZIB8A4COXlI
        S0jiHxtGJBtmCfW1lg0M+nyvaA==
X-Google-Smtp-Source: ABdhPJzp5yqlNn9XN4uPF9c7nAWZA+XWtd3Sy4mLI0yHOOtqINMGwFy8UQ5m7lSjFwEUB/r32ixK0Q==
X-Received: by 2002:a63:a4d:: with SMTP id z13mr1809168pgk.445.1629178876720;
        Mon, 16 Aug 2021 22:41:16 -0700 (PDT)
Received: from [10.255.196.46] ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id q3sm1287686pgf.18.2021.08.16.22.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 22:41:16 -0700 (PDT)
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhoufeng.zf@bytedance.com
From:   chenying <chenying.kernel@bytedance.com>
Subject: ovl: fix BUG_ON() in may_delete() when called from ovl_cleanup
Message-ID: <e6496a94-a161-dc04-c38a-d2544633acb4@bytedance.com>
Date:   Tue, 17 Aug 2021 13:41:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 From ee4466d66af5d214edb306dbf7f456e21cbb73ac Mon Sep 17 00:00:00 2001
From: chenying <chenying.kernel@bytedance.com>
Date: Mon, 16 Aug 2021 18:02:56 +0800
Subject: [PATCH] ovl: fix BUG_ON() in may_delete() when called from 
ovl_cleanup

If function ovl_instantiate returns an error, ovl_cleanup will be called
and try to remove newdentry from wdir, but the newdentry has been moved to
udir at this time. This will causes BUG_ON(victim->d_parent->d_inode !=
dir) in fs/namei.c:may_delete.

[25355953.608321] overlayfs: failed to get inode (-116)
[25355953.608337] ------------[ cut here ]------------
[25355953.608338] kernel BUG at fs/namei.c:2800!
[25355953.610787] invalid opcode: 0000 [#1] SMP NOPTI
[25355953.612694] CPU: 75 PID: 3739998 Comm: dockerd Kdump: loaded 
Tainted: G        W  OE     4.19.117.bsk.4-amd64 #4.19.117.bsk.4
[25355953.617046] Hardware name: Inspur NF5266M5/YZMB-01229-103, BIOS 
3.1.3 06/24/2020
[25355953.618920] RIP: 0010:may_delete+0x16f/0x190
[25355953.621120] Code: 00 3d 00 00 20 00 74 12 41 bd ec ff ff ff 5b 44 
89 e8 5d 41 5c 41 5d 41 5e c3 48 3b 5b 18 75 94 41 bd f0 ff ff ff eb a2 
0f 0b <0f> 0b 41 bd fe ff ff ff eb 96 41 bd eb ff ff ff eb 8e 41 bd b5 ff
[25355953.625147] RSP: 0018:ffff9aad5c09bb30 EFLAGS: 00010206
[25355953.627562] RAX: ffff8ebceb709b00 RBX: ffff8e73262c3800 RCX: 
0000000200000000
[25355953.629381] RDX: 0000000000000000 RSI: ffff8e73262c3800 RDI: 
ffff8e71e22b1ee0
[25355953.631562] RBP: ffff8e71e22b3000 R08: 0000000000000038 R09: 
ffff8e73262c2300
[25355953.633571] R10: ffff9aad5c09bae0 R11: 0000000000000000 R12: 
ffff8e71e22b4568
[25355953.635193] R13: ffff8e71e22b3000 R14: ffff8ebceb709080 R15: 
0000000000000000
[25355953.637280] FS:  00007f3e77fff700(0000) GS:ffff8eceff6c0000(0000) 
knlGS:0000000000000000
[25355953.639360] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25355953.640935] CR2: 0000000017fe3000 CR3: 0000000161380004 CR4: 
00000000007606e0
[25355953.642878] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[25355953.644835] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[25355953.646305] PKRU: 55555554
[25355953.647995] Call Trace:
[25355953.649891]  vfs_unlink+0x23/0x180
[25355953.651891]  ovl_cleanup+0x36/0xb0 [overlay]
[25355953.653682]  ovl_create_or_link+0x47a/0x600 [overlay]
[25355953.655569]  ? inode_init_always+0x13e/0x1f0
[25355953.657377]  ? inode_sb_list_add+0x47/0x80
[25355953.659083]  ? ovl_fill_inode+0x34/0x130 [overlay]
[25355953.660730]  ovl_create_object+0xd9/0x110 [overlay]
[25355953.662392]  path_openat+0x1351/0x1430
[25355953.663961]  ? terminate_walk+0xdd/0x100
[25355953.665605]  ? ext4_getattr+0x7f/0x90 [ext4]
[25355953.667019]  ? ovl_getattr+0x138/0x3c0 [overlay]
[25355953.668075]  do_filp_open+0x99/0x110
[25355953.669180]  ? __check_object_size+0x166/0x1b0
[25355953.670485]  ? do_sys_open+0x12e/0x210
[25355953.671811]  do_sys_open+0x12e/0x210
[25355953.672966]  do_syscall_64+0x5d/0x110
[25355953.673880]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: chenying <chenying.kernel@bytedance.com>
---
  fs/overlayfs/dir.c | 6 ++++--
  1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 93efe7048a77..7c1850adec28 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -542,8 +542,10 @@ static int ovl_create_over_whiteout(struct dentry 
*dentry, struct inode *inode,
                         goto out_cleanup;
         }
         err = ovl_instantiate(dentry, inode, newdentry, hardlink);
-       if (err)
-               goto out_cleanup;
+       if (err) {
+               ovl_cleanup(udir, newdentry);
+               dput(newdentry);
+       }
  out_dput:
         dput(upper);
  out_unlock:
--
2.11.0

