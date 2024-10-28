Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2264E1DF728
	for <linux-unionfs@vger.kernel.org>; Mon, 28 Oct 2024 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730139151; cv=none; b=aTuBOQVjNhbioa+DRKmq/i8Z1w6sD+AzDGKKp5oWzsGbtDVtbpWd1cByZ+jLgivBI72zderCPQDWOYaTOA5Btdi80asKBT5o0Z8VGRJH2CGWxL+ADHPLbpgGd8SENs0VxG3yEHe88uD+VkDjqqPs0IoDlLUufAXp8qulRbdQT/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730139151; c=relaxed/simple;
	bh=q6FpP2QA5N4r3dgwc3meUU6xGy7EzmpuvymXwJ1K8RM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ojv2vpsPHfo6UkNDdHKeLRbnzGhrVPBLkrQBHVaFQJYycS9CDOmeVHF2X/dP0As60pVV73KyjYeyo3xoiHHI8DRzmF3E537pOIJL/T1+1P0gJM8QiLKiQDeiioXN7av3MEAFiaO0uChyggQ7bIANCCeSM0FvkgmKz6TB7KYg9Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3cb771556so40389435ab.3
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Oct 2024 11:12:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730139148; x=1730743948;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=St+fKTQI1ljguXNK5rR1GNwGlKeuluur0G4UkXay8fI=;
        b=MBhqAVwMAAmbqDySrrMHykrPpomUm/tsRA6T4l8LVy/vIv3vc0uebafCTeQ3eDXQIS
         zkqOX1/9R3Is3sEg/HXBTo6odewRNm2UrhC85/RTk/gBBvWA+BHpbsg2uwSicOnBiUWB
         +Muj9z9U8EfRSw+xgr8/ImRn1t+FpOf7KQ0wiJuBIuwvoH65sQWnDYKKQ9CxvanMfpQc
         ywq3dJDZBp/sNV6QU+fQdI28+e7iG5MoSZsNoPzRhVPPc78DQPy/oZzCNwvyEjMhO1D2
         mBv+Ngo5JnxsmT8RtNgc9WgfhlPTKI0ogqpwJ+XEmXowV1qQkiZz7YA5GpXjfgkOsluk
         53gQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvGTuoW81j5DW5GEqiMHarJtMmYO/jsve3iUArV3IzAMgnWXypgAzodiF41xTGxPRCCwI5GKqxfC+yBUkd@vger.kernel.org
X-Gm-Message-State: AOJu0YxPbcaefbPrSEG0+flhA/0X5qn5EJpHHLFm7uuLwGMy6ogr28TC
	ZSuUF6I5ynR/3qPwc4MzDxFx7rl0HU8ls4WXEhF7hMGJzweUXDEeVbj7LwPMY+bTeRiOLoyuPgs
	lDq82vW7ohUDW5Qqzp/cYdm5tFhPN7s2aC+HZRrm2zOYNBAdIRUpJF8U=
X-Google-Smtp-Source: AGHT+IHTno+3mCcY2BMZQ3BatgETWv2efZ1dJCqFsErEnhDuipDHMcmEfutcotiC9PB8+iXsAVq12kDBEW65QDvIDwpeqUzYZrbb
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156b:b0:3a4:ebfa:2ac7 with SMTP id
 e9e14a558f8ab-3a4ed2ef57bmr77193655ab.12.1730139148294; Mon, 28 Oct 2024
 11:12:28 -0700 (PDT)
Date: Mon, 28 Oct 2024 11:12:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671fd40c.050a0220.4735a.024f.GAE@google.com>
Subject: [syzbot] [overlayfs?] WARNING in ovl_encode_real_fh
From: syzbot <syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=178bf640580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=ec07f6f5ce62b858579f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112628a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104bf640580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/bzImage-c2ee9f59.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com

RDX: 0000000000000000 RSI: 0000000020000440 RDI: 00000000ffffff9c
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000003932
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc9b4e42fc
R13: 0000000000000004 R14: 431bde82d7b634db R15: 00007ffc9b4e4330
 </TASK>
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5103 at fs/overlayfs/copy_up.c:448 ovl_encode_real_fh+0x2e2/0x410 fs/overlayfs/copy_up.c:448
Modules linked in:
CPU: 0 UID: 0 PID: 5103 Comm: syz-executor195 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ovl_encode_real_fh+0x2e2/0x410 fs/overlayfs/copy_up.c:448
Code: 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc e8 05 b6 75 fe 90 0f 0b 90 eb 14 e8 fa b5 75 fe 90 0f 0b 90 eb 09 e8 ef b5 75 fe 90 <0f> 0b 90 4c 89 ff e8 b3 6a d3 fe 49 c7 c7 fb ff ff ff eb 8b 89 d1
RSP: 0018:ffffc9000b1f73c0 EFLAGS: 00010293
RAX: ffffffff831f21f1 RBX: 1ffff9200163ee80 RCX: ffff88801fbc2440
RDX: 0000000000000000 RSI: 00000000000000ff RDI: 00000000000000ff
RBP: ffffc9000b1f7470 R08: ffffffff831f208c R09: 1ffffffff2039fdd
R10: dffffc0000000000 R11: fffffbfff2039fde R12: 00000000000000ff
R13: 0000000000000080 R14: 1ffff9200163ee7c R15: ffff888036790300
FS:  0000555590223480(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6fdf3d7709 CR3: 0000000040e6e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ovl_get_origin_fh fs/overlayfs/copy_up.c:484 [inline]
 ovl_do_copy_up fs/overlayfs/copy_up.c:961 [inline]
 ovl_copy_up_one fs/overlayfs/copy_up.c:1203 [inline]
 ovl_copy_up_flags+0x1068/0x46f0 fs/overlayfs/copy_up.c:1258
 ovl_setattr+0x11d/0x5a0 fs/overlayfs/inode.c:40
 notify_change+0xbca/0xe90 fs/attr.c:503
 chown_common+0x501/0x850 fs/open.c:793
 do_fchownat+0x16a/0x240 fs/open.c:824
 __do_sys_fchownat fs/open.c:839 [inline]
 __se_sys_fchownat fs/open.c:836 [inline]
 __x64_sys_fchownat+0xb5/0xd0 fs/open.c:836
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6fdf3812f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 31 1b 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc9b4e42a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000104
RAX: ffffffffffffffda RBX: 00007ffc9b4e42b0 RCX: 00007f6fdf3812f9
RDX: 0000000000000000 RSI: 0000000020000440 RDI: 00000000ffffff9c
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000003932
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc9b4e42fc
R13: 0000000000000004 R14: 431bde82d7b634db R15: 00007ffc9b4e4330
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
