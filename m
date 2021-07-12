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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C3DC07E99
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jul 2021 15:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8F16610C7
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jul 2021 15:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhGLPzd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 11:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhGLPzd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jul 2021 11:55:33 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3A4C0613DD
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jul 2021 08:52:44 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id z1so20053512ils.0
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jul 2021 08:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5WFfG812zU8BnmAfzDQ+5zeuRk6DO6905dVJ+yu7X0Y=;
        b=EzG7I8Z5dlarBd/dClq6Q3GYYua3hTRrHcIMqNeSgCWJy2aVi/PU33HYlCIvL0UOk3
         zESeM8Rqn+r4SiF0H27c7iDiGszNZcF9eJEMuX4LrQ7X3U2wH9WbeXDwsqNej8FfYdNI
         AQoEXvH/mkc1f5trGSuSJ/vv67wZ3U7umSRCQfKTH1pWX7n7GahYry0XZKFEGLtQdvUY
         edb7kH4LVig+20UqGPs9h98f8jNsZZ4OczUIjFP61hDWcwtNu2AzVtjZ4NPcpVJRTO9H
         GnROTKpCImCuLfxd6LISaMo7T4xJmeQhvteL2ECm2mI+96CQ+T4WMJVhKw2Yp5wep1eS
         37Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5WFfG812zU8BnmAfzDQ+5zeuRk6DO6905dVJ+yu7X0Y=;
        b=WccR+jFtICHqfUhi2yJUyapW1b1UIR8/dsC7Lsco8QCuEp8/3lDFscggCBiSu/WeFR
         MvuHQWffBXEZmDArXHjp/iqqSPCFG1YkRCbnN7wOnhLhYn0OnmrlM4AjVkwq/U3bFtSZ
         GXyu5WORvhgdcuQSUmzyJrhN3uGb148pGxD9FrcF4/Oiia5TP5/9Hc6/Lez6brYAVjB1
         7BWw67N32Ek9EaSsWZ4KzNALP1GEbmkvaNjCW5BC5zkwPys+Mj1FAYjdlvdYbhtFC2Lp
         gEsPgeBdd5uXIw+Yzv3M9WbcQlvVAJVMxUz9YnpZqxrJmE/OuGn7TJQiyx0jSQjSsb3C
         JT/Q==
X-Gm-Message-State: AOAM5335L0evhJ+AmZSmqraqb3q5bQaC7g/+YMn6RgEREiGcZuKFTmkZ
        D+QjAPuHob1dtI0VzJWRAt8KCLJCMw6kzP4u+QQ=
X-Google-Smtp-Source: ABdhPJyJsfQ9viGu/GBMjNA+ulntq4qAS9NWo2NvO+M7P1rSKGwdZSAocje+80HyTFEMSXBzYvL4AzZvMncoe7bH50w=
X-Received: by 2002:a92:4442:: with SMTP id a2mr18502807ilm.72.1626105164244;
 Mon, 12 Jul 2021 08:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210619092619.1107608-1-amir73il@gmail.com> <20210619092619.1107608-4-amir73il@gmail.com>
 <CAJfpegv89zStsDSWmY39YiF=aZVyO=rOYFU5_VBHxu-H_h-_dQ@mail.gmail.com> <CAOQ4uxiWRWtkFixLU72Bu9_o+hncsX0VQczpbVXkOZG3K8UAxQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiWRWtkFixLU72Bu9_o+hncsX0VQczpbVXkOZG3K8UAxQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 12 Jul 2021 18:52:32 +0300
