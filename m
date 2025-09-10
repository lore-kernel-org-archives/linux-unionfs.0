Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562B726E158
	for <linux-unionfs@vger.kernel.org>; Wed, 10 Sep 2025 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757526811; cv=none; b=Fk9YFLYMoyr71u+a/B8bjMxuqbkO/kArUwiUl8a3RPryY8rfH8DZWC8XTf7t85sqshjRTZQp8cxw3svX61WKYGenGa9EuZ+BXmfUg54sRgPHX8A+C8ipNtG1uiEG8m9jVQWS/iweRrK1B99qdZM8VXb1ho6Mrjl/BbECz0Ok/qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757526811; c=relaxed/simple;
	bh=g65vmnBrf83PJDIpAFQzfZ0xLySouvkFdaGla1Iow0Y=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cduQRJO7KxmguFdlCp0d0rbVZXn2NxHjh2BghAnVdpRib8PPaTsCRFEsmYFPwSUwVB7DwnDCbAjDj146WJJipODdZmh+mmTCG/KHtD8Ao1Y4kPsyEEQBgKRkNHKIFwMxl9PIgIuYmdBNC1ua/vaTINJWfQA//RSeEC6js9royB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-886e347d26bso112814339f.0
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Sep 2025 10:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757526809; x=1758131609;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fAe78HzvKrmzUWfDTlQOX6TLHogAHGupJtXSD3zOil4=;
        b=ImIDIbF20AEA0hwU41+gy2IPm3NUvefp1QkgJQc/3AGz7mwDPlddfdDYu37gHII0/z
         v2idk0b+KUTj9vqIby9+rXQIbNNfacPdvLihXghrMT3/TB4WxSK2FgzyHAz8F7lxkelp
         mr184HlXsnKMn29WjWW8qHkWdYLYzJHzCcNJdKXa9+oID8peBAvTZWKOW4R2W/SnDn7Z
         W1RO1dUaBNn/DkTKjpom+5oYt30PaaaxORYyV3cDfEvK+jNq52feUSFC1Ul+U/tMDKcE
         kAzwRfJ3BOkCdOB7sDjvqtLzwvmwwuHg9pgo1bmN6+f7XuswHEmnKa6eYDNQvWCxl/W4
         hbkA==
X-Forwarded-Encrypted: i=1; AJvYcCU7kDHcRz9A8nCdM/oRiC//kmBm/xeQBwIGto9vhKz6zbNqWQX/JDL5YuPXaUDa0Qz09tV7bbNrgwhH0Ceo@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb16AtV58C8wXf0JAYhY7HYVd/QrsaH93qeuMcGkRu9rGobHdK
	dCTeoyLmfJEujDwA3pI3yqsOCGKek3Q2n0OkMxVpo1tFpuPKC4KLRgFoVCH7S6rcqs7Y2pYXEFi
	by0RaMWbuUY8+JjmILp9TTgKd7BA4nM5bUSMnQYxgAmuVmjR9Qc7Lm/FsyUk=
X-Google-Smtp-Source: AGHT+IG0q7VHKO3FPxRQyRcND8f+cOEPjTXAcOqrvlE/B3jzOTdvqug6xnHm+OmQX8YjWxmBtZ19g1dKmFQ6s3v9xlcjt4QVyJK7
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca0a:0:b0:402:b8e3:c9f7 with SMTP id
 e9e14a558f8ab-41beb04877fmr7394125ab.8.1757526809505; Wed, 10 Sep 2025
 10:53:29 -0700 (PDT)
Date: Wed, 10 Sep 2025 10:53:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c1bb19.050a0220.3c6139.0027.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in ovl_workdir_create (5)
From: syzbot <syzbot+078954d5ad423349aa78@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d1d10cea0895 Merge tag 'perf-tools-fixes-for-v6.17-2025-09..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14fba87c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=429771c55b615e85
dashboard link: https://syzkaller.appspot.com/bug?extid=078954d5ad423349aa78
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fca0faadbf1b/disk-d1d10cea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aa812ff26c41/vmlinux-d1d10cea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0cf89313ffd8/bzImage-d1d10cea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+078954d5ad423349aa78@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(rt_mutex_owner(lock) != current)
WARNING: CPU: 1 PID: 6377 at kernel/locking/rtmutex_common.h:191 debug_rt_mutex_unlock kernel/locking/rtmutex_common.h:191 [inline]
WARNING: CPU: 1 PID: 6377 at kernel/locking/rtmutex_common.h:191 rt_mutex_slowunlock+0x6ce/0x8a0 kernel/locking/rtmutex.c:1419
Modules linked in:
CPU: 1 UID: 0 PID: 6377 Comm: syz.2.75 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:debug_rt_mutex_unlock kernel/locking/rtmutex_common.h:191 [inline]
RIP: 0010:rt_mutex_slowunlock+0x6ce/0x8a0 kernel/locking/rtmutex.c:1419
Code: 0f b6 04 20 84 c0 0f 85 c6 01 00 00 83 3d 0d fc 24 04 00 75 19 90 48 c7 c7 c0 ed 0a 8b 48 c7 c6 00 ee 0a 8b e8 c3 bf 8a f6 90 <0f> 0b 90 90 90 e9 2f fa ff ff 90 0f 0b 90 e9 53 fe ff ff be 02 00
RSP: 0018:ffffc90004dd74a0 EFLAGS: 00010046
RAX: 0f6370d1171cee00 RBX: ffff88805d37f7e0 RCX: 0000000000080000
RDX: ffffc9000eb1b000 RSI: 000000000000170a RDI: 000000000000170b
RBP: ffffc90004dd7590 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed1017124863 R12: dffffc0000000000
R13: ffff88805d37f790 R14: 0000000000000a02 R15: 1ffff920009bae9c
FS:  00007f7c0943d6c0(0000) GS:ffff8881269bf000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe813a53530 CR3: 00000000378d0000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 inode_unlock include/linux/fs.h:879 [inline]
 ovl_workdir_create+0x4da/0x8b0 fs/overlayfs/super.c:331
 ovl_make_workdir fs/overlayfs/super.c:669 [inline]
 ovl_get_workdir+0x32f/0x17c0 fs/overlayfs/super.c:827
 ovl_fill_super+0x1365/0x35b0 fs/overlayfs/super.c:1406
 vfs_get_super fs/super.c:1325 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1344
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7c0b1febe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7c0943d038 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f7c0b436090 RCX: 00007f7c0b1febe9
RDX: 0000200000000440 RSI: 0000200000000100 RDI: 0000000000000000
RBP: 00007f7c0b281e19 R08: 0000200000000200 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7c0b436128 R14: 00007f7c0b436090 R15: 00007fff5ec39608
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
