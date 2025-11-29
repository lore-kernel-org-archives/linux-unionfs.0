Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A682139CE
	for <linux-unionfs@vger.kernel.org>; Sat, 29 Nov 2025 13:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764421526; cv=none; b=fBX19v8/+pNO4CxXWeoFfLyUF4VY72qAXpUxzAZX5zDkuXdX9aN/VPwHRHW3lseyuA6IVjlBs1OrFCFsU1jgtTu7sC50fiLECXSW4tM9bow/pUMAOkcuElnDrUbDSn1GxnVKLjWdom88GFMlYKXxV3T2Eb/opqyO1PzhLu1o2GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764421526; c=relaxed/simple;
	bh=5H4v58CFvKdhVBv1n7Kicc3UFongoWfkwaOYHH0HT6E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cYc1CwMJ9i8apBXl+wAJRklC0tTJBWw7sdVmkGM2KSyd4V+mqmuH7hGaQ/I8zzoArts0qcugrIPl1PtixLXKr5he3iMQ/jlXSGPbDrW3CUO0rtkMc8SHhHc+C3DaQIw/o90fg0SDacQYCMkNhGj78Mnje4IyIuGqiKCCoQqZNLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-433795a17c1so21079215ab.2
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Nov 2025 05:05:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764421524; x=1765026324;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p/AjsLSw3aZ/hJvRaRsmMwJng9RMGyhyWJt6uETCibQ=;
        b=MVNOCfqH1F/tx42fNaU1V+2utGFXHyEuvypj6a07TLteeFQoGvypKMpFsuNZrGPXCA
         60SMKAmf+RHDQAjqe1vMrgd0DdN04zZ0DiKW9Nb8vJytIJ7ekiJOVtrpUdNcKXdm7DSi
         Oo8uRcbNhJkgycNHBVuThgJPg0VQMJtRjk13VQ5+lFkNu54SsxW/RBvi4Ocds4MQxppO
         TlKezHEUOOmtrQTU7asUOoo4838GPcSa+yBqZqw3Uf+4CMX9+ikVUPI86GLlNHJHa6K7
         R5ZUBkxTkk3xz49zG+Gn1s5Xf9acZJTrWgv14mAtqHbdhyYl4RV1vi5DOdGBLDXDlcJh
         1xWg==
X-Forwarded-Encrypted: i=1; AJvYcCXZd17IVnOSS2PIzvW0m7E08qyOw86eApsVa67vneIIO7zv4xhQgmB7XYY2mR7wOc2DP5iSyej9owYrnfL+@vger.kernel.org
X-Gm-Message-State: AOJu0YyVNMn0xiv9k3oPDgS5ud5QtkU6y4/G4r1v4l04zhmkyLx0P4pC
	UdEAZiLj1TTIs2engI+O16U9N54+uWTQ0dn040xwhXbJ/tmYrjNpk0dtP25O4KP3kuwFgQlcToh
	StCr4utjQHtK/3aa3kz/6NZ1cJY7SX6rVYACIRtwNaJDXlNot6uNgplItJx4=
X-Google-Smtp-Source: AGHT+IFByml6kwKuEIpQl6nNAhFNnDTZqBEAngdpOCN6AS9dK/ei40xzv92OXTKBzHdMCvzMOH0j9/F/X7Yt5TQXQY+qBCBrF3WX
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2146:b0:433:7a5f:9439 with SMTP id
 e9e14a558f8ab-435b98c6abbmr251866885ab.24.1764421523738; Sat, 29 Nov 2025
 05:05:23 -0800 (PST)
Date: Sat, 29 Nov 2025 05:05:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692aef93.a70a0220.d98e3.015b.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in fast_dput
From: syzbot <syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com>
To: amir73il@gmail.com, brauner@kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7d31f578f323 Add linux-next specific files for 20251128
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14db5f42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6336d8e94a7c517d
dashboard link: https://syzkaller.appspot.com/bug?extid=b74150fd2ef40e716ca2
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1780a112580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f6be92580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6b49d8ad90de/disk-7d31f578.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dbe2d4988ca7/vmlinux-7d31f578.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fc0448ab2411/bzImage-7d31f578.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: fs/dcache.c:829 at fast_dput+0x334/0x430 fs/dcache.c:829, CPU#1: syz.0.17/6053
Modules linked in:
CPU: 1 UID: 0 PID: 6053 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:fast_dput+0x334/0x430 fs/dcache.c:829
Code: e3 81 ff 48 b8 00 00 00 00 00 fc ff df 41 0f b6 44 05 00 84 c0 0f 85 e2 00 00 00 41 80 0e 40 e9 fd fe ff ff e8 4d e3 81 ff 90 <0f> 0b 90 e9 ef fe ff ff 44 89 e6 81 e6 00 00 04 00 31 ff e8 74 e7
RSP: 0018:ffffc90003407cd8 EFLAGS: 00010293
RAX: ffffffff823fcfe3 RBX: ffff88806c44ac78 RCX: ffff88802e41bd00
RDX: 0000000000000000 RSI: 00000000ffffff80 RDI: 0000000000000001
RBP: 00000000ffffff80 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000680f8c R12: dffffc0000000000
R13: 1ffff1100d889597 R14: ffff88806c44abc0 R15: ffff88806c44acb8
FS:  00005555820e4500(0000) GS:ffff888125f4f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31b63fff CR3: 0000000072c78000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 dput+0xe8/0x1a0 fs/dcache.c:924
 __fput+0x68e/0xa70 fs/file_table.c:476
 task_work_run+0x1d4/0x260 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0xff/0x4f0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4966f8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc01c51258 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 000000000001a7a1 RCX: 00007f4966f8f749
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000201c5154f
R10: 0000001b30f20000 R11: 0000000000000246 R12: 00007f49671e5fac
R13: 00007f49671e5fa0 R14: ffffffffffffffff R15: 0000000000000004
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
