Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7CD381B8
	for <linux-unionfs@vger.kernel.org>; Mon, 13 May 2024 18:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715624908; cv=none; b=OHaCuTCAqCfbzbrk5ZlbxB9nt9IZvoDqYgGhjk5kt7ExOJhWwYgPDRm+UOA5rI2A+l2IOq+Mqept5gtO1eJIKh9KqCtifvw5GcmIPXu34bBi04evZ1j2XgI03JIhtgW4sR3iKla/HKz75yhvmS4PeCLdXjqA0py8TGZbQV7QNkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715624908; c=relaxed/simple;
	bh=Icslwjsq8g9SV845eb164Q87FLWh/kmVKyl69+aO8PA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VFts7obbvifQ8AH5kDY9S0KMEK8ESxUHlT4Hl5BSGqmqU0t72LKHMOHVpSZ7UHLeC9YJlVklxtgXk2y/spKAyzmdO2XylIgTFYakvVF1A8soK8NAQtM+HZXvmHE2lZ+ZRTQGh2vJKJtKqaAGxpHnm+XHG1xQY/r1hc/7CA3Mlxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7e1d56d36b9so265425439f.1
        for <linux-unionfs@vger.kernel.org>; Mon, 13 May 2024 11:28:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715624906; x=1716229706;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=msQ7h7JBL1Igw0Dsub4eMsPGj3cl9F2AESheEMyZNi0=;
        b=qIwk+BlmXnZOqCuH7jZ3iXONQC54UsTqQWZE7ZSbcZe0V5vsIQYYgmRXmACOz49sR5
         jWu3FJskePV8Q/XvGg1inte5YE+Tm89u46IEE8jsEKAmDMQIYQR4vrtibfQOa3CNT0oA
         tK2DnSs5w4EMcq+dj/2V9f9gNJtj7rXL/Nk9EFu9ijgnyYqUXBKP+H2QVwcBRY38q7nr
         aT23dzyNc0dVbh0ZvuAFGUH86DVopIBU/k8b5Y4Q7h0Di8Fcpg44rJatDrdbr3p6X0if
         WTuiXh4Go45G5+F4pALie41cLQKXthyxg+vYg1J5rk1Ql+EzuYfEFTC/jl/1HoDjQ4L3
         xMew==
X-Forwarded-Encrypted: i=1; AJvYcCW9r+QNHkr+hwiD3bQibS7gbYSB+nIetZ0gOHKrt/MOSfB3FdRHk7zsjGNV9auBYnj0ezygSzp1ZSQyhYRUdlTu3oTN3gsa+JIt8+Cm8A==
X-Gm-Message-State: AOJu0YzDFtRfwecPTjdwlUaOmaLYrwhByaeuD7mdar1XdPCCO3Pg4Zh5
	KvSH0qZLIcWlc9R9A+3+yQvXL7VfqmsxasMSOct2XcYioLVZ7Haz/MP0VY0uUDtEjmh0CScRTYI
	PPLNUMO23N4jlSliHAZfujruiux3pKqZEFbGiK1o3W5DBRytuheAUJSo=
X-Google-Smtp-Source: AGHT+IEJ87fqDBDxD5FNsfS/AshCbCDYvrG+kW4m+aPcTiCAXIld7FqaZva35xQz5z0JmJLK7syjbP10t7ZOrjGaAJHfkVT3me+f
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2510:b0:488:c743:c17 with SMTP id
 8926c6da1cb9f-4895a39dbf2mr971912173.5.1715624905804; Mon, 13 May 2024
 11:28:25 -0700 (PDT)
Date: Mon, 13 May 2024 11:28:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000141e8306185a0daa@google.com>
Subject: [syzbot] [overlayfs?] WARNING in ovl_workdir_create (3)
From: syzbot <syzbot+8aa3f99a6acb9f8fd429@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    45db3ab70092 Merge tag '6.9-rc7-ksmbd-fixes' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=169b934c980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2f7a2b43b9e58995
dashboard link: https://syzkaller.appspot.com/bug?extid=8aa3f99a6acb9f8fd429
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0c2a8034002c/disk-45db3ab7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/807e35e2b3a9/vmlinux-45db3ab7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4868b2eab91a/bzImage-45db3ab7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8aa3f99a6acb9f8fd429@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE)): count = 0x0, magic = 0xffff888077f311f0, owner = 0x0, curr 0xffff8880787ebc00, list empty
WARNING: CPU: 1 PID: 8339 at kernel/locking/rwsem.c:1369 __up_write kernel/locking/rwsem.c:1369 [inline]
WARNING: CPU: 1 PID: 8339 at kernel/locking/rwsem.c:1369 up_write+0x469/0x520 kernel/locking/rwsem.c:1632
Modules linked in:
CPU: 1 PID: 8339 Comm: syz-executor.2 Not tainted 6.9.0-rc7-syzkaller-00056-g45db3ab70092 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:__up_write kernel/locking/rwsem.c:1369 [inline]
RIP: 0010:up_write+0x469/0x520 kernel/locking/rwsem.c:1632
Code: ea 03 80 3c 02 00 75 53 48 8b 13 4d 89 f1 41 55 4d 89 f8 4c 89 e1 48 c7 c6 40 b7 2c 8b 48 c7 c7 60 b6 2c 8b e8 08 91 e5 ff 90 <0f> 0b 90 90 5a e9 96 fc ff ff 48 89 ef e8 e5 26 7f 00 e9 03 fd ff
RSP: 0018:ffffc90010ac7928 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888077f311f0 RCX: ffffc9000baa6000
RDX: 0000000000040000 RSI: ffffffff81517126 RDI: 0000000000000001
RBP: ffff888077f311f8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000002 R12: ffff888077f311f0
R13: ffffffff8b2cb5a0 R14: ffff8880787ebc00 R15: 0000000000000000
FS:  00007f0eebfff6c0(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020098000 CR3: 0000000021f12000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 inode_unlock include/linux/fs.h:800 [inline]
 ovl_workdir_create+0x33e/0x820 fs/overlayfs/super.c:359
 ovl_make_workdir fs/overlayfs/super.c:656 [inline]
 ovl_get_workdir fs/overlayfs/super.c:814 [inline]
 ovl_fill_super+0xe6b/0x6720 fs/overlayfs/super.c:1382
 vfs_get_super fs/super.c:1268 [inline]
 get_tree_nodev+0xdd/0x190 fs/super.c:1287
 vfs_get_tree+0x92/0x380 fs/super.c:1779
 do_new_mount fs/namespace.c:3352 [inline]
 path_mount+0x14e6/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __x64_sys_mount+0x297/0x320 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x260 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0eec47dd69
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0eebfff0c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f0eec5ac050 RCX: 00007f0eec47dd69
RDX: 0000000020000080 RSI: 00000000200000c0 RDI: 0000000000000000
RBP: 00007f0eec4ca49e R08: 0000000020000200 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000006e R14: 00007f0eec5ac050 R15: 00007ffe9e328388
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
