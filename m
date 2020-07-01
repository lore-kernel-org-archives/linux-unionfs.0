Return-Path: <SRS0=Dknc=AM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91FDC433DF
	for <linux-unionfs@archiver.kernel.org>; Wed,  1 Jul 2020 10:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7ED120747
	for <linux-unionfs@archiver.kernel.org>; Wed,  1 Jul 2020 10:31:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VHRterdT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbgGAKbP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 06:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729683AbgGAKbO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Jul 2020 06:31:14 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39494C061755
        for <linux-unionfs@vger.kernel.org>; Wed,  1 Jul 2020 03:31:14 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i25so24491891iog.0
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Jul 2020 03:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XO/Hz7ycQVlo8wUgQsJQttrQG1l06pIw6f6wWv5ZSAI=;
        b=VHRterdT0Y+qxbRiBcM76gUFEassF1E/VtAAy7xz9G5TAqy4Xm2b1WOzWiXEmRYXCB
         mAM1Yxb2CCoqC6UpUsd0AJ3CMF2B3Yk5BcE5grhqtMf8NZUpxxiaY+KcAa2KmIQwI2It
         HvOt9zFgQP+e9p6iRjnLsBqsHWOZ1n9NiHfF6uHpRyTDjnzVRmIWEdx9mJTwOgbsT1iI
         PtfdBNgcPYGAfcyIbIssceJ6QdCNql4TmJUGildPGxAm8Ja62HPBJt+g8wPiXgfTBzDB
         SGaSaukCfKgz07dYiexpZDgcWqUFckwDR6X2qebBXckLJnquev2xHWZCnSYMGddCax4d
         AzmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XO/Hz7ycQVlo8wUgQsJQttrQG1l06pIw6f6wWv5ZSAI=;
        b=M6Nk4Tu2aNvEEYJuvLMdyRgNA3W18uIt5k9haw45yQJJnVVboWMYrbVRNkBH4FghGb
         kw4y9EhqrZFwYpjSHtLxpFFlnLn+Ql8JYScvsVSYMJq3qSe/OyBCErUufK7BPWbrQEh5
         b+3KqpWyAs9KhM3QWfczWY5KpMRvse98J8SZiFEpVd1KJj5MKNzbXIIRRDjdA51eSeE4
         lvO87m9WfhFgBZEFym+YwyNNTKSoheYXd0w2qYJPyeG0t5FinHVBfAffI4eQS8l5RomG
         YEDtq6OWgfBwxAb5hW5ENZ6D9BuIGsM/BYrO3cMTAGGT/UF+dxk71Z9IlfTCKFhwt8Na
         38lg==
X-Gm-Message-State: AOAM532+tLcZZ+rBCVzo0Ksxo/eIpy1Cb3/2fucH+k/80k+cwQPN4SXm
        Z2CYaORMV1+2Ov6y/60kyM6ZUnT4Xt1+mDvXQh8=
X-Google-Smtp-Source: ABdhPJwrxwub6ERhjfPkfUzY6pgIz44nVPvnVGGBOdEJA0qOJRGcaSGwagz7A9S6tRhemqFRL7mvr+DeajSyP/KAS70=
X-Received: by 2002:a02:c903:: with SMTP id t3mr10415837jao.30.1593599472864;
 Wed, 01 Jul 2020 03:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200630193708.GB328891@redhat.com>
In-Reply-To: <20200630193708.GB328891@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 1 Jul 2020 13:31:01 +0300
Message-ID: <CAOQ4uxgkrZZ-QwyhyLKQ9GaH6a1zOrEfgSTtAge0Xyaz3LQChA@mail.gmail.com>
Subject: Re: [RFC PATCH] overlayfs: Provide a mount option "nosync" to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>, pmatilai@redhat.com,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 30, 2020 at 10:37 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Container folks are complaining that dnf/yum issues too many sync while
> installing packages and this slows down the image build. Build
> requirement is such that they don't care if a node goes down while
> build was still going on. In that case, they will simply throw away
> unfinished layer and start new build. So they don't care about syncing
> intermediate state to the disk and hence don't want to pay the price
> associated with sync.
>
> So they are asking for an option where they can disable sync on overlay
> mount point completely and user space will do sync management on upper
> layer as needed.
>

