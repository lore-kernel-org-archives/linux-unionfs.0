Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC98C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Feb 2021 09:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D19A364EAE
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Feb 2021 09:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhBAJkJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 04:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhBAJkI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Feb 2021 04:40:08 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2515BC06174A;
        Mon,  1 Feb 2021 01:39:28 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id d13so16647952ioy.4;
        Mon, 01 Feb 2021 01:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uuRY1ShUv8lS2pwIJyrYPW0isnLpvtLcR6UKMOqQKRU=;
        b=s6B05Woki1ZcWJknQ/GjOJphSXln4J0tdZjbmjHXetD+kO/ZEBTAV7NzqZphedg9Gq
         c7Lwls/IDr7tW0EbYcGyqNcWAb/RIfza/y8k2MkvFTiTmD8q5qdYlp/Yh+qydBCDgeQa
         kP2OFilaEQKk+4VIO63/ZZXqz9OsPfPA5ENMjy8j3WMDwS1nCcSIsvYIO7DGapNsZDgg
         UpG1WN6HcYsfEpBpkGBoxDIRFcZdTgVJopcYv1y5Vnf/5hH8Zt791lJKAkRZcdkCQEkF
         1Vg/IiOqtUPHaFtmavNH2zQqBLa9+6jwOlqdz+VLwXAmZI6QK5CcanB8bSNRLCoCGtFa
         1CYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uuRY1ShUv8lS2pwIJyrYPW0isnLpvtLcR6UKMOqQKRU=;
        b=sQ3RiINtqvz8w9yr6V5f0ntIqOLUCvFPcDPlTKr+HFugdN6qcGQ4APsBtG9wjraRk7
         oEOPuOP1JI17at1CtCNLJEupjb/DacEUJO+sczXB5tXoX1KyJqzWtvUG3Qg7zAzvpzNX
         OdSii2kDCiQg2onwgHFQwsbXU4Z85x2G3zWKDFgr4l3bM6ULvueuOgDJXvlCZj9Ymqgo
         oO9rFj7KtmkSGsuSysSeTw4/zJH2PiOmB/kmu3K4zwwhHZLXqMvh/j4upTCiBwVWe9XY
         oc47L4wp7Q5vwk1V+/BeVWitRpwVw04UCTircZ2TMF7wIWBGMAb20dvtQuE5EoOzVAKz
         6XEg==
X-Gm-Message-State: AOAM530sWXOYEc6/w5dnbeqQOl8RsvOUunma78oWuoWstW7HA4EsZn6S
        U8HDW3Ez5CQN2QF2e2xHihMDb6wEma9BHyrrL6g=
X-Google-Smtp-Source: ABdhPJz8EbyTA3i011XhHu3KSV0VxSAAGQHUNc2dRNTIXu02lVXWWiU+b7vk9e3+IeRSiMeiVGwOxunTX3+kk8h/gcc=
X-Received: by 2002:a02:3e96:: with SMTP id s144mr13465231jas.81.1612172367516;
 Mon, 01 Feb 2021 01:39:27 -0800 (PST)
MIME-Version: 1.0
References: <000000000000c83a9705ba42d18d@google.com>
In-Reply-To: <000000000000c83a9705ba42d18d@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 1 Feb 2021 11:39:16 +0200
Message-ID: <CAOQ4uxip-rpMT7Mj=BW1H398FpDgDfT+PZasjQym76ueDaUqFg@mail.gmail.com>
Subject: Re: possible deadlock in ovl_dir_real_file
To:     syzbot <syzbot+6a023cb2262c79301432@syzkaller.appspotmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Feb 1, 2021 at 11:21 AM syzbot
<syzbot+6a023cb2262c79301432@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    6642d600 Merge tag '5.11-rc5-smb3' of git://git.samba.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=148aef78d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9408d1770a50819c
> dashboard link: https://syzkaller.appspot.com/bug?extid=6a023cb2262c79301432
> compiler:       clang version 11.0.1
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6a023cb2262c79301432@syzkaller.appspotmail.com
>
> ============================================
> WARNING: possible recursive locking detected
> 5.11.0-rc5-syzkaller #0 Not tainted
> --------------------------------------------
> syz-executor.2/3639 is trying to acquire lock:
> ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: inode_lock include/linux/fs.h:773 [inline]
> ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: ovl_dir_real_file+0x20b/0x310 fs/overlayfs/readdir.c:886
>
> but task is already holding lock:
> ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: inode_lock include/linux/fs.h:773 [inline]
> ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: ovl_ioctl_set_flags fs/overlayfs/file.c:530 [inline]
> ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: ovl_ioctl+0x2fb/0x960 fs/overlayfs/file.c:569
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&ovl_i_mutex_dir_key[depth]);
>   lock(&ovl_i_mutex_dir_key[depth]);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 2 locks held by syz-executor.2/3639:
>  #0: ffff88807a706460 (sb_writers#17){.+.+}-{0:0}, at: mnt_want_write_file+0x5a/0x250 fs/namespace.c:412
>  #1: ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: inode_lock include/linux/fs.h:773 [inline]
>  #1: ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: ovl_ioctl_set_flags fs/overlayfs/file.c:530 [inline]
>  #1: ffff888084c0b5f0 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}, at: ovl_ioctl+0x2fb/0x960 fs/overlayfs/file.c:569
>
> stack backtrace:
> CPU: 1 PID: 3639 Comm: syz-executor.2 Not tainted 5.11.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x137/0x1be lib/dump_stack.c:120
>  __lock_acquire+0x2333/0x5e90 kernel/locking/lockdep.c:4670
>  lock_acquire+0x114/0x5e0 kernel/locking/lockdep.c:5442
>  down_write+0x56/0x120 kernel/locking/rwsem.c:1406
>  inode_lock include/linux/fs.h:773 [inline]
>  ovl_dir_real_file+0x20b/0x310 fs/overlayfs/readdir.c:886
>  ovl_real_fdget fs/overlayfs/file.c:136 [inline]
>  ovl_real_ioctl fs/overlayfs/file.c:499 [inline]
>  ovl_ioctl_set_flags fs/overlayfs/file.c:545 [inline]
>  ovl_ioctl+0x4de/0x960 fs/overlayfs/file.c:569
>  vfs_ioctl fs/ioctl.c:48 [inline]
>  __do_sys_ioctl fs/ioctl.c:753 [inline]
>  __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45e219
> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f02ed677c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e219
> RDX: 0000000000000000 RSI: 0000000040086602 RDI: 0000000000000003
> RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
> R13: 00007ffd373df6ef R14: 00007f02ed6789c0 R15: 000000000119bf8c
>
>

#syz fix: ovl: avoid deadlock on directory ioctl

Should be in linux-next tree already.

Thanks,
Amir.
