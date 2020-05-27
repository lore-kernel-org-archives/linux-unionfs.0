Return-Path: <SRS0=jndh=7J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0001C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 20:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E11CB2073B
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 20:11:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JWCXOmyR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgE0ULu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 May 2020 16:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgE0ULu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 May 2020 16:11:50 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033DFC05BD1E
        for <linux-unionfs@vger.kernel.org>; Wed, 27 May 2020 13:11:50 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id a18so8128437ilp.7
        for <linux-unionfs@vger.kernel.org>; Wed, 27 May 2020 13:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZLkOkeqK5sshH42PrM7QypijMzjKr2Z6NTHEtHRAuBk=;
        b=JWCXOmyRewDz4WeYujfdCxklgHYfsdwaazCLMmcxMA9IP+b5rYvtes+teAL8HTsKCf
         ixYrs46kvE2EkFcCvddaVx7Z1fdvimBHSZ0h7JOtCHsaQR4Hq8wLHIwOXRT1n+Qhfwyk
         WyQvufwolzCcXCrqMktJxg2O9kDpw2qa8Sg/j+aHEyfz0uCnVMmd8/lOjuh5z9cN9mGx
         NhJS43/qAwuW3+9kG3KDnJtGt83uy9yYcEl3jykZ7tiovcJirVPfVWSPiODr6MIo7HK8
         kYMxqbAR3/KK3ZfjbaNz7S1cs83OM/D4l4E5BX1x63tbOKlM5fdw+2fKMsRcps+JaAJX
         j1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZLkOkeqK5sshH42PrM7QypijMzjKr2Z6NTHEtHRAuBk=;
        b=UBpleX68Y9ce2cBBynpDAjEiwYyf2rrCa39EJCjwYVL5mNrUTonQk0MWH/isRVXjic
         CJS9Da+ND/D96quRa5GbwaveTXOsNwQ2+jxRdNQaEtFML5BZMfQ6zZ7XXRWSnIrSzGjI
         fI6nHEZm0NevgcDB2z4kx9xs4Y09+AiQ8KmdBn96/8lzz5g30YMun15GPjeFIwuXQ/SD
         e6st280A+Lq4dzlkCcaDSXTJKNjt96zYOPMVQTOxSa4L7aBLswEwFhxMAvBxgHpQlGlu
         JMNTMU3L1jUQG9gS4lBSWLrTvA5TyC+9EVASwTAnno/GkSr6EenHzZobJQUlYp1lc1Mf
         27cQ==
X-Gm-Message-State: AOAM533c2ctb+/sXbz4ITD5Ze1avyVPO61drn/XufKe19d4xquwZy/bP
        Zw9Nahd9g4OggaUcgepVV3vDTnIByOnpO3rbWGM=
X-Google-Smtp-Source: ABdhPJwOjdUJRLHdTuJFgD59UIWJPqKJiNqlLOXpNqh9Gb/WtsonCO8GUvRevOSGsawFU2w5opfhvnknZ7MIf6yRCok=
X-Received: by 2002:a92:4015:: with SMTP id n21mr7526774ila.137.1590610309286;
 Wed, 27 May 2020 13:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200527041711.60219-1-yangerkun@huawei.com> <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
 <20200527194925.GD140950@redhat.com>
