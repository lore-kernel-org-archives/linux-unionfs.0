Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C900614D70B
	for <linux-unionfs@vger.kernel.org>; Fri, 29 Nov 2024 06:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732862551; cv=none; b=o4bZH94nJE6yqxdSbWdVhM1ItFyO1Bb+7OW22B7t8FDdwLzJnPU+ijOhngpkDJQsmsByfEX6syBLXePez+FfmdxasPV67uCX7dZkWWoPd8mYqf0ha76jDfJ2tjHIGYuzEE4S8jSJLxFI5A3bqWUuQflQEaBIx5Ka8AxvJN04S2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732862551; c=relaxed/simple;
	bh=tWfUNdPe5dPJrlkPG7M/Vf1isjT6Xw1COFMQ++6ZhZA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Lq+lMzgnvW5FO7b2aJ/1dPHXeq+Qb+lbufhuPrIAuK8itNhP8X16ElxPEUc/Ws458Imt9lgqoA66KMn5/ViSHUzp/+SJQHeTKTAbGRm88JoY4jJh29l3NJJBBTw5K1kMiV5+HGACpn0fTstLegV/VkLNsnM9uKvypsHWG6SJDuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a7a1e95f19so14729645ab.1
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Nov 2024 22:42:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732862549; x=1733467349;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CD8x9KRAK1LCMpYyl25z1y0rxMD0DzxEj7pSOvbXZ4g=;
        b=EXvvd00H5jTly1KvDMKYGuRgIQXPinMHn4Elcirr5ONutRmqTYHeCL4p8g3WzNVX0w
         naJ6BVn925D7r15EtwK9wemvG9RLLbK+ivbkFqGpz6Ufs1gAzJDOHU/OGsLuUtUQ87rj
         NLQ0CVr7ixRCkO07DGbRFZZaJRRSK/MPfc982JlVIx5dpRGc0v2d4Z7Ba01kybJCZPbb
         jZzJrAivH29hO6X5uWZtu8fBmOI2/wK3GKynWxdYkZ9E5a6Bn/z5NyGHbeVrVwtimv62
         CdSJHZk9bsMAXOdCYht17WTKGRFhq7a5IIctcQCCy8XfZhHmQ3REblayuDroFY5YjEAP
         Gi3g==
X-Forwarded-Encrypted: i=1; AJvYcCVmQ93iKBt7UYy0Cs2/pE7du6gJ2mUyBmb3M0IfU2dIcxeVa1VYgE2nwyz+OeznsW1JJH17iX6pYPCXddq/@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrg8Hwia3nYsjR/PijKhGit+tNpyga5oojSjdlH3/VrG1URZL6
	GA8bzCg/WojC5G9zbFwQ0hLWqUw5kwMExjIrm9fCuENs1GKGVcyQJBezC1rTxsfQuuuDXE82/lx
	PXscfNutKwi4NJhAuyZoVEWLxSJppiQtvxIFq/Ol2lMiI/uNmCwrGfw8=
X-Google-Smtp-Source: AGHT+IG7fpQQp79dZOqBJMRjYItyfBBZddtwPIomhcAcPwVNtS2nnp0gh5eqa7p3DOuN0R+BVTpsxK7lgs1cNLCKthaWdGUouAxQ
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a03:b0:3a7:432d:912f with SMTP id
 e9e14a558f8ab-3a7c5525801mr90116455ab.1.1732862548950; Thu, 28 Nov 2024
 22:42:28 -0800 (PST)
Date: Thu, 28 Nov 2024 22:42:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67496254.050a0220.253251.00a3.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in ovl_workdir_create (4)
From: syzbot <syzbot+fbcf713b26e03b637adb@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    85a2dd7d7c81 Add linux-next specific files for 20241125
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=167f25c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45719eec4c74e6ba
dashboard link: https://syzkaller.appspot.com/bug?extid=fbcf713b26e03b637adb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5422dd6ada68/disk-85a2dd7d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3a382ed71d3a/vmlinux-85a2dd7d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9b4d03eb0da3/bzImage-85a2dd7d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fbcf713b26e03b637adb@syzkaller.appspotmail.com

loop4: detected capacity change from 0 to 4096
------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE)): count = 0x0, magic = 0xffff88804e04a088, owner = 0x0, curr 0xffff888034fa3c00, list empty
WARNING: CPU: 1 PID: 12660 at kernel/locking/rwsem.c:1368 __up_write kernel/locking/rwsem.c:1367 [inline]
WARNING: CPU: 1 PID: 12660 at kernel/locking/rwsem.c:1368 up_write+0x502/0x590 kernel/locking/rwsem.c:1630
Modules linked in:
CPU: 1 UID: 0 PID: 12660 Comm: syz.4.2018 Not tainted 6.12.0-next-20241125-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:__up_write kernel/locking/rwsem.c:1367 [inline]
RIP: 0010:up_write+0x502/0x590 kernel/locking/rwsem.c:1630
Code: c7 c7 60 8a 0a 8c 48 c7 c6 80 8c 0a 8c 48 8b 54 24 28 48 8b 4c 24 18 4d 89 e0 4c 8b 4c 24 30 53 e8 b3 27 e6 ff 48 83 c4 08 90 <0f> 0b 90 90 e9 6a fd ff ff 48 c7 c1 c4 d8 18 90 80 e1 07 80 c1 03
RSP: 0018:ffffc9000fdb74e0 EFLAGS: 00010292
RAX: 1172aec84e22b600 RBX: ffffffff8c0a8b40 RCX: 0000000000080000
RDX: ffffc90004be1000 RSI: 000000000000848e RDI: 000000000000848f
RBP: ffffc9000fdb75b0 R08: ffffffff81601b32 R09: fffffbfff1cfa218
R10: dffffc0000000000 R11: fffffbfff1cfa218 R12: 0000000000000000
R13: ffff88804e04a088 R14: 1ffff92001fb6ea4 R15: dffffc0000000000
FS:  00007f35e2a3a6c0(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000005cc32000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 inode_unlock include/linux/fs.h:823 [inline]
 ovl_workdir_create+0x8e1/0x980 fs/overlayfs/super.c:353
 ovl_make_workdir fs/overlayfs/super.c:650 [inline]
 ovl_get_workdir+0x311/0x1920 fs/overlayfs/super.c:808
 ovl_fill_super+0x12a8/0x3560 fs/overlayfs/super.c:1376
 vfs_get_super fs/super.c:1280 [inline]
 get_tree_nodev+0xb7/0x140 fs/super.c:1299
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f35e1b7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f35e2a3a038 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f35e1d35fa0 RCX: 00007f35e1b7e819
RDX: 0000000020000000 RSI: 0000000020000040 RDI: 0000000000000000
RBP: 00007f35e1bf175e R08: 0000000020000100 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f35e1d35fa0 R15: 00007fffb14ff288
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
