Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA60C4338F
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Aug 2021 15:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2563760EE4
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Aug 2021 15:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhHQPkA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 11:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbhHQPj6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Aug 2021 11:39:58 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13419C061764
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Aug 2021 08:39:25 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id g1so13395048vsq.7
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Aug 2021 08:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JBTfnUrOXPoVHjOY7K2K3BUVZcH0TAcexI/mEMvT9EQ=;
        b=Gs41cMZr3xIq2z+aDA3/oQODbeG3A321dsDNymRD1Zj+9i2Xzrx1wYwlmyTxQ7qYTW
         hhKBHB00QiJ9kGsY4n5MMOo/Ai01QcBs7rfCY6xIhQbjyWXqeFBibKJL+P/N/cDTbHIk
         8zBeOOn/gzk1u4PqTWzJ4i/YJ79mvhVOqJuNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JBTfnUrOXPoVHjOY7K2K3BUVZcH0TAcexI/mEMvT9EQ=;
        b=qBvXPAYFwHpvIj275gAycbI3iLVPED5X9TiAPSSe5pZe9d9h6Q/9d8gG7PFdAbADox
         tkZ+vqeClF6sJwjuObuda+YLrFLT+PxBcLT+gmyQzwbsJMdoyx8KG00erZiXCRPAKuAX
         yDL7p8iWg3raTEYQnH+4rQTZyVGCYe2jlzZYG5BObXL2+KjcdYo+1uCpZJywTGvT1sPg
         0odZ8kjh4E6YaQuLHdMIxXvZtnK3jufRGAfow+s4mh8CwLiv7zw1BFtEm0e4j1+pDArU
         a9khUNmWXwHcfnB7MiHU1lbE1dlujNm2rDuel+OjQUP216aInDF2zTDFannD1ob1etC7
         S4kA==
X-Gm-Message-State: AOAM5329plbQ0ya0gCWoE/+bW6WMzUGbQMCCua35AcBatMZamGJHI08n
        mXOYhC1ymuDq326LQL3XsHf9Jnp9901FZKC9NrQ+2g==
X-Google-Smtp-Source: ABdhPJxA1UnCU/eplyw2lV0XlTEHG3pJV4+LYleZ3aBEUv+CaugCkMlKR5JnbeKOniFQd59mVYS9xtkgQGrSQNUbVAM=
X-Received: by 2002:a67:5c41:: with SMTP id q62mr3576658vsb.7.1629214764160;
 Tue, 17 Aug 2021 08:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <e6496a94-a161-dc04-c38a-d2544633acb4@bytedance.com>
In-Reply-To: <e6496a94-a161-dc04-c38a-d2544633acb4@bytedance.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 17 Aug 2021 17:39:13 +0200
Message-ID: <CAJfpegt_EZRPbQLbcHRXD9Yx9zvcKmgos=u79k=kgKwd0LWzaA@mail.gmail.com>
Subject: Re: ovl: fix BUG_ON() in may_delete() when called from ovl_cleanup
To:     chenying <chenying.kernel@bytedance.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, zhoufeng.zf@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 17 Aug 2021 at 07:41, chenying <chenying.kernel@bytedance.com> wrote:
>
>  From ee4466d66af5d214edb306dbf7f456e21cbb73ac Mon Sep 17 00:00:00 2001
> From: chenying <chenying.kernel@bytedance.com>
> Date: Mon, 16 Aug 2021 18:02:56 +0800
> Subject: [PATCH] ovl: fix BUG_ON() in may_delete() when called from
> ovl_cleanup
>
> If function ovl_instantiate returns an error, ovl_cleanup will be called
> and try to remove newdentry from wdir, but the newdentry has been moved to
> udir at this time. This will causes BUG_ON(victim->d_parent->d_inode !=
> dir) in fs/namei.c:may_delete.
>
> [25355953.608321] overlayfs: failed to get inode (-116)
> [25355953.608337] ------------[ cut here ]------------
> [25355953.608338] kernel BUG at fs/namei.c:2800!
> [25355953.610787] invalid opcode: 0000 [#1] SMP NOPTI
> [25355953.612694] CPU: 75 PID: 3739998 Comm: dockerd Kdump: loaded
> Tainted: G        W  OE     4.19.117.bsk.4-amd64 #4.19.117.bsk.4
> [25355953.617046] Hardware name: Inspur NF5266M5/YZMB-01229-103, BIOS
> 3.1.3 06/24/2020
> [25355953.618920] RIP: 0010:may_delete+0x16f/0x190
> [25355953.621120] Code: 00 3d 00 00 20 00 74 12 41 bd ec ff ff ff 5b 44
> 89 e8 5d 41 5c 41 5d 41 5e c3 48 3b 5b 18 75 94 41 bd f0 ff ff ff eb a2
> 0f 0b <0f> 0b 41 bd fe ff ff ff eb 96 41 bd eb ff ff ff eb 8e 41 bd b5 ff
> [25355953.625147] RSP: 0018:ffff9aad5c09bb30 EFLAGS: 00010206
> [25355953.627562] RAX: ffff8ebceb709b00 RBX: ffff8e73262c3800 RCX:
> 0000000200000000
> [25355953.629381] RDX: 0000000000000000 RSI: ffff8e73262c3800 RDI:
> ffff8e71e22b1ee0
> [25355953.631562] RBP: ffff8e71e22b3000 R08: 0000000000000038 R09:
> ffff8e73262c2300
> [25355953.633571] R10: ffff9aad5c09bae0 R11: 0000000000000000 R12:
> ffff8e71e22b4568
> [25355953.635193] R13: ffff8e71e22b3000 R14: ffff8ebceb709080 R15:
> 0000000000000000
> [25355953.637280] FS:  00007f3e77fff700(0000) GS:ffff8eceff6c0000(0000)
> knlGS:0000000000000000
> [25355953.639360] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [25355953.640935] CR2: 0000000017fe3000 CR3: 0000000161380004 CR4:
> 00000000007606e0
> [25355953.642878] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [25355953.644835] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [25355953.646305] PKRU: 55555554
> [25355953.647995] Call Trace:
> [25355953.649891]  vfs_unlink+0x23/0x180
> [25355953.651891]  ovl_cleanup+0x36/0xb0 [overlay]
> [25355953.653682]  ovl_create_or_link+0x47a/0x600 [overlay]
> [25355953.655569]  ? inode_init_always+0x13e/0x1f0
> [25355953.657377]  ? inode_sb_list_add+0x47/0x80
> [25355953.659083]  ? ovl_fill_inode+0x34/0x130 [overlay]
> [25355953.660730]  ovl_create_object+0xd9/0x110 [overlay]
> [25355953.662392]  path_openat+0x1351/0x1430
> [25355953.663961]  ? terminate_walk+0xdd/0x100
> [25355953.665605]  ? ext4_getattr+0x7f/0x90 [ext4]
> [25355953.667019]  ? ovl_getattr+0x138/0x3c0 [overlay]
> [25355953.668075]  do_filp_open+0x99/0x110
> [25355953.669180]  ? __check_object_size+0x166/0x1b0
> [25355953.670485]  ? do_sys_open+0x12e/0x210
> [25355953.671811]  do_sys_open+0x12e/0x210
> [25355953.672966]  do_syscall_64+0x5d/0x110
> [25355953.673880]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Signed-off-by: chenying <chenying.kernel@bytedance.com>

Thanks, applied.

Miklos
