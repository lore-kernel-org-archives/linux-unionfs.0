Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553ABC41513
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Aug 2023 15:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237816AbjHOPMg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Aug 2023 11:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237813AbjHOPM0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2023 11:12:26 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E641737
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 08:12:24 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id 006d021491bc7-56ca1eebcd7so3948431eaf.0
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2023 08:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692112343; x=1692717143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=znzGBWXrDHAGV1f1Jvu5H+6hID8ZB7aYRwz1/0QudDo=;
        b=AWlLxdSxTehlnV1uxyR1L8Xa2kVe+SslPh4zwngcqW8rLd2a81ByNtaFZJVgb1ZfUf
         DY5N4iIJrOjAi6ZXosFNdmprFHl7+n9rwERZyLvbex1pfzztIdD8mImRa4NC3eEScmwV
         OrjE5jExP5l8fnkHPWaJu8rqJJ+9fr9kUejwKh843mNDyGa1hwq6gpvglN8zeGuhY4ty
         HQxZ2pNl4FQrOzk4Rp4gnR4cl0zJu21OnsKdX/F7TiPiJ4eozmJfDCE3TaSx8NBdGX65
         CE+thCfnAU5zXL7QanNwl/Kz+2TVMANi2cM625Omh//NuId2tjbLGWtJS7TN4iG5oclA
         TIRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692112343; x=1692717143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=znzGBWXrDHAGV1f1Jvu5H+6hID8ZB7aYRwz1/0QudDo=;
        b=ZvtV5RRxDiRcLyP+oEhJOUwrXXl37wpEUqLuFV1iNpd3Zd/wj/RoBWp/5jgxYBuAIo
         lqhGkgbpP46Po2F6oVjvOHLCzLV98StB9RYDyfwc6H9DmaZaEgr+q6CezZ3MdHBBNEdt
         9Uf8bLSIkB20HlczrCJnF2YG7VnorP9L+iYnTQIuUtujA+GDk1em4mPZ1D5ONTioxy2c
         04dQ/MVmdZc4ckM04mR3u2vnNBefqu/S6yQFkhiKztaST+oOaZYQsqAiH8evAQIiivMr
         jBy7gU5iBh0wH686Gndus5Rszt52iZ4f81nPFPK1BaKSp70DR1G9Ygi/aad18/KLaMPJ
         O/vA==
X-Gm-Message-State: AOJu0YwrOXe1H560uuuU0c1GtZZqEJHqKi0U47wvX8GIaSR5L+USFCNk
        HNNnntBvFdyXs0bM70l/F7gRh6ldRUhWJp5dHQ/+LdYT
X-Google-Smtp-Source: AGHT+IHx8xcAT7ipPu9OfRSPFgZsm8Jy7AKFPhntLPzQ5PpAzKm230IZCgHYedCiezCU5YhM99ji+HMOuBLNPH4JTmQ=
X-Received: by 2002:a05:6358:7e43:b0:134:e422:c500 with SMTP id
 p3-20020a0563587e4300b00134e422c500mr8642708rwm.27.1692112343322; Tue, 15 Aug
 2023 08:12:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230814140518.763674-1-amir73il@gmail.com> <20230814140518.763674-2-amir73il@gmail.com>
 <CAJfpeguUdzXdWwwFS668RcKHfKx4NJ4d9Sw6B9egiZAfCAhzLA@mail.gmail.com>
