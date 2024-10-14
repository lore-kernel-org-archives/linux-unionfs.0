Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A213A12CD96
	for <linux-unionfs@vger.kernel.org>; Mon, 14 Oct 2024 08:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728896316; cv=none; b=Xy1H3PK0cXLMuLejJcjY1IEPDoSPAyBomQCN5feAfvULyK4CmJjdizdtbUL4ECikXN63a83VcJL4dzV5BJQ4u4XzpkiAcp237D/tsdeMZ7hiAIZHLWJtqJlVIKgFdOyDKhErCXAWsOiRyKNE07tNBumi7R5CTbxPyZAD+t9e+qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728896316; c=relaxed/simple;
	bh=TStZyu8j/ZM33Ne/PPDdyHIoix6y4SaFuHb6f5Xbzbw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=o+b5otUI3F/r3pgqNX9hr2j7+NHZp7AWgSXCFWnFV3AcmdmG4MNju7QjaUTm6ZxT9jO9FdFGVr9+tYpcoL9kFHR9J6T5ogHpnEDoF+Q6m5yuF0Wr/jJ9XoPnqmL67lGwtYE7Fjpj1ON8I1aekxpjfECQKWiQWk4qFKgOibqo0mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3cc9fa12dso7917555ab.1
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Oct 2024 01:58:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728896313; x=1729501113;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A5hLPwUtSaWC1R9AldPVcKRZukS7UuyAgJR0eNPYzOo=;
        b=vQ7em6/jVMldRIeWiT20qTRLTe2eiqxwzYwp8d+pZVLwbfuI3EkU18Jf8ccDxYOByp
         FgHaWRj5SGI0Wb7TuqkbbYm8Hy+k3uVMZcvenNcRsjtyEghYTQvRkmeNAxRzKDP7vUq5
         O3nmSbjBPT0soIUfzYAmnTR4sfeXh2KIJuVolFtM4ukF+mzkXWeW9+K73gs4Q2Sy5D/o
         0OEaDrs7WbCGwi5djLBm5nIW5v1JUaROxVDLx6Y+KODS8RLs1IOSA26U2ZtkGCfT7VSD
         SPlsBb7+HoaIGe3T27oUWHPSL6Scbq2JjBQYEVUw3uW9bO3ucCAxCwriNkKOv/TMhpqs
         YiaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqDONh/Iko8IlAQcqnK4Q2J+P+KBxWz42VilnGSMGvVw+TTdhcRehr98TCA/64wfeabXxiNyXX6ane4dVi@vger.kernel.org
X-Gm-Message-State: AOJu0YwI1DVMNUWYVzOS4DxfHGXfu4HLt5Wu9PLrJBYMgi/6Y32F73ZZ
	0KiuNlKSFvD3/DEzDpj8Zx5sLeordd69gZVQ+nxaNuZnmzZCXzMalZOrCCDtpVArtrI2za2WVtT
	bV8alHkkZei/DOMpBRKuOaAl+scIOgsSPissmoNU6mVGvAMxcVi448VA=
X-Google-Smtp-Source: AGHT+IEhDLmhOzUJrA4eULFmcZ7upwVC/zktUY8tSdjmq3JB97fv2Bu5IRjP8fDyhjxJ6KkF0/ENNOR9MmyDg0qe1MknykIw3vzL
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aaa:b0:3a0:ae35:f2eb with SMTP id
 e9e14a558f8ab-3a3bcdfdf39mr50059535ab.19.1728896313660; Mon, 14 Oct 2024
 01:58:33 -0700 (PDT)
Date: Mon, 14 Oct 2024 01:58:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670cdd39.050a0220.4cbc0.0048.GAE@google.com>
Subject: [syzbot] [overlayfs?] general protection fault in ovl_real_file_path
From: syzbot <syzbot+aaf95b6e8fc9d906d8a7@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d61a00525464 Add linux-next specific files for 20241011
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1688fb27980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8554528c7f4bf3fb
dashboard link: https://syzkaller.appspot.com/bug?extid=aaf95b6e8fc9d906d8a7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d5705f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1188fb27980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f615720e9964/disk-d61a0052.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c4a45c7583c6/vmlinux-d61a0052.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d767ab86d0d0/bzImage-d61a0052.xz

The issue was bisected to:

