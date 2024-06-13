Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1E613B797
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Jun 2024 23:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718320041; cv=none; b=bjNrbuwUDLoIZ16lTD+YHMZmst5W+zOec1KxGHTJyZmSs8Puww44fgCO2eCVgcboy7zXHuhb32qz313xt6BpgLnRIbohgIx+mJY9j/9oCf3rFfublvYTlNn6/fQlOn7Ht2/Uvv57Jgi576PBGgX//m8xwlocn+5OxcRfvvWpYc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718320041; c=relaxed/simple;
	bh=n1Y5m9otBU6hte2PtnQK+im6Xep/yBqIajVHKBwgx9o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aw6MMxl99uOnY5BXk3nCl6Tasi7/1M6dO9o1Qc2GCVRuWA0yNC3xln9cBqjx8VshniiPl7citsv9AqRzn0ai4h4qbF3p0VdyLbqQsVK3jj9Jv522fI95bzKs/nThtqlqQGm6owsId21i9aeQs7YrAL/i6aqC9lSzv1slk/PXr2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-375cad499bbso15178945ab.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jun 2024 16:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718320039; x=1718924839;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dyz5r8hDyAsZrj6dPgAbaNIoJrRgDMa7wV/eJK12qFA=;
        b=k3q4eDPYhymR87pYOS9HpVIt20jUwqp+a8A8Qm83zxXVtYD0BP3UZ73k0ncmqTB/nR
         xS7vyAI1yZ0w3gKNRXpauJv2mLaWwOM5bbv28QO4hwONlIK1gXpI5SVucejPQjOlYLWi
         LUC+ipDG3MTL6UcS024Knko4hB/sqGTFdQtHQZlNHIt35A2peekb2EUF42D/BzungLNq
         u4fgifogdPAtzVTWq0e6NRdpeBaEWHL8upV22304gam301yzKOfKW1HrDBzXSApslshv
         AA1YUNerD2fyo02yu6b/1gxbfoV6DVUlrHbuZ9uVYAlNBkfdxvfPA3eMoI1sZJtThS4m
         WC7g==
X-Forwarded-Encrypted: i=1; AJvYcCUyDqjV2UTb+Rn6yMRUW8UcXsAcClm30tOf60uTB3UpybYZqJrTblgeJ2Ivaa9Y/TAW6/lZiRAABrIMeUKMF2VDJd51Kxs0olUaG3zNjA==
X-Gm-Message-State: AOJu0YwBcp0S+a2Pf0VCASU+DpX+DDcGYIrjmp/cVYVqUJvLnTlQrTMh
	Et2Dbw7XKzXYq5PIIQHLwGBuJF9O67Sd/T8ujFAbTnPReYjC9i+F+kND9W5PVKLmjMwQBJHu8OX
	/dF+bn4zCGSEON5QpkbOGcwoM4+dC1Zkb8SHfzuRZC8G56wAuzG/KN0A=
X-Google-Smtp-Source: AGHT+IECsQPiXRaL4Q7strF5/1JWWAVyQqHIbfg1tmCZ+Ec3k7G0Ph/GsCtd/o0H8++4rAOsxqadw9vO6k6dw9xqoSPpKAp4VC5A
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1389:b0:375:9e20:bee3 with SMTP id
 e9e14a558f8ab-375e0c74fd5mr605405ab.0.1718320038871; Thu, 13 Jun 2024
 16:07:18 -0700 (PDT)
