Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DC31EA7D1
	for <linux-unionfs@vger.kernel.org>; Thu,  6 Feb 2025 13:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738848747; cv=none; b=f3+7jrTTbaXpcCFXBst3HUXcAN1XI9HfYs6AK7Ne04ksEsn65h8oLFFo+IHPy215uDBzcHDUkDbG/wcs3Ywbx6QEttqCsYBfAyz8Gh4tfjvQR37pvztkvAqepZtJxQZDel11gwtjnfvxDFP8UxBLDy1BaMUcQGcEOHpHj+SlLOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738848747; c=relaxed/simple;
	bh=DTZKQQioBnMwqumypWWor9mITJYoqJGzfS1zESGLYA4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qFnn5ObFByEP7E93Ym+c8Zrx1jx0FlWRueKob9qljdbKd6Grnkdb87rdwwd20Zr0/BhZ1kLpN0F+yFLf5DsEawqc3IHyUfFr+ZTciAKKhun5sRKlHMXDK05Zzlo8ClfnRxFU9/Xuf5dJ2pKj2udHMhd80LiTPQuDb6+VwncpdCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d04b390e9cso5431815ab.3
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Feb 2025 05:32:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738848744; x=1739453544;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=caeipFMK9LSzj6Y/pd9FAx9dqXfLglZhdEiweSmy3Qs=;
        b=kJ8jlUU1EFKpa/U0YTJh3Sv7jBz2uWslDZCbg1yAxkePyQPx6BLJDdH7w1dLJ2Lt9z
         pPdmYynKp6tN6d6wmM7NLdUPvFwRy6s31uB084phgh05eapsARMztGi0s4HvCGrDl/UR
         bAzOO/w1xMYuuGAb/bpNVY9a/jFpr3RfQoasjGVndNrijd+aJthpeMfhDrBHaEziZz51
         ONFCeBvmKuObaMXqYWxaXLGLds2Np/BnmJqa/blTvvHiWwesGFzvk7m3H9BpE8W9BdlC
         jE7kTZM/bDH0kLnuXWSB7KS6Igq5vevjzR5PhLtigkhmgebk0+8sp4xBqs2B8PAMU63f
         DEVA==
X-Forwarded-Encrypted: i=1; AJvYcCVzWVHTCC5ngG6PRGkrWTRfGgbrI2E+Oks9EpEnClZotdb/G5Ofo2Soqd1EA9H6TNC4p4BofKqumuBLsOB8@vger.kernel.org
X-Gm-Message-State: AOJu0Yxoxn4JB0X4yo1hS0RhnHHzic1+eqyjyqWtwI6RaRvERgg/qFXC
	ZMSOhITUPTglYXGIEf4g3lrfAn6MkR6cyeL+jGcNOUfIEcGBlVAAf7ell3LYm13AOj5Xd5ClisT
	rVA2XF83VkHLtT4zt9RxIACShwurwVUkuKwveBKVPIpia6HPRqF4c4EE=
X-Google-Smtp-Source: AGHT+IF7qyEGqqywpW3bywnhxGPuZln9LlRICGT+piy6W7bOyXoz8xXxP0bAYvgMPvyIjNnXUl3og24BVIlS8ctTqNy4/nxLmcDU
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1707:b0:3d0:23f6:2eed with SMTP id
 e9e14a558f8ab-3d04f44ce97mr53607355ab.11.1738848744668; Thu, 06 Feb 2025
 05:32:24 -0800 (PST)
