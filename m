Return-Path: <SRS0=JwOv=5T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8997C43331
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 02:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91E1B2063A
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 02:47:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfxLiQuR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390175AbgDCCrH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 22:47:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45233 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731842AbgDCCrG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Apr 2020 22:47:06 -0400
Received: by mail-wr1-f65.google.com with SMTP id t7so6696722wrw.12
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Apr 2020 19:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eOrPpd82XmUxpXLfHP41/qm9dWrI00qsgPgcPkSx23U=;
        b=PfxLiQuREBLYcb8zBhv/sPfLvU52At7XjD+8jHJqmFsnA8SfjMfQ2wptiMLc5Tjjdd
         YXppzmj3qaPM4lotn+SLOexxEvupJBxRjyRAC53js6ETAXZmRv2PilBkoYXFzt/mYRRL
         hLG9q8ydS7AxageEEHG2fFRWFecBKviJoBdXy3nqfTXdFf/royrJQuk3TBaVIi0crGn7
         xvJOhKGvCLQ3SUNc7n+E1BZ0tWnZeNyVznfZLR7CgxXFpEYHGxKGjUMKLMNMLmrDNAK2
         4a58U5S8peD4qH2kgNG/8HKLkM93XVbZzEQHO6pTSFss9D59q9ySneL5poJ62oYfy2Mg
         AJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eOrPpd82XmUxpXLfHP41/qm9dWrI00qsgPgcPkSx23U=;
        b=kdy5bcZY+HWkTVlSHnVvQOU2y8ZsaFYVttWN7z4WUSJJNIKqtQLOnDsWSB17fcHrMh
         aNqwMz1dDFNn4iLi4FWuNe2671BLxxaM9BWMVzonRu5wJ/GR3XVp/6SHVAo7SIaVXcKV
         vswbqP0M3gw7AoFEq/KRgYTDpUVUYlcuo4TWJkCcnCuD1LxOtIotmqDSGPLWnlp8ne2Y
         qNjwJaFxAWD08s4gm+bt3Dpvk/VFIONoRDA5g+8OjlGdBfmOps1OakJyQRETYaN+BW1m
         Qz8DTBFNmyBoyUt7+EEK7ayVy+HnUtK1/Eghvpb35IdPlBMa72g300GIVoBisYhq7+Cl
         frNA==
X-Gm-Message-State: AGi0PubXdJ234LUasc+3o6ikw4+PNHZbaLodjPYPlb41taZU5MoV0AiA
        t9sflyrIvMEwuAATt50y06OWYbBPFCWuR8EH2JV1RuA1
X-Google-Smtp-Source: APiQypKkhOOjy8dE5J4Ou1XJKzGXQKtm97qSz6BZUgDUCLhEGWZc5sHnTAWUtMpdP9zw7IN9QMqZg+GdUru0C5Aset8=
X-Received: by 2002:adf:de82:: with SMTP id w2mr6663101wrl.92.1585882024107;
 Thu, 02 Apr 2020 19:47:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200402085808.17695-1-cgxu519@mykernel.net>
In-Reply-To: <20200402085808.17695-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 3 Apr 2020 05:46:52 +0300
Message-ID: <CAOQ4uxhwNpz-83xeTmDBvP7WtL=OXvjLH_gnUQ548PKj7=rvtw@mail.gmail.com>
Subject: Re: [PATCH] ovl: sharing inode with different whiteout files
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 2, 2020 at 11:58 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Sharing inode with different whiteout files for saving
> inode and speeding up delete opration.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>
> Hi Miklos, Amir
>
> This is another inode sharing approach for whiteout files compare
> to Tao's previous patch. I didn't receive feedback from Tao for
> further update and this new approach seems more simple and reliable.
> Could you have a look at this patch?
>

I like the simplification, but there are some parts of Tao's patch you
removed without understanding they need to be restored.

The main think you missed is that it is not safe to protect ofs->whiteout
with i_mutex on workdir, because workdir in ovl_whiteout() can be
one of 2 directories.
This is the point were the discussion on V3 got derailed.

I will try to work on a patch unifying index/work dirs to solve this
problem, so you won't need to change anything in your patch,
but it will depend on this prerequisite.
As alternative, if you do not wish to wait for my patch,
please see the check for (workdir == ofs->workdir) in Tao's patch.

More below...

>
>  fs/overlayfs/dir.c       | 53 ++++++++++++++++++++++++++++++++++------
>  fs/overlayfs/overlayfs.h |  2 +-
>  fs/overlayfs/ovl_entry.h |  2 ++
>  fs/overlayfs/readdir.c   |  3 ++-
>  fs/overlayfs/super.c     |  3 +++
>  fs/overlayfs/util.c      |  3 ++-
>  6 files changed, 56 insertions(+), 10 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 279009dee366..d5c2e1ada624 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -61,36 +61,74 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
>         return temp;
>  }
>
> +const unsigned int ovl_whiteout_link_max = 60000;

Please keep this a module param as in V3.
A module param is also a way to disable whiteout linking
if for some reason it causes problems.

