Return-Path: <SRS0=vlVb=CI=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526F5C433E2
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 20:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21BE520578
	for <linux-unionfs@archiver.kernel.org>; Sun, 30 Aug 2020 20:25:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W713bR+I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgH3UZ3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 16:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgH3UZ1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 30 Aug 2020 16:25:27 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A398C061573
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 13:25:27 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z25so1240944iol.10
        for <linux-unionfs@vger.kernel.org>; Sun, 30 Aug 2020 13:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8FpYAS2701XTB3XMQJl6nwliAoMzl8EbDw8NJmQDGk=;
        b=W713bR+IXN49e8l9Woh85MtRfmAe0EtGkSbj/xMZTOZXXIjwHOptbazGq3L9tTk6EN
         pciaBfeS8yJvKDiFofbUo4ejWn5FsqlkL8sOuzt1fkEpEQ0GXNKgESnkbLxB6tC6GTzS
         01nUBcitnfVnGKx0MF83CNSN7mmbjxKvkyCU+r4Ik4/WwhqiEAPHUyOj3i/hn+As5owS
         biYmcM7wXP2Urq1805VOvAVFy6b4gKZ9hfTVN3uC3GybUqm2cDrvyTaw9B1S1k/1oJCL
         xwSciz8JlGsfLuOLWwltpKoEtkXJ8LbqZBs/xpKXp/9hr6LTY9da7sXfrKz03Q69IG8+
         oYnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8FpYAS2701XTB3XMQJl6nwliAoMzl8EbDw8NJmQDGk=;
        b=SUoofimZMniEkoSojyK9EcWOfk0SgXL9nTPXkew6Ky7UawriKjbJhPQoZg182EyWri
         d4l0ID8nqQU8PcNAJc+66pBjAiMjZmOcpKypNR5O/vg4Orj9pp6B9vmFwkDgFRmSMqJG
         beNWJILOXCk0aaoABQ40uFLkuF3Z3Kjjn1IGYiV2XRrvf3gsmHS2nj0RpY3DtX59BRZG
         yd4TS27dZP/Hg9kZ+zOgbzdGTeYmFlOmrc0z2fD6N1kQLdMg5hs/9nwksQRWBs+GaxIa
         UxWo3bgKojR7ncnI0Rkw1+6aZrg1WsZsUbnQ+FTIoOa+TCrGu2okvG9dwZC0y5qrsIk7
         lqmw==
X-Gm-Message-State: AOAM532K8nbX8w+vjyRGdJ/q2NecKv/sN1ADEr/h279vtu5SDf7ZWpaD
        5RX78Fjlna/tw450WtWWVtic7V6yI9ejNk4GnN4=
X-Google-Smtp-Source: ABdhPJy3c4s0+4r1U03kWBh40uDb9ujTHvmZpPktwPhXr2DKZdI+2qIWsLUqb8l4M9h1r33dsbun7PpwZFuwt71GnR0=
X-Received: by 2002:a05:6602:240c:: with SMTP id s12mr6206567ioa.5.1598819125674;
 Sun, 30 Aug 2020 13:25:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200830200647.19047-1-amir73il@gmail.com>
