Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93782C07E9A
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jul 2021 08:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C76B61003
	for <linux-unionfs@archiver.kernel.org>; Wed, 14 Jul 2021 08:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238667AbhGNIuZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 04:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238432AbhGNIuY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jul 2021 04:50:24 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07130C061760
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jul 2021 01:47:33 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id n201so309271vke.7
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jul 2021 01:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bbboInCcDAT4fQTPlvyUGsIijU2++w2L6+XFYyih3uo=;
        b=ldoL9ymov2SUJ4qvraR7i09G91Pst7q0tY/QGekfDhy8PGYqPP+hSzfFHugJ5PFu0I
         om+8YtfVdtNA4HbhCaHV/qv3xPAJJbQV9NWHliMIkp8m5GEs2f0oiOCkteI9Ha3UachJ
         2uVWu1j5+lqGbNAQi4ploy1z3qivgJngKvpUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bbboInCcDAT4fQTPlvyUGsIijU2++w2L6+XFYyih3uo=;
        b=nMbqQl9MRkejp7KkRBMryGHk6HSW/uqbv7yZoQZl8BLzmNEAVJbI6Hy47oAVJtlGaQ
         7POhjbcrxvcVYUWi4fhyS8cc3R5SroWp4nQNTQI6yOAMj0f4CvNPg1sgtdkEZy+HogxW
         3y5LMglJE4oWFiSG1V26aMrjS1J7mu6LpZTjCpqgrCOdMXrHq0fU7AegjFxRTK0EAWo9
         JujBYC4wlB+yCudFTI6z86w7w2gUF18AzRFsZPbP/1JwWW17lsC1rXNKhasGdIvwW4AL
         TCRtwe8XCuWpMXrvg7RlmRg7B2DOYZgEDajox60vjmxxPFTdYKaCamXekJ0R0/KiWpxK
         p7Yw==
X-Gm-Message-State: AOAM530RswyjL0bKQm8wCUV5ZptW89rfPp/puCeTLGDm3rfLwbzCzA7d
        cP7ToKogwQOskTMGUTyE26b37gy6H2rZvr8hXdGE3w==
X-Google-Smtp-Source: ABdhPJwaIvPYw2wMS6yjb7Y6uNCCSjozuL7uUrsuT+UnInqP8Ri2woMxk0Q6LPVjTju1Jbj+sNXOxzP2vFPw3yfBzXw=
X-Received: by 2002:a1f:e3c2:: with SMTP id a185mr10675433vkh.3.1626252452102;
 Wed, 14 Jul 2021 01:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210619092619.1107608-1-amir73il@gmail.com> <20210619092619.1107608-4-amir73il@gmail.com>
 <CAJfpegv89zStsDSWmY39YiF=aZVyO=rOYFU5_VBHxu-H_h-_dQ@mail.gmail.com>
 <CAOQ4uxiWRWtkFixLU72Bu9_o+hncsX0VQczpbVXkOZG3K8UAxQ@mail.gmail.com> <CAOQ4uxgQuhPck2psKsROoVUprPw62kV46MFv_4SHWU+s11xH3w@mail.gmail.com>
