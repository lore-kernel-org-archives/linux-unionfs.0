Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA673BB9ED
	for <linux-unionfs@vger.kernel.org>; Fri, 29 May 2026 09:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780047272; cv=none; b=uPL/mJNhwEwwWzwb+k3yzImpbYD8QsKcN+6ln/g8VbYD2cImfSC+4PfqYSPz2YdOAZvx5MkJQMNMPLKDgSvB0h8RsoNpL2Ohk3dwnVEc3p4b32XjkWEkB0gAAuBOyQxnALrVAi6xMoX90Xsp0oHJOpvRzBS4PbeeHUtFSSMBqmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780047272; c=relaxed/simple;
	bh=gN8Ky9jHILxKRQ3yUDP+DOlpnYKqFI49ajEdmJKRtQc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jdqe26lth8RbC5ucCGgg8ZfvpDSmhDrodlijmdY7VNNGbHouVNhs7GhQmeIFAOm2BkaCtp1VCZQnZfuAkglppIyfyzXyMMa86qO37j7VFfNJ4UHaXEhiWOrp//hRUc91XKgaOlETi0rXzzFkwGNhRpJpeh8ECI9TWGniwKO0DTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7dcde7bf859so28713728a34.0
        for <linux-unionfs@vger.kernel.org>; Fri, 29 May 2026 02:34:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780047269; x=1780652069;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HmdT+qkWIjU/Jjif2NUskoy7YHStO9bPID0z9dl/xsw=;
        b=AgwN1f/5f6qZqPZrOCjbXC0FYK4V7aABoTMuUhChkknuiQ65a86YcfmATOIhIue/xd
         NpY3iQhSE3Yeb5QeSCb+AB+mP3Rz8N/dqNcwtQ/ZZtneuZGSNKwa8jSFxjeZvtjFuaff
         OtfE2WP+zYXt/6iObf6ktWxNiN0k+UPUQpTvG/x6hFTUTCryFx4SDMtSf6JQrLjfDDhh
         pyHjxTDDV2UzzYnBrX8HOzo3qp+O1H9FGRgY/6hCbvZrVcGjnF8uVyDbpaFMQUde+MDM
         5+n5bMpDuWypiBsmut6SZzYVFt5Yw9Rc82w7pZV7UCBlzCtzJQXvLUBzeaPe8V75B9z6
         Ye7w==
X-Forwarded-Encrypted: i=1; AFNElJ+/YRfk+sljM47ZH/zpnwoVy7BD8+6TLGhTYTQo7VKJ0MzEQsGcpXyph/4CHvjwO3Lk660HQw02z524GDBd@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk5epmfByGKhr6eJyKGEMHCSR6Lld6FOBtRTJhIUhurSMuanOH
	k5qORD+0N/TBM9NE3ztUys26W/wnVtpMn+A/3IPyCeo2Kg6zLncNpQ2DogT7a28d4mFrTyjF4kq
	gxS08KJHuH6qdfDQmriqhQ8JGg8pjOzPmdkg07kPVh6tTR/Eq0XidBGvIe4E=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2388:b0:69d:e2fc:3631 with SMTP id
 006d021491bc7-69e03ebcba3mr853536eaf.10.1780047269678; Fri, 29 May 2026
 02:34:29 -0700 (PDT)
