Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04275C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 22:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFFD22085B
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 22:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgEVWXU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 May 2020 18:23:20 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:55236 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731193AbgEVWXS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 May 2020 18:23:18 -0400
Received: by mail-io1-f69.google.com with SMTP id t23so8222911iog.21
        for <linux-unionfs@vger.kernel.org>; Fri, 22 May 2020 15:23:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ib8iwf4xOaH0Ndn5bAVIlh6KVenXo5kUkNI10opU8V4=;
        b=LUpxt+qXOZqVDR0tn0KiDHcKL8arwnS0VUR79FPMdrMMo1MNxt6FzJFEB3EJe1KsR5
         ZVxJeZC2i9fR9opCEUOzDjW8dNbDzt91Spq/VWxMORuVVXNTmmx1yUlachymiaTq8tck
         N98JUSAGc3eLrMBwExHNbGsrPbUQB9EVpyEaC6oJqyz3/LQPUUE6aVEf6HfQjFVcmL/I
         XEsaew14mTHJR6rz2RMeaZ0XJ423SmhRcFElJXths7LIstKqF36LR6v+BbEdPzRY0Uny
         NZUJoejWVKvBS8Jbcj1WlwDuJ85yP3rYE/OSqx9olY+Vweyw79lJ7SBCQ0uhCz2K9MXi
         2XNg==
X-Gm-Message-State: AOAM5302ynJ+ylYXC5pJdPs97vUUsHAOOq+dK7Cd0kRMe/Cc2Rhl+CWN
        konkmHrUtYWR+Cs+gJKzacZrYEI44lEIjjKMb8fiwqdv575f
X-Google-Smtp-Source: ABdhPJxIwwPr+Mk6Sj2l1Iz0pZf+2Zy9fft5amMeIxCemKISuwPCMBOEjP5gnRNPcXNrg39PPKXSapFW/lVX9zH64Urfz9SzsgDZ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1147:: with SMTP id o7mr15290844ill.51.1590186196587;
 Fri, 22 May 2020 15:23:16 -0700 (PDT)
Date:   Fri, 22 May 2020 15:23:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fd9aa05a6441365@google.com>
Subject: KASAN: slab-out-of-bounds Read in ovl_check_fb_len
From:   syzbot <syzbot+61958888b1c60361a791@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        mszeredi@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b85051e7 Merge tag 'fixes-for-5.7-rc6' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165d2b81100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3368ce0cc5f5ace
dashboard link: https://syzkaller.appspot.com/bug?extid=61958888b1c60361a791
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168e6272100000

The bug was bisected to:

commit cbe7fba8edfc8cb8e621599e376f8ac5c224fa72
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Fri Nov 15 11:33:03 2019 +0000

    ovl: make sure that real fid is 32bit aligned in memory

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11f95922100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13f95922100000
console output: https://syzkaller.appspot.com/x/log.txt?x=15f95922100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+61958888b1c60361a791@syzkaller.appspotmail.com
Fixes: cbe7fba8edfc ("ovl: make sure that real fid is 32bit aligned in memory")

==================================================================
BUG: KASAN: slab-out-of-bounds in ovl_check_fb_len+0x171/0x1a0 fs/overlayfs/namei.c:89
Read of size 1 at addr ffff88809727834d by task syz-executor.4/8488

CPU: 0 PID: 8488 Comm: syz-executor.4 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:382
 __kasan_report.cold+0x20/0x38 mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 ovl_check_fb_len+0x171/0x1a0 fs/overlayfs/namei.c:89
 ovl_check_fh_len fs/overlayfs/overlayfs.h:358 [inline]
 ovl_fh_to_dentry+0x1ab/0x814 fs/overlayfs/export.c:812
 exportfs_decode_fh+0x11f/0x717 fs/exportfs/expfs.c:434


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
