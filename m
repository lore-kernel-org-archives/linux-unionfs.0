Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB3115535B
	for <linux-unionfs@vger.kernel.org>; Sat,  1 Feb 2025 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738426346; cv=none; b=uj5rpKlNR6J5rfFnEReFHoRwYJqNy5VGPNtndXHAA+U6D3irQvIuiNjRvscfMHxBURo4yAwXdzFxFrewxdrlRMfeCnJO6V3jHmOXdTunlcrCvHrXFI3F69zap4/YTwqcdffqojNMBS9LIESWAKZmzyMBJfLUG3Ly+VlIZX/KGdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738426346; c=relaxed/simple;
	bh=JtZ04UNyH23V270wHtAoAJW6QpRgEi4X0u/ziEmXSbg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eBNLTxRHd7yYprEledflKgQMYnSxAB1VnY3pZH9VEMOYGzglXuRbl7wKIkeRtup5yOolYGoX9H8jg3yd+1zZXKVhcfzMMBi74PKqAf61VOelRV31ZDLHTi6gumbtZ19zSk8tNlFi2JEqyef166ZP6QlGxLMn/3R+W78CTRTuSNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-851f02bbfd8so174773039f.2
        for <linux-unionfs@vger.kernel.org>; Sat, 01 Feb 2025 08:12:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738426343; x=1739031143;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tyGD3kn0ahOYQSd5y7of5ZgUpydEeJctMr1j2Eqeg5I=;
        b=JuZT3Xp23rgXeZRf3PPOwKyt4FKqDUCINavmqNz2/2zrFyHGO/Wv9/TGFiNUokddqc
         bpqMANCX4YAWRaEn1PXtysugqR/oiaLgxi9dqM5nX+r4dOtXMhq5FZjxN+zSywTwT7tj
         lAJgz+0rzX/L0yTuTv13lCksZcQFZSbA66oo+HtD9h1E12mD5Vw/aslX1aptT7elCFFX
         +6qdW+tUBQWC5CSsINfP5LWUYmYFtI/6kfgEQcAfn9QdjucdZMk/YqXM9Mq2PlTUeddr
         1OtuCtS6IOq43oE2hpYoEQH8onoH/wGdXkPUOE3oho+CgakRQ6wxSanmpmTUdXiVF6As
         +54w==
X-Forwarded-Encrypted: i=1; AJvYcCWfjYvxQTCqjcTGDWAWGhYYU2AqAsaJUFuWWmtKKRZPfsVRTq1gTZ40tz6VyOLU3rCxb8Kvn2uQMAJotAHv@vger.kernel.org
X-Gm-Message-State: AOJu0YwRngM/QqDJi3b82G5bcwly/H1DA8IdaZojVtmOWhj7lrWrvcI8
	RXa1zCC9fHBoBUAnexOcNKtupwZU6ggb9rTpkecf1vjhn0JkG4qut78ysGT7ZreBp8Q6uhk4TCJ
	GyUMmHbFzVUPZS7g6jLar3n/k8GddqYKVGqgdZa4SXZy+Gw8fm88D+2E=
X-Google-Smtp-Source: AGHT+IEZeC/XfVZ5fWXRhpEada1rV5f/DE2gpaK0SLZAQFZrtNIdpPwsSEzNbwZbhcr5iAkS/zMgJ+gyIYB5xTLpQ/a/84+Gfx6X
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c24f:0:b0:3d0:1abc:fe03 with SMTP id
 e9e14a558f8ab-3d01abcff3emr46234015ab.15.1738426343697; Sat, 01 Feb 2025
 08:12:23 -0800 (PST)
