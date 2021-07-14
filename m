Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E21C07E9A
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jul 2021 10:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5E9561363
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jul 2021 10:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhGNKlI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 06:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhGNKlH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jul 2021 06:41:07 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798AAC06175F
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jul 2021 03:38:16 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id w1so1055574ilg.10
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jul 2021 03:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fzYmvy5tKuWMHIUKMuUYnDT3zZh64RtBT2mDZEAky7k=;
        b=Ifk803gsQv2Vp6TmsUew66B3JWfX0SVMEEvcOzbn52vayLKw3klT5pQjBCPfcouNir
         G+uwHvJMSVShZy2hTz2O35t6LSldJC0K5/Vk1xXBhLEN/9dRDhzxT2qh2sy8tneiznle
         AWhkORzBVJ86jdzMTjw1sCqRgviqgRceSHOw3AOKVqknaWyP7/V+BovpoDgVT0K1TkY3
         IcbXNwQGX2jJvQlqQkgHkmxq6/Evn1tsuT6S2uspLt7MjEHC6mNGosJ9bXE2LA2Dfgnd
         o8FK5+IUKosWN+awVPSAwAMbgaWHgL7Ur785E3sBbs8inGgYXrk7VvvzrVa20dMNoIvE
         WMMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fzYmvy5tKuWMHIUKMuUYnDT3zZh64RtBT2mDZEAky7k=;
        b=D29g3S7mIzgrWOY1r2wfg7qUIlDeaYYIsK9ZPnJE/TeJMalk310u8BN+JlInbjnOel
         3cINGAxhmyMSOhMXoGn3mKHaxRF9YMnXVx98Rq2EbHyI1GRTjNWBmxTzHaLNZCY4ybMx
         sBh+1vS8y3OcdO66pcexUZcU3myEkn3hVpj6NiHEFjD7YBiLNRO3jLxBtRYNpAywDaYr
         4soQBF9Wu8jahL2OwOT1H6voVfKcMjqK0aj1qvwcotxVNQDDBk4x2YocUF8PDQYCAKYj
         KhGlyb0VBQxc4K5qbrWIJaUCAu4YJVbP9A3Ei7SlWSi9pO/muQxyg/RcOHjtNdIb/HKv
         8M7A==
X-Gm-Message-State: AOAM533OJtVKuSxB210HL/+HrZY0CIn8nizO32i4kz/UmjVBbaAEQ5gp
        KMZAVhf2gArg8Y1njhexeZ1MSEW6We4trNopijwMHe1t
X-Google-Smtp-Source: ABdhPJyjppaCi1FpL7SSId7XT6CT9wvex49/LiBicCtW9DIlYQhmjoozIlxWUeyEp58s+rJT/5K28wBuaneB2EgoiW8=
X-Received: by 2002:a92:4442:: with SMTP id a2mr6204227ilm.72.1626259095844;
 Wed, 14 Jul 2021 03:38:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210619092619.1107608-1-amir73il@gmail.com> <20210619092619.1107608-4-amir73il@gmail.com>
 <CAJfpegv89zStsDSWmY39YiF=aZVyO=rOYFU5_VBHxu-H_h-_dQ@mail.gmail.com>
 <CAOQ4uxiWRWtkFixLU72Bu9_o+hncsX0VQczpbVXkOZG3K8UAxQ@mail.gmail.com>
 <CAOQ4uxgQuhPck2psKsROoVUprPw62kV46MFv_4SHWU+s11xH3w@mail.gmail.com> <CAJfpegvpk-4SPPi2NM6ZnuDZNxcPK=4+JapxtLf_oYiCvuScrw@mail.gmail.com>
