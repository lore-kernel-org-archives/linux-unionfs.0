Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795573770;
	b=MRt6A0dmZOxzKicMX3Yz1CKOHrEXf2w4TLsGlsXeQLzI6E3JaNLP0mXSo9H3Q9lz4iti
	 1sDm5xeJjN9a0kXzp+cly8P/PfBoVXQbW8AT53DgAbnUsq2SU6X9s8xTe2XBCLaoqkrDg
	 DWifT5qQA4Y7ZEcbCEBj0LEaOdnSvaoBVh/rCAgf/HHKEmeRt6+Z5A4eBpJE3nhIFyw8H
	 5Exnc9OylmmSme7fRBtB1RcQQDCV3Op/YXNeBuwvDm95LOtf2rgFCGEqG4lGIiqPAASrX
	 Ts+PvBSOEeDj9rdM0jGFxHAuvwgo4RHZFCEU3NCzRMpGq/FC3xt6/utC2HFiO+InwEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795573770;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=e7Cl89+R1Vj7SXxz2atxPq7wxZKUNKR/lRW9u+O9qks=;
	b=m+NWkY4LK0OonAI4qkuQ2HpqrMufyinu/Oi5CPUH6tapol58bOVOkI6JZw1vqo3RRlAX
	 4xZQEKXxfbfx76oy881uyl4X76PzpBAUYyvxzD3rr5wSanXg6dWtOPHsrY5PMPHXvj27t
	 R8okn2PyDaZFzKC8T3NQ5ehnecRf2IzP1dV1MfPV2DoLnS10dQEsLreXR0wRGGRdg2Zd5
	 Hv9kT6hUjOwJ1UQzEjhPN0uyMDBIdt2RHOZBNoEz8FoC53d/7Jzm8Xt9JalzbWssVYs/I
	 QgW1oKThI024+1TUZKZAbUcF8B7G20s8Ty7OmUbkcZM0DMHsLG+PCLeHgJeddczR8eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED11606A326
	for <linux-unionfs@vger.kernel.org>; Wed, 25 Nov 2026 02:29:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5ED11606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-57289376805so5115340b6e.1
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Nov 2026 18:29:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795573769; x=1796178569;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=e7Cl89+R1Vj7SXxz2atxPq7wxZKUNKR/lRW9u+O9qks=;
        b=NcG8l5i2yrPMnE6N+ZhgpwXF/buNfUGffvh1aaw7cXxwty+ZkKULHHf0EvvocSjpCO
         GBdK5fsNocsPPlLeDoUHBkIWztnpAYL1U90JDTuh146oDmMOryUtDqDybWLjV9ivBctx
         YPp71+zWwuS77abbAwP5hW8T91yvSuaLSv4wKa1yJmkFpv/Su0WxT8RLP2k6fdjZpole
         J5J8pZtSl7FoLaoVwS4D8BtCwwCUfT1HKhMS8UKsaptLMuNLa8rNaPAlRhqch+sHUCuJ
         dRqk/zEwDnZp/DZhZKqRoNyalkUh3W+HyBWiwLa3sd+TNix/xi8UdUPJN7pOvwgXXEqO
         e/2Q==
X-Forwarded-Encrypted: i=1; AL+hErF8QRRyaGU8y6UIA0Id33hAdez8j0ZCkGhCHQ1FRIyOTbnZwWrMEOvoAWVgKKNbhs2MLQH+pG7C/ohiq1E5@vger.kernel.org
X-Gm-Message-State: APuU4Z/a/oUQaJN9lgUurDbWotMVTFklIbfSanzeJ0mIy0upgTOYbhFT
	asFKMMvHt1hZgTNP+q3+wRPZk7Rzirndz8bnVlk1c4RosT6xWCXN0ZMDYz8guwE5BCDWB3jcxpr
	mBXOBeoYNmvvpMDWi6KCF2xxbKmIScbmM73ptMQhPcb1yb6Ka+fSkJuJ7R+8=
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f46:b0:55c:6ea:3e3f with SMTP id
 5614622812f47-57a0b449e33mr17983150b6e.28.1795573769302; Tue, 24 Nov 2026
 18:29:29 -0800 (PST)
