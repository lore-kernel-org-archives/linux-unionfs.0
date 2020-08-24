Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B04C433E4
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 21:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DD7120866
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 21:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fEvAEdk/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgHXVAZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:00:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43576 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726939AbgHXVAW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 17:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598302820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dArBMjBu6Yjd06FGK20jndZ6EdlklVUmvStH3WB7sTA=;
        b=fEvAEdk/wHdCmDoaAxCRLXi4jhZpsjJLW3khLGEvUOcux8XdzgOvZRNGJ6Enpp3mck7IjT
        JzMhHqTIA5zFmBJgZ0/7hLcQtWOgghZpJCAe58etuO73b4oQT0GWeMXMON04q2wmjP6dXg
        LNyIDu9jkT5m433fUvHLxrKA0UrOUeI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-vxPa2lyXMhWzoi3-oqgdwA-1; Mon, 24 Aug 2020 17:00:14 -0400
X-MC-Unique: vxPa2lyXMhWzoi3-oqgdwA-1
Received: by mail-lf1-f69.google.com with SMTP id n72so134770lfa.10
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 14:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dArBMjBu6Yjd06FGK20jndZ6EdlklVUmvStH3WB7sTA=;
        b=TIbwKTolIeVMSx/TYmPTwtAXCJjZlES2vSiPMgiC4S4T06Sr/6NCfA84pbE4Vw6EbG
         0qnL6QV51OcUBMLNU+2d3m/paxst/Dgv4zF5MpS2WKBxgV03F+7z/qd5iOJt+tGJ8eyT
         ULxe3BUkwcp/UnQH2YN8FLjEUGk9sKPCalXbJ1qpQAq1PLJJyM3NFw0eWwdc0GiEDwaj
         QLGeemwSsPCsOs0Evvvf6F9pKgng9awb31z0oAf5ynB+Mb6ID/kKk3q9XQB7VmYtztSi
         lKP2Trf57GTAGBj1STizUpO5JWpHhLi8TP2SGvbuzkRBNbEBL789TskYLg9ej5gK3I4r
         4NqQ==
X-Gm-Message-State: AOAM530NTMCrQU1RaCenZ8h743JHEueJhlvOgBE6W/XfUIvkEjdmD2WP
        KUCOcXt1j+iMcaaa020J4ghj+zm4X8fbZ2ka2gfI89XCM8kcFTsCoy3PGjvHcNCzdUqbuYAWeSC
        v92A+4kLFEj6pAFeR9Dv7Rtc4QYl0tI9LJa0VFcP+UA==
X-Received: by 2002:ac2:568b:: with SMTP id 11mr3362059lfr.87.1598302811940;
        Mon, 24 Aug 2020 14:00:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyh510SXVhjTJ4fo6qnIoXsDmjw+4kFDJo+p6bMWy1uCQEAElrM7xxXDoIBq3WLL1m/FjtxmlH9uAoJXx9nXns=
X-Received: by 2002:ac2:568b:: with SMTP id 11mr3362038lfr.87.1598302811601;
 Mon, 24 Aug 2020 14:00:11 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008caae305ab9a5318@google.com> <000000000000a726a405ada4b6cf@google.com>
In-Reply-To: <000000000000a726a405ada4b6cf@google.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 24 Aug 2020 23:00:00 +0200
Message-ID: <CAFqZXNvQcjp201ahjLBhYJJCuYqZrYLGDA-wE3hXiJpRNgbTKg@mail.gmail.com>
Subject: Re: general protection fault in security_inode_getattr
To:     syzbot <syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        James Morris <jmorris@namei.org>, john.fastabend@gmail.com,
        kafai@fb.com, KP Singh <kpsingh@chromium.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        linux-fsdevel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 24, 2020 at 9:37 PM syzbot
<syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com> wrote:
> syzbot has found a reproducer for the following issue on:

Looping in fsdevel and OverlayFS maintainers, as this seems to be
FS/OverlayFS related...

See also original report against 5.8-rc7:
https://lore.kernel.org/linux-security-module/0000000000008caae305ab9a5318@google.com/T/

