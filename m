Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55DCFC433B4
	for <linux-unionfs@archiver.kernel.org>; Sat,  3 Apr 2021 19:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18D5B61242
	for <linux-unionfs@archiver.kernel.org>; Sat,  3 Apr 2021 19:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbhDCTS0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 3 Apr 2021 15:18:26 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48104 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhDCTSZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 3 Apr 2021 15:18:25 -0400
Received: by mail-il1-f197.google.com with SMTP id h21so7565510ila.14
        for <linux-unionfs@vger.kernel.org>; Sat, 03 Apr 2021 12:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=pBpQH6Uo9KRda80ccxd7QvvIiYNrWX49X9IvsMF/eo4=;
        b=VK3abL2DoXCQc4qvU4XPCyZAGFpD7eiOdcBF+f247XaHNe9odfkkmCIYpDwHfskPp8
         vCyP66nsd9800BpNxKfgxDinC8LVhB8fRgVqq5z9zL1X57/HbWPHmLGkRZkwtRF8i+1w
         qZbAsSfyckjyKQqt/WVgOKrP7ogv/d01W+g9K+9TrvFkbCNJD6Ef9TR6w4xuG75Pas25
         d9lCzv4iqdW0zy5TPDjttb6Hk2h2tMHYHZKxCkZf1+Gy4puYwaiT6T983eA2j56X8fQz
         RAmsGPzKpORqmN+lgfaIoH2e8kGGcyH8X5Es4J9u5v6H/KyYwO2da9RL4fNtwuzO2oJc
         6p3Q==
X-Gm-Message-State: AOAM533VqeJfOiGcXwDeoW98jWFHlZDuHwprxxyn6WHfQlR/eS85Qf4F
        4ocNGUbB/+7y5zIeSNvAZEmsjmAmG8jKh9OiV8xv5OerNQ6L
X-Google-Smtp-Source: ABdhPJzXeNMuCwLndOf+4RPQAqO75l52hEE1x2sFduQcjb+rnn/GHabsRTcnPhPqkfgKU1rYMHsMAaMqMMes+43+kDHYrB/RcIiy
MIME-Version: 1.0
X-Received: by 2002:a5d:9285:: with SMTP id s5mr15073777iom.139.1617477500879;
 Sat, 03 Apr 2021 12:18:20 -0700 (PDT)