Date: Thu, 13 Jun 2024 16:07:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000871190061acd8fed@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in ovl_copy_up_one
From: syzbot <syzbot+b778ac10fe2a0cd72517@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    771ed66105de Merge tag 'clk-fixes-for-linus' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15018032980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=399230c250e8119c
dashboard link: https://syzkaller.appspot.com/bug?extid=b778ac10fe2a0cd72517
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1253e6f6980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b2d41c980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-771ed661.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8d8815105845/vmlinux-771ed661.xz
kernel image: https://storage.googleapis.com/syzbot-assets/93a43d933942/bzImage-771ed661.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b778ac10fe2a0cd72517@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
6.10.0-rc2-syzkaller-00366-g771ed66105de #0 Not tainted
--------------------------------------------
syz-executor222/5195 is trying to acquire lock:
ffff888024f6a420 (sb_writers#5){.+.+}-{0:0}, at: ovl_do_copy_up fs/overlayfs/copy_up.c:967 [inline]
ffff888024f6a420 (sb_writers#5){.+.+}-{0:0}, at: ovl_copy_up_one+0x82a/0x3490 fs/overlayfs/copy_up.c:1168

but task is already holding lock:
ffff888024f6a420 (sb_writers#5){.+.+}-{0:0}, at: ovl_tmpfile+0x15b/0x6f0 fs/overlayfs/dir.c:1363

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sb_writers#5);
  lock(sb_writers#5);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by syz-executor222/5195:
 #0: ffff88801bbe2420 (sb_writers#10){.+.+}-{0:0}, at: do_tmpfile fs/namei.c:3761 [inline]
 #0: ffff88801bbe2420 (sb_writers#10){.+.+}-{0:0}, at: path_openat+0xc0f/0x29f0 fs/namei.c:3798
 #1: ffff888024f6a420 (sb_writers#5){.+.+}-{0:0}, at: ovl_tmpfile+0x15b/0x6f0 fs/overlayfs/dir.c:1363
 #2: ffff88803037a808 (&ovl_i_lock_key[depth]){+.+.}-{3:3}, at: ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:657 [inline]
 #2: ffff88803037a808 (&ovl_i_lock_key[depth]){+.+.}-{3:3}, at: ovl_copy_up_start+0x4d/0x2f0 fs/overlayfs/util.c:719

stack backtrace:
CPU: 0 PID: 5195 Comm: syz-executor222 Not tainted 6.10.0-rc2-syzkaller-00366-g771ed66105de #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 check_deadlock kernel/locking/lockdep.c:3062 [inline]
 validate_chain kernel/locking/lockdep.c:3856 [inline]
 __lock_acquire+0x20e6/0x3b30 kernel/locking/lockdep.c:5137
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1655 [inline]
 sb_start_write include/linux/fs.h:1791 [inline]
 ovl_start_write+0x130/0x310 fs/overlayfs/util.c:31
 ovl_do_copy_up fs/overlayfs/copy_up.c:967 [inline]
 ovl_copy_up_one+0x82a/0x3490 fs/overlayfs/copy_up.c:1168
 ovl_copy_up_flags+0x18d/0x200 fs/overlayfs/copy_up.c:1223
 ovl_create_tmpfile fs/overlayfs/dir.c:1317 [inline]
 ovl_tmpfile+0x2b8/0x6f0 fs/overlayfs/dir.c:1373
 vfs_tmpfile+0x2be/0x540 fs/namei.c:3701
 do_tmpfile fs/namei.c:3764 [inline]
 path_openat+0xc8e/0x29f0 fs/namei.c:3798
 do_filp_open+0x1dc/0x430 fs/namei.c:3834
 do_sys_openat2+0x17a/0x1e0 fs/open.c:1405
 do_sys_open fs/open.c:1420 [inline]
 __do_sys_open fs/open.c:1428 [inline]
 __se_sys_open fs/open.c:1424 [inline]
 __x64_sys_open+0x154/0x1e0 fs/open.c:1424
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9268e3ef49
Code: 48 83 c4 28 c3 e8 67 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff6faf26d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fff6faf26e0 RCX: 00007f9268e3ef49
RDX: 0000000000000000 RSI: 0000000000591002 RDI: 0000000020000100
RBP: 00007fff6faf26e8 R08: 00007f9268e0bf50 R09: 00007f9268e0bf50
R10: 00007f9268e0bf50 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff6faf2948 R14: 0000000000000001 R15: 0000000000000001
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
