Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05DFC07E99
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jul 2021 15:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 824BA610C7
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jul 2021 15:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhGLPy0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 11:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhGLPyY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jul 2021 11:54:24 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75073C0613DD
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jul 2021 08:51:36 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id w1so17985101ilg.10
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jul 2021 08:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OfVhWb443OHSC+sLhcw7Uw8aw/e1Pl94OuR+MVu2r3Y=;
        b=e+5D5x39YkcRLshFcdRuyRuvk2jkwIQwHBvM9LJsL3maYn19WTqNmcdu2EKGdKOTlF
         FzgiZZHhTO+SgmnrFkSBQX37gPyYX6mXnZzIl5b91zLX0OHN/LyWqerbttph31W4Kucp
         lC0dIuVCHEz2VvWJFH47/V14UD7NVjRZWr86OxHJ2u7lMtUpWGdhaPzycVF8D7Y5yT70
         41I2UNG8w/+8q2IaxlvfIHbdkVVWkenQrlVGLjggRZTNVe2ayL7NTYmJJrioJG3YxmLd
         LZy3+/6Y+aTLF+OKL+X1ybCPQ+JR9A5BHyphfC4U4YMALo+uPh4u642Utri2WghYd5uK
         B/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OfVhWb443OHSC+sLhcw7Uw8aw/e1Pl94OuR+MVu2r3Y=;
        b=azm3j/Cdb5EXtzsiqOukidUM0hJib9hTYrFKA9o6Bku2nsz1dKb0qX+xm2bcizmSCk
         4IOQurnuhqPYy1EeHGzILeCMM/7iLApj2YMHbMJ80eoTgJ6MK4DW7LtIjWBkI1ySrKQH
         xaUSDu1lUXcifLq87kzK3k0fnooDqCGhr9a2CwexnfWAEJM6m5sZmJU1gf9fWE6sHvv2
         XGJPe+FJaIIEpspJcB2/yKkSIaXrDvq1B6idbL+OpiNI63JStjDjCtGaYHC2G91UTmGQ
         JL5OtjpLtvx9ncmpN3qUIfCwKYYjSCtLlJI8t04r3Nu7ubcDhb3hMB/AgS3P+v2NArdP
         gGRg==
X-Gm-Message-State: AOAM530QmA91xWC234uRBKw/YYG88NvmeJayRwbJlHtTh4mlIwHN+cGD
        o0dvOZTBv7hCRqkJtfk9k/eG5vmyvM2Wyih9Pog=
X-Google-Smtp-Source: ABdhPJw1kGXNTexOYUP8Z/juJBoXIAu5hIJ1Rwjqvnc+75ooYuXIU8bDdUUuYv+BcxAnnsFGSMtHvNhVheJY8BRcgBM=
X-Received: by 2002:a05:6e02:1c2d:: with SMTP id m13mr4711436ilh.137.1626105095880;
 Mon, 12 Jul 2021 08:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210619092619.1107608-1-amir73il@gmail.com> <20210619092619.1107608-4-amir73il@gmail.com>
 <CAJfpegv89zStsDSWmY39YiF=aZVyO=rOYFU5_VBHxu-H_h-_dQ@mail.gmail.com>