In-Reply-To: <20200830200647.19047-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 30 Aug 2020 23:25:14 +0300
Message-ID: <CAOQ4uxgXQmSWnij=3YCSuR+ictF2uR=Y_23aTcDH0gqP06S73Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: check for incomapt features in work dir
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:06 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> An incompatible feature is marked by a non-empty directory nested
> 2 levels deep under "work" dir, e.g.:
> workdir/work/incompat/volatile.
>
> This commit checks for marked incompat features, warns about them
> and fails to mount the overlay, for example:
>   overlayfs: overlay with incompat feature 'volatile' cannot be mounted
>
> Very old kernels (i.e. v3.18) will fail to remove a non-empty "work"
> dir and fail the mount.  Newer kernels will fail to remove a "work"
> dir with entries nested 3 levels and fall back to read-only mount.
>
> User mounting with old kernel will see a warning like these in dmesg:
>   overlayfs: cleanup of 'incompat/...' failed (-39)
>   overlayfs: cleanup of 'work/incompat' failed (-39)
>   overlayfs: cleanup of 'ovl-work/work' failed (-39)
>   overlayfs: failed to create directory /vdf/ovl-work/work (errno: 17);
>              mounting read-only
>
> These warnings should give the hint to the user that:
> 1. mount failure is caused by backward incompatible features
> 2. mount failure can be resolved by manually removing the "work" directory
>
> There is nothing preventing users on old kernels from manually removing
> workdir entirely or mounting overlay with a new workdir, so this is in
> no way a full proof backward compatibility enforcement, but only a best
> effort.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Vivek,
>
> I dusted off some code from my old ovl-features branch.
> This should explain what I was trying to say on review of volatile (v6).
>
> There are also some helpers on that branch to create incompat feature dir,
> but they seemed too generic for your needs, so I left them out.
>
> What I was trying to explain is that with this change, the documentation
> for "volatile" should intstruct user to remove the incompat/volatile dir
> entirely, not just the dirty file, in order to reuse the overlay and I
> think that makes sense.
>
> To be clear, an empty work/incompat dir does not prevent neither old nor
> new kernel from mounting the overlay and an empty incompat/volatile dir
> does not prevent old kernel from mounting the overlay, which is why we
> still need to create the dirty file.
>
> Thanks,
> Amir.
>
>
>  fs/overlayfs/overlayfs.h |  4 +++-
>  fs/overlayfs/readdir.c   | 31 +++++++++++++++++++++++++------
>  fs/overlayfs/super.c     | 25 ++++++++++++++++++-------
>  3 files changed, 46 insertions(+), 14 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 29bc1ec699e7..dc8ad8dc884a 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -31,6 +31,8 @@ enum ovl_path_type {
>  #define OVL_XATTR_UPPER OVL_XATTR_PREFIX "upper"
>  #define OVL_XATTR_METACOPY OVL_XATTR_PREFIX "metacopy"
>
> +#define OVL_INCOMPATDIR_NAME "incompat"
> +
>  enum ovl_inode_flag {
>         /* Pure upper dir that may contain non pure upper entries */
>         OVL_IMPURE,
> @@ -54,6 +56,7 @@ enum {
>         OVL_XINO_ON,
>  };
>
> +
>  /*
>   * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
>   * where:
> @@ -349,7 +352,6 @@ static inline void ovl_inode_unlock(struct inode *inode)
>         mutex_unlock(&OVL_I(inode)->lock);
>  }
>
> -
>  /* namei.c */
>  int ovl_check_fb_len(struct ovl_fb *fb, int fb_len);
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 6918b98faeb6..8e4938b51814 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -1051,7 +1051,8 @@ int ovl_check_d_type_supported(struct path *realpath)
>         return rdd.d_type_supported;
>  }
>
> -static void ovl_workdir_cleanup_recurse(struct path *path, int level)
> +static int ovl_workdir_cleanup_recurse(struct path *path, int level,
> +                                      bool incompat)
>  {
>         int err;
>         struct inode *dir = path->dentry->d_inode;
> @@ -1079,25 +1080,42 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
>                                 continue;
>                         if (p->len == 2 && p->name[1] == '.')
>                                 continue;
> +               } else if (incompat) {
> +                       pr_warn("overlay with incompat feature '%.*s' cannot be mounted\n",
> +                               p->len, p->name);
> +                       err = -EEXIST;
> +                       break;
>                 }
>                 dentry = lookup_one_len(p->name, path->dentry, p->len);
>                 if (IS_ERR(dentry))
>                         continue;
>                 if (dentry->d_inode)
> -                       ovl_workdir_cleanup(dir, path->mnt, dentry, level);
> +                       err = ovl_workdir_cleanup(dir, path->mnt, dentry, level);
>                 dput(dentry);
> +               if (err)
> +                       break;
>         }
>         inode_unlock(dir);
>  out:
>         ovl_cache_free(&list);
> +       return err;
>  }
>
>  int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
> -                        struct dentry *dentry, int level)
> +                       struct dentry *dentry, int level)
>  {
> +       bool incompat = false;
>         int err;
>
> -       if (!d_is_dir(dentry) || level > 1) {
> +       /*
> +        * The "work/incompat" directory is treated specially - if it is not
> +        * empty, instead of printing a generic error and mounting read-only,
> +        * we will error about incompat features and fail the mount.
> +        */
> +       if (d_is_dir(dentry) && level == 1 &&
> +           !strcmp(dentry->d_name.name, OVL_INCOMPATDIR_NAME)) {
> +               incompat = true;

Self nit - move this test into ovl_workdir_cleanup_recurse()
Noticed after posting, will post v2.

> +       } else if (!d_is_dir(dentry) || level > 1) {
>                 return ovl_cleanup(dir, dentry);
>         }
>
> @@ -1106,9 +1124,10 @@ int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
>                 struct path path = { .mnt = mnt, .dentry = dentry };
>
>                 inode_unlock(dir);
> -               ovl_workdir_cleanup_recurse(&path, level + 1);
> +               err = ovl_workdir_cleanup_recurse(&path, level + 1, incompat);
>                 inode_lock_nested(dir, I_MUTEX_PARENT);
> -               err = ovl_cleanup(dir, dentry);
> +               if (!err)
> +                       err = ovl_cleanup(dir, dentry);
>         }
>
>         return err;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 4b38141c2985..3cd47e4b2eae 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -705,8 +705,12 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
>                                 goto out_unlock;
>
>                         retried = true;
> -                       ovl_workdir_cleanup(dir, mnt, work, 0);
> +                       err = ovl_workdir_cleanup(dir, mnt, work, 0);
>                         dput(work);
> +                       if (err == -EEXIST) {
> +                               work = ERR_PTR(err);
> +                               goto out_unlock;
> +                       }
>                         goto retry;
>                 }
>
> @@ -1203,7 +1207,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
>                             struct path *workpath)
>  {
>         struct vfsmount *mnt = ovl_upper_mnt(ofs);
> -       struct dentry *temp;
> +       struct dentry *temp, *workdir;
>         bool rename_whiteout;
>         bool d_type;
>         int fh_type;
> @@ -1213,10 +1217,13 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
>         if (err)
>                 return err;
>
> -       ofs->workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
> -       if (!ofs->workdir)
> +       workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
> +       err = PTR_ERR(workdir);
> +       if (IS_ERR_OR_NULL(workdir))
>                 goto out;
>
> +       ofs->workdir = workdir;
> +
>         err = ovl_setup_trap(sb, ofs->workdir, &ofs->workdir_trap, "workdir");
>         if (err)
>                 goto out;
> @@ -1347,6 +1354,7 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
>                             struct ovl_entry *oe, struct path *upperpath)
>  {
>         struct vfsmount *mnt = ovl_upper_mnt(ofs);
> +       struct dentry *indexdir;
>         int err;
>
>         err = mnt_want_write(mnt);
> @@ -1366,9 +1374,12 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
>         ofs->workdir_trap = NULL;
>         dput(ofs->workdir);
>         ofs->workdir = NULL;
> -       ofs->indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
> -       if (ofs->indexdir) {
> -               ofs->workdir = dget(ofs->indexdir);
> +       indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
> +       if (IS_ERR(indexdir)) {
> +               err = PTR_ERR(indexdir);
> +       } else if (indexdir) {
> +               ofs->indexdir = indexdir;
> +               ofs->workdir = dget(indexdir);
>
>                 err = ovl_setup_trap(sb, ofs->indexdir, &ofs->indexdir_trap,
>                                      "indexdir");
> --
> 2.17.1
>
