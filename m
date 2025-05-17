Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD3B1A2643
	for <linux-unionfs@vger.kernel.org>; Sat, 17 May 2025 09:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747474719; cv=none; b=LnWcyJSXrutQpOVfnSvPhPF6948KsQuIFGUMoniJeoj5KjYzJp32LvYiEnNaGCmXqp3hdqxOZ8d1eIvQ/6PCjCvCqyeHt6yHgrvHm1WhaLwjfv3KiJbLlWjXBHXVDqKZQveOfbH8rRdISOFbKR8YZGMblqvFr9BzRRtEgJxRIm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747474719; c=relaxed/simple;
	bh=jxUvZx5EGYlh6he4NGXlph3gNoPH7F+QwosL8sQcDYM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=INs6mr4V64N6dHkKJqLwb+P97gp1ycI2UWTkktXosRiW/smi386cFDdBBYiM3kiDRBRjkyR0KJcHZFzrQGRA4YllUy8Y6KFZZmAgfoS/j5cNGFcOdMLSjocqGB8LcmIAwPAMiNPda9fb5q6ZtX2LBECUqi8U4lnnXLI9S8fsGMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-85e4f920dacso240844939f.2
        for <linux-unionfs@vger.kernel.org>; Sat, 17 May 2025 02:38:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747474716; x=1748079516;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JBhObzTThOmM6+0reVHQkiRQ8/CGfx6i58EUAAuXwZc=;
        b=h9Pg4zzRmGwHKSREfibKI7sN7EqJHDF/Sh7472BJxqO7RlzrTLJN8hNTavOPuxcMNW
         pq9t8NZp2ce2nWLmhNf5DPHMvc/jd7+6Z+ebJwiriBmndAPsAckdSCBYcWUMkDjsrqeG
         /ZO+wTp2Xbdb49eMFhE5ZKa93FAAZptJwz1hsrUbY2C0vvmR5MGoDms0clNMwjFtATF/
         Wq2Io1iZiIBlFzZP7Q1RfmPhmaneadq9onWOyUaV0o70yDZkOk/BYjxBxo9KMRdQ0SY9
         DprIAlHfPjXhKvMvYNKMhMkJsGK0w+WU2RfHoH5IwnptbAlmuFppMTZm6p93UlQbKRjZ
         oeog==
X-Forwarded-Encrypted: i=1; AJvYcCXkv9J17QTCFyzh98MfDyKueOKOVuJ3On74WABvKE6HVtEVirTjNfseKM3XqgLTntcEg1qFFs9Y9N+Oux2z@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4hgIxmHzFvY13Udw8AMCk9pYj3xsq0u37IMSWvtn80/Cjm7a8
	NodXpA5uW7zOkIc4E7CmMyHSyMMsNa13gDmAcNxtv/4Rfslarb/Z2Fb0ToDwIMapbPCnWftuVzk
	7hN/h0OIvQLFqslv6nFndbAPR0/+zGJOtBPHbo/fxL+12lavgye1EozKbOmU=
X-Google-Smtp-Source: AGHT+IGCFW5TV/yCXWGJ7tZe5DaLkBZ4xU4rJSs4O2WyhBhgzKJORA5EU31rk1ljl3WSPXWIeUxLrf4XZHTZOjOsVVuN2mPsjmcG
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3607:b0:867:237f:381e with SMTP id
 ca18e2360f4ac-86a2317b1f5mr870688239f.2.1747474716696; Sat, 17 May 2025
 02:38:36 -0700 (PDT)
Date: Sat, 17 May 2025 02:38:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6828591c.a00a0220.398d88.0248.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in ovl_listxattr
From: syzbot <syzbot+4125590f2a9f5b3cdf43@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e9565e23cd89 Merge tag 'sched_ext-for-6.15-rc6-fixes' of g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15ee8f68580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5929ac65be9baf3c
dashboard link: https://syzkaller.appspot.com/bug?extid=4125590f2a9f5b3cdf43
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12cb6af4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1301f670580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/88b9a7ce7297/disk-e9565e23.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6ef1e04f11ea/vmlinux-e9565e23.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dfb61d29ee21/bzImage-e9565e23.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4125590f2a9f5b3cdf43@syzkaller.appspotmail.com

WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5827 at fs/overlayfs/xattrs.c:136 ovl_listxattr+0x3a3/0x400 fs/overlayfs/xattrs.c:136
Modules linked in:
CPU: 0 UID: 0 PID: 5827 Comm: syz-executor209 Not tainted 6.15.0-rc6-syzkaller-00047-ge9565e23cd89 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:ovl_listxattr+0x3a3/0x400 fs/overlayfs/xattrs.c:136
Code: d5 f3 fe e9 47 ff ff ff e8 da 06 94 fe 4c 89 f8 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 be 06 94 fe 90 <0f> 0b 90 49 c7 c7 fb ff ff ff eb d7 e8 ac 06 94 fe 90 0f 0b 90 e9
RSP: 0018:ffffc9000440fdb8 EFLAGS: 00010293
RAX: ffffffff832bea42 RBX: ffff888020aec700 RCX: ffff88802faf5a00
RDX: 0000000000000000 RSI: 0000000000000011 RDI: 0000000000000012
RBP: ffff88823bf5cf01 R08: ffff8880335691d3 R09: 1ffff110066ad23a
R10: dffffc0000000000 R11: ffffed10066ad23b R12: ffffffffffffffff
R13: 0000000000000012 R14: ffff8880687d7820 R15: 0000000000000011
FS:  000055558015f380(0000) GS:ffff8881260fb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 000000007f130000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vfs_listxattr fs/xattr.c:493 [inline]
 listxattr+0x10d/0x2a0 fs/xattr.c:924
 filename_listxattr fs/xattr.c:958 [inline]
 path_listxattrat+0x179/0x390 fs/xattr.c:988
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcb6cb2da39
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdbfef0558 EFLAGS: 00000246 ORIG_RAX: 00000000000000c3
RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 00007fcb6cb2da39
RDX: 00000000000000b6 RSI: 0000200000000200 RDI: 00002000000001c0
RBP: 0000200000000180 R08: 0000000000000006 R09: 0000000000000006
R10: 0000200000000300 R11: 0000000000000246 R12: 00007fcb6cb7c17c
R13: 00007fcb6cb77082 R14: 0000000000000001 R15: 0000000000000001
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
