Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF75C77B7F
	for <linux-unionfs@archiver.kernel.org>; Tue, 16 May 2023 10:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjEPKS2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 16 May 2023 06:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjEPKS1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2023 06:18:27 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160821A5
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2023 03:18:21 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id ada2fe7eead31-43278f6d551so4557970137.1
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2023 03:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684232300; x=1686824300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Hxb+lWFaoYR5alIOCMFTaSiG9s3LgGyZYYw8/5NDrk=;
        b=KtrFFdM6gaeCNGumLRlc0uvWif/ITBruhADaM8SzAIhlPZmHdUvo+wurPS2fvYrg+T
         tUuEJcuxax6FlZt8NATCOZUpV/BCCmpmiWgFcWXmqmtoPdL/NORPKXqXIGGxR90qWV9G
         Vnh8Sfvu9DKR+YOEG1mECjEyy28hf9DzdFQ1y4Jsby892B5VLnCNSEytJNLhPRcTwV0X
         E5YLbM37QoCiaASHv5Ff9oPs33luNrmJi3x1XkdTNMkA+eu3nvbmy5ENjsIijbXuLJG9
         6W4CJ0RjA42uRvfgvqoQlvjpf1AVZEMkMZZ6C7QqmcfuxnpoBDZyqvgkZGL+Eo7dt5S7
         NUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684232300; x=1686824300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Hxb+lWFaoYR5alIOCMFTaSiG9s3LgGyZYYw8/5NDrk=;
        b=Gvvv908EgAQXrQl9dkgop1Q2Et7YvlbSTAdA7s7tmh+bbB1kLhxGZHUlEWztx0WAHg
         WQ/laS7tVZIUoepkRhrwHlOOufKF8kNEFo7BdI35y2X6OkJ43LzVrTR7wxmn5GsAnZoG
         +12SJHATTwf8QFjzp+GnxcfxS0ibzCKXo6v5EqLyDFq6l6e+0KMaE2porxA4Smd8pkeR
         3sI9ay8qe+nYlrJi6H7N+UGvO0HREyGmIsDAd3NqC4y8KVimbW40dTL+ejDSOHtco41i
         2L4zP3cUzy9I4hjWTfTza1NgqzEZYKF/sqtpTCFQCnVAQAgZ1dHgBCSbWOYIk+Akvqke
         01rg==
X-Gm-Message-State: AC+VfDyDmWbhXXfyuGESGjdQh3jWy1DuAFPUw8oI4uaNfFbUK8kPiVdE
        4GjIkw2jTxB/RvyuOZNoHBxBfzN2Xkig5DidAJI=
X-Google-Smtp-Source: ACHHUZ7VpODqdXPUhRz1v0mr66YSyV7Rebkmh+y6djcICdfe5pqPNyR1AqepvimB7t4K2J03cpK1xkzixKi5AVAqwjI=
X-Received: by 2002:a05:6102:494:b0:42c:90a9:a211 with SMTP id
 n20-20020a056102049400b0042c90a9a211mr14325745vsa.0.1684232299876; Tue, 16
 May 2023 03:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <20230427130539.2798797-10-amir73il@gmail.com>
 <CAOQ4uxhrCUuQ=wg8dXueTGN3JnxXasnVoVi=cVPva3m6zCRMYQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhrCUuQ=wg8dXueTGN3JnxXasnVoVi=cVPva3m6zCRMYQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 16 May 2023 13:18:08 +0300
Message-ID: <CAOQ4uxjHgmU5jec+QhtgYDFDa4z2T3ROMqCNDi1hxL8Y4Sbo6g@mail.gmail.com>
Subject: Re: [PATCH v2 09/13] ovl: introduce data-only lower layers
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 14, 2023 at 10:13=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Thu, Apr 27, 2023 at 4:05=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > Introduce the format lowerdir=3Dlower1:lower2::lowerdata1:lowerdata2
> > where the lower layers on the right of the :: separator are not merged
> > into the overlayfs merge dirs.
> >
> > The files in those layers are only meant to be accessible via absolute
> > redirect from metacopy files in lower layers.  Following changes will
> > implement lookup in the data layers.
> >
> > This feature was requested for composefs ostree use case, where the
> > lower data layer should only be accessiable via absolute redirects
> > from metacopy inodes.
> >
> > The lower data layers are not required to a have a unique uuid or any
> > uuid at all, because they are never used to compose the overlayfs inode
> > st_ino/st_dev.
> >
> > Reviewed-by: Alexander Larsson <alexl@redhat.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  Documentation/filesystems/overlayfs.rst | 36 +++++++++++++++++++
> >  fs/overlayfs/namei.c                    |  2 +-
> >  fs/overlayfs/ovl_entry.h                |  9 +++++
> >  fs/overlayfs/super.c                    | 46 +++++++++++++++++++++----
> >  4 files changed, 85 insertions(+), 8 deletions(-)
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/fi=
lesystems/overlayfs.rst
> > index 4c76fda07645..bc95343bafba 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -371,6 +371,42 @@ conflict with metacopy=3Don, and will result in an=
 error.
> >  [*] redirect_dir=3Dfollow only conflicts with metacopy=3Don if upperdi=
r=3D... is
> >  given.
> >
> > +
> > +Data-only lower layers
> > +----------------------
> > +
> > +With "metacopy" feature enabled, an overlayfs regular file may be a co=
mposition
> > +of information from up to three different layers:
> > +
> > + 1) metadata from a file in the upper layer
> > +
> > + 2) st_ino and st_dev object identifier from a file in a lower layer
> > +
> > + 3) data from a file in another lower layer (further below)
> > +
> > +The "lower data" file can be on any lower layer, except from the top m=
ost
> > +lower layer.
> > +
> > +Below the top most lower layer, any number of lower most layers may be=
 defined
