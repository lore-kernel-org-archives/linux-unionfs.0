Return-Path: <SRS0=o1el=4S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CA5C3F2CD
	for <linux-unionfs@archiver.kernel.org>; Sun,  1 Mar 2020 19:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A5A1246B9
	for <linux-unionfs@archiver.kernel.org>; Sun,  1 Mar 2020 19:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgCATNQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 1 Mar 2020 14:13:16 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:41487 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgCATNQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 1 Mar 2020 14:13:16 -0500
Received: by mail-il1-f200.google.com with SMTP id k9so9081874ili.8
        for <linux-unionfs@vger.kernel.org>; Sun, 01 Mar 2020 11:13:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4/VA9BmvqbsM5rNUMslEh9Krn9FOhK79mHkgoz8CgtQ=;
        b=gBF5pWGeFJ1TlRVdW40PLgUfK85dbkEFGrDeewikKrFgiPSxD04Ifn1pIHXUIYyDZh
         G/75BRbF9kZITe58N4oOu6R7s83G0lpnMg4YV6B1FzbZog20yRjIvRCc+LlqYSfIDSaU
         lrBHsS7tYWg/eNNwbUNHliVr5nXyy/ADZtTkz/LDQgWiLkiGllNDIldfGLNeomYD/CPn
         e7OY8O0j/HuFy1zODoEw/T2qgHk3II8QY329COFm6XOvoQ9CRp/kojxtWv4DXSlhCVuz
         orlaYuuWlifiLG2ia7+biT5mFnKCkkfntpIb4VQYL1ypHhePNkL5xwCWYifcMxc4ZP8o
         plVw==
X-Gm-Message-State: APjAAAXfrit9fSQz3lpjuWLkB7xd0LqxgGn+atFODf4bt3NJPF7lS+OM
        XZWwzN1wgdiL8NfIffXqfqn+c4oldgg5kRfaD+vZdHsLA8uR
X-Google-Smtp-Source: APXvYqzB1BketvTg0rahQq0fxwHpeTUel4QC/DT09Cw7tuGz2C101wjAnqMSYMcXmWgQimMlSVx69hHFmRFRaPCrAKAiDcj5Xflj
MIME-Version: 1.0
X-Received: by 2002:a92:8547:: with SMTP id f68mr13809858ilh.26.1583089995471;
 Sun, 01 Mar 2020 11:13:15 -0800 (PST)
Date:   Sun, 01 Mar 2020 11:13:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3e319059fcfdc98@google.com>
Subject: WARNING: bad unlock balance in ovl_llseek
From:   syzbot <syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        mszeredi@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f8788d86 Linux 5.6-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c5f8f9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
dashboard link: https://syzkaller.appspot.com/bug?extid=66a9752fa927f745385e
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131d9a81e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14117a81e00000

The bug was bisected to:

commit b1f9d3858f724ed45b279b689fb5b400d91352e3
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Sat Dec 21 09:42:29 2019 +0000

    ovl: use ovl_inode_lock in ovl_llseek()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16ff3bede00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15ff3bede00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11ff3bede00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+66a9752fa927f745385e@syzkaller.appspotmail.com
Fixes: b1f9d3858f72 ("ovl: use ovl_inode_lock in ovl_llseek()")

=====================================
WARNING: bad unlock balance detected!
5.6.0-rc3-syzkaller #0 Not tainted
-------------------------------------
syz-executor194/8947 is trying to release lock (&ovl_i_lock_key[depth]) at:
[<ffffffff828b7835>] ovl_inode_unlock fs/overlayfs/overlayfs.h:328 [inline]
[<ffffffff828b7835>] ovl_llseek+0x215/0x2c0 fs/overlayfs/file.c:193
but there are no more locks to release!

other info that might help us debug this:
1 lock held by syz-executor194/8947:
 #0: ffff88809742ade0 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x279/0x310 fs/file.c:821

stack backtrace:
CPU: 0 PID: 8947 Comm: syz-executor194 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 print_unlock_imbalance_bug+0x20b/0x240 kernel/locking/lockdep.c:4007
 __lock_release kernel/locking/lockdep.c:4241 [inline]
 lock_release+0x469/0x710 kernel/locking/lockdep.c:4502
 __mutex_unlock_slowpath+0x80/0x5b0 kernel/locking/mutex.c:1228
 mutex_unlock+0xd/0x10 kernel/locking/mutex.c:740
 ovl_inode_unlock fs/overlayfs/overlayfs.h:328 [inline]
 ovl_llseek+0x215/0x2c0 fs/overlayfs/file.c:193
 vfs_llseek fs/read_write.c:300 [inline]
 ksys_lseek fs/read_write.c:313 [inline]
 __do_sys_lseek fs/read_write.c:324 [inline]
 __se_sys_lseek fs/read_write.c:322 [inline]
 __x64_sys_lseek+0x15f/0x1f0 fs/read_write.c:322
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x445df9
Code: e8 ac b8 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b 12 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff735aecce8 EFLAGS: 00000246 ORIG_RAX: 0000000000000008
RAX: ffffffffffffffda RBX: 00000000006dac38 RCX: 0000000000445df


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
