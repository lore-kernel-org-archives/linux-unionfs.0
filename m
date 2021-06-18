Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4243CC48BDF
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Jun 2021 15:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25F7B611CD
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Jun 2021 15:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbhFRP4q (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 11:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbhFRP4p (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 18 Jun 2021 11:56:45 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F775C061574
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Jun 2021 08:54:36 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id x12so8820977ill.4
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Jun 2021 08:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4CNOYKipnnJE/g/wWXgG15FFiKmS2uUgf7FSKMVOjr4=;
        b=ozvqHo6UoLcLInq6lSFo3RrycNkPtwK/2JQj0WPG3MZeU0cBHuGW9/ancWcF5nzHkQ
         t7YZBHYbcI3Xv+d6x2AO4qLil/wvig2sWzCSTpo4guAYsoIbd2b7NvSNMpLbJ/mUG6Z4
         L+6UofcD9onDy/LvfNsSFVh0cSHyV8/vYXDlU9tLz68I9XF3szZ1Qs5c0SPndbgEYoCE
         KMFqStOyfT/2UcE15U/DFewk47MN4VfwF0yo8xmtI+/Bb1nzH2WrA1VnhdZZVuBaNml7
         hh2OTQGGVFWUphfCt91N4xEZvazIYD/mWUNtg0u+CSadf7PbAQ/NV6ukeEmKOiTKEaGX
         hXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4CNOYKipnnJE/g/wWXgG15FFiKmS2uUgf7FSKMVOjr4=;
        b=pGnr6eUo5aY9DrHOkLVa34lC1Uyt8BW0vep7Wd82Z/4cDSwHErTrISBw58QXTEL7jW
         EgMP7oSyLYgcaxFQfGirMhen5t3tzjygOdZL/QQDQ+EIJBzJlydXvQqeOxDsNIgu/XmK
         dv+yaqqWJxyQwBREx7euDz/TH2yvC+JDqMT5Mn6AhnISovPoC5rr5CNYE1kRnoRClRJv
         X6HMvWc0W0ni0mjBuIyHi7M89Wb++ObZn0/AcqNVy5RgiWOdJpWRdVVE8nMkX4rHDF8Y
         CY0Bqut2pObb1kzXdAm9ewNmdTdMTpITDLwZHvbwrAP+w5AIt8rIclrlxlSR+uVUjbpF
         Gg2A==
X-Gm-Message-State: AOAM533oRnFSe3FXMddWxp/BzUV8zkm6DF8h+JeB68MU0YTMlZoHl7GK
        B/gMnRnBSCYhLsFuQgu09uskev89UeIwZMgsba1FosW/a2k=
X-Google-Smtp-Source: ABdhPJxeIKlQIGALx06+P3Zx6/rt3ANx9Cgfnyniwt0Ctb0x05k66e+e3/lMWU234w/JsLH85diItwhmhJJluOtAsUw=
X-Received: by 2002:a92:874b:: with SMTP id d11mr7557931ilm.137.1624031675614;
 Fri, 18 Jun 2021 08:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210617152241.987010-1-amir73il@gmail.com> <20210617152241.987010-4-amir73il@gmail.com>
 <CAJfpegv9e1oTyu+9Z-TyZQmNG0NrJhokXd8UbaRNft3_bwBEjQ@mail.gmail.com>
In-Reply-To: <CAJfpegv9e1oTyu+9Z-TyZQmNG0NrJhokXd8UbaRNft3_bwBEjQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 18 Jun 2021 18:54:24 +0300
Message-ID: <CAOQ4uxgdWwrOa79BRzZ1PS6SxmLtywQCAr3+WLRZPx38aHHyQw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: consistent behavior for immutable/append-only inodes
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 18, 2021 at 4:57 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, 17 Jun 2021 at 17:22, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > Instead, if any of the fileattr flags of interest exist on the lower
> > inode, we store them in overlay.xflags xattr on the upper inode and we
> > we read the flags from xattr on lookup and on fileattr_get().
>
> Calling this xflags, especially near fileattr code, makes it easy to
> confuse with fsx_xflags.   Can we find a more distinctive name?
>

Indeed. I'll change to overlay.protected as suggested in the v1
patch discussion.

> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index aec353a2dc80..d66e51b9c347 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -162,7 +162,8 @@ int ovl_getattr(struct user_namespace *mnt_userns, const struct path *path,
> >         enum ovl_path_type type;
> >         struct path realpath;
> >         const struct cred *old_cred;
> > -       bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
> > +       struct inode *inode = d_inode(dentry);
> > +       bool is_dir = S_ISDIR(inode->i_mode);
> >         int fsid = 0;
> >         int err;
> >         bool metacopy_blocks = false;
> > @@ -175,6 +176,10 @@ int ovl_getattr(struct user_namespace *mnt_userns, const struct path *path,
> >         if (err)
> >                 goto out;
> >
> > +       /* Report immutable/append-only STATX flags */
> > +       if (ovl_test_flag(OVL_XFLAGS, inode))
> > +               ovl_fill_xflags(inode, stat, NULL);
> > +
>
> Filesystems are doing these transformations: (already down one from
> before fileattr)
>
> internal flags -> statx->attributes
> internal flags -> inode->i_flags
> internal flags <-> fa->flags or fa->fsx_xflags
>
> To further improve this situation the statx filling could be moved to
> generic code based on i_flags.  I'm not asking you to convert all
> filesystems (though that would be nice), but adding the helpers and
> using them here would be a good first step.
>

I am afraid that the only flags this would be relevant to are (a) and (i),
so not sure it is worth the generic helper, but I will look into it.

> > @@ -639,6 +642,174 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
> >         return err;
> >  }
> >
> > +
> > +/*
> > + * Overlayfs stores immutable/append-only attributes in overlay.xflags xattr.
> > + * If upper inode does have those fileattr flags set (i.e. from old kernel),
> > + * overlayfs does not clear them on fileattr_get(), but it will clear them on
> > + * fileattr_set().
> > + */
> > +#define OVL_XFLAG(c, x) \
> > +       { c, S_ ## x, FS_ ## x ## _FL, FS_XFLAG_ ## x, STATX_ATTR_ ## x }
> > +
> > +struct ovl_xflag {
> > +       char code;
> > +       u32 i_flag;
> > +       u32 fs_flag;
> > +       u32 fsx_flag;
> > +       u64 statx_attr;
> > +} const ovl_xflags[] = {
> > +       OVL_XFLAG('a', APPEND),
> > +       OVL_XFLAG('i', IMMUTABLE),
> > +};
>
> This would be really nice for a dozen flags, but for two...
>
> My guess is that many lines of code could be saved by un-generalizing this.
>

Perhaps. I'll try.

> > +/* Set inode flags and xflags xattr from fileattr */
> > +int ovl_set_xflags(struct inode *inode, struct dentry *upper,
> > +                  struct fileattr *fa)
> > +{
> > +       struct ovl_fs *ofs = OVL_FS(inode->i_sb);
> > +       char buf[OVL_XFLAGS_NUM];
> > +       int len, err = 0;
> > +
> > +       BUILD_BUG_ON(OVL_XFLAGS_NUM >= OVL_XFLAGS_MAX);
> > +       len = ovl_xflags_to_buf(inode, buf, OVL_XFLAGS_NUM, fa);
> > +
> > +       /*
> > +        * Do not fail when upper doesn't support xattrs, but also do not
> > +        * mask out the xattr xflags from real fileattr to continue
> > +        * supporting fileattr_set() on fs without xattr support.
> > +        * Remove xattr if it exist and all flags are cleared.
> > +        */
>
> Does this matter in practice?   I.e. is there any filesystem with
> immutable/append attribute but not xattr that could be an upper layer?

I did not find any, but did not want to take the risk, because maybe
there is a fs that does not support trusted.xattr but does support fileattr -
I did not check that. And the fallback seemed pretty safe to me.
I am also fine with failing fileattr_set() in that case.

>
> If yes, then this could end up as a copy-up regression (failure to
> copy up files having immutable/append).

No, because ovl_copy_xflags() always masks those flags on copy up:

        BUILD_BUG_ON(OVL_COPY_FS_FLAGS_MASK & ~FS_COMMON_FL);
        newfa.flags &= ~OVL_COPY_FS_FLAGS_MASK;
        newfa.flags |= (oldfa.flags & OVL_COPY_FS_FLAGS_MASK);

        BUILD_BUG_ON(OVL_COPY_FSX_FLAGS_MASK & ~FS_XFLAG_COMMON);
        newfa.fsx_xflags &= ~OVL_COPY_FSX_FLAGS_MASK;
        newfa.fsx_xflags |= (oldfa.fsx_xflags & OVL_COPY_FSX_FLAGS_MASK);

The comment above about not clearing the immutable flag is referring
specifically to fileattr_set().

Thanks,
Amir.