In-Reply-To: <20200527194925.GD140950@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 27 May 2020 23:11:38 +0300
Message-ID: <CAOQ4uxis2fgf_c02q=Fy2h=C0U+_zrfUmxW1HQOJ0A7KaKqWgg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     yangerkun <yangerkun@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 27, 2020 at 10:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, May 27, 2020 at 02:16:00PM +0300, Amir Goldstein wrote:
> > On Wed, May 27, 2020 at 6:45 AM yangerkun <yangerkun@huawei.com> wrote:
> > >
> > > Run generic/461 with ext4 upper/lower layer sometimes may trigger the
> > > bug as below(linux 4.19):
> > >
> > > [  551.001349] overlayfs: failed to get metacopy (-5)
> > > [  551.003464] overlayfs: failed to get inode (-5)
> > > [  551.004243] overlayfs: cleanup of 'd44/fd51' failed (-5)
> > > [  551.004941] overlayfs: failed to get origin (-5)
> > > [  551.005199] ------------[ cut here ]------------
> > > [  551.006697] WARNING: CPU: 3 PID: 24674 at fs/inode.c:1528 iput+0x33b/0x400
> > > ...
> > > [  551.027219] Call Trace:
> > > [  551.027623]  ovl_create_object+0x13f/0x170
> > > [  551.028268]  ovl_create+0x27/0x30
> > > [  551.028799]  path_openat+0x1a35/0x1ea0
> > > [  551.029377]  do_filp_open+0xad/0x160
> > > [  551.029944]  ? vfs_writev+0xe9/0x170
> > > [  551.030499]  ? page_counter_try_charge+0x77/0x120
> > > [  551.031245]  ? __alloc_fd+0x160/0x2a0
> > > [  551.031832]  ? do_sys_open+0x189/0x340
> > > [  551.032417]  ? get_unused_fd_flags+0x34/0x40
> > > [  551.033081]  do_sys_open+0x189/0x340
> > > [  551.033632]  __x64_sys_creat+0x24/0x30
> > > [  551.034219]  do_syscall_64+0xd5/0x430
> > > [  551.034800]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > ...
> > > [  556.107515] BUG: Dentry 000000006bc1d73f{i=4129c,n=fd51}  still in use (-1) [unmount of ext4 sdb]
> > > [  556.108946] ------------[ cut here ]------------
> > > [  556.109686] WARNING: CPU: 1 PID: 24682 at fs/dcache.c:1557 umount_check+0x95/0xc0
> > > [  556.130343]  d_walk+0x10d/0x430
> > > [  556.130832]  do_one_tree+0x30/0x60
> > > [  556.131365]  shrink_dcache_for_umount+0x38/0xe0
> > > [  556.132063]  generic_shutdown_super+0x2e/0x1c0
> > > [  556.132747]  kill_block_super+0x29/0x80
> > > [  556.133338]  deactivate_locked_super+0x7a/0x100
> > > [  556.134034]  deactivate_super+0x9d/0xb0
> > > [  556.134627]  cleanup_mnt+0x67/0x100
> > > [  556.135173]  __cleanup_mnt+0x16/0x20
> > > [  556.135731]  task_work_run+0xdb/0x110
> > > [  556.136306]  exit_to_usermode_loop+0x197/0x1b0
> > > [  556.136991]  do_syscall_64+0x3ce/0x430
> > > [  556.137571]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > ...
> > > [  556.378140] VFS: Busy inodes after unmount of sdb. Self-destruct in 5 seconds.  Have a nice day...
> > >
> > > After check the code, there may some bug need to fix:
> > > 1. We need to call iput once ovl_check_metacopy_xattr fail.
> > > 2. We need to call unlock_new_inode or the above iput(also with iput in
> > >    ovl_create_object) will trigger the a WARN_ON since  the I_NEW still
> > >    exists.
> > > 3. We should move the init for upperdentry to the place below
> > >    ovl_check_metacopy_xattr. Or the dentry reference will decrease to
> > >    -1(error path in ovl_create_upper will inc, ovl_destroy_inode too).
> > >
> >
> > OR we don't check metacopy xattr in ovl_get_inode().
> >
> > In ovl_lookup() we already checked metacopy xattr.
> > No reason to check it again in this subtle context.
> >
> > In ovl_lookup() can store value of upper metacopy and after we get
> > the inode, set the OVL_UPPERDATA inode flag according to
> > upperdentry && !uppermetacopy.
> >
> > That would be consistent with ovl_obtain_alias() which sets the
> > OVL_UPPERDATA inode flag after getting the inode.
>
> Hi Amir,
>
> This patch implements what you are suggesting. Compile tested only.
> Does this look ok?
>

It looks correct.

> May be I don't need to split it up in lmetacopy and umetacopy. Ideally,
> lookup in lower layers should stop if an upper regular file is not
> metacopy. IOW, (upperdentry && !metacopy) might be sufficient check.
> Will look closely if this patch looks fine.
>

I would stick uppermetacopy much like upperredirect and upperopaque.

This test:

        if (metacopy) {
                /*
                 * Found a metacopy dentry but did not find corresponding
                 * data dentry
                 */
                if (d.metacopy) {

Is equivalent to if (d.metacopy) {

I am not sure about:
        if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
                origin = stack[0].dentry;

I will let you figure it out, but it feels like it is actually testing
!uppermetacopy

Thanks,
Amir.
