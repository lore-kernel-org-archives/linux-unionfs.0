Return-Path: <SRS0=vZRj=EM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32AFAC2D0A3
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Nov 2020 17:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D197206FA
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Nov 2020 17:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="Fo6JMNUr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgKFR7S (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Nov 2020 12:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgKFR7S (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Nov 2020 12:59:18 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B108FC0613CF
        for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2020 09:59:17 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id ay21so2166517edb.2
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2020 09:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+iZwYnzGrmmMzy5GlFwDbh4OSlBABjGsENyUdBEl/jQ=;
        b=Fo6JMNUrOVzm6ZpoU7h/L2WVQAFyAEVCSx9I3jDAQWwDFXKIEsDTJA6P+aBklBEVIM
         zvaLm8YDJbiHzdj9zv77GQzGiGqNJX09CaUKKBpXXg106d+5OtpXS9fQdICvozhqlvtF
         ikZ+zPgBB46CzQJ6/Ch82V5LwMVFH3fWmUnV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+iZwYnzGrmmMzy5GlFwDbh4OSlBABjGsENyUdBEl/jQ=;
        b=uTAdDqNuLU3Vx25fXpp71I2VindDsoqPcA8WrPOwAp87ZwsK/D6v5SAF0UNjfZIO2y
         GN6CAmXqFWv7rzgwn8yNstS2+tMju26H3yjtUYWqW/xi1eNXrzFwUqYl0dUFNv9cGibG
         5DecDnN/kKcwU7gESRW62Xxacn/DztFGA2S5J+PCx4d+u7yxmWgeBYO8EO0aGn29iR3A
         7XughalRpC/9ZuTVgTZ72LTobP8at75Gwxk+2lkQy6sKqMgtDvzqZXSpIN5QmAVS1lhG
         BK+68cGfqrI9/SDVW9W2qIKj36VZQsgdTUTISlQYFSfhRcspsAa458HjhpWngDYT4S16
         7eYg==
X-Gm-Message-State: AOAM531Gu2GwaTCnkzDWOADw2cv8R1VCLmoPQbb3jr+3x9Hquu+LJxUM
        KTLtivNdIpjXjKdI7jDv15s7JRfAKovDUCgzLbmrXg==
X-Google-Smtp-Source: ABdhPJyN+kaTzQ+CmVA9oMY53oSkPObTKcHNasnIPngP63toGaNK0VuFG6ZytFBoFBjn/5i7qbxLkas+1JHm8Zb1Mtg=
X-Received: by 2002:aa7:d709:: with SMTP id t9mr3377758edq.305.1604685556035;
 Fri, 06 Nov 2020 09:59:16 -0800 (PST)
