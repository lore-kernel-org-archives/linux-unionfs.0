Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C35C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Feb 2021 10:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C0E64DA5
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Feb 2021 10:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhBAKIG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 05:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhBAKHT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Feb 2021 05:07:19 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041BEC061756;
        Mon,  1 Feb 2021 02:06:39 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id x21so16707184iog.10;
        Mon, 01 Feb 2021 02:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7TfQmnWXMLDV4KK/yrcdrfGH4xnHu8H2yQVDi+jxI8o=;
        b=DcJodsdGPhHoTDR0XCKR/FQyAr+wuYt54P6QT5FfSC/v5mZ8yxDOGKaT0ZV41Bm2Vz
         THVPeBLfJjSFx+FdWrG2sk9ZaqtC1RM5lyvxy/uW4JJbWGNIdF5fR4YpVZowNfyDGl00
         AtoK2G8aKQJjvRAtaGbvTObHrr6dCyV1/lAFxBMoD9GJxkmjQt4HXrNwwhmb0IdXZgyK
         aBvzRE54rJQsrOtT99uOrus5nNMztvpC+lVvj0lNwUusdKi7ckxGvNxaX5WbzG9syErG
         RWWACUUTqg3mmHiW8CxAotcTMpx6ZH8w45jwPJY5nVqoExc8WJ69Hadp5VS348+C3Wxt
         UmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7TfQmnWXMLDV4KK/yrcdrfGH4xnHu8H2yQVDi+jxI8o=;
        b=hdFeGUV8PpCNluI2V8evdDx/DejVx18tChxdT8/s1dcDJuvL8eau0Wv9fTGxCX/zvv
         WiKpJKx3LSruwjWTWi5xApHleCsxFALWthdVa8NYLMp7UV5/5M3hjXPMRVufTP7mlvXx
         M2MyS9VfZl7MaRFGS6WKBCioWNTO6iXvQhc+RWTnuPX6cvE5NnuR+8cQuJrFYxzYDUMq
         lXQY0N3yVaIXZRuimxlijVSSXJ9fsfXtmWRzLjNU01fYavya+wfLvkRgBbxF3fLuXNFv
         AtNHyo3O50pQTKliJLWZRRNZe1fJtPsQEwdNhqpnu7oBSEEHLQvz64dl96dkbN2q1stz
         HYwQ==
X-Gm-Message-State: AOAM5332POQ6AZMym8gvNnFgCJ+PTgJm5JjwZ9eiCDNOIm7Pj/tXc1G0
        r+HW0VrWvfSjdaopHU/ODcrpoNkX2Giz2uKf7KY=
X-Google-Smtp-Source: ABdhPJyEfujie8aFaCvV9ytfbM2Mtx4GZXZgdspt0XnngJwS0diLdConHLVDXJLB3KzTpQt1ZOrC0rY0cE05tj5ntks=
X-Received: by 2002:a02:c98b:: with SMTP id b11mr4313067jap.123.1612173998414;
 Mon, 01 Feb 2021 02:06:38 -0800 (PST)
MIME-Version: 1.0
References: <0000000000006689ee05ba42aa3d@google.com>
In-Reply-To: <0000000000006689ee05ba42aa3d@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 1 Feb 2021 12:06:27 +0200
Message-ID: <CAOQ4uxirYSKzhPOYwnZy=BjvNiJyAcwZoVvde28aYG=7zcAJpg@mail.gmail.com>
Subject: Re: WARNING: suspicious RCU usage in kernfs_iop_permission
To:     syzbot <syzbot+0e507d08417ca2d565bf@syzkaller.appspotmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Feb 1, 2021 at 11:06 AM syzbot
<syzbot+0e507d08417ca2d565bf@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    6642d600 Merge tag '5.11-rc5-smb3' of git://git.samba.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=171405bf500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9408d1770a50819c
> dashboard link: https://syzkaller.appspot.com/bug?extid=0e507d08417ca2d565bf
> compiler:       clang version 11.0.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b8a330d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f3628cd00000
>
> The issue was bisected to:
>
> commit 89bdfaf93d9157499c3a0d61f489df66f2dead7f
> Author: Miklos Szeredi <mszeredi@redhat.com>
> Date:   Mon Dec 14 14:26:14 2020 +0000
>
>     ovl: make ioctl() safe
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11b85fb4d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13b85fb4d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15b85fb4d00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0e507d08417ca2d565bf@syzkaller.appspotmail.com
> Fixes: 89bdfaf93d91 ("ovl: make ioctl() safe")
>
> =============================
> WARNING: suspicious RCU usage
> 5.11.0-rc5-syzkaller #0 Not tainted
> -----------------------------
> kernel/sched/core.c:7932 Illegal context switch in RCU-sched read-side critical section!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 0
> no locks held by systemd/1.
>
> stack backtrace:
> CPU: 0 PID: 1 Comm: systemd Not tainted 5.11.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x137/0x1be lib/dump_stack.c:120
>  ___might_sleep+0xb4/0x530 kernel/sched/core.c:7932
>  __mutex_lock_common+0x4e/0x2f00 kernel/locking/mutex.c:935
>  __mutex_lock kernel/locking/mutex.c:1103 [inline]
>  mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
>  kernfs_iop_permission+0x66/0x2f0 fs/kernfs/inode.c:284
>  do_inode_permission fs/namei.c:398 [inline]
>  inode_permission+0x234/0x4a0 fs/namei.c:463
>  may_lookup fs/namei.c:1575 [inline]
>  link_path_walk+0x226/0xc10 fs/namei.c:2128
>  path_openat+0x1f5/0x37a0 fs/namei.c:3367
>  do_filp_open+0x191/0x3a0 fs/namei.c:3398
>  do_sys_openat2+0xba/0x380 fs/open.c:1172
>  do_sys_open fs/open.c:1188 [inline]
>  __do_sys_open fs/open.c:1196 [inline]
>  __se_sys_open fs/open.c:1192 [inline]
>  __x64_sys_open+0x1af/0x1e0 fs/open.c:1192
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7fdaf5f1370d
> Code: 30 2c 00 00 75 10 b8 02 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe 9d 01 00 48 89 04 24 b8 02 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 47 9e 01 00 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:00007ffedccb56f0 EFLAGS: 00000293 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 000055b998e80590 RCX: 00007fdaf5f1370d
> RDX: 00000000000001b6 RSI: 0000000000080000 RDI: 00007ffedccb57d0
> RBP: 0000000000000008 R08: 0000000000000008 R09: 0000000000000001
> R10: 0000000000080000 R11: 0000000000000293 R12: 00007fdaf764d7b4
> R13: 0000000000000001 R14: 000055b998d5ad60 R15: 00007ffedccb57d0
>
>

The bisection result is questionable.
The repro does ioctl NS_GET_OWNER_UID which should not be hitting
any code affected by the bisected commit.

If anything I would also try:

#syz fix: ovl: avoid deadlock on directory ioctl

Perhaps a lock left help by some ioctl that happened before the repro has
caused this report.

Thanks,
Amir.