> > +as "data-only" lower layers, using the double colon ("::") separator.
> > +The double colon ("::") separator can only occur once and it must have=
 a
> > +non-empty list of lower directory paths on the left and a non-empty
> > +list of "data-only" lower directory paths on the right.
> > +
> > +
> > +For example:
> > +
> > +  mount -t overlay overlay -olowerdir=3D/l1:/l2:/l3::/do1:/do2 /merged
> > +
> > +The paths of files in the "data-only" lower layers are not visible in =
the
> > +merged overlayfs directories and the metadata and st_ino/st_dev of fil=
es
> > +in the "data-only" lower layers are not visible in overlayfs inodes.
> > +
> > +Only the data of the files in the "data-only" lower layers may be visi=
ble
> > +when a "metacopy" file in one of the lower layers above it, has a "red=
irect"
> > +to the absolute path of the "lower data" file in the "data-only" lower=
 layer.
> > +
> > +
> >  Sharing and copying layers
> >  --------------------------
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index e2b3c8f6753a..6bb07e1c01ee 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -356,7 +356,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct =
ovl_fh *fh, bool connected,
> >         struct dentry *origin =3D NULL;
> >         int i;
> >
> > -       for (i =3D 1; i < ofs->numlayer; i++) {
> > +       for (i =3D 1; i <=3D ovl_numlowerlayer(ofs); i++) {
> >                 /*
> >                  * If lower fs uuid is not unique among lower fs we can=
not match
> >                  * fh->uuid to layer.
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index 548c93e030fc..93ff299da0dd 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -57,6 +57,8 @@ struct ovl_fs {
> >         unsigned int numlayer;
> >         /* Number of unique fs among layers including upper fs */
> >         unsigned int numfs;
> > +       /* Number of data-only lower layers */
> > +       unsigned int numdatalayer;
> >         const struct ovl_layer *layers;
> >         struct ovl_sb *fs;
> >         /* workbasedir is the path at workdir=3D mount option */
> > @@ -90,6 +92,13 @@ struct ovl_fs {
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
> > index 9b326b857ad6..988edb9e9d23 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1576,6 +1576,16 @@ static int ovl_get_fsid(struct ovl_fs *ofs, cons=
t struct path *path)
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
> >  static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
> >                           struct path *stack, unsigned int numlower,
> >                           struct ovl_layer *layers)
> > @@ -1583,11 +1593,14 @@ static int ovl_get_layers(struct super_block *s=
b, struct ovl_fs *ofs,
> >         int err;
> >         unsigned int i;
> >
> > -       ofs->fs =3D kcalloc(numlower + 1, sizeof(struct ovl_sb), GFP_KE=
RNEL);
> > +       ofs->fs =3D kcalloc(numlower + 2, sizeof(struct ovl_sb), GFP_KE=
RNEL);
> >         if (ofs->fs =3D=3D NULL)
> >                 return -ENOMEM;
> >
> > -       /* idx/fsid 0 are reserved for upper fs even with lower only ov=
erlay */
> > +       /*
> > +        * idx/fsid 0 are reserved for upper fs even with lower only ov=
erlay
> > +        * and the last fsid is reserved for "null fs" of the data laye=
rs.
> > +        */
> >         ofs->numfs++;
> >
> >         /*
> > @@ -1612,7 +1625,10 @@ static int ovl_get_layers(struct super_block *sb=
, struct ovl_fs *ofs,
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
> > @@ -1700,6 +1716,7 @@ static struct ovl_entry *ovl_get_lowerstack(struc=
t super_block *sb,
> >         int err;
> >         struct path *stack =3D NULL;
> >         struct ovl_path *lowerstack;
> > +       unsigned int numlowerdata =3D 0;
> >         unsigned int i;
> >         struct ovl_entry *oe;
> >
> > @@ -1712,13 +1729,27 @@ static struct ovl_entry *ovl_get_lowerstack(str=
uct super_block *sb,
> >         if (!stack)
> >                 return ERR_PTR(-ENOMEM);
> >
> > -       err =3D -EINVAL;
> > -       for (i =3D 0; i < numlower; i++) {
> > +       for (i =3D 0; i < numlower;) {
> >                 err =3D ovl_lower_dir(lower, &stack[i], ofs, &sb->s_sta=
ck_depth);
> >                 if (err)
> >                         goto out_err;
> >
> >                 lower =3D strchr(lower, '\0') + 1;
> > +
> > +               i++;
> > +               err =3D -EINVAL;
> > +               /* :: separator indicates the start of lower data layer=
s */
> > +               if (!*lower && i < numlower && !numlowerdata) {
>
> FYI, kernel test bot reported a KASAN out-of-bounds access on !*lower
> because it is tested also when i =3D=3D numlower and in any case, the tes=
t
> should be i < numlower - 1, so :: cannot be at the end of the list.
>
> Pushed a fix to branch ovl-lazy-lowerdata with an improved comment:
>
>                 /*
>                  * Empty lower layer path could mean :: separator that in=
dicates
>                  * the start of lower data layers.
>                  * Only one :: separator is allowed and it has to have at=
 least
>                  * one lowerdir to the left and one lowerdir to the right=
.
>                  */
>                 if (!numlowerdata && i < numlower - 1 && !*lower) {
>
>

FYI, rebased branch ovl-lazy-lowerdata onto v6.4-rc2.

Miklos, please let me know if you want me to re-post v3
with the KASAN warning fix above.

Thanks,
Amir.