Date: Thu, 06 Feb 2025 05:32:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a4b9e8.050a0220.d6d27.0000.GAE@google.com>
Subject: [syzbot] [overlayfs?] general protection fault in clone_private_mount
From: syzbot <syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    808eb958781e Add linux-next specific files for 20250206
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=126e33df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=88b25e5d30d576e4
dashboard link: https://syzkaller.appspot.com/bug?extid=62dfea789a2cedac1298
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16346df8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117e80e4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/493ef93f2e5f/disk-808eb958.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b41757cd41c9/vmlinux-808eb958.xz
kernel image: https://storage.googleapis.com/syzbot-assets/24f456104aad/bzImage-808eb958.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000009: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
CPU: 0 UID: 0 PID: 5834 Comm: syz-executor772 Not tainted 6.14.0-rc1-next-20250206-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:is_anon_ns fs/mount.h:159 [inline]
RIP: 0010:clone_private_mount+0x184/0x3e0 fs/namespace.c:2425
Code: 89 d8 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc 48 83 c3 48 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 4d 89 fc 74 08 48 89 df e8 db dd e4 ff 48 8b 1b 31 ff
RSP: 0018:ffffc90003e2f958 EFLAGS: 00010206
RAX: 0000000000000009 RBX: 0000000000000048 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff888032eb2710
RBP: 0000000000000000 R08: ffffffff8ea81ca7 R09: 1ffffffff1d50394
R10: dffffc0000000000 R11: fffffbfff1d50395 R12: ffff888032eb2700
R13: ffff888032eb2720 R14: 1ffff11006b34091 R15: ffff8880359a0488
FS:  0000555584629380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 00000000786c2000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ovl_get_layers fs/overlayfs/super.c:1061 [inline]
 ovl_get_lowerstack fs/overlayfs/super.c:1156 [inline]
 ovl_fill_super+0x1a24/0x3560 fs/overlayfs/super.c:1404
 vfs_get_super fs/super.c:1280 [inline]
 get_tree_nodev+0xb7/0x140 fs/super.c:1299
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3659
 do_mount fs/namespace.c:3999 [inline]
 __do_sys_mount fs/namespace.c:4210 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4187
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9d7cd98329
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdbd4bd438 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 00007f9d7cd98329
RDX: 0000200000000180 RSI: 0000200000000140 RDI: 0000000000000000
RBP: 00007f9d7ce0b610 R08: 00002000000001c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffdbd4bd608 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:is_anon_ns fs/mount.h:159 [inline]
RIP: 0010:clone_private_mount+0x184/0x3e0 fs/namespace.c:2425
Code: 89 d8 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc 48 83 c3 48 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 4d 89 fc 74 08 48 89 df e8 db dd e4 ff 48 8b 1b 31 ff
RSP: 0018:ffffc90003e2f958 EFLAGS: 00010206
RAX: 0000000000000009 RBX: 0000000000000048 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff888032eb2710
RBP: 0000000000000000 R08: ffffffff8ea81ca7 R09: 1ffffffff1d50394
R10: dffffc0000000000 R11: fffffbfff1d50395 R12: ffff888032eb2700
R13: ffff888032eb2720 R14: 1ffff11006b34091 R15: ffff8880359a0488
FS:  0000555584629380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000066c7e0 CR3: 00000000786c2000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	89 d8                	mov    %ebx,%eax
   2:	48 83 c4 10          	add    $0x10,%rsp
   6:	5b                   	pop    %rbx
   7:	41 5c                	pop    %r12
   9:	41 5d                	pop    %r13
   b:	41 5e                	pop    %r14
   d:	41 5f                	pop    %r15
   f:	5d                   	pop    %rbp
  10:	c3                   	ret
  11:	cc                   	int3
  12:	cc                   	int3
  13:	cc                   	int3
  14:	cc                   	int3
  15:	48 83 c3 48          	add    $0x48,%rbx
  19:	48 89 d8             	mov    %rbx,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2e:	4d 89 fc             	mov    %r15,%r12
  31:	74 08                	je     0x3b
  33:	48 89 df             	mov    %rbx,%rdi
  36:	e8 db dd e4 ff       	call   0xffe4de16
  3b:	48 8b 1b             	mov    (%rbx),%rbx
  3e:	31 ff                	xor    %edi,%edi


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
