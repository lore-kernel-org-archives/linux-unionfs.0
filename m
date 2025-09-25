Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805F51E0DEA
	for <linux-unionfs@vger.kernel.org>; Thu, 25 Sep 2025 17:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758822632; cv=none; b=umTV86cWeIQd5nkijWGlYsmFT/d3mNAqwCkCSXfJ6MLJ5tYWKidvcecSZcBd3bP9JmmeGQs5Dr9gDyzKGlHSmLqry9568ceNHm3heh1YXUNsdKFyVDWtq3gO7aCbHokLIbrSRDF3rbTFtWiLNdx3wmP9l1QAVuoCDbGMRPeY/Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758822632; c=relaxed/simple;
	bh=hOX9VPtfC91Mg3d1GTnIUDFrJ8wLg3sJL12KTynCPNc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=W83WNIbT1/JLzdlA6DdiUmtetTdzsr+nxDU/EvSz4HD35eEHwJaCmn6hWOMVJQpGbiWqLT/ntwe3R5qG7oc5zyFi6OwUNvk1cUtF2qo8KWEeUANeMexGjIHoLjoazmZVphzpgwKtUeU3jlMtXHnQb4reTY934A+bTCSDzYUvf3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-4241c41110eso31389805ab.1
        for <linux-unionfs@vger.kernel.org>; Thu, 25 Sep 2025 10:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758822629; x=1759427429;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9+Hg3CA0qqYhxfghG2it4mVMoZpeVHhlGfIerLYLkrY=;
        b=phGWIW2e4Bog6iJxfAx7RMUBH2Sxk3zVWI/6Khbs3hsD1XHfSOBHc/rAsDcC7RtEqE
         8dNZoMtbQDJ9mQ9B1Km3EUi35Tj2uwZEKxPb0tJ2W7nf9MInOIPyZB8Esz8vKz9S7UXg
         GOjv9wS5wyzWuIIyYLiO6aHTJ2y3oVKCWE72z2qhyOK73cwhKF6GqGquBnw+AKLEs0kp
         eBHtk+Jqhgf9WZeXXNMHkMEtqVmvaglSFNWqVeRwUEOQownb2T/ZRZDYv8zFxpqsSA20
         zBB64Nnn4eZIqIny8flyCnX6hutdJXLHadRzFrYTmSV3JlD9FHLUUaVX1aJd8iKASUTG
         JBOw==
X-Forwarded-Encrypted: i=1; AJvYcCWBvoBpgqk7j8FsjnHVlzsAFOfLlITwnp4+Smq/eAE8ZTQiqVeNv5Wj7JiPn7SNicT9Ui1piSbVX8ULfQd9@vger.kernel.org
X-Gm-Message-State: AOJu0YwR9t7Ywa+j0b6KzY/0POyrqBefY3tAzFWSclouYl1AWYk7pntA
	WFo+s293TTrQELudAKN02LWVzXQUYmoVKAI7dwaeozOfR03rcIL8XFzyeD9IUu6yW5tyPdntdJR
	9wIh6cOuHPw2JOWxrGNFLsiINTqOcdCurvOH+Y0Zp/M0ORTl02Yo+CscmPgA=
X-Google-Smtp-Source: AGHT+IHXpLfshWYCdLUpi+vWygHE0MWp2ID0gLUf+wNbex6bK1BhmZijbcVJMe2Tecd+fIL4yrsD1+edyWXtE4Jp0mW3uGPz0xu/
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6c:b0:424:8151:dcd6 with SMTP id
 e9e14a558f8ab-425955d4654mr63027115ab.9.1758822629562; Thu, 25 Sep 2025
 10:50:29 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:50:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d580e5.a00a0220.303701.0019.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in ovl_copy_up_file (2)
From: syzbot <syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bf40f4b87761 Merge tag 'probes-fixes-v6.17-rc7' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1636e142580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf99f2510ef92ba5
dashboard link: https://syzkaller.appspot.com/bug?extid=f754e01116421e9754b9
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13eb34e2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ca2f12580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-bf40f4b8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2fe4635de41e/vmlinux-bf40f4b8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/acfb085eaa3e/bzImage-bf40f4b8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1280fcf9f9a9/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 8
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5501 at fs/overlayfs/copy_up.c:276 ovl_copy_up_file+0x640/0x6a0 fs/overlayfs/copy_up.c:276
Modules linked in:
CPU: 0 UID: 0 PID: 5501 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ovl_copy_up_file+0x640/0x6a0 fs/overlayfs/copy_up.c:276
Code: e9 2d ff ff ff e8 60 ac 8b fe 49 bc 00 00 00 00 00 fc ff df e9 14 ff ff ff e8 4c ac 8b fe 90 0f 0b 90 eb 09 e8 41 ac 8b fe 90 <0f> 0b 90 41 bd fb ff ff ff 48 8b 5c 24 10 e9 8d fb ff ff e8 d8 35
RSP: 0018:ffffc90002b0f040 EFLAGS: 00010293
RAX: ffffffff833410ff RBX: ffffc90002b0f0c0 RCX: ffff88801f022440
RDX: 0000000000000000 RSI: fc0000000000000a RDI: 0000000000000000
RBP: ffffc90002b0f170 R08: ffffc90002b0f0cf R09: 0000000000000000
R10: ffffc90002b0f0c0 R11: fffff52000561e1a R12: dffffc0000000000
R13: fc0000000000000a R14: ffff888033b7d380 R15: ffff888042c0f028
FS:  0000555584fee500(0000) GS:ffff88808d007000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2eacb909c0 CR3: 0000000059e0d000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ovl_copy_up_tmpfile fs/overlayfs/copy_up.c:885 [inline]
 ovl_do_copy_up fs/overlayfs/copy_up.c:999 [inline]
 ovl_copy_up_one fs/overlayfs/copy_up.c:1202 [inline]
 ovl_copy_up_flags+0x1502/0x2fe0 fs/overlayfs/copy_up.c:1257
 ovl_open+0x138/0x2f0 fs/overlayfs/file.c:211
 do_dentry_open+0x953/0x13f0 fs/open.c:965
 vfs_open+0x3b/0x340 fs/open.c:1095
 do_open fs/namei.c:3887 [inline]
 path_openat+0x2ee5/0x3830 fs/namei.c:4046
 do_filp_open+0x1fa/0x410 fs/namei.c:4073
 do_sys_openat2+0x121/0x1c0 fs/open.c:1435
 do_sys_open fs/open.c:1450 [inline]
 __do_sys_openat fs/open.c:1466 [inline]
 __se_sys_openat fs/open.c:1461 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1461
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1be718eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff614ed578 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f1be73e5fa0 RCX: 00007f1be718eec9
RDX: 0000000000000042 RSI: 0000200000000040 RDI: ffffffffffffff9c
RBP: 00007f1be7211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1be73e5fa0 R14: 00007f1be73e5fa0 R15: 0000000000000004
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
