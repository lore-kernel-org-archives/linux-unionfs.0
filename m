Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3362F2561D
	for <linux-unionfs@vger.kernel.org>; Fri,  8 Nov 2024 04:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731041246; cv=none; b=lbrJlktsH2Q8z69KsXxT6yXz2UazGgEjwxCo3aUV8OT0v5RW8xepRlmx4wIQuVJ6fddV9HvMtLI0Qt0uGF/oisFKmr9O2EhiswwTewNi1Sqyb0i/NC5Ff3N1s3Dy/9AE+T+1LhGqHocbAtLxrF7JdL057lSKWHQPikqrXoyN6+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731041246; c=relaxed/simple;
	bh=FxOERmQoaZm1/dKPeopIgLX7XhlQVT48y1z2KaMXJcU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ueCadl/93WOiQ7A2fpnUEj0P7y7A3vhd9gLLJCmyf4ckE0/bl7B/zaVQ7uP0fkwr27vn0OQZ+0KdPVrsxFr/Zncat+Rzy/0bwmsYbOeTX+HSPGnidP+rZwatsebiStpdjwHhlQKIvu/zqYQeyLeF8qIEuLjIVIWzQ123e2wsGd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83adc5130e3so189068339f.0
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Nov 2024 20:47:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731041243; x=1731646043;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qrP/XI7t3oNPB4GVpNZrHEl8KPsWvfRvYQSdcSEumP4=;
        b=Q8ZOAba3/+rFxeTzQGIgVimYRlcuzqlx0WaZT13qN6AG3Nv9B0X5W+fpeSHxu9leY8
         6m/ze6foe7HzLVHdfI85BMpXp6RynpATy1QRewldjiZaAb9clGa9Yf9kmP/0Tl18NA5M
         HDO/UAIo/BxEiw4qU11AQYqMDkj1Tl+JLvt93QDhenrUE2QAnUQuEjEM9Opv2k8v4oMc
         2BLRkuGyz339ae+nkTURbtbX7ie9DYy90JpdQfK65ZMXCPuNFFXSaH1ADQVSQlrzs4WE
         iJvorBakmut+CauGuhlwWdZlVLDPU52I6dmhVJC/CSTxDPCdQ5KUOq47MeanP/wYdC6B
         poMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgwwMNKGV5uE6ZifvRaHN89wljujG8AA0Cub0+Kxj78ykBRnh83yWEKVplHT4LzA6Q/Of+PjArHQXZAod6@vger.kernel.org
X-Gm-Message-State: AOJu0YxN61rThBzKuTPvMI26k6e48kFwpg8uqpSn4OBG2fNh9/qhlTcJ
	9C39JxXk3yos5zyGVwtxQXpSTkQVZuGaFiVTcD62GqZIh1t37C7V7UV9lXaaAnZino+lFX20Ccs
	59eFy/gUvBwRhiFe2Ggid+mpVhNyiiKWtAkwKaGBq3WFxt+W9XxWZ9WA=
X-Google-Smtp-Source: AGHT+IG5rXH6vO/KfjlfhelxGe1lEVQ8Zq/HJVSDFkTHAX9UPVDwSTPhzaslXYewE4M90hrK4XxkmWD1Hm6Lsrjdy9cWCXq08v2q
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1949:b0:3a3:778e:45cd with SMTP id
 e9e14a558f8ab-3a6f1a4c181mr18977855ab.21.1731041243339; Thu, 07 Nov 2024
 20:47:23 -0800 (PST)
Date: Thu, 07 Nov 2024 20:47:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672d97db.050a0220.15a23d.01ac.GAE@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in pipe_lock (6)
From: syzbot <syzbot+603e6f91a1f6c5af8c02@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a33ab3f94f51 Merge tag 'kbuild-fixes-v6.12-2' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ab06a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=728f7ffd25400452
dashboard link: https://syzkaller.appspot.com/bug?extid=603e6f91a1f6c5af8c02
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-a33ab3f9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1ddf4248da4a/vmlinux-a33ab3f9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/79ee0fff762e/bzImage-a33ab3f9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+603e6f91a1f6c5af8c02@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc5-syzkaller-00330-ga33ab3f94f51 #0 Not tainted
------------------------------------------------------
syz.6.2203/14529 is trying to acquire lock:
ffff888032ab3468 (&pipe->mutex){+.+.}-{3:3}, at: pipe_lock fs/pipe.c:92 [inline]
ffff888032ab3468 (&pipe->mutex){+.+.}-{3:3}, at: pipe_lock+0x64/0x80 fs/pipe.c:89

