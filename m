Return-Path: <SRS0=6v4H=7K=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40566C433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 May 2020 21:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 111B2207BC
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 May 2020 21:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="crAtnthT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407509AbgE1VH7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 May 2020 17:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407484AbgE1VH5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 May 2020 17:07:57 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C807C08C5C6
        for <linux-unionfs@vger.kernel.org>; Thu, 28 May 2020 14:07:57 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id v11so410903ilh.1
        for <linux-unionfs@vger.kernel.org>; Thu, 28 May 2020 14:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=roPjiFSY/Ri+KgLu9HJ8VghNLTiI/qSMqKtMbIHsGeo=;
        b=crAtnthTrEi0T/Vn44JK18AZF9nJybMIoHCldeHZzkMRHDlc3ed2MEK2eKROiflQlx
         pdNIaUUVdJOXmHrTFlI6ltUiAMN+4VAXMUO1uKYVg7n3rW/audG+GxrqHQPlmArB1WtK
         wnUKw3fM8jpnLsrjUqSP8ptKrlXjuboIK9R8NjeHKWb4AFIhDz4+n9Vl+Hz0P04V5zLj
         A8hErzM9LW40Uj9sB/TwPvNVzPjbJueNp7NwAjcnabFj9+0UU5lNkIVgxR/SQljYxQbV
         8xhU8wwhPanr2RIrXJd68lelkuW6nRSxaTTCq25y+aKckETi8lLlu1QXOiFLZhNpW744
         hl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=roPjiFSY/Ri+KgLu9HJ8VghNLTiI/qSMqKtMbIHsGeo=;
        b=uSYjvc0Zgj1PyLkbf/hvV8H/35Fc3ZP/fUZKRo22HnasvoKpVzfHX9r6n7+KP17L4a
         Y5CiCN4eHWocMbhcpB/GDgJGXQqpOELty2hxztH+W0aqYxQOpU0qBQ8YJAv62c4dcsDX
         +uS2gps2ms8mSTdbzVTZwnbQU58804mN0YrpUauJc3sERTOcP/035pdTWup2cVFrYNmR
         r8yonFIoJSshWSz4YgNSehb6M/j4+v+c1wYPP+t+vj1ZV7400XYXfzmlQ4F1SYJOhY/j
         0wDX/SMr8KF/CrWS8STpJ3nFnhE2P7Exfn03NaHLy6O0F+0U/1xPO+KnR9ZZ0J+rOoFv
         7MKA==
X-Gm-Message-State: AOAM531Q52uVisEvYGJXbapI3TmDwCOsX+g1p7r2iOtDclXSyesS9Ym+
        tvExNAGDxl29sUNvKifI9mHdSGMcseOvgFmA/BY=
X-Google-Smtp-Source: ABdhPJxzqYLMkaRmbAYDYkttHd/7391O0+FXlxtngx/tQe9aKpXXts5Q74PT9HBAychZ8dvtGOYUJ1cCRz+uSIoCrHg=
X-Received: by 2002:a92:db12:: with SMTP id b18mr4605043iln.250.1590700076886;
 Thu, 28 May 2020 14:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200527041711.60219-1-yangerkun@huawei.com> <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
 <20200527194925.GD140950@redhat.com> <CAOQ4uxis2fgf_c02q=Fy2h=C0U+_zrfUmxW1HQOJ0A7KaKqWgg@mail.gmail.com>
 <20200528173512.GA167257@redhat.com>
In-Reply-To: <20200528173512.GA167257@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 29 May 2020 00:07:45 +0300
Message-ID: <CAOQ4uxhnsc8AHfeQJ-eHFEjyONRF5bXBvRd-D29Nao4Bz8EM0g@mail.gmail.com>
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

On Thu, May 28, 2020 at 8:35 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, May 27, 2020 at 11:11:38PM +0300, Amir Goldstein wrote:
>
> [..]
> > > > OR we don't check metacopy xattr in ovl_get_inode().
> > > >
> > > > In ovl_lookup() we already checked metacopy xattr.
> > > > No reason to check it again in this subtle context.
> > > >
> > > > In ovl_lookup() can store value of upper metacopy and after we get
> > > > the inode, set the OVL_UPPERDATA inode flag according to
> > > > upperdentry && !uppermetacopy.
> > > >
> > > > That would be consistent with ovl_obtain_alias() which sets the
> > > > OVL_UPPERDATA inode flag after getting the inode.
> > >
> > > Hi Amir,
> > >
> > > This patch implements what you are suggesting. Compile tested only.
> > > Does this look ok?
> > >
> >
> > It looks correct.
> >
> > > May be I don't need to split it up in lmetacopy and umetacopy. Ideally,
> > > lookup in lower layers should stop if an upper regular file is not
> > > metacopy. IOW, (upperdentry && !metacopy) might be sufficient check.
> > > Will look closely if this patch looks fine.
> > >
> >
> > I would stick uppermetacopy much like upperredirect and upperopaque.
>
> Ok, I introduced uppermetacopy and lowermetacopy. I need to make
> sure that I don't following metacopy file to lower layer if
> metacopy feature is off. This check should be done both for upper
> and lower metcopy files.

