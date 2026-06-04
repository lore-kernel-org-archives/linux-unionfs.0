Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95915477E3D
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Jun 2026 21:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780608814; cv=none; b=aocHenK5fQtZ9RemQJJ+8C08Qfi7irH3BC4Oqv1tkkiTdIcAF1Q9Vofz/ro2wsuZAIKAGvX82kRLedgYZsD2ZyYgN3ISihCdIrlF2qrX8/GmfFKZNEnTeqEG3CHqu1NaQyT+6TuRrwV4VsHaUHqL29LqiDYoJyvdbY/TkfIJZUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780608814; c=relaxed/simple;
	bh=pyFc6Bl5jdsAF/lR6EWrYHzNgPwR+Ynyed2NUjuaUI4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lVGVIk61cyzqp0xDUFz2xGNpY8gt9jU/bV6iwxb3td4DQ8mcVrVBHzEG35rzdeasikp27LadmWagxIOP+wgXACkZxZjf0jaF6g7yJ2V2iqHSZv+ixE2qZPhuciNXVuOfpH7ubftaIbcoX/xnwAXm5e6UGbSJbkwsyyedIT7CRAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-48637dce961so1112446b6e.0
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jun 2026 14:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780608811; x=1781213611;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5fRp0rtFh81Fn8m28u+cah1AL7sUPsmKU6z3BIZnz7Q=;
        b=V2vOI5jiAE5HxkB/JRgU2DLUWg+aZ1kMfQ4hAAoEI7ejEaqsC/ptibvtkDzOJZl4x0
         YGhKeAHgJoZLC8Nz0yKTrhBMTmFi9aDDq0voe+E/lsokjKXGopJ3ZDHf60xlXJoqbM3a
         09WuksRO7x7bHI3NpaA1q5Y0Yglg64sCkUInWr/XjDUgAxQ+tqweLIW+ASmuXYBNwphl
         0VORBdo6UlbZq0KppAnsvxhecflMhG6kXG97Ianb25W0VKWI5dCgd+czz7G/Ub8hLRys
         Lh8BgwiDDn79a//xEqFD2hUtTmp3SiVZTb9aENWMr4hcNGUlmDnaB690n37IvnxHQhHX
         WU0A==
X-Forwarded-Encrypted: i=1; AFNElJ/waWVsowLDcROvBpARxnSS0gw14xmad3ctQMyeqrtgUSXZmISN0NjGiIy450Hr02Bf0SNYkzgPeua6LQaF@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5lUc6y6WGtTOnzCfTAhtXkjTc2lQVYjfwUV2b3nY2DH6AgWyc
	RzB7oD22xC+btGWFB8eI88Yjzqjplpx3IkP+vsJ9Cab2DH+gYfb9tEw0i3UZCI1NHPnWAmRJa7p
	7XWE80Pt1bxO6DHu57wpXGNiRZ0g2+fD7rW5VIyMUic6lpT48O8BVfKlA0j0=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c8b:b0:69d:a224:6ee7 with SMTP id
 006d021491bc7-69e68cb64efmr577923eaf.54.1780608811698; Thu, 04 Jun 2026
 14:33:31 -0700 (PDT)
Date: Thu, 04 Jun 2026 14:33:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a21ef2b.a88f22c3.173579.0016.GAE@google.com>
Subject: [syzbot] [overlayfs?] [ext4?] possible deadlock in
 lock_two_nondirectories (2)
From: syzbot <syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ba3e43a9e601 Merge tag 'soc-fixes-7.1-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1033aa56580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd38685893011045
dashboard link: https://syzkaller.appspot.com/bug?extid=ad6118a7584b607c67f2
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e2f3ec580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=174c2a66580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8759ddf1bfa7/disk-ba3e43a9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e2f0e563c705/vmlinux-ba3e43a9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b40bdb37a0d7/bzImage-ba3e43a9.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4074e1f6d9f8/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1103db7e580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com

EXT4-fs: Ignoring removed bh option
EXT4-fs (loop0): stripe (5) is not aligned with cluster size (16), stripe is disabled
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: none.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.22/5968 is trying to acquire lock:
ffff88805aab44a0 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
ffff88805aab44a0 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}, at: lock_two_nondirectories+0xe7/0x180 fs/inode.c:1254

but task is already holding lock:
ffff88803ea9c480 (sb_writers#4){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (sb_writers#4){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
       file_start_write include/linux/fs.h:2724 [inline]
       vfs_iter_write+0x1f8/0x610 fs/read_write.c:982
       do_backing_file_write_iter fs/backing-file.c:226 [inline]
       backing_file_write_iter+0x5e7/0x950 fs/backing-file.c:274
       ovl_write_iter+0x2fd/0x3d0 fs/overlayfs/file.c:370
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x629/0xba0 fs/read_write.c:688
       ksys_pwrite64 fs/read_write.c:795 [inline]
       __do_sys_pwrite64 fs/read_write.c:803 [inline]
       __se_sys_pwrite64 fs/read_write.c:800 [inline]
       __x64_sys_pwrite64+0x19c/0x230 fs/read_write.c:800
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x3a/0x50 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       lock_two_nondirectories+0xe7/0x180 fs/inode.c:1254
       ext4_move_extents+0x20f/0x3950 fs/ext4/move_extent.c:589
       __ext4_ioctl fs/ext4/ioctl.c:1657 [inline]
       ext4_ioctl+0x3092/0x4b40 fs/ext4/ioctl.c:1922
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_writers#4);
                               lock(&ovl_i_mutex_key[depth]);
                               lock(sb_writers#4);
  lock(&ovl_i_mutex_key[depth]);

 *** DEADLOCK ***

1 lock held by syz.0.22/5968:
 #0: ffff88803ea9c480 (sb_writers#4){.+.+}-{0:0}, at: mnt_want_write_file+0x63/0x210 fs/namespace.c:537

stack backtrace:
CPU: 0 UID: 0 PID: 5968 Comm: syz.0.22 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 down_write+0x3a/0x50 kernel/locking/rwsem.c:1625
 inode_lock include/linux/fs.h:1029 [inline]
 lock_two_nondirectories+0xe7/0x180 fs/inode.c:1254
 ext4_move_extents+0x20f/0x3950 fs/ext4/move_extent.c:589
 __ext4_ioctl fs/ext4/ioctl.c:1657 [inline]
 ext4_ioctl+0x3092/0x4b40 fs/ext4/ioctl.c:1922
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb592a3ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc3443e838 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fb592cb5fa0 RCX: 00007fb592a3ce59
RDX: 0000200000000040 RSI: 00000000c028660f RDI: 0000000000000005
RBP: 00007fb592ad2d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb592cb5fac R14: 00007fb592cb5fa0 R15: 00007fb592cb5fa0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
