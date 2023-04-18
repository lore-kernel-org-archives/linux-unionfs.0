Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB49C6FD18
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 14:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjDROIG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 10:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDROIG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2023 10:08:06 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D2283FE
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 07:08:04 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id r10so11212804uat.6
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 07:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681826884; x=1684418884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+MOC5/sLNaYEbKnkVvIVPAFc+ZlZwT6F6cr7grTmF0=;
        b=QRn2CROOg2EYfv6bXOv4Vb5V7aa8cxqEXn7n6cgIFWR0mAQwZBqInWsYERyLnZ0rzh
         nAQXHk5d4r/1y9fLQ73OKuXA8kb7amaYougS4i2RVeu/AxXTLg2Lh+9ZV7vFvS28K0W3
         n88gTat6f+UA9kFV5lFuXJJxZYCpTCjziCNJEi4oqxq5ujImJ6mk+IYEqjZ31eWx9e23
         Q+BOp9TCkGrMGFIfmbXSj8r9bd16vEZWADGTPFDGM2DIn3NhUdeBkp5mAJTJ1lpkUfBf
         76NjUodKTKYnKkD6dPWGKIjvAbihoOfY2tPd4Z4xa3V1gJwP9BZQomhplvDApkMSwt43
         cQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826884; x=1684418884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a+MOC5/sLNaYEbKnkVvIVPAFc+ZlZwT6F6cr7grTmF0=;
        b=OkI+LGbGXUDzZRaaDq5ppHAn9JMRoeWd4reOEhQ/Ujw5ZfRNvxZ0724q9sBD4CQKNG
         qXuB3UioXR44GSBfli+iUEPpgLzXadmQNZiV3KFFcoahAHS7cMENTZCfRgWLITRe7bKM
         aSbrgYH8eIIURL5LIAHtA2RKQkFX8DS/6XA7VkHq1MbMcTntGzaQ3SouNkXs/j9fadET
         PykJ+mPkQvq+2SNVWYQ9GZBHtZcK4c8y2M1w+TJFJE34ARBtU2wBTabpeesnA0dMy0i4
         iT27QjGd8Kcc0SUE/3VADkXiaMJsIZwVfTPWUQMXJvW1zfYZf3xnHGTdILh5UnEkAIf8
         faWw==
X-Gm-Message-State: AAQBX9eJmWPjfZRTV3vrHfbvdqJ7Gq9nkqlhlaJO9Hj06cIJxSaJ+fUP
        T+Ok0GSAonGqNU/kdK9jHS9/z8mVsUTAqXwYNz6Vfr8gDuE=
X-Google-Smtp-Source: AKy350b2TIUuZu7wzIiIvZPOV05ZNL7Jl8RILwRnC50DVQyd1JbKFImrv3edMtL6teftJI97SlSir7PVVcyC0p7oe7E=
X-Received: by 2002:ab0:5b54:0:b0:772:4a2:62af with SMTP id
 v20-20020ab05b54000000b0077204a262afmr9922217uae.1.1681826883620; Tue, 18 Apr
 2023 07:08:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230412135412.1684197-1-amir73il@gmail.com> <20230412135412.1684197-4-amir73il@gmail.com>
 <f3d4d0dacf08cb227661c2145840781915c3c7c2.camel@redhat.com>
 <CAOQ4uxgbO_7qcJiGKTJzV9dw5_cQrpVAAJ0DHQRQ+bi5NeUysQ@mail.gmail.com> <CAL7ro1EhRJbiDq5rYbPmeUTa-BwJYr2CV7ufCAgD2mmL+yWhZA@mail.gmail.com>
