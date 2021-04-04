Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9CCC433B4
	for <linux-unionfs@archiver.kernel.org>; Sun,  4 Apr 2021 08:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 829F261350
	for <linux-unionfs@archiver.kernel.org>; Sun,  4 Apr 2021 08:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhDDILF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 4 Apr 2021 04:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhDDILE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 4 Apr 2021 04:11:04 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87076C061756;
        Sun,  4 Apr 2021 01:10:59 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e186so9307362iof.7;
        Sun, 04 Apr 2021 01:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GGPHVd/NhK9uFiQkIOwsYkGkFCF2c8G1ttqY7ce8eyI=;
        b=tZpWb8QhTx+xkrSmLYqohrmPl6ShCLmHPi9lSjRK87uUQIMNDD8x5/kp9tNMC84jO+
         VQKXZr2N8LhnLfuVuMPVgtCCfYmzRhLugm+T/ooR4CJ2rGEpr3gY6x7TXjLV1rJxuG5Q
         Ea2rLYiOH4GwafeYqJIXuEH5+wg5yiaQdtrIpKMEP7bOnCIlp7sI/SiF2tuNIS8zl1wM
         8bX1btHw5dNcp9ppOI50HIlnCtDJUzu4/sbiA+lr2cBOlkvUZsdAMZTGJxG7c/0RXo+K
         g55OmD/UZbkBBRanWwXCD/Od09zEP2e+ioZvdfj+//iwPOmLQcdmo+ONfD8oS5v+VgUe
         8uFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GGPHVd/NhK9uFiQkIOwsYkGkFCF2c8G1ttqY7ce8eyI=;
        b=CQC6RLbF5jSwwx1EZ0UfQM4yTIpmB27W/79WVqWYGRL2wgVAH0iluhegPqczHUWlS1
         grkxEnCncbP9yx8BlqdSiDIf4WVA0OHxYfcHrkLM5fIVwgOO+o16U1bnvRwfY3cOhhP2
         t2KB5CSHZVZOnPl+Dz4HyAFAfUEp59LfmZHNDPeeR1Hq6rorjVfQeC5pdWOKDTBLAseW
         3iejWF/5+E07GBJ5UEdmN8NHV6eorwwDw44pBEB0cwDCpNFoNj5SAaiogM72TfZyVwUJ
         LQc5zaUPc2s6txuCQrIM2qTrcJ8rW07EDPDkYSXvv8qyUIlWfuy1BR4gdJWC3vhs4bPi
         0Ovw==
X-Gm-Message-State: AOAM531nIWBF3tZeGamEMR6njJi/FPzhGKPH6+ApzNQIibGAxXuXGGIN
        TqQ0meiLFAoywdld60HmIqwh1oAjbf/Tp7OLIPBgCLLA314=
X-Google-Smtp-Source: ABdhPJy9lX92gMs1KC5Iw2hVW7A0bsqeaAa5FdBc927H3GKZiVwZ/Y3MW0seW/9OHKZ/7fjhneF81sAQU/zj0EJsZjg=
X-Received: by 2002:a5e:8e41:: with SMTP id r1mr16423641ioo.5.1617523858895;
 Sun, 04 Apr 2021 01:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c5b77105b4c3546e@google.com> <000000000000df47be05bf165394@google.com>
