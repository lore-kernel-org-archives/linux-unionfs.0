Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7892F1FCB
	for <linux-unionfs@vger.kernel.org>; Thu, 27 Nov 2025 23:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764287764; cv=none; b=GTCVKnXie9vtlR2wTK4z/g55Fb5ns4U69yXkPXnwHM22bih4GYLRXpWxp1LdifgrLWYhAJCpePX5DCbXv7LupfMbLs61f9TOVai5D/1Vg6ToMD5dGHQTMLiyazRcgID4tkHM+QYRlymHhkXebMmamSgH63OeEuctwZWCRSPt/Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764287764; c=relaxed/simple;
	bh=B84p07Lal+bz5kkMxPCDPB8pZElp6uU/vO+zbEuxlHY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=rT6RsCdPZtEDkG+A9Vj1CH4QASyi7P5+XU4I0BDQBen7in6wWBm/7SA/BzZGNXW7HhEHVgX8Rk/N1GZmvavE6MheqnDBah9YngttDZNhz0Tx8qsbT5OPbCq81JMVGg5QYkCsPWg5meQ/xWkaVpwge5Lz63dJA7waoihdlMfcNM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-9489c73d908so70602239f.2
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Nov 2025 15:56:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764287762; x=1764892562;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ADQPIMYoNAMhB0Om8+ldlY3pmxuWZv8eZT90H7dqM4=;
        b=dgnhC73Fq7moU/jQVWSJHHp4F1QNWEhIcZ/PBs6dt6c3FgvIwC+6a2Gkv0aOIs3zGI
         i+7QvF0iXsMUorJ116zvSdRtFeyxF5n+114XgtpLbBv/mKXvN2hmTL32UzdnjviewqnN
         HxRQRKsOPQPd+mVjoqHEpsdoT0XJA8P7gck854MVhVJkvOajnVGaA8PewgSLDmyL/2W/
         b/isHBHdvZPU83b4Fxqf0940rYbEben/L3FDGmLOZ/4HhEjz5MixcLoY+BSKs1BK4U8t
         X8m/sfV823pdpB5xUicMLSWpq2TEMMxDVeSp6fsKofyN3jLS/IN9waJ3KqJo3fhaSj2P
         AoFw==
X-Forwarded-Encrypted: i=1; AJvYcCXztpuyumqGE2ejxHk9cDKRieohKRIMunnFvs/F5Az8hSJM/ESnIlir+sxSbQOGrZyI5YU5/yGbZ/yekUL2@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk0iFuFDF4VzyKs8T1dJUZytQ0S/PlDRV2zhjcECzwwSqLnp70
	mLxp4ebJ0FG4+VFAsvAvKP5ppLGpNlmRK+HPhLF4TbR6njWZBXS2iRoB93bZPSVU8Jb5A38o1ya
	EKjfAX0piCcIbK1BsGMBoa072hYSVxGkmC5BVq48x7mE25CO4NKxdUw4Mx30=
X-Google-Smtp-Source: AGHT+IHMsUBvllSPOWNH3mzk9gY/mOONXfjQrjflwIbmJia2Po5mLC14f+svSUNKr8qysIk1kvoHJSNdZ6cI89kUwsu/ZcPrelw5
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cda2:0:b0:433:2091:8a86 with SMTP id
 e9e14a558f8ab-435dd050f5emr117822475ab.6.1764287762152; Thu, 27 Nov 2025
 15:56:02 -0800 (PST)
Date: Thu, 27 Nov 2025 15:56:02 -0800
In-Reply-To: <20251127234129.9487-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6928e512.a70a0220.d98e3.0124.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink (2)
From: syzbot <syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com>
To: amir73il@gmail.com, brauner@kernel.org, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, neilb@ownmail.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in shmem_unlink

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6869 at fs/inode.c:417 drop_nlink+0xc5/0x110 fs/inode.c:417
Modules linked in:
CPU: 1 UID: 0 PID: 6869 Comm: syz.0.58 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:417
Code: c0 08 00 00 be 08 00 00 00 e8 37 6a ec ff f0 48 ff 83 c0 08 00 00 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 0c a6 8a ff 90 <0f> 0b 90 eb 81 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
RSP: 0018:ffffc90003bd7288 EFLAGS: 00010293
RAX: ffffffff82340734 RBX: ffff8880592bec40 RCX: ffff88802957da00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffff5200077ae49 R12: 1ffff1100b257d91
R13: 000000006928e4cf R14: ffff8880592bec88 R15: dffffc0000000000
FS:  00007fecf3ad56c0(0000) GS:ffff888126ef4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fecf3ad4f98 CR3: 0000000039a9c000 CR4: 00000000003526f0
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
RIP: 0033:0x7fecf448f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fecf3ad5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fecf46e6090 RCX: 00007fecf448f749
RDX: 0000000000105042 RSI: 0000200000000080 RDI: ffffffffffffff9c
RBP: 00007fecf4513f91 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000001ff R11: 0000000000000246 R12: 0000000000000000
R13: 00007fecf46e6128 R14: 00007fecf46e6090 R15: 00007ffc02c45398
 </TASK>


Tested on:

commit:         e1afacb6 Merge tag 'ceph-for-6.18-rc8' of https://gith..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11681f42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=38a0c4cddc846161
dashboard link: https://syzkaller.appspot.com/bug?extid=bfc9a0ccf0de47d04e8c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.
