Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFE7C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Sep 2021 15:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F5561107
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Sep 2021 15:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345050AbhIGPQV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Sep 2021 11:16:21 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44968 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345037AbhIGPQV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Sep 2021 11:16:21 -0400
Received: by mail-io1-f71.google.com with SMTP id d15-20020a0566022befb02905b2e9040807so7465776ioy.11
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Sep 2021 08:15:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dAC0ehQqSL3LXf3Hlk97dfq/+ThOu7yS5FU81XRTVbQ=;
        b=r8BSB/OVFTS3AEdhSFlZl4Vx5nfIQaC3LLeZ05SVVkgh22UAwUo1PD8IFOWNLC0Ks6
         8tB2j9mYCELhaTzNvi4ag6yZe7s576h3O9yVV4+m8C4uDxLf6einmKjHAKuAKJnTOhc7
         WGmibdd2eaUQ/eVslAUgUEcnzG4ea/OZ3lI890srx35mLTgqCM5W3ok58e083waTnzfJ
         DONn/ulbKLQTXj0v18LUR/RWiqySJoIW9sKf+iEt0iswCSBK/fWaUl6Z+w/burFAmcT1
         g/Eh/x09Vg08OEzCon3qe+zWD43t/WdhMBqAKzm9ZJYerTKO6cSxov4EKkDJbYM+qNqM
         a3+g==
X-Gm-Message-State: AOAM5315JLxQ7FGm+woE+xp6teH431E9+MJ0KJP14Wxw8sYOW/Z8klKQ
        T+GEXLRkAmayna8XJtTCaZmUHpyKyAllEOYQG4nEbBOpQWoI
X-Google-Smtp-Source: ABdhPJyWPBb/lQbdU6ZkggxWdWQn90GY2+gBfEII6wnYfsTT/HzIlljaPaCIDLO9zz6oR4MI6S3sTKbUfamOpUmpk5nZgDk/g4RY
MIME-Version: 1.0
X-Received: by 2002:a05:6638:38d:: with SMTP id y13mr15549698jap.139.1631027714506;
 Tue, 07 Sep 2021 08:15:14 -0700 (PDT)
Date:   Tue, 07 Sep 2021 08:15:14 -0700
In-Reply-To: <CAJfpegvOa5cT5eRTsaMtAJ0YfZ1ob_kuW-NNK-emu3ncp2pK7A@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008ac5d405cb693b63@google.com>
Subject: Re: [syzbot] WARNING in ovl_create_real
From:   syzbot <syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in ovl_create_real

overlayfs: negative dentry after mkdir (cgroup2)
------------[ cut here ]------------
WARNING: CPU: 0 PID: 10918 at fs/overlayfs/dir.c:218 ovl_create_real.cold+0x80/0x1e3 fs/overlayfs/dir.c:216
Modules linked in:
CPU: 0 PID: 10918 Comm: syz-executor.0 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ovl_create_real.cold+0x80/0x1e3 fs/overlayfs/dir.c:218
Code: 37 00 48 c1 e0 2a 48 89 da 48 c1 ea 03 80 3c 02 00 74 08 48 89 df e8 81 90 c3 f8 48 8b 33 48 c7 c7 20 0f c4 89 e8 90 73 f9 ff <0f> 0b 4c 89 e5 49 c7 c4 fb ff ff ff e9 5f c7 bb f9 e8 fc 4f 7c f8
RSP: 0018:ffffc9000cd47958 EFLAGS: 00010282
RAX: 0000000000000030 RBX: ffffffff8b9bea20 RCX: 0000000000000000
RDX: ffff8880131c3900 RSI: ffffffff815dcd38 RDI: fffff520019a8f1d
RBP: ffff88806ee38d38 R08: 0000000000000030 R09: 0000000000000000
R10: ffffffff815d6ade R11: 0000000000000000 R12: ffff88806ee38d38
R13: 0000000000004000 R14: ffff88806dd2ed90 R15: ffff88806dd2ee70
FS:  00007fb3f7195700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e370d81a70 CR3: 000000002184a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ovl_workdir_create+0x3a9/0x5b0 fs/overlayfs/super.c:790
 ovl_make_workdir fs/overlayfs/super.c:1364 [inline]
 ovl_get_workdir fs/overlayfs/super.c:1511 [inline]
 ovl_fill_super+0x199a/0x5fb0 fs/overlayfs/super.c:2067
 mount_nodev+0x60/0x110 fs/super.c:1414
 legacy_get_tree+0x105/0x220 fs/fs_context.c:610
 vfs_get_tree+0x89/0x2f0 fs/super.c:1498
 do_new_mount fs/namespace.c:2988 [inline]
 path_mount+0x1320/0x1fa0 fs/namespace.c:3318
 do_mount fs/namespace.c:3331 [inline]
 __do_sys_mount fs/namespace.c:3539 [inline]
 __se_sys_mount fs/namespace.c:3516 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3516
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb3f7195188 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 00000000200000c0 RSI: 0000000020000000 RDI: 000000000040000d
RBP: 00000000004bfcc4 R08: 0000000020000100 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffd2744f94f R14: 00007fb3f7195300 R15: 0000000000022000


Tested on:

commit:         4b93c544 thunderbolt: test: split up test cases in tb_..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13249aed300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f8c28906b7bb02d
dashboard link: https://syzkaller.appspot.com/bug?extid=75eab84fd0af9e8bf66b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10fc0943300000

