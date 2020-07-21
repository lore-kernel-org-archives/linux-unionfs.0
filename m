Return-Path: <SRS0=wxOy=BA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2612C433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Jul 2020 13:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 937D520717
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Jul 2020 13:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="bFyaybPl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgGUNQJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 09:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgGUNQI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Jul 2020 09:16:08 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BB0C061794
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Jul 2020 06:16:08 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id rk21so21621404ejb.2
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Jul 2020 06:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dn2TsBkW6f5+a7a25abjEcG5m7fkrlRN2Nj2Y1lEVuY=;
        b=bFyaybPl8jURkfMi5lZRvwEB4kKTxtxc6ZfBl1Kai4KaJ9wUC+N9OeIMmTshi2DdJV
         gwDjvvXto/LfhACvbOjWcrAmYNL/4rtnpEG5kUwQF2YTnUp769ZgkxU7Aqt1NxU1gVlt
         Cez3qSKZbwrcwBVzHwOMxTVKHB2E+axLBLJVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dn2TsBkW6f5+a7a25abjEcG5m7fkrlRN2Nj2Y1lEVuY=;
        b=TuyEdTe8hVzPuVgNOJCGjgRW2+Tj4z3zikNrQMInnYLSM+JtZNc4TWREU7ngIEj5Fp
         ZjtDrcMW/OQgJkPU4rs1GNPb7dzR5nMvMZNj/9R7RjiAT5uJFsyxeMnUSWRPjmKf5A6Y
         /fBkWLVl1F6MuNPwpE8LuUQRpiNvIvwkXKKNQrWerMLhCZKu6Q40t/MfUDc3C1jkYue5
         dh6/RzXPTzq7EFzeTMMqrHTHidc2mmI79RuixQgXHPg6NBcIpoNCq7LTccIh4Azz9TCu
         ujVL2bUxahXmfXgRVfwTYkWO8tR2TnHbhHLBGHNA1AQq6Wa+5boA2D2f+NndVni0+5al
         OB0g==
X-Gm-Message-State: AOAM530u9xItMu7xRtq9MB4WpqqefqRb1iowD1fgYhh/29id/aj0HnbE
        sw1pSKmIGF43RKMKvV8Q/jjjUizz2lCXIy+WFwizeg==
X-Google-Smtp-Source: ABdhPJwhrieuuUKXVF6WVrp6Ktb9dJG8uOYrV7LqKpCpgLJNrB0/D8roi8YNR+F+gEGdE8p3I3/zVsOAMrwSi4inxa8=
X-Received: by 2002:a17:906:1c05:: with SMTP id k5mr24643455ejg.320.1595337366780;
 Tue, 21 Jul 2020 06:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200706161227.GB3107@redhat.com> <CAJfpegtBjv60ZYJYSgQfU9EFx+eMbjqzcZ1HFV8P2nL64x5D2A@mail.gmail.com>
 <20200720161618.GD502563@redhat.com>
In-Reply-To: <20200720161618.GD502563@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 21 Jul 2020 15:15:55 +0200
Message-ID: <CAJfpegt2k=r6TRok57tKPcLyUhCBOcBAV7bgLSPrQYXsPoPkpQ@mail.gmail.com>
Subject: Re: [PATCH v4] overlayfs: Provide mount options sync=off/fs to skip sync
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>, pmatilai@redhat.com,
        sandeen@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 20, 2020 at 6:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> For building images containers folks need to sync upper layer. Their
> current plan is to use "syncfs upper/" because it is same as if overlay
> was mounted with sync=fs. But this syncs whole upper filesystem and
> not just upper of a particular overlayfs instance
>
> So idea was to provide sync=fs from the beginning and ask container
> folks to use this. So that in future if we can optimize sync=fs to
> sync selctive inodes, then container runtime will automatically
> benefit from it without any changes. It also reduces the chances
> of error on container runtime which fail to sync upper.  Hence idea
> of sync=fs sounded appleaing to me.

Not sure I understand the reason for sync=fs?  Should it rather be
sync=shutdown?

>
> Havid said that, I am open to dropping sync=fs for now, if you don't
> see the value at this point of time.

At this point it doesn't add any usefulness, so let's just drop it.

