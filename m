Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A8C38F80
	for <linux-unionfs@vger.kernel.org>; Fri, 19 Sep 2025 12:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758285035; cv=none; b=tF2L4GxM2/GF2XEci7iIz2618R0u6utxnzUTN/kkwW1w9t9PsbuwIhuliw/AQ7vF/XCQMe0swL8q3jC9W7zSaHl5pLbyiakLqyiv8nYfoQ/d0d/xb11Mm9RVJMxHMtmxdpGfIA33HQ/hlKw1ieH7VOA0UydV9MnFInaPzjVf5kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758285035; c=relaxed/simple;
	bh=jj+inExAUbsFvsAoHvcW6L6sYHa02yk0gKG/4O/EIfI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=D1R5GOrHP6DTcQheyy42bdaFV4WeJlbmvtPYSWabGbUBhVBJEHMjgxDAADI8qByE21o7IfT1VPJTdsUi0F/tHQXbUFRi3IZ99FTca5oAGHpzOLdij6ddWG5UTZYadoPisN7w1AaVBwf/8tiJDWvUh+wSiu97OiZNK+s37h7McYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-4247d389921so18837955ab.0
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Sep 2025 05:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758285032; x=1758889832;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mfmW+GAM56h3CvQewvV1CQQSb+YXqeP7gXYwDwlkbDI=;
        b=SH3GDg5KJqSrEK3ML0SPtnl9X70Z5XRGGDPC8KCZcpa3CrO5g21uOETW0LkAaDMJQQ
         ph+9OattwzjlAieHdS/FLlsU4ibWd0Eccjxckpf1ZT9yohmxQX9KsKn05xY9N9oo7hQR
         3dbr/J4xrWXDzjZhL0kZXvp39scz7/vb7MSnw5jfQE7frFPC2xpR4eO7QGHlGIpEpdDh
         hmB47AbX6BrsnzWoejU7VctJU9M3vyW9BN4Tlr+MNOagEre4kEjZNslpbAOGlonWM19P
         A2G1iv3w97bub940Q3B1vRseru66iVL7Ij961HL4AgFvmpuCnrTEvlUV2uk47stG+Z+r
         ACYg==
X-Forwarded-Encrypted: i=1; AJvYcCV9jh9HByO85BOlAQgfIXXFj2O/CNhDXuBAVRTqBOzRaf/xtIZw9G6eNu07Qk3KGgyQZt5heq/QBO7//iGJ@vger.kernel.org
X-Gm-Message-State: AOJu0YxE/rxo7MD5eilquoqxXGgHCOUsxY+gItDFn8GWpXWQ4CNh4c1T
	FpEgPLFidJWw0VFm9BJvEk59+lbc9DAOIqBtrRNfG4b7lfCuWjxooBlFOzZU+dwPHkWkGjsitSr
	Ri9fInCkzhEUF+M9gSpycEOdnrFbcbnNl4h8n4DRKqy57s92NJh/PT8CxZJk=
X-Google-Smtp-Source: AGHT+IHuHQvi7jWB2wMCGFEBNaVivefmUoLBpiF4aCIEWV/q4WZ5Vh5vWhUfCvJfaUz5ZUQR+kG2FTmzSoBj/tyIm+ej7FnkuAF9
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aae:b0:424:805a:be98 with SMTP id
 e9e14a558f8ab-4248177d40emr46555385ab.9.1758285032406; Fri, 19 Sep 2025
 05:30:32 -0700 (PDT)
Date: Fri, 19 Sep 2025 05:30:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cd4ce8.050a0220.ba58e.045e.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in ovl_create_real (3)
From: syzbot <syzbot+59732cea2887c2408d94@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f83ec76bf285 Linux 6.17-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1511e762580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f01d8629880e620
dashboard link: https://syzkaller.appspot.com/bug?extid=59732cea2887c2408d94
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f83ec76b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bdedf70f8797/vmlinux-f83ec76b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5bf9318d9242/bzImage-f83ec76b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+59732cea2887c2408d94@syzkaller.appspotmail.com

overlayfs: ...falling back to redirect_dir=nofollow.
overlayfs: ...falling back to index=off.
overlayfs: ...falling back to uuid=null.
------------[ cut here ]------------
WARNING: CPU: 3 PID: 2192 at fs/overlayfs/dir.c:208 ovl_create_real+0x50f/0x780 fs/overlayfs/dir.c:208
Modules linked in:
CPU: 3 UID: 0 PID: 2192 Comm: syz.3.9488 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ovl_create_real+0x50f/0x780 fs/overlayfs/dir.c:208
Code: 84 74 fc ff ff e8 b1 32 81 fe 48 63 ed e9 96 fc ff ff e8 a4 32 81 fe e9 2e fd ff ff 48 89 dd e9 84 fc ff ff e8 92 32 81 fe 90 <0f> 0b 90 e8 89 32 81 fe 48 89 ee 48 c7 c7 00 f0 ff ff e8 ea 2d 81
RSP: 0018:ffffc90007e9f4f0 EFLAGS: 00010283
RAX: 00000000000151fe RBX: ffff888038a89d60 RCX: ffffc9002b804000
RDX: 0000000000080000 RSI: ffffffff833a6aae RDI: ffff888038a89dc8
RBP: ffff888038a89d60 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880332f66a0
R13: ffff888031447c20 R14: 000000000000a000 R15: 000000000000a000
FS:  00007f83766e46c0(0000) GS:ffff8880d69b2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ef21ff8 CR3: 0000000032996000 CR4: 0000000000352ef0
DR0: 0000000000000002 DR1: 0000000000000005 DR2: 8000000000000000
DR3: 1000000100000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ovl_create_temp+0x64/0xb0 fs/overlayfs/dir.c:229
 ovl_copy_up_workdir fs/overlayfs/copy_up.c:782 [inline]
 ovl_do_copy_up fs/overlayfs/copy_up.c:1001 [inline]
 ovl_copy_up_one+0xc18/0x38e0 fs/overlayfs/copy_up.c:1202
 ovl_copy_up_flags+0x18d/0x200 fs/overlayfs/copy_up.c:1257
 ovl_rename+0x813/0x1710 fs/overlayfs/dir.c:1145
 vfs_rename+0xfba/0x22c0 fs/namei.c:5129
 do_renameat2+0x7f9/0xc50 fs/namei.c:5278
 __do_sys_renameat2 fs/namei.c:5312 [inline]
 __se_sys_renameat2 fs/namei.c:5309 [inline]
 __x64_sys_renameat2+0xe7/0x130 fs/namei.c:5309
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4e0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f837578eba9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f83766e4038 EFLAGS: 00000246 ORIG_RAX: 000000000000013c
RAX: ffffffffffffffda RBX: 00007f83759d5fa0 RCX: 00007f837578eba9
RDX: ffffffffffffff9c RSI: 0000200000000180 RDI: ffffffffffffff9c
RBP: 00007f8375811e19 R08: 0000000000000002 R09: 0000000000000000
R10: 0000200000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f83759d6038 R14: 00007f83759d5fa0 R15: 00007ffd8123fe08
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