> +
> +static bool ovl_whiteout_linkable(struct dentry *dentry)
> +{
> +       unsigned int max;
> +
> +       max = min_not_zero(dentry->d_sb->s_max_links, ovl_whiteout_link_max);
> +       if (dentry->d_inode->i_nlink >= max)
> +               return false;
> +       return true;

return (dentry->d_inode->i_nlink < max);

> +}
> +
>  /* caller holds i_mutex on workdir */
> -static struct dentry *ovl_whiteout(struct dentry *workdir)
> +static struct dentry *ovl_whiteout(struct dentry *workdir, struct ovl_fs *ofs)

Please keep ofs argument first as per convention.

>  {
>         int err;
> +       bool again = true;

bool again = (ovl_whiteout_link_max > 1);

assuming that it is changed to a module param.

>         struct dentry *whiteout;
>         struct inode *wdir = workdir->d_inode;
>
> +retry:
>         whiteout = ovl_lookup_temp(workdir);
>         if (IS_ERR(whiteout))
>                 return whiteout;
>
> +
> +       if (ofs->whiteout) {
> +               if (ovl_whiteout_linkable(ofs->whiteout)) {
> +                       err = ovl_do_link(ofs->whiteout, wdir, whiteout);
> +                       if (!err)
> +                               return whiteout;
> +
> +                       if (!again)
> +                               goto out;
> +               }
> +
> +               err = ovl_do_unlink(ofs->workdir->d_inode, ofs->whiteout);

use 'wdir'

> +               ofs->whiteout = NULL;

dput(ofs->whiteout); before reset

> +               if (err)
> +                       goto out;
> +       }
> +
>         err = ovl_do_whiteout(wdir, whiteout);
> -       if (err) {
> -               dput(whiteout);
> -               whiteout = ERR_PTR(err);
> +       if (!err) {
> +               ofs->whiteout = whiteout;

only set ofs->whiteout if (again) and get a reference.
otherwise return the whiteout.

> +               if (again) {
> +                       again = false;

dget(whiteout);

> +                       goto retry;
> +               }
> +               return ERR_PTR(-EIO);

Why fail? just return the whiteout.

>         }
>
> +out:
> +       dput(whiteout);
> +       whiteout = ERR_PTR(err);
>         return whiteout;

return ERR_PTR(err);


>  }
>
>  /* Caller must hold i_mutex on both workdir and dir */
>  int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
> -                            struct dentry *dentry)
> +                            struct dentry *dentry, struct ovl_fs *ofs)

ofs arg first

>  {
>         struct inode *wdir = workdir->d_inode;
>         struct dentry *whiteout;
>         int err;
>         int flags = 0;
>
> -       whiteout = ovl_whiteout(workdir);
> +       whiteout = ovl_whiteout(workdir, ofs);
>         err = PTR_ERR(whiteout);
>         if (IS_ERR(whiteout))
>                 return err;
> @@ -715,6 +753,7 @@ static bool ovl_matches_upper(struct dentry *dentry, struct dentry *upper)
>  static int ovl_remove_and_whiteout(struct dentry *dentry,
>                                    struct list_head *list)
>  {
> +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
>         struct dentry *workdir = ovl_workdir(dentry);
>         struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
>         struct dentry *upper;
> @@ -748,7 +787,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
>                 goto out_dput_upper;
>         }
>
> -       err = ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), upper);
> +       err = ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), upper, ofs);
>         if (err)
>                 goto out_d_drop;
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index e6f3670146ed..6212feef36c5 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -456,7 +456,7 @@ static inline void ovl_copyflags(struct inode *from, struct inode *to)
>  /* dir.c */
>  extern const struct inode_operations ovl_dir_inode_operations;
>  int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
> -                            struct dentry *dentry);
> +                            struct dentry *dentry, struct ovl_fs *ofs);
>  struct ovl_cattr {
>         dev_t rdev;
>         umode_t mode;
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 5762d802fe01..408aa6c7a3bd 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -77,6 +77,8 @@ struct ovl_fs {
>         int xino_mode;
>         /* For allocation of non-persistent inode numbers */
>         atomic_long_t last_ino;
> +       /* Whiteout dentry cache */
> +       struct dentry *whiteout;
>  };
>
>  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index e452ff7d583d..0c8c7ff4fc9e 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -1146,7 +1146,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
>                          * Whiteout orphan index to block future open by
>                          * handle after overlay nlink dropped to zero.
>                          */
> -                       err = ovl_cleanup_and_whiteout(indexdir, dir, index);
> +                       err = ovl_cleanup_and_whiteout(indexdir, dir, index,
> +                                                      ofs);
>                 } else {
>                         /* Cleanup orphan index entries */
>                         err = ovl_cleanup(dir, index);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 732ad5495c92..fae9729ff018 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -240,6 +240,9 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>         kfree(ofs->config.redirect_mode);
>         if (ofs->creator_cred)
>                 put_cred(ofs->creator_cred);
> +       if (ofs->whiteout)
> +               ovl_do_unlink(ofs->workdir->d_inode,
> +                          ofs->whiteout);

You cannot and should not do that here.
It will be cleaned up on next mount.
You need here unconditional:
dputt(whiteout);

Thanks,
Amir.
