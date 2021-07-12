Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65ABC07E99
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jul 2021 14:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C82FC610A7
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jul 2021 14:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhGLOXN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 10:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbhGLOXN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jul 2021 10:23:13 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDA2C0613DD
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jul 2021 07:20:24 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id x20so4032080vkd.5
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jul 2021 07:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g2tAJ7328pjl9NHo3ZXAAJRugt7w/yW/YtiqrQtM6wk=;
        b=C5Y37cqMgOajqGw9evucSwpfw4JX6wTqfC1j+OkuJrRVzhtC0GTWbl8f9ribewL7Em
         bQZ8DEFq20dXj0DPzh5OsZSFiZc39uJmjcxsHE7C+f3RfayZ0yXft9ETPLL15q+96AUm
         JOH/lqKqKEtEnCln8Uwha7paISbJN5pJkCA5c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g2tAJ7328pjl9NHo3ZXAAJRugt7w/yW/YtiqrQtM6wk=;
        b=S/VadfXYBu4w2zNRyXXCj2PflR3/33giyZL9Diji2Pqxxl46B7qXK1Q8pWhyQmQQMV
         04NBvHtx+hitCb2lnecLuQ0GqNjetkYhPvvKv0+bPJWvC2LpQmS2DApR7x/SkKcTgNPX
         k7745XDwiMCeockBsTo2v30g1HzFUDaWXG72DZd1+gFL82kSY3OhgjOeu39VVxnlGCLj
         9/FSO2/Ki3Lj73qGbtSzNyfOe0SE5mEre/QcxUPK1+rcXOdFl0GfQWZ1gNkZVriDSr6N
         ivJ80jzfnSGVn+eMTG0F1wOTsXPqUvDOCvzd2pRQxZft9QExhg9yWiabYey6vh3eJGpt
         qJzA==
X-Gm-Message-State: AOAM530uOoDBPp4fpKIiLBVXH7/CRBu7HiQRvz9BeV/6FNd7H4AmUT6o
        WPbzHgotKrC59l8Q5XtfataCgENzS/2DCVcDfG+wGMX+BPY6BA==
X-Google-Smtp-Source: ABdhPJx5JvyiXIL6H1k30PvYy2NKz6RY0WaDl+dvu8xX1xzpq2S58S4ymdTTo684A5Yi7D1hSYklWet48elS9CDzH4Y=
X-Received: by 2002:a05:6122:786:: with SMTP id k6mr40387797vkr.19.1626099623819;
 Mon, 12 Jul 2021 07:20:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210619092619.1107608-1-amir73il@gmail.com> <20210619092619.1107608-4-amir73il@gmail.com>
In-Reply-To: <20210619092619.1107608-4-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 12 Jul 2021 16:20:12 +0200
Message-ID: <CAJfpegv89zStsDSWmY39YiF=aZVyO=rOYFU5_VBHxu-H_h-_dQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: copy up sync/noatime fileattr flags
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 19 Jun 2021 at 11:26, Amir Goldstein <amir73il@gmail.com> wrote:
>
> When a lower file has sync/noatime fileattr flags, the behavior of
> overlayfs post copy up is inconsistent.
>
> Immediattely after copy up, ovl inode still has the S_SYNC/S_NOATIME
> inode flags copied from lower inode, so vfs code still treats the ovl
> inode as sync/noatime.  After ovl inode evict or mount cycle,
> the ovl inode does not have these inode flags anymore.
>
> To fix this inconsitency, try to copy the fileattr flags on copy up
> if the upper fs supports the fileattr_set() method.
>
> This gives consistent behavior post copy up regardless of inode eviction
> from cache.
>
> We cannot copy up the immutable/append-only inode flags in a similar
> manner, because immutable/append-only inodes cannot be linked and because
> overlayfs will not be able to set overlay.* xattr on the upper inodes.
>
> Those flags will be addressed by a followup patch.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c   | 49 ++++++++++++++++++++++++++++++++++------
>  fs/overlayfs/inode.c     | 36 ++++++++++++++++++-----------
>  fs/overlayfs/overlayfs.h | 14 +++++++++++-
>  3 files changed, 78 insertions(+), 21 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 3fa68a5cc16e..a06b423ca5d1 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -8,6 +8,7 @@
>  #include <linux/fs.h>
>  #include <linux/slab.h>
>  #include <linux/file.h>
> +#include <linux/fileattr.h>
>  #include <linux/splice.h>
>  #include <linux/xattr.h>
>  #include <linux/security.h>
> @@ -130,6 +131,31 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
>         return error;
>  }
>
> +static int ovl_copy_fileattr(struct path *old, struct path *new)
> +{
> +       struct fileattr oldfa = { .flags_valid = true };
> +       struct fileattr newfa = { .flags_valid = true };
> +       int err;
> +
> +       err = ovl_real_fileattr(old, &oldfa, false);
> +       if (err)
> +               return err;
> +
> +       err = ovl_real_fileattr(new, &newfa, false);
> +       if (err)
> +               return err;
> +
> +       BUILD_BUG_ON(OVL_COPY_FS_FLAGS_MASK & ~FS_COMMON_FL);
> +       newfa.flags &= ~OVL_COPY_FS_FLAGS_MASK;
> +       newfa.flags |= (oldfa.flags & OVL_COPY_FS_FLAGS_MASK);
> +
> +       BUILD_BUG_ON(OVL_COPY_FSX_FLAGS_MASK & ~FS_XFLAG_COMMON);
> +       newfa.fsx_xflags &= ~OVL_COPY_FSX_FLAGS_MASK;
> +       newfa.fsx_xflags |= (oldfa.fsx_xflags & OVL_COPY_FSX_FLAGS_MASK);
> +
> +       return ovl_real_fileattr(new, &newfa, true);
> +}
> +
>  static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
>                             struct path *new, loff_t len)
>  {
> @@ -493,20 +519,21 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
>  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>  {
>         struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
> +       struct inode *inode = d_inode(c->dentry);
> +       struct path upperpath, datapath;
>         int err;
>
> +       ovl_path_upper(c->dentry, &upperpath);
> +       if (WARN_ON(upperpath.dentry != NULL))
> +               return -EIO;
> +
> +       upperpath.dentry = temp;
> +
>         /*
>          * Copy up data first and then xattrs. Writing data after
>          * xattrs will remove security.capability xattr automatically.
>          */
>         if (S_ISREG(c->stat.mode) && !c->metacopy) {
> -               struct path upperpath, datapath;
> -
> -               ovl_path_upper(c->dentry, &upperpath);
> -               if (WARN_ON(upperpath.dentry != NULL))
> -                       return -EIO;
> -               upperpath.dentry = temp;
> -
>                 ovl_path_lowerdata(c->dentry, &datapath);
>                 err = ovl_copy_up_data(ofs, &datapath, &upperpath,
>                                        c->stat.size);
> @@ -518,6 +545,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>         if (err)
>                 return err;
>
> +       if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
> +               /*
> +                * Copy the fileattr inode flags that are the source of already
> +                * copied i_flags (best effort).
> +                */
> +               ovl_copy_fileattr(&c->lowerpath, &upperpath);

I'm not sure this should be ignoring errors.  Was this done to prevent
regressing cases where the upper fs cannot store the flags?  Do you
have a concrete example?

Thanks,
Miklos
