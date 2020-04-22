Return-Path: <SRS0=lkgI=6G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A96C55185
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 11:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 418FD20784
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 11:50:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q41QdD97"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgDVLun (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 07:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726992AbgDVLum (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Apr 2020 07:50:42 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86063C03C1A8
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Apr 2020 04:50:42 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id z12so1530904ilb.10
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Apr 2020 04:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QCaNJzNDUI5E98YR7B7OByECy6Zl/J6yp+P+d73dz6M=;
        b=Q41QdD97WbO58Y7iqw8CR6XWY47PUFLZiUwjJZGaaaMPA2Nf7VgMS+s/KmKTfANHW8
         Kjh7BSMRQa2rksXmP3kgc9FdQAu+xWhoUxw3Qqcf1Vk2ohgmkmAyBY0iu5NwDw/nfcJ/
         OsWnIiughVIKhtmWr09pQ92xWb/4t6cOZkhOI2rlcgJvTpf6reWCtfHIfoky+2tAD5QP
         rGzq+Xy1kQ8tVLkBdQqUBPy8QcA8ZST1NvTx/+L0qnoSi5SSRtkbiVvHEk4bp1d4IeZL
         K/qr2X63RA1DcPMOlcFxdSwwB/mwEZ51NJa0LD2z+AuOHE/jZveXEJARe2vUQxNWTvn2
         bBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QCaNJzNDUI5E98YR7B7OByECy6Zl/J6yp+P+d73dz6M=;
        b=IxY9+z8D2QFnBxG04PPIuu/Tx/CIbh9zSPEFl8zhvUfdIKDGZd9Y9uUwxtHYe7qRvu
         H2o+VR60L6hRwJvlxnsErtVnKnk/qWSoAYnD2mGFkv0tem3QkW+oyNnggWE7xpnCgPwo
         ynHDzU0lCkl9bse5qfJrHO0UjfDrPjWgZQRoBMauXOFeTJkV6ioo2BkrZwvtQjBpVjKA
         sQKQPWJ/SOEIMuCwZypeKvJBHpC54LPHoMnajWw54ULN2ua1ErewWAb3vM10c+V14dDF
         qbJq6ACOvtUs0Iii8Z19r1hV3zWv5zPSatd/Wuw/p/lDlhaCA1k6JcnUJ3FMRcXuwDlI
         ABpg==
X-Gm-Message-State: AGi0Pub/nw5ymXOb+1nVPAU7TgdGtlPzeMojejAmYjay1A/OpODNy/If
        SC6etUih+RA0fLQuuI4lzxxwrqu1Vb2So9dwp4E/JBwW
X-Google-Smtp-Source: APiQypKK0pE2jPNtn7NbKeUu9yeaxdypRJzF+ia2IhO/tgahWEKZtzTk29ZebHeqaCAdWBe+JekK7Mj55OeAWmXxpcU=
X-Received: by 2002:a92:390f:: with SMTP id g15mr10923515ila.72.1587556241817;
 Wed, 22 Apr 2020 04:50:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200422102740.6670-1-cgxu519@mykernel.net>
In-Reply-To: <20200422102740.6670-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 22 Apr 2020 14:50:30 +0300
Message-ID: <CAOQ4uxj5JsWOgQ8vHqTkAXx16Y9URTgNpALY5XO=VNUAMTkOMw@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: whiteout inode sharing
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 22, 2020 at 1:28 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Sharing inode with different whiteout files for saving
> inode and speeding up deleting operation.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Just one question...

