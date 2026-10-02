Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BA9514770
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 20:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790971893; cv=none; b=ZKfw654vL1prD2oylexaqjlPRvhii4dpORVRHOESOp9mjK4FMxa2OMPjrXIYu2VfNZmr3hPNv7nEVAA2uIVrIaQITOMg+OXhz1qBcjqbWVi7+PqOLRemeGLv789EalEEDUAAM7GIUdlbGsl32RkTqjv0IEBysqX8GhlqK3bg01E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790971893; c=relaxed/simple;
	bh=khPh14Pceb2xrIP/Q35E8Ty/zjps/OZrik46SvHKJwU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aFU/1P1KRW1Nd2mfVQvIi+Zt2jIEFOv7LxVv1Qo5ktx6tAUy0K92P4Uc/HcNfPGd94JRWub+xSFtsp15kDINLDGZOrCCkQ4qHyzOnVuBC7ExrdcHMSDBRi89BtOEmxfty8QsTbwg9VyiDchRpVteOGVLn97wf9537QQaE8FHrlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4c467e19391so15195713b6e.3
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Oct 2026 13:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790971891; x=1791576691;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sMGooLKsXYFPTfvyOy4AlOUY1TGy9Q+HaH3JlZUNrJo=;
        b=XV3HCNRUDuzPwKbIj7aQTAGpRKaXBqgDY7Olhd3l8Oa2C6UkaJMv7fy56QmFfrrK4Y
         Apn7oVZico4j4M5q8a8jG0JipvW/6r0iJl+5uh9Y7MeIv8TDmTJeUXyxKAtOz/fD/365
         G1CAhr2tdrSs0UXxjIucNl1OIhRe6DraxQJjdGne4pES4YToDMa2cgFweXTlcJMPjhDE
         ttuV7de+byXAqpy0cbwAZBOZHjDCWp6bw3sHqiTS/AA1gIK7LJ2DfqfDobmDzUSu1e1d
         HppdWG4iLM3Z9cuj6cnEbF5R0cLyde9Pic2+FKM/NkaEkIi6ZR0vIe5bRO+X7XMeTSya
         y+QQ==
X-Forwarded-Encrypted: i=1; AKwUvBxC6WpxOWiwWngPOYIfpR48AAifGA0TdPTXAqVv2XBWzPg42DxwbbmOSNdXmiOISzNqfSCdHftye0W8vjke@vger.kernel.org
X-Gm-Message-State: AFuF++nlY/tPwufLzUW/O9T7Be0UNvVui+VarIKxWvAOEm5c5kKg4SO0
	/sSOuES6XD3m+Mor6FRMoyt5WLzq5psOLB3n/7E+esvrHfKHl2nSpGkqaCgU5lNyB7/f5Fiehk9
	bUAfACoQyBcnx1nZwIFN8yP5/uWYGwdzrqtiXdCILtpWMuhLL27AXRVZgyUU=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f14:b0:4c4:d8a0:2773 with SMTP id
 5614622812f47-4f67a0f6c02mr483176b6e.32.1790971890910; Fri, 02 Oct 2026
 13:11:30 -0700 (PDT)
