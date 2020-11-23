Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F90C63777
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Nov 2020 10:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FBAF20888
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Nov 2020 10:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgKWKFT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 05:05:19 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:47537 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgKWKFS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Nov 2020 05:05:18 -0500
Received: by mail-il1-f199.google.com with SMTP id u16so13320785ilq.14
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Nov 2020 02:05:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9rX7UbfQr7P3nKEs3rfronzjV+PkIsz7V6NWjhe7k9Q=;
        b=dQ2HkC4Q5NNIRFTTkjjAHa2YNIl33RHl9fM39mVf0C7xBETXGuvArSDjUu2XT/FCC9
         fi0s20FvH3xp8AiXcwKxBc1SooDEyittWj4UAI/ofNhMJGN4CKYtU55BHxrVz3F62Bwe
         gS3IYvcS25yNfaU21q7QYCM46KepG5+9eRHQUZ5a0wTkHp9R708ZNrCUjv7S48Lf9E2N
         9z+0XwukVqvKpy2x4RvcULyIK8PIKfhp4YMuzSKhVB4OzRKiUmirlKRfiNxPqw48oNhF
         pd7zEDTtCFvNhdE6RGyZ3dbwVBA2ELrVpLZxObmIxABc2Yb2u0p2T0I/TPO7S3HuL4rM
         9qGQ==
X-Gm-Message-State: AOAM5303hNXI/pzBtiC32Iq/mKnJDd9mn+APFelI3nIBFPO4o6BJbJuv
        TRYXl1Lrrj7cjUi2lU/24pWkrrhQz22tX03QxEFMnnb5UhQc
X-Google-Smtp-Source: ABdhPJxUpFXhr38UyfjXLHpQXsUBd75VpK/B3nuzYpYFtV7M9D2B4a5+CLsWdt1kppdrInzpq6WIqCAIDD/J5aHas1DhPOhhmJV4
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:ea1:: with SMTP id u1mr17700208ilj.246.1606125917417;
 Mon, 23 Nov 2020 02:05:17 -0800 (PST)