> ---
> v1->v2:
> - Address Amir's comments in v1.
>
> v2->v3:
> - Address Amir's comments in v2.
> - Rebase on Amir's "Overlayfs use index dir as work dir" patch set.
> - Keep at most one whiteout tmpfile in work dir.
>
> v3->v4:
> - Disable the feature after link failure.
> - Add mount option(whiteout link max) for overlayfs instance.
>
>  fs/overlayfs/dir.c       | 47 ++++++++++++++++++++++++++++++++++------
>  fs/overlayfs/overlayfs.h | 10 +++++++--
>  fs/overlayfs/ovl_entry.h |  5 +++++
>  fs/overlayfs/readdir.c   |  3 ++-
>  fs/overlayfs/super.c     | 24 ++++++++++++++++++++
>  fs/overlayfs/util.c      |  3 ++-
>  6 files changed, 81 insertions(+), 11 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 279009dee366..8b7d8854f31f 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -62,35 +62,67 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
>  }
>
>  /* caller holds i_mutex on workdir */
> -static struct dentry *ovl_whiteout(struct dentry *workdir)
> +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry *workdir)
>  {
>         int err;
> +       bool retried = false;
> +       bool should_link = (ofs->whiteout_link_max > 1);
>         struct dentry *whiteout;
>         struct inode *wdir = workdir->d_inode;
>
> +retry:
>         whiteout = ovl_lookup_temp(workdir);
>         if (IS_ERR(whiteout))
>                 return whiteout;
>
> +       err = 0;
> +       if (should_link) {
> +               if (ovl_whiteout_linkable(ofs)) {
> +                       err = ovl_do_link(ofs->whiteout, wdir, whiteout);
> +                       if (!err)
> +                               return whiteout;
> +               } else if (ofs->whiteout) {
> +                       dput(whiteout);
> +                       whiteout = ofs->whiteout;
> +                       ofs->whiteout = NULL;
> +                       return whiteout;
> +               }
> +
> +               if (err) {
> +                       pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%i)\n",
> +                               ofs->whiteout->d_inode->i_nlink, err);
> +                       ofs->whiteout_link_max = 0;
> +                       should_link = false;
> +                       ovl_cleanup(wdir, ofs->whiteout);
> +                       dput(ofs->whiteout);
> +                       ofs->whiteout = NULL;
> +               }
> +       }
> +
>         err = ovl_do_whiteout(wdir, whiteout);
>         if (err) {
>                 dput(whiteout);
> -               whiteout = ERR_PTR(err);
> +               return ERR_PTR(err);
>         }
>
> -       return whiteout;
> +       if (!should_link || retried)
> +               return whiteout;
> +
> +       ofs->whiteout = whiteout;
> +       retried = true;
> +       goto retry;
>  }
>
>  /* Caller must hold i_mutex on both workdir and dir */
> -int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
> -                            struct dentry *dentry)
> +int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workdir,
> +                            struct inode *dir, struct dentry *dentry)
>  {
>         struct inode *wdir = workdir->d_inode;
>         struct dentry *whiteout;
>         int err;
>         int flags = 0;
>
> -       whiteout = ovl_whiteout(workdir);
> +       whiteout = ovl_whiteout(ofs, workdir);
>         err = PTR_ERR(whiteout);
>         if (IS_ERR(whiteout))
>                 return err;
> @@ -715,6 +747,7 @@ static bool ovl_matches_upper(struct dentry *dentry, struct dentry *upper)
>  static int ovl_remove_and_whiteout(struct dentry *dentry,
>                                    struct list_head *list)
>  {
> +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
>         struct dentry *workdir = ovl_workdir(dentry);
>         struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
>         struct dentry *upper;
> @@ -748,7 +781,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
>                 goto out_dput_upper;
>         }
>
> -       err = ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), upper);
> +       err = ovl_cleanup_and_whiteout(ofs, workdir, d_inode(upperdir), upper);
>         if (err)
>                 goto out_d_drop;
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index e00b1ff6dea9..3b127c997a6d 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -225,6 +225,12 @@ static inline bool ovl_open_flags_need_copy_up(int flags)
>         return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
>  }
>
> +static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs)
> +{
> +       return (ofs->whiteout &&
> +               ofs->whiteout->d_inode->i_nlink < ofs->whiteout_link_max);
> +}
> +
>  /* util.c */
>  int ovl_want_write(struct dentry *dentry);
>  void ovl_drop_write(struct dentry *dentry);
> @@ -455,8 +461,8 @@ static inline void ovl_copyflags(struct inode *from, struct inode *to)
>
>  /* dir.c */
>  extern const struct inode_operations ovl_dir_inode_operations;
> -int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
> -                            struct dentry *dentry);
> +int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workdir,
> +                            struct inode *dir, struct dentry *dentry);
>  struct ovl_cattr {
>         dev_t rdev;
>         umode_t mode;
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 5762d802fe01..c805c35e0594 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -17,6 +17,7 @@ struct ovl_config {
>         bool nfs_export;
>         int xino;
>         bool metacopy;
> +       unsigned int whiteout_link_max;
>  };
>
>  struct ovl_sb {
> @@ -77,6 +78,10 @@ struct ovl_fs {
>         int xino_mode;
>         /* For allocation of non-persistent inode numbers */
>         atomic_long_t last_ino;
> +       /* Whiteout dentry cache */
> +       struct dentry *whiteout;
> +       /* Whiteout max link count */
> +       unsigned int whiteout_link_max;
>  };
>
>  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 20f5310d3ee4..bf22fb7792c1 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -1154,7 +1154,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
>                          * Whiteout orphan index to block future open by
>                          * handle after overlay nlink dropped to zero.
>                          */
> -                       err = ovl_cleanup_and_whiteout(indexdir, dir, index);
> +                       err = ovl_cleanup_and_whiteout(ofs, indexdir, dir,
> +                                                      index);
>                 } else {
>                         /* Cleanup orphan index entries */
>                         err = ovl_cleanup(dir, index);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index f57aa348dcd6..6bccab4d5596 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -26,6 +26,10 @@ struct ovl_dir_cache;
>
>  #define OVL_MAX_STACK 500
>
> +static unsigned int ovl_whiteout_link_max_def = 60000;
> +module_param_named(whiteout_link_max, ovl_whiteout_link_max_def, uint, 0644);
> +MODULE_PARM_DESC(whiteout_link_max, "Maximum count of whiteout file link");
> +
>  static bool ovl_redirect_dir_def = IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_DIR);
>  module_param_named(redirect_dir, ovl_redirect_dir_def, bool, 0644);
>  MODULE_PARM_DESC(redirect_dir,
> @@ -219,6 +223,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>         iput(ofs->upperdir_trap);
>         dput(ofs->indexdir);
>         dput(ofs->workdir);
> +       dput(ofs->whiteout);
>         if (ofs->workdir_locked)
>                 ovl_inuse_unlock(ofs->workbasedir);
>         dput(ofs->workbasedir);
> @@ -358,6 +363,10 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         if (ofs->config.metacopy != ovl_metacopy_def)
>                 seq_printf(m, ",metacopy=%s",
>                            ofs->config.metacopy ? "on" : "off");
> +       if (ofs->config.whiteout_link_max != ovl_whiteout_link_max_def)
> +               seq_printf(m, ",whiteout_link_max=%u",
> +                          ofs->config.whiteout_link_max);
> +
>         return 0;
>  }
>
> @@ -398,6 +407,7 @@ enum {
>         OPT_XINO_AUTO,
>         OPT_METACOPY_ON,
>         OPT_METACOPY_OFF,
> +       OPT_WHITEOUT_LINK_MAX,
>         OPT_ERR,
>  };
>
> @@ -416,6 +426,7 @@ static const match_table_t ovl_tokens = {
>         {OPT_XINO_AUTO,                 "xino=auto"},
>         {OPT_METACOPY_ON,               "metacopy=on"},
>         {OPT_METACOPY_OFF,              "metacopy=off"},
> +       {OPT_WHITEOUT_LINK_MAX,         "whiteout_link_max=%u"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -469,6 +480,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  {
>         char *p;
>         int err;
> +       int link_max;
>         bool metacopy_opt = false, redirect_opt = false;
>         bool nfs_export_opt = false, index_opt = false;
>
> @@ -560,6 +572,13 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         metacopy_opt = true;
>                         break;
>
> +               case OPT_WHITEOUT_LINK_MAX:
> +                       if (match_int(&args[0], &link_max))
> +                               return -EINVAL;
> +                       if (link_max < ovl_whiteout_link_max_def)
> +                               config->whiteout_link_max = link_max;

Why not allow link_max > ovl_whiteout_link_max_def?
admin may want to disable ovl_whiteout_link_max_def by default
in module parameter, but allow it for specific overlay instances.

In any case, if we do have a good reason to ignore user configurable
value we should pr_warn about it and explain to users what they
need to do to overcome the miss configuration issue.

Thanks,
Amir.
