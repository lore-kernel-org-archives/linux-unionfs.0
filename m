Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBF12DF703
	for <linux-unionfs@vger.kernel.org>; Thu, 27 Nov 2025 20:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764275793; cv=none; b=V3aZv/PqjhRWtB88wjNzniEXiFQfI5VhRlsaPmRY1IJMMMYn5ogVEXJ9leWca84RBqSARuwkrKtKOZjZljO2SZ+XtwrEqUUmdoADWyhaogjP0/Ac59sp3+vQhSq8paaWHbt0SG1goqiDRg04VwvJcyeKG2rFJe6NlZc6ZjQUrYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764275793; c=relaxed/simple;
	bh=Kdu3ENfjySkIYsFZ2Mf3HuEUQY/+jUzWcegqb0Q9gu0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OL7SFiyzQs+lNr3Kkv+eacaxT3ThnqKN4EC03vVTSB4YCkJW6Hvs1W3gfrg/HMBYkjRsH6X8pYhHzjeS98q72TLpxkGnpd6rbPTtWnjfGegERIj+/P1LJApqY4RFX6hVblTegIcpxAo8AQWX324NqtLW6wJzPDcUKLTwmf8Nuc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-4337e3aca0cso9274675ab.1
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Nov 2025 12:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764275791; x=1764880591;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a9yrpU79ZgfEOKY5TyU9mXWqxdQNr9nKCtg4cYqgusI=;
        b=Gv112lHbcKuKLGGqu0eTIQUCDOhYGaqN2hkYYNmam0y/2p/nIfjQeXtAzsYGysDq2k
         MWw/a2hYB59Kxwk49+Abpyx+FPwwXeIv3C5jUqYyic+pxccnoTnsj598AvTC7KMGXlWd
         YjB9mT6eSmIRFL6n7Mb3qKqPPB2VuLktbSXnKW84gTHJbA7B7JxmBUyeDXAtVwtF/8Cm
         L7tsPTtQc0qsABBzH7mrvftxq/NOb/cKCYGfUEWTQzGaRKTBiUPyOMyX+5cpMQJIzhb+
         m4LH9Tsby+xfoiqyH7ASgFUxlFtb10znsA5ObW9qNhHeIbqFhnhHdlO4f5vkkQxKjhjc
         OR+A==
X-Forwarded-Encrypted: i=1; AJvYcCX/ka4+BbmZg3VWrjjXAN3DnUBWRhNWedS1f7CVae3XYHH7070Z8dKtpqwv4NexWZ5WPGvwu0mpvF7J7cXg@vger.kernel.org
X-Gm-Message-State: AOJu0YygWTUlKiUFCPC6XOFb3m4wUuT2rVPNULY4Z4sULeNnIyZxPUoX
	MKA8ajvecoBVSmk5JhR+4W2khmybTHHhD9Ao0ueicr4VVUzbkO91s+xl3zhMF8Yn8OoN4U4GYYI
	FE1s2ZP7rartKnESgiYqmjiry8aAabU6eFSofgftGAap3R2v8tlQcEetOc08=
X-Google-Smtp-Source: AGHT+IF7K0NNrofBrSkHU0uwE8v+A6bJd9ujH8Qc/usra3aLCTynYWOxJ25m9MvNNyu7ykpTCBIWjkciEgEwgc5LG/ioSNGnKAYO
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2787:b0:433:7a94:6fcc with SMTP id
 e9e14a558f8ab-435b8c17ffamr212734125ab.2.1764275791461; Thu, 27 Nov 2025
 12:36:31 -0800 (PST)
Date: Thu, 27 Nov 2025 12:36:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6928b64f.a70a0220.d98e3.0115.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in shmem_unlink (2)
From: syzbot <syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com>
To: amir73il@gmail.com, brauner@kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, neil@brown.name, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    30f09200cc4a Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1047ee92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=38a0c4cddc846161
dashboard link: https://syzkaller.appspot.com/bug?extid=bfc9a0ccf0de47d04e8c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1626ae12580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1126ae12580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a5630d1ab1eb/disk-30f09200.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/584408ed3fcf/vmlinux-30f09200.xz
kernel image: https://storage.googleapis.com/syzbot-assets/69749e493b1e/bzImage-30f09200.xz

The issue was bisected to:

commit d2c995581c7c5d0ff623b2700e76bf22499c66df
Author: NeilBrown <neil@brown.name>
Date:   Wed Jul 16 00:44:14 2025 +0000

    ovl: Call ovl_create_temp() without lock held.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13db1e92580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=103b1e92580000
console output: https://syzkaller.appspot.com/x/log.txt?x=17db1e92580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com
Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6236 at fs/inode.c:417 drop_nlink+0xc5/0x110 fs/inode.c:417
Modules linked in:
CPU: 0 UID: 0 PID: 6236 Comm: syz.0.107 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:417
Code: c0 08 00 00 be 08 00 00 00 e8 87 6b ec ff f0 48 ff 83 c0 08 00 00 5b 41 5c 41 5e 41 5f 5d e9 52 5c 90 08 cc e8 2c aa 8a ff 90 <0f> 0b 90 eb 81 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
RSP: 0018:ffffc90003b0f288 EFLAGS: 00010293
RAX: ffffffff82340314 RBX: ffff888023b292e0 RCX: ffff8880397ada00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffff52000761e49 R12: 1ffff11004765265
R13: 000000006926eb25 R14: ffff888023b29328 R15: dffffc0000000000
FS:  00007f944571d6c0(0000) GS:ffff888126df6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f944571cf98 CR3: 0000000028194000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 shmem_unlink+0x1f5/0x2d0 mm/shmem.c:3979
 shmem_rename2+0x22d/0x360 mm/shmem.c:4065
 vfs_rename+0xb34/0xe80 fs/namei.c:5216
 ovl_do_rename+0x13c/0x210 fs/overlayfs/overlayfs.h:373
 ovl_create_over_whiteout fs/overlayfs/dir.c:550 [inline]
 ovl_create_or_link+0xaf7/0x1410 fs/overlayfs/dir.c:656
 ovl_create_object+0x234/0x310 fs/overlayfs/dir.c:695
 lookup_open fs/namei.c:3796 [inline]
 open_last_lookups fs/namei.c:3895 [inline]
 path_openat+0x1500/0x3840 fs/namei.c:4131
 do_filp_open+0x1fa/0x410 fs/namei.c:4161
 do_sys_openat2+0x121/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1463
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f94460cf749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f944571d038 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f9446326090 RCX: 00007f94460cf749
RDX: 0000000000105042 RSI: 0000200000000080 RDI: ffffffffffffff9c
RBP: 00007f9446153f91 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000001ff R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9446326128 R14: 00007f9446326090 R15: 00007fff80085c88
 </TASK>


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