Date:   Mon, 23 Nov 2020 02:05:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c5b77105b4c3546e@google.com>
Subject: possible deadlock in ovl_maybe_copy_up
From:   syzbot <syzbot+c18f2f6a7b08c51e3025@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a349e4c6 Merge tag 'xfs-5.10-fixes-7' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11813299500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a521022462477aea
dashboard link: https://syzkaller.appspot.com/bug?extid=c18f2f6a7b08c51e3025
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c18f2f6a7b08c51e3025@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.10.0-rc4-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.4/12280 is trying to acquire lock:
ffff8881480c8460 (sb_writers#4){.+.+}-{0:0}, at: ovl_maybe_copy_up+0x11f/0x190 fs/overlayfs/copy_up.c:990

but task is already holding lock:
ffff888011c1a740 (&iint->mutex){+.+.}-{3:3}, at: process_measurement+0x363/0x1760 security/integrity/ima/ima_main.c:253

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&iint->mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:956 [inline]
       __mutex_lock+0x134/0x10e0 kernel/locking/mutex.c:1103
       process_measurement+0x363/0x1760 security/integrity/ima/ima_main.c:253
       ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:498
       do_open fs/namei.c:3254 [inline]
       path_openat+0x154d/0x2730 fs/namei.c:3369
       do_filp_open+0x17e/0x3c0 fs/namei.c:3396
       do_sys_openat2+0x16d/0x420 fs/open.c:1168
       do_sys_open fs/open.c:1184 [inline]
       __do_sys_openat fs/open.c:1200 [inline]
       __se_sys_openat fs/open.c:1195 [inline]
       __x64_sys_openat+0x13f/0x1f0 fs/open.c:1195
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> #0 (sb_writers#4){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:2866 [inline]
       check_prevs_add kernel/locking/lockdep.c:2991 [inline]
       validate_chain kernel/locking/lockdep.c:3606 [inline]
       __lock_acquire+0x2ca6/0x5c00 kernel/locking/lockdep.c:4830
       lock_acquire kernel/locking/lockdep.c:5435 [inline]
       lock_acquire+0x2a3/0x8c0 kernel/locking/lockdep.c:5400
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1594 [inline]
       sb_start_write include/linux/fs.h:1664 [inline]
       mnt_want_write+0x69/0x3d0 fs/namespace.c:354
       ovl_maybe_copy_up+0x11f/0x190 fs/overlayfs/copy_up.c:990
       ovl_open+0xba/0x270 fs/overlayfs/file.c:154
       do_dentry_open+0x4b9/0x11b0 fs/open.c:817
       vfs_open fs/open.c:931 [inline]
       dentry_open+0x132/0x1d0 fs/open.c:947
       ima_calc_file_hash+0x32b/0x5a0 security/integrity/ima/ima_crypto.c:557
       ima_collect_measurement+0x4ca/0x570 security/integrity/ima/ima_api.c:250
       process_measurement+0xca6/0x1760 security/integrity/ima/ima_main.c:330
       ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:498
       do_open fs/namei.c:3254 [inline]
       path_openat+0x154d/0x2730 fs/namei.c:3369
       do_filp_open+0x17e/0x3c0 fs/namei.c:3396
       do_sys_openat2+0x16d/0x420 fs/open.c:1168
       do_sys_open fs/open.c:1184 [inline]
       __do_sys_open fs/open.c:1192 [inline]
       __se_sys_open fs/open.c:1188 [inline]
       __x64_sys_open+0x119/0x1c0 fs/open.c:1188
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&iint->mutex);
                               lock(sb_writers#4);
                               lock(&iint->mutex);
  lock(sb_writers#4);

 *** DEADLOCK ***

1 lock held by syz-executor.4/12280:
 #0: ffff888011c1a740 (&iint->mutex){+.+.}-{3:3}, at: process_measurement+0x363/0x1760 security/integrity/ima/ima_main.c:253

stack backtrace:
CPU: 0 PID: 12280 Comm: syz-executor.4 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2115
 check_prev_add kernel/locking/lockdep.c:2866 [inline]
 check_prevs_add kernel/locking/lockdep.c:2991 [inline]
 validate_chain kernel/locking/lockdep.c:3606 [inline]
 __lock_acquire+0x2ca6/0x5c00 kernel/locking/lockdep.c:4830
 lock_acquire kernel/locking/lockdep.c:5435 [inline]
 lock_acquire+0x2a3/0x8c0 kernel/locking/lockdep.c:5400
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1594 [inline]
 sb_start_write include/linux/fs.h:1664 [inline]
 mnt_want_write+0x69/0x3d0 fs/namespace.c:354
 ovl_maybe_copy_up+0x11f/0x190 fs/overlayfs/copy_up.c:990
 ovl_open+0xba/0x270 fs/overlayfs/file.c:154
 do_dentry_open+0x4b9/0x11b0 fs/open.c:817
 vfs_open fs/open.c:931 [inline]
 dentry_open+0x132/0x1d0 fs/open.c:947
 ima_calc_file_hash+0x32b/0x5a0 security/integrity/ima/ima_crypto.c:557
 ima_collect_measurement+0x4ca/0x570 security/integrity/ima/ima_api.c:250
 process_measurement+0xca6/0x1760 security/integrity/ima/ima_main.c:330
 ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:498
 do_open fs/namei.c:3254 [inline]
 path_openat+0x154d/0x2730 fs/namei.c:3369
 do_filp_open+0x17e/0x3c0 fs/namei.c:3396
 do_sys_openat2+0x16d/0x420 fs/open.c:1168
 do_sys_open fs/open.c:1184 [inline]
 __do_sys_open fs/open.c:1192 [inline]
 __se_sys_open fs/open.c:1188 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1188
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fccb9104c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00000000000221c0 RCX: 000000000045deb9
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000020000040
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffc3967e2bf R14: 00007fccb91059c0 R15: 000000000118bf2c
overlayfs: upperdir is in-use as upperdir/workdir of another mount, mount with '-o index=off' to override exclusive upperdir protection.


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
