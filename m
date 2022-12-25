Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F68AC4332F
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Dec 2022 02:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiLYCQy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 24 Dec 2022 21:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLYCQx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 24 Dec 2022 21:16:53 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4F56377
        for <linux-unionfs@vger.kernel.org>; Sat, 24 Dec 2022 18:16:52 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id h24-20020a056e021d9800b0030be8a5dd68so3433865ila.13
        for <linux-unionfs@vger.kernel.org>; Sat, 24 Dec 2022 18:16:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XUQzGX68q2F3T2QOe3onWvn1683qyXZpQzxMzGlRkzg=;
        b=bomx+O9PeEw+PI6LOsKaAkubIeeUYaXyo+RCzLoO9Lk6gKCDtp+k8nYlruNPZHdobh
         IEG0ooirxTqnzUj5mhGGVtoabi6I9hOROsoIEcZ4SWRjGIwSIN+BWzbfDrj2qudkZPZd
         odyGg5h6mH21LuHlniIZZUq5EcYpTEXJG1n5wAAyYfq23yFKVkzid42DYyJCypdUTnA8
         Z9sMvrBw83nvcc7epU/1513/AwWn0NeMnLGvbyt5iIjw63JWbvNqjBs5vytfVF3+3vv7
         I3sx0rCyJOLxrUn9epzt8JvXiFehm2rorV0h+bnpV6HZW3DUNaF6A3cwhYzOpccoBr2A
         ltnw==
X-Gm-Message-State: AFqh2krSoyiQ4S8aksOuAqLr8wFNfIXRLsaqsXXBbvYRsN9hm+RIzSh9
        dsSY+/9OHNxG7W9TpvluAwvaRmy3wdtef0CkIocoHHAXk2nu
X-Google-Smtp-Source: AMrXdXuXhBc0cSxuLMfytcY730C7SNTMox28GsOAl4bnXawZToLNnRJS/WM4zyZQ0V1yWbgayb0VypJIYKaIbhZECov0P/we76W0
MIME-Version: 1.0
X-Received: by 2002:a5e:9242:0:b0:6e2:c840:e65f with SMTP id
 z2-20020a5e9242000000b006e2c840e65fmr948619iop.135.1671934611394; Sat, 24 Dec
 2022 18:16:51 -0800 (PST)
Date:   Sat, 24 Dec 2022 18:16:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000099952805f09d9ca2@google.com>
Subject: [syzbot] WARNING in ovl_workdir_create
From:   syzbot <syzbot+5c000f9370a28b5a0cf9@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6feb57c2fd7c Merge tag 'kbuild-v6.2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=119e2920480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d3fb546de56fbf8d
dashboard link: https://syzkaller.appspot.com/bug?extid=5c000f9370a28b5a0cf9
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/81556e491789/disk-6feb57c2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/065c943ec9de/vmlinux-6feb57c2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/66e98c522c1f/bzImage-6feb57c2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5c000f9370a28b5a0cf9@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE)): count = 0x0, magic = 0xffff8880797a8330, owner = 0x0, curr 0xffff888027640000, list empty
WARNING: CPU: 1 PID: 4264 at kernel/locking/rwsem.c:1361 __up_write kernel/locking/rwsem.c:1360 [inline]
WARNING: CPU: 1 PID: 4264 at kernel/locking/rwsem.c:1361 up_write+0x4f9/0x580 kernel/locking/rwsem.c:1615
Modules linked in:
CPU: 0 PID: 4264 Comm: syz-executor.4 Not tainted 6.1.0-syzkaller-13822-g6feb57c2fd7c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__up_write kernel/locking/rwsem.c:1360 [inline]
RIP: 0010:up_write+0x4f9/0x580 kernel/locking/rwsem.c:1615
Code: c7 00 ac ed 8a 48 c7 c6 a0 ae ed 8a 48 8b 54 24 28 48 8b 4c 24 18 4d 89 e0 4c 8b 4c 24 30 31 c0 53 e8 9b 59 e8 ff 48 83 c4 08 <0f> 0b e9 6b fd ff ff 48 c7 c1 98 9c 96 8e 80 e1 07 80 c1 03 38 c1
RSP: 0018:ffffc9000572f6a0 EFLAGS: 00010296
RAX: b0f262dcfc357400 RBX: ffffffff8aedace0 RCX: 0000000000040000
RDX: ffffc9000bf01000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffffc9000572f770 R08: ffffffff816f2c9d R09: fffff52000ae5e8d
R10: fffff52000ae5e8d R11: 1ffff92000ae5e8c R12: 0000000000000000
R13: ffff8880797a8330 R14: 1ffff92000ae5edc R15: dffffc0000000000
FS:  00007f002ce5c700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc9ea442251 CR3: 0000000028e53000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 inode_unlock include/linux/fs.h:761 [inline]
 ovl_workdir_create+0x87e/0x8f0 fs/overlayfs/super.c:840
 ovl_make_workdir+0x107/0xdf0 fs/overlayfs/super.c:1294
 ovl_get_workdir+0x2e4/0x410 fs/overlayfs/super.c:1444
 ovl_fill_super+0x19d7/0x2790 fs/overlayfs/super.c:2000
 mount_nodev+0x52/0xe0 fs/super.c:1405
 legacy_get_tree+0xea/0x180 fs/fs_context.c:610
 vfs_get_tree+0x88/0x270 fs/super.c:1489
 do_new_mount+0x289/0xad0 fs/namespace.c:3145
 do_mount fs/namespace.c:3488 [inline]
 __do_sys_mount fs/namespace.c:3697 [inline]
 __se_sys_mount+0x2d3/0x3c0 fs/namespace.c:3674
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f002c08c0d9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f002ce5c168 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f002c1ac050 RCX: 00007f002c08c0d9
RDX: 0000000020000080 RSI: 0000000020000040 RDI: 0000000000000000
RBP: 00007f002c0e7ae9 R08: 0000000020000440 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc709959bf R14: 00007f002ce5c300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
