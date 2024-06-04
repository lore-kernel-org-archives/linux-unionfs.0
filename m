Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E7153BE
	for <linux-unionfs@vger.kernel.org>; Tue,  4 Jun 2024 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717527030; cv=none; b=MmrGDPI0V2LB8qzRkk5ymHBiSqu9HEV9urOxxKcOWsKUv1bHC8+DYCuyDaVnOJwHG3v5RpOgA8NbcXv89q11IRq+NKb4O63Uj4ORsiQ96a3gQhxDjEdqS32pvMsvSFcDg5NMwdVbK/uWWq73FMBRcIn4Vlkl+7iUf1RWHXkj5no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717527030; c=relaxed/simple;
	bh=krSPU5pOGZIAztx1Wl/6rjG1rE9uG42eSwQTDza2NMY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LlemOe1GKGMlMpZmPN2CXVqc9KI11ReDRPgyWSmHbhUfeUsBvR/NzR7MOVJEuEnpk2sFrbs3S17ywpSXxREU080TqWiANFNdH13Uo9VIAUIv3O2M8zKj1XDQIeVdBLEutSiRjxmRovUHfZz6tWsN2knUVdO7OFgH9bJ/P96BK/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-37497716eb5so13675145ab.2
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Jun 2024 11:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717527028; x=1718131828;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T2+QoTfTwrlWaCODQk6HKVoeseQOgSTMFKHIgcLAPAI=;
        b=GT92EXnYqCs339GKro0KTjvhFiPHH1fYYwTmAS9MHjmKeKpwIABO5+oOV+DfZndYie
         s705oMck22EliY7d/9Be8m1zIzn6dHalx6FqdeJQeN+lO/QD8KmsRlFzbtoE05OnKhQ/
         uzL5h281kerto2Nb/u9QMKHg13OEr7R0jxhkbspsiUcn3MlRmA0b1+NQejToflEBYvkp
         6iCGnpdHNE1cL+PLNFVATnKoMUtTlcqBp6cqQHBewqdwZjS3+5h+/7zvXAJgwNHDTaCV
         bjGVK3FcScF99l3VYybr7NFtRBrQicrge8q90Mfb8IN7gi6B9WML6RvQXzugkQ/9CdZh
         cHjQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3fIx/ww0TVkJSkoUj1BmfMYO15mEOVvI7yckT2UasX4qfbRcsVCjPxga5axIrHBsau7OsJ1fWJ5qWdFfcAPxErfQCqOABUnGDPvvTzw==
X-Gm-Message-State: AOJu0YzL8wDrqLjJV0Xy0mInQdVvjgBP2jBicGRvnJRpFBcYO5pZLLVZ
	zAyKCXoY/GcHvC276+xLUhQCDK/U/xblFl9Tuo9HEi2LLfCPMbzggLjzRk5ujTXP02wPPFsFvOf
	NmEMhmsazvc/cESG/4IFZF/VaQtF6h8OcaONIYyl5N8D4ZYvOK+/9j2M=
X-Google-Smtp-Source: AGHT+IFMmkq9LUlnObuOg19vG4/2PM1sJneKxfvtoUUF24p037G1AY3/r76wSeDcAAfyEtgiihzjK/yf/8eOXU6/ZEz/to3XQIQi
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c26b:0:b0:371:139d:ba7e with SMTP id
 e9e14a558f8ab-374b1f6585fmr114445ab.3.1717527028008; Tue, 04 Jun 2024
 11:50:28 -0700 (PDT)
