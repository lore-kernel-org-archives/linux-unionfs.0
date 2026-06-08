Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2055D4071CA
	for <linux-unionfs@vger.kernel.org>; Mon,  8 Jun 2026 23:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960534; cv=none; b=bA1G/gjZAEgWez579NMW3ZtbvcioO5uiP0MWbr53v+rD+1fizGDWJ3gyFpivrOI7blTo5QvqHUvnvu2kwTMGBvoMwO+GffKIVaw6c4UDZvXikawRFrHSkRRlQcjAgHJM1wu3dqF7NxUyOu+sOtbrYt2/kbCaqP11OYRl1dEkBfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960534; c=relaxed/simple;
	bh=u/c2UJgHba4bu+luPnrKhYslUgNgA/CgLZn1nBCNkU4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DBB0fco36q0Pm4dpyzJC62mOkIJ2K9TFpQYtzl4ZPPkZQ/mMAYJ+m12J1Kj+yVMTO3tog+ZguXM3lhEEIiqKRNUlWz92S7s4QG7Sx3EhSzFNUylJC/hKwbh7AnQNxq/3KdfQQALPMsdneUgJF9eGwGcrhc1qsn5WRZ+gWBOEyoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7e6d9be94a2so3842578a34.1
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Jun 2026 16:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780960532; x=1781565332;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L5S5wmIGUcqFIkrVsA5/P1zutrYnuAieN/KICqmjtD4=;
        b=M3lcbcpnoITOoQkz3DHc4cPYPw6Y33p+H+rVf414QQkXVhwKH55dD8IXMymzR8p2au
         1tqHH+6nN4dlCejlVGyd1hSPUZvZVQH4EyJmy2N7HqTXIjJKSVrDNAaEEiNfHO4dpGPM
         K5N5JMMvRheGv01JLCbrkYedDiHv24N+2Zjyz8HK53UyQCAaiLljCZXSUKSsjUdwVhm1
         IYC8JRKSZ/zT4AczYQsaVZf7336Nx2XIjpCBQ6LLplJa4kmqRD4mwGc7ysUIv3GnxgxY
         2S08U5J+wrN+9CuQrxuDkeqlulJ4apjuO+yEZD9lo7VcH0xKMf5kEknZ4IBcArRrJxmr
         x7SQ==
X-Forwarded-Encrypted: i=1; AFNElJ+go/2d7x1XJoqLquDJ3f4oEnZUBDWXwCe/D7jDbjXiJ4yds3CRc9Piu8Yipc3LQHtIagb1McmCzdOOeiyh@vger.kernel.org
X-Gm-Message-State: AOJu0YxBm5gziqFguy8GKe0na1eKv02QSPcr2FAsOV0nUuygpMHPZmn2
	OOV4a0dMn21EGfDhcA3v+r7BKNRZC0Xz/bO0dP+HWlA/52EPWaH1x1m1emAeVSliIkfLRRAQCTI
	TIatXIwFzPJq9tCbR6CySrU55qrOFcF3wOoZ1tU2gDxo+3ARxqDdguiGIOsM=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1514:b0:69d:9288:66bc with SMTP id
 006d021491bc7-69e68b09a6fmr8367147eaf.5.1780960532137; Mon, 08 Jun 2026
 16:15:32 -0700 (PDT)
Date: Mon, 08 Jun 2026 16:15:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a274d14.c25708ab.1b19ef.0016.GAE@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in mnt_want_write (8)
From: syzbot <syzbot+1e5626d6fd59853cbfaa@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ec7ef10b77a6 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17a17dd2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=522222e78af9b9d2
dashboard link: https://syzkaller.appspot.com/bug?extid=1e5626d6fd59853cbfaa
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/22c81873d970/disk-ec7ef10b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ba2c817c4ea9/vmlinux-ec7ef10b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/04c4e1c1bb56/Image-ec7ef10b.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1e5626d6fd59853cbfaa@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.5.673/7842 is trying to acquire lock:
ffff0000d814a410 (sb_writers#3){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:493

but task is already holding lock:
ffff0000dc947230 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
ffff0000dc947230 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_nlink_start+0xc8/0x350 fs/overlayfs/util.c:1173

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
       el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
       el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
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
       el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
       el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
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
       sb_start_write+0x5c/0x294 include/linux/fs/super.h:125
       mnt_want_write+0x44/0x9c fs/namespace.c:493
       ovl_want_write fs/overlayfs/util.c:38 [inline]
       ovl_nlink_start+0x154/0x350 fs/overlayfs/util.c:1177
       ovl_do_remove+0x1c0/0xa04 fs/overlayfs/dir.c:954
       ovl_rmdir+0x24/0x34 fs/overlayfs/dir.c:993
       vfs_rmdir+0x34c/0x5a0 fs/namei.c:5366
       filename_rmdir+0x208/0x3dc fs/namei.c:5421
       __do_sys_unlinkat fs/namei.c:5596 [inline]
       __se_sys_unlinkat fs/namei.c:5589 [inline]
       __arm64_sys_unlinkat+0xc8/0x104 fs/namei.c:5589
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
       el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
       el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
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

4 locks held by syz.5.673/7842:
 #0: ffff0000d924c410 (sb_writers#17){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:493
 #1: ffff0000dc944300 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1074 [inline]
 #1: ffff0000dc944300 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: __start_dirop+0xa0/0xf4 fs/namei.c:2914
 #2: ffff0000dc946ec0 (&ovl_i_mutex_dir_key[depth]){++++}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #2: ffff0000dc946ec0 (&ovl_i_mutex_dir_key[depth]){++++}-{4:4}, at: vfs_rmdir+0x110/0x5a0 fs/namei.c:5351
 #3: ffff0000dc947230 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
 #3: ffff0000dc947230 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_nlink_start+0xc8/0x350 fs/overlayfs/util.c:1173

stack backtrace:
CPU: 1 UID: 0 PID: 7842 Comm: syz.5.673 Tainted: G             L      syzkaller #0 PREEMPT 
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
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_write+0x5c/0x294 include/linux/fs/super.h:125
 mnt_want_write+0x44/0x9c fs/namespace.c:493
 ovl_want_write fs/overlayfs/util.c:38 [inline]
 ovl_nlink_start+0x154/0x350 fs/overlayfs/util.c:1177
 ovl_do_remove+0x1c0/0xa04 fs/overlayfs/dir.c:954
 ovl_rmdir+0x24/0x34 fs/overlayfs/dir.c:993
 vfs_rmdir+0x34c/0x5a0 fs/namei.c:5366
 filename_rmdir+0x208/0x3dc fs/namei.c:5421
 __do_sys_unlinkat fs/namei.c:5596 [inline]
 __se_sys_unlinkat fs/namei.c:5589 [inline]
 __arm64_sys_unlinkat+0xc8/0x104 fs/namei.c:5589
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
