Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A9B32E745
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Feb 2026 07:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770707129; cv=none; b=LqJViuPtzqfN7MM0TUR8wA07n5GgRA57ic+ZznZH593pPGCWLMnXUGE0chNDN4PbCN9/WePqbtVo17lT2L9RhbfiVtMIlajXnazt9fV2nKDI4fhwB/j1yc8AkWnd+VYHAy5MQEEdeoLVn1tILMZGKO0/TEP7iX8/qXpa202pFV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770707129; c=relaxed/simple;
	bh=FfvjmMtbr+l7yyr/lzi2SNNav2qpTG29N9G1743vkIU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Yz4QAt6pQnNVlL1smcZrvpueQHQaUt4XfYVqtuFaXpDGUKwYtoeJ8B6K/wQkZufd6/kXgVoc8Q6U/ZW9hcH6gGzNJkb77HtvLRYBYjquPK/4ycPO2FQ/o2L0JtIoS6OmQq007ZR+qtNwCyAf7GDOewJytOX8WkzbVw5pG0N4NqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7d185984792so2105219a34.1
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Feb 2026 23:05:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770707127; x=1771311927;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D6BRwKNufHnhCCmb1iIN3+erlQW3TyvPeAAx0pMb11k=;
        b=M7ywRnAy9AsF4EUnp1G7uZm4AthEymNoHTdtWNvR6/W6hmP/fAG4TDYHInvOHoDkZv
         VMoGDd3OkQt5Wjq4OIViMylqLkrgogdthsUK6f8zZPB/CccndRpqNMYJlxt1qhd3DMuU
         TSgNXeQ5mhnDEIdf+BOZyb364bJ/+/VuTZcAnl83/nZU5sKguLcmuOPMRwN14NrU8lC0
         Wl+uifybDE0erqgbKkEyh31pWKzOyyy+YfvmkBgnbM7kfCKMjFV3zXd5Lp6oJW9Kp6lX
         uH6Cze0Yarsg97+uieqmLkiPiQKVeaQjs21CpiiUAd07y7IlsDfLMSvhx/9m7DBksHwV
         9EbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxmy7Dgus+ZZsq84oKPHynnQyFX9yHcZWdTvJTmzMNwad9NvNCPCKx/0R2kvE6wxtXIbJjdS7r66C71SKk@vger.kernel.org
X-Gm-Message-State: AOJu0YwFuT3V0oWabnb+udeLxf2eL8CzXr9DBc2ltIrLuBu6CyFdPooI
	PHOJU2QVLGcjbb5r88w6z/vAXSHLbBymf7S4q0WJzfL7FEX96YSjEmhimbFN8sR4GWq8VseArnd
	5W/+B0X8tiiU5McDUdNfJrmIW0cYARySwIKvZ2Kwx4FuaEihxlZ4TAIqouQs=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3088:b0:662:f61e:759d with SMTP id
 006d021491bc7-66d0c666b89mr6513087eaf.62.1770707127429; Mon, 09 Feb 2026
 23:05:27 -0800 (PST)
Date: Mon, 09 Feb 2026 23:05:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698ad8b7.050a0220.3b3015.008b.GAE@google.com>
Subject: [syzbot] [overlayfs?] KMSAN: uninit-value in ovl_fileattr_get
From: syzbot <syzbot+fa79520cb6cf363d660d@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8fdb05de0e2d Merge tag 'net-6.19-rc9' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d888aa580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9682a42d8ec8b05c
dashboard link: https://syzkaller.appspot.com/bug?extid=fa79520cb6cf363d660d
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1233cb22580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1035878a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/25d060d68c51/disk-8fdb05de.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f033f4d0ec73/vmlinux-8fdb05de.xz
kernel image: https://storage.googleapis.com/syzbot-assets/942ea5e5d5f5/bzImage-8fdb05de.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fa79520cb6cf363d660d@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ovl_security_fileattr fs/overlayfs/inode.c:617 [inline]
BUG: KMSAN: uninit-value in ovl_real_fileattr_get fs/overlayfs/inode.c:701 [inline]
BUG: KMSAN: uninit-value in ovl_fileattr_get+0x5cd/0x650 fs/overlayfs/inode.c:720
 ovl_security_fileattr fs/overlayfs/inode.c:617 [inline]
 ovl_real_fileattr_get fs/overlayfs/inode.c:701 [inline]
 ovl_fileattr_get+0x5cd/0x650 fs/overlayfs/inode.c:720
 vfs_fileattr_get fs/file_attr.c:94 [inline]
 __do_sys_file_getattr fs/file_attr.c:416 [inline]
 __se_sys_file_getattr+0x6cb/0xbd0 fs/file_attr.c:372
 __x64_sys_file_getattr+0xe4/0x150 fs/file_attr.c:372
 x64_sys_call+0x17cd/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:469
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 ovl_security_fileattr fs/overlayfs/inode.c:612 [inline]
 ovl_real_fileattr_get fs/overlayfs/inode.c:701 [inline]
 ovl_fileattr_get+0x5c6/0x650 fs/overlayfs/inode.c:720
 vfs_fileattr_get fs/file_attr.c:94 [inline]
 __do_sys_file_getattr fs/file_attr.c:416 [inline]
 __se_sys_file_getattr+0x6cb/0xbd0 fs/file_attr.c:372
 __x64_sys_file_getattr+0xe4/0x150 fs/file_attr.c:372
 x64_sys_call+0x17cd/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:469
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable fa.i created at:
 __do_sys_file_getattr fs/file_attr.c:380 [inline]
 __se_sys_file_getattr+0x8c/0xbd0 fs/file_attr.c:372
 __x64_sys_file_getattr+0xe4/0x150 fs/file_attr.c:372

CPU: 0 UID: 0 PID: 6044 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(voluntary) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
=====================================================


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
