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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D3AC2BA17
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 09:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58981206B8
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 09:18:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G2m+okUi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgDCJSV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 05:18:21 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:38129 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgDCJSU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Apr 2020 05:18:20 -0400
Received: by mail-il1-f193.google.com with SMTP id n13so6566099ilm.5
        for <linux-unionfs@vger.kernel.org>; Fri, 03 Apr 2020 02:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LALJOOr237N1A7qO2MuWg4PSmiM9xvL/1GuGxhQOQ5U=;
        b=G2m+okUiJufJOvBATB7yRPcvmkgQJwyCeYUZwkwY+Z0Mfn3yHFz6CKw3MAXcNKeXNa
         PBltrqPGEPnOMhEHsRdZZ+uHFvb3mWGE/9nz0hE7USz7+nRNyUDBHt5zCuNI3Op4V+jz
         BtS99eTYQxcmm/mVMvoELLSE56ZQeDLXLD927Mj4GOzmiOoZHvnOD2AcETEvtB2k85/4
         JwMJYjmeK/sA8evzXGlrQ5B0qp/dHyRXDXcOfP8JyhSp8GFtLIa20w4YimeRfJz4i+6g
         2HLv+Fj8SaXN7MdYYu1vAmmmGNus2TKnGC+isErOF8BcXqw87vt6hJyAFt9VZABe75o/
         o2Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LALJOOr237N1A7qO2MuWg4PSmiM9xvL/1GuGxhQOQ5U=;
        b=FfoXu/7jlFh76fR4DuBOZX2mGamckt1jAu/iGKWW82PxcAQMQ0A5SXiyvytk6Ctvlg
         LKIbB5h4PzYVnL6OH5OnhJwPQlB5smCblbEPv+l5cc7W436DM9WWZ5/AvnlV2nb4cHEF
         Rw4jJmjueRxKAiBJheeZvGfnbpAUNxJo5dJ8kuiJfu8K/8LSP3GhAsQi3ENSTW4WnPfP
         inBj/UecTJmkr0RkS5TLXJOrTQz7fgENwZF69YElBm0Sg2Q4tx7kBQq4LHlTK/bDRkkI
         eyXR7muHvFMlSpX2Ny1O+pUi0/w8eNE8hpeOG5u+fmlvWGG9A+JhzYTbIz2IIoIf+GHc
         VMzw==
X-Gm-Message-State: AGi0PuYCYmGkTrBCltC1AddOa0+nHbkR61TxNQxhosIDN0JrrhZAAdSi
        8Dsn7bmsN7YMP45CFQZO7MKEiCsKPVMW421ZjAfNsMtD
X-Google-Smtp-Source: APiQypLGvOYMqE9U2T2H5TCYRhbhj32CTFZjsS74vN7GG/RHvXcOEkVKS81pUR/v2yg6w90ldkRQyd9z/c9cATxfcFM=
X-Received: by 2002:a92:5b51:: with SMTP id p78mr7600687ilb.250.1585905498029;
 Fri, 03 Apr 2020 02:18:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200403064444.31062-1-cgxu519@mykernel.net>
In-Reply-To: <20200403064444.31062-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 3 Apr 2020 12:18:06 +0300
Message-ID: <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: sharing inode with different whiteout files
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 3, 2020 at 9:45 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Sharing inode with different whiteout files for saving
> inode and speeding up delete operation.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

A few more nits.
Please wait with v3 until I fix my patches, so you can test in top of
them.
Please run the overlay xfstests to test your patch.

I suspect this part of test overlay/031 will fail and will need to fix
the test to expect at most single whiteout 'residue' in work dir:

# try to remove test dir from overlay dir, trigger ovl_remove_and_whiteout,
# it will not clean up the dir and lead to residue.
rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
ls $workdir/work

And you should start writing a test.
I suggest setting /sys/module/overlay/parameters/whiteout_link_max to 2
(test should _not_run if param does not exist)
removing a bunch of files and verify after unmount that:
- whiteouts have nlink 2
- there is no more than single residue whiteout in work dir