Date: Sat, 01 Feb 2025 08:12:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679e47e7.050a0220.d7c5a.005f.GAE@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in ovl_create_object
From: syzbot <syzbot+93ea1efef88821c553ad@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    805ba04cb7cc Merge tag 'mips_6.14' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=157e6364580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ae8afe424ee551e
dashboard link: https://syzkaller.appspot.com/bug?extid=93ea1efef88821c553ad
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-805ba04c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f9b9a1354470/vmlinux-805ba04c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6c77f51f864a/bzImage-805ba04c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+93ea1efef88821c553ad@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.13.0-syzkaller-08291-g805ba04cb7cc #0 Not tainted
------------------------------------------------------
syz.4.1894/11640 is trying to acquire lock:
ffff88805ad04420 (sb_writers#6){.+.+}-{0:0}, at: ovl_create_object+0x12e/0x300 fs/overlayfs/dir.c:656

but task is already holding lock:
ffff8880362ed258 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}, at: inode_lock include/linux/fs.h:865 [inline]
ffff8880362ed258 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}, at: open_last_lookups fs/namei.c:3745 [inline]
ffff8880362ed258 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}, at: path_openat+0x15a4/0x2d80 fs/namei.c:3984

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}:
       down_read+0x9a/0x330 kernel/locking/rwsem.c:1524
       inode_lock_shared include/linux/fs.h:875 [inline]
       lookup_slow fs/namei.c:1807 [inline]
       walk_component+0x342/0x5b0 fs/namei.c:2112
       lookup_last fs/namei.c:2610 [inline]
       path_lookupat+0x17f/0x770 fs/namei.c:2634
       filename_lookup+0x221/0x5f0 fs/namei.c:2663
       kern_path+0x35/0x50 fs/namei.c:2771
       lookup_bdev+0xd9/0x280 block/bdev.c:1163
       resume_store+0x1d8/0x460 kernel/power/hibernate.c:1242
       kobj_attr_store+0x55/0x80 lib/kobject.c:840
       sysfs_kf_write+0x117/0x170 fs/sysfs/file.c:139
       kernfs_fop_write_iter+0x33d/0x500 fs/kernfs/file.c:334
       new_sync_write fs/read_write.c:586 [inline]
       vfs_write+0x5ae/0x1150 fs/read_write.c:679
       ksys_write+0x12b/0x250 fs/read_write.c:731
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&of->mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xb10 kernel/locking/mutex.c:730
       kernfs_fop_write_iter+0x27b/0x500 fs/kernfs/file.c:325
       iter_file_splice_write+0x90f/0x10b0 fs/splice.c:743
       do_splice_from fs/splice.c:941 [inline]
       do_splice+0x146a/0x1f70 fs/splice.c:1354
       __do_splice+0x327/0x360 fs/splice.c:1436
       __do_sys_splice fs/splice.c:1639 [inline]
       __se_sys_splice fs/splice.c:1621 [inline]
       __x64_sys_splice+0x187/0x250 fs/splice.c:1621
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&pipe->mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xb10 kernel/locking/mutex.c:730
       pipe_lock fs/pipe.c:92 [inline]
       pipe_lock+0x64/0x80 fs/pipe.c:89
       iter_file_splice_write+0x1eb/0x10b0 fs/splice.c:687
       do_splice_from fs/splice.c:941 [inline]
       do_splice+0x146a/0x1f70 fs/splice.c:1354
       __do_splice+0x327/0x360 fs/splice.c:1436
       __do_sys_splice fs/splice.c:1639 [inline]
       __se_sys_splice fs/splice.c:1621 [inline]
       __x64_sys_splice+0x187/0x250 fs/splice.c:1621
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_writers#6){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain kernel/locking/lockdep.c:3906 [inline]
       __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5228
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5851
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1773 [inline]
       sb_start_write include/linux/fs.h:1909 [inline]
       mnt_want_write+0x6f/0x450 fs/namespace.c:547
       ovl_create_object+0x12e/0x300 fs/overlayfs/dir.c:656
       lookup_open.isra.0+0x11c8/0x1580 fs/namei.c:3649
       open_last_lookups fs/namei.c:3748 [inline]
       path_openat+0x904/0x2d80 fs/namei.c:3984
       do_filp_open+0x20c/0x470 fs/namei.c:4014
       do_sys_openat2+0x17a/0x1e0 fs/open.c:1427
       do_sys_open fs/open.c:1442 [inline]
       __do_sys_open fs/open.c:1450 [inline]
       __se_sys_open fs/open.c:1446 [inline]
       __x64_sys_open+0x154/0x1e0 fs/open.c:1446
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  sb_writers#6 --> &of->mutex --> &ovl_i_mutex_dir_key[depth]#2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ovl_i_mutex_dir_key[depth]#2);
                               lock(&of->mutex);
                               lock(&ovl_i_mutex_dir_key[depth]#2);
  rlock(sb_writers#6);

 *** DEADLOCK ***

2 locks held by syz.4.1894/11640:
 #0: ffff88805690c420 (sb_writers#20){.+.+}-{0:0}, at: open_last_lookups fs/namei.c:3737 [inline]
 #0: ffff88805690c420 (sb_writers#20){.+.+}-{0:0}, at: path_openat+0x1fab/0x2d80 fs/namei.c:3984
 #1: ffff8880362ed258 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}, at: inode_lock include/linux/fs.h:865 [inline]
 #1: ffff8880362ed258 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}, at: open_last_lookups fs/namei.c:3745 [inline]
 #1: ffff8880362ed258 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}, at: path_openat+0x15a4/0x2d80 fs/namei.c:3984

stack backtrace:
CPU: 3 UID: 0 PID: 11640 Comm: syz.4.1894 Not tainted 6.13.0-syzkaller-08291-g805ba04cb7cc #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x490/0x760 kernel/locking/lockdep.c:2076
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2208
 check_prev_add kernel/locking/lockdep.c:3163 [inline]
 check_prevs_add kernel/locking/lockdep.c:3282 [inline]
 validate_chain kernel/locking/lockdep.c:3906 [inline]
 __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5228
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5851
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1773 [inline]
 sb_start_write include/linux/fs.h:1909 [inline]
 mnt_want_write+0x6f/0x450 fs/namespace.c:547
 ovl_create_object+0x12e/0x300 fs/overlayfs/dir.c:656
 lookup_open.isra.0+0x11c8/0x1580 fs/namei.c:3649
 open_last_lookups fs/namei.c:3748 [inline]
 path_openat+0x904/0x2d80 fs/namei.c:3984
 do_filp_open+0x20c/0x470 fs/namei.c:4014
 do_sys_openat2+0x17a/0x1e0 fs/open.c:1427
 do_sys_open fs/open.c:1442 [inline]
 __do_sys_open fs/open.c:1450 [inline]
 __se_sys_open fs/open.c:1446 [inline]
 __x64_sys_open+0x154/0x1e0 fs/open.c:1446
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb22938cda9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb22a1f9038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fb2295a5fa0 RCX: 00007fb22938cda9
RDX: 0000000000000000 RSI: 0000000000060142 RDI: 0000000020000000
RBP: 00007fb22940e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fb2295a5fa0 R15: 00007ffe95a187a8
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
