Return-Path: <SRS0=TJLE=IF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_DIGITS,
	FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DD6C433E0
	for <linux-unionfs@archiver.kernel.org>; Sun,  7 Mar 2021 07:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D259F65115
	for <linux-unionfs@archiver.kernel.org>; Sun,  7 Mar 2021 07:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbhCGHrs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 02:47:48 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:37515 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhCGHrS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 7 Mar 2021 02:47:18 -0500
Received: by mail-io1-f72.google.com with SMTP id a18so5290522ioo.4
        for <linux-unionfs@vger.kernel.org>; Sat, 06 Mar 2021 23:47:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=D6UHTmpY2QGLphjd+CxgWKu56YFBraD/vukY3pRjpfo=;
        b=EGo3fFjCW/eSyJTWbrm7YpuIGToW2Gm7lIc/IrXtOX5ipMLFgtjbliqewlaEgQf1rN
         d3z5zYtpXRndAeZ5p5BKGafRH1zTmuWQ4DCpB1e4LpEkO82r74HnQdo8BNk6j8Bkvn0l
         rBpcRhgnTLuUzD5nzWKtR9Rn4OSgmLYBp7raFELvffUHx3jsOb4kcjjCuMC4WJx5xFcm
         ZcVSI7SpV0u9Wt+wPhSYztO9yI/J1G0RNOFcS+x8BF92SzhVSz36DsDojcVbm2uJGyVz
         V7PXiKznRkN8RWAe31O7Rolb39dZxMfjaH2l2fd45ehwSJxbdQfy2zYGVNVgF2G0OG5C
         a/LQ==
X-Gm-Message-State: AOAM5301vzVduTAoaxGq2v0WYUqACxRIteN89kH9efrZ+EUDwjx0RK1m
        kXtU38aGS9gYHTXT9X5gfq2IizYbOl5DawoCNAb8GsY/trCS
X-Google-Smtp-Source: ABdhPJyW7FC7KLp50q+a9R1vz7kt9eBNFYREyAE3yNL7iLjUxmnaQWmWyBKxHkbBpuEU009/Y2MMd9Bb7LcXl/6F2/r6zfgdTL5U
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12a1:: with SMTP id f1mr15193080ilr.124.1615103237925;
 Sat, 06 Mar 2021 23:47:17 -0800 (PST)
Date:   Sat, 06 Mar 2021 23:47:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c5b20005bced862d@google.com>
Subject: [syzbot] KASAN: use-after-free Read in ovl_real_fdget_meta
From:   syzbot <syzbot+d8f10499005854b34b80@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    92f791eb Add linux-next specific files for 20210302
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12696076d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=55e0d976097c2fbd
dashboard link: https://syzkaller.appspot.com/bug?extid=d8f10499005854b34b80

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d8f10499005854b34b80@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in file_inode include/linux/fs.h:1301 [inline]
BUG: KASAN: use-after-free in ovl_real_fdget_meta+0x482/0x500 fs/overlayfs/file.c:118
Read of size 8 at addr ffff88801854d420 by task syz-executor.2/18364

CPU: 0 PID: 18364 Comm: syz-executor.2 Not tainted 5.12.0-rc1-next-20210302-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 file_inode include/linux/fs.h:1301 [inline]
 ovl_real_fdget_meta+0x482/0x500 fs/overlayfs/file.c:118
 ovl_real_fdget+0xad/0x260 fs/overlayfs/file.c:141
 ovl_flush+0x72/0x230 fs/overlayfs/file.c:695
 filp_close+0xb4/0x170 fs/open.c:1295
 close_fd+0x5c/0x80 fs/file.c:628
 __do_sys_close fs/open.c:1314 [inline]
 __se_sys_close fs/open.c:1312 [inline]
 __x64_sys_close+0x2f/0xa0 fs/open.c:1312
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x41920b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007fffbf66ec90 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000000041920b
RDX: 0000000000570448 RSI: ffffffff8906c86e RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000001b2c13ba84
R10: 00007fffbf66ed80 R11: 0000000000000293 R12: 000000000005a429
R13: 00000000000003e8 R14: 000000000056bf60 R15: 000000000005a36d

Allocated by task 18368:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 __kasan_slab_alloc+0x75/0x90 mm/kasan/common.c:460
 kasan_slab_alloc include/linux/kasan.h:223 [inline]
 slab_post_alloc_hook mm/slab.h:516 [inline]
 slab_alloc_node mm/slub.c:2907 [inline]
 slab_alloc mm/slub.c:2915 [inline]
 kmem_cache_alloc+0x15e/0x380 mm/slub.c:2920
 kmem_cache_zalloc include/linux/slab.h:674 [inline]
 __alloc_file+0x21/0x280 fs/file_table.c:101
 alloc_empty_file_noaccount+0x19/0x90 fs/file_table.c:172
 open_with_fake_path+0x27/0xe0 fs/open.c:969
 ovl_open_realfile+0x270/0x2f0 fs/overlayfs/file.c:60
 ovl_open fs/overlayfs/file.c:156 [inline]
 ovl_open+0x125/0x270 fs/overlayfs/file.c:144
 do_dentry_open+0x4b9/0x11b0 fs/open.c:826
 do_open fs/namei.c:3365 [inline]
 path_openat+0x1c0e/0x27e0 fs/namei.c:3498
 do_filp_open+0x17e/0x3c0 fs/namei.c:3525
 do_sys_openat2+0x16d/0x420 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_openat fs/open.c:1219 [inline]
 __se_sys_openat fs/open.c:1214 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1214
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 4854:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x72/0x1b0 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kmem_cache_free+0x8b/0x730 mm/slub.c:3177
 rcu_do_batch kernel/rcu/tree.c:2559 [inline]
 rcu_core+0x722/0x1280 kernel/rcu/tree.c:2794
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3039 [inline]
 call_rcu+0xb1/0x700 kernel/rcu/tree.c:3114
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3039 [inline]
 call_rcu+0xb1/0x700 kernel/rcu/tree.c:3114
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801854d400
 which belongs to the cache filp of size 464
The buggy address is located 32 bytes inside of
 464-byte region [ffff88801854d400, ffff88801854d5d0)
The buggy address belongs to the page:
page:000000004db6be2d refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1854c
head:000000004db6be2d order:1 compound_mapcount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 ffffea0000bff380 0000000600000006 ffff888140005500
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801854d300: fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc
 ffff88801854d380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801854d400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff88801854d480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801854d500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
