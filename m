Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E339C3019D7
	for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 07:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773904835; cv=none; b=Xp/UJoo/HWZ+JkiW/jp0nYat0G4pm51tU6vEup3Vkjoy03VLznI1x8VlDg6NPZ9W9RyBTix6iPo/sqHZxZEKMS5e8/XryGKAdItr2OZdWrY+xCF0d3Keoh+Cy0nRZr2caN0JwdACLvOQ4MzycMvWQokO/EvlO3iI9fPzBc6ccXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773904835; c=relaxed/simple;
	bh=Pbzgw1p28QaMq1IaNK7YjVB0W6x2rXWHpZhAFxRcZe0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=asTT0tJW758as5+rXynOZXgLujqyVSW4pJQ8vN82S0MaKK+hNDXyqnUpruPV5U8aQEl8IPdDGj9VoM6uXoxXkFLRnVYuJih+JPmAkLpBUqSWgkK8JcPzzMQsAZ2uyA8tIFkqI0XjWIupQuTS/SFvnX7jW2yn5tExQv84pnqAyeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-67bbb4e5f24so6015433eaf.0
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 00:20:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773904833; x=1774509633;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=46RXaeXXKwybWDt1XkZRwMyCctEztxZyo5tWo9IKaog=;
        b=kyvsBPQCEKuOKL16EpyWj2a3qDD99XL/JRsDFWGG/YFKgRxjTdg+UZtuu/jBWPWk/N
         uya+AmgmNICdbSZ07gYKOVQYbSXq7LSSJsYeb1f1005WHjhtICCkhN/HiT215aWdwtUs
         JCAufvmGL2hStFEwVyc1nXtzFyCLQP9/Qg+K255GN/x/cvEs2KmWmNL5PjN9o2E8Dzxt
         5S9xNB3zhvx5Rkb39Q+zlBvtlUwBRA+6cJOt9tzTD13LS6xIhMWv2LU+DD6qklNVYTib
         2lu9CA7n5jFIYNV+afFIBQgZ8NjSxuwTKz0kc7DaptK+g3hIghrXzTCX8+bBMR/CPXpZ
         oMyA==
X-Forwarded-Encrypted: i=1; AJvYcCW/WYDoJ9/lYC/zx+Gy0+RvtpuOW745btVQU5C/bNsCJJGSKvYpULpVIX9EFE5aVpd713VKN9hmEXUswMU9@vger.kernel.org
X-Gm-Message-State: AOJu0Yx38KT5CAZSLbPRvIQkJMPWwgQkT33FOgiZckoNQ7e/HLBwmMhm
	NXRJoX2eMHSsamvSHX9aEi1dloBbFbaXUjUMr6yROJ3hgJ1+5U2A/d0INOWWADajmdra2ASVLaF
	tqAYq1sQQhx0SGu3QZrsU3yHEiUSocVo8xdOQbGFXYk09b4FnbxPV07huYLs=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:308b:b0:661:13eb:6ce4 with SMTP id
 006d021491bc7-67c0daa01d1mr4052547eaf.21.1773904833061; Thu, 19 Mar 2026
 00:20:33 -0700 (PDT)