In-Reply-To: <CAOQ4uxgQuhPck2psKsROoVUprPw62kV46MFv_4SHWU+s11xH3w@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 14 Jul 2021 10:47:21 +0200
Message-ID: <CAJfpegvpk-4SPPi2NM6ZnuDZNxcPK=4+JapxtLf_oYiCvuScrw@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: copy up sync/noatime fileattr flags
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 12 Jul 2021 at 17:52, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 6:51 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Jul 12, 2021 at 5:20 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Sat, 19 Jun 2021 at 11:26, Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > When a lower file has sync/noatime fileattr flags, the behavior of
> > > > overlayfs post copy up is inconsistent.
> > > >
> > > > Immediattely after copy up, ovl inode still has the S_SYNC/S_NOATIME
> > > > inode flags copied from lower inode, so vfs code still treats the ovl
> > > > inode as sync/noatime.  After ovl inode evict or mount cycle,
> > > > the ovl inode does not have these inode flags anymore.
> > > >
> > > > To fix this inconsitency, try to copy the fileattr flags on copy up
> > > > if the upper fs supports the fileattr_set() method.
> > > >
> > > > This gives consistent behavior post copy up regardless of inode eviction
> > > > from cache.
> > > >
> > > > We cannot copy up the immutable/append-only inode flags in a similar
> > > > manner, because immutable/append-only inodes cannot be linked and because
> > > > overlayfs will not be able to set overlay.* xattr on the upper inodes.
> > > >
> > > > Those flags will be addressed by a followup patch.
> > > >
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >  fs/overlayfs/copy_up.c   | 49 ++++++++++++++++++++++++++++++++++------
> > > >  fs/overlayfs/inode.c     | 36 ++++++++++++++++++-----------
> > > >  fs/overlayfs/overlayfs.h | 14 +++++++++++-
> > > >  3 files changed, 78 insertions(+), 21 deletions(-)
> > > >
> > > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > > index 3fa68a5cc16e..a06b423ca5d1 100644
> > > > --- a/fs/overlayfs/copy_up.c
> > > > +++ b/fs/overlayfs/copy_up.c
> > > > @@ -8,6 +8,7 @@
> > > >  #include <linux/fs.h>
> > > >  #include <linux/slab.h>
> > > >  #include <linux/file.h>
> > > > +#include <linux/fileattr.h>
> > > >  #include <linux/splice.h>
> > > >  #include <linux/xattr.h>
> > > >  #include <linux/security.h>
> > > > @@ -130,6 +131,31 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
> > > >         return error;
> > > >  }
> > > >
> > > > +static int ovl_copy_fileattr(struct path *old, struct path *new)
> > > > +{
> > > > +       struct fileattr oldfa = { .flags_valid = true };
> > > > +       struct fileattr newfa = { .flags_valid = true };
> > > > +       int err;
> > > > +
> > > > +       err = ovl_real_fileattr(old, &oldfa, false);
> > > > +       if (err)
> > > > +               return err;
> > > > +
> > > > +       err = ovl_real_fileattr(new, &newfa, false);
> > > > +       if (err)
> > > > +               return err;
> > > > +
> > > > +       BUILD_BUG_ON(OVL_COPY_FS_FLAGS_MASK & ~FS_COMMON_FL);
> > > > +       newfa.flags &= ~OVL_COPY_FS_FLAGS_MASK;
> > > > +       newfa.flags |= (oldfa.flags & OVL_COPY_FS_FLAGS_MASK);
> > > > +
> > > > +       BUILD_BUG_ON(OVL_COPY_FSX_FLAGS_MASK & ~FS_XFLAG_COMMON);
> > > > +       newfa.fsx_xflags &= ~OVL_COPY_FSX_FLAGS_MASK;
> > > > +       newfa.fsx_xflags |= (oldfa.fsx_xflags & OVL_COPY_FSX_FLAGS_MASK);
> > > > +
> > > > +       return ovl_real_fileattr(new, &newfa, true);
> > > > +}
> > > > +
> > > >  static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
> > > >                             struct path *new, loff_t len)
> > > >  {
> > > > @@ -493,20 +519,21 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
> > > >  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> > > >  {
> > > >         struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
> > > > +       struct inode *inode = d_inode(c->dentry);
> > > > +       struct path upperpath, datapath;
> > > >         int err;
> > > >
> > > > +       ovl_path_upper(c->dentry, &upperpath);
> > > > +       if (WARN_ON(upperpath.dentry != NULL))
> > > > +               return -EIO;
> > > > +
> > > > +       upperpath.dentry = temp;
> > > > +
> > > >         /*
> > > >          * Copy up data first and then xattrs. Writing data after
> > > >          * xattrs will remove security.capability xattr automatically.
> > > >          */
> > > >         if (S_ISREG(c->stat.mode) && !c->metacopy) {
> > > > -               struct path upperpath, datapath;
> > > > -
> > > > -               ovl_path_upper(c->dentry, &upperpath);
> > > > -               if (WARN_ON(upperpath.dentry != NULL))
> > > > -                       return -EIO;
> > > > -               upperpath.dentry = temp;
> > > > -
> > > >                 ovl_path_lowerdata(c->dentry, &datapath);
> > > >                 err = ovl_copy_up_data(ofs, &datapath, &upperpath,
> > > >                                        c->stat.size);
> > > > @@ -518,6 +545,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> > > >         if (err)
> > > >                 return err;
> > > >
> > > > +       if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
> > > > +               /*
> > > > +                * Copy the fileattr inode flags that are the source of already
> > > > +                * copied i_flags (best effort).
> > > > +                */
> > > > +               ovl_copy_fileattr(&c->lowerpath, &upperpath);
> > >
> > > I'm not sure this should be ignoring errors.  Was this done to prevent
> > > regressing cases where the upper fs cannot store the flags?
> >
> > Yes.
> >
> > > Do you have a concrete example?
> >
> > Unpriv userns mount??
> >
>
> Upperfs that does not support fileattr (FUSE?)

Okay, so two subcases:

  - no xattr on upper
  - no fileattr on upper

FUSE is considered "remote" and overlayfs enforces xattr support, but
not fileattr support.  So yeah, it seems theoretically these are
possible.

But I think it might be the best to risk it and return the error,
hoping that this is such a rare corner case that there's no existing
use.  If a regression is reported, than we need to go for a more
complex solution where this case is detected on startup and handled
accordingly.

Thanks,
Miklos