Date:   Sat, 03 Apr 2021 12:18:20 -0700
In-Reply-To: <000000000000c5b77105b4c3546e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df47be05bf165394@google.com>
Subject: Re: [syzbot] possible deadlock in ovl_maybe_copy_up
From:   syzbot <syzbot+c18f2f6a7b08c51e3025@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    454c576c Add linux-next specific files for 20210401
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1616e07ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=920cc274cae812a5
dashboard link: https://syzkaller.appspot.com/bug?extid=c18f2f6a7b08c51e3025
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13da365ed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ca9d16d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c18f2f6a7b08c51e3025@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.12.0-rc5-next-20210401-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor144/9166 is trying to acquire lock:
ffff888144cf0460 (sb_writers#5){.+.+}-{0:0}, at: ovl_maybe_copy_up+0x11f/0x190 fs/overlayfs/copy_up.c:995

but task is already holding lock:
ffff8880256d42c0 (&iint->mutex){+.+.}-{3:3}, at: process_measurement+0x3a8/0x17e0 security/integrity/ima/ima_main.c:253

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&iint->mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:949 [inline]
       __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
       process_measurement+0x3a8/0x17e0 security/integrity/ima/ima_main.c:253
       ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:499
       do_open fs/namei.c:3361 [inline]
       path_openat+0x15b5/0x27e0 fs/namei.c:3492
       do_filp_open+0x17e/0x3c0 fs/namei.c:3519
       do_sys_openat2+0x16d/0x420 fs/open.c:1187
       do_sys_open fs/open.c:1203 [inline]
       __do_sys_open fs/open.c:1211 [inline]
       __se_sys_open fs/open.c:1207 [inline]
       __x64_sys_open+0x119/0x1c0 fs/open.c:1207
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (sb_writers#5){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:2938 [inline]
       check_prevs_add kernel/locking/lockdep.c:3061 [inline]
       validate_chain kernel/locking/lockdep.c:3676 [inline]
       __lock_acquire+0x2a17/0x5230 kernel/locking/lockdep.c:4902
       lock_acquire kernel/locking/lockdep.c:5512 [inline]
       lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1758 [inline]
       sb_start_write include/linux/fs.h:1828 [inline]
       mnt_want_write+0x6e/0x3e0 fs/namespace.c:375
       ovl_maybe_copy_up+0x11f/0x190 fs/overlayfs/copy_up.c:995
       ovl_open+0xba/0x270 fs/overlayfs/file.c:149
       do_dentry_open+0x4b9/0x11b0 fs/open.c:826
       vfs_open fs/open.c:940 [inline]
       dentry_open+0x132/0x1d0 fs/open.c:956
       ima_calc_file_hash+0x2d2/0x4b0 security/integrity/ima/ima_crypto.c:557
       ima_collect_measurement+0x4ca/0x570 security/integrity/ima/ima_api.c:252
       process_measurement+0xd1c/0x17e0 security/integrity/ima/ima_main.c:330
       ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:499
       do_open fs/namei.c:3361 [inline]
       path_openat+0x15b5/0x27e0 fs/namei.c:3492
       do_filp_open+0x17e/0x3c0 fs/namei.c:3519
       do_sys_openat2+0x16d/0x420 fs/open.c:1187
       do_sys_open fs/open.c:1203 [inline]
       __do_sys_open fs/open.c:1211 [inline]
       __se_sys_open fs/open.c:1207 [inline]
       __x64_sys_open+0x119/0x1c0 fs/open.c:1207
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&iint->mutex);
                               lock(sb_writers#5);
                               lock(&iint->mutex);
  lock(sb_writers#5);

 *** DEADLOCK ***

1 lock held by syz-executor144/9166:
 #0: ffff8880256d42c0 (&iint->mutex){+.+.}-{3:3}, at: process_measurement+0x3a8/0x17e0 security/integrity/ima/ima_main.c:253

stack backtrace:
CPU: 1 PID: 9166 Comm: syz-executor144 Not tainted 5.12.0-rc5-next-20210401-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2129
 check_prev_add kernel/locking/lockdep.c:2938 [inline]
 check_prevs_add kernel/locking/lockdep.c:3061 [inline]
 validate_chain kernel/locking/lockdep.c:3676 [inline]
 __lock_acquire+0x2a17/0x5230 kernel/locking/lockdep.c:4902
 lock_acquire kernel/locking/lockdep.c:5512 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write include/linux/fs.h:1758 [inline]
 sb_start_write include/linux/fs.h:1828 [inline]
 mnt_want_write+0x6e/0x3e0 fs/namespace.c:375
 ovl_maybe_copy_up+0x11f/0x190 fs/overlayfs/copy_up.c:995
 ovl_open+0xba/0x270 fs/overlayfs/file.c:149
 do_dentry_open+0x4b9/0x11b0 fs/open.c:826
 vfs_open fs/open.c:940 [inline]
 dentry_open+0x132/0x1d0 fs/open.c:956
 ima_calc_file_hash+0x2d2/0x4b0 security/integrity/ima/ima_crypto.c:557
 ima_collect_measurement+0x4ca/0x570 security/integrity/ima/ima_api.c:252
 process_measurement+0xd1c/0x17e0 security/integrity/ima/ima_main.c:330
 ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:499
 do_open fs/namei.c:3361 [inline]
 path_openat+0x15b5/0x27e0 fs/namei.c:3492
 do_filp_open+0x17e/0x3c0 fs/namei.c:3519
 do_sys_openat2+0x16d/0x420 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open fs/open.c:1207 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1207
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x446109
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe4412f12f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00000000004cb4c0 RCX: 0000000000446109
RDX: 0000000000000000 RSI: 0000000000000007 RDI: 00000000200001c0
RBP: 000000000049b06c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 69662f7375622f2e
R13: 79706f636174656d R14: 0079616c7265766f R15: 00000000004cb4c8