>
> HEAD commit:    d012a719 Linux 5.9-rc2
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14aa130e900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=891ca5711a9f1650
> dashboard link: https://syzkaller.appspot.com/bug?extid=f07cc9be8d1d226947ed
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104a650e900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com
>
> general protection fault, probably for non-canonical address 0xdffffc000000000d: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
> CPU: 1 PID: 32288 Comm: syz-executor.3 Not tainted 5.9.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:d_backing_inode include/linux/dcache.h:549 [inline]
> RIP: 0010:security_inode_getattr+0x42/0x140 security/security.c:1276
> Code: 1b fe 49 8d 5e 08 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 bc b4 5b fe 48 8b 1b 48 83 c3 68 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 9f b4 5b fe 48 8b 1b 48 83 c3 0c
> RSP: 0018:ffffc9000a017750 EFLAGS: 00010202
> RAX: 000000000000000d RBX: 0000000000000068 RCX: ffff888093ec6180
> RDX: 0000000000000000 RSI: ffffc9000a017860 RDI: ffffc9000a017850
> RBP: ffffc9000a017850 R08: dffffc0000000000 R09: ffffc9000a017850
> R10: fffff52001402f0c R11: 0000000000000000 R12: ffffc9000a017860
> R13: 0000000000008401 R14: ffffc9000a017850 R15: dffffc0000000000
> FS:  00007f292d4ef700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30920074 CR3: 00000000937fd000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  vfs_getattr+0x21/0x60 fs/stat.c:121
>  ovl_copy_up_one fs/overlayfs/copy_up.c:850 [inline]
>  ovl_copy_up_flags+0x2ef/0x2a00 fs/overlayfs/copy_up.c:931
>  ovl_maybe_copy_up+0x154/0x180 fs/overlayfs/copy_up.c:963
>  ovl_open+0xa2/0x200 fs/overlayfs/file.c:147
>  do_dentry_open+0x7c8/0x1010 fs/open.c:817
>  do_open fs/namei.c:3251 [inline]
>  path_openat+0x2794/0x3840 fs/namei.c:3368
>  do_filp_open+0x191/0x3a0 fs/namei.c:3395
>  file_open_name+0x321/0x430 fs/open.c:1113
>  acct_on kernel/acct.c:207 [inline]
>  __do_sys_acct kernel/acct.c:286 [inline]
>  __se_sys_acct+0x122/0x6f0 kernel/acct.c:273
>  do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45d579
> Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f292d4eec78 EFLAGS: 00000246 ORIG_RAX: 00000000000000a3
> RAX: ffffffffffffffda RBX: 0000000000000700 RCX: 000000000045d579
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000040
> RBP: 000000000118cf70 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
> R13: 00007ffc8e04bc4f R14: 00007f292d4ef9c0 R15: 000000000118cf4c
> Modules linked in:
> ---[ end trace 7e4f1041b188e411 ]---
> RIP: 0010:d_backing_inode include/linux/dcache.h:549 [inline]
> RIP: 0010:security_inode_getattr+0x42/0x140 security/security.c:1276
> Code: 1b fe 49 8d 5e 08 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 bc b4 5b fe 48 8b 1b 48 83 c3 68 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 9f b4 5b fe 48 8b 1b 48 83 c3 0c
> RSP: 0018:ffffc9000a017750 EFLAGS: 00010202
> RAX: 000000000000000d RBX: 0000000000000068 RCX: ffff888093ec6180
> RDX: 0000000000000000 RSI: ffffc9000a017860 RDI: ffffc9000a017850
> RBP: ffffc9000a017850 R08: dffffc0000000000 R09: ffffc9000a017850
> R10: fffff52001402f0c R11: 0000000000000000 R12: ffffc9000a017860
> R13: 0000000000008401 R14: ffffc9000a017850 R15: dffffc0000000000
> FS:  00007f292d4ef700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fef820e7000 CR3: 00000000937fd000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>

-- 
Ondrej Mosnacek
Software Engineer, Platform Security - SELinux kernel
Red Hat, Inc.