> >
> > Naming: I'm not at all convinced by any name having "sync" in it.  I
> > think "sync=no" is about the implementation, not the functionality,
> > and so it's confusing. The functionality is better described by
> > "volatile" or "temporary".   But I can live with sync=... if voted
> > down.
>
> I am fine with the name "volatile/temporary" for sync=off.

How about needing "volatile" for all kinds of modes that reduce the
normal durability/integrity guarantees.  Then additional "sync=foobar"
option to control the details?

Thanks,
Miklos



>
> Amir, WDYT?
>
> Vivek
>
> >
> >
> >
> >
> >
> > >
> > > Giuseppe is also looking to cut down on number of iops done on the
> > > disk. He is complaining that often in cloud their VMs are throttled
> > > if they cross the limit. This option can help them where they reduce
> > > number of iops (by cutting down on frequent sync and writebacks).
> > >
> > > Changes from v3:
> > > - Used only enums and dropped bit flags (Amir Goldstein)
> > > - Dropped error when conflicting sync options provided. (Amir Goldstein)
> > >
> > > Changes from v2:
> > > - Added helper functions (Amir Goldstein)
> > > - Used enums to keep sync state (Amir Goldstein)
> > >
> > > Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  Documentation/filesystems/overlayfs.rst | 16 +++++++++++
> > >  fs/overlayfs/copy_up.c                  | 12 ++++++---
> > >  fs/overlayfs/file.c                     | 10 ++++++-
> > >  fs/overlayfs/ovl_entry.h                | 17 ++++++++++++
> > >  fs/overlayfs/readdir.c                  |  3 +++
> > >  fs/overlayfs/super.c                    | 35 ++++++++++++++++++++++---
> > >  6 files changed, 85 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> > > index 660dbaf0b9b8..4e55ac4433ec 100644
> > > --- a/Documentation/filesystems/overlayfs.rst
> > > +++ b/Documentation/filesystems/overlayfs.rst
> > > @@ -563,6 +563,22 @@ This verification may cause significant overhead in some cases.
> > >  Note: the mount options index=off,nfs_export=on are conflicting and will
> > >  result in an error.
> > >
> > > +Disable sync
> > > +------------
> > > +By default, overlay skips sync on files residing on a lower layer.  It
> > > +is possible to skip sync operations for files on the upper layer as well
> > > +with the "sync=off" and "sync=fs" mount option.
> > > +
> > > +"sync=off" option disables all forms of sync from overlay, including the
> > > +one done at umount/remount. If system crashes or shuts down, user
> > > +should throw away upper directory and start fresh.
> > > +
> > > +"sync=fs" option disables all forms of sync except full filesystem
> > > +sync which is done at syncfs/remount/mount time. This is useful for
> > > +use cases like container image build which want upper to persist
> > > +only if operation has finished. If system crashes before image
> > > +layer formation is complete, tools should discard upper and start
> > > +fresh.
> > >
> > >  Testsuite
> > >  ---------
> > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > index 79dd052c7dbf..3a5ae9c2f86e 100644
> > > --- a/fs/overlayfs/copy_up.c
> > > +++ b/fs/overlayfs/copy_up.c
> > > @@ -128,7 +128,8 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
> > >         return error;
> > >  }
> > >
> > > -static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
> > > +static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
> > > +                           struct path *new, loff_t len)
> > >  {
> > >         struct file *old_file;
> > >         struct file *new_file;
> > > @@ -218,7 +219,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
> > >                 len -= bytes;
> > >         }
> > >  out:
> > > -       if (!error)
> > > +       if (!error && ovl_should_fsync(ofs))
> > >                 error = vfs_fsync(new_file, 0);
> > >         fput(new_file);
> > >  out_fput:
> > > @@ -484,6 +485,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
> > >
> > >  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> > >  {
> > > +       struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
> > >         int err;
> > >
> > >         /*
> > > @@ -499,7 +501,8 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> > >                 upperpath.dentry = temp;
> > >
> > >                 ovl_path_lowerdata(c->dentry, &datapath);
> > > -               err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
> > > +               err = ovl_copy_up_data(ofs, &datapath, &upperpath,
> > > +                                      c->stat.size);
> > >                 if (err)
> > >                         return err;
> > >         }
> > > @@ -784,6 +787,7 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
> > >  /* Copy up data of an inode which was copied up metadata only in the past. */
> > >  static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
> > >  {
> > > +       struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
> > >         struct path upperpath, datapath;
> > >         int err;
> > >         char *capability = NULL;
> > > @@ -804,7 +808,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
> > >                         goto out;
> > >         }
> > >
> > > -       err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
> > > +       err = ovl_copy_up_data(ofs, &datapath, &upperpath, c->stat.size);
> > >         if (err)
> > >                 goto out_free;
> > >
> > > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > > index 01820e654a21..c92af3856dbf 100644
> > > --- a/fs/overlayfs/file.c
> > > +++ b/fs/overlayfs/file.c
> > > @@ -329,6 +329,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
> > >         struct fd real;
> > >         const struct cred *old_cred;
> > >         ssize_t ret;
> > > +       int ifl = iocb->ki_flags;
> > >
> > >         if (!iov_iter_count(iter))
> > >                 return 0;
> > > @@ -344,11 +345,14 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
> > >         if (ret)
> > >                 goto out_unlock;
> > >
> > > +       if (!ovl_should_fsync(OVL_FS(inode->i_sb)))
> > > +               ifl &= ~(IOCB_DSYNC | IOCB_SYNC);
> > > +
> > >         old_cred = ovl_override_creds(file_inode(file)->i_sb);
> > >         if (is_sync_kiocb(iocb)) {
> > >                 file_start_write(real.file);
> > >                 ret = vfs_iter_write(real.file, iter, &iocb->ki_pos,
> > > -                                    ovl_iocb_to_rwf(iocb->ki_flags));
> > > +                                    ovl_iocb_to_rwf(ifl));
> > >                 file_end_write(real.file);
> > >                 /* Update size */
> > >                 ovl_copyattr(ovl_inode_real(inode), inode);
> > > @@ -368,6 +372,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
> > >                 real.flags = 0;
> > >                 aio_req->orig_iocb = iocb;
> > >                 kiocb_clone(&aio_req->iocb, iocb, real.file);
> > > +               aio_req->iocb.ki_flags = ifl;
> > >                 aio_req->iocb.ki_complete = ovl_aio_rw_complete;
> > >                 ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
> > >                 if (ret != -EIOCBQUEUED)
> > > @@ -431,6 +436,9 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
> > >         const struct cred *old_cred;
> > >         int ret;
> > >
> > > +       if (!ovl_should_fsync(OVL_FS(file_inode(file)->i_sb)))
> > > +               return 0;
> > > +
> > >         ret = ovl_real_fdget_meta(file, &real, !datasync);
> > >         if (ret)
> > >                 return ret;
> > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > > index b429c80879ee..e6d21eff5620 100644
> > > --- a/fs/overlayfs/ovl_entry.h
> > > +++ b/fs/overlayfs/ovl_entry.h
> > > @@ -5,6 +5,12 @@
> > >   * Copyright (C) 2016 Red Hat, Inc.
> > >   */
> > >
> > > +enum ovl_sync_type {
> > > +       OVL_SYNC_ON,
> > > +       OVL_SYNC_OFF,
> > > +       OVL_SYNC_FS,
> > > +};
> > > +
> > >  struct ovl_config {
> > >         char *lowerdir;
> > >         char *upperdir;
> > > @@ -17,6 +23,7 @@ struct ovl_config {
> > >         bool nfs_export;
> > >         int xino;
> > >         bool metacopy;
> > > +       enum ovl_sync_type sync;
> > >  };
> > >
> > >  struct ovl_sb {
> > > @@ -90,6 +97,16 @@ static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> > >         return (struct ovl_fs *)sb->s_fs_info;
> > >  }
> > >
> > > +static inline bool ovl_should_fsync(struct ovl_fs *ofs)
> > > +{
> > > +       return ofs->config.sync == OVL_SYNC_ON;
> > > +}
> > > +
> > > +static inline bool ovl_should_syncfs(struct ovl_fs *ofs)
> > > +{
> > > +       return ofs->config.sync != OVL_SYNC_OFF;
> > > +}
> > > +
> > >  /* private information held for every overlayfs dentry */
> > >  struct ovl_entry {
> > >         union {
> > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > index 6918b98faeb6..80f772faad5c 100644
> > > --- a/fs/overlayfs/readdir.c
> > > +++ b/fs/overlayfs/readdir.c
> > > @@ -863,6 +863,9 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
> > >         if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
> > >                 return 0;
> > >
> > > +       if (!ovl_should_fsync(OVL_FS(dentry->d_sb)))
> > > +               return 0;
> > > +
> > >         /*
> > >          * Need to check if we started out being a lower dir, but got copied up
> > >          */
> > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > > index 91476bc422f9..04f6108fdc69 100644
> > > --- a/fs/overlayfs/super.c
> > > +++ b/fs/overlayfs/super.c
> > > @@ -264,6 +264,8 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
> > >         if (!ovl_upper_mnt(ofs))
> > >                 return 0;
> > >
> > > +       if (!ovl_should_syncfs(ofs))
> > > +               return 0;
> > >         /*
> > >          * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
> > >          * All the super blocks will be iterated, including upper_sb.
> > > @@ -327,6 +329,12 @@ static const char * const ovl_xino_str[] = {
> > >         "on",
> > >  };
> > >
> > > +static const char * const ovl_sync_str[] = {
> > > +       "on",
> > > +       "off",
> > > +       "fs",
> > > +};
> > > +
> > >  static inline int ovl_xino_def(void)
> > >  {
> > >         return ovl_xino_auto_def ? OVL_XINO_AUTO : OVL_XINO_OFF;
> > > @@ -362,6 +370,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
> > >         if (ofs->config.metacopy != ovl_metacopy_def)
> > >                 seq_printf(m, ",metacopy=%s",
> > >                            ofs->config.metacopy ? "on" : "off");
> > > +       if (ofs->config.sync != OVL_SYNC_ON)
> > > +               seq_printf(m, ",sync=%s", ovl_sync_str[ofs->config.sync]);
> > >         return 0;
> > >  }
> > >
> > > @@ -376,9 +386,11 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
> > >
> > >         if (*flags & SB_RDONLY && !sb_rdonly(sb)) {
> > >                 upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
> > > -               down_read(&upper_sb->s_umount);
> > > -               ret = sync_filesystem(upper_sb);
> > > -               up_read(&upper_sb->s_umount);
> > > +               if (ovl_should_syncfs(ofs)) {
> > > +                       down_read(&upper_sb->s_umount);
> > > +                       ret = sync_filesystem(upper_sb);
> > > +                       up_read(&upper_sb->s_umount);
> > > +               }
> > >         }
> > >
> > >         return ret;
> > > @@ -411,6 +423,8 @@ enum {
> > >         OPT_XINO_AUTO,
> > >         OPT_METACOPY_ON,
> > >         OPT_METACOPY_OFF,
> > > +       OPT_SYNC_OFF,
> > > +       OPT_SYNC_FS,
> > >         OPT_ERR,
> > >  };
> > >
> > > @@ -429,6 +443,8 @@ static const match_table_t ovl_tokens = {
> > >         {OPT_XINO_AUTO,                 "xino=auto"},
> > >         {OPT_METACOPY_ON,               "metacopy=on"},
> > >         {OPT_METACOPY_OFF,              "metacopy=off"},
> > > +       {OPT_SYNC_OFF,                  "sync=off"},
> > > +       {OPT_SYNC_FS,                   "sync=fs"},
> > >         {OPT_ERR,                       NULL}
> > >  };
> > >
> > > @@ -573,6 +589,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
> > >                         metacopy_opt = true;
> > >                         break;
> > >
> > > +               case OPT_SYNC_OFF:
> > > +                       config->sync = OVL_SYNC_OFF;
> > > +                       break;
> > > +
> > > +               case OPT_SYNC_FS:
> > > +                       config->sync = OVL_SYNC_FS;
> > > +                       break;
> > > +
> > >                 default:
> > >                         pr_err("unrecognized mount option \"%s\" or missing value\n",
> > >                                         p);
> > > @@ -588,6 +612,11 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
> > >                 config->workdir = NULL;
> > >         }
> > >
> > > +       if (!config->upperdir && config->sync) {
> > > +               pr_info("option sync=off/fs is meaningless in a non-upper mount, ignoring it.\n");
> > > +               config->sync = 0;
> > > +       }
> > > +
> > >         err = ovl_parse_redirect_mode(config, config->redirect_mode);
> > >         if (err)
> > >                 return err;
> > > --
> > > 2.25.4
> > >
> >
>