In-Reply-To: <CAJfpegvpk-4SPPi2NM6ZnuDZNxcPK=4+JapxtLf_oYiCvuScrw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 14 Jul 2021 13:38:04 +0300
Message-ID: <CAOQ4uxhZoDd+75Q+cbJs+xV4yDoQ75qKDcMN8nRpm_Mt=vKQMw@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: copy up sync/noatime fileattr flags
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 14, 2021 at 11:47 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, 12 Jul 2021 at 17:52, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Jul 12, 2021 at 6:51 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Mon, Jul 12, 2021 at 5:20 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Sat, 19 Jun 2021 at 11:26, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > When a lower file has sync/noatime fileattr flags, the behavior of
> > > > > overlayfs post copy up is inconsistent.
> > > > >
> > > > > Immediattely after copy up, ovl inode still has the S_SYNC/S_NOATIME
> > > > > inode flags copied from lower inode, so vfs code still treats the ovl
> > > > > inode as sync/noatime.  After ovl inode evict or mount cycle,
> > > > > the ovl inode does not have these inode flags anymore.
> > > > >
> > > > > To fix this inconsitency, try to copy the fileattr flags on copy up
> > > > > if the upper fs supports the fileattr_set() method.
> > > > >
> > > > > This gives consistent behavior post copy up regardless of inode eviction
> > > > > from cache.
> > > > >
> > > > > We cannot copy up the immutable/append-only inode flags in a similar
> > > > > manner, because immutable/append-only inodes cannot be linked and because
> > > > > overlayfs will not be able to set overlay.* xattr on the upper inodes.
> > > > >
> > > > > Those flags will be addressed by a followup patch.
> > > > >
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > > >  fs/overlayfs/copy_up.c   | 49 ++++++++++++++++++++++++++++++++++------
> > > > >  fs/overlayfs/inode.c     | 36 ++++++++++++++++++-----------
> > > > >  fs/overlayfs/overlayfs.h | 14 +++++++++++-
> > > > >  3 files changed, 78 insertions(+), 21 deletions(-)
> > > > >
> > > > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > > > index 3fa68a5cc16e..a06b423ca5d1 100644
> > > > > --- a/fs/overlayfs/copy_up.c
> > > > > +++ b/fs/overlayfs/copy_up.c
> > > > > @@ -8,6 +8,7 @@
> > > > >  #include <linux/fs.h>
> > > > >  #include <linux/slab.h>
> > > > >  #include <linux/file.h>
> > > > > +#include <linux/fileattr.h>
> > > > >  #include <linux/splice.h>
> > > > >  #include <linux/xattr.h>
> > > > >  #include <linux/security.h>
> > > > > @@ -130,6 +131,31 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
> > > > >         return error;
> > > > >  }
> > > > >
> > > > > +static int ovl_copy_fileattr(struct path *old, struct path *new)
> > > > > +{
> > > > > +       struct fileattr oldfa = { .flags_valid = true };
> > > > > +       struct fileattr newfa = { .flags_valid = true };
> > > > > +       int err;
> > > > > +
> > > > > +       err = ovl_real_fileattr(old, &oldfa, false);
> > > > > +       if (err)
> > > > > +               return err;
> > > > > +
> > > > > +       err = ovl_real_fileattr(new, &newfa, false);
> > > > > +       if (err)
> > > > > +               return err;
> > > > > +
> > > > > +       BUILD_BUG_ON(OVL_COPY_FS_FLAGS_MASK & ~FS_COMMON_FL);
> > > > > +       newfa.flags &= ~OVL_COPY_FS_FLAGS_MASK;
> > > > > +       newfa.flags |= (oldfa.flags & OVL_COPY_FS_FLAGS_MASK);
> > > > > +
> > > > > +       BUILD_BUG_ON(OVL_COPY_FSX_FLAGS_MASK & ~FS_XFLAG_COMMON);
> > > > > +       newfa.fsx_xflags &= ~OVL_COPY_FSX_FLAGS_MASK;
> > > > > +       newfa.fsx_xflags |= (oldfa.fsx_xflags & OVL_COPY_FSX_FLAGS_MASK);
> > > > > +
> > > > > +       return ovl_real_fileattr(new, &newfa, true);
> > > > > +}
> > > > > +
> > > > >  static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
> > > > >                             struct path *new, loff_t len)
> > > > >  {
> > > > > @@ -493,20 +519,21 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
> > > > >  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> > > > >  {
> > > > >         struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
> > > > > +       struct inode *inode = d_inode(c->dentry);
> > > > > +       struct path upperpath, datapath;
> > > > >         int err;
> > > > >
> > > > > +       ovl_path_upper(c->dentry, &upperpath);
> > > > > +       if (WARN_ON(upperpath.dentry != NULL))
> > > > > +               return -EIO;
> > > > > +
> > > > > +       upperpath.dentry = temp;
> > > > > +
> > > > >         /*
> > > > >          * Copy up data first and then xattrs. Writing data after
> > > > >          * xattrs will remove security.capability xattr automatically.
> > > > >          */
> > > > >         if (S_ISREG(c->stat.mode) && !c->metacopy) {
> > > > > -               struct path upperpath, datapath;
> > > > > -
> > > > > -               ovl_path_upper(c->dentry, &upperpath);
> > > > > -               if (WARN_ON(upperpath.dentry != NULL))
> > > > > -                       return -EIO;
> > > > > -               upperpath.dentry = temp;
> > > > > -
> > > > >                 ovl_path_lowerdata(c->dentry, &datapath);
> > > > >                 err = ovl_copy_up_data(ofs, &datapath, &upperpath,
> > > > >                                        c->stat.size);
> > > > > @@ -518,6 +545,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> > > > >         if (err)
> > > > >                 return err;
> > > > >
> > > > > +       if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
> > > > > +               /*
> > > > > +                * Copy the fileattr inode flags that are the source of already
> > > > > +                * copied i_flags (best effort).
> > > > > +                */
> > > > > +               ovl_copy_fileattr(&c->lowerpath, &upperpath);
> > > >
> > > > I'm not sure this should be ignoring errors.  Was this done to prevent
> > > > regressing cases where the upper fs cannot store the flags?
> > >
> > > Yes.
> > >
> > > > Do you have a concrete example?
> > >
> > > Unpriv userns mount??
> > >
> >
> > Upperfs that does not support fileattr (FUSE?)
>
> Okay, so two subcases:
>
>   - no xattr on upper
>   - no fileattr on upper
>
> FUSE is considered "remote" and overlayfs enforces xattr support, but
> not fileattr support.  So yeah, it seems theoretically these are
> possible.
>
> But I think it might be the best to risk it and return the error,
> hoping that this is such a rare corner case that there's no existing
> use.  If a regression is reported, than we need to go for a more
> complex solution where this case is detected on startup and handled
> accordingly.
>

Ok.

Thanks,
Amir.
