Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B2E41A8F
	for <linux-unionfs@vger.kernel.org>; Thu, 25 Dec 2025 00:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766622202; cv=none; b=ROSAUSofDBfNTwY5NlLwyqgD9XkrFRQ2+0jycAVRXTgIf6A/5L4CdElg6UOFRXieE5SaSKeGsMKC5NWgKjavSVkj0yGswQZJGWld2aOxXbdBHfZnKkCQyRZN00gu4tajDExjLjBGaSHUFU/0RTepRXs3YQ4Qv8Q486EOug5d5BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766622202; c=relaxed/simple;
	bh=5HqmG0XxPxIdIz54ebXDeZ4wOIX6qL08vC58F38YQL0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KwhueVsbmNQtK1npkkZN+UEkFUCaZwP+Htv06LQwQ/Q/xpR6w2nnS9rKA4UCutnRFs9K7/9W1sVN3EhwFuNpJnwjH86dNKBoA8o1YEXqDoGJew630Lj2gpg0J3vjy4NzsDlJJmqwmWSaD5q89shqsMSz1TtUNJ15OoUD5/agDCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-65703b66ebfso10524126eaf.0
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Dec 2025 16:23:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766622199; x=1767226999;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Uxcgsamk0+6RrM/8nKWQY8I7xSlkQ8o5HmeILS8TAU=;
        b=bNG0g/JpkDWUC34x6a4mRdHA9hwkKJvRiv3+/ANDIPUJQ2fcdavLQChPB4QMI+064N
         JPTXEvjVCAmpQAc35SeBa5QAlxxqqILBxKGQTLnPcL1MghwI+VnIbtK7QcV9sxcCymqB
         g1pAONvT8y/2OFJedAYqXUJX3uWWMirPYpKey2EfES7xP8sLkY6XHb5PMLS/qxijNiCA
         OuejWB9dx/VGmnYUZMdTdwAaJxnCW/4+40Ilq2JvC5cWY2s+W286sAf/8YjBA2y7tExG
         nJnMTKTSUtVU34aSGJkhAME2AF/H0Vliaw6UM+rDo06nYlXKNZmI/eV4W3UEWC0sblk8
         54Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVrc8xxLsE6fN3EYzek7OmgoLgqsBBAQR/JKlaXaf+T04VqqGC4vq+CCSzuF4/PJqKZ12KlRa3YadCdxahE@vger.kernel.org
X-Gm-Message-State: AOJu0YyOBho8P55jIZd3IWxLnIrkBipWi0909BRJVsB/ZNgsHabMGHsd
	8tN/IS7BTl9DU2yuvffyyXmbP+Jm1XE+ovcPZOn41PyVLolqFhY6wXdnwPdN0S41y2UwEQLOFlI
	VllaceNMB2XVJnCiFMmxuPKaIonmxgDIbCXf+O/GqX6mc0c+9SoJjr6zS9KE=
X-Google-Smtp-Source: AGHT+IEkH3TVcB/G4XDMU9UQ3GoiEgHCR4icBvg9G14svsZZfWDNOTLZ2VZNLFXlo/81D1Al8ENe6pZMHcEKkTZRqZEJZigXktyO
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2c0a:b0:659:a8f3:e10f with SMTP id
 006d021491bc7-65cfe770b7cmr7820080eaf.31.1766622199341; Wed, 24 Dec 2025
 16:23:19 -0800 (PST)
