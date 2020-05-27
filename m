Return-Path: <SRS0=jndh=7J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0EB6C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 14:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 863E020899
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 14:46:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="hKlG9Ic3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389264AbgE0Oqw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 May 2020 10:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389249AbgE0Oqw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 May 2020 10:46:52 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B858CC05BD1E
        for <linux-unionfs@vger.kernel.org>; Wed, 27 May 2020 07:46:50 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id c35so4145614edf.5
        for <linux-unionfs@vger.kernel.org>; Wed, 27 May 2020 07:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KMoa7H1YP9mRk6qPCbeEllwBcYCQ5xUs/Fm5HspwXuw=;
        b=hKlG9Ic3ZpJfzXikJqJqkbzJajMrFzvkcarOv4SOt0k6Rrw/J2rj9HVOg58AWZ7ehE
         owmB59Mqaqrd/ZRWFzoTwyfiNTIuCDtM0Vxzssden4P8o7eL/v9ZuKTeX9mjHWyyUARy
         +XChK/0+W7ZC32dxt6snns08K1Y+sfX+A4Bkw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KMoa7H1YP9mRk6qPCbeEllwBcYCQ5xUs/Fm5HspwXuw=;
        b=fS1DACuWFu8J/RBtPN1JSu+CVzIbjmXuPOkAWzLqEduym1D5XCbGBIHIX/Bfed6BPV
         2tPYCitVan/BmkYTKvlIEADIZb/BZSv+eKLlha4Z0unTYiRghYOfKZ148QB1EuI8YQWC
         BAxGiggauay1OydfZVFs+b1vWpWoK316RBNRuDr4OGwmiUyvO8tuEmqRNVp57uuBdiy0
         5vFcqFdDl/AJPmfmyddwb/RbmS83zwUIxiZWbSLv//WFUj0PuULE6m5ZSarsd+rq6Z/P
         upSIczmUv2ROvPOc/68rrzy6TWmND6jDyu4PyyGos1JVuxvBc+1gwtHBNh9YKHBOhr4s
         6muQ==
X-Gm-Message-State: AOAM5305IVOwkiZT+Co5zA0ilCGRprUD6F7YhP6/Fyhps3gjrkw9gGEG
        PrPRFcmOoItTQzUd9zprz5CK8g1BbGoWtFiH7YVC5g==
X-Google-Smtp-Source: ABdhPJwIFi9igdBaLs5oghS75DnNGSq1IjMKc3LyStIUYrRhrnszEHfYa/1N9Gsb2wtxvqXnBd4//ckNpVaB7IV3xoo=
X-Received: by 2002:a05:6402:2058:: with SMTP id bc24mr24651829edb.134.1590590809453;
 Wed, 27 May 2020 07:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200527041711.60219-1-yangerkun@huawei.com> <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 27 May 2020 16:46:37 +0200
Message-ID: <CAJfpegv8-6heAchSSGu1o6Rktd=v+PCFtAddeQhdvgAeiP0ztw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     yangerkun <yangerkun@huawei.com>, Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 27, 2020 at 1:16 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, May 27, 2020 at 6:45 AM yangerkun <yangerkun@huawei.com> wrote:
> >
> > Run generic/461 with ext4 upper/lower layer sometimes may trigger the
> > bug as below(linux 4.19):
> >
> > [  551.001349] overlayfs: failed to get metacopy (-5)
> > [  551.003464] overlayfs: failed to get inode (-5)
> > [  551.004243] overlayfs: cleanup of 'd44/fd51' failed (-5)
> > [  551.004941] overlayfs: failed to get origin (-5)
> > [  551.005199] ------------[ cut here ]------------
> > [  551.006697] WARNING: CPU: 3 PID: 24674 at fs/inode.c:1528 iput+0x33b/0x400
> > ...
> > [  551.027219] Call Trace:
> > [  551.027623]  ovl_create_object+0x13f/0x170
> > [  551.028268]  ovl_create+0x27/0x30
> > [  551.028799]  path_openat+0x1a35/0x1ea0
> > [  551.029377]  do_filp_open+0xad/0x160
> > [  551.029944]  ? vfs_writev+0xe9/0x170
> > [  551.030499]  ? page_counter_try_charge+0x77/0x120
> > [  551.031245]  ? __alloc_fd+0x160/0x2a0
> > [  551.031832]  ? do_sys_open+0x189/0x340
> > [  551.032417]  ? get_unused_fd_flags+0x34/0x40
> > [  551.033081]  do_sys_open+0x189/0x340
> > [  551.033632]  __x64_sys_creat+0x24/0x30
> > [  551.034219]  do_syscall_64+0xd5/0x430
> > [  551.034800]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > ...
> > [  556.107515] BUG: Dentry 000000006bc1d73f{i=4129c,n=fd51}  still in use (-1) [unmount of ext4 sdb]
> > [  556.108946] ------------[ cut here ]------------
> > [  556.109686] WARNING: CPU: 1 PID: 24682 at fs/dcache.c:1557 umount_check+0x95/0xc0
> > [  556.130343]  d_walk+0x10d/0x430
> > [  556.130832]  do_one_tree+0x30/0x60
> > [  556.131365]  shrink_dcache_for_umount+0x38/0xe0
> > [  556.132063]  generic_shutdown_super+0x2e/0x1c0
> > [  556.132747]  kill_block_super+0x29/0x80
> > [  556.133338]  deactivate_locked_super+0x7a/0x100
> > [  556.134034]  deactivate_super+0x9d/0xb0
> > [  556.134627]  cleanup_mnt+0x67/0x100
> > [  556.135173]  __cleanup_mnt+0x16/0x20
> > [  556.135731]  task_work_run+0xdb/0x110
> > [  556.136306]  exit_to_usermode_loop+0x197/0x1b0
> > [  556.136991]  do_syscall_64+0x3ce/0x430
> > [  556.137571]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > ...
> > [  556.378140] VFS: Busy inodes after unmount of sdb. Self-destruct in 5 seconds.  Have a nice day...
> >
> > After check the code, there may some bug need to fix:
> > 1. We need to call iput once ovl_check_metacopy_xattr fail.
> > 2. We need to call unlock_new_inode or the above iput(also with iput in
> >    ovl_create_object) will trigger the a WARN_ON since  the I_NEW still
> >    exists.
> > 3. We should move the init for upperdentry to the place below
> >    ovl_check_metacopy_xattr. Or the dentry reference will decrease to
> >    -1(error path in ovl_create_upper will inc, ovl_destroy_inode too).
> >
>
> OR we don't check metacopy xattr in ovl_get_inode().
>
> In ovl_lookup() we already checked metacopy xattr.
> No reason to check it again in this subtle context.
>
> In ovl_lookup() can store value of upper metacopy and after we get
> the inode, set the OVL_UPPERDATA inode flag according to
> upperdentry && !uppermetacopy.
>
> That would be consistent with ovl_obtain_alias() which sets the
> OVL_UPPERDATA inode flag after getting the inode.

I agree that that is a good direction, however for the actual fix I
think the following is sufficient (whitespace damaged, only for
review).

The reason we can skip the metacopy check for the ->newinode != NULL
case is that that only happens on object creation, which very
obviously won't have metacopy set.

Thanks,
Miklos

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3b7ed5d2279c..fd7f1d4adf04 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -889,7 +889,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
     if (oip->index)
         ovl_set_flag(OVL_INDEX, inode);

-    if (upperdentry) {
+    if (upperdentry && !oip->newinode) {
         err = ovl_check_metacopy_xattr(upperdentry);
         if (err < 0)
             goto out_err;
