Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1773C4143
	for <linux-unionfs@vger.kernel.org>; Wed, 17 Jun 2026 21:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781730576; cv=none; b=ZEXpTjV5DPhsKzspWvKmiwIeKFBdg0GqbzEKwzHV4gXaL0xlsxejDYQtFuQav+y/eg6Vhof3qDkqbdSO16mjgRjYIcrM6KWJO2aOx0XQEh/02GPRV9QlZSlJ4A1iQDuaDAfHCiLc4orVFFxSW2Bq9fEfW6IwQirOOHoDecfJVP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781730576; c=relaxed/simple;
	bh=3+8Brf8ODRXGAjUEM8QFTF95Jb14UFCEEcnSjoqfKiQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Fw+cHTfh0J7yCydEkFBc7JPQePQ05+ZcYYPMMEkCZRxxCUw3rxavPsmzGzW+g8bkt37dvbbuhnty7QIIPB4aIMuwmA1Tne6Wt0wwsC0zXb4SKS6zP54YabmzLpF7FDP9Ae5LUe0gwz+u0YVFsaOBi56QdypJy0JQxex9mEtKheY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-486a24852ddso591963b6e.1
        for <linux-unionfs@vger.kernel.org>; Wed, 17 Jun 2026 14:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781730574; x=1782335374;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ls6nnt7Gmh5oIq7HUnXiRTpdJiSDl+jtLsjNlkBAIfQ=;
        b=P+to9dXm8BRG911Go6/bJ76A88Xco4EsPWWsbjbuJSnZugcQGhVwqckZL0kXXWxvgM
         08qHJtGzatNdk4yNksssDiZDir4nrW18GOFGscXKEfxkZTDIk+z0lWGg/XMA37ZBYqCv
         psKvOCNhWJ0I01uen1VCwdunep64Rcc4OFkrdTtImbEI1+sjih9e4SSdSE8QRubMINI9
         ovXuPXnxneP2z3tERKVdaNZx3xKOlm+hLgwQSJIgtP3MOfu1F9W3RrGoxzWx8jPZJ+eI
         7+MhhWx5mlD753suiZ2w3FC5Dgf3FwUEdCr1rj7dCXHG7jHVQdX2Dzw8zIIFnRPT+d4e
         N7vw==
X-Forwarded-Encrypted: i=1; AFNElJ9rOqWRy6ESXCRUcUmCibKMTrRlQZWE6URC+eN2hXBVOFrpHE6Zae2xcG7gA2V5yEisStv/Y0tBZWJ9Oszj@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4/tu697dVcny/oD2eVBp2e4GBzcOcZ8lBq4G+dA0SKA427RbW
	wbYXstM4Pd1KflKKrJawytWcaF2kE0zbxRCyWM4RAUuSTbSJPybpLQME/RQnccXIq5LIJP4iIiI
	lZcs/aguUt93Mzpo2MOyqP2l9/91ZbBHkWggrx9/TFGAFJvmTq+Rsw+HopME=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1992:b0:486:a5e9:c320 with SMTP id
 5614622812f47-489429ec656mr6608629b6e.29.1781730574114; Wed, 17 Jun 2026
 14:09:34 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:09:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a330d0e.6d5abbec.a50f.0020.GAE@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in ovl_copy_up_start (5)
From: syzbot <syzbot+d4e3aadc5bd19f7e71ff@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    596d152bc5e3 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=10aba8ae580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb40ba923a822433
dashboard link: https://syzkaller.appspot.com/bug?extid=d4e3aadc5bd19f7e71ff
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/32d15acc8c01/disk-596d152b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/83b3d8d84761/vmlinux-596d152b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8edfcc3bf911/Image-596d152b.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d4e3aadc5bd19f7e71ff@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.3.611/8517 is trying to acquire lock:
ffff0000eee140f8 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
ffff0000eee140f8 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_copy_up_start+0x58/0x264 fs/overlayfs/util.c:735

but task is already holding lock:
ffff0000eee13d88 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
ffff0000eee13d88 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}, at: lock_two_nondirectories+0xe8/0x148 fs/inode.c:1256

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}:
       __lock_release kernel/locking/lockdep.c:5574 [inline]
       lock_release+0x178/0x3b0 kernel/locking/lockdep.c:5889
       up_write+0x3c/0x5d8 kernel/locking/rwsem.c:1681
       inode_unlock include/linux/fs.h:1039 [inline]
       unlock_two_nondirectories+0x60/0x118 fs/inode.c:1269
       ext4_move_extents+0x468/0x3580 fs/ext4/move_extent.c:656
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
       el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
       el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594