Date: Tue, 24 Nov 2026 18:29:29 -0800
In-Reply-To: <6a8e6f78.dbb3a75c.7844.0033.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b064809.e1ffc79a.44bf.0003.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in ima_path_truncate
From: syzbot <syzbot+ecf337bf2c6f75c1ddd8@syzkaller.appspotmail.com>
To: a.hindborg@kernel.org, amir73il@gmail.com, leitao@debian.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8d7fe9885c62 Merge tag 'hid-for-linus-2026112301' of git:/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=12615bbe580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=462e918ed4cc6d73
dashboard link: https://syzkaller.appspot.com/bug?extid=ecf337bf2c6f75c1ddd8
compiler:       Debian clang version 22.1.8 (1~deb13u5), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112be823580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ecf337bf2c6f75c1ddd8@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor272/5659 is trying to acquire lock:
ffff88801359bed0 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}, at: ima_reset_action_flags security/integrity/ima/ima_main.c:709 [inline]
ffff88801359bed0 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}, at: ima_path_truncate+0xd3/0x190 security/integrity/ima/ima_main.c:718

but task is already holding lock:
ffff888051144478 (sb_writers#4){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:531

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (sb_writers#4){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_write+0x48/0x1c0 include/linux/fs/super.h:125
       mnt_want_write+0x41/0x90 fs/namespace.c:531
       ovl_xattr_set+0x15c/0x5e0 fs/overlayfs/xattrs.c:61
       __vfs_setxattr+0x442/0x480 fs/xattr.c:223
       __vfs_setxattr_noperm+0x12a/0x660 fs/xattr.c:257
       vfs_setxattr+0x151/0x370 fs/xattr.c:344
       cachefiles_preset_object_xattr+0x142/0x3e0 fs/cachefiles/xattr.c:58
       cachefiles_create_tmpfile+0x3e7/0x790 fs/cachefiles/namei.c:455
       cachefiles_create_file+0x78/0x140 fs/cachefiles/namei.c:487
       cachefiles_look_up_object+0x38c/0x7b0 fs/cachefiles/namei.c:622
       cachefiles_lookup_cookie+0x374/0x750 fs/cachefiles/interface.c:125
       fscache_perform_lookup fs/netfs/fscache_cookie.c:518 [inline]
       fscache_cookie_state_machine fs/netfs/fscache_cookie.c:729 [inline]
       fscache_cookie_worker+0xa77/0x1170 fs/netfs/fscache_cookie.c:835
       process_one_work kernel/workqueue.c:3495 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}:
       down_write+0x91/0x200 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1027 [inline]
       ovl_write_iter+0x1fb/0x3b0 fs/overlayfs/file.c:358
       vfs_iocb_iter_write+0x245/0x5e0 fs/read_write.c:930
       __cachefiles_write+0x6c9/0xbd0 fs/cachefiles/io.c:355
       netfs_issue_write fs/netfs/write_issue.c:290 [inline]
       netfs_advance_write+0x328/0x4b0 fs/netfs/write_issue.c:331
       netfs_write_folio fs/netfs/write_issue.c:510 [inline]
       netfs_writepages+0x12d3/0x22b0 fs/netfs/write_issue.c:600
       do_writepages+0x338/0x560 mm/page-writeback.c:2562
       filemap_writeback mm/filemap.c:386 [inline]
       filemap_fdatawrite_range mm/filemap.c:411 [inline]
       filemap_fdatawrite+0x1e9/0x2f0 mm/filemap.c:417
       v9fs_vfs_setattr_dotl+0x4dc/0xab0 fs/9p/vfs_inode_dotl.c:585
       notify_change+0xbba/0xea0 fs/attr.c:556
       do_truncate+0x1c2/0x250 fs/open.c:68
       handle_truncate fs/namei.c:4306 [inline]
       do_open fs/namei.c:4855 [inline]
       path_openat+0x18a6/0x20f0 fs/namei.c:5016
       do_file_open+0x23e/0x4a0 fs/namei.c:5045
       do_sys_openat2+0x115/0x200 fs/open.c:1443
       do_sys_open fs/open.c:1449 [inline]
       __do_sys_openat fs/open.c:1465 [inline]
       __se_sys_openat fs/open.c:1460 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1460
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&sb->s_type->i_mutex_key#25){++++}-{4:4}:
       down_read_interruptible+0x4b/0x3b0 kernel/locking/rwsem.c:1584
       netfs_start_io_read+0x25/0x180 fs/netfs/locking.c:67
       netfs_buffered_read_iter+0xd6/0x160 fs/netfs/buffered_read.c:940
       __kernel_read+0x4ca/0x960 fs/read_write.c:512
       integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
       ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
       ima_calc_file_hash+0x451/0x890 security/integrity/ima/ima_crypto.c:280
       ima_collect_measurement+0x51b/0xa00 security/integrity/ima/ima_api.c:300
       process_measurement+0x1272/0x1c10 security/integrity/ima/ima_main.c:425
       ima_file_check+0xdc/0x130 security/integrity/ima/ima_main.c:686
       security_file_post_open+0xb3/0x260 security/security.c:2777
       do_open fs/namei.c:4853 [inline]
       path_openat+0x1748/0x20f0 fs/namei.c:5016
       do_file_open+0x23e/0x4a0 fs/namei.c:5045
       do_sys_openat2+0x115/0x200 fs/open.c:1443
       do_sys_open fs/open.c:1449 [inline]
       __do_sys_openat fs/open.c:1465 [inline]
       __se_sys_openat fs/open.c:1460 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1460
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       ima_reset_action_flags security/integrity/ima/ima_main.c:709 [inline]
       ima_path_truncate+0xd3/0x190 security/integrity/ima/ima_main.c:718
       security_path_truncate+0x1d0/0x310 security/security.c:1578
       vfs_truncate+0x46e/0x540 fs/open.c:116
       ksys_truncate+0xf3/0x1c0 fs/open.c:142
       __do_sys_truncate fs/open.c:154 [inline]
       __se_sys_truncate fs/open.c:152 [inline]
       __x64_sys_truncate+0x5b/0x70 fs/open.c:152
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ima_iint_mutex_key[depth] --> &ovl_i_mutex_key[depth] --> sb_writers#4

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_writers#4);
                               lock(&ovl_i_mutex_key[depth]);
                               lock(sb_writers#4);
  lock(&ima_iint_mutex_key[depth]);

 *** DEADLOCK ***

locks held by syz-executor272/5659: 1, on CPU#0:
 #0: ffff888051144478 (sb_writers#4){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:531

stack backtrace:
CPU: 0 UID: 0 PID: 5659 Comm: syz-executor272 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
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
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
 ima_reset_action_flags security/integrity/ima/ima_main.c:709 [inline]
 ima_path_truncate+0xd3/0x190 security/integrity/ima/ima_main.c:718
 security_path_truncate+0x1d0/0x310 security/security.c:1578
 vfs_truncate+0x46e/0x540 fs/open.c:116
 ksys_truncate+0xf3/0x1c0 fs/open.c:142
 __do_sys_truncate fs/open.c:154 [inline]
 __se_sys_truncate fs/open.c:152 [inline]
 __x64_sys_truncate+0x5b/0x70 fs/open.c:152
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0e2c62c7c7
Code: 44 00 00 31 ff e8 89 f7 ff ff 48 8b 2d f2 81 2a 00 85 c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 b8 4c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 d0 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffe754e2898 EFLAGS: 00000246 ORIG_RAX: 000000000000004c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0e2c62c7c7
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007f0e2c69ea92
RBP: 00007ffe754e2940 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0e2c69eab0
R13: 00007ffe754e28c0 R14: 00007ffe754e2980 R15: 00007f0e2c69e8cf
 </TASK>
CacheFiles: File cache on CacheFiles unregistering
netfs: Withdrawing cache "CacheFiles" (6 objs)
