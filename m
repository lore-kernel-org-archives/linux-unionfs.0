Return-Path: <SRS0=8cne=AR=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FF4C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 17:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76FC206DF
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 17:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mzhg7sgS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbgGFRQs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 13:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729500AbgGFRQs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jul 2020 13:16:48 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ACAC061755
        for <linux-unionfs@vger.kernel.org>; Mon,  6 Jul 2020 10:16:48 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q74so16590194iod.1
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Jul 2020 10:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zfbHyDMCU5td0lGN7GgenK4ZrzkEdCIPBeyfCCOAK3k=;
        b=mzhg7sgSO4sA8qvEzOKzt0RBtwhsB67DEfBUoe/RJW6HRSYs0nQbemcDiQ51iTpkvp
         KQ1wzGwnyQZJxrRiCbATpsQpTEC2Am6X6yzEV6KRrZDRhZ20m4RrL/0HmUn3fOyvL5iv
         nNON7EE7siDIOFA85KESbF07L/MAtWxqlI4M3s2qnzxte5Mnsw6Jp5m3OskxtRC+rt26
         fJE/T1s3hZHcWNEoFVJF/gnT7SF+POzvBdAOuKJ4IpCOhNSSnzAjkN5cqZ/C8HcqZOiM
         pmcn2Rj5gyF9ewu+NzJexz+KQxrwF8KIbLk5ACGjvPus0n7IzFU5SRRwvKER7NcleREh
         EUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zfbHyDMCU5td0lGN7GgenK4ZrzkEdCIPBeyfCCOAK3k=;
        b=DUedwR4//1dYl7qDoa3QjsO3kXhpdGrPoAUeVuyxGBzZXrbRISXr/z7rpZDf45a0cF
         Oo10HqYmlIY4J0Q5m/6Yqmz5X1DScGyhnRUNTNqrM14retekPBX211pgnTukPWecxnr8
         DOL4hiZEp1VAPx803qdiXWTjlzFzqQ8hzheSKfOKdvFxwRp69SaZYWidWMsW4yVJ9sTO
         nGCjE4TpxPeZENTgrgXXasaekGzL4cYTcPkpiYxnMJJoPNWkRFQITSA2yUts2siNLv/W
         sgXzuPm7WxK+S6UGnpTWv/U+GVPUzHtn1rRKI1ZfvtoRqcthYb5PR2kjPjCoaz5dsmsB
         0e6g==
X-Gm-Message-State: AOAM531X8SvuJwIU29R1Uu21gWiHUmtf2BpsbOzhgfxegPuOl6tTfYei
        K/mSuWk9XQCCNDcqEJBJIvpLrLEgS+BmWBgqS46QlgEg
X-Google-Smtp-Source: ABdhPJz9/xqixZsPQjGrZbfKJtD5XVGgKd8oAH/Yi2T6QerxgOytsfj2uWYubT3flyl2ULNLBEnKKa+kIYYKXEja2ik=
X-Received: by 2002:a05:6602:58a:: with SMTP id v10mr26371159iox.203.1594055807184;
 Mon, 06 Jul 2020 10:16:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200706161227.GB3107@redhat.com>
In-Reply-To: <20200706161227.GB3107@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 6 Jul 2020 20:16:36 +0300
Message-ID: <CAOQ4uxiTdLDZ6J4j4p38XKxKN+m3hcJLghLebgno9rQuy32S4w@mail.gmail.com>
Subject: Re: [PATCH v4] overlayfs: Provide mount options sync=off/fs to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>, pmatilai@redhat.com,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 6, 2020 at 7:12 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Container folks are complaining that dnf/yum issues too many sync while
> installing packages and this slows down the image build. Build
> requirement is such that they don't care if a node goes down while
> build was still going on. In that case, they will simply throw away
> unfinished layer and start new build. So they don't care about syncing
> intermediate state to the disk and hence don't want to pay the price
> associated with sync.
>
> So they are asking for mount options where they can disable sync on overlay
> mount point.
>
> They primarily seem to have two use cases.
>
> - For building images, they will mount overlay with nosync and then sync
>   upper layer after unmounting overlay and reuse upper as lower for next
>   layer.
>
> - For running containers, they don't seem to care about syncing upper
>   layer because if node goes down, they will simply throw away upper
>   layer and create a fresh one.
>
> So this patch provides two mount options "sync=off" and "sync=fs".
> First option disables all forms of sync. Now it is caller's responsibility
> to throw away upper if system crashes or shuts down and start fresh.
>
> Option "sync=fs" disables all forms of sync except syncfs/umount/remount.
> This is basically useful for image build where we want to persist upper
> layer only after operation is complete and upper will be renamed and
> reused as lower for next layer build.
>
> With sync=off, I am seeing roughly 20% speed up in my VM where I am just
> installing emacs in an image. Installation time drops from 31 seconds to
> 25 seconds when nosync option is used. This is for the case of building on top
> of an image where all packages are already cached. That way I take
> out the network operations latency out of the measurement.
>
> With sync=fs, I am seeing roughly 12% speed up.
>
> Giuseppe is also looking to cut down on number of iops done on the
> disk. He is complaining that often in cloud their VMs are throttled
> if they cross the limit. This option can help them where they reduce
> number of iops (by cutting down on frequent sync and writebacks).
>
> Changes from v3:
> - Used only enums and dropped bit flags (Amir Goldstein)
> - Dropped error when conflicting sync options provided. (Amir Goldstein)
>
> Changes from v2:
> - Added helper functions (Amir Goldstein)
> - Used enums to keep sync state (Amir Goldstein)
>
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks!