-> #1 (sb_writers#3){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_write include/linux/fs/super.h:125 [inline]
       ovl_start_write+0xf0/0x324 fs/overlayfs/util.c:32
       ovl_do_copy_up fs/overlayfs/copy_up.c:977 [inline]
       ovl_copy_up_one fs/overlayfs/copy_up.c:1189 [inline]
       ovl_copy_up_flags+0x980/0x28a4 fs/overlayfs/copy_up.c:1243
       ovl_maybe_copy_up+0x108/0x148 fs/overlayfs/copy_up.c:1272
       ovl_open+0x12c/0x2c0 fs/overlayfs/file.c:211
       do_dentry_open+0x5c4/0xfc8 fs/open.c:947
       vfs_open+0x44/0x2d4 fs/open.c:1079
       do_open fs/namei.c:4699 [inline]
       path_openat+0x2234/0x2a6c fs/namei.c:4858
       do_file_open+0x1c4/0x2e4 fs/namei.c:4887
       do_sys_openat2+0x114/0x1e8 fs/open.c:1364
       do_sys_open+0xac/0xdc fs/open.c:1370
       __do_sys_openat fs/open.c:1386 [inline]
       __se_sys_openat fs/open.c:1381 [inline]
       __arm64_sys_openat+0x9c/0xb8 fs/open.c:1381
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
       el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
       el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594

-> #0 (&ovl_i_lock_key[depth]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1780/0x2f44 kernel/locking/lockdep.c:5237
       lock_acquire+0x140/0x368 kernel/locking/lockdep.c:5868
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x160/0xef8 kernel/locking/mutex.c:820
       mutex_lock_interruptible_nested+0x24/0x30 kernel/locking/mutex.c:898
       ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
       ovl_copy_up_start+0x58/0x264 fs/overlayfs/util.c:735
       ovl_copy_up_one fs/overlayfs/copy_up.c:1182 [inline]
       ovl_copy_up_flags+0x768/0x28a4 fs/overlayfs/copy_up.c:1243
       ovl_copy_up+0x24/0x34 fs/overlayfs/copy_up.c:1282
       ovl_rename_start fs/overlayfs/dir.c:1176 [inline]
       ovl_rename+0x2d8/0xfec fs/overlayfs/dir.c:1363
       vfs_rename+0xa78/0xd48 fs/namei.c:6064
       filename_renameat2+0x66c/0x730 fs/namei.c:6182
       __do_sys_renameat2 fs/namei.c:6211 [inline]
       __se_sys_renameat2 fs/namei.c:6206 [inline]
       __arm64_sys_renameat2+0xe4/0x114 fs/namei.c:6206
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
       el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
       el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594

other info that might help us debug this:

Chain exists of:
  &ovl_i_lock_key[depth] --> sb_writers#3 --> &ovl_i_mutex_key[depth]/4

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ovl_i_mutex_key[depth]/4);
                               lock(sb_writers#3);
                               lock(&ovl_i_mutex_key[depth]/4);
  lock(&ovl_i_lock_key[depth]);

 *** DEADLOCK ***

5 locks held by syz.3.611/8517:
 #0: ffff00010bddc410 (sb_writers#17){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:493
 #1: ffff00010bddc718 (&type->s_vfs_rename_key#3){+.+.}-{4:4}, at: lock_rename fs/namei.c:3791 [inline]
 #1: ffff00010bddc718 (&type->s_vfs_rename_key#3){+.+.}-{4:4}, at: __start_renaming+0xec/0x33c fs/namei.c:3880
 #2: ffff0000eee14300 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #2: ffff0000eee14300 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: lock_two_directories+0x19c/0x214 fs/namei.c:3767
 #3: ffff0000eee13810 (&ovl_i_mutex_dir_key[depth]/5){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #3: ffff0000eee13810 (&ovl_i_mutex_dir_key[depth]/5){+.+.}-{4:4}, at: lock_two_directories+0x1c4/0x214 fs/namei.c:3768
 #4: ffff0000eee13d88 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #4: ffff0000eee13d88 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}, at: lock_two_nondirectories+0xe8/0x148 fs/inode.c:1256

stack backtrace:
CPU: 1 UID: 0 PID: 8517 Comm: syz.3.611 Tainted: G             L      syzkaller #0 PREEMPT 
Tainted: [L]=SOFTLOCKUP
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
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x160/0xef8 kernel/locking/mutex.c:820
 mutex_lock_interruptible_nested+0x24/0x30 kernel/locking/mutex.c:898
 ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
 ovl_copy_up_start+0x58/0x264 fs/overlayfs/util.c:735
 ovl_copy_up_one fs/overlayfs/copy_up.c:1182 [inline]
 ovl_copy_up_flags+0x768/0x28a4 fs/overlayfs/copy_up.c:1243
 ovl_copy_up+0x24/0x34 fs/overlayfs/copy_up.c:1282
 ovl_rename_start fs/overlayfs/dir.c:1176 [inline]
 ovl_rename+0x2d8/0xfec fs/overlayfs/dir.c:1363
 vfs_rename+0xa78/0xd48 fs/namei.c:6064
 filename_renameat2+0x66c/0x730 fs/namei.c:6182
 __do_sys_renameat2 fs/namei.c:6211 [inline]
 __se_sys_renameat2 fs/namei.c:6206 [inline]
 __arm64_sys_renameat2+0xe4/0x114 fs/namei.c:6206
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594


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
