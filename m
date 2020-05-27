Return-Path: <SRS0=jndh=7J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0527DC433E2
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 17:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A7020873
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 17:12:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tAZmVIPJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbgE0RMI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 May 2020 13:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731198AbgE0RMH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 May 2020 13:12:07 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F07DC03E97D
        for <linux-unionfs@vger.kernel.org>; Wed, 27 May 2020 10:12:07 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x6so11190934wrm.13
        for <linux-unionfs@vger.kernel.org>; Wed, 27 May 2020 10:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJoGsckjCy1bf27yHnGhtYKHJ9TmIZLJQTwuN5oo+Es=;
        b=tAZmVIPJhj8Ys+itQG1D0UBztSYbLDPokJfqyOna86UCh6SnZZ0vndPCPKpSa2cjF1
         G8WVdfCdBgr/TygnpCqBOJS8llpjYNcLJ6nN6elCNY/ISTaWW7JUBLi0mSps/C9xc/bs
         +PdIlz1bV4WSKnHLTm1c7+SVqPXPCrUcMkBZ6Vb9RObBmzUq/HTYBtutxEzs0h2/Jwac
         r6DhggrkDc1uGmAzyXpwHHxkvnRKzxbboni2/9bnDrx8xyDl+QvjEMtxhrVy3EkI7C//
         O4JYK2ceiDU5nzQzzxkpjnMFuR0lpNYY5bbh3epNQI9frfV8z0FEyOA5bnftlvf0utzl
         nGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pJoGsckjCy1bf27yHnGhtYKHJ9TmIZLJQTwuN5oo+Es=;
        b=a+hN++rRFn1imdeWomDGIZL5QL7l+HIakiaVmHwCjZFIb4kYWXsX7SOinvpgDnv5tK
         L0LXsmw2f+6A1NpaqceV4qJrr2bdcNOi+6HaNYckf0Tp0ju1yMxHxaM0QWLGWMGnNbGI
         CzLhAqBIBxsRjTkSzOYYynQdR2App0vUrhG0eLKAl5bAZ/RXpn6DWNa1HePVS0kxCNbE
         eo1UavL9E4eSM7aS3lvNfwUzR17tQ8IPwwQ65Ugsy6SkYLUW5efaJmPE5pAAWOw+QSAB
         gUxzJfzLiOvUCWDNxHIjSV2YfSA2Uo/VeYTyLigKIxHeBV4nRMy3n7gPskH/zLDp6VzE
         Rrpg==
X-Gm-Message-State: AOAM530tQxrSBlNAx2RRco3gAwLHAXcc1uh9qX/6sOYP7pklFiERK9+8
        069qp/P1/xD2kgeQw2hghl3yjiKJqCrTvxxPbfw=
X-Google-Smtp-Source: ABdhPJybbB0tnjajU/9f+gqvXVrC0OcgD9V+p9X2HzxHky1/X+QhN0Bw4IcIUOZwBDi6VI2Dq8YayW2DRDMrDFqqhKk=
X-Received: by 2002:adf:8041:: with SMTP id 59mr24543140wrk.278.1590599526004;
 Wed, 27 May 2020 10:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200527041711.60219-1-yangerkun@huawei.com> <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
 <CAJfpegv8-6heAchSSGu1o6Rktd=v+PCFtAddeQhdvgAeiP0ztw@mail.gmail.com> <20200527160243.GA140950@redhat.com>
