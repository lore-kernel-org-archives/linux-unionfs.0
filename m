Return-Path: <SRS0=xn9V=AI=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_DIGITS,
	FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86A2C433DF
	for <linux-unionfs@archiver.kernel.org>; Sat, 27 Jun 2020 07:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B252080C
	for <linux-unionfs@archiver.kernel.org>; Sat, 27 Jun 2020 07:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgF0HRO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 27 Jun 2020 03:17:14 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:56838 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgF0HRN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 27 Jun 2020 03:17:13 -0400
Received: by mail-il1-f200.google.com with SMTP id k13so7975581ilh.23
        for <linux-unionfs@vger.kernel.org>; Sat, 27 Jun 2020 00:17:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=O8yhhfv67XW37X/ycOvuxmls81kz3h5COJbT73m0epk=;
        b=DKa2Y2n64D0veNcP63nzEsMKR4fbl4dB6PGtEvyYi6WM7hqZ7j4aO0rJB1TBYRxOaj
         AEk8XpMFzhh0+8kHos6lEKQxInlfzbFQsHSyYLTId+zDryTZ9MXQtNc4e+rzv38Ls5KH
         yoVh0kv4yFnTuZdvW5NN6jnz+bgb4Sl+WNrMjAwt0JFw3rDrdkiazXmXjCdSAJ/AgYAd
         DmYXevnCZY6GdlbvIL2HWoQSwzi3eQ8fPumH/IrG2q2wkui/MfLD8BnMW6yCELDLHLGS
         HvpMSyCiX7udLUyzMAlrEQlpQIrHsQKQ+abh9XX6nm1rH8CgvwSN2r6AeMLUE6W9gUkD
         lHeQ==
X-Gm-Message-State: AOAM530j+pFI1hLLjY9nwr+R03qh9KypUyTj69uee5wNdaGyI6z62/UE
        gD9zGsieq2dNzIEPnpWOUEV67LPGjgbVgUnQXP9de8MXRgwO
X-Google-Smtp-Source: ABdhPJxPGS6BdRgguUJ51JPxBTwzwL2QYw2wEofGYanjclDQLhNfXox07Q3nOhjZcQwki9Ga0ax0N+sZGAuF6hUdS6CkGox/FSGD
MIME-Version: 1.0
X-Received: by 2002:a02:370b:: with SMTP id r11mr7073884jar.119.1593242232380;
 Sat, 27 Jun 2020 00:17:12 -0700 (PDT)
Date:   Sat, 27 Jun 2020 00:17:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004d61fe05a90b9db0@google.com>
Subject: WARNING in ovl_d_real
From:   syzbot <syzbot+3886b8b076850872876e@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11704e29100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be4578b3f1083656
dashboard link: https://syzkaller.appspot.com/bug?extid=3886b8b076850872876e
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3886b8b076850872876e@syzkaller.appspotmail.com

------------[ cut here ]------------
ovl_d_real(/file0, sda1:15683): real dentry not found
WARNING: CPU: 0 PID: 10016 at fs/overlayfs/super.c:112 ovl_d_real+0x1ec/0x300 fs/overlayfs/super.c:111
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 10016 Comm: syz-executor.3 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1ac/0x2d0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:105 [inline]
 do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:197
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:216
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:ovl_d_real+0x1ec/0x300 fs/overlayfs/super.c:111
Code: c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 1c b6 2b ff 49 8b 0c 24 48 c7 c7 56 03 ef 88 4c 89 f6 48 89 da 31 c0 e8 04 98 be fe <0f> 0b e9 c0 00 00 00 e8 c8 d1 ec fe e9 b3 00 00 00 e8 be d1 ec fe
RSP: 0018:ffffc90009507840 EFLAGS: 00010246
RAX: 83d49f6fcdb20800 RBX: ffff888099184698 RCX: 0000000000040000
RDX: ffffc9000fce2000 RSI: 00000000000137b1 RDI: 00000000000137b2
RBP: ffffffff88759760 R08: ffffffff815dd879 R09: ffffed1015d066c8
R10: ffffed1015d066c8 R11: 0000000000000000 R12: ffff8880514d62f8
R13: dffffc0000000000 R14: ffff88808ab6d170 R15: ffff8880887e7e60
 d_real include/linux/dcache.h:583 [inline]
 file_dentry include/linux/fs.h:1332 [inline]
 fscrypt_file_open+0x2a4/0x310 fs/crypto/hooks.c:41
 ext4_file_open+0x193/0x5b0 fs/ext4/file.c:811
 do_dentry_open+0x808/0x1020 fs/open.c:828
 open_with_fake_path+0x53/0x90 fs/open.c:976
 ovl_open_realfile fs/overlayfs/file.c:44 [inline]
 ovl_open+0x172/0x2b0 fs/overlayfs/file.c:139
 do_dentry_open+0x808/0x1020 fs/open.c:828
 do_open fs/namei.c:3229 [inline]
 path_openat+0x2790/0x38b0 fs/namei.c:3346
 do_filp_open+0x191/0x3a0 fs/namei.c:3373
 do_sys_openat2+0x463/0x770 fs/open.c:1179
 do_sys_open fs/open.c:1195 [inline]
 ksys_open include/linux/syscalls.h:1388 [inline]
 __do_sys_open fs/open.c:1201 [inline]
 __se_sys_open fs/open.c:1199 [inline]
 __x64_sys_open+0x1af/0x1e0 fs/open.c:1199
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45cb09
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc620690c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00000000004f7be0 RCX: 000000000045cb09
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000080
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000798 R14: 0000000000526dff R15: 00007fc6206916d4
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