>  Documentation/filesystems/overlayfs.rst | 16 +++++++++++
>  fs/overlayfs/copy_up.c                  | 12 ++++++---
>  fs/overlayfs/file.c                     | 10 ++++++-
>  fs/overlayfs/ovl_entry.h                | 17 ++++++++++++
>  fs/overlayfs/readdir.c                  |  3 +++
>  fs/overlayfs/super.c                    | 35 ++++++++++++++++++++++---
>  6 files changed, 85 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 660dbaf0b9b8..4e55ac4433ec 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -563,6 +563,22 @@ This verification may cause significant overhead in some cases.
>  Note: the mount options index=off,nfs_export=on are conflicting and will
>  result in an error.
>
> +Disable sync
> +------------
> +By default, overlay skips sync on files residing on a lower layer.  It
> +is possible to skip sync operations for files on the upper layer as well
> +with the "sync=off" and "sync=fs" mount option.
> +
> +"sync=off" option disables all forms of sync from overlay, including the
> +one done at umount/remount. If system crashes or shuts down, user
> +should throw away upper directory and start fresh.
> +
> +"sync=fs" option disables all forms of sync except full filesystem
> +sync which is done at syncfs/remount/mount time. This is useful for
> +use cases like container image build which want upper to persist
> +only if operation has finished. If system crashes before image
> +layer formation is complete, tools should discard upper and start
> +fresh.
>
>  Testsuite
>  ---------
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 79dd052c7dbf..3a5ae9c2f86e 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -128,7 +128,8 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
>         return error;
>  }
>
> -static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
> +static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
> +                           struct path *new, loff_t len)
>  {
>         struct file *old_file;
>         struct file *new_file;
> @@ -218,7 +219,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>                 len -= bytes;
>         }
>  out:
> -       if (!error)
> +       if (!error && ovl_should_fsync(ofs))
>                 error = vfs_fsync(new_file, 0);
>         fput(new_file);
>  out_fput:
> @@ -484,6 +485,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
>
>  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>  {
> +       struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
>         int err;
>
>         /*
> @@ -499,7 +501,8 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>                 upperpath.dentry = temp;
>
>                 ovl_path_lowerdata(c->dentry, &datapath);
> -               err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
> +               err = ovl_copy_up_data(ofs, &datapath, &upperpath,
> +                                      c->stat.size);
>                 if (err)
>                         return err;
>         }
> @@ -784,6 +787,7 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
>  /* Copy up data of an inode which was copied up metadata only in the past. */
>  static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>  {
> +       struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
>         struct path upperpath, datapath;
>         int err;
>         char *capability = NULL;
> @@ -804,7 +808,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>                         goto out;
>         }
>
> -       err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
> +       err = ovl_copy_up_data(ofs, &datapath, &upperpath, c->stat.size);
>         if (err)
>                 goto out_free;
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 01820e654a21..c92af3856dbf 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -329,6 +329,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>         struct fd real;
>         const struct cred *old_cred;
>         ssize_t ret;
> +       int ifl = iocb->ki_flags;
>
>         if (!iov_iter_count(iter))
>                 return 0;
> @@ -344,11 +345,14 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>         if (ret)
>                 goto out_unlock;
>
> +       if (!ovl_should_fsync(OVL_FS(inode->i_sb)))
> +               ifl &= ~(IOCB_DSYNC | IOCB_SYNC);
> +
>         old_cred = ovl_override_creds(file_inode(file)->i_sb);
>         if (is_sync_kiocb(iocb)) {
>                 file_start_write(real.file);
>                 ret = vfs_iter_write(real.file, iter, &iocb->ki_pos,
> -                                    ovl_iocb_to_rwf(iocb->ki_flags));
> +                                    ovl_iocb_to_rwf(ifl));
>                 file_end_write(real.file);
>                 /* Update size */
>                 ovl_copyattr(ovl_inode_real(inode), inode);
> @@ -368,6 +372,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>                 real.flags = 0;
>                 aio_req->orig_iocb = iocb;
>                 kiocb_clone(&aio_req->iocb, iocb, real.file);
> +               aio_req->iocb.ki_flags = ifl;
>                 aio_req->iocb.ki_complete = ovl_aio_rw_complete;
>                 ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
>                 if (ret != -EIOCBQUEUED)
> @@ -431,6 +436,9 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>         const struct cred *old_cred;
>         int ret;
>
> +       if (!ovl_should_fsync(OVL_FS(file_inode(file)->i_sb)))
> +               return 0;
> +
>         ret = ovl_real_fdget_meta(file, &real, !datasync);
>         if (ret)
>                 return ret;
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index b429c80879ee..e6d21eff5620 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -5,6 +5,12 @@
>   * Copyright (C) 2016 Red Hat, Inc.
>   */
>
> +enum ovl_sync_type {
> +       OVL_SYNC_ON,
> +       OVL_SYNC_OFF,
> +       OVL_SYNC_FS,
> +};
> +
>  struct ovl_config {
>         char *lowerdir;
>         char *upperdir;
> @@ -17,6 +23,7 @@ struct ovl_config {
>         bool nfs_export;
>         int xino;
>         bool metacopy;
> +       enum ovl_sync_type sync;
>  };
>
>  struct ovl_sb {
> @@ -90,6 +97,16 @@ static inline struct ovl_fs *OVL_FS(struct super_block *sb)
>         return (struct ovl_fs *)sb->s_fs_info;
>  }
>
> +static inline bool ovl_should_fsync(struct ovl_fs *ofs)
> +{
> +       return ofs->config.sync == OVL_SYNC_ON;
> +}
> +
> +static inline bool ovl_should_syncfs(struct ovl_fs *ofs)
> +{
> +       return ofs->config.sync != OVL_SYNC_OFF;
> +}
> +
>  /* private information held for every overlayfs dentry */
>  struct ovl_entry {
>         union {
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 6918b98faeb6..80f772faad5c 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -863,6 +863,9 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
>         if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
>                 return 0;
>
> +       if (!ovl_should_fsync(OVL_FS(dentry->d_sb)))
> +               return 0;
> +
>         /*
>          * Need to check if we started out being a lower dir, but got copied up
>          */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 91476bc422f9..04f6108fdc69 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -264,6 +264,8 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>         if (!ovl_upper_mnt(ofs))
>                 return 0;
>
> +       if (!ovl_should_syncfs(ofs))
> +               return 0;
>         /*
>          * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
>          * All the super blocks will be iterated, including upper_sb.
> @@ -327,6 +329,12 @@ static const char * const ovl_xino_str[] = {
>         "on",
>  };
>
> +static const char * const ovl_sync_str[] = {
> +       "on",
> +       "off",
> +       "fs",
> +};
> +
>  static inline int ovl_xino_def(void)
>  {
>         return ovl_xino_auto_def ? OVL_XINO_AUTO : OVL_XINO_OFF;
> @@ -362,6 +370,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         if (ofs->config.metacopy != ovl_metacopy_def)
>                 seq_printf(m, ",metacopy=%s",
>                            ofs->config.metacopy ? "on" : "off");
> +       if (ofs->config.sync != OVL_SYNC_ON)
> +               seq_printf(m, ",sync=%s", ovl_sync_str[ofs->config.sync]);
>         return 0;
>  }
>
> @@ -376,9 +386,11 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
>
>         if (*flags & SB_RDONLY && !sb_rdonly(sb)) {
>                 upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
> -               down_read(&upper_sb->s_umount);
> -               ret = sync_filesystem(upper_sb);
> -               up_read(&upper_sb->s_umount);
> +               if (ovl_should_syncfs(ofs)) {
> +                       down_read(&upper_sb->s_umount);
> +                       ret = sync_filesystem(upper_sb);
> +                       up_read(&upper_sb->s_umount);
> +               }
>         }
>
>         return ret;
> @@ -411,6 +423,8 @@ enum {
>         OPT_XINO_AUTO,
>         OPT_METACOPY_ON,
>         OPT_METACOPY_OFF,
> +       OPT_SYNC_OFF,
> +       OPT_SYNC_FS,
>         OPT_ERR,
>  };
>
> @@ -429,6 +443,8 @@ static const match_table_t ovl_tokens = {
>         {OPT_XINO_AUTO,                 "xino=auto"},
>         {OPT_METACOPY_ON,               "metacopy=on"},
>         {OPT_METACOPY_OFF,              "metacopy=off"},
> +       {OPT_SYNC_OFF,                  "sync=off"},
> +       {OPT_SYNC_FS,                   "sync=fs"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -573,6 +589,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         metacopy_opt = true;
>                         break;
>
> +               case OPT_SYNC_OFF:
> +                       config->sync = OVL_SYNC_OFF;
> +                       break;
> +
> +               case OPT_SYNC_FS:
> +                       config->sync = OVL_SYNC_FS;
> +                       break;
> +
>                 default:
>                         pr_err("unrecognized mount option \"%s\" or missing value\n",
>                                         p);
> @@ -588,6 +612,11 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                 config->workdir = NULL;
>         }
>
> +       if (!config->upperdir && config->sync) {
> +               pr_info("option sync=off/fs is meaningless in a non-upper mount, ignoring it.\n");
> +               config->sync = 0;
> +       }
> +
>         err = ovl_parse_redirect_mode(config, config->redirect_mode);
>         if (err)
>                 return err;
> --
> 2.25.4
>
