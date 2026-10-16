Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379402F5321
	for <linux-unionfs@vger.kernel.org>; Fri, 16 Oct 2026 01:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792115491; cv=none; b=jGZVgiRIgY4sU2rViBU1TUfAYlvpaKoFcaVQ8N3Z6WxRhsGhT0QMOsWRGBj4B1jnC+h3elGZa5CuqfXfeZy9D2t5MUyIUp50M38eMsl1g8O5pl5WomJ58dOqe9B89yTPmejyCEIWg2UYDcuWs76dwso6ZmVFozcT9IOJB1TtyHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792115491; c=relaxed/simple;
	bh=DuKiu/B2dUd5qGRA+KlNOIyWlp6IqfK58bdzQgLPpHo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=nLWZB4iuT/h92mpU9oSTfkZQSNNvpUhgUoqi8ptBdqfmzKAVNcWGjVniy2nUeW8BEL0D53duPFOMdTE5EjRKmPVKvpeo3+sfGnnXRdONCQMWtDaYUv/yWnr5RuMPUXZ39mKGUpnn17b/tdKBCQrB1iVwv8YeGwSnnNJs2J+sx84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b26d8d2498so3218314b6e.2
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Oct 2026 18:51:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792115489; x=1792720289;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Bs4ER0aIIQg4GWVgoIQKKfHZ+d+lxOX71WRb5HgYtBU=;
        b=XHl2GJYzf084jEAMVlxnpDiONm8EnP7dDRtWZDFJi4eU4ar2U9yqT7lKAJbiWMv7tl
         dY98D+g9uViwbo+uYvrK3p3xHmNsffM4mwfEnv1vu7KDjPW0VxVUbZ283qSv0m6uBESo
         mWUmoBplUkdyCwf+oCmBrmUtpTV+Y+h/BFDxtSpuSSHhxCjE0bb0wEjlyIP3kL1dME7z
         QKsbN9qvDwPnTL9v776fOIZ2I2eHmAgTjNwjVYThI9B7AS1wmxBIxGOHMnWijOUJEdFc
         9aFtTf1/j0G1RRTc7hdfGWkanrU0zcU+1uY5J5vzhptZO7i5aCkfK3dAwCYP7qlSvk/O
         rdlw==
X-Forwarded-Encrypted: i=1; AKwUvBxxTVUKkGS5S/jnZDmUXqY5zPWaHwx+IlEg3UMt230LVATCd9rQ7LlZf7bUhJwTr8cSj2pDuu9hFjVDIkdi@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8iBFd6AJ5reAEpbi+pjGq5cRsat/Y0lkMVgW/x5pxcH88FVop
	Ed1WBZDZDypCcKN3GRJ2iEGU6FoDlnxkyB2HU1E31wwTJNxUaopeH6DPL7ean0UzJbbUEHIvLax
	UQLcSzsAp3EvWJxyuG8RmoKgHhn16uD3URb9WC2s5T98c5JmsQAdQZnk9QJg=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a21:b0:4f4:d7:b15b with SMTP id
 5614622812f47-50c415db066mr17134401b6e.4.1792115489161; Thu, 15 Oct 2026
 18:51:29 -0700 (PDT)
Date: Thu, 15 Oct 2026 18:51:29 -0700
In-Reply-To: <69d93248.050a0220.3030df.002f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad18321.7952420f.283480.0192.GAE@google.com>
Subject: Re: [syzbot] [cgroups?] [overlayfs?] possible deadlock in
 cgroup_kn_lock_live (2)
From: syzbot <syzbot+6dc923fb5b4671f0fcf0@syzkaller.appspotmail.com>
To: amir73il@gmail.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, mkoutny@suse.com, syzkaller-bugs@googlegroups.com, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    045958acaa75 Merge tag 'net-7.3-rc8' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1067ffd1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=44ac479246d4559b
dashboard link: https://syzkaller.appspot.com/bug?extid=6dc923fb5b4671f0fcf0
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1467ffd1580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6dc923fb5b4671f0fcf0@syzkaller.appspotmail.com