You don't need lowermetacopy for that. you can check d.metacopy
directly.

>
> >
> > This test:
> >
> >         if (metacopy) {
> >                 /*
> >                  * Found a metacopy dentry but did not find corresponding
> >                  * data dentry
> >                  */
> >                 if (d.metacopy) {
> >
> > Is equivalent to if (d.metacopy) {
>
> Agreed. Updated the patch.
>
> >
> > I am not sure about:
> >         if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> >                 origin = stack[0].dentry;
> >
> > I will let you figure it out, but it feels like it is actually testing
> > !uppermetacopy
>
> Yes this is testing !uppermetacopy. I really want to simplify it a bit
> or atleast document it a bit that why metacopy case is different. Upper,
> regular files done't go through lower layer loop but upper metacopy
> files do. That's one difference which introduces some interesting
> code changes.
>
> - lower layer lookup loop already sets "origin" for metacopy files if
>   indexing is on. This does not happen for regular non-metacopy files
>   so they need to set origin here explicitly.
>
>   if index feature is off, then we will not set "origin" for metacopy
>   files in lower layer loop. But do we really need to set it given
>   index is off and we don't want to lookup index.
>
> - We don't want to set origin if upper never had xattr ORIGIN. For
>   regular files, ctr will be 0 or 1 if ORIGIN xattr was found on
>   upper. But for metacopy upper files, ctr can be non-zero even
>   if ORGIN xattr was not found. So that's another reason that
>   we check for upper metacopy here.
>
> Difference between the case of regular and metacopy is subtle and
> I think this should be simplified otherwise its very easy to break
> it.
>
> I will spend some time on this after fixing the issue at hand. /me
> always gets lost in the mage of index and origin. There seem to
> be so many permutation and combination and its not clear to me
> when metacopy file is different than regular file w.r.t origin
> and index. It will be nice if we can minimize this difference and
> document it well so that future modifications are easy.

I agree it should be simplified.
If you cannot figure out how, let me know and I will try.


>
> Here is V2 of the patch. I added changelog. Also updated it to
> set OVL_UPPERDATA in ovl_instantiate(). This is creating a new
> file, so it can't be metacopy and should set OVL_UPPERDATA.
>
> Miklos and Amir, please let me know what do you think about this
> patch. I ran xfstetests overlay tests and these pass (except two
> which fail even without the patch and are meant to fail.).
>
> Thanks
> Vivek
>
>
> Subject: overlayfs: Initialize OVL_UPPERDATA in ovl_lookup()
>
> Currently ovl_get_inode() initializes OVL_UPPERDATA flag and for that it
> has to call ovl_check_metacopy_xattr() and check if metacopy xattr is
> present or not.
>
> yangerkun reported sometimes underlying filesystem might return -EIO
> and in that case error handling path does not cleanup properly leading
> to various warnings.
>
> Run generic/461 with ext4 upper/lower layer sometimes may trigger the
> bug as below(linux 4.19):
>
> [  551.001349] overlayfs: failed to get metacopy (-5)
> [  551.003464] overlayfs: failed to get inode (-5)
> [  551.004243] overlayfs: cleanup of 'd44/fd51' failed (-5)
> [  551.004941] overlayfs: failed to get origin (-5)
> [  551.005199] ------------[ cut here ]------------
> [  551.006697] WARNING: CPU: 3 PID: 24674 at fs/inode.c:1528 iput+0x33b/0x400
> ...
> [  551.027219] Call Trace:
> [  551.027623]  ovl_create_object+0x13f/0x170
> [  551.028268]  ovl_create+0x27/0x30
> [  551.028799]  path_openat+0x1a35/0x1ea0
> [  551.029377]  do_filp_open+0xad/0x160
> [  551.029944]  ? vfs_writev+0xe9/0x170
> [  551.030499]  ? page_counter_try_charge+0x77/0x120
> [  551.031245]  ? __alloc_fd+0x160/0x2a0
> [  551.031832]  ? do_sys_open+0x189/0x340
> [  551.032417]  ? get_unused_fd_flags+0x34/0x40
> [  551.033081]  do_sys_open+0x189/0x340
> [  551.033632]  __x64_sys_creat+0x24/0x30
> [  551.034219]  do_syscall_64+0xd5/0x430
> [  551.034800]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> One solution is to improve error handling and call iget_failed() if error
> is encountered. Amir thinks that this path is little intricate and there
> is not real need to check and initialize OVL_UPPERDATA in ovl_get_inode().
> Instead caller of ovl_get_inode() can initialize this state. And this
> will avoid double checking of metacopy xattr lookup in ovl_lookup()
> and ovl_get_inode().
>
> OVL_UPPERDATA is inode flag. So I was little concerned that initializing
> it outside ovl_get_inode() might have some races. But this is one way
> transition. That is once a file has been fully copied up, it can't go
> back to metacopy file again. And that seems to help avoid races. So
> as of now I can't see any races w.r.t OVL_UPPERDATA being set wrongly. So
> move settingof OVL_UPPERDATA inside the callers of ovl_get_inode().
> ovl_obtain_alias() already does it. So only two callers now left
> are ovl_lookup() and ovl_instantiate().
>
> metacopy variable has been split into two variables, lowermetacopy
> and uppermetacopy. It just makes it easier to understand whether
> metacopy if set on lower or upper. We need to set OVL_UPPERDATA
> only in case of uppermetacopy.
>
> Reported-by: yangerkun <yangerkun@huawei.com>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/dir.c   |    2 ++
>  fs/overlayfs/inode.c |   11 +----------
>  fs/overlayfs/namei.c |   25 ++++++++++++-------------
>  3 files changed, 15 insertions(+), 23 deletions(-)
>
> Index: redhat-linux/fs/overlayfs/namei.c
> ===================================================================
> --- redhat-linux.orig/fs/overlayfs/namei.c      2020-05-28 10:51:57.838556592 -0400
> +++ redhat-linux/fs/overlayfs/namei.c   2020-05-28 12:11:36.876964037 -0400
> @@ -823,7 +823,7 @@ struct dentry *ovl_lookup(struct inode *
>         struct dentry *this;
>         unsigned int i;
>         int err;
> -       bool metacopy = false;
> +       bool uppermetacopy=false, lowermetacopy=false;

spaces around = and no need for lowermetacopy

>         struct ovl_lookup_data d = {
>                 .sb = dentry->d_sb,
>                 .name = dentry->d_name,
> @@ -869,7 +869,7 @@ struct dentry *ovl_lookup(struct inode *
>                                 goto out_put_upper;
>
>                         if (d.metacopy)
> -                               metacopy = true;
> +                               uppermetacopy = true;
>                 }
>
>                 if (d.redirect) {
> @@ -941,7 +941,7 @@ struct dentry *ovl_lookup(struct inode *
>                 }
>
>                 if (d.metacopy)
> -                       metacopy = true;
> +                       lowermetacopy = true;
>                 /*
>                  * Do not store intermediate metacopy dentries in chain,
>                  * except top most lower metacopy dentry
> @@ -982,16 +982,13 @@ struct dentry *ovl_lookup(struct inode *
>                 }
>         }
>
> -       if (metacopy) {
> -               /*
> -                * Found a metacopy dentry but did not find corresponding
> -                * data dentry
> -                */
> -               if (d.metacopy) {
> -                       err = -EIO;
> -                       goto out_put;
> -               }
> +       /* Found a metacopy dentry but did not find corresponding data dentry */
> +       if (d.metacopy) {
> +               err = -EIO;
> +               goto out_put;
> +       }
>
> +       if (lowermetacopy || uppermetacopy) {
>                 err = -EPERM;
>                 if (!ofs->config.metacopy) {
>                         pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n",

Move that test up to where setting metacopy = true for lower layers
similar to "refusing to follow redirect" and make it:
       if (uppermetacopy || d.metacopy) {

Then you got rid of lowermetacopy.

> @@ -1023,7 +1020,7 @@ struct dentry *ovl_lookup(struct inode *
>          *
>          * Always lookup index of non-dir non-metacopy and non-upper.
>          */
> -       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> +       if (ctr && (!upperdentry || (!d.is_dir && !uppermetacopy)))
>                 origin = stack[0].dentry;
>

I think this should be:

          * Always lookup index of non-dir and non-upper.
          */
          if (!origin && ctr && (!upperdentry || !d.is_dir))
                 origin = stack[0].dentry;

uppermetacopy is guaranteed to either have origin already set or
exit with an an error for ovl_verify_origin().

HOWEVER, if we set origin to lower, which turns out to be a lower
metacopy, we then skip this layer to the next one, but origin remains
set on the skipped layer dentry, which we had already dput().
Ay ay ay!

I think it would be best to move the check
                 * Do not store intermediate metacopy dentries in chain,
to right after ovl_lookup_layer(), before the ovl_fix_origin() and
ovl_verify_origin() checks.

Thanks,
Amir.