commit 181d71062eef699385d92b92f8ad3cbf03e61267
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Mon Oct 7 13:22:29 2024 +0000

    ovl: allocate a container struct ovl_file for ovl private context

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11c41440580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13c41440580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15c41440580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+aaf95b6e8fc9d906d8a7@syzkaller.appspotmail.com
Fixes: 181d71062eef ("ovl: allocate a container struct ovl_file for ovl private context")

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000d: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
CPU: 1 UID: 0 PID: 5235 Comm: syz-executor410 Not tainted 6.12.0-rc2-next-20241011-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:file_inode include/linux/fs.h:1124 [inline]
RIP: 0010:ovl_is_real_file fs/overlayfs/file.c:100 [inline]
RIP: 0010:ovl_real_file_path+0xa5/0x2e0 fs/overlayfs/file.c:118
Code: 03 4d 89 f7 42 80 3c 30 00 74 08 4c 89 ef e8 22 1e e0 fe 4c 89 64 24 10 49 8b 45 00 49 89 c4 4c 8d 70 68 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00 74 08 4c 89 f7 e8 fc 1d e0 fe 49 8b 1e 48 83 c5 68
RSP: 0018:ffffc90002dcfb28 EFLAGS: 00010202
RAX: 000000000000000d RBX: 1ffff920005b9f79 RCX: ffff88801efa5a00
RDX: 0000000000000000 RSI: ffffc90002dcfbc0 RDI: ffff888031c9bc00
RBP: ffff88807eb938f8 R08: ffffffff831d82d9 R09: 0000000000000000
R10: ffffc90002dcfae0 R11: fffff520005b9f5e R12: 0000000000000000
R13: ffff888078c80000 R14: 0000000000000068 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001740 CR3: 000000000e736000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ovl_real_file+0x186/0x210 fs/overlayfs/file.c:176
 ovl_flush+0x22/0x140 fs/overlayfs/file.c:620
 filp_flush+0xb7/0x160 fs/open.c:1527
 filp_close+0x1e/0x40 fs/open.c:1540
 close_files fs/file.c:508 [inline]
 put_files_struct+0x198/0x310 fs/file.c:523
 do_exit+0xa10/0x28e0 kernel/exit.c:933
 do_group_exit+0x207/0x2c0 kernel/exit.c:1087
 __do_sys_exit_group kernel/exit.c:1098 [inline]
 __se_sys_exit_group kernel/exit.c:1096 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1096
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbb4c5e7739
Code: Unable to access opcode bytes at 0x7fbb4c5e770f.
RSP: 002b:00007fff9c70aac8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbb4c5e7739
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007fbb4c662290 R08: ffffffffffffffb8 R09: 00007fbb4c5b5e50
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbb4c662290
R13: 0000000000000000 R14: 00007fbb4c662ce0 R15: 00007fbb4c5b62a0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:file_inode include/linux/fs.h:1124 [inline]
RIP: 0010:ovl_is_real_file fs/overlayfs/file.c:100 [inline]
RIP: 0010:ovl_real_file_path+0xa5/0x2e0 fs/overlayfs/file.c:118
Code: 03 4d 89 f7 42 80 3c 30 00 74 08 4c 89 ef e8 22 1e e0 fe 4c 89 64 24 10 49 8b 45 00 49 89 c4 4c 8d 70 68 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00 74 08 4c 89 f7 e8 fc 1d e0 fe 49 8b 1e 48 83 c5 68
RSP: 0018:ffffc90002dcfb28 EFLAGS: 00010202
RAX: 000000000000000d RBX: 1ffff920005b9f79 RCX: ffff88801efa5a00
RDX: 0000000000000000 RSI: ffffc90002dcfbc0 RDI: ffff888031c9bc00
RBP: ffff88807eb938f8 R08: ffffffff831d82d9 R09: 0000000000000000
R10: ffffc90002dcfae0 R11: fffff520005b9f5e R12: 0000000000000000
R13: ffff888078c80000 R14: 0000000000000068 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001740 CR3: 000000000e736000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	03 4d 89             	add    -0x77(%rbp),%ecx
   3:	f7 42 80 3c 30 00 74 	testl  $0x7400303c,-0x80(%rdx)
   a:	08 4c 89 ef          	or     %cl,-0x11(%rcx,%rcx,4)
   e:	e8 22 1e e0 fe       	call   0xfee01e35
  13:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  18:	49 8b 45 00          	mov    0x0(%r13),%rax
  1c:	49 89 c4             	mov    %rax,%r12
  1f:	4c 8d 70 68          	lea    0x68(%rax),%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 fc 1d e0 fe       	call   0xfee01e35
  39:	49 8b 1e             	mov    (%r14),%rbx
  3c:	48 83 c5 68          	add    $0x68,%rbp


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
