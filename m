Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28E2C2B9F4
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Jun 2021 08:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1F8F60C3E
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Jun 2021 08:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhFVI4V (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 04:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhFVI4V (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Jun 2021 04:56:21 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFB6C061574;
        Tue, 22 Jun 2021 01:54:05 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id b5so5785793ilc.12;
        Tue, 22 Jun 2021 01:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ksfHZFwQXO1kG+jZWjJIQXWNbSFc4z7fgimEkskTCKI=;
        b=ljzHHHHchlVu65YtIj0WEM+N6rqPNUASRI0GwtiHOuGnEjscHKgxCqysRI4ZH2wdrs
         Xz65UTRhzQor5JtKE87GS9UmL2ro2TZT63VdkVhbFxtiT3oz7L2uQbaxilvrc2sZiHJ7
         Sr2TCwo57XjACJdPhYjEUavx5JsPN+TLBA42x2AmCHwoB7nrVzIv/aERUPG8ajyMmzQP
         xZbR994l96adWsutqABaHkxYs2TZVCw3m6qHZLtkdbqCxnHrsVC1UFeXqQzoPtrzs2cW
         e4e8NARSdRrJZlaKyv5B368MY5PPfRtPh866NQhmZ++NEylsiCfBthCyl/G3lQZSkdVo
         z6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ksfHZFwQXO1kG+jZWjJIQXWNbSFc4z7fgimEkskTCKI=;
        b=H4W/DwN7lUTjR6wSQGwu3JcfAdW7VWbm7Vszl8pWNu3M9pgLN7GFLELp9lULyEtkBx
         /TiL4XFxHql33rpGSAAx5wF7lnMl/9R3lUoa49IWpOnR24fZxmLdu2JGdom9vNFzhmun
         GXB3X+IMTW1Cfairipm5pnCmDX2MMNUvklw2ixFbi1hp+uNuvYBvY+CsrtQtsiZLSyb4
         UncOqxUr99OiSE30Amrkxojg3p6n9ywN5kSJjzII8IqvEIego6zVJoDqZGLiPATUZmVx
         mcRBJ16lOFm7yL+3EIylUOaxEms2h2U/DYXaSFqOAAK3Dr/9L+Tk6/10yJMKgsh8t9q0
         iQ8A==
X-Gm-Message-State: AOAM532R9nxbCg73ZWjR/sbNaFJJ7D6VZ1CuQPjk665gVdrKWYiNhlz1
        ng5fZbmSntbYkpzZvIokqEYF1Va8NaLhPxLU68I=
X-Google-Smtp-Source: ABdhPJwaMPO33TS6JlJVjhTtm2v/QzIExHK4osOqzyWwnwRWtQY+0pRZKnrjDc/GEph71FIOLDS2jMmpHB2UqadpAcw=
X-Received: by 2002:a92:874b:: with SMTP id d11mr1830435ilm.137.1624352044431;
 Tue, 22 Jun 2021 01:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c5b77105b4c3546e@google.com> <000000000000df47be05bf165394@google.com>
 <20210618040135.950-1-hdanton@sina.com> <23ba225593be391c384109af527bd0f3cb122a0d.camel@linux.ibm.com>
 <20210622065340.1322-1-hdanton@sina.com>
In-Reply-To: <20210622065340.1322-1-hdanton@sina.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 22 Jun 2021 11:53:53 +0300
Message-ID: <CAOQ4uxgN-900999N3RS97dmc64G5P0hyxhVq5+U+-XL_Vd6t+A@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in ovl_maybe_copy_up
To:     Hillf Danton <hdanton@sina.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        syzbot <syzbot+c18f2f6a7b08c51e3025@syzkaller.appspotmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 22, 2021 at 9:53 AM Hillf Danton <hdanton@sina.com> wrote:
>
> On Mon, 21 Jun 2021 22:32:28 -0400 Mimi Zohar wrote:
> >On Fri, 2021-06-18 at 12:01 +0800, Hillf Danton wrote:
> >> On Sun, 4 Apr 2021 11:10:48 +0300 Amir Goldstein wrote:
> >> >On Sat, Apr 3, 2021 at 10:18 PM syzbot wrote:
> >> >>
> >> >> syzbot has found a reproducer for the following issue on:
> >> >>
> >> >> HEAD commit:    454c576c Add linux-next specific files for 20210401
> >> >> git tree:       linux-next
> >> >> console output: https://syzkaller.appspot.com/x/log.txt?x=1616e07ed00000
> >> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=920cc274cae812a5
> >> >> dashboard link: https://syzkaller.appspot.com/bug?extid=c18f2f6a7b08c51e3025
> >> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13da365ed00000
> >> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ca9d16d00000
> >> >>
> >> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> >> Reported-by: syzbot+c18f2f6a7b08c51e3025@syzkaller.appspotmail.com
> >> >>
> >> >> ======================================================
> >> >> WARNING: possible circular locking dependency detected
> >> >> 5.12.0-rc5-next-20210401-syzkaller #0 Not tainted
> >> >> ------------------------------------------------------
> >> >> syz-executor144/9166 is trying to acquire lock:
> >> >> ffff888144cf0460 (sb_writers#5){.+.+}-{0:0}, at: ovl_maybe_copy_up+0x11f/0x190 fs/overlayfs/copy_up.c:995
> >> >>
> >> >> but task is already holding lock:
> >> >> ffff8880256d42c0 (&iint->mutex){+.+.}-{3:3}, at: process_measurement+0x3a8/0x17e0 security/integrity/ima/ima_main.c:253
> >> >>
> >> >> which lock already depends on the new lock.
> >> >>
> >> >>
> >> >> the existing dependency chain (in reverse order) is:
> >> >>
> >> >> -> #1 (&iint->mutex){+.+.}-{3:3}:
> >> >>        __mutex_lock_common kernel/locking/mutex.c:949 [inline]
> >> >>        __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
> >> >>        process_measurement+0x3a8/0x17e0 security/integrity/ima/ima_main.c:253
> >> >>        ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:499
> >> >>        do_open fs/namei.c:3361 [inline]
> >> >>        path_openat+0x15b5/0x27e0 fs/namei.c:3492
> >> >>        do_filp_open+0x17e/0x3c0 fs/namei.c:3519
> >> >>        do_sys_openat2+0x16d/0x420 fs/open.c:1187
> >> >>        do_sys_open fs/open.c:1203 [inline]
> >> >>        __do_sys_open fs/open.c:1211 [inline]
> >> >>        __se_sys_open fs/open.c:1207 [inline]
> >> >>        __x64_sys_open+0x119/0x1c0 fs/open.c:1207
> >> >>        do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >> >>        entry_SYSCALL_64_after_hwframe+0x44/0xae
> >> >>
> >> >> -> #0 (sb_writers#5){.+.+}-{0:0}:
> >> >>        check_prev_add kernel/locking/lockdep.c:2938 [inline]
> >> >>        check_prevs_add kernel/locking/lockdep.c:3061 [inline]
> >> >>        validate_chain kernel/locking/lockdep.c:3676 [inline]
> >> >>        __lock_acquire+0x2a17/0x5230 kernel/locking/lockdep.c:4902
> >> >>        lock_acquire kernel/locking/lockdep.c:5512 [inline]
> >> >>        lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
> >> >>        percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
> >> >>        __sb_start_write include/linux/fs.h:1758 [inline]
> >> >>        sb_start_write include/linux/fs.h:1828 [inline]
> >> >>        mnt_want_write+0x6e/0x3e0 fs/namespace.c:375
> >> >>        ovl_maybe_copy_up+0x11f/0x190 fs/overlayfs/copy_up.c:995
> >> >>        ovl_open+0xba/0x270 fs/overlayfs/file.c:149
> >> >>        do_dentry_open+0x4b9/0x11b0 fs/open.c:826
> >> >>        vfs_open fs/open.c:940 [inline]
> >> >>        dentry_open+0x132/0x1d0 fs/open.c:956
> >> >>        ima_calc_file_hash+0x2d2/0x4b0 security/integrity/ima/ima_crypto.c:557
> >> >>        ima_collect_measurement+0x4ca/0x570 security/integrity/ima/ima_api.c:252
> >> >>        process_measurement+0xd1c/0x17e0 security/integrity/ima/ima_main.c:330
> >> >>        ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:499
> >> >>        do_open fs/namei.c:3361 [inline]
> >> >>        path_openat+0x15b5/0x27e0 fs/namei.c:3492
> >> >>        do_filp_open+0x17e/0x3c0 fs/namei.c:3519
> >> >>        do_sys_openat2+0x16d/0x420 fs/open.c:1187
> >> >>        do_sys_open fs/open.c:1203 [inline]
> >> >>        __do_sys_open fs/open.c:1211 [inline]
> >> >>        __se_sys_open fs/open.c:1207 [inline]
> >> >>        __x64_sys_open+0x119/0x1c0 fs/open.c:1207
> >> >>        do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >> >>        entry_SYSCALL_64_after_hwframe+0x44/0xae
> >> >>
> >> >> other info that might help us debug this:
> >> >>
> >> >>  Possible unsafe locking scenario:
> >> >>
> >> >>        CPU0                    CPU1
> >> >>        ----                    ----
> >> >>   lock(&iint->mutex);
> >> >>                                lock(sb_writers#5);
> >> >>                                lock(&iint->mutex);
> >> >>   lock(sb_writers#5);
> >> >>
> >> >>  *** DEADLOCK ***
> >> >>
> >> >> 1 lock held by syz-executor144/9166:
> >> >>  #0: ffff8880256d42c0 (&iint->mutex){+.+.}-{3:3}, at: process_measurement+0x3a8/0x17e0 security/integrity/ima/ima_main.c:253
> >> >>
> >>
> >> It is reported again.
> >>   https://lore.kernel.org/lkml/00000000000067d24205c4d0e599@google.com/
> >> >
> >> >It's a false positive lockdep warning due to missing annotation of
> >> >stacking layer on iint->mutex in IMA code.
> >>
> >> Add it by copying what's created for ovl, see below.
> >> >
> >> >To fix it properly, iint->mutex, which can be taken in any of the
> >> >stacking fs layers, should be annotated with stacking depth like
> >> >ovl_lockdep_annotate_inode_mutex_key()
> >> >
> >> >I think it's the same root cause as:
> >> >https://syzkaller.appspot.com/bug?extid=18a1619cceea30ed45af
> >> >https://syzkaller.appspot.com/bug?extid=ae82084b07d0297e566b
> >> >
> >> >I think both of the above were marked "fixed" by a paper over.
> >> >The latter was marked "fixed" by "ovl: detect overlapping layers"
> >> >but if you look at the repro, the fact that 'workdir' overlaps with
> >> >'lowerdir' has nothing to do with the lockdep warning, so said
> >> >"fix" just papered over the IMA lockdep warning.
> >> >
> >> >Thanks,
> >> >Amir.
> >>
> >> +++ x/security/integrity/iint.c
> >> @@ -85,6 +85,45 @@ static void iint_free(struct integrity_i
> >>      kmem_cache_free(iint_cache, iint);
> >>  }
> >>
> >> +/*
> >> + * a copy from ovl_lockdep_annotate_inode_mutex_key() in a bit to fix
> >> +
> >> +   Possible unsafe locking scenario:
> >> +
> >> +    CPU0                    CPU1
> >> +       ----                    ----
> >> +     lock(&iint->mutex);
> >> +                               lock(sb_writers#5);
> >> +                               lock(&iint->mutex);
> >> +     lock(sb_writers#5);
> >> +
> >> +     *** DEADLOCK ***
> >> +
> >> +It's a false positive lockdep warning due to missing annotation of
> >> +stacking layer on iint->mutex in IMA code. [1]
> >> +
> >> +[1] https://lore.kernel.org/linux-unionfs/CAOQ4uxjk4XYuwz5HCmN-Ge=Ld=tM1f7ZxVrd5U1AC2Wisc9MTA@mail.gmail.com/
> >> +*/
> >> +static void iint_annotate_mutex_key(struct integrity_iint_cache *iint,
> >> +                                    struct inode *inode)
> >> +{
> >> +#ifdef CONFIG_LOCKDEP
> >> +    static struct lock_class_key
> >> +            iint_mutex_key[FILESYSTEM_MAX_STACK_DEPTH],
> >> +            iint_mutex_dir_key[FILESYSTEM_MAX_STACK_DEPTH];
> >> +
> >> +    int depth = inode->i_sb->s_stack_depth - 1;
> >> +
> >> +    if (WARN_ON_ONCE(depth < 0 || depth >= FILESYSTEM_MAX_STACK_DEPTH))
> >> +            depth = 0;
> >> +
> >> +    if (S_ISDIR(inode->i_mode))
> >> +            lockdep_set_class(&iint->mutex, &iint_mutex_dir_key[depth]);
> >> +    else
> >> +            lockdep_set_class(&iint->mutex, &iint_mutex_key[depth]);
> >> +#endif
> >> +}
> >
> >The iint cache is only for regular files.
>
> Yes you are right.
> >
> >> +
> >>  /**
> >>   * integrity_inode_get - find or allocate an iint associated with an inode
> >>   * @inode: pointer to the inode
> >> @@ -113,6 +152,7 @@ struct integrity_iint_cache *integrity_i
> >>      iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
> >>      if (!iint)
> >>              return NULL;
> >> +    iint_annotate_mutex_key(iint, inode);
> >>
> >>      write_lock(&integrity_iint_lock);
> >
> >Should annotating the iint be limited to files on overlay filesystems?
>
> Yes but it is more difficult to address than thought without adding to
> the vfs is_ovl_inode(inode).
>
> Aside from adding is_xfs_inode(inode), another option is move the
> dentry_open() in ima_calc_file_hash() out of and before the iint->mutex in
> process_measurement(), and that will keep the AB locking order intact.
>
> Thoughts are welcome.

There is no need to detect overlayfs check for (inode->i_sb->s_stack_depth > 0)

Thanks,
Amir.
