Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AB110A36
	for <linux-unionfs@vger.kernel.org>; Mon, 27 May 2024 06:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716792444; cv=none; b=nqcaT9fRH3ngL3r8SA6xPFC3c5Gquyp96OX5l0x5jwY39IhahLpVVugXKN2smD04iXs/Lf17HmZ3duQFdYZSejQA3EyjOkbRzH1yweZnqy/yPPvdY2CB8kEAojn7UeJSUUie1LdsIvTsDmKLVgfFsWGgMVEBZ8Jg2gCJpiTOeYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716792444; c=relaxed/simple;
	bh=uinJ2gLeCoRdr0Fk4l9/eDWL3T2/p4iaiPNTcJGHAlk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qpwvqyLEXlyXsDEVIlXPUKlG+1SSiNnr3sZutHQ3Tfn283juvzmL2iimSdyCy7yJkmsymWEMwIqm/x/DYT79ddkTsB0uP/pEEhae8VnshHbYz+hg9D24wvHOcPKHxQR09VRU8m5mOFCPYcrna3Yz2oVM4dXRlfcuAHLFgYdOwNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3713862bcefso38287665ab.0
        for <linux-unionfs@vger.kernel.org>; Sun, 26 May 2024 23:47:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716792442; x=1717397242;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OwO70/XYVuf3nef+i69Y/PpyG5l9UkE9yqtW/mEST84=;
        b=UsBMa7JVKrmi9rbtR1LIHUoDgB4bYA6NmtoAey1ad8lUSMiKzOuhBSlmEamE4XrCNa
         bd2P5p/AZIZ8NpqmUHxafdG+FOZ8kUlTodW84kcUR4BbZyqbcXYC8lfeMnYLR2oL4KE8
         ZPeakHjof2Sl9jA1nRbFQOKghq4Nk9QUphsL8q7khfMa61cVa6GCdblRqCi2ZIhXaRDQ
         1as7i+bckMPUCtreWpPl0+3hH5gAZsOC3ClIhFdu3TI5iTwRTanUL3ULRy/PztoK0gRX
         xVGFffwMfH0lDcJFV4JH/pW8HeY8SPjpo7kVfHP7tnyRq4IFYmsZ4Go3ShMxWYEFMSgl
         fGGw==
X-Forwarded-Encrypted: i=1; AJvYcCXOxnMxMU88T0gaESEPVBgITLsv+UFohl/y0MVfE8stcZogn4XD3PR9JAXmVs/PQ/0+UC+F5RBBBnKBxRk8pUPyZxCLvAdrhDr7b2WPrA==
X-Gm-Message-State: AOJu0YxFl2T+gw1UyUdYM1qiYs2EiH5G6T90FBPM6Pcu3W6OD4pEkxRG
	M+5Vfs5Udzyvu4heK59Gaa0cPzPiCrCKhO4SJ1XEAheuDFPziEGolGLmNzFLHnSOdrfuk55sDP/
	0R1AV7mraQZmlwE3RvdOoEwJSyNH7TwI3WV8Ugcl7SIQTJ7C5Xk1b0Vg=
X-Google-Smtp-Source: AGHT+IH4e/7wy43OeXcp2oVoO/pPSXJY8v735rWJFcob5AQbcSfCopjwq7FKlq8jDH6Ki5W3SVt0l7o3ahGCQeJr9/jOdn3HrTUk
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:6408:0:b0:374:5776:de62 with SMTP id
 e9e14a558f8ab-3745776e1bdmr586845ab.2.1716792442204; Sun, 26 May 2024
 23:47:22 -0700 (PDT)
Date: Sun, 26 May 2024 23:47:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000abc6c5061969e3a5@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in seq_read_iter (4)
From: syzbot <syzbot+fcdd1f09adf0e00f70b1@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b6394d6f7159 Merge tag 'pull-misc' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135d2872980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=713476114e57eef3
dashboard link: https://syzkaller.appspot.com/bug?extid=fcdd1f09adf0e00f70b1
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8e1377d4772/disk-b6394d6f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/19fbbb3b6dd5/vmlinux-b6394d6f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4dcce16af95d/bzImage-b6394d6f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fcdd1f09adf0e00f70b1@syzkaller.appspotmail.com

EXT4-fs (loop3): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: writeback.
ext4 filesystem being mounted at /root/syzkaller-testdir1425634012/syzkaller.WKKmVT/16/bus supports timestamps until 2038-01-19 (0x7fffffff)
======================================================
WARNING: possible circular locking dependency detected
6.9.0-syzkaller-10729-gb6394d6f7159 #0 Not tainted
------------------------------------------------------
syz-executor.3/6567 is trying to acquire lock:
ffff88805cad90a0 (&p->lock){+.+.}-{3:3}, at: seq_read_iter+0xb7/0xd60 fs/seq_file.c:182