Date: Tue, 04 Jun 2024 11:50:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065b2f6061a14ecde@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in iter_file_splice_write (4)
From: syzbot <syzbot+5ce16f43e888965f009d@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f06ce441457d Merge tag 'loongarch-fixes-6.10-1' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1435a032980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb72437243175f22
dashboard link: https://syzkaller.appspot.com/bug?extid=5ce16f43e888965f009d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/00ecb7bdd1a8/disk-f06ce441.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3926ab949197/vmlinux-f06ce441.xz
kernel image: https://storage.googleapis.com/syzbot-assets/36849eea4fc5/bzImage-f06ce441.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ce16f43e888965f009d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.10.0-rc2-syzkaller-00007-gf06ce441457d #0 Not tainted
------------------------------------------------------
syz-executor.3/17052 is trying to acquire lock:
ffff888022903468 (&pipe->mutex){+.+.}-{3:3}, at: iter_file_splice_write+0x335/0x14e0 fs/splice.c:687

but task is already holding lock:
ffff8880292be420 (sb_writers#4){.+.+}-{0:0}, at: do_splice+0xcf0/0x1900 fs/splice.c:1353

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (sb_writers#4){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1655 [inline]
       sb_start_write+0x4d/0x1c0 include/linux/fs.h:1791
       mnt_want_write+0x3f/0x90 fs/namespace.c:409
       ovl_create_object+0x13b/0x370 fs/overlayfs/dir.c:642
       lookup_open fs/namei.c:3505 [inline]
       open_last_lookups fs/namei.c:3574 [inline]
       path_openat+0x1425/0x3280 fs/namei.c:3804
       do_filp_open+0x235/0x490 fs/namei.c:3834
       do_sys_openat2+0x13e/0x1d0 fs/open.c:1405
       do_sys_open fs/open.c:1420 [inline]
       __do_sys_openat fs/open.c:1436 [inline]
       __se_sys_openat fs/open.c:1431 [inline]
       __x64_sys_openat+0x247/0x2a0 fs/open.c:1431
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (&ovl_i_mutex_dir_key[depth]
){++++}-{3:3}:
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
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&of->mutex){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       kernfs_seq_start+0x53/0x3b0 fs/kernfs/file.c:154
       seq_read_iter+0x3d0/0xd60 fs/seq_file.c:225
       do_iter_readv_writev+0x5a4/0x800
       vfs_readv+0x2b6/0xa90 fs/read_write.c:932
       do_preadv fs/read_write.c:1049 [inline]
       __do_sys_preadv fs/read_write.c:1099 [inline]
       __se_sys_preadv fs/read_write.c:1094 [inline]
       __x64_sys_preadv+0x1c7/0x2d0 fs/read_write.c:1094
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&p->lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       seq_read_iter+0xb7/0xd60 fs/seq_file.c:182
       copy_splice_read+0x662/0xb60 fs/splice.c:365
       do_splice_read fs/splice.c:985 [inline]
       splice_file_to_pipe+0x299/0x500 fs/splice.c:1295
       do_sendfile+0x515/0xe10 fs/read_write.c:1301
       __do_sys_sendfile64 fs/read_write.c:1356 [inline]
       __se_sys_sendfile64+0x100/0x1e0 fs/read_write.c:1348
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&pipe->mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3869
       __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
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
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  
&pipe->mutex --> &ovl_i_mutex_dir_key[depth] --> sb_writers#4

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_writers#4);
                               lock(&ovl_i_mutex_dir_key[depth]);
                               lock(sb_writers#4);
  lock(&pipe->mutex);

 *** DEADLOCK ***

1 lock held by syz-executor.3/17052:
 #0: ffff8880292be420 (sb_writers#4){.+.+}-{0:0}, at: do_splice+0xcf0/0x1900 fs/splice.c:1353

stack backtrace:
CPU: 1 PID: 17052 Comm: syz-executor.3 Not tainted 6.10.0-rc2-syzkaller-00007-gf06ce441457d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3134 [inline]
 check_prevs_add kernel/locking/lockdep.c:3253 [inline]
 validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3869
 __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
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
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f93d627cf69
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f93d5dde0c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 00007f93d63b4070 RCX: 00007f93d627cf69
RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f93d62da706 R08: 00000000ffffffe1 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f93d63b4070 R15: 00007ffc1c7ac468
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
