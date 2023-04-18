Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716CDC6FD18
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 13:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjDRNeM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 09:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjDRNeL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2023 09:34:11 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152B6119
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 06:34:10 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id l17so7521655uak.0
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 06:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681824849; x=1684416849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qMnORTrtLovyRrF4ko6mL37dx5rFXBbFyJLUt1NmH5g=;
        b=gYYcmNZwwFHkxjbqYoyDcWw148+gxtej24Nqwr+cOKmBPysbECh0Ww20YiDDnerIJ6
         ADfb9YlBCI/fmcqGAhcN5SGDgKxm0DVvTrLrOGCWknG93cbNIrufJjRxkqaPYO31+GJR
         J8u69hPvQNSMhJPNEwWeb+zZk/eXb4/KMlxogUcnfGWos4S3i9k9IyJoIwFowRqyno8P
         gHnqxzuqUdg9FMYgdaT+qmCFK9iCXPVh/XERkEB0sM3lxwd3EW9e8CZe5Inkv82f1H5g
         38BpnncBOko0+uX8QcaU8oXyGlv1ceg+p0gSKZSjZLv03qtgFiUVfqsTRMT9+BEQIQhy
         Y+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681824849; x=1684416849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qMnORTrtLovyRrF4ko6mL37dx5rFXBbFyJLUt1NmH5g=;
        b=bL3pMuSUbW60TKjYjWAQMG0tCAP06gFLGqLsNnUicRKKenQq2Qcn+yt4ESCbrQ7atB
         5r6d0k6GHdjgClnAhXc7RjxEYCX9R0eMrXisDVifBiUVPX+SMT8QgDF4fRfnh22GkKzC
         0N+3X3blCzCSDeA2ikgd3dXrnhjMZwFiMHTbNbxtZecWU3yQ4ESa/+pC0Lsw1A+GUk3B
         dACHs+UMLAz25qwwY/HhtCPN5PZ2UqD8h7+hI+bKTfDBsnfifkKUI7wMl2grqoEBJcG8
         8mUew89OXBeeLQlf7Eyh1c6zF8fbZG8yZHiNhSa0EdzpWEmoYf1fyMBaOIqvKdAxyo94
         KDMw==
X-Gm-Message-State: AAQBX9curgVzSwhQUs+BEieniMFL2046wbseeCczVdEgiES1EOSYZFNH
        Z+xC50h7c+uZiTdvoaYKPurEV+UN3A4vd/X03ds=
X-Google-Smtp-Source: AKy350bGvoY8hTwD4KS2cHLYDKdtDCeA8miacmNZvBtZuXTk+sOyyy9BMM5RFmEAWWaqTkZvAee64hE2zhHbD/dSDYg=
X-Received: by 2002:a1f:a710:0:b0:40c:4d1:b550 with SMTP id
 q16-20020a1fa710000000b0040c04d1b550mr9701078vke.0.1681824848952; Tue, 18 Apr
 2023 06:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230412135412.1684197-1-amir73il@gmail.com> <20230412135412.1684197-3-amir73il@gmail.com>
 <8ac422621de7b422cf4b744463f3c1e4bae148d9.camel@redhat.com>