In-Reply-To: <20200527160243.GA140950@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 27 May 2020 20:11:54 +0300
Message-ID: <CAOQ4uxjRo-p2ecOKzVURyjGcxKgCb3AK=sdwtYuHcjtXj9mp1Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 27, 2020 at 7:02 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, May 27, 2020 at 04:46:37PM +0200, Miklos Szeredi wrote:
> > On Wed, May 27, 2020 at 1:16 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Wed, May 27, 2020 at 6:45 AM yangerkun <yangerkun@huawei.com> wrote:
> > > >
> > > > Run generic/461 with ext4 upper/lower layer sometimes may trigger the
> > > > bug as below(linux 4.19):
> > > >
> > > > [  551.001349] overlayfs: failed to get metacopy (-5)
> > > > [  551.003464] overlayfs: failed to get inode (-5)
> > > > [  551.004243] overlayfs: cleanup of 'd44/fd51' failed (-5)
> > > > [  551.004941] overlayfs: failed to get origin (-5)
> > > > [  551.005199] ------------[ cut here ]------------
> > > > [  551.006697] WARNING: CPU: 3 PID: 24674 at fs/inode.c:1528 iput+0x33b/0x400
> > > > ...
> > > > [  551.027219] Call Trace:
> > > > [  551.027623]  ovl_create_object+0x13f/0x170
> > > > [  551.028268]  ovl_create+0x27/0x30
> > > > [  551.028799]  path_openat+0x1a35/0x1ea0
> > > > [  551.029377]  do_filp_open+0xad/0x160
> > > > [  551.029944]  ? vfs_writev+0xe9/0x170
> > > > [  551.030499]  ? page_counter_try_charge+0x77/0x120
> > > > [  551.031245]  ? __alloc_fd+0x160/0x2a0
> > > > [  551.031832]  ? do_sys_open+0x189/0x340
> > > > [  551.032417]  ? get_unused_fd_flags+0x34/0x40
> > > > [  551.033081]  do_sys_open+0x189/0x340
> > > > [  551.033632]  __x64_sys_creat+0x24/0x30
> > > > [  551.034219]  do_syscall_64+0xd5/0x430
> > > > [  551.034800]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > ...
> > > > [  556.107515] BUG: Dentry 000000006bc1d73f{i=4129c,n=fd51}  still in use (-1) [unmount of ext4 sdb]
> > > > [  556.108946] ------------[ cut here ]------------
> > > > [  556.109686] WARNING: CPU: 1 PID: 24682 at fs/dcache.c:1557 umount_check+0x95/0xc0
> > > > [  556.130343]  d_walk+0x10d/0x430
> > > > [  556.130832]  do_one_tree+0x30/0x60
> > > > [  556.131365]  shrink_dcache_for_umount+0x38/0xe0
> > > > [  556.132063]  generic_shutdown_super+0x2e/0x1c0
> > > > [  556.132747]  kill_block_super+0x29/0x80
> > > > [  556.133338]  deactivate_locked_super+0x7a/0x100
> > > > [  556.134034]  deactivate_super+0x9d/0xb0
> > > > [  556.134627]  cleanup_mnt+0x67/0x100
> > > > [  556.135173]  __cleanup_mnt+0x16/0x20
> > > > [  556.135731]  task_work_run+0xdb/0x110
> > > > [  556.136306]  exit_to_usermode_loop+0x197/0x1b0
> > > > [  556.136991]  do_syscall_64+0x3ce/0x430
> > > > [  556.137571]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > > ...
> > > > [  556.378140] VFS: Busy inodes after unmount of sdb. Self-destruct in 5 seconds.  Have a nice day...
> > > >
> > > > After check the code, there may some bug need to fix:
> > > > 1. We need to call iput once ovl_check_metacopy_xattr fail.
> > > > 2. We need to call unlock_new_inode or the above iput(also with iput in
> > > >    ovl_create_object) will trigger the a WARN_ON since  the I_NEW still
> > > >    exists.
> > > > 3. We should move the init for upperdentry to the place below
> > > >    ovl_check_metacopy_xattr. Or the dentry reference will decrease to
> > > >    -1(error path in ovl_create_upper will inc, ovl_destroy_inode too).
> > > >
> > >
> > > OR we don't check metacopy xattr in ovl_get_inode().
> > >
> > > In ovl_lookup() we already checked metacopy xattr.
> > > No reason to check it again in this subtle context.
> > >
> > > In ovl_lookup() can store value of upper metacopy and after we get
> > > the inode, set the OVL_UPPERDATA inode flag according to
> > > upperdentry && !uppermetacopy.
> > >
> > > That would be consistent with ovl_obtain_alias() which sets the
> > > OVL_UPPERDATA inode flag after getting the inode.
> >
> > I agree that that is a good direction, however for the actual fix I
> > think the following is sufficient (whitespace damaged, only for
> > review).
> >
> > The reason we can skip the metacopy check for the ->newinode != NULL
> > case is that that only happens on object creation, which very
> > obviously won't have metacopy set.
> >
> > Thanks,
> > Miklos
> >
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index 3b7ed5d2279c..fd7f1d4adf04 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -889,7 +889,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
> >      if (oip->index)
> >          ovl_set_flag(OVL_INDEX, inode);
> >
> > -    if (upperdentry) {
> > +    if (upperdentry && !oip->newinode) {
> >          err = ovl_check_metacopy_xattr(upperdentry);
> >          if (err < 0)
> >              goto out_err;
>
> Hi Miklos and Amir,
>
> How about enahncing above a bit to deal with error. Will this work. Just
> compile tested.
>

Please no. it makes no sense.
Proper fix IMO is to use value checked in ovl_lookup()
instead of rechecking here.
Miklos' fix should works by avoiding hitting this check
in the most likely scenario (that getxattr either fails or succeeds,
but not randomly).

Thanks,
Amir.