Date: Wed, 24 Dec 2025 16:23:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694c83f7.050a0220.35954c.002d.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in end_dirop
From: syzbot <syzbot+19b2d871b77d222db434@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d8ba32c5a460 Merge tag 'block-6.19-20251218' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b11392580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1f2b6fe1fdf1a00b
dashboard link: https://syzkaller.appspot.com/bug?extid=19b2d871b77d222db434
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/aea104204e52/disk-d8ba32c5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/84e31eb35609/vmlinux-d8ba32c5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8598104810a4/bzImage-d8ba32c5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+19b2d871b77d222db434@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(rt_mutex_owner(lock) != current)
WARNING: kernel/locking/rtmutex_common.h:182 at debug_rt_mutex_unlock kernel/locking/rtmutex_common.h:182 [inline], CPU#1: syz.4.151/6765
WARNING: kernel/locking/rtmutex_common.h:182 at rt_mutex_slowunlock+0x6c0/0x8a0 kernel/locking/rtmutex.c:1419, CPU#1: syz.4.151/6765
Modules linked in:
CPU: 1 UID: 0 PID: 6765 Comm: syz.4.151 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:debug_rt_mutex_unlock kernel/locking/rtmutex_common.h:182 [inline]
RIP: 0010:rt_mutex_slowunlock+0x6c7/0x8a0 kernel/locking/rtmutex.c:1419
Code: db 8e 48 c1 e8 03 42 0f b6 04 20 84 c0 0f 85 c0 01 00 00 83 3d 7d ea 05 04 00 75 13 48 8d 3d 00 ea 08 04 48 c7 c6 60 1e eb 8a <67> 48 0f b9 3a 90 e9 35 fa ff ff 90 0f 0b 90 e9 59 fe ff ff be 02
RSP: 0018:ffffc9000f52f4c0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff88805ddef6f0 RCX: ffff88801df5bc80
RDX: 0000000000000000 RSI: ffffffff8aeb1e60 RDI: ffffffff8ede4300
RBP: ffffc9000f52f5b0 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff1db686f R12: dffffc0000000000
R13: ffff88805ddef6a0 R14: 0000000000000a06 R15: 1ffff92001ea5ea0
FS:  00007f64ba31e6c0(0000) GS:ffff888126e01000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000005c8c0000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 inode_unlock include/linux/fs.h:1037 [inline]
 end_dirop+0x7d/0x90 fs/namei.c:2888
 end_creating_keep include/linux/namei.h:147 [inline]
 ovl_workdir_create+0x4c7/0x900 fs/overlayfs/super.c:346
 ovl_make_workdir fs/overlayfs/super.c:682 [inline]
 ovl_get_workdir fs/overlayfs/super.c:840 [inline]
 ovl_fill_super_creds fs/overlayfs/super.c:1453 [inline]
 ovl_fill_super+0x188f/0x5a90 fs/overlayfs/super.c:1567
 vfs_get_super fs/super.c:1324 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1343
 vfs_get_tree+0x92/0x2a0 fs/super.c:1751
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3636 [inline]
 do_new_mount+0x302/0xa10 fs/namespace.c:3712
 do_mount fs/namespace.c:4035 [inline]
 __do_sys_mount fs/namespace.c:4224 [inline]
 __se_sys_mount+0x313/0x410 fs/namespace.c:4201
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f64bc0bf749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f64ba31e038 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f64bc315fa0 RCX: 00007f64bc0bf749
RDX: 0000200000000b80 RSI: 0000200000000100 RDI: 0000000000000000
RBP: 00007f64bc143f91 R08: 0000200000000240 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f64bc316038 R14: 00007f64bc315fa0 R15: 00007ffc96aee038
 </TASK>
----------------
Code disassembly (best guess):
   0:	db 8e 48 c1 e8 03    	fisttpl 0x3e8c148(%rsi)
   6:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
   b:	84 c0                	test   %al,%al
   d:	0f 85 c0 01 00 00    	jne    0x1d3
  13:	83 3d 7d ea 05 04 00 	cmpl   $0x0,0x405ea7d(%rip)        # 0x405ea97
  1a:	75 13                	jne    0x2f
  1c:	48 8d 3d 00 ea 08 04 	lea    0x408ea00(%rip),%rdi        # 0x408ea23
  23:	48 c7 c6 60 1e eb 8a 	mov    $0xffffffff8aeb1e60,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	90                   	nop
  30:	e9 35 fa ff ff       	jmp    0xfffffa6a
  35:	90                   	nop
  36:	0f 0b                	ud2
  38:	90                   	nop
  39:	e9 59 fe ff ff       	jmp    0xfffffe97
  3e:	be                   	.byte 0xbe
  3f:	02                   	.byte 0x2


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
