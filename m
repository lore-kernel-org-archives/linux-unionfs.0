Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B931F0E25
	for <linux-unionfs@vger.kernel.org>; Tue, 20 Jan 2026 01:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768871612; cv=none; b=pN9j5rlrR9In3byVLuKWCmvX+idFrrRG90K2xBIOzbiT7x5kn67nWEPLowFKReymmxfZ55EDgJlB+v9zqOz6UUlM11e2hvtwFJxQKttguMWtz1+JJdMHGaOxaBWwmDvOXFsdAlPV40v+Fi6an3y/lit5sKxWEcrC0rmTBKpLcr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768871612; c=relaxed/simple;
	bh=Y14vDKD49LDciXUVtCE3b0WBpRwLTNiS7LhbkI/TzaA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=I22/Lk2oEYIUed9/mnQX6dB9FfUKJB5SabswDd5nceHKr0LvX64HqiAwD+/2CSodYiuHx3/3s9lFQhhnNJPkTaRwnceOIlrW0KtimF/W9zDvKpzhnxT+SvnJpLekQqBX/0Vbnv6heO2jDNJ+pJa7/Tir//OM8M0gAtF6EAo3FQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-6610632db4dso12705298eaf.1
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jan 2026 17:13:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768871610; x=1769476410;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iMZ0SB80UsvlLl0TAHlXKp/7xzXwkZovkGIyQE9iOYo=;
        b=XtI/vto+W5BKgxyAXsSr/FxQX5K850p5Bry74nMCtHOcgbpMdC2rH7Xd2Jmimh/X9Z
         xmM8kN+k2BF8EV9wq8pTPiCZuHuVC33qThfa3A5wx4DlpQXQHkxYInCKwA+ytrpCph8W
         PfS3Cqop+g6C3DJgf/9NoZXtfI07IBh45RRx7Zhs60/INkpWpgIrRsj9S0UKzm2mK2b5
         4xqrhyvKxl0exYUFhVzSiwESSq98SXiHjcwXWYsLJrQPRMZl3p5jE9pQzQzPJjO8vN5j
         OjYLLeCXxDAKC3cvenruTfz7DaBWLty9fEuKzG8ipQnSRi1JXO/QNcAgDbLGe1u+UQz3
         uNvg==
X-Forwarded-Encrypted: i=1; AJvYcCWF4wdWl4hePhmImApEJwYPS7scAQ4cVMjXuws6HduoYaDu3r6KrqJbTCluCAufHyRxWeaCSeOPqyHjlDhX@vger.kernel.org
X-Gm-Message-State: AOJu0YyU/mI2Js+7a/7zbilL6lg3Yy22lSi+CeQKCDDOeVW8myYrT0vz
	+JmozlUMXYDkt58G9yaWmB4haSSNsi+T4GBy/OlPZ4nzU1kxOKxMgZyoEYyjCkVdd25uxeR4uYN
	EKJqmXHKQXuwhwJ8KvaSOZokjOdT2yH9i+DJesg1X8gTWnKc4w2YGIYBr3hk=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3081:b0:65f:6794:9e76 with SMTP id
 006d021491bc7-66118913f36mr5838273eaf.36.1768871609809; Mon, 19 Jan 2026
 17:13:29 -0800 (PST)
Date: Mon, 19 Jan 2026 17:13:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696ed6b9.a00a0220.203946.0000.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in ovl_create_real (4)
From: syzbot <syzbot+2214f6a425ea963a605b@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    603c05a1639f Merge tag 'nfs-for-6.19-2' of git://git.linux..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b8339a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1859476832863c41
dashboard link: https://syzkaller.appspot.com/bug?extid=2214f6a425ea963a605b
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-603c05a1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0fd1a1c47d69/vmlinux-603c05a1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/152f657b1f0a/bzImage-603c05a1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2214f6a425ea963a605b@syzkaller.appspotmail.com

overlayfs: ...falling back to redirect_dir=nofollow.
overlayfs: ...falling back to index=off.
overlayfs: ...falling back to uuid=null.
------------[ cut here ]------------
WARNING: fs/overlayfs/dir.c:214 at ovl_create_real+0x9af/0xbd0 fs/overlayfs/dir.c:214, CPU#2: syz.2.9540/3063
Modules linked in:
CPU: 2 UID: 0 PID: 3063 Comm: syz.2.9540 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ovl_create_real+0x9af/0xbd0 fs/overlayfs/dir.c:214
Code: 8b 48 c7 c7 c8 2b 79 90 e8 1e 42 98 01 44 0f b6 3d 41 5a 31 0d e9 dc fa ff ff e8 fc 05 e1 fe e9 67 f8 ff ff e8 12 2a 77 fe 90 <0f> 0b 90 49 c7 c4 fb ff ff ff e9 ac f8 ff ff 49 c7 c4 fe ff ff ff
RSP: 0018:ffffc9000518f4b0 EFLAGS: 00010283
RAX: 000000000001eb61 RBX: ffff88802d846758 RCX: ffffc9002830b000
RDX: 0000000000080000 RSI: ffffffff8347d1be RDI: 0000000000000005
RBP: ffff88803bd2f490 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: ffff888033102ff0 R12: 0000000000000000
R13: ffff888034d2a800 R14: ffff88802d8467c0 R15: ffff888035c6e2e0
FS:  00007f0d6ec506c0(0000) GS:ffff8880d6af2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b333dcff8 CR3: 000000005d5af000 CR4: 0000000000352ef0
DR0: ffffffffffffffff DR1: 00000000000001f8 DR2: 0000000000000083
DR3: ffffffffefffff15 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ovl_create_temp+0x54/0xb0 fs/overlayfs/dir.c:253
 ovl_copy_up_workdir fs/overlayfs/copy_up.c:778 [inline]
 ovl_do_copy_up fs/overlayfs/copy_up.c:988 [inline]
 ovl_copy_up_one+0xc4e/0x3c40 fs/overlayfs/copy_up.c:1189
 ovl_copy_up_flags+0x18f/0x240 fs/overlayfs/copy_up.c:1243
 ovl_rename_start fs/overlayfs/dir.c:1161 [inline]
 ovl_rename+0x270/0x6b0 fs/overlayfs/dir.c:1348
 vfs_rename+0x1021/0x2390 fs/namei.c:5938
 do_renameat2+0x71c/0x9b0 fs/namei.c:6056
 __do_sys_rename fs/namei.c:6099 [inline]
 __se_sys_rename fs/namei.c:6097 [inline]
 __x64_sys_rename+0x7d/0xa0 fs/namei.c:6097
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0d6dd8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0d6ec50038 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007f0d6dfe5fa0 RCX: 00007f0d6dd8f7c9
RDX: 0000000000000000 RSI: 0000200000000180 RDI: 0000200000000000
RBP: 00007f0d6de13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0d6dfe6038 R14: 00007f0d6dfe5fa0 R15: 00007fffee2fe808
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
