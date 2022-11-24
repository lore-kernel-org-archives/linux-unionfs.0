Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1F7C4332F
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Nov 2022 04:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiKXEvr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 23:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKXEvm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Nov 2022 23:51:42 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B175C051F
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Nov 2022 20:51:41 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id h20-20020a056e021d9400b00300581edaa5so567514ila.12
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Nov 2022 20:51:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZLpWs4bB+dTvlttaOpG/dYbHkM/jQ6IX2jBeOEssUPU=;
        b=CEsUQ3gY/RsLZpOO/gR/3TiSkp3dPlFBmSIH+0YiIeXTQeZpnXhwuk4KT1+mxTILUP
         Ls+5xQKArNqJPjdoYb1J4uXEg5MBJ9Rw5V0VpG29D/8iPfyLMXyCm7/TS74bQD3doSqZ
         ovoMouQo0+Tcbg2inR/cKNPfbzF+0iiTVl9fZoZP6GyJXclkCqC11+FHqsWgmlo4GHc5
         x32TZzE3QJ/8z4Oqsi1t4jtVcq7pk6Qty/dRR62YICzVzRNB70zMxjDOgfWOmN948q0W
         s2E1j62MgYqkqVW+jDOZEj5vz03606NH1GSI/wqmhQPMTB7EOYZKZ7PoIFqq9f1yxD5E
         70uA==
X-Gm-Message-State: ANoB5pnSSzKlRwhXMroan1IF0FApE8cZBg7Rt3yooRS34VsE1Lz0Lt54
        XFObaycPp6l8/484d9dA75O5x06qYI3z2akgsqHPjSGj6+HS
X-Google-Smtp-Source: AA0mqf78DDMzbohbjZ7e5SO9HnMAAGQrTQcirUf5Yi/RRN2MC5MqZ94o1IRO/uqUCs2IyZBpUVwoD3WdM0TItNmT2YbqhcsdlEvF
MIME-Version: 1.0
X-Received: by 2002:a92:2c03:0:b0:302:a769:f7b6 with SMTP id
 t3-20020a922c03000000b00302a769f7b6mr5191746ile.120.1669265500935; Wed, 23
 Nov 2022 20:51:40 -0800 (PST)
Date:   Wed, 23 Nov 2022 20:51:40 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000381c1405ee3029c0@google.com>
Subject: [syzbot] general protection fault in ovl_dentry_upper
From:   syzbot <syzbot+a4055c78774bbf3498bb@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fe24a97cf254 Merge tag 'input-for-v6.1-rc5' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15a02765880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f9416d398342c83
dashboard link: https://syzkaller.appspot.com/bug?extid=a4055c78774bbf3498bb
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a320fd880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e6b6ed880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d4424ef25058/disk-fe24a97c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/61c4ed6a96dd/vmlinux-fe24a97c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d1b8ff061e4e/bzImage-fe24a97c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a4055c78774bbf3498bb@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000092: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000490-0x0000000000000497]
CPU: 0 PID: 16299 Comm: syz-executor309 Not tainted 6.1.0-rc5-syzkaller-00307-gfe24a97cf254 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:ovl_upperdentry_dereference fs/overlayfs/ovl_entry.h:150 [inline]
RIP: 0010:ovl_dentry_upper+0x40/0x60 fs/overlayfs/util.c:213
Code: fe 49 83 c6 68 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 7f 28 e9 fe bb 90 04 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 61 28 e9 fe 48 8b 03 5b 41 5e 41
RSP: 0018:ffffc9000ef3fa50 EFLAGS: 00010202
RAX: 0000000000000092 RBX: 0000000000000490 RCX: ffff888020328000
RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffff888075528758
RBP: dffffc0000000000 R08: ffffffff81f2119e R09: ffffed100eaa50fa
R10: ffffed100eaa50fa R11: 1ffff1100eaa50f9 R12: 0000000000000040
R13: ffffc9000ef3fc20 R14: ffff8880755287c0 R15: dffffc0000000000
FS:  00007f7e44d61700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7e44df1800 CR3: 000000007c404000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ovl_dentry_revalidate_common fs/overlayfs/super.c:146 [inline]
 ovl_dentry_revalidate+0x4b/0x380 fs/overlayfs/super.c:159
 d_revalidate fs/namei.c:856 [inline]
 lookup_fast+0x26c/0x480 fs/namei.c:1634
 walk_component+0x55/0x410 fs/namei.c:1989
 lookup_last fs/namei.c:2450 [inline]
 path_lookupat+0x17d/0x450 fs/namei.c:2474
 filename_lookup+0x274/0x650 fs/namei.c:2503
 user_path_at_empty+0x40/0x1a0 fs/namei.c:2876
 user_path_at include/linux/namei.h:57 [inline]
 __do_sys_name_to_handle_at fs/fhandle.c:107 [inline]
 __se_sys_name_to_handle_at+0xf8/0x610 fs/fhandle.c:93
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f7e44db0159
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7e44d612f8 EFLAGS: 00000246 ORIG_RAX: 000000000000012f
RAX: ffffffffffffffda RBX: 0000000000000034 RCX: 00007f7e44db0159
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00007f7e44e394a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7e44e394a0
R13: 00007f7e44e394ac R14: 00007f7e44e06074 R15: 0030656c69662f2e
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ovl_upperdentry_dereference fs/overlayfs/ovl_entry.h:150 [inline]
RIP: 0010:ovl_dentry_upper+0x40/0x60 fs/overlayfs/util.c:213
Code: fe 49 83 c6 68 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 7f 28 e9 fe bb 90 04 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 61 28 e9 fe 48 8b 03 5b 41 5e 41
RSP: 0018:ffffc9000ef3fa50 EFLAGS: 00010202
RAX: 0000000000000092 RBX: 0000000000000490 RCX: ffff888020328000
RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffff888075528758
RBP: dffffc0000000000 R08: ffffffff81f2119e R09: ffffed100eaa50fa
R10: ffffed100eaa50fa R11: 1ffff1100eaa50f9 R12: 0000000000000040
R13: ffffc9000ef3fc20 R14: ffff8880755287c0 R15: dffffc0000000000
FS:  00007f7e44d61700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564e6292d008 CR3: 000000007c404000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	49 83 c6 68          	add    $0x68,%r14
   4:	4c 89 f0             	mov    %r14,%rax
   7:	48 c1 e8 03          	shr    $0x3,%rax
   b:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
  10:	74 08                	je     0x1a
  12:	4c 89 f7             	mov    %r14,%rdi
  15:	e8 7f 28 e9 fe       	callq  0xfee92899
  1a:	bb 90 04 00 00       	mov    $0x490,%ebx
  1f:	49 03 1e             	add    (%r14),%rbx
  22:	48 89 d8             	mov    %rbx,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	48 89 df             	mov    %rbx,%rdi
  33:	e8 61 28 e9 fe       	callq  0xfee92899
  38:	48 8b 03             	mov    (%rbx),%rax
  3b:	5b                   	pop    %rbx
  3c:	41 5e                	pop    %r14
  3e:	41                   	rex.B


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