block2mtd: error: cannot open device /tmp/cg/nonexistent_mtd_bdev
block2mtd: error: cannot open device /dev/nonexistent_mtd_bdev
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor140/5993 is trying to acquire lock:
ffffffff8fe523e0 (cgroup_mutex){+.+.}-{4:4}, at: cgroup_lock include/linux/cgroup.h:482 [inline]
ffffffff8fe523e0 (cgroup_mutex){+.+.}-{4:4}, at: cgroup_kn_lock_live+0x116/0x520 kernel/cgroup/cgroup.c:1719

but task is already holding lock:
ffff888071de6740 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
ffff888071de6740 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: vfs_rmdir fs/namei.c:5529 [inline]
ffff888071de6740 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: vfs_rmdir+0xed/0x8a0 fs/namei.c:5517

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&type->i_mutex_dir_key#7){++++}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       down_read+0x99/0x4c0 kernel/locking/rwsem.c:1574
       inode_lock_shared include/linux/fs.h:1039 [inline]
       lookup_slow+0x42/0x70 fs/namei.c:1935
       walk_component fs/namei.c:2311 [inline]
       lookup_last fs/namei.c:2818 [inline]
       path_lookupat+0x5e8/0xc40 fs/namei.c:2842
       filename_lookup+0x202/0x590 fs/namei.c:2871
       kern_path+0x37/0x50 fs/namei.c:3065
       lookup_bdev+0xd8/0x2a0 block/bdev.c:1268
       bdev_file_open_by_path+0x82/0x330 block/bdev.c:1123
       add_device drivers/mtd/devices/block2mtd.c:279 [inline]
       block2mtd_setup2.isra.0+0x2f8/0xc60 drivers/mtd/devices/block2mtd.c:459
       block2mtd_setup+0xbd/0xd0 drivers/mtd/devices/block2mtd.c:476
       param_attr_store+0x199/0x300 kernel/params.c:591
       module_attr_store+0x58/0x80 kernel/params.c:906
       sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
       kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x6af/0x1050 fs/read_write.c:687
       ksys_write+0x12a/0x250 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x121/0x770 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (param_lock){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       ieee80211_rate_control_ops_get net/mac80211/rate.c:221 [inline]
       rate_control_alloc net/mac80211/rate.c:267 [inline]
       ieee80211_init_rate_ctrl_alg+0x1df/0x3b0 net/mac80211/rate.c:1016
       ieee80211_register_hw+0x2c5b/0x45c0 net/mac80211/main.c:1565
       mac80211_hwsim_new_radio+0x2b08/0x6510 drivers/net/wireless/virtual/mac80211_hwsim_main.c:6143
       init_mac80211_hwsim+0x5e2/0x6f0 drivers/net/wireless/virtual/mac80211_hwsim_main.c:7633
       do_one_initcall+0x11c/0x6f0 init/main.c:1362
       do_initcall_level init/main.c:1424 [inline]
       do_initcalls init/main.c:1440 [inline]
       do_basic_setup init/main.c:1460 [inline]
       kernel_init_freeable+0x6ea/0x7b0 init/main.c:1675
       kernel_init+0x21/0x1e0 init/main.c:1565
       ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 (rtnl_mutex){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       cgrp_css_online+0xa1/0x1f0 net/core/netprio_cgroup.c:157
       online_css+0xb2/0x350 kernel/cgroup/cgroup.c:5871
       css_create kernel/cgroup/cgroup.c:5949 [inline]
       cgroup_apply_control_enable+0xa8d/0xdd0 kernel/cgroup/cgroup.c:3460
       cgroup_mkdir+0x57f/0x1330 kernel/cgroup/cgroup.c:6150
       kernfs_iop_mkdir+0x111/0x190 fs/kernfs/dir.c:1305
       vfs_mkdir+0x364/0x850 fs/namei.c:5439
       filename_mkdirat+0x48b/0x5e0 fs/namei.c:5472
       __do_sys_mkdirat fs/namei.c:5493 [inline]
       __se_sys_mkdirat fs/namei.c:5490 [inline]
       __x64_sys_mkdirat+0x89/0xc0 fs/namei.c:5490
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x121/0x770 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (cgroup_mutex){+.+.}-{4:4}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       cgroup_lock include/linux/cgroup.h:482 [inline]
       cgroup_kn_lock_live+0x116/0x520 kernel/cgroup/cgroup.c:1719
       cgroup_rmdir+0x22/0x2f0 kernel/cgroup/cgroup.c:6402
       kernfs_iop_rmdir+0x106/0x170 fs/kernfs/dir.c:1323
       vfs_rmdir fs/namei.c:5544 [inline]
       vfs_rmdir+0x328/0x8a0 fs/namei.c:5517
       filename_rmdir+0x31a/0x5c0 fs/namei.c:5601
       __do_sys_rmdir fs/namei.c:5624 [inline]
       __se_sys_rmdir fs/namei.c:5621 [inline]
       __x64_sys_rmdir+0x46/0x70 fs/namei.c:5621
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x121/0x770 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  cgroup_mutex --> param_lock --> &type->i_mutex_dir_key#7

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&type->i_mutex_dir_key#7);
                               lock(param_lock);
                               lock(&type->i_mutex_dir_key#7);
  lock(cgroup_mutex);

 *** DEADLOCK ***

locks held by syz-executor140/5993: 3, last CPU#0:
 #0: ffff88807ea22460 (sb_writers#10){.+.+}-{0:0}, at: filename_rmdir+0x1ff/0x5c0 fs/namei.c:5590
 #1: ffff888076d68f80 (&type->i_mutex_dir_key#7/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #1: ffff888076d68f80 (&type->i_mutex_dir_key#7/1){+.+.}-{4:4}, at: __start_dirop fs/namei.c:2947 [inline]
 #1: ffff888076d68f80 (&type->i_mutex_dir_key#7/1){+.+.}-{4:4}, at: start_dirop fs/namei.c:2971 [inline]
 #1: ffff888076d68f80 (&type->i_mutex_dir_key#7/1){+.+.}-{4:4}, at: filename_rmdir+0x258/0x5c0 fs/namei.c:5594
 #2: ffff888071de6740 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
 #2: ffff888071de6740 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: vfs_rmdir fs/namei.c:5529 [inline]
 #2: ffff888071de6740 (&type->i_mutex_dir_key#7){++++}-{4:4}, at: vfs_rmdir+0xed/0x8a0 fs/namei.c:5517

stack backtrace:
CPU: 0 UID: 0 PID: 5993 Comm: syz-executor140 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1be kernel/locking/lockdep.c:2087
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2219
 check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
 lock_acquire kernel/locking/lockdep.c:5942 [inline]
 lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
 cgroup_lock include/linux/cgroup.h:482 [inline]
 cgroup_kn_lock_live+0x116/0x520 kernel/cgroup/cgroup.c:1719
 cgroup_rmdir+0x22/0x2f0 kernel/cgroup/cgroup.c:6402
 kernfs_iop_rmdir+0x106/0x170 fs/kernfs/dir.c:1323
 vfs_rmdir fs/namei.c:5544 [inline]
 vfs_rmdir+0x328/0x8a0 fs/namei.c:5517
 filename_rmdir+0x31a/0x5c0 fs/namei.c:5601
 __do_sys_rmdir fs/namei.c:5624 [inline]
 __se_sys_rmdir fs/namei.c:5621 [inline]
 __x64_sys_rmdir+0x46/0x70 fs/namei.c:5621
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x121/0x770 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f81c4d28557
Code: 00 00 90 48 83 ec 10 48 63 ff 45 31 c9 45 31 c0 6a 00 31 c9 e8 4a 02 02 00 48 83 c4 18 c3 0f 1f 44 00 00 b8 54 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 d8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffe71e77668 EFLAGS: 00000206 ORIG_RAX: 0000000000000054
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f81c4d28557
RDX: 0000000000000000 RSI: 00007f81c4db03a3 RDI: 00007f81c4d83e7b
RBP: 00007ffe71e77670 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 00007f81c4d83e50
R13: 00007f81c4d83e7b R14: 000000000000001e R15: 0000000000000002
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
