Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A0A33CEA0
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 14:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766501061; cv=none; b=htdc7BoYMldAjVFrKBb/GetmTDBYT1AO5n9l5pA1Z78BelRg5K7mwRLW1ZFawdMMAhjfkiEaEP0KFOHASVao6EDZPcHzFwcMzsosrYf6QnU6kBai9vU5bpbEEFnSX4gaE/qrW6NH2jWHT+4asDgalbU90xs+jkUVYPkQS8ik8HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766501061; c=relaxed/simple;
	bh=1ssTRcCl/VsrATu6rqeNqg1wdeP2BUS5TiYJj0nJa0g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DGzn4NZ3Enxxst4C6HNCv2G4w8gWfh7W5BF0TjwhwtE/F7wTBffmZH3NAqGNipeCb2+Ok94J5MF2lvaXTU2NnfRNpdsS3rOQm6ThMze1dDhlDCqDuCuqZ8vTSPA1LeXSTdc/AV/cEugZmtzByYMVpHSLNHPX/h09ByaX8W0j/yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7cb133bc2d0so6709568a34.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 06:44:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766501059; x=1767105859;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xs89H/miBrEzJ1qIpByNnZFgqDkkZlY5WmPEw5QJqV4=;
        b=fw4sB/o235HU+yE61V83L+2J96mUA4gGTrC+aF9Ff4/3BCz8fMHGNJSplbKrPjHvOq
         N4+x/WrxqkH5Rl/IUROcZwXgm+jFU60cqZ+0Vgu85U/1EbEndifSCkNIq5lXOnWrb11r
         1n10BeKQVi1ryyoTcZIegX7jrB3gMSjz04i4xqvKu0JNnfemjLrxTIQZbyhnoL/Fcfyz
         HdrG8zwSsPLKE6uWEUHMiD89UVfCcj/jLohqsK0uXicGhY5Jrx1BSC5U/XAe2NbFOIT5
         SnExxZJiYc5P1pE5jkI+tjUtAlCw8O4pIlyrgPSWhI7q5z6e0Alg1Tfsu7ZzXVU2Kirv
         8RWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7O1jn8NbyWUmVGnQSjBSRT34odEB+7sjSN1GNgMcCmVTpr3YUc+DYUtjXOMY3N8hqL7DQWG6aXKXgIIDO@vger.kernel.org
X-Gm-Message-State: AOJu0YypwjSXwkZjN78KEEJ7iUhkgsAXQJfM9A38/2Kuwb4Tvar7+lOR
	Q11NHsopLlSEiDuKh4V4c7hPyLfrDuot4yyfdRPScwiCKiBNO1gMQuekwp2FlKxjam022XmiMQD
	EL6gBN2EikJkFFoxQAkdxgrzcD+D1FxLQmWL5FlXYOTM1hy+8KCUM9KwjmJA=
X-Google-Smtp-Source: AGHT+IHG9Mvcl2ExBLN6BzuYJvxF8GsU8T+hw1YJLY0h3CsACcHHWWqMLtGJftKLWrpVLQOG4XCP+rMOfWnCu6mTLjp7TMvAgzCX
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:510e:b0:659:9a49:90a6 with SMTP id
 006d021491bc7-65d0e9c257emr3976410eaf.37.1766501058699; Tue, 23 Dec 2025
 06:44:18 -0800 (PST)