Message-ID: <CAOQ4uxgQuhPck2psKsROoVUprPw62kV46MFv_4SHWU+s11xH3w@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: copy up sync/noatime fileattr flags
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 12, 2021 at 6:51 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jul 12, 2021 at 5:20 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Sat, 19 Jun 2021 at 11:26, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > When a lower file has sync/noatime fileattr flags, the behavior of
> > > overlayfs post copy up is inconsistent.
> > >
> > > Immediattely after copy up, ovl inode still has the S_SYNC/S_NOATIME
> > > inode flags copied from lower inode, so vfs code still treats the ovl
> > > inode as sync/noatime.  After ovl inode evict or mount cycle,
> > > the ovl inode does not have these inode flags anymore.
> > >
> > > To fix this inconsitency, try to copy the fileattr flags on copy up
> > > if the upper fs supports the fileattr_set() method.
> > >
> > > This gives consistent behavior post copy up regardless of inode eviction
> > > from cache.
> > >
> > > We cannot copy up the immutable/append-only inode flags in a similar
> > > manner, because immutable/append-only inodes cannot be linked and because
> > > overlayfs will not be able to set overlay.* xattr on the upper inodes.
> > >
> > > Those flags will be addressed by a followup patch.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/overlayfs/copy_up.c   | 49 ++++++++++++++++++++++++++++++++++------
> > >  fs/overlayfs/inode.c     | 36 ++++++++++++++++++-----------
> > >  fs/overlayfs/overlayfs.h | 14 +++++++++++-
> > >  3 files changed, 78 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > index 3fa68a5cc16e..a06b423ca5d1 100644
> > > --- a/fs/overlayfs/copy_up.c
> > > +++ b/fs/overlayfs/copy_up.c
> > > @@ -8,6 +8,7 @@
> > >  #include <linux/fs.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/file.h>
> > > +#include <linux/fileattr.h>
> > >  #include <linux/splice.h>
> > >  #include <linux/xattr.h>
> > >  #include <linux/security.h>
> > > @@ -130,6 +131,31 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
> > >         return error;
> > >  }
> > >
> > > +static int ovl_copy_fileattr(struct path *old, struct path *new)
> > > +{
> > > +       struct fileattr oldfa = { .flags_valid = true };
> > > +       struct fileattr newfa = { .flags_valid = true };
> > > +       int err;
> > > +
> > > +       err = ovl_real_fileattr(old, &oldfa, false);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       err = ovl_real_fileattr(new, &newfa, false);
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       BUILD_BUG_ON(OVL_COPY_FS_FLAGS_MASK & ~FS_COMMON_FL);
> > > +       newfa.flags &= ~OVL_COPY_FS_FLAGS_MASK;
> > > +       newfa.flags |= (oldfa.flags & OVL_COPY_FS_FLAGS_MASK);
> > > +
> > > +       BUILD_BUG_ON(OVL_COPY_FSX_FLAGS_MASK & ~FS_XFLAG_COMMON);
> > > +       newfa.fsx_xflags &= ~OVL_COPY_FSX_FLAGS_MASK;
> > > +       newfa.fsx_xflags |= (oldfa.fsx_xflags & OVL_COPY_FSX_FLAGS_MASK);
> > > +
> > > +       return ovl_real_fileattr(new, &newfa, true);
> > > +}
> > > +
> > >  static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
> > >                             struct path *new, loff_t len)
> > >  {
> > > @@ -493,20 +519,21 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
> > >  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> > >  {
> > >         struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
> > > +       struct inode *inode = d_inode(c->dentry);
> > > +       struct path upperpath, datapath;
> > >         int err;
> > >
> > > +       ovl_path_upper(c->dentry, &upperpath);
> > > +       if (WARN_ON(upperpath.dentry != NULL))
> > > +               return -EIO;
> > > +
> > > +       upperpath.dentry = temp;
> > > +
> > >         /*
> > >          * Copy up data first and then xattrs. Writing data after
> > >          * xattrs will remove security.capability xattr automatically.
> > >          */
> > >         if (S_ISREG(c->stat.mode) && !c->metacopy) {
> > > -               struct path upperpath, datapath;
> > > -
> > > -               ovl_path_upper(c->dentry, &upperpath);
> > > -               if (WARN_ON(upperpath.dentry != NULL))
> > > -                       return -EIO;
> > > -               upperpath.dentry = temp;
> > > -
> > >                 ovl_path_lowerdata(c->dentry, &datapath);
> > >                 err = ovl_copy_up_data(ofs, &datapath, &upperpath,
> > >                                        c->stat.size);
> > > @@ -518,6 +545,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> > >         if (err)
> > >                 return err;
> > >
> > > +       if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
> > > +               /*
> > > +                * Copy the fileattr inode flags that are the source of already
> > > +                * copied i_flags (best effort).
> > > +                */
> > > +               ovl_copy_fileattr(&c->lowerpath, &upperpath);
> >
> > I'm not sure this should be ignoring errors.  Was this done to prevent
> > regressing cases where the upper fs cannot store the flags?
>
> Yes.
>
> > Do you have a concrete example?
>
> Unpriv userns mount??
>

Upperfs that does not support fileattr (FUSE?)

Thanks,
Amir.
