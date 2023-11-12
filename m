Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E8CC4332F
	for <linux-unionfs@archiver.kernel.org>; Sun, 12 Nov 2023 04:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjKLESa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 11 Nov 2023 23:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjKLES3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 11 Nov 2023 23:18:29 -0500
Received: from mail-pf1-f207.google.com (mail-pf1-f207.google.com [209.85.210.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B30230F7
        for <linux-unionfs@vger.kernel.org>; Sat, 11 Nov 2023 20:18:25 -0800 (PST)
Received: by mail-pf1-f207.google.com with SMTP id d2e1a72fcca58-6c4f8a2dcbdso1282553b3a.3
        for <linux-unionfs@vger.kernel.org>; Sat, 11 Nov 2023 20:18:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699762705; x=1700367505;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qWEoTwBlXjGTTrl0xPgTiw5vgCy7bqROUuWjF1tWseI=;
        b=H+YLQW50pnYF15qkh9QvXfNTretTo7PLqk4CQA2ZzJxYouRP8t7+3AAy2BlAO8/jLd
         gSiF2JDcHzZQzS5u9wICxhqCPA14kuBTTpjX+uyvdz8ODjO4cchGVKVjwAJtbal/UgGI
         1nkJRX07mnCcxFA2eJABE3rKXXxRu3ATVUXLw2Y1ERVVmCGPZfM9b5/P7lZvN4Woblr6
         mUprMwSeYcyRnbAd8mrA62Z1SVEj4o6qqg3J9NiQaK8LnD83HSH5YjonZ8DCDLAFYfSw
         xUy22o7cryHJIX6jcP82KrACNKOivkJMHevQ6DZfdTDgBN8zspHuTYVV1ZgwaOz90oXp
         cDdA==
X-Gm-Message-State: AOJu0Yx7Tk5oz1sDIBvFCudcppoBcKc1+BHcnShJUanInc6t4Tej8IQG
        YR2P4HymwDR0KlPh9GDIwmdDDW6N/99zuNUAjf77ZJDxaylH
X-Google-Smtp-Source: AGHT+IHZ5YatetUTXqQsCd+tFcdXeuEetfUkqDqzA7IEbmiUgUyTV1jGMi+vSA4VND+qs4KiCqLnYHoIb85f+QrAzPtMoM9IiM0R
MIME-Version: 1.0
X-Received: by 2002:a05:6a00:1884:b0:6c6:b762:ad8a with SMTP id
 x4-20020a056a00188400b006c6b762ad8amr574179pfh.0.1699762705017; Sat, 11 Nov
 2023 20:18:25 -0800 (PST)
Date:   Sat, 11 Nov 2023 20:18:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003c31650609ecd824@google.com>
Subject: [syzbot] [overlayfs?] memory leak in ovl_parse_param
From:   syzbot <syzbot+26eedf3631650972f17c@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    13d88ac54ddd Merge tag 'vfs-6.7.fsid' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=121cf047680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ecfdf78a410c834
dashboard link: https://syzkaller.appspot.com/bug?extid=26eedf3631650972f17c
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c7a6eb680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f8b787680000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9bb27a01f17c/disk-13d88ac5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fb496feed171/vmlinux-13d88ac5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f4da22719ffa/bzImage-13d88ac5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+26eedf3631650972f17c@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff8881009b40a8 (size 8):
  comm "syz-executor225", pid 5035, jiffies 4294944336 (age 13.730s)
  hex dump (first 8 bytes):
    2e 00 00 00 00 00 00 00                          ........
  backtrace:
    [<ffffffff8163331d>] kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
    [<ffffffff8163331d>] slab_post_alloc_hook mm/slab.h:766 [inline]
    [<ffffffff8163331d>] slab_alloc_node mm/slub.c:3478 [inline]
    [<ffffffff8163331d>] __kmem_cache_alloc_node+0x2dd/0x3f0 mm/slub.c:3517
    [<ffffffff8157e57c>] __do_kmalloc_node mm/slab_common.c:1006 [inline]
    [<ffffffff8157e57c>] __kmalloc_node_track_caller+0x4c/0x150 mm/slab_common.c:1027
    [<ffffffff8156da4c>] kstrdup+0x3c/0x70 mm/util.c:62
    [<ffffffff81d0438a>] ovl_parse_param_lowerdir fs/overlayfs/params.c:496 [inline]
    [<ffffffff81d0438a>] ovl_parse_param+0x70a/0xc70 fs/overlayfs/params.c:576
    [<ffffffff8170542b>] vfs_parse_fs_param+0xfb/0x190 fs/fs_context.c:146
    [<ffffffff81705556>] vfs_parse_fs_string+0x96/0xd0 fs/fs_context.c:188
    [<ffffffff8170566f>] vfs_parse_monolithic_sep+0xdf/0x130 fs/fs_context.c:230
    [<ffffffff816dff08>] do_new_mount fs/namespace.c:3333 [inline]
    [<ffffffff816dff08>] path_mount+0xc48/0x10d0 fs/namespace.c:3664
    [<ffffffff816e0b41>] do_mount fs/namespace.c:3677 [inline]
    [<ffffffff816e0b41>] __do_sys_mount fs/namespace.c:3886 [inline]
    [<ffffffff816e0b41>] __se_sys_mount fs/namespace.c:3863 [inline]
    [<ffffffff816e0b41>] __x64_sys_mount+0x1a1/0x1f0 fs/namespace.c:3863
    [<ffffffff84b67d8f>] do_syscall_x64 arch/x86/entry/common.c:51 [inline]
    [<ffffffff84b67d8f>] do_syscall_64+0x3f/0x110 arch/x86/entry/common.c:82
    [<ffffffff84c0008b>] entry_SYSCALL_64_after_hwframe+0x63/0x6b

BUG: memory leak
unreferenced object 0xffff88814002d070 (size 8):
  comm "syz-executor225", pid 5036, jiffies 4294944900 (age 8.090s)
  hex dump (first 8 bytes):
    2e 00 00 00 00 00 00 00                          ........
  backtrace:
    [<ffffffff8163331d>] kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
    [<ffffffff8163331d>] slab_post_alloc_hook mm/slab.h:766 [inline]
    [<ffffffff8163331d>] slab_alloc_node mm/slub.c:3478 [inline]
    [<ffffffff8163331d>] __kmem_cache_alloc_node+0x2dd/0x3f0 mm/slub.c:3517
    [<ffffffff8157e57c>] __do_kmalloc_node mm/slab_common.c:1006 [inline]
    [<ffffffff8157e57c>] __kmalloc_node_track_caller+0x4c/0x150 mm/slab_common.c:1027
    [<ffffffff8156da4c>] kstrdup+0x3c/0x70 mm/util.c:62
    [<ffffffff81d0438a>] ovl_parse_param_lowerdir fs/overlayfs/params.c:496 [inline]
    [<ffffffff81d0438a>] ovl_parse_param+0x70a/0xc70 fs/overlayfs/params.c:576
    [<ffffffff8170542b>] vfs_parse_fs_param+0xfb/0x190 fs/fs_context.c:146
    [<ffffffff81705556>] vfs_parse_fs_string+0x96/0xd0 fs/fs_context.c:188
    [<ffffffff8170566f>] vfs_parse_monolithic_sep+0xdf/0x130 fs/fs_context.c:230
    [<ffffffff816dff08>] do_new_mount fs/namespace.c:3333 [inline]
    [<ffffffff816dff08>] path_mount+0xc48/0x10d0 fs/namespace.c:3664
    [<ffffffff816e0b41>] do_mount fs/namespace.c:3677 [inline]
    [<ffffffff816e0b41>] __do_sys_mount fs/namespace.c:3886 [inline]
    [<ffffffff816e0b41>] __se_sys_mount fs/namespace.c:3863 [inline]
    [<ffffffff816e0b41>] __x64_sys_mount+0x1a1/0x1f0 fs/namespace.c:3863
    [<ffffffff84b67d8f>] do_syscall_x64 arch/x86/entry/common.c:51 [inline]
    [<ffffffff84b67d8f>] do_syscall_64+0x3f/0x110 arch/x86/entry/common.c:82
    [<ffffffff84c0008b>] entry_SYSCALL_64_after_hwframe+0x63/0x6b



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
