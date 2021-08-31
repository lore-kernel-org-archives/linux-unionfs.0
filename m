Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B48C4320A
	for <linux-unionfs@archiver.kernel.org>; Tue, 31 Aug 2021 10:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A43B601FD
	for <linux-unionfs@archiver.kernel.org>; Tue, 31 Aug 2021 10:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhHaKhe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 06:37:34 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:53175 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241027AbhHaKhS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Aug 2021 06:37:18 -0400
Received: by mail-io1-f69.google.com with SMTP id e18-20020a6b7312000000b005be766a70dbso5379332ioh.19
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Aug 2021 03:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=1QsrxMTQ85qZOPqgnRl/vLMVjUOqzpDzRxErTUbVndE=;
        b=mQJW8jMcAjKBIXlFgKow2yxGSG5xEzo4L1iJ/wg25hkxSyy20MBJArPXjN/St5xyMj
         /Y8HCTUWHMLlG9myfmcQqZsE4qXoqearsm4th7yERFkKvBFeIdANRhIBf0Y27mSJH1xM
         Uz7wPFgFkrkuWcf6uskdg2YLbuaCx/F9FaRdxjOechHzf2qb9lwyO+o9TmJkdOtZnkuk
         9vQNyORsMLAf2eoVfSt4/ke36LhdTE8anP+acX5jMH7RpIH2OcPgIhwyIj3IPA7WVTl6
         d1LVoahXZ67fvcJoTz0EKQvhOOdFjEf/cbRs+lALXPfruMAx3orTSm+Mkgz7SqvQeHuj
         hyHg==
X-Gm-Message-State: AOAM530L1ptV1vcACDCLKHQH/goVvTGnoMj4jWSCZpyUdqtvWUMM8cs7
        OGPZNl7zveTCtOazg45Ci+Q89hduMp0WCN/Y4oU1v6Pk7z5z
X-Google-Smtp-Source: ABdhPJzbikzxCi3j3s/DdEUZZlOmQ8cmpMjUunOwvxjOD+pBSs/2+9AvOwnVXIiSADNLNmIkw0VI0fOQuUEDtKUgcHhNzoHmS8Ua
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160f:: with SMTP id t15mr20626525ilu.60.1630406183867;
 Tue, 31 Aug 2021 03:36:23 -0700 (PDT)
Date:   Tue, 31 Aug 2021 03:36:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006dd93205cad885e5@google.com>
Subject: [syzbot] WARNING in ovl_create_real
From:   syzbot <syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4ccc9e2db7ac Add linux-next specific files for 20210729
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13891f5c300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=75a5bed89b5c0fd2
dashboard link: https://syzkaller.appspot.com/bug?extid=75eab84fd0af9e8bf66b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1085e076300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14247a56300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6576 at fs/overlayfs/dir.c:212 ovl_create_real+0x272/0x520 fs/overlayfs/dir.c:212
Modules linked in:
CPU: 1 PID: 6576 Comm: syz-executor088 Not tainted 5.14.0-rc3-next-20210729-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ovl_create_real+0x272/0x520 fs/overlayfs/dir.c:212
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 80 02 00 00 49 83 7c 24 68 00 0f 85 7a fe ff ff e8 de b6 c3 fe <0f> 0b 4c 89 e5 49 c7 c4 fb ff ff ff e9 57 fe ff ff 66 81 eb 00 10
RSP: 0018:ffffc90002bef958 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000004000 RCX: 0000000000000000
RDX: ffff88807b10b900 RSI: ffffffff82b20102 RDI: ffff88806f971208
RBP: ffff88806f9711a0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff82b2018b R11: 0000000000000000 R12: ffff88806f9711a0
R13: 0000000000004000 R14: ffff8880715c8a20 R15: ffff8880715c8b00
FS:  00007fe7eef6d700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f49bbacf000 CR3: 000000001eea6000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ovl_workdir_create+0x3a9/0x5b0 fs/overlayfs/super.c:790
 ovl_make_workdir fs/overlayfs/super.c:1364 [inline]
 ovl_get_workdir fs/overlayfs/super.c:1511 [inline]
 ovl_fill_super+0x199a/0x5fb0 fs/overlayfs/super.c:2067
 mount_nodev+0x60/0x110 fs/super.c:1414
 legacy_get_tree+0x105/0x220 fs/fs_context.c:610
 vfs_get_tree+0x89/0x2f0 fs/super.c:1498
 do_new_mount fs/namespace.c:2978 [inline]
 path_mount+0x132a/0x1fa0 fs/namespace.c:3308
 do_mount fs/namespace.c:3321 [inline]
 __do_sys_mount fs/namespace.c:3529 [inline]
 __se_sys_mount fs/namespace.c:3506 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3506
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4458d9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe7eef6d2f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00000000004ca400 RCX: 00000000004458d9
RDX: 00000000200000c0 RSI: 0000000020000000 RDI: 000000000040000d
RBP: 000000000049a074 R08: 0000000020000100 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0030656c69662f2e
R13: 0079616c7265766f R14: 003270756f726763 R15: 00000000004ca408


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
