Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5D3C3A5A7
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Dec 2022 09:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLHJyN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Dec 2022 04:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiLHJyM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Dec 2022 04:54:12 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73D0654EB
        for <linux-unionfs@vger.kernel.org>; Thu,  8 Dec 2022 01:54:08 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vv4so2630128ejc.2
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Dec 2022 01:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=clTK3lLSYVEtL+4WC/aYf9rm0hyH+5JZyvXmlPjMKR4=;
        b=rIbfx5eSeW6FQi2OmE6qAhILLZV6VghKIBLnlCELsq0rybVX78mEJuRgu/wJahASRz
         S260M1NlNnORt/d6oftGkZc3dmhSG1EK4olxKj9p+CGWwWJILN522BSOuSPCXtjaZ78t
         3GvUmgN3pSjUw6SHvLvu1cHP5MhYFxaQu290A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=clTK3lLSYVEtL+4WC/aYf9rm0hyH+5JZyvXmlPjMKR4=;
        b=Yl+xlhtPEQvdEy6X16R3mlDfXZpTfey1uwOtY3hJzyIpVbyVEKLJch6iEayB39nbNB
         C+2lYyPdFOEAw7rC2A8JJ/OZxQM96LDfNy0hmg8IRR3xJpd8O6DLm/rzIY/SMwTTnxSL
         KSzFCVZn8RXnBXvxh306zFRqfKNqaU8t4UR2FLtoKcj0t0/4nuy/1OUTAVkSZcSSiAQ9
         aMkEqi1vAoyGp8LimF4eltCUsn8W5rQ/vKT6/HcgLcjXT8dk0a1yuHM4IIJ+6sDNtyrK
         H8yUUZthtDn9SB6dMAd2ZwsEgO+YYFxmxHVtICCmDjucIyGCGCzXBwsuaswQyP7e+SRw
         H9ew==
X-Gm-Message-State: ANoB5pn8xUr6uamN4nWmV0J0Tklh++cOT+6ooCSwEL/0ZofGCN3kysNY
        a0L3ABmbR2kJh8v1JwZN1QfN/URiI7tnOsOjmPML7A==
X-Google-Smtp-Source: AA0mqf4spIGJizROgRnG9BczabVBpD8maSU1AxTz8/IYNATxvNVtZx6RcDS/PCn/zW1vUAxgEhmtvwwW8n2PdLyQvv8=
X-Received: by 2002:a17:906:e54:b0:7c1:10b4:4741 with SMTP id
 q20-20020a1709060e5400b007c110b44741mr7255627eji.8.1670493247271; Thu, 08 Dec
 2022 01:54:07 -0800 (PST)
MIME-Version: 1.0
References: <000000000000decafe05ef372b92@google.com> <000000000000b85cdf05ef430758@google.com>
In-Reply-To: <000000000000b85cdf05ef430758@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 8 Dec 2022 10:53:56 +0100
Message-ID: <CAJfpegsMHvpDCSA6CvrH6woKh2MRkDY_ZV1yqLY_30T6EPkDjA@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in ovl_fallocate
To:     syzbot <syzbot+38a94e1872470e3450a6@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Removed offending commit from overlayfs-next (this was a duplicate fix).

Thanks,
Miklos

On Wed, 7 Dec 2022 at 21:47, syzbot
<syzbot+38a94e1872470e3450a6@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    591cd61541b9 Add linux-next specific files for 20221207
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1044bbad880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8b2d3e63e054c24f
> dashboard link: https://syzkaller.appspot.com/bug?extid=38a94e1872470e3450a6
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15236fe3880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178313f3880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/bc862c01ec56/disk-591cd615.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/8f9b93f8ed2f/vmlinux-591cd615.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9d5cb636d548/bzImage-591cd615.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+38a94e1872470e3450a6@syzkaller.appspotmail.com
>
> ============================================
> WARNING: possible recursive locking detected
> 6.1.0-rc8-next-20221207-syzkaller #0 Not tainted
> --------------------------------------------
> syz-executor169/5069 is trying to acquire lock:
> ffff8880750fa480 (&ovl_i_mutex_key[depth]){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:756 [inline]
> ffff8880750fa480 (&ovl_i_mutex_key[depth]){+.+.}-{3:3}, at: ovl_remove_privs_unlocked fs/overlayfs/file.c:519 [inline]
> ffff8880750fa480 (&ovl_i_mutex_key[depth]){+.+.}-{3:3}, at: ovl_fallocate+0x15c/0x270 fs/overlayfs/file.c:546
>
> but task is already holding lock:
> ffff8880750fa480 (&ovl_i_mutex_key[depth]){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:756 [inline]
> ffff8880750fa480 (&ovl_i_mutex_key[depth]){+.+.}-{3:3}, at: ovl_fallocate+0x9f/0x270 fs/overlayfs/file.c:535
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&ovl_i_mutex_key[depth]);
>   lock(&ovl_i_mutex_key[depth]);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 2 locks held by syz-executor169/5069:
>  #0: ffff88802b1d6460 (sb_writers#9){.+.+}-{0:0}, at: ksys_fallocate fs/open.c:346 [inline]
>  #0: ffff88802b1d6460 (sb_writers#9){.+.+}-{0:0}, at: __do_sys_fallocate fs/open.c:354 [inline]
>  #0: ffff88802b1d6460 (sb_writers#9){.+.+}-{0:0}, at: __se_sys_fallocate fs/open.c:352 [inline]
>  #0: ffff88802b1d6460 (sb_writers#9){.+.+}-{0:0}, at: __x64_sys_fallocate+0xd3/0x140 fs/open.c:352
>  #1: ffff8880750fa480 (&ovl_i_mutex_key[depth]){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:756 [inline]
>  #1: ffff8880750fa480 (&ovl_i_mutex_key[depth]){+.+.}-{3:3}, at: ovl_fallocate+0x9f/0x270 fs/overlayfs/file.c:535
>
> stack backtrace:
> CPU: 1 PID: 5069 Comm: syz-executor169 Not tainted 6.1.0-rc8-next-20221207-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  print_deadlock_bug kernel/locking/lockdep.c:2990 [inline]
>  check_deadlock kernel/locking/lockdep.c:3033 [inline]
>  validate_chain kernel/locking/lockdep.c:3818 [inline]
>  __lock_acquire.cold+0x116/0x3a7 kernel/locking/lockdep.c:5055
>  lock_acquire kernel/locking/lockdep.c:5668 [inline]
>  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>  down_write+0x94/0x220 kernel/locking/rwsem.c:1562
>  inode_lock include/linux/fs.h:756 [inline]
>  ovl_remove_privs_unlocked fs/overlayfs/file.c:519 [inline]
>  ovl_fallocate+0x15c/0x270 fs/overlayfs/file.c:546
>  vfs_fallocate+0x48b/0xe00 fs/open.c:323
>  ksys_fallocate fs/open.c:346 [inline]
>  __do_sys_fallocate fs/open.c:354 [inline]
>  __se_sys_fallocate fs/open.c:352 [inline]
>  __x64_sys_fallocate+0xd3/0x140 fs/open.c:352
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fa3d1605c29
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffccc67e118 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa3d1605c29
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 00007fa3d15c9dd0 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000001000f4 R11: 0000000000000246 R12: 00007fa3d15c9e60
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
>
