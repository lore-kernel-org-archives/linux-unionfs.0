Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3303950128E
	for <linux-unionfs@vger.kernel.org>; Thu, 15 Oct 2026 11:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792062998; cv=none; b=MWoYw9VYKXtJCIqtuxpoQ3Tpj5n3AzFfqUPXSUJGdK/XcwsdMvLqS4k3PlVPRBPU35Z6sWDsOZfZUD3KUkYNK+G/poAK+1SAZeop1DhB/aPEjXidz/5xfs/O/kb/86mnyNVDq2BRZ74Kp1mFr6emAOTChjwPcNNgKoLFy8b+zUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792062998; c=relaxed/simple;
	bh=aq0xX3/cPkEAM0nO5kMsIP5zC8LwsPjKPbF1/P8O8k8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ALJ9k/Eq5m7No/hfNmst/eYOs1O01jp8Tby4tZzlKixqak1hLxIL3/EXJ6Nps7Qsur79BdgbTSI78HhDnRODJhD8m7kqYYdd36dMn448yJzFVhIQ0YfUFU2f2F4uHsAQuqHz8HS5ZkW/o4Em/0QS8vQe3bY6KXgp7ombNL3qA48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-8254ce65bfeso3295973a34.0
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Oct 2026 04:16:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792062994; x=1792667794;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZMaWeQ8qRXsWqh/vQuYUD/x5APIi3Y53X4W2uV0kU3M=;
        b=EULV6UCwVp9LTXp75JEti0s4dMxDBEptYrhrXeIoxhLnLWS+8cCH/zizbmFkDUhIVH
         iZdSkbqfB3kDJmOAG/fqE6Xlsu8LmAU0ZEMzeKTqCkx+SxOLKJcWv7ixu0Oyp1MM+Bar
         Wyg91U+xMzZkgZ2ic+JckkjhIfheXnQ7EDM7NeeRKzZ+MiU0eWLCT0fOlnkVChMpqg8w
         DKX0WupUFwJgzR6wwyOfz6JmilsZ2LlYSv+DYPbBfQ6rMTJ7a2qC4SuLUvCPabNkJySC
         QyJHF5KI2sMWRbcPUvSM4t9w3iURGJYIBV6r9tFZH+du2LA4XImM5+oZviFcH+jAr4w1
         6pEw==
X-Forwarded-Encrypted: i=1; AKwUvBwXxtLfbh8MdGOpH0czn1y5ORGPvdGxN7TZ5HafJ+zEmPtjWw8l4rPqpEMkT3WxFap5wopi7yTh6BlQ78bW@vger.kernel.org
X-Gm-Message-State: AFq9FYL88sFTbgc41P/thzd7zwjLJSKsyM7EYp57NVgMlFXOhP1JmWwC
	5RgLXDYnxZ/VCFC4xepiu3+GtgBUKTsbc+3NRO2XTeNaDtW5mdIlDF401ygG4yGu4Hca4/kEZCg
	hK44vrTiuXyF9GB68Ni9l2XcdiZKDwyNpEaqpqNBJYOuj0fQkEFxpy+4PW80=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f09:b0:4cb:abff:3db9 with SMTP id
 5614622812f47-50c45c64e1cmr19275571b6e.9.1792062993992; Thu, 15 Oct 2026
 04:16:33 -0700 (PDT)
