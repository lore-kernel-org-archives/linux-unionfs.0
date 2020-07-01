Return-Path: <SRS0=Dknc=AM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4451DC433DF
	for <linux-unionfs@archiver.kernel.org>; Wed,  1 Jul 2020 19:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16C9320702
	for <linux-unionfs@archiver.kernel.org>; Wed,  1 Jul 2020 19:08:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1mynACb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgGATIk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 15:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGATIk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Jul 2020 15:08:40 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DF4C08C5C1
        for <linux-unionfs@vger.kernel.org>; Wed,  1 Jul 2020 12:08:40 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id a12so26234265ion.13
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Jul 2020 12:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V+MP94fdd7wfebxIho4tUqEPksR2usfs+LQ2oeBs438=;
        b=m1mynACbRuuvK+zxfAAkxyvawL2E6/4kOQ/QTLFpr3HGBProhU5s13svCq23iM7Nwo
         anOEhPZhqTN206FP7GP4D7xqYvbkKu0vGTl/bN2CxLYm9XEOY918QwPo2+za5cBBAow+
         trmrGgkdjcU7rsLhNCAr8kMa1BouUMYd/rN6id07shV6MtCaUhiWYBTZkK0QvCPtWqdc
         K9gzsywMg5CGSqJVspBRrPofVxV+08YzCAfr7zaD7v3h7IVUYSI0RjMYD/pTGmRDk/1k
         4Su6DEQ9POjPasj8TudTdW2G2TzDRKE9e+mYigSK4bz9A71mtfNV8AA3Wbiod+3cPa0r
         9PnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+MP94fdd7wfebxIho4tUqEPksR2usfs+LQ2oeBs438=;
        b=GLkJ+lnVpz8rQk2pDbJrKyCdyI5wxt8+ngWeFwyFHLslBiaTqfvROpam7nIpGDC+Ws
         Ea8EricUXYQhwPyTIFQ1KauUBWZGV2KMuHNoJoD2coLcpuUmlEK6JMnqDj2GG0B7kxKH
         iWKZKA2JhdhU5DhPcpOfKEwm4gmvHrrPIAlQZNaV2d61PWSDILw54Z/oB+3KmbSCjSXl
         LCAuw8itip1Xt2Ez6XPO+8J4trL6zkOrdC8QI/MeQaQS1OWRnQPvXfs3TYVPVIBP83GI
         3b/TRZXuaIK+7sYRc+KazW7ytz75FRHTh9GZVmRut1Ezvp5alYR5BervfwYOyXdpuJjC
         IZ3g==
X-Gm-Message-State: AOAM533FPVP7TLaeDwDWMDnQkZuvcBfo8dEWlopqbgL9RFHSMVg2sHNv
        /AaIVv+Ic58m1XLJ8rtCc6Kpa9lrf3ognPicrIGR1Zta
X-Google-Smtp-Source: ABdhPJzcS7AwjlNK9qw3to67hHXNhklHO0uQ/gxvpBdoVHESmf31ul/VKvtupCJFmg3qdWG/9W6O7A3opPkw5MKdV6k=
X-Received: by 2002:a02:a797:: with SMTP id e23mr3080751jaj.81.1593630519512;
 Wed, 01 Jul 2020 12:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200701175716.GA384828@redhat.com>
In-Reply-To: <20200701175716.GA384828@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 1 Jul 2020 22:08:28 +0300
Message-ID: <CAOQ4uxisFOkQF8eq5ysZYtdfd_Z26r5MHsdr+ozwz4ry+WuUEA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] overlayfs: Provide mount options sync=off/fs to
 skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>, pmatilai@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 1, 2020 at 8:57 PM Vivek Goyal <vgoyal@redhat.com> wrote:
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
> Opption "sync=fs" disables all forms of sync except syncfs/umount/remount.

typo: Opption

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
> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  Documentation/filesystems/overlayfs.rst | 16 +++++++++++
>  fs/overlayfs/copy_up.c                  | 12 +++++---
>  fs/overlayfs/file.c                     | 13 ++++++++-
>  fs/overlayfs/ovl_entry.h                |  2 ++
>  fs/overlayfs/readdir.c                  |  4 +++
>  fs/overlayfs/super.c                    | 37 +++++++++++++++++++++++--
>  6 files changed, 76 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 660dbaf0b9b8..4e8e44ee31aa 100644
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
> +one done at umount/remount. If system crashes or shuts down data, user
> +should throw away upper and start fresh.
> +
> +"sync=fs" option disables all forms of sync except full filesystem
> +sync which is done at syncfs/remount/mount time. This is useful for
> +use cases like container image build which want upper to persist
> +only if operation has finished. If system crashes before image
> +layer formation is complete, tools will discard upper and start
> +fresh.
>

Nice.

>  Testsuite
>  ---------
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 79dd052c7dbf..e576929d619d 100644
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
> +       if (!error && (!ofs->config.nosync && !ofs->config.syncfs))
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
> index 01820e654a21..2a01fb8ba897 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -329,6 +329,8 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>         struct fd real;
>         const struct cred *old_cred;
>         ssize_t ret;
> +       int ifl = iocb->ki_flags;
> +       struct ovl_fs *ofs;
>
>         if (!iov_iter_count(iter))
>                 return 0;
> @@ -344,11 +346,15 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>         if (ret)
>                 goto out_unlock;
>
> +       ofs = OVL_FS(inode->i_sb);
> +       if (ofs->config.nosync || ofs->config.syncfs)
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
> @@ -368,6 +374,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>                 real.flags = 0;
>                 aio_req->orig_iocb = iocb;
>                 kiocb_clone(&aio_req->iocb, iocb, real.file);
> +               aio_req->iocb.ki_flags = ifl;
>                 aio_req->iocb.ki_complete = ovl_aio_rw_complete;
>                 ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
>                 if (ret != -EIOCBQUEUED)
> @@ -430,6 +437,10 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>         struct fd real;
>         const struct cred *old_cred;
>         int ret;
> +       struct ovl_fs *ofs = OVL_FS(file_inode(file)->i_sb);
> +
> +       if (ofs->config.nosync || ofs->config.syncfs)
> +               return 0;
>
>         ret = ovl_real_fdget_meta(file, &real, !datasync);
>         if (ret)
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index b429c80879ee..473508f1a1da 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -17,6 +17,8 @@ struct ovl_config {
>         bool nfs_export;
>         int xino;
>         bool metacopy;
> +       bool nosync;
> +       bool syncfs;
>  };
>
>  struct ovl_sb {
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 6918b98faeb6..970319ca1623 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -858,11 +858,15 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
>         struct ovl_dir_file *od = file->private_data;
>         struct dentry *dentry = file->f_path.dentry;
>         struct file *realfile = od->realfile;
> +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
>
>         /* Nothing to sync for lower */
>         if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
>                 return 0;
>
> +       if (ofs->config.nosync || ofs->config.syncfs)
> +               return 0;
> +

Generally looks good, but those test conditions are quite weird IMO.
I would go for either enum or flags, but not up to me to decide.
But at the very least use inline helpers ovl_should_fsync(),
ovl_should_syncfs(), because if we want to add new sync modes or
whatever going over all those conditions and
changing them would be sub-optimal.

Thanks,
Amir.