In-Reply-To: <CAJfpeguUdzXdWwwFS668RcKHfKx4NJ4d9Sw6B9egiZAfCAhzLA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 15 Aug 2023 18:12:11 +0300
Message-ID: <CAOQ4uxg9HCw6Qr-8tNiEzzZ-g3SapZpz9CYE3VuGoLY=ZMuJeA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ovl: reorder ovl_want_write() after ovl_inode_lock()
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 15, 2023 at 1:50=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Mon, 14 Aug 2023 at 16:05, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Make the locking order of ovl_inode_lock() strictly between the two
> > vfs stacked layers, i.e.:
> > - ovl vfs locks: sb_writers, inode_lock, ...
> > - ovl_inode_lock
> > - upper vfs locks: sb_writers, inode_lock, ...
> >
> > To that effect, move ovl_want_write() into the helpers ovl_nlink_start(=
)
> > and ovl_copy_up_one() which currently take the ovl_inode_lock() after
> > ovl_want_write().
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/copy_up.c | 36 ++++++++++-----------
> >  fs/overlayfs/dir.c     | 71 ++++++++++++++++++------------------------
> >  fs/overlayfs/export.c  |  7 +----
> >  fs/overlayfs/inode.c   | 56 ++++++++++++++++-----------------
> >  fs/overlayfs/util.c    |  7 +++++
> >  5 files changed, 83 insertions(+), 94 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index bae404a1bad4..c998dab440f8 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -1085,15 +1085,22 @@ static int ovl_copy_up_one(struct dentry *paren=
t, struct dentry *dentry,
> >         if (unlikely(err)) {
> >                 if (err > 0)
> >                         err =3D 0;
> > -       } else {
> > -               if (!ovl_dentry_upper(dentry))
> > -                       err =3D ovl_do_copy_up(&ctx);
> > -               if (!err && parent && !ovl_dentry_has_upper_alias(dentr=
y))
> > -                       err =3D ovl_link_up(&ctx);
> > -               if (!err && ovl_dentry_needs_data_copy_up_locked(dentry=
, flags))
> > -                       err =3D ovl_copy_up_meta_inode_data(&ctx);
> > -               ovl_copy_up_end(dentry);
> > +               goto out;
> >         }
> > +
> > +       err =3D ovl_want_write(dentry);
> > +       if (err)
> > +               goto out;
>
> Needs ovl_copy_up_end.

Right. though those lines are removed in the next patch..

>
> > +
> > +       if (!ovl_dentry_upper(dentry))
> > +               err =3D ovl_do_copy_up(&ctx);
> > +       if (!err && parent && !ovl_dentry_has_upper_alias(dentry))
> > +               err =3D ovl_link_up(&ctx);
> > +       if (!err && ovl_dentry_needs_data_copy_up_locked(dentry, flags)=
)
> > +               err =3D ovl_copy_up_meta_inode_data(&ctx);
> > +       ovl_drop_write(dentry);
> > +       ovl_copy_up_end(dentry);
> > +out:
> >         do_delayed_call(&done);
> >
> >         return err;
> > @@ -1169,17 +1176,10 @@ static bool ovl_open_need_copy_up(struct dentry=
 *dentry, int flags)
> >
> >  int ovl_maybe_copy_up(struct dentry *dentry, int flags)
> >  {
> > -       int err =3D 0;
> > -
> > -       if (ovl_open_need_copy_up(dentry, flags)) {
> > -               err =3D ovl_want_write(dentry);
> > -               if (!err) {
> > -                       err =3D ovl_copy_up_flags(dentry, flags);
> > -                       ovl_drop_write(dentry);
> > -               }
> > -       }
> > +       if (!ovl_open_need_copy_up(dentry, flags))
> > +               return 0;
> >
> > -       return err;
> > +       return ovl_copy_up_flags(dentry, flags);
> >  }
> >
> >  int ovl_copy_up_with_data(struct dentry *dentry)
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index 033fc0458a3d..f01031fe7b97 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -559,10 +559,6 @@ static int ovl_create_or_link(struct dentry *dentr=
y, struct inode *inode,
> >         struct cred *override_cred;
> >         struct dentry *parent =3D dentry->d_parent;
> >
> > -       err =3D ovl_copy_up(parent);
> > -       if (err)
> > -               return err;
> > -
> >         old_cred =3D ovl_override_creds(dentry->d_sb);
> >
> >         /*
> > @@ -626,15 +622,11 @@ static int ovl_create_object(struct dentry *dentr=
y, int mode, dev_t rdev,
> >                 .link =3D link,
> >         };
> >
> > -       err =3D ovl_want_write(dentry);
> > -       if (err)
> > -               goto out;
> > -
> >         /* Preallocate inode to be used by ovl_get_inode() */
> >         err =3D -ENOMEM;
> >         inode =3D ovl_new_inode(dentry->d_sb, mode, rdev);
> >         if (!inode)
> > -               goto out_drop_write;
> > +               goto out;
> >
> >         spin_lock(&inode->i_lock);
> >         inode->i_state |=3D I_CREATING;
> > @@ -643,12 +635,19 @@ static int ovl_create_object(struct dentry *dentr=
y, int mode, dev_t rdev,
> >         inode_init_owner(&nop_mnt_idmap, inode, dentry->d_parent->d_ino=
de, mode);
> >         attr.mode =3D inode->i_mode;
> >
> > +       err =3D ovl_copy_up(dentry->d_parent);
> > +       if (err)
> > +               return err;
>
> Needs iput().
>
> > +
> > +       err =3D ovl_want_write(dentry);
> > +       if (err)
> > +               goto out;
>
> This as well.
>
> Also I don't understand the reason behind moving ovl_want_write().
> I'd just put the copy_up(dentry->parent) above ovl_mnt_write().
>

You're right. not sure why I did that.

> > +
> >         err =3D ovl_create_or_link(dentry, inode, &attr, false);
> >         /* Did we end up using the preallocated inode? */
> >         if (inode !=3D d_inode(dentry))
> >                 iput(inode);
> >
> > -out_drop_write:
> >         ovl_drop_write(dentry);
> >  out:
> >         return err;
> > @@ -700,28 +699,24 @@ static int ovl_link(struct dentry *old, struct in=
ode *newdir,
> >         int err;
> >         struct inode *inode;
> >
> > -       err =3D ovl_want_write(old);
> > +       err =3D ovl_copy_up(old);
> >         if (err)
> >                 goto out;
> >
> > -       err =3D ovl_copy_up(old);
> > +       err =3D ovl_copy_up(new->d_parent);
> >         if (err)
> > -               goto out_drop_write;
> > +               goto out;
> >
> > -       err =3D ovl_copy_up(new->d_parent);
> > +       err =3D ovl_nlink_start(old);
> >         if (err)
> > -               goto out_drop_write;
> > +               goto out;
> >
> >         if (ovl_is_metacopy_dentry(old)) {
> >                 err =3D ovl_set_link_redirect(old);
> >                 if (err)
> > -                       goto out_drop_write;
> > +                       goto out_nlink_end;
> >         }
> >
> > -       err =3D ovl_nlink_start(old);
> > -       if (err)
> > -               goto out_drop_write;
> > -
> >         inode =3D d_inode(old);
> >         ihold(inode);
> >
> > @@ -731,9 +726,8 @@ static int ovl_link(struct dentry *old, struct inod=
e *newdir,
> >         if (err)
> >                 iput(inode);
> >
> > +out_nlink_end:
> >         ovl_nlink_end(old);
> > -out_drop_write:
> > -       ovl_drop_write(old);
> >  out:
> >         return err;
> >  }
> > @@ -891,17 +885,13 @@ static int ovl_do_remove(struct dentry *dentry, b=
ool is_dir)
> >                         goto out;
> >         }
> >
> > -       err =3D ovl_want_write(dentry);
> > -       if (err)
> > -               goto out;
> > -
> >         err =3D ovl_copy_up(dentry->d_parent);
> >         if (err)
> > -               goto out_drop_write;
> > +               goto out;
> >
> >         err =3D ovl_nlink_start(dentry);
> >         if (err)
> > -               goto out_drop_write;
> > +               goto out;
> >
> >         old_cred =3D ovl_override_creds(dentry->d_sb);
> >         if (!lower_positive)
> > @@ -926,8 +916,6 @@ static int ovl_do_remove(struct dentry *dentry, boo=
l is_dir)
> >         if (ovl_dentry_upper(dentry))
> >                 ovl_copyattr(d_inode(dentry));
> >
> > -out_drop_write:
> > -       ovl_drop_write(dentry);
> >  out:
> >         ovl_cache_free(&list);
> >         return err;
> > @@ -1131,29 +1119,32 @@ static int ovl_rename(struct mnt_idmap *idmap, =
struct inode *olddir,
> >                 }
> >         }
> >
> > -       err =3D ovl_want_write(old);
> > -       if (err)
> > -               goto out;
> > -
> >         err =3D ovl_copy_up(old);
> >         if (err)
> > -               goto out_drop_write;
> > +               goto out;
> >
> >         err =3D ovl_copy_up(new->d_parent);
> >         if (err)
> > -               goto out_drop_write;
> > +               goto out;
> >         if (!overwrite) {
> >                 err =3D ovl_copy_up(new);
> >                 if (err)
> > -                       goto out_drop_write;
> > +                       goto out;
> >         } else if (d_inode(new)) {
> >                 err =3D ovl_nlink_start(new);
> >                 if (err)
> > -                       goto out_drop_write;
> > +                       goto out;
> >
> >                 update_nlink =3D true;
> >         }
> >
> > +       if (!update_nlink) {
> > +               /* ovl_nlink_start() took ovl_want_write() */
> > +               err =3D ovl_want_write(old);
> > +               if (err)
> > +                       goto out;
> > +       }
> > +
> >         old_cred =3D ovl_override_creds(old->d_sb);
> >
> >         if (!list_empty(&list)) {
> > @@ -1286,8 +1277,8 @@ static int ovl_rename(struct mnt_idmap *idmap, st=
ruct inode *olddir,
> >         revert_creds(old_cred);
> >         if (update_nlink)
> >                 ovl_nlink_end(new);
> > -out_drop_write:
> > -       ovl_drop_write(old);
> > +       else
> > +               ovl_drop_write(old);
> >  out:
> >         dput(opaquedir);
> >         ovl_cache_free(&list);
> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > index c8c8588bd98c..4a79c479c971 100644
> > --- a/fs/overlayfs/export.c
> > +++ b/fs/overlayfs/export.c
> > @@ -23,12 +23,7 @@ static int ovl_encode_maybe_copy_up(struct dentry *d=
entry)
> >         if (ovl_dentry_upper(dentry))
> >                 return 0;
> >
> > -       err =3D ovl_want_write(dentry);
> > -       if (!err) {
> > -               err =3D ovl_copy_up(dentry);
> > -               ovl_drop_write(dentry);
> > -       }
> > -
> > +       err =3D ovl_copy_up(dentry);
> >         if (err) {
> >                 pr_warn_ratelimited("failed to copy up on encode (%pd2,=
 err=3D%i)\n",
> >                                     dentry, err);
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index b395cd84bfce..f5638cfe8f6d 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -32,10 +32,6 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dent=
ry *dentry,
> >         if (err)
> >                 return err;
> >
> > -       err =3D ovl_want_write(dentry);
> > -       if (err)
> > -               goto out;
> > -
> >         if (attr->ia_valid & ATTR_SIZE) {
> >                 /* Truncate should trigger data copy up as well */
> >                 full_copy_up =3D true;
> > @@ -54,7 +50,7 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dentr=
y *dentry,
> >                         winode =3D d_inode(upperdentry);
> >                         err =3D get_write_access(winode);
> >                         if (err)
> > -                               goto out_drop_write;
> > +                               goto out;
> >                 }
> >
> >                 if (attr->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
> > @@ -78,6 +74,10 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dent=
ry *dentry,
> >                  */
> >                 attr->ia_valid &=3D ~ATTR_OPEN;
> >
> > +               err =3D ovl_want_write(dentry);
> > +               if (err)
> > +                       goto out;
>
> Need to put write access.
>

ok.

> > +
> >                 inode_lock(upperdentry->d_inode);
> >                 old_cred =3D ovl_override_creds(dentry->d_sb);
> >                 err =3D ovl_do_notify_change(ofs, upperdentry, attr);
> > @@ -85,12 +85,11 @@ int ovl_setattr(struct mnt_idmap *idmap, struct den=
try *dentry,
> >                 if (!err)
> >                         ovl_copyattr(dentry->d_inode);
> >                 inode_unlock(upperdentry->d_inode);
> > +               ovl_drop_write(dentry);
> >
> >                 if (winode)
> >                         put_write_access(winode);
> >         }
> > -out_drop_write:
> > -       ovl_drop_write(dentry);
> >  out:
> >         return err;
> >  }
> > @@ -361,27 +360,27 @@ int ovl_xattr_set(struct dentry *dentry, struct i=
node *inode, const char *name,
> >         struct path realpath;
> >         const struct cred *old_cred;
> >
> > -       err =3D ovl_want_write(dentry);
> > -       if (err)
> > -               goto out;
> > -
> >         if (!value && !upperdentry) {
> >                 ovl_path_lower(dentry, &realpath);
> >                 old_cred =3D ovl_override_creds(dentry->d_sb);
> >                 err =3D vfs_getxattr(mnt_idmap(realpath.mnt), realdentr=
y, name, NULL, 0);
> >                 revert_creds(old_cred);
> >                 if (err < 0)
> > -                       goto out_drop_write;
> > +                       goto out;
> >         }
> >
> >         if (!upperdentry) {
> >                 err =3D ovl_copy_up(dentry);
> >                 if (err)
> > -                       goto out_drop_write;
> > +                       goto out;
> >
> >                 realdentry =3D ovl_dentry_upper(dentry);
> >         }
> >
> > +       err =3D ovl_want_write(dentry);
> > +       if (err)
> > +               goto out;
> > +
> >         old_cred =3D ovl_override_creds(dentry->d_sb);
> >         if (value) {
> >                 err =3D ovl_do_setxattr(ofs, realdentry, name, value, s=
ize,
> > @@ -391,12 +390,10 @@ int ovl_xattr_set(struct dentry *dentry, struct i=
node *inode, const char *name,
> >                 err =3D ovl_do_removexattr(ofs, realdentry, name);
> >         }
> >         revert_creds(old_cred);
> > +       ovl_drop_write(dentry);
> >
> >         /* copy c/mtime */
> >         ovl_copyattr(inode);
> > -
> > -out_drop_write:
> > -       ovl_drop_write(dentry);
> >  out:
> >         return err;
> >  }
> > @@ -611,10 +608,6 @@ static int ovl_set_or_remove_acl(struct dentry *de=
ntry, struct inode *inode,
> >         struct dentry *upperdentry =3D ovl_dentry_upper(dentry);
> >         struct dentry *realdentry =3D upperdentry ?: ovl_dentry_lower(d=
entry);
> >
> > -       err =3D ovl_want_write(dentry);
> > -       if (err)
> > -               return err;
> > -
> >         /*
> >          * If ACL is to be removed from a lower file, check if it exist=
s in
> >          * the first place before copying it up.
> > @@ -630,7 +623,7 @@ static int ovl_set_or_remove_acl(struct dentry *den=
try, struct inode *inode,
> >                 revert_creds(old_cred);
> >                 if (IS_ERR(real_acl)) {
> >                         err =3D PTR_ERR(real_acl);
> > -                       goto out_drop_write;
> > +                       goto out;
> >                 }
> >                 posix_acl_release(real_acl);
> >         }
> > @@ -638,23 +631,26 @@ static int ovl_set_or_remove_acl(struct dentry *d=
entry, struct inode *inode,
> >         if (!upperdentry) {
> >                 err =3D ovl_copy_up(dentry);
> >                 if (err)
> > -                       goto out_drop_write;
> > +                       goto out;
> >
> >                 realdentry =3D ovl_dentry_upper(dentry);
> >         }
> >
> > +       err =3D ovl_want_write(dentry);
> > +       if (err)
> > +               goto out;
> > +
> >         old_cred =3D ovl_override_creds(dentry->d_sb);
> >         if (acl)
> >                 err =3D ovl_do_set_acl(ofs, realdentry, acl_name, acl);
> >         else
> >                 err =3D ovl_do_remove_acl(ofs, realdentry, acl_name);
> >         revert_creds(old_cred);
> > +       ovl_drop_write(dentry);
> >
> >         /* copy c/mtime */
> >         ovl_copyattr(inode);
> > -
> > -out_drop_write:
> > -       ovl_drop_write(dentry);
> > +out:
> >         return err;
> >  }
> >
> > @@ -777,14 +773,14 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
> >         unsigned int flags;
> >         int err;
> >
> > -       err =3D ovl_want_write(dentry);
> > -       if (err)
> > -               goto out;
> > -
> >         err =3D ovl_copy_up(dentry);
> >         if (!err) {
> >                 ovl_path_real(dentry, &upperpath);
> >
> > +               err =3D ovl_want_write(dentry);
> > +               if (err)
> > +                       goto out;
> > +
> >                 old_cred =3D ovl_override_creds(inode->i_sb);
> >                 /*
> >                  * Store immutable/append-only flags in xattr and clear=
 them
> > @@ -797,6 +793,7 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
> >                 if (!err)
> >                         err =3D ovl_real_fileattr_set(&upperpath, fa);
> >                 revert_creds(old_cred);
> > +               ovl_drop_write(dentry);
> >
> >                 /*
> >                  * Merge real inode flags with inode flags read from
> > @@ -811,7 +808,6 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
> >                 /* Update ctime */
> >                 ovl_copyattr(inode);
> >         }
> > -       ovl_drop_write(dentry);
> >  out:
> >         return err;
> >  }
> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > index 0f387092450e..4deed8a2a112 100644
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -1062,6 +1062,10 @@ int ovl_nlink_start(struct dentry *dentry)
> >         if (err)
> >                 return err;
> >
> > +       err =3D ovl_want_write(dentry);
> > +       if (err)
> > +               goto out;
>
> Need to unlock.

goto out does unlock, but I will make this more explicit
with out_unlock label.

>
>
> > +
> >         if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, inode))
> >                 goto out;
>
> Need to drop write.

This one is not an error case, it is a success and it returns with
both inode lock and sb write held, so it can just be return 0;

>
> >
> > @@ -1074,6 +1078,8 @@ int ovl_nlink_start(struct dentry *dentry)
> >          */
> >         err =3D ovl_set_nlink_upper(dentry);
> >         revert_creds(old_cred);
> > +       if (err)
> > +               ovl_drop_write(dentry);
> >
> >  out:
> >         if (err)
>
> I'd just separate out error handling into separate labels.
>

OK.

I hope the two other patches have less mistakes :-/

Thanks,
Amir.