Sounds reasonable.
I have a lot of comments below, but the bottom line is if you change "nosync"
to "sync=off" and adapt documentation, the patch itself looks fine to me
for addressing the "volatile container" use case.

> They primarily seem to have two use cases.
>
> - For building images, they will mount overlay with nosync and then sync
>   upper layer after unmounting overlay and reuse upper as lower for next
>   layer.

This sentence reads to me as if "sync upper layer" is simple, which is not
entirely true. syncfs(2) will sync ALL the upper layers of all containers even
in the best case where the filesystem is dedicated to containers storage.
The fact is that for this specific use case, the most optimal handling would
have been "sync on unmount/remount/syncfs but skip fsync".

But of course, without improving the implementation of ovl_sync_fs(),
this is currently equivalent to what you are describing.
Still I feel that we do need to make this distinction and provide mount option
"sync=fs" instead of letting the container runtime take care of
"syncing upper layer"
this way when the day comes and "sync=fs" is properly implemented,
all container runtimes will win on kernel upgrade.

>
> - For running containers, they don't seem to care about syncing upper
>   layer because if node goes down, they will simply throw away upper
>   layer and create a fresh one.
>
> So this patch provides a mount option "nosync" which disables all forms
> of sync. Now it is caller's responsibility to manage sync of upper layer
> before it is reused again.
>
> I am seeing roughly 20% speed up in my VM where I am just installing
> emacs in an image. Installation time drops from 31 seconds to 25 seconds
> when nosync option is used. This is for the case of building on top
> of an image where all packages are already cached. That way I take
> out the network operations latency out of the measurement.
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
>  Documentation/filesystems/overlayfs.rst | 20 ++++++++++++++++++++
>  fs/overlayfs/copy_up.c                  | 12 ++++++++----
>  fs/overlayfs/file.c                     | 11 ++++++++++-
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/readdir.c                  |  3 +++
>  fs/overlayfs/super.c                    | 23 ++++++++++++++++++++---
>  6 files changed, 62 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 660dbaf0b9b8..0a42f26a3f0c 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -563,6 +563,26 @@ This verification may cause significant overhead in some cases.
>  Note: the mount options index=off,nfs_export=on are conflicting and will
>  result in an error.
>
> +Disable sync
> +------------
> +By default, overlay skips sync on files residing on a lower layer.  It
> +is possible to skip sync operations for files on the upper layer as well
> +with the 'nosync' mount option. This option disables all forms of sync
> +from overlay, including the one done at umount/remount and it is
> +user's responsibility to sync upper layer on the file system it
> +is residing.
> +
> +With this option, data loss will happen if overlayfs upper layer is
> +not synced. So use this option very carefully. This is only for the
> +use cases where users discard upper layer if they could not sync it
> +successfully.
> +
> +Typically workflow will be.
> +
> +- mount overlay
> +- Do bunch of operations
> +- unmount overlay
> +- sync filesystem container upper layer

I don't like to document this workflow, because I think it is wrong.
Please document only the "volatile container" use case for "sync=off".

>
>  Testsuite
>  ---------
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 79dd052c7dbf..5431a89bbd8a 100644
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
> +       if (!error && !ofs->config.nosync)
>                 error = vfs_fsync(new_file, 0);

Two points about this:

1. The purpose of this particular fsync is different from user requested fsync.
Example:
If a user chowns all files in a tree on xfs/ext4, ~1 minute later,
changes will likely
be safely stored because of periodic journal commit.
This is not a filesystem guaranty, but that's the way it is and if that were to
change, surely some users will notice and complain as happened in the past
with ext3 -> ext4 transition [1].

If a user chowns all files in a tree on overlay (without metacopy)
over xfs/ext4,
~1 minute later, changes will not have been safely stored if it wasn't
for this fsync.
The reason is delayed allocation of blocks of the new upper file.
ext4 has some heuristics in place to start writeback after rename over a file
(see NO_AUTO_DA_ALLOC), but not for linking an O_TMPFILE.