In-Reply-To: <CAJfpegv89zStsDSWmY39YiF=aZVyO=rOYFU5_VBHxu-H_h-_dQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 12 Jul 2021 18:51:25 +0300
Message-ID: <CAOQ4uxiWRWtkFixLU72Bu9_o+hncsX0VQczpbVXkOZG3K8UAxQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: copy up sync/noatime fileattr flags
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 12, 2021 at 5:20 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sat, 19 Jun 2021 at 11:26, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > When a lower file has sync/noatime fileattr flags, the behavior of
> > overlayfs post copy up is inconsistent.
> >
> > Immediattely after copy up, ovl inode still has the S_SYNC/S_NOATIME
> > inode flags copied from lower inode, so vfs code still treats the ovl
> > inode as sync/noatime.  After ovl inode evict or mount cycle,
> > the ovl inode does not have these inode flags anymore.
> >
> > To fix this inconsitency, try to copy the fileattr flags on copy up
> > if the upper fs supports the fileattr_set() method.
> >
> > This gives consistent behavior post copy up regardless of inode eviction
> > from cache.
> >
> > We cannot copy up the immutable/append-only inode flags in a similar
> > manner, because immutable/append-only inodes cannot be linked and because
> > overlayfs will not be able to set overlay.* xattr on the upper inodes.
> >
> > Those flags will be addressed by a followup patch.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/copy_up.c   | 49 ++++++++++++++++++++++++++++++++++------
> >  fs/overlayfs/inode.c     | 36 ++++++++++++++++++-----------
> >  fs/overlayfs/overlayfs.h | 14 +++++++++++-
> >  3 files changed, 78 insertions(+), 21 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 3fa68a5cc16e..a06b423ca5d1 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/fs.h>
> >  #include <linux/slab.h>
> >  #include <linux/file.h>
> > +#include <linux/fileattr.h>
> >  #include <linux/splice.h>
> >  #include <linux/xattr.h>
> >  #include <linux/security.h>
> > @@ -130,6 +131,31 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
> >         return error;
> >  }
> >
> > +static int ovl_copy_fileattr(struct path *old, struct path *new)
> > +{
> > +       struct fileattr oldfa = { .flags_valid = true };
> > +       struct fileattr newfa = { .flags_valid = true };
> > +       int err;
> > +
> > +       err = ovl_real_fileattr(old, &oldfa, false);
> > +       if (err)
> > +               return err;
> > +
> > +       err = ovl_real_fileattr(new, &newfa, false);
> > +       if (err)
> > +               return err;
> > +
> > +       BUILD_BUG_ON(OVL_COPY_FS_FLAGS_MASK & ~FS_COMMON_FL);
> > +       newfa.flags &= ~OVL_COPY_FS_FLAGS_MASK;
> > +       newfa.flags |= (oldfa.flags & OVL_COPY_FS_FLAGS_MASK);
> > +
> > +       BUILD_BUG_ON(OVL_COPY_FSX_FLAGS_MASK & ~FS_XFLAG_COMMON);
> > +       newfa.fsx_xflags &= ~OVL_COPY_FSX_FLAGS_MASK;
> > +       newfa.fsx_xflags |= (oldfa.fsx_xflags & OVL_COPY_FSX_FLAGS_MASK);
> > +
> > +       return ovl_real_fileattr(new, &newfa, true);
> > +}
> > +
> >  static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
> >                             struct path *new, loff_t len)
> >  {
> > @@ -493,20 +519,21 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
> >  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >  {
> >         struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
> > +       struct inode *inode = d_inode(c->dentry);
> > +       struct path upperpath, datapath;
> >         int err;
> >
> > +       ovl_path_upper(c->dentry, &upperpath);
> > +       if (WARN_ON(upperpath.dentry != NULL))
> > +               return -EIO;
> > +
> > +       upperpath.dentry = temp;
> > +
> >         /*
> >          * Copy up data first and then xattrs. Writing data after
> >          * xattrs will remove security.capability xattr automatically.
> >          */
> >         if (S_ISREG(c->stat.mode) && !c->metacopy) {
> > -               struct path upperpath, datapath;
> > -
> > -               ovl_path_upper(c->dentry, &upperpath);
> > -               if (WARN_ON(upperpath.dentry != NULL))
> > -                       return -EIO;
> > -               upperpath.dentry = temp;
> > -
> >                 ovl_path_lowerdata(c->dentry, &datapath);
> >                 err = ovl_copy_up_data(ofs, &datapath, &upperpath,
> >                                        c->stat.size);
> > @@ -518,6 +545,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >         if (err)
> >                 return err;
> >
> > +       if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
> > +               /*
> > +                * Copy the fileattr inode flags that are the source of already
> > +                * copied i_flags (best effort).
> > +                */
> > +               ovl_copy_fileattr(&c->lowerpath, &upperpath);
>
> I'm not sure this should be ignoring errors.  Was this done to prevent
> regressing cases where the upper fs cannot store the flags?

Yes.

> Do you have a concrete example?

Unpriv userns mount??

Thanks,
Amir.