Date: Thu, 15 Oct 2026 04:16:33 -0700
In-Reply-To: <6abfe422.7503fbd6.2d3f6.0023.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad0b611.5f317f00.247b6.0067.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in __d_alloc_parallel
From: syzbot <syzbot+52aa59fd5e3cd8a19dd7@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    d419d682257d Add linux-next specific files for 20261014
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1157ce8e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2935483cab352f25
dashboard link: https://syzkaller.appspot.com/bug?extid=52aa59fd5e3cd8a19dd7
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f9d3d1580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+52aa59fd5e3cd8a19dd7@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor151/5964 is trying to acquire lock:
ffff88806b10d620 (DCACHE_PAR_LOOKUP){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
ffff88806b10d620 (DCACHE_PAR_LOOKUP){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
ffff88806b10d620 (DCACHE_PAR_LOOKUP){+.+.}-{0:0}, at: __d_alloc_parallel+0x39e/0x1700 fs/dcache.c:2883

but task is already holding lock:
ffff88805c8d39e0 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
ffff88805c8d39e0 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: lookup_slow+0x46/0x80 fs/namei.c:1936

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&type->i_mutex_dir_key#3){++++}-{4:4}:
       down_read+0x45/0x320 kernel/locking/rwsem.c:1574
       inode_lock_shared include/linux/fs.h:1039 [inline]
       lookup_slow+0x46/0x80 fs/namei.c:1936
       ovl_lookup_positive_unlocked fs/overlayfs/namei.c:216 [inline]
       ovl_lookup_single+0x323/0xe90 fs/overlayfs/namei.c:260
       ovl_lookup_layer+0x377/0x440 fs/overlayfs/namei.c:365
       ovl_lookup_layers fs/overlayfs/namei.c:1109 [inline]
       ovl_lookup+0x5e5/0x1c80 fs/overlayfs/namei.c:1403
       lookup_open+0x94b/0x1970 fs/namei.c:4578
       open_last_lookups fs/namei.c:4816 [inline]
       path_openat+0x70c/0x20f0 fs/namei.c:5055
       do_file_open+0x258/0x570 fs/namei.c:5087
       do_sys_openat2+0x115/0x200 fs/open.c:1442
       do_sys_open fs/open.c:1448 [inline]
       __do_sys_openat fs/open.c:1788 [inline]
       __se_sys_openat fs/open.c:1783 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1783
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (DCACHE_PAR_LOOKUP){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       d_wait_lookup fs/dcache.c:2840 [inline]
       __d_alloc_parallel+0xc32/0x1700 fs/dcache.c:2944
       __lookup_slow+0x82/0x2f0 fs/namei.c:1905
       lookup_slow+0x59/0x80 fs/namei.c:1937
       walk_component fs/namei.c:2316 [inline]
       lookup_last fs/namei.c:2824 [inline]
       path_lookupat+0x3f5/0x8c0 fs/namei.c:2857
       filename_lookup+0x258/0x5f0 fs/namei.c:2886
       do_readlinkat+0xe3/0x510 fs/stat.c:575
       __do_sys_readlink fs/stat.c:609 [inline]
       __se_sys_readlink fs/stat.c:606 [inline]
       __x64_sys_readlink+0x7f/0x90 fs/stat.c:606
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&type->i_mutex_dir_key#3);
                               lock(DCACHE_PAR_LOOKUP);
                               lock(&type->i_mutex_dir_key#3);
  lock(DCACHE_PAR_LOOKUP);

 *** DEADLOCK ***

locks held by syz-executor151/5964: 1, last CPU#1:
 #0: ffff88805c8d39e0 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff88805c8d39e0 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: lookup_slow+0x46/0x80 fs/namei.c:1936

stack backtrace:
CPU: 1 UID: 0 PID: 5964 Comm: syz-executor151 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
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
 d_wait_lookup fs/dcache.c:2840 [inline]
 __d_alloc_parallel+0xc32/0x1700 fs/dcache.c:2944
 __lookup_slow+0x82/0x2f0 fs/namei.c:1905
 lookup_slow+0x59/0x80 fs/namei.c:1937
 walk_component fs/namei.c:2316 [inline]
 lookup_last fs/namei.c:2824 [inline]
 path_lookupat+0x3f5/0x8c0 fs/namei.c:2857
 filename_lookup+0x258/0x5f0 fs/namei.c:2886
 do_readlinkat+0xe3/0x510 fs/stat.c:575
 __do_sys_readlink fs/stat.c:609 [inline]
 __se_sys_readlink fs/stat.c:606 [inline]
 __x64_sys_readlink+0x7f/0x90 fs/stat.c:606
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0e12a36e97
Code: 00 00 90 48 83 ec 10 48 63 ff 45 31 c9 45 31 c0 6a 00 31 c9 e8 4a 0a 02 00 48 83 c4 18 c3 0f 1f 44 00 00 b8 59 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 d0 ff ff ff f7 d8 64 89 02 48
RSP: 002b:00007f0e12a02fe8 EFLAGS: 00000202 ORIG_RAX: 0000000000000059
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f0e12a36e97
RDX: 0000000000000100 RSI: 00007f0e12a02ff0 RDI: 00007f0e12a030f0
RBP: 00007f0e12a030f0 R08: 00007f0e12ad9b20 R09: 0000000000000005
R10: 0000000000000000 R11: 0000000000000202 R12: 00007f0e12a02ff0
R13: 00007f0e12ad9b20 R14: 00007f0e12aa5028 R15: 00007ffda7595668
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