Date: Thu, 19 Mar 2026 00:20:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bba3c1.050a0220.227207.002d.GAE@google.com>
Subject: [syzbot] [overlayfs?] general protection fault in do_dentry_open
From: syzbot <syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8e5a478b6d6a Add linux-next specific files for 20260317
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1391d602580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1d7d59e3bf573a4f
dashboard link: https://syzkaller.appspot.com/bug?extid=f34aab278bf5d664e2be
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15395b4a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130ef8da580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d3f80068a490/disk-8e5a478b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5bfbdf243860/vmlinux-8e5a478b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f43f1bae2625/bzImage-8e5a478b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 0 UID: 0 PID: 6035 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:do_dentry_open+0xaf/0x14e0 fs/open.c:896
Code: 44 24 28 80 3c 28 00 74 08 4c 89 ff e8 fa 5e ef ff 4c 89 7c 24 20 4d 89 27 4d 8d 7c 24 30 4c 89 f8 48 c1 e8 03 48 89 44 24 58 <80> 3c 28 00 74 08 4c 89 ff e8 e3 5d ef ff 4c 89 7c 24 60 4d 8b 3f
RSP: 0018:ffffc900037d7638 EFLAGS: 00010206
RAX: 0000000000000006 RBX: ffff88807217db60 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000ffffffff
RBP: dffffc0000000000 R08: ffff88807b54d9b3 R09: 1ffff1100f6a9b36
R10: dffffc0000000000 R11: ffffed100f6a9b37 R12: 0000000000000000
R13: 1ffff1100e42fb7d R14: ffff88807217dbe8 R15: 0000000000000030
FS:  00005555907f6500(0000) GS:ffff888124de1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 00000000772e8000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 vfs_open+0x3b/0x340 fs/open.c:1081
 backing_file_open_user_path+0x24/0x50 fs/file_table.c:73
 backing_tmpfile_open+0x9b/0xf0 fs/backing-file.c:71
 ovl_create_tmpfile fs/overlayfs/dir.c:1392 [inline]
 ovl_tmpfile+0x400/0x810 fs/overlayfs/dir.c:1449
 vfs_tmpfile+0x3ff/0x890 fs/namei.c:4744
 do_tmpfile+0xd3/0x240 fs/namei.c:4809
 path_openat+0x300d/0x3860 fs/namei.c:4843
 do_file_open+0x23e/0x4a0 fs/namei.c:4881
 do_sys_openat2+0x113/0x200 fs/open.c:1366
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_open fs/open.c:1380 [inline]
 __se_sys_open fs/open.c:1376 [inline]
 __x64_sys_open+0x11e/0x150 fs/open.c:1376
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff99279c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff78638ef8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007ff992a15fa0 RCX: 00007ff99279c799
RDX: 0000000000000028 RSI: 0000000000551083 RDI: 0000200000000040
RBP: 00007ff992832c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff992a15fac R14: 00007ff992a15fa0 R15: 00007ff992a15fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:do_dentry_open+0xaf/0x14e0 fs/open.c:896
Code: 44 24 28 80 3c 28 00 74 08 4c 89 ff e8 fa 5e ef ff 4c 89 7c 24 20 4d 89 27 4d 8d 7c 24 30 4c 89 f8 48 c1 e8 03 48 89 44 24 58 <80> 3c 28 00 74 08 4c 89 ff e8 e3 5d ef ff 4c 89 7c 24 60 4d 8b 3f
RSP: 0018:ffffc900037d7638 EFLAGS: 00010206
RAX: 0000000000000006 RBX: ffff88807217db60 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000ffffffff
RBP: dffffc0000000000 R08: ffff88807b54d9b3 R09: 1ffff1100f6a9b36
R10: dffffc0000000000 R11: ffffed100f6a9b37 R12: 0000000000000000
R13: 1ffff1100e42fb7d R14: ffff88807217dbe8 R15: 0000000000000030
FS:  00005555907f6500(0000) GS:ffff888124de1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 00000000772e8000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	44 24 28             	rex.R and $0x28,%al
   3:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1)
   7:	74 08                	je     0x11
   9:	4c 89 ff             	mov    %r15,%rdi
   c:	e8 fa 5e ef ff       	call   0xffef5f0b
  11:	4c 89 7c 24 20       	mov    %r15,0x20(%rsp)
  16:	4d 89 27             	mov    %r12,(%r15)
  19:	4d 8d 7c 24 30       	lea    0x30(%r12),%r15
  1e:	4c 89 f8             	mov    %r15,%rax
  21:	48 c1 e8 03          	shr    $0x3,%rax
  25:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
* 2a:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 e3 5d ef ff       	call   0xffef5e1b
  38:	4c 89 7c 24 60       	mov    %r15,0x60(%rsp)
  3d:	4d 8b 3f             	mov    (%r15),%r15


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
