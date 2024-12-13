Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3517E1
	for <linux-unionfs@vger.kernel.org>; Fri, 13 Dec 2024 03:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734060740; cv=none; b=m3mF7ZzjeTs6qyeb7ogc2QuKOqlDATZeWZ91q2mpZh0CRj99zGrbv8JQErTf9s9nNKJ84piyn3DvZGE0kqxIUrdvAHf097cMoxBFzjpjAFqtpsIk5IORvdNfen00ltbycnaob9rAj6iFO/73D2RjsfyHXGcBbBKkMV/a8bXQRrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734060740; c=relaxed/simple;
	bh=HuulfV48WkXe0u0jWCoykJXAlmjVYlr49rAfTOc6Q4U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=hwu9ganjXR0FhLzLi4xMZ1u7W+sGCyiEeOcc5BH87v9+ajPk0oATq+W7C5L87uTSQXVBA9q0lih0ihh3RXK2b1rqlIte706c4NeNqFq4aqmegXV9ql+JcTmbpR8WdbH1kZ3lxccmFTPody3mnrnuOHU2QFBIgd7tiihSKwRU/PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a814bfb77bso24149485ab.0
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Dec 2024 19:32:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734060738; x=1734665538;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xEdUOUolAV7uWM7ZRVrKCZI3kOhD0Uq3JUWmjiqMHNo=;
        b=VdF7svToN9IxfoATACcV3GBFJpCroqY2wXt3JRKTHC3HkAVFp6985m/IPfGEWhROKb
         y8i4TC9vKGyoNzHyq7NqeQUu0N6/ZWbo0fb5xBV7p6o3dzvLYNlnCFrumySO/F1k1jbf
         NhZV7hFWW39Yv9fkcaWBr+dKE58E+xkenWVSb8Ra3QbUfTNyVWY8g4RsQh/FGYjZ1gjt
         TwWUjgDocSLL97f2GzO/cQP1ImNQfSiIC7Nmr+aR+1AgyoZiebAft5ia1sbe4SypKto/
         TFY0SotDUgYMCUqnIwlK+UZQx3VQ0QuougBlAn49f2MFWd36BDJY0d7x1ub9cedl6LqS
         4UwA==
X-Forwarded-Encrypted: i=1; AJvYcCUGqw+zWSNrp/T7i5eYBal1Yy4jGDFge0yATt9GegdMlG6oVaADHsgc+FsytiB72yg/DoEEGnCN72n3GlNR@vger.kernel.org
X-Gm-Message-State: AOJu0YzZoKG/6wb6+7uC7QAQeqXPbCbRAJPYBvEaMenv+Q8bgeqPO8gC
	1N0mcZAa6cqUeqPVuRjEsAMAAZqR6QqmIbUJwrCWD/3RQaduKuarZP3DSpBVSLiQWK56dj8DfYZ
	HXVjVK5BB3ZUOo5ygevh9purlfQVnmmkflmnbGe/J4MqKGXdhcLneGm8=
X-Google-Smtp-Source: AGHT+IFuTxWE7jyg7A/PpxUXlwyMSdn3HQAKBc79zybAzwZUO3BYx1XxMF1uoECo2Ej+tZqXN0coW+xlgnGACzVpwUXvNx8aDzqm
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16cb:b0:3a7:d02b:f653 with SMTP id
 e9e14a558f8ab-3b024e395femr6843835ab.0.1734060738108; Thu, 12 Dec 2024
 19:32:18 -0800 (PST)
Date: Thu, 12 Dec 2024 19:32:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675baac2.050a0220.cd16f.003c.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in ovl_create_real (2)
From: syzbot <syzbot+db0356b67c48887188e2@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    62b5a46999c7 Merge tag '6.13-rc1-smb3-client-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1479cb30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b33c8d5f5a10b30b
dashboard link: https://syzkaller.appspot.com/bug?extid=db0356b67c48887188e2
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-62b5a469.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5982feeea069/vmlinux-62b5a469.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7d4d78f5f270/bzImage-62b5a469.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+db0356b67c48887188e2@syzkaller.appspotmail.com

overlayfs: ...falling back to redirect_dir=nofollow.
overlayfs: ...falling back to index=off.
overlayfs: ...falling back to uuid=null.
------------[ cut here ]------------
WARNING: CPU: 2 PID: 9939 at fs/overlayfs/dir.c:213 ovl_create_real+0x5ab/0x670 fs/overlayfs/dir.c:213
Modules linked in:
CPU: 2 UID: 0 PID: 9939 Comm: syz.1.1043 Not tainted 6.13.0-rc1-syzkaller-00378-g62b5a46999c7 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ovl_create_real+0x5ab/0x670 fs/overlayfs/dir.c:213
Code: 89 e2 48 c7 c6 80 9b 89 8b 48 c7 c7 50 34 0d 90 e8 ba 23 bb 01 e9 d9 fb ff ff e8 00 5b ef fe e9 93 fc ff ff e8 06 a5 8c fe 90 <0f> 0b 90 4c 89 e3 49 c7 c4 fb ff ff ff e9 d5 fc ff ff e8 7e 38 0e
RSP: 0018:ffffc90023f8fc28 EFLAGS: 00010287
RAX: 00000000000051e1 RBX: ffff8880009de178 RCX: ffffc9000c001000
RDX: 0000000000080000 RSI: ffffffff830c9b7a RDI: ffff8880009de1e0
RBP: 1ffff920047f1f86 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000004 R12: ffff8880009de178
R13: 0000000000000000 R14: ffff888012c0b9f0 R15: 000000000000a000
FS:  0000000000000000(0000) GS:ffff88802b600000(0063) knlGS:00000000f5166b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000000000c33e9c8 CR3: 000000005d116000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ovl_create_upper fs/overlayfs/dir.c:334 [inline]
 ovl_create_or_link+0x2a4/0x800 fs/overlayfs/dir.c:632
 ovl_create_object+0x268/0x300 fs/overlayfs/dir.c:673
 vfs_symlink fs/namei.c:4669 [inline]
 vfs_symlink+0x3e8/0x660 fs/namei.c:4653
 do_symlinkat+0x263/0x310 fs/namei.c:4695
 __do_sys_symlink fs/namei.c:4716 [inline]
 __se_sys_symlink fs/namei.c:4714 [inline]
 __ia32_sys_symlink+0x74/0x90 fs/namei.c:4714
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0x73/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf747e579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f516657c EFLAGS: 00000292 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00000000200003c0 RCX: 0000000020000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000296 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	10 06                	adc    %al,(%rsi)
   2:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   6:	10 07                	adc    %al,(%rdi)
   8:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   c:	10 08                	adc    %cl,(%rax)
   e:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1e:	00 51 52             	add    %dl,0x52(%rcx)
  21:	55                   	push   %rbp
  22:	89 e5                	mov    %esp,%ebp
  24:	0f 34                	sysenter
  26:	cd 80                	int    $0x80
* 28:	5d                   	pop    %rbp <-- trapping instruction
  29:	5a                   	pop    %rdx
  2a:	59                   	pop    %rcx
  2b:	c3                   	ret
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop
  30:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  37:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


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
