Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1458D2DB794
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790960677; cv=none; b=n/LOX6uCPi5lUzTdHoNdaalvvBZgceAjmQ7afcCcNOjXhYDacYThmRQ5xdhj3uF7VBEGUNcI4P1ax4gNuMJLNH2vkOsl3uuAOLe5ZBY9/FEuom3Q8BtsyhXNoIvGLUHSWnxzNtSuH04UC+jFfqQrR8pWMm6NpqIvvGu5iz7CiMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790960677; c=relaxed/simple;
	bh=GpP5XgwYyQJUWQYpJ7j/DbLvKgzskfuJg6aRikW+1yQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BbobtHVIq6O7wzdwaiwmikFACRoNSe/isPPZ3dOtyUIp9C73HU5udaP4/S2OfuGccViT6U3XK98xTSU7SCCTUWBoZbPlFqYp42BCdMp7/9aNXfZEMkXd01YcpA33pm8/zaMjHz0qIuRKP+0fYbXRR6CnEGnl8OgkFieW/Amas4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4dab94dc3e7so13005697b6e.0
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Oct 2026 10:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790960675; x=1791565475;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SzNUvwDq9v9Cm/x2IZGNhM6swbAMlfGpw3MhkiY8pXc=;
        b=1qo1MolijVUnGZz/reMDlWq5fj9rAm1F4W0ICw4ovbam3KeulcrZC7u3ccKAmLYgU/
         KDr4yWj8LvcUcjS0jg31ZCJIZXbk37ekd8EG9BzSf+U1gsHqINJvu85AVdGDJuH0f+L5
         OpY1NYv3tZJQqoKOT4Q1bdq8Okq1qBGTkuNNjgjWTxWGL2bPSgQ1ZBJLw6B7Are3j6c/
         VtI49WJj8qpMw1y4mlzeHhl2+K3qnl59fubJgU9lUNVHgry3tq0/jy9Ya5gMkvRHkcfK
         QZ08IF/XLzmYSHRYmkhhiqE5H7a6HXHScwcJZIcmk0kN/pU7b/j9ozWsLtkZZv/RjVsB
         Tidg==
X-Forwarded-Encrypted: i=1; AKwUvBwF/oDGhx+oqt9R33wHMK2QlGPhzWy0qemi7CBfnqI5siCM/vw7TV4jM91MbZs11s+qzHTu3lOCnjX/GxLC@vger.kernel.org
X-Gm-Message-State: AFuF++nxpL2gat3yF2OJJplwALcAYUAThUIsreX5tArg1Z9lK8lCOsRc
	wgkfqZTlYCRPiL4bpbbyEFvM1cZE4DN1ICxwhzA10YEloNnL4Y6MCEamt4tBKMD8SzynSwLLefH
	n3O6rFWMUAJ2CA8S7q2xqY04Wnvferk4oq6ehUUwZFeDsqTzTQBk2JnOkCTE=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:17a8:b0:4f4:73a9:f853 with SMTP id
 5614622812f47-4f677447435mr94188b6e.1.1790960674967; Fri, 02 Oct 2026
 10:04:34 -0700 (PDT)