Date: Fri, 29 May 2026 02:34:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a195da5.c16d89a8.217f2c.0001.GAE@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in ovl_copy_up_flags (2)
From: syzbot <syzbot+b754bc5f4c7fddac5253@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4b4362973b6f Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1292dc2e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a834c6344141a58b
dashboard link: https://syzkaller.appspot.com/bug?extid=b754bc5f4c7fddac5253
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f69f86c90ee5/disk-4b436297.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/79fa7b33aaab/vmlinux-4b436297.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ef080156d0de/Image-4b436297.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b754bc5f4c7fddac5253@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.5.344/6315 is trying to acquire lock:
ffff0000cbc50410 (sb_writers#3){.+.+}-{0:0}, at: ovl_do_copy_up fs/overlayfs/copy_up.c:977 [inline]
ffff0000cbc50410 (sb_writers#3){.+.+}-{0:0}, at: ovl_copy_up_one fs/overlayfs/copy_up.c:1189 [inline]
ffff0000cbc50410 (sb_writers#3){.+.+}-{0:0}, at: ovl_copy_up_flags+0x980/0x28a4 fs/overlayfs/copy_up.c:1243

but task is already holding lock:
ffff0000f25fdcd8 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
ffff0000f25fdcd8 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_copy_up_start+0x58/0x264 fs/overlayfs/util.c:735

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ovl_i_lock_key[depth]){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x160/0xef8 kernel/locking/mutex.c:820
       mutex_lock_interruptible_nested+0x24/0x30 kernel/locking/mutex.c:898
       ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
       ovl_copy_up_start+0x58/0x264 fs/overlayfs/util.c:735
       ovl_copy_up_one fs/overlayfs/copy_up.c:1182 [inline]
       ovl_copy_up_flags+0x768/0x28a4 fs/overlayfs/copy_up.c:1243
       ovl_copy_up+0x24/0x34 fs/overlayfs/copy_up.c:1282
       ovl_link+0x8c/0x26c fs/overlayfs/dir.c:774
       vfs_link+0x40c/0x580 fs/namei.c:5774
       filename_linkat+0x224/0x478 fs/namei.c:5842
       __do_sys_linkat fs/namei.c:5868 [inline]
       __se_sys_linkat fs/namei.c:5863 [inline]
       __arm64_sys_linkat+0xe8/0x118 fs/namei.c:5863
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
       el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:740
       el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:759
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594

-> #1 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       lock_two_nondirectories+0xc4/0x148 fs/inode.c:1254
       ext4_move_extents+0x194/0x3580 fs/ext4/move_extent.c:589
       __ext4_ioctl fs/ext4/ioctl.c:1657 [inline]
       ext4_ioctl+0x2a14/0x4234 fs/ext4/ioctl.c:1922
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl fs/ioctl.c:583 [inline]
       __arm64_sys_ioctl+0x14c/0x1c4 fs/ioctl.c:583
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
       el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:740
       el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:759
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594

-> #0 (sb_writers#3){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1780/0x2f44 kernel/locking/lockdep.c:5237
       lock_acquire+0x140/0x368 kernel/locking/lockdep.c:5868
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_write include/linux/fs/super.h:125 [inline]
       ovl_start_write+0xf0/0x324 fs/overlayfs/util.c:32
       ovl_do_copy_up fs/overlayfs/copy_up.c:977 [inline]
       ovl_copy_up_one fs/overlayfs/copy_up.c:1189 [inline]
       ovl_copy_up_flags+0x980/0x28a4 fs/overlayfs/copy_up.c:1243
       ovl_copy_up+0x24/0x34 fs/overlayfs/copy_up.c:1282
       ovl_xattr_set+0x284/0x47c fs/overlayfs/xattrs.c:54
       ovl_other_xattr_set+0x50/0x68 fs/overlayfs/xattrs.c:224
       __vfs_setxattr+0x130/0x17c fs/xattr.c:218
       __vfs_setxattr_noperm+0x120/0x5c4 fs/xattr.c:252
       __vfs_setxattr_locked+0x114/0x248 fs/xattr.c:313
       vfs_setxattr+0x150/0x2e0 fs/xattr.c:339
       do_setxattr+0xf8/0x190 fs/xattr.c:654
       filename_setxattr+0x134/0x1f8 fs/xattr.c:682
       path_setxattrat+0x200/0x2a8 fs/xattr.c:726
       __do_sys_setxattr fs/xattr.c:760 [inline]
       __se_sys_setxattr fs/xattr.c:756 [inline]
       __arm64_sys_setxattr+0xc0/0xdc fs/xattr.c:756
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
       el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:740
       el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:759
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594

other info that might help us debug this:

Chain exists of:
  sb_writers#3 --> &ovl_i_mutex_key[depth] --> &ovl_i_lock_key[depth]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ovl_i_lock_key[depth]);
                               lock(&ovl_i_mutex_key[depth]);
                               lock(&ovl_i_lock_key[depth]);
  rlock(sb_writers#3);

 *** DEADLOCK ***

3 locks held by syz.5.344/6315:
 #0: ffff0000f5150410 (sb_writers#15){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:493
 #1: ffff0000f25fd960 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #1: ffff0000f25fd960 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}, at: vfs_setxattr+0x130/0x2e0 fs/xattr.c:338
 #2: ffff0000f25fdcd8 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
 #2: ffff0000f25fdcd8 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_copy_up_start+0x58/0x264 fs/overlayfs/util.c:735

stack backtrace:
CPU: 1 UID: 0 PID: 6315 Comm: syz.5.344 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x328/0x330 kernel/locking/lockdep.c:2043
 check_noncircular+0x158/0x174 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1780/0x2f44 kernel/locking/lockdep.c:5237
 lock_acquire+0x140/0x368 kernel/locking/lockdep.c:5868
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_write include/linux/fs/super.h:125 [inline]
 ovl_start_write+0xf0/0x324 fs/overlayfs/util.c:32
 ovl_do_copy_up fs/overlayfs/copy_up.c:977 [inline]
 ovl_copy_up_one fs/overlayfs/copy_up.c:1189 [inline]
 ovl_copy_up_flags+0x980/0x28a4 fs/overlayfs/copy_up.c:1243
 ovl_copy_up+0x24/0x34 fs/overlayfs/copy_up.c:1282
 ovl_xattr_set+0x284/0x47c fs/overlayfs/xattrs.c:54
 ovl_other_xattr_set+0x50/0x68 fs/overlayfs/xattrs.c:224
 __vfs_setxattr+0x130/0x17c fs/xattr.c:218
 __vfs_setxattr_noperm+0x120/0x5c4 fs/xattr.c:252
 __vfs_setxattr_locked+0x114/0x248 fs/xattr.c:313
 vfs_setxattr+0x150/0x2e0 fs/xattr.c:339
 do_setxattr+0xf8/0x190 fs/xattr.c:654
 filename_setxattr+0x134/0x1f8 fs/xattr.c:682
 path_setxattrat+0x200/0x2a8 fs/xattr.c:726
 __do_sys_setxattr fs/xattr.c:760 [inline]
 __se_sys_setxattr fs/xattr.c:756 [inline]
 __arm64_sys_setxattr+0xc0/0xdc fs/xattr.c:756
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:740
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:759
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
EXT4-fs error (device loop5): ext4_find_dest_de:2050: inode #12: block 7: comm syz.5.344: bad entry in directory: rec_len is too small for name_len - offset=16, inode=14, rec_len=40, size=56 fake=0
EXT4-fs (loop5): Remounting filesystem read-only


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
