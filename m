Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DA8C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Feb 2021 09:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EE0A64D73
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Feb 2021 09:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhBAJTa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 04:19:30 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:42740 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbhBAJSB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Feb 2021 04:18:01 -0500
Received: by mail-il1-f200.google.com with SMTP id i16so13109256ila.9
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Feb 2021 01:17:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=b4WyNj/mYmWoFnb16jtfXo7YU8unzJ8Ax1ZCNtN8gHQ=;
        b=qBojcKpOqFFQNm2NTFqUjlR/n6kJuVMtkRw4AbGN7YcjG5C3CYjMRsrcuJ4oWTz3S+
         kWhAjWAOwUcp+dNehNB1voZzFVkjOPCNW9acniYWsVnQZIBCS0Ampnn6BlnAOVe4rIRL
         93O3pUQeAamomhJ2dB0Ff/Vi83q8wqcPWw81xf58h8cSves12x2RyFF9c8TATQs7oq1T
         Q1r5dTpLRr0CBVqB7OgYzd2dvHfmHppbu4fJThEnl5JKgT/P7J1DtC8k0Kw8JQ1VRqbL
         leTV0RNTil+VjToM9aSykBzuDjF+fbjQlWiGnksOhAUm796yEfbwSp75INSjysv8Eadf
         RuLA==
X-Gm-Message-State: AOAM532pDxjjDkqtZCepd8wr8u7R0ORkyg4MRkKbQWTMEhOgInliZxTW
        mmBLrSJJJFytF5lWh/eNgdEN0yurD5Vp8OVfdg496Rmq87rC
X-Google-Smtp-Source: ABdhPJzfYJvL+V2Mnhtcr53eabCrWQvAnphqYRcNj2x1g0l2aVRxHSC12GrMlkHiGzDdOpaHc32WgVNwpG9u2ZfvKi37xa2123ct
MIME-Version: 1.0
X-Received: by 2002:a5e:9416:: with SMTP id q22mr1522792ioj.98.1612171033720;
 Mon, 01 Feb 2021 01:17:13 -0800 (PST)
Date:   Mon, 01 Feb 2021 01:17:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c83a9705ba42d18d@google.com>
Subject: possible deadlock in ovl_dir_real_file
From:   syzbot <syzbot+6a023cb2262c79301432@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6642d600 Merge tag '5.11-rc5-smb3' of git://git.samba.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=148aef78d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9408d1770a50819c
dashboard link: https://syzkaller.appspot.com/bug?extid=6a023cb2262c79301432
compiler:       clang version 11.0.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6a023cb2262c79301432@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.11.0-rc5-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.2/3639 is trying to acquire lock:
ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: inode_lock include/linux/fs.h:773 [inline]
ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: ovl_dir_real_file+0x20b/0x310 fs/overlayfs/readdir.c:886

but task is already holding lock:
ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: inode_lock include/linux/fs.h:773 [inline]
ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: ovl_ioctl_set_flags fs/overlayfs/file.c:530 [inline]
ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: ovl_ioctl+0x2fb/0x960 fs/overlayfs/file.c:569

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ovl_i_mutex_dir_key[depth]);
  lock(&ovl_i_mutex_dir_key[depth]);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor.2/3639:
 #0: ffff88807a706460 (sb_writers#17){.+.+}-{0:0}, at: mnt_want_write_file+0x5a/0x250 fs/namespace.c:412
 #1: ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: inode_lock include/linux/fs.h:773 [inline]
 #1: ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: ovl_ioctl_set_flags fs/overlayfs/file.c:530 [inline]
 #1: ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: ovl_ioctl+0x2fb/0x960 fs/overlayfs/file.c:569

stack backtrace:
CPU: 1 PID: 3639 Comm: syz-executor.2 Not tainted 5.11.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x137/0x1be lib/dump_stack.c:120
 __lock_acquire+0x2333/0x5e90 kernel/locking/lockdep.c:4670
 lock_acquire+0x114/0x5e0 kernel/locking/lockdep.c:5442
 down_write+0x56/0x120 kernel/locking/rwsem.c:1406
 inode_lock include/linux/fs.h:773 [inline]
 ovl_dir_real_file+0x20b/0x310 fs/overlayfs/readdir.c:886
 ovl_real_fdget fs/overlayfs/file.c:136 [inline]
 ovl_real_ioctl fs/overlayfs/file.c:499 [inline]
 ovl_ioctl_set_flags fs/overlayfs/file.c:545 [inline]
 ovl_ioctl+0x4de/0x960 fs/overlayfs/file.c:569
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f02ed677c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000040086602 RDI: 0000000000000003
RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffd373df6ef R14: 00007f02ed6789c0 R15: 000000000119bf8c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