Date: Tue, 23 Dec 2025 06:44:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694aaac2.050a0220.19928e.002b.GAE@google.com>
Subject: [syzbot] [overlayfs?] general protection fault in ovl_iterate
From: syzbot <syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f0b4cce4481 Linux 6.19-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128d7b0a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5888b6002e661229
dashboard link: https://syzkaller.appspot.com/bug?extid=a16fb0cce329a320661c
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/551afd5ea893/disk-8f0b4cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1f52c6204286/vmlinux-8f0b4cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e55fced475b1/bzImage-8f0b4cce.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc9110a1fb76: 0000 [#1] SMP KASAN NOPTI
KASAN: probably user-memory-access in range [0x00000488850fdbb0-0x00000488850fdbb7]
CPU: 0 UID: 0 PID: 25741 Comm: syz.3.5509 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:ovl_iterate_merged fs/overlayfs/readdir.c:856 [inline]
RIP: 0010:ovl_iterate+0x645/0x1120 fs/overlayfs/readdir.c:906
Code: 07 00 00 49 8b 46 08 48 83 c0 10 48 39 c3 0f 84 b0 fd ff ff e8 bc 94 77 fe 4c 8d 63 31 4c 89 e0 4c 89 e2 48 c1 e8 03 83 e2 07 <0f> b6 04 28 38 d0 7f 08 84 c0 0f 85 01 07 00 00 44 0f b6 6b 31 31
RSP: 0018:ffffc90003367d20 EFLAGS: 00010206
RAX: 0000009110a1fb76 RBX: 00000488850fdb85 RCX: ffffc90019118000
RDX: 0000000000000006 RSI: ffffffff83473ee4 RDI: 0000000000000007
RBP: dffffc0000000000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: ffff888026ca66b0 R12: 00000488850fdbb6
R13: ffff888056ed2598 R14: ffff888033b4e900 R15: ffffc90003367e70
FS:  00007f78892aa6c0(0000) GS:ffff8881248f6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0c09f72100 CR3: 000000001270e000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 wrap_directory_iterator+0xa2/0xe0 fs/readdir.c:65
 iterate_dir+0x296/0xaf0 fs/readdir.c:108
 __do_sys_getdents fs/readdir.c:326 [inline]
 __se_sys_getdents fs/readdir.c:312 [inline]
 __x64_sys_getdents+0x13c/0x2b0 fs/readdir.c:312
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f788838f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f78892aa038 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
RAX: ffffffffffffffda RBX: 00007f78885e5fa0 RCX: 00007f788838f749
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 00007f7888413f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f78885e6038 R14: 00007f78885e5fa0 R15: 00007ffe66aedea8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ovl_iterate_merged fs/overlayfs/readdir.c:856 [inline]
RIP: 0010:ovl_iterate+0x645/0x1120 fs/overlayfs/readdir.c:906
Code: 07 00 00 49 8b 46 08 48 83 c0 10 48 39 c3 0f 84 b0 fd ff ff e8 bc 94 77 fe 4c 8d 63 31 4c 89 e0 4c 89 e2 48 c1 e8 03 83 e2 07 <0f> b6 04 28 38 d0 7f 08 84 c0 0f 85 01 07 00 00 44 0f b6 6b 31 31
RSP: 0018:ffffc90003367d20 EFLAGS: 00010206
RAX: 0000009110a1fb76 RBX: 00000488850fdb85 RCX: ffffc90019118000
RDX: 0000000000000006 RSI: ffffffff83473ee4 RDI: 0000000000000007
RBP: dffffc0000000000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: ffff888026ca66b0 R12: 00000488850fdbb6
R13: ffff888056ed2598 R14: ffff888033b4e900 R15: ffffc90003367e70
FS:  00007f78892aa6c0(0000) GS:ffff8881249f6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e2adb4d000 CR3: 000000001270e000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	00 00                	add    %al,(%rax)
   2:	49 8b 46 08          	mov    0x8(%r14),%rax
   6:	48 83 c0 10          	add    $0x10,%rax
   a:	48 39 c3             	cmp    %rax,%rbx
   d:	0f 84 b0 fd ff ff    	je     0xfffffdc3
  13:	e8 bc 94 77 fe       	call   0xfe7794d4
  18:	4c 8d 63 31          	lea    0x31(%rbx),%r12
  1c:	4c 89 e0             	mov    %r12,%rax
  1f:	4c 89 e2             	mov    %r12,%rdx
  22:	48 c1 e8 03          	shr    $0x3,%rax
  26:	83 e2 07             	and    $0x7,%edx
* 29:	0f b6 04 28          	movzbl (%rax,%rbp,1),%eax <-- trapping instruction
  2d:	38 d0                	cmp    %dl,%al
  2f:	7f 08                	jg     0x39
  31:	84 c0                	test   %al,%al
  33:	0f 85 01 07 00 00    	jne    0x73a
  39:	44 0f b6 6b 31       	movzbl 0x31(%rbx),%r13d
  3e:	31                   	.byte 0x31


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