but task is already holding lock:
ffff88802c2dc420 (sb_writers#6){.+.+}-{0:0}, at: __do_splice+0x327/0x360 fs/splice.c:1436

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (
sb_writers#6
){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_write include/linux/fs.h:1852 [inline]
       mnt_want_write+0x6f/0x450 fs/namespace.c:515
       ovl_create_object+0x12e/0x300 fs/overlayfs/dir.c:642
       lookup_open.isra.0+0x1174/0x14c0 fs/namei.c:3595
       open_last_lookups fs/namei.c:3694 [inline]
       path_openat+0x904/0x2d60 fs/namei.c:3930
       do_filp_open+0x1dc/0x430 fs/namei.c:3960
       do_sys_openat2+0x17a/0x1e0 fs/open.c:1415
       do_sys_open fs/open.c:1430 [inline]
       __do_sys_openat fs/open.c:1446 [inline]
       __se_sys_openat fs/open.c:1441 [inline]
       __x64_sys_openat+0x175/0x210 fs/open.c:1441
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (
&ovl_i_mutex_dir_key[depth]
#3){++++}-{3:3}
:
       down_read+0x9a/0x330 kernel/locking/rwsem.c:1524
       inode_lock_shared include/linux/fs.h:825 [inline]
       lookup_slow fs/namei.c:1748 [inline]
       walk_component+0x342/0x5b0 fs/namei.c:2053
       lookup_last fs/namei.c:2556 [inline]
       path_lookupat+0x17f/0x770 fs/namei.c:2580
       filename_lookup+0x1e5/0x5b0 fs/namei.c:2609
       kern_path+0x35/0x50 fs/namei.c:2717
       lookup_bdev+0xd9/0x280 block/bdev.c:1164
       resume_store+0x1d8/0x460 kernel/power/hibernate.c:1239
       kobj_attr_store+0x55/0x80 lib/kobject.c:840
       sysfs_kf_write+0x117/0x170 fs/sysfs/file.c:136
       kernfs_fop_write_iter+0x33d/0x500 fs/kernfs/file.c:334
       new_sync_write fs/read_write.c:590 [inline]
       vfs_write+0x5ae/0x1150 fs/read_write.c:683
       ksys_write+0x12f/0x260 fs/read_write.c:736
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&of->mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x175/0x9c0 kernel/locking/mutex.c:752
       kernfs_fop_write_iter+0x27b/0x500 fs/kernfs/file.c:325
       iter_file_splice_write+0x90f/0x10b0 fs/splice.c:743
       do_splice_from fs/splice.c:941 [inline]
       do_splice+0x145c/0x1f60 fs/splice.c:1354
       __do_splice+0x327/0x360 fs/splice.c:1436
       __do_sys_splice fs/splice.c:1652 [inline]
       __se_sys_splice fs/splice.c:1634 [inline]
       __x64_sys_splice+0x1cd/0x270 fs/splice.c:1634
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&pipe->mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x250b/0x3ce0 kernel/locking/lockdep.c:5202
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x175/0x9c0 kernel/locking/mutex.c:752
       pipe_lock fs/pipe.c:92 [inline]
       pipe_lock+0x64/0x80 fs/pipe.c:89
       iter_file_splice_write+0x1eb/0x10b0 fs/splice.c:687
       do_splice_from fs/splice.c:941 [inline]
       do_splice+0x145c/0x1f60 fs/splice.c:1354
       __do_splice+0x327/0x360 fs/splice.c:1436
       __do_sys_splice fs/splice.c:1652 [inline]
       __se_sys_splice fs/splice.c:1634 [inline]
       __x64_sys_splice+0x1cd/0x270 fs/splice.c:1634
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &pipe->mutex --> &ovl_i_mutex_dir_key[depth]#3 --> sb_writers#6

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_writers#6);
                               lock(&ovl_i_mutex_dir_key[depth]#3);
                               lock(sb_writers#6);
  lock(&pipe->mutex);

 *** DEADLOCK ***

1 lock held by syz.6.2203/14529:
 #0: ffff88802c2dc420 (sb_writers#6){.+.+}-{0:0}, at: __do_splice+0x327/0x360 fs/splice.c:1436

stack backtrace:
CPU: 0 UID: 0 PID: 14529 Comm: syz.6.2203 Not tainted 6.12.0-rc5-syzkaller-00330-ga33ab3f94f51 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x41c/0x610 kernel/locking/lockdep.c:2074
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x250b/0x3ce0 kernel/locking/lockdep.c:5202
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5825
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x175/0x9c0 kernel/locking/mutex.c:752
 pipe_lock fs/pipe.c:92 [inline]
 pipe_lock+0x64/0x80 fs/pipe.c:89
 iter_file_splice_write+0x1eb/0x10b0 fs/splice.c:687
 do_splice_from fs/splice.c:941 [inline]
 do_splice+0x145c/0x1f60 fs/splice.c:1354
 __do_splice+0x327/0x360 fs/splice.c:1436
 __do_sys_splice fs/splice.c:1652 [inline]
 __se_sys_splice fs/splice.c:1634 [inline]
 __x64_sys_splice+0x1cd/0x270 fs/splice.c:1634
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7fd357e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7fd434e038 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 00007f7fd3735f80 RCX: 00007f7fd357e719
RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f7fd35f132e R08: 0000000000001003 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f7fd3735f80 R15: 00007fff4fba4458
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