MIME-Version: 1.0
References: <20200831181529.GA1193654@redhat.com>
In-Reply-To: <20200831181529.GA1193654@redhat.com>
From:   Sargun Dhillon <sargun@sargun.me>
Date:   Fri, 6 Nov 2020 09:58:39 -0800
Message-ID: <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 31, 2020 at 11:15 AM Vivek Goyal <vgoyal@redhat.com> wrote:
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
> So this patch provides a mount option "volatile" which disables all forms
> of sync. Now it is caller's responsibility to throw away upper if
> system crashes or shuts down and start fresh.
>
> With "volatile", I am seeing roughly 20% speed up in my VM where I am just
> installing emacs in an image. Installation time drops from 31 seconds to
> 25 seconds when nosync option is used. This is for the case of building on top
> of an image where all packages are already cached. That way I take
> out the network operations latency out of the measurement.
>
> Giuseppe is also looking to cut down on number of iops done on the
> disk. He is complaining that often in cloud their VMs are throttled
> if they cross the limit. This option can help them where they reduce
> number of iops (by cutting down on frequent sync and writebacks).
>
> Changes from v6:
> - Got rid of logic to check for volatile/dirty file. Now Amir's
>   patch checks for presence of incomat/volatile directory and errors
>   out if present. User is now required to remove volatile
>   directory. (Amir).
>
> Changes from v5:
> - Added support to detect that previous overlay was mounted with
>   "volatile" option and fail mount. (Miklos and Amir).
>
> Changes from v4:
> - Dropped support for sync=fs (Miklos)
> - Renamed "sync=off" to "volatile". (Miklos)
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
>  Documentation/filesystems/overlayfs.rst | 17 +++++
>  fs/overlayfs/copy_up.c                  | 12 ++--
>  fs/overlayfs/file.c                     | 10 ++-
>  fs/overlayfs/ovl_entry.h                |  6 ++
>  fs/overlayfs/readdir.c                  |  3 +
>  fs/overlayfs/super.c                    | 88 ++++++++++++++++++++++++-
>  6 files changed, 128 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 8ea83a51c266..b33465fdf260 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -563,6 +563,23 @@ This verification may cause significant overhead in some cases.
>  Note: the mount options index=off,nfs_export=on are conflicting for a
>  read-write mount and will result in an error.
>
> +Disable sync
> +------------
> +By default, overlay skips sync on files residing on a lower layer.  It
> +is possible to skip sync operations for files on the upper layer as well
> +with the "volatile" mount option.
> +
> +"volatile" mount option disables all forms of sync from overlay, including
> +the one done at umount/remount. If system crashes or shuts down, user
> +should throw away upper directory and start fresh.
> +
> +When overlay is mounted with "volatile" option, overlay creates an internal
> +directory "$workdir/work/incompat/volatile". During next mount, overlay
> +checks for this directory and refuses to mount if present. This is a strong
> +indicator that user should throw away upper and work directories and
> +create fresh one. In very limited cases where user knows system has not
> +crashed and contents in upperdir are intact, one can remove the "volatile"
> +directory and retry mount.
>
>  Testsuite
>  ---------
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index d07fb92b7253..9d17e42d184b 100644
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
> +       if (!error && ovl_should_sync(ofs))
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
> index 0d940e29d62b..3582c3ae819c 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -331,6 +331,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>         struct fd real;
>         const struct cred *old_cred;
>         ssize_t ret;
> +       int ifl = iocb->ki_flags;
>
>         if (!iov_iter_count(iter))
>                 return 0;
> @@ -346,11 +347,14 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>         if (ret)
>                 goto out_unlock;
>
> +       if (!ovl_should_sync(OVL_FS(inode->i_sb)))
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
> @@ -370,6 +374,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>                 real.flags = 0;
>                 aio_req->orig_iocb = iocb;
>                 kiocb_clone(&aio_req->iocb, iocb, real.file);
> +               aio_req->iocb.ki_flags = ifl;
>                 aio_req->iocb.ki_complete = ovl_aio_rw_complete;
>                 ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
>                 if (ret != -EIOCBQUEUED)
> @@ -433,6 +438,9 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>         const struct cred *old_cred;
>         int ret;
>
> +       if (!ovl_should_sync(OVL_FS(file_inode(file)->i_sb)))
> +               return 0;
> +
>         ret = ovl_real_fdget_meta(file, &real, !datasync);
>         if (ret)
>                 return ret;
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index b429c80879ee..1b5a2094df8e 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -17,6 +17,7 @@ struct ovl_config {
>         bool nfs_export;
>         int xino;
>         bool metacopy;
> +       bool ovl_volatile;
>  };
>
>  struct ovl_sb {
> @@ -90,6 +91,11 @@ static inline struct ovl_fs *OVL_FS(struct super_block *sb)
>         return (struct ovl_fs *)sb->s_fs_info;
>  }
>
> +static inline bool ovl_should_sync(struct ovl_fs *ofs)
> +{
> +       return !ofs->config.ovl_volatile;
> +}
> +
>  /* private information held for every overlayfs dentry */
>  struct ovl_entry {
>         union {
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 683c6f27ab77..f50a9f20e72d 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -863,6 +863,9 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
>         if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
>                 return 0;
>
> +       if (!ovl_should_sync(OVL_FS(dentry->d_sb)))
> +               return 0;
> +
>         /*
>          * Need to check if we started out being a lower dir, but got copied up
>          */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 3cd47e4b2eae..f0f7ad8da4be 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -264,6 +264,8 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>         if (!ovl_upper_mnt(ofs))
>                 return 0;
>
> +       if (!ovl_should_sync(ofs))
> +               return 0;
>         /*
>          * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
>          * All the super blocks will be iterated, including upper_sb.
> @@ -362,6 +364,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         if (ofs->config.metacopy != ovl_metacopy_def)
>                 seq_printf(m, ",metacopy=%s",
>                            ofs->config.metacopy ? "on" : "off");
> +       if (ofs->config.ovl_volatile)
> +               seq_printf(m, ",volatile");
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
> +               if (ovl_should_sync(ofs)) {
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
> +       OPT_VOLATILE,
>         OPT_ERR,
>  };
>
> @@ -429,6 +436,7 @@ static const match_table_t ovl_tokens = {
>         {OPT_XINO_AUTO,                 "xino=auto"},
>         {OPT_METACOPY_ON,               "metacopy=on"},
>         {OPT_METACOPY_OFF,              "metacopy=off"},
> +       {OPT_VOLATILE,                  "volatile"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -573,6 +581,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         metacopy_opt = true;
>                         break;
>
> +               case OPT_VOLATILE:
> +                       config->ovl_volatile = true;
> +                       break;
> +
>                 default:
>                         pr_err("unrecognized mount option \"%s\" or missing value\n",
>                                         p);
> @@ -595,6 +607,11 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                 config->index = false;
>         }
>
> +       if (!config->upperdir && config->ovl_volatile) {
> +               pr_info("option \"volatile\" is meaningless in a non-upper mount, ignoring it.\n");
> +               config->ovl_volatile = false;
> +       }
> +
>         err = ovl_parse_redirect_mode(config, config->redirect_mode);
>         if (err)
>                 return err;
> @@ -1203,6 +1220,59 @@ static int ovl_check_rename_whiteout(struct dentry *workdir)
>         return err;
>  }
>
> +/*
> + * Creates $workdir/work/incompat/volatile/dirty file if it is not
> + * already present.
> + */
> +static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
> +{
> +       struct dentry *parent, *child;
> +       char *name;
> +       int i, len, err;
> +       char *dirty_path[] = {OVL_WORKDIR_NAME, "incompat", "volatile", "dirty"};
> +       int nr_elems = ARRAY_SIZE(dirty_path);
> +
> +       err = 0;
> +       parent = ofs->workbasedir;
> +       dget(parent);
> +
> +       for (i = 0; i < nr_elems; i++) {
> +               name = dirty_path[i];
> +               len = strlen(name);
> +               inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
> +               child = lookup_one_len(name, parent, len);
> +               if (IS_ERR(child)) {
> +                       err = PTR_ERR(child);
> +                       goto out_unlock;
> +               }
> +
> +               if (!child->d_inode) {
> +                       unsigned short ftype;
> +
> +                       ftype = (i == (nr_elems - 1)) ? S_IFREG : S_IFDIR;
> +                       child = ovl_create_real(parent->d_inode, child,
> +                                               OVL_CATTR(ftype | 0));
> +                       if (IS_ERR(child)) {
> +                               err = PTR_ERR(child);
> +                               goto out_unlock;
> +                       }
> +               }
> +
> +               inode_unlock(parent->d_inode);
> +               dput(parent);
> +               parent = child;
> +               child = NULL;
> +       }
> +
> +       dput(parent);
> +       return err;
> +
> +out_unlock:
> +       inode_unlock(parent->d_inode);
> +       dput(parent);
> +       return err;
> +}
> +
>  static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
>                             struct path *workpath)
>  {
> @@ -1286,6 +1356,18 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
>                 goto out;
>         }
>
> +       /*
> +        * For volatile mount, create a incompat/volatile/dirty file to keep
> +        * track of it.
> +        */
> +       if (ofs->config.ovl_volatile) {
> +               err = ovl_create_volatile_dirty(ofs);
> +               if (err < 0) {
> +                       pr_err("Failed to create volatile/dirty file.\n");
> +                       goto out;
> +               }
> +       }
> +
>         /* Check if upper/work fs supports file handles */
>         fh_type = ovl_can_decode_fh(ofs->workdir->d_sb);
>         if (ofs->config.index && !fh_type) {
> --
> 2.25.4
>
There is some slightly confusing behaviour here [I realize this
behaviour is as intended]:

(root) ~ # mount -t overlay -o
volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
none /mnt/foo
(root) ~ # umount /mnt/foo
(root) ~ # mount -t overlay -o
volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
none /mnt/foo
mount: /mnt/foo: wrong fs type, bad option, bad superblock on none,
missing codepage or helper program, or other error.

From my understanding, the dirty flag should only be a problem if the
existing overlayfs is unmounted uncleanly. Docker does
this (mount, and re-mounts) during startup time because it writes some
files to the overlayfs. I think that we should harden
the volatile check slightly, and make it so that within the same boot,
it's not a problem, and having to have the user clear
the workdir every time is a pain. In addition, the semantics of the
volatile patch itself do not appear to be such that they
would break mounts during the same boot / mount of upperdir -- as
overlayfs does not defer any writes in itself, and it's
only that it's short-circuiting writes to the upperdir.

Amir,
What do you think?