In-Reply-To: <000000000000df47be05bf165394@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 4 Apr 2021 11:10:48 +0300
Message-ID: <CAOQ4uxjk4XYuwz5HCmN-Ge=Ld=tM1f7ZxVrd5U1AC2Wisc9MTA@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in ovl_maybe_copy_up
To:     syzbot <syzbot+c18f2f6a7b08c51e3025@syzkaller.appspotmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Apr 3, 2021 at 10:18 PM syzbot
<syzbot+c18f2f6a7b08c51e3025@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    454c576c Add linux-next specific files for 20210401
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1616e07ed00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=920cc274cae812a5
> dashboard link: https://syzkaller.appspot.com/bug?extid=c18f2f6a7b08c51e3025
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13da365ed00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ca9d16d00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c18f2f6a7b08c51e3025@syzkaller.appspotmail.com
>
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.12.0-rc5-next-20210401-syzkaller #0 Not tainted
> ------------------------------------------------------
> syz-executor144/9166 is trying to acquire lock:
> ffff888144cf0460 (sb_writers#5){.+.+}-{0:0}, at: ovl_maybe_copy_up+0x11f/0x190 fs/overlayfs/copy_up.c:995
>
> but task is already holding lock:
> ffff8880256d42c0 (&iint->mutex){+.+.}-{3:3}, at: process_measurement+0x3a8/0x17e0 security/integrity/ima/ima_main.c:253
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&iint->mutex){+.+.}-{3:3}:
>        __mutex_lock_common kernel/locking/mutex.c:949 [inline]
>        __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
>        process_measurement+0x3a8/0x17e0 security/integrity/ima/ima_main.c:253
>        ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:499
>        do_open fs/namei.c:3361 [inline]
>        path_openat+0x15b5/0x27e0 fs/namei.c:3492
>        do_filp_open+0x17e/0x3c0 fs/namei.c:3519
>        do_sys_openat2+0x16d/0x420 fs/open.c:1187
>        do_sys_open fs/open.c:1203 [inline]
>        __do_sys_open fs/open.c:1211 [inline]
>        __se_sys_open fs/open.c:1207 [inline]
>        __x64_sys_open+0x119/0x1c0 fs/open.c:1207
>        do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> -> #0 (sb_writers#5){.+.+}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:2938 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3061 [inline]
>        validate_chain kernel/locking/lockdep.c:3676 [inline]
>        __lock_acquire+0x2a17/0x5230 kernel/locking/lockdep.c:4902
>        lock_acquire kernel/locking/lockdep.c:5512 [inline]
>        lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
>        percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
>        __sb_start_write include/linux/fs.h:1758 [inline]
>        sb_start_write include/linux/fs.h:1828 [inline]
>        mnt_want_write+0x6e/0x3e0 fs/namespace.c:375
>        ovl_maybe_copy_up+0x11f/0x190 fs/overlayfs/copy_up.c:995
>        ovl_open+0xba/0x270 fs/overlayfs/file.c:149
>        do_dentry_open+0x4b9/0x11b0 fs/open.c:826
>        vfs_open fs/open.c:940 [inline]
>        dentry_open+0x132/0x1d0 fs/open.c:956
>        ima_calc_file_hash+0x2d2/0x4b0 security/integrity/ima/ima_crypto.c:557
>        ima_collect_measurement+0x4ca/0x570 security/integrity/ima/ima_api.c:252
>        process_measurement+0xd1c/0x17e0 security/integrity/ima/ima_main.c:330
>        ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:499
>        do_open fs/namei.c:3361 [inline]
>        path_openat+0x15b5/0x27e0 fs/namei.c:3492
>        do_filp_open+0x17e/0x3c0 fs/namei.c:3519
>        do_sys_openat2+0x16d/0x420 fs/open.c:1187
>        do_sys_open fs/open.c:1203 [inline]
>        __do_sys_open fs/open.c:1211 [inline]
>        __se_sys_open fs/open.c:1207 [inline]
>        __x64_sys_open+0x119/0x1c0 fs/open.c:1207
>        do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&iint->mutex);
>                                lock(sb_writers#5);
>                                lock(&iint->mutex);
>   lock(sb_writers#5);
>
>  *** DEADLOCK ***
>
> 1 lock held by syz-executor144/9166:
>  #0: ffff8880256d42c0 (&iint->mutex){+.+.}-{3:3}, at: process_measurement+0x3a8/0x17e0 security/integrity/ima/ima_main.c:253
>

It's a false positive lockdep warning due to missing annotation of
stacking layer on iint->mutex in IMA code.

To fix it properly, iint->mutex, which can be taken in any of the
stacking fs layers, should be annotated with stacking depth like
ovl_lockdep_annotate_inode_mutex_key()

I think it's the same root cause as:
https://syzkaller.appspot.com/bug?extid=18a1619cceea30ed45af
https://syzkaller.appspot.com/bug?extid=ae82084b07d0297e566b

I think both of the above were marked "fixed" by a paper over.
The latter was marked "fixed" by "ovl: detect overlapping layers"
but if you look at the repro, the fact that 'workdir' overlaps with
'lowerdir' has nothing to do with the lockdep warning, so said
"fix" just papered over the IMA lockdep warning.

Thanks,
Amir.