In-Reply-To: <8ac422621de7b422cf4b744463f3c1e4bae148d9.camel@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Apr 2023 16:33:57 +0300
Message-ID: <CAOQ4uxgU4LZy5=ouqFDWAPn=t17mavfhs_1915-HW3AGywjYkw@mail.gmail.com>
Subject: Re: [PATCH 2/5] ovl: introduce data-only lower layers
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2023 at 3:02=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Wed, 2023-04-12 at 16:54 +0300, Amir Goldstein wrote:
> > Introduce the format lowerdir=3Dlower1:lower2::lowerdata1:lowerdata2
> > where the lower layers after the :: separator are not merged into the
> > overlayfs merge dirs.
> >
> > The files in those layers are only meant to be accessible via
> > absolute
> > redirect from metacopy files in lower layers.  Following changes will
> > implement lookup in the data layers.
> >
> > This feature was requested for composefs ostree use case, where the
> > lower data layer should only be accessiable via absolute redirects
> > from metacopy inodes.
> >
> > The lower data layers are not required to a have a unique uuid or any
> > uuid at all, because they are never used to compose the overlayfs
> > inode
> > st_ino/st_dev.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Reviewed-by: Alexander Larsson <alexl@redhat.com>
>
> > ---
> >  Documentation/filesystems/overlayfs.rst | 32 +++++++++++++++++
> >  fs/overlayfs/namei.c                    |  4 +--
> >  fs/overlayfs/ovl_entry.h                |  9 +++++
> >  fs/overlayfs/super.c                    | 46 +++++++++++++++++++++--
> > --
> >  4 files changed, 82 insertions(+), 9 deletions(-)
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst
> > b/Documentation/filesystems/overlayfs.rst
> > index 4c76fda07645..c8e04a4f0e21 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -371,6 +371,38 @@ conflict with metacopy=3Don, and will result in an
> > error.
> >  [*] redirect_dir=3Dfollow only conflicts with metacopy=3Don if
> > upperdir=3D... is
> >  given.
> >
> > +
> > +Data-only lower layers
> > +----------------------
> > +
> > +With "metacopy" feature enabled, an overlayfs regular file may be a
> > composition
> > +of information from up to three different layers:
> > +
> > + 1) metadata from a file in the upper layer
> > +
> > + 2) st_ino and st_dev object identifier from a file in a lower layer
> > +
> > + 3) data from a file in another lower layer (further below)
> > +
> > +The "lower data" file can be on any lower layer, except from the top
> > most
> > +lower layer.
> > +
> > +Below the top most lower layer, any number of lower most layers may
> > be defined
> > +as "data-only" lower layers, using the double collon ("::")
> > separator.
>
> "colon", not "collon"
>
> > +
> > +For example:
> > +
> > +  mount -t overlay overlay -olowerdir=3D/lower1::/lower2:/lower3
> > /merged
> > +
> > +The paths of files in the "data-only" lower layers are not visible
> > in the
> > +merged overlayfs directories and the metadata and st_ino/st_dev of
> > files
> > +in the "data-only" lower layers are not visible in overlayfs inodes.
> > +
> > +Only the data of the files in the "data-only" lower layers may be
> > visible
> > +when a "metacopy" file in one of the lower layers above it, has a
> > "redirect"
> > +to the absolute path of the "lower data" file in the "data-only"
> > lower layer.
> > +
> > +
> >  Sharing and copying layers
> >  --------------------------
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index b629261324f1..ff82155b4f7e 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -356,7 +356,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs,
> > struct ovl_fh *fh, bool connected,
> >         struct dentry *origin =3D NULL;
> >         int i;
> >
> > -       for (i =3D 1; i < ofs->numlayer; i++) {
> > +       for (i =3D 1; i <=3D ovl_numlowerlayer(ofs); i++) {
> >                 /*
> >                  * If lower fs uuid is not unique among lower fs we
> > cannot match
> >                  * fh->uuid to layer.
> > @@ -907,7 +907,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> > struct dentry *dentry,
> >
> >         if (!d.stop && ovl_numlower(poe)) {
> >                 err =3D -ENOMEM;
> > -               stack =3D ovl_stack_alloc(ofs->numlayer - 1);
> > +               stack =3D ovl_stack_alloc(ovl_numlowerlayer(ofs));
> >                 if (!stack)
> >                         goto out_put_upper;
> >         }
>
> Again, surely ovl_numlower(poe) is a better size here?

Intentional. that is changed in the following patch.
(to ovl_numlowerlayer(ofs) + 1)
As the commit message says:
"Following changes will implement lookup in the data layers."

>
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index 221f0cbe748e..25fabb3175cf 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -62,6 +62,8 @@ struct ovl_fs {
> >         unsigned int numlayer;
> >         /* Number of unique fs among layers including upper fs */
> >         unsigned int numfs;
> > +       /* Number of data-only lower layers */
> > +       unsigned int numdatalayer;
> >         const struct ovl_layer *layers;
> >         struct ovl_sb *fs;
> >         /* workbasedir is the path at workdir=3D mount option */
> > @@ -95,6 +97,13 @@ struct ovl_fs {
> >         errseq_t errseq;
> >  };
> >
> > +
> > +/* Number of lower layers, not including data-only layers */
> > +static inline unsigned int ovl_numlowerlayer(struct ovl_fs *ofs)
> > +{
> > +       return ofs->numlayer - ofs->numdatalayer - 1;
> > +}
> > +
> >  static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
> >  {
> >         return ofs->layers[0].mnt;
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 7742aef3f3b3..3484f39a8f27 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1579,6 +1579,16 @@ static int ovl_get_fsid(struct ovl_fs *ofs,
> > const struct path *path)
> >         return ofs->numfs++;
> >  }
> >
> > +/*
> > + * The fsid after the last lower fsid is used for the data layers.
> > + * It is a "null fs" with a null sb, null uuid, and no pseudo dev.
> > + */
> > +static int ovl_get_data_fsid(struct ovl_fs *ofs)
> > +{
> > +       return ofs->numfs;
> > +}
> > +
> > +
> >  static int ovl_get_layers(struct super_block *sb, struct ovl_fs
> > *ofs,
> >                           struct path *stack, unsigned int numlower,
> >                           struct ovl_layer *layers)
> > @@ -1586,11 +1596,14 @@ static int ovl_get_layers(struct super_block
> > *sb, struct ovl_fs *ofs,
> >         int err;
> >         unsigned int i;
> >
> > -       ofs->fs =3D kcalloc(numlower + 1, sizeof(struct ovl_sb),
> > GFP_KERNEL);
> > +       ofs->fs =3D kcalloc(numlower + 2, sizeof(struct ovl_sb),
> > GFP_KERNEL);
> >         if (ofs->fs =3D=3D NULL)
> >                 return -ENOMEM;
> >
> > -       /* idx/fsid 0 are reserved for upper fs even with lower only
> > overlay */
> > +       /*
> > +        * idx/fsid 0 are reserved for upper fs even with lower only
> > overlay
> > +        * and the last fsid is reserved for "null fs" of the data
> > layers.
> > +        */
> >         ofs->numfs++;
> >
> >         /*
> > @@ -1615,7 +1628,10 @@ static int ovl_get_layers(struct super_block
> > *sb, struct ovl_fs *ofs,
> >                 struct inode *trap;
> >                 int fsid;
> >
> > -               fsid =3D ovl_get_fsid(ofs, &stack[i]);
> > +               if (i < numlower - ofs->numdatalayer)
> > +                       fsid =3D ovl_get_fsid(ofs, &stack[i]);
> > +               else
> > +                       fsid =3D ovl_get_data_fsid(ofs);
> >                 if (fsid < 0)
> >                         return fsid;
> >
> > @@ -1703,6 +1719,7 @@ static int ovl_get_lowerstack(struct
> > super_block *sb, struct ovl_entry *oe,
> >         int err;
> >         struct path *stack =3D NULL;
> >         struct ovl_path *lowerstack;
> > +       unsigned int numlowerdata =3D 0;
> >         unsigned int i;
> >
> >         if (!ofs->config.upperdir && numlower =3D=3D 1) {
> > @@ -1714,13 +1731,27 @@ static int ovl_get_lowerstack(struct
> > super_block *sb, struct ovl_entry *oe,
> >         if (!stack)
> >                 return -ENOMEM;
> >
> > -       err =3D -EINVAL;
> > -       for (i =3D 0; i < numlower; i++) {
> > +       for (i =3D 0; i < numlower;) {
> >                 err =3D ovl_lower_dir(lower, &stack[i], ofs, &sb-
> > >s_stack_depth);
> >                 if (err)
> >                         goto out_err;
> >
> >                 lower =3D strchr(lower, '\0') + 1;
> > +
> > +               i++;
> > +               err =3D -EINVAL;
> > +               /* :: seperator indicates the start of lower data
> > layers */
> > +               if (!*lower && i < numlower && !numlowerdata) {
> > +                       if (!ofs->config.metacopy) {
> > +                               pr_err("lower data-only dirs require
> > metacopy support.\n");
> > +                               goto out_err;
> > +                       }
> > +                       lower++;
> > +                       numlower--;
> > +                       ofs->numdatalayer =3D numlowerdata =3D numlower=
 -
> > i;
> > +                       pr_info("using the lowest %d of %d lowerdirs
> > as data layers\n",
> > +                               numlowerdata, numlower);
> > +               }
> >         }
>
> This will handle a "::" at the end of the string as an error. Maybe it
> would be better to treat it as "zero lower data layera", to make code
> that generates mount options more regular? Not a huge issue though.
>

No reason to do that.
Code that prepares lowerdata layers should know what it is doing.

Thanks,
Amir.