but task is already holding lock:
ffff88801eec3c68 (&pipe->mutex){+.+.}-{3:3}, at: splice_file_to_pipe+0x2e/0x500 fs/splice.c:1292

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&pipe->mutex){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       iter_file_splice_write+0x335/0x14e0 fs/splice.c:687
       do_splice_from fs/splice.c:941 [inline]
       do_splice+0xd77/0x1900 fs/splice.c:1354
       __do_splice fs/splice.c:1436 [inline]
       __do_sys_splice fs/splice.c:1652 [inline]
       __se_sys_splice+0x331/0x4a0 fs/splice.c:1634
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (sb_writers#4){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1655 [inline]
       sb_start_write+0x4d/0x1c0 include/linux/fs.h:1791
       mnt_want_write+0x3f/0x90 fs/namespace.c:409
       ovl_setattr+0x2de/0x5a0 fs/overlayfs/inode.c:77
       notify_change+0xb9d/0xe70 fs/attr.c:497
       vfs_utimes+0x4b5/0x770 fs/utimes.c:66
       do_utimes_path fs/utimes.c:99 [inline]
       do_utimes fs/utimes.c:145 [inline]
       __do_sys_utime fs/utimes.c:226 [inline]
       __se_sys_utime+0x1e1/0x2e0 fs/utimes.c:215
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ovl_i_mutex_dir_key[depth]#2){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
       inode_lock_shared include/linux/fs.h:801 [inline]
       lookup_slow+0x45/0x70 fs/namei.c:1708
       walk_component+0x2e1/0x410 fs/namei.c:2004
       lookup_last fs/namei.c:2469 [inline]
       path_lookupat+0x16f/0x450 fs/namei.c:2493
       filename_lookup+0x256/0x610 fs/namei.c:2522
       kern_path+0x35/0x50 fs/namei.c:2630
       lookup_bdev+0xc5/0x290 block/bdev.c:1157
       resume_store+0x1a0/0x710 kernel/power/hibernate.c:1235
       kernfs_fop_write_iter+0x3a1/0x500 fs/kernfs/file.c:334
       new_sync_write fs/read_write.c:497 [inline]
       vfs_write+0xa72/0xc90 fs/read_write.c:590
       ksys_write+0x1a0/0x2c0 fs/read_write.c:643
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&of->mutex){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       kernfs_seq_start+0x53/0x3b0 fs/kernfs/file.c:154
       seq_read_iter+0x3d0/0xd60 fs/seq_file.c:225
       copy_splice_read+0x662/0xb60 fs/splice.c:365
       do_splice_read fs/splice.c:985 [inline]
       splice_direct_to_actor+0x4b7/0xc90 fs/splice.c:1089
       do_splice_direct_actor fs/splice.c:1207 [inline]
       do_splice_direct+0x28c/0x3e0 fs/splice.c:1233
       do_sendfile+0x56d/0xe10 fs/read_write.c:1295
       __do_sys_sendfile64 fs/read_write.c:1362 [inline]
       __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1348
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&p->lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain+0x18cb/0x58e0 kernel/locking/lockdep.c:3869
       __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       seq_read_iter+0xb7/0xd60 fs/seq_file.c:182
       copy_splice_read+0x662/0xb60 fs/splice.c:365
       do_splice_read fs/splice.c:985 [inline]
       splice_file_to_pipe+0x299/0x500 fs/splice.c:1295
       do_sendfile+0x515/0xe10 fs/read_write.c:1301
       __do_sys_sendfile64 fs/read_write.c:1362 [inline]
       __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1348
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &p->lock --> sb_writers#4 --> &pipe->mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&pipe->mutex);
                               lock(sb_writers#4);
                               lock(&pipe->mutex);
  lock(&p->lock);

 *** DEADLOCK ***

1 lock held by syz-executor.3/6567:
 #0: ffff88801eec3c68 (&pipe->mutex){+.+.}-{3:3}, at: splice_file_to_pipe+0x2e/0x500 fs/splice.c:1292

stack backtrace:
CPU: 1 PID: 6567 Comm: syz-executor.3 Not tainted 6.9.0-syzkaller-10729-gb6394d6f7159 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3134 [inline]
 check_prevs_add kernel/locking/lockdep.c:3253 [inline]
 validate_chain+0x18cb/0x58e0 kernel/locking/lockdep.c:3869
 __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
 seq_read_iter+0xb7/0xd60 fs/seq_file.c:182
 copy_splice_read+0x662/0xb60 fs/splice.c:365
 do_splice_read fs/splice.c:985 [inline]
 splice_file_to_pipe+0x299/0x500 fs/splice.c:1295
 do_sendfile+0x515/0xe10 fs/read_write.c:1301
 __do_sys_sendfile64 fs/read_write.c:1362 [inline]
 __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1348
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fad33e7cee9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fad34b5b0c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007fad33fabf80 RCX: 00007fad33e7cee9
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 000000000000000a
RBP: 00007fad33ec949e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000100801700 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007fad33fabf80 R15: 00007ffed6123a38
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