Date: Fri, 02 Oct 2026 10:04:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abfe422.7503fbd6.2d3f6.0023.GAE@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in __d_alloc_parallel
From: syzbot <syzbot+52aa59fd5e3cd8a19dd7@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9f24d789f03b Add linux-next specific files for 20261001
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17d76bf5580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c999b3b0b3b9da44
dashboard link: https://syzkaller.appspot.com/bug?extid=52aa59fd5e3cd8a19dd7
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/dd8482e32335/disk-9f24d789.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c0d5a36cf052/vmlinux-9f24d789.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e5992c4e2fd4/bzImage-9f24d789.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+52aa59fd5e3cd8a19dd7@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     Y
------------------------------------------------------
syz.4.3863/19816 is trying to acquire lock:
ffff88805896ae00 (DCACHE_PAR_LOOKUP){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
ffff88805896ae00 (DCACHE_PAR_LOOKUP){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
ffff88805896ae00 (DCACHE_PAR_LOOKUP){+.+.}-{0:0}, at: __d_alloc_parallel+0x39e/0x1700 fs/dcache.c:2881

but task is already holding lock:
ffff888058a4f950 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
ffff888058a4f950 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: lookup_open+0x221/0x1970 fs/namei.c:4460

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&type->i_mutex_dir_key#3){++++}-{4:4}:
       down_read+0x45/0x320 kernel/locking/rwsem.c:1574
       inode_lock_shared include/linux/fs.h:1039 [inline]
       lookup_slow+0x46/0x80 fs/namei.c:1935
       ovl_lookup_positive_unlocked fs/overlayfs/namei.c:216 [inline]
       ovl_lookup_single+0x323/0xe90 fs/overlayfs/namei.c:260
       ovl_lookup_layer+0x377/0x440 fs/overlayfs/namei.c:365
       ovl_lookup_layers fs/overlayfs/namei.c:1168 [inline]
       ovl_lookup+0x9ae/0x1c80 fs/overlayfs/namei.c:1403
       __lookup_slow+0x1fb/0x2f0 fs/namei.c:1919
       lookup_slow+0x59/0x80 fs/namei.c:1936
       walk_component fs/namei.c:2282 [inline]
       lookup_last fs/namei.c:2789 [inline]
       path_lookupat+0x3f5/0x8c0 fs/namei.c:2813
       filename_lookup+0x265/0x5d0 fs/namei.c:2842
       user_path_at+0x40/0x160 fs/namei.c:3641
       do_mount fs/namespace.c:4191 [inline]
       __do_sys_mount fs/namespace.c:4407 [inline]
       __se_sys_mount+0x2dc/0x420 fs/namespace.c:4384
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (DCACHE_PAR_LOOKUP){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       d_wait_lookup fs/dcache.c:2838 [inline]
       __d_alloc_parallel+0xc32/0x1700 fs/dcache.c:2942
       lookup_open+0x2c2/0x1970 fs/namei.c:4473
       open_last_lookups fs/namei.c:4769 [inline]
       path_openat+0x673/0x1da0 fs/namei.c:5008
       do_file_open+0x23e/0x4a0 fs/namei.c:5040
       do_sys_openat2+0x115/0x200 fs/open.c:1442
       do_sys_open fs/open.c:1448 [inline]
       __do_sys_openat fs/open.c:1464 [inline]
       __se_sys_openat fs/open.c:1459 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1459
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

locks held by syz.4.3863/19816: 1, last CPU#1:
 #0: ffff888058a4f950 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:1039 [inline]
 #0: ffff888058a4f950 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: lookup_open+0x221/0x1970 fs/namei.c:4460

stack backtrace:
CPU: 1 UID: 0 PID: 19816 Comm: syz.4.3863 Tainted: G             L     Y syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP, [Y]=FORCED_BIND
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
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
 d_wait_lookup fs/dcache.c:2838 [inline]
 __d_alloc_parallel+0xc32/0x1700 fs/dcache.c:2942
 lookup_open+0x2c2/0x1970 fs/namei.c:4473
 open_last_lookups fs/namei.c:4769 [inline]
 path_openat+0x673/0x1da0 fs/namei.c:5008
 do_file_open+0x23e/0x4a0 fs/namei.c:5040
 do_sys_openat2+0x115/0x200 fs/open.c:1442
 do_sys_open fs/open.c:1448 [inline]
 __do_sys_openat fs/open.c:1464 [inline]
 __se_sys_openat fs/open.c:1459 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1459
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2a81f9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2a82ed0028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f2a82226090 RCX: 00007f2a81f9e159
RDX: 0000000000000000 RSI: 00002000000000c0 RDI: ffffffffffffff9c
RBP: 00007f2a8203506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2a82226128 R14: 00007f2a82226090 R15: 00007ffdafde6058
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