In-Reply-To: <CAL7ro1EhRJbiDq5rYbPmeUTa-BwJYr2CV7ufCAgD2mmL+yWhZA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Apr 2023 17:07:52 +0300
Message-ID: <CAOQ4uxh8naOzE4TU6CQ3aUOGRtxOsyue_7eNoeTVYtHkW-FqVA@mail.gmail.com>
Subject: Re: [PATCH 3/5] ovl: implement lookup in data-only layers
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2023 at 5:00=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Tue, Apr 18, 2023 at 3:41=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Tue, Apr 18, 2023 at 3:40=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > On Wed, 2023-04-12 at 16:54 +0300, Amir Goldstein wrote:
> > > > Lookup in data-only layers only for a lower metacopy with an absolu=
te
> > > > redirect xattr.
> > > >
> > > > The metacopy xattr is not checked on files found in the data-only
> > > > layers
> > > > and redirect xattr are not followed in the data-only layers.
> > > >
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > >
> > > Reviewed-by: Alexander Larsson <alexl@redhat.com>
> > >
> > > > ---
> > > >  fs/overlayfs/namei.c | 77
> > > > ++++++++++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 75 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > > > index ff82155b4f7e..82e103e2308b 100644
> > > > --- a/fs/overlayfs/namei.c
> > > > +++ b/fs/overlayfs/namei.c
> > > > @@ -14,6 +14,8 @@
> > > >  #include <linux/exportfs.h>
> > > >  #include "overlayfs.h"
> > > >
> > > > +#include "../internal.h"       /* for vfs_path_lookup */
> > > > +
> > > >  struct ovl_lookup_data {
> > > >         struct super_block *sb;
> > > >         struct vfsmount *mnt;
> > > > @@ -24,6 +26,8 @@ struct ovl_lookup_data {
> > > >         bool last;
> > > >         char *redirect;
> > > >         bool metacopy;
> > > > +       /* Referring to last redirect xattr */
> > > > +       bool absolute_redirect;
> > > >  };
> > > >
> > > >  static int ovl_check_redirect(const struct path *path, struct
> > > > ovl_lookup_data *d,
> > > > @@ -33,11 +37,13 @@ static int ovl_check_redirect(const struct path
> > > > *path, struct ovl_lookup_data *d
> > > >         char *buf;
> > > >         struct ovl_fs *ofs =3D OVL_FS(d->sb);
> > > >
> > > > +       d->absolute_redirect =3D false;
> > > >         buf =3D ovl_get_redirect_xattr(ofs, path, prelen +
> > > > strlen(post));
> > > >         if (IS_ERR_OR_NULL(buf))
> > > >                 return PTR_ERR(buf);
> > > >
> > > >         if (buf[0] =3D=3D '/') {
> > > > +               d->absolute_redirect =3D true;
> > > >                 /*
> > > >                  * One of the ancestor path elements in an absolute
> > > > path
> > > >                  * lookup in ovl_lookup_layer() could have been
> > > > opaque and
> > > > @@ -349,6 +355,61 @@ static int ovl_lookup_layer(struct dentry *bas=
e,
> > > > struct ovl_lookup_data *d,
> > > >         return 0;
> > > >  }
> > > >
> > > > +static int ovl_lookup_data_layer(struct dentry *dentry, const char
> > > > *redirect,
> > > > +                                const struct ovl_layer *layer,
> > > > +                                struct path *datapath)
> > > > +{
> > > > +       int err;
> > > > +
> > > > +       err =3D vfs_path_lookup(layer->mnt->mnt_root, layer->mnt,
> > > > redirect,
> > > > +                       LOOKUP_BENEATH | LOOKUP_NO_SYMLINKS |
> > > > LOOKUP_NO_XDEV,
> > > > +                       datapath);
> > > > +       pr_debug("lookup lowerdata (%pd2, redirect=3D\"%s\", layer=
=3D%d,
> > > > err=3D%i)\n",
> > > > +                dentry, redirect, layer->idx, err);
> > > > +
> > > > +       if (err)
> > > > +               return err;
> > > > +
> > > > +       err =3D -EREMOTE;
> > > > +       if (ovl_dentry_weird(datapath->dentry))
> > > > +               goto out_path_put;
> > > > +
> > > > +       err =3D -ENOENT;
> > > > +       /* Only regular file is acceptable as lower data */
> > > > +       if (!d_is_reg(datapath->dentry))
> > > > +               goto out_path_put;
> > > > +
> > > > +       return 0;
> > > > +
> > > > +out_path_put:
> > > > +       path_put(datapath);
> > > > +
> > > > +       return err;
> > > > +}
> > > > +
> > > > +/* Lookup in data-only layers by absolute redirect to layer root *=
/
> > > > +static int ovl_lookup_data_layers(struct dentry *dentry, const cha=
r
> > > > *redirect,
> > > > +                                 struct ovl_path *lowerdata)
> > > > +{
> > > > +       struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> > > > +       const struct ovl_layer *layer;
> > > > +       struct path datapath;
> > > > +       int err =3D -ENOENT;
> > > > +       int i;
> > > > +
> > > > +       layer =3D &ofs->layers[ofs->numlayer - ofs->numdatalayer];
> > > > +       for (i =3D 0; i < ofs->numdatalayer; i++, layer++) {
> > > > +               err =3D ovl_lookup_data_layer(dentry, redirect, lay=
er,
> > > > &datapath);
> > > > +               if (!err) {
> > > > +                       mntput(datapath.mnt);
> > > > +                       lowerdata->dentry =3D datapath.dentry;
> > > > +                       lowerdata->layer =3D layer;
> > > > +                       return 0;
> > > > +               }
> > > > +       }
> > > > +
> > > > +       return err;
> > > > +}
> > > >
> > > >  int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, boo=
l
> > > > connected,
> > > >                         struct dentry *upperdentry, struct ovl_path
> > > > **stackp)
> > > > @@ -907,7 +968,9 @@ struct dentry *ovl_lookup(struct inode *dir,
> > > > struct dentry *dentry,
> > > >
> > > >         if (!d.stop && ovl_numlower(poe)) {
> > > >                 err =3D -ENOMEM;
> > > > -               stack =3D ovl_stack_alloc(ovl_numlowerlayer(ofs));
> > > > +               /* May need to reserve space in lowerstack for
> > > > lowerdata */
> > > > +               stack =3D ovl_stack_alloc(ovl_numlowerlayer(ofs) +
> > > > +                                       (!d.is_dir && !!ofs-
> > > > >numdatalayer));
> > >
> > > I think this runs into issues if ovl_numlower(poe) is zero, but we
> > > have a redirect into the lowerdata, due to the if (ovl_numlower(poe))
> > > check above. We won't be allocating the lowerdata stack space in this
> > > case.
> > >
> >
> > Redirect from upper directly into data-only is not valid.
>
> Ah.
>
> > As the comment below says:
> > /* Lookup absolute redirect from lower metacopy in data-only layers */
> > data-only can only be accessed by absolute redirect from
> > lower layer.
> > Is that a problem for your use case?
>
> No, just something I noticed that looked wrong.

I haven't actually explained why that limitation exists.

Apart from the fact that your use case does not need
redirect from upper to data-only, when the stack is composed
of only upper and lower (not 2 lowers) then the lower is used
for the overlay ino/index/fh.

data-only layers cannot be used for ovelray ino/index/fh because
they are data-only and ino/fh is metadata.

That's also the reason that data-only layers do not need to go through
the ovl_lower_uuid_ok() check, which allows greater flexibility
with the filesystems being used for the backing store of the data blobs.

Thanks,
Amir.