Date: Fri, 02 Oct 2026 13:11:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac00ff2.9ad129c8.3858c0.0004.GAE@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in iterate_dir (4)
From: syzbot <syzbot+7c4b3d05083880a09cdd@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6474fa070f2b Add linux-next specific files for 20260929
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11744725580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3477d5a04d788556
dashboard link: https://syzkaller.appspot.com/bug?extid=7c4b3d05083880a09cdd
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0b184b600605/disk-6474fa07.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/71aa06781faf/vmlinux-6474fa07.xz
kernel image: https://storage.googleapis.com/syzbot-assets/250dcdc25f2b/bzImage-6474fa07.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7c4b3d05083880a09cdd@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.1.241/6613 is trying to acquire lock:
ffff888079d74140 (&type->i_mutex_dir_key#4){++++}-{4:4}, at: iterate_dir+0x209/0x4d0 fs/readdir.c:103

but task is already holding lock:
ffff888059293d88 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}, at: wrap_directory_iterator+0x5a/0xe0 fs/readdir.c:56

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}:
       down_read+0x45/0x320 kernel/locking/rwsem.c:1574
       inode_lock_shared include/linux/fs.h:1039 [inline]
       lookup_slow+0x46/0x80 fs/namei.c:1935
       ovl_lookup_positive_unlocked fs/overlayfs/namei.c:216 [inline]
       ovl_lookup_single+0x323/0xe90 fs/overlayfs/namei.c:260
       ovl_lookup_layer+0x377/0x440 fs/overlayfs/namei.c:365
       ovl_lookup_layers fs/overlayfs/namei.c:1168 [inline]
       ovl_lookup+0x9ae/0x1c80 fs/overlayfs/namei.c:1403
       lookup_open+0x94b/0x1970 fs/namei.c:4530
       open_last_lookups fs/namei.c:4769 [inline]
       path_openat+0x673/0x1da0 fs/namei.c:5008
       do_file_open+0x23e/0x4a0 fs/namei.c:5040
       do_sys_openat2+0x115/0x200 fs/open.c:1442
       do_sys_open fs/open.c:1448 [inline]
       __do_sys_openat fs/open.c:1464 [inline]
       __se_sys_openat fs/open.c:1459 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1459
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (DCACHE_PAR_LOOKUP){+.+.}-{0:0}:
       d_wait_lookup fs/dcache.c:2838 [inline]
       __d_alloc_parallel+0xc32/0x1700 fs/dcache.c:2942
       __lookup_slow+0x82/0x2f0 fs/namei.c:1904
       lookup_slow+0x59/0x80 fs/namei.c:1936
       walk_component fs/namei.c:2282 [inline]
       lookup_last fs/namei.c:2789 [inline]
       path_lookupat+0x3f5/0x8c0 fs/namei.c:2813
       filename_lookup+0x265/0x5d0 fs/namei.c:2842
       do_readlinkat+0xe3/0x510 fs/stat.c:571
       __do_sys_readlink fs/stat.c:605 [inline]
       __se_sys_readlink fs/stat.c:602 [inline]
       __x64_sys_readlink+0x7f/0x90 fs/stat.c:602
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&type->i_mutex_dir_key#4){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       down_read_killable+0x4b/0x3b0 kernel/locking/rwsem.c:1599
       iterate_dir+0x209/0x4d0 fs/readdir.c:103
       ovl_dir_read+0x141/0x4a0 fs/overlayfs/readdir.c:388
       ovl_dir_read_merged+0x2fb/0x520 fs/overlayfs/readdir.c:451
       ovl_cache_get fs/overlayfs/readdir.c:504 [inline]
       ovl_iterate_merged fs/overlayfs/readdir.c:846 [inline]
       ovl_iterate+0xd5a/0x2160 fs/overlayfs/readdir.c:906
       wrap_directory_iterator+0x96/0xe0 fs/readdir.c:67
       iterate_dir+0x2e2/0x4d0 fs/readdir.c:110
       __do_sys_getdents64 fs/readdir.c:399 [inline]
       __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &type->i_mutex_dir_key#4 --> DCACHE_PAR_LOOKUP --> &ovl_i_mutex_dir_key[depth]#2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ovl_i_mutex_dir_key[depth]#2);
                               lock(DCACHE_PAR_LOOKUP);
                               lock(&ovl_i_mutex_dir_key[depth]#2);
  rlock(&type->i_mutex_dir_key#4);

 *** DEADLOCK ***

locks held by syz.1.241/6613: 2, last CPU#1:
 #0: ffff88807eb65cf0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x118/0x160 fs/file.c:1408
 #1: ffff888059293d88 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}, at: wrap_directory_iterator+0x5a/0xe0 fs/readdir.c:56

stack backtrace:
CPU: 1 UID: 0 PID: 6613 Comm: syz.1.241 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
 check_prev_add kernel/locking/lockdep.c:3209 [inline]
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 down_read_killable+0x4b/0x3b0 kernel/locking/rwsem.c:1599
 iterate_dir+0x209/0x4d0 fs/readdir.c:103
 ovl_dir_read+0x141/0x4a0 fs/overlayfs/readdir.c:388
 ovl_dir_read_merged+0x2fb/0x520 fs/overlayfs/readdir.c:451
 ovl_cache_get fs/overlayfs/readdir.c:504 [inline]
 ovl_iterate_merged fs/overlayfs/readdir.c:846 [inline]
 ovl_iterate+0xd5a/0x2160 fs/overlayfs/readdir.c:906
 wrap_directory_iterator+0x96/0xe0 fs/readdir.c:67
 iterate_dir+0x2e2/0x4d0 fs/readdir.c:110
 __do_sys_getdents64 fs/readdir.c:399 [inline]
 __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5cfbb9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5cfc9c0028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
RAX: ffffffffffffffda RBX: 00007f5cfbe25fa0 RCX: 00007f5cfbb9e159
RDX: 0000000000001000 RSI: 0000200000001dc0 RDI: 0000000000000009
RBP: 00007f5cfbc3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5cfbe26038 R14: 00007f5cfbe25fa0 R15: 00007ffe433bef38
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