2. What could be useful is a mount option (e.g. sync=writeback) to convert this
vfs_fsync() to either filemap_flush() or filemap_fdatawrite().
This will start writeback on the new file with/without blocking and
without issuing
any FLUSH to block layer. Periodic journal commit will take care of the rest.
Again, this is not a guarantee that filesystems make and my attempts
to formalize
this as an user API in LSFMM did not go far, but it is a powerful tool
that container
administrators who know which underlying filesystem they use can make use of
and the performance benefit for setup of thousands of containers should be very
noticeable.

[1] https://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-length-file-problem/


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
> index 01820e654a21..a361890a8d05 100644
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
> +       if (OVL_FS(inode->i_sb)->config.nosync)
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
> @@ -430,6 +435,10 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>         struct fd real;
>         const struct cred *old_cred;
>         int ret;
> +       struct ovl_fs *ofs = OVL_FS(file_inode(file)->i_sb);
> +
> +       if (ofs->config.nosync)
> +               return 0;
>

Can convert the vfs_sync_range() to filemap_fdatawrite_range() with
"sync=writeback"

>         ret = ovl_real_fdget_meta(file, &real, !datasync);
>         if (ret)
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index b429c80879ee..034a8d9897e0 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -17,6 +17,7 @@ struct ovl_config {
>         bool nfs_export;
>         int xino;
>         bool metacopy;
> +       bool nosync;
>  };
>
>  struct ovl_sb {
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 6918b98faeb6..9e93db028dbf 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -863,6 +863,9 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
>         if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
>                 return 0;
>
> +       if (OVL_FS(dentry->d_sb)->config.nosync)
> +               return 0;
> +
>         /*
>          * Need to check if we started out being a lower dir, but got copied up
>          */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 91476bc422f9..c28ab39b5c70 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -264,6 +264,8 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>         if (!ovl_upper_mnt(ofs))
>                 return 0;
>
> +       if (ofs->config.nosync)
> +               return 0;

I'd be happier if we implement "sync=off/fs" from the start, or at least make
ofs->config.sync an enum or bit mask to represent these modes, even if
we only implement mount option "sync=off" to begin with.

>         /*
>          * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
>          * All the super blocks will be iterated, including upper_sb.
> @@ -362,6 +364,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         if (ofs->config.metacopy != ovl_metacopy_def)
>                 seq_printf(m, ",metacopy=%s",
>                            ofs->config.metacopy ? "on" : "off");
> +       if (ofs->config.nosync)
> +               seq_puts(m, ",nosync");
>         return 0;
>  }
>
> @@ -376,9 +380,11 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
>
>         if (*flags & SB_RDONLY && !sb_rdonly(sb)) {
>                 upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
> -               down_read(&upper_sb->s_umount);
> -               ret = sync_filesystem(upper_sb);
> -               up_read(&upper_sb->s_umount);
> +               if (!ofs->config.nosync) {
> +                       down_read(&upper_sb->s_umount);
> +                       ret = sync_filesystem(upper_sb);
> +                       up_read(&upper_sb->s_umount);
> +               }
>         }
>
>         return ret;
> @@ -411,6 +417,7 @@ enum {
>         OPT_XINO_AUTO,
>         OPT_METACOPY_ON,
>         OPT_METACOPY_OFF,
> +       OPT_NOSYNC,
>         OPT_ERR,
>  };
>
> @@ -429,6 +436,7 @@ static const match_table_t ovl_tokens = {
>         {OPT_XINO_AUTO,                 "xino=auto"},
>         {OPT_METACOPY_ON,               "metacopy=on"},
>         {OPT_METACOPY_OFF,              "metacopy=off"},
> +       {OPT_NOSYNC,                    "nosync"},

As should be very clear by now, I prefer that we call the option "sync=off",
so that we can later (or now) also implement "sync=fs" and maybe also
"sync=writeback", but plus that one semantic change, I am fine with the
patch as is.

Thanks,
Amir.