> ---
>  fs/overlayfs/dir.c       | 50 ++++++++++++++++++++++++++++++++--------
>  fs/overlayfs/overlayfs.h | 11 +++++++--
>  fs/overlayfs/ovl_entry.h |  4 ++++
>  fs/overlayfs/readdir.c   |  3 ++-
>  fs/overlayfs/super.c     | 10 ++++++++
>  fs/overlayfs/util.c      |  3 ++-
>  6 files changed, 68 insertions(+), 13 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 279009dee366..e48ba7de1bcb 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -62,35 +62,66 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
>  }
>
>  /* caller holds i_mutex on workdir */
> -static struct dentry *ovl_whiteout(struct dentry *workdir)
> +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry *workdir)
>  {
>         int err;
> +       bool same = true;

'same' is not the best name, but I expect you won't need it anyway.
I would replace this with:
bool should_link = (ofs->whiteout_link_max > 1);

> +       bool again = true;
>         struct dentry *whiteout;
>         struct inode *wdir = workdir->d_inode;
>
> +       if (ofs->workdir != workdir)
> +               same = false;
> +retry:
>         whiteout = ovl_lookup_temp(workdir);
>         if (IS_ERR(whiteout))
>                 return whiteout;
>
> +       if (same && ofs->whiteout) {
> +               if (ovl_whiteout_linkable(ofs, workdir, ofs->whiteout)) {
> +                       err = ovl_do_link(ofs->whiteout, wdir, whiteout);
> +                       if (!err)
> +                               return whiteout;
> +
> +                       if (!again)
> +                               goto out;
> +               }
> +

We actually need to also cleanup this whiteout:

ovl_cleanup(wdir, ofs->whiteout);

> +               dput(ofs->whiteout);
> +               ofs->whiteout = NULL;
> +       }
> +
>         err = ovl_do_whiteout(wdir, whiteout);
> -       if (err) {
> -               dput(whiteout);
> -               whiteout = ERR_PTR(err);
> +       if (!err) {

save the nesting:
if (err)
    goto out;

> +               if (!same || ofs->whiteout_link_max == 1)
> +                       return whiteout;
> +
> +               if (!again) {
> +                       WARN_ON_ONCE(1);

Definitely no WARN on this case.
We can consider setting whiteout_link_max to 0 and pr_warn()
about auto disabling whiteout linking due to unexpected failure.

> +                       return whiteout;
> +               }
> +
> +               dget(whiteout);
> +               ofs->whiteout = whiteout;

Shorter:
               ofs->whiteout = dget(whiteout);

> +               again = false;
> +               goto retry;
>         }
>
> -       return whiteout;
> +out:
> +       dput(whiteout);
> +       return ERR_PTR(err);
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
> @@ -715,6 +746,7 @@ static bool ovl_matches_upper(struct dentry *dentry, struct dentry *upper)
>  static int ovl_remove_and_whiteout(struct dentry *dentry,
>                                    struct list_head *list)
>  {
> +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
>         struct dentry *workdir = ovl_workdir(dentry);
>         struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
>         struct dentry *upper;
> @@ -748,7 +780,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
>                 goto out_dput_upper;
>         }
>
> -       err = ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), upper);
> +       err = ovl_cleanup_and_whiteout(ofs, workdir, d_inode(upperdir), upper);
>         if (err)
>                 goto out_d_drop;
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index e6f3670146ed..cc7bcc3fb916 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -225,6 +225,13 @@ static inline bool ovl_open_flags_need_copy_up(int flags)
>         return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
>  }
>
> +static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs,
> +                                        struct dentry *workdir,

workdir unused.

> +                                        struct dentry *dentry)
> +{
> +       return dentry->d_inode->i_nlink < ofs->whiteout_link_max;
> +}
> +
>  /* util.c */
>  int ovl_want_write(struct dentry *dentry);
>  void ovl_drop_write(struct dentry *dentry);
> @@ -455,8 +462,8 @@ static inline void ovl_copyflags(struct inode *from, struct inode *to)
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
> index 5762d802fe01..de5f230b6e6b 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -77,6 +77,10 @@ struct ovl_fs {
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
> index e452ff7d583d..1e921115e6aa 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -1146,7 +1146,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
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
> index 732ad5495c92..340c4c05c410 100644
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
> @@ -1762,6 +1767,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>
>                 if (!ofs->workdir)
>                         sb->s_flags |= SB_RDONLY;
> +               else
> +                       ofs->whiteout_link_max = min_not_zero(
> +                                       ofs->workdir->d_sb->s_max_links,
> +                                       ovl_whiteout_link_max_def ?
> +                                       ovl_whiteout_link_max_def : 1);
>

ovl_whiteout_link_max_def ?: 1);

Thanks,
Amir.
