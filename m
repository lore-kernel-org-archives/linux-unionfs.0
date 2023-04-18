Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4495EC6FD18
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 13:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjDRNle (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 09:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjDRNld (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2023 09:41:33 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B00A210B
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 06:41:32 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id l16so5966138vst.2
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 06:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681825291; x=1684417291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhxpMB3fGiQq+0vQZbOk4dc3m0RYfVvz7m99Q8e8S6Q=;
        b=oizVRQUhVsL1d4aQPcATwCAqwjtpObi4kNIXwyppbeR543xk2We2CPUdDbZmKSWtNr
         67Gb2EbJaxDOkifSd2peK12nqHTrUjcnNeqc0YKOzlu7Wm9Oo1+ACC6BKtzFnAYd+HlR
         940JDpF0MA1nnX7P95ReBSVsMVKI6+sk0Na+9WmsM46QCPladuKLYdYDhRB/ztYgAmpM
         zoSyeNt2ML4J/meNGxX0NZr9J6ALeSU7Q4khLTiWcDgjQNUMcvt4rvEMhj1SpVhaYz0Z
         hDUHTj3kPzQWG+JzxPRpDkOQQPQlqnt6op0/sGfZV8gZ1oEVs3t9YhO8XzmhF/Xb/bN7
         /4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681825291; x=1684417291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhxpMB3fGiQq+0vQZbOk4dc3m0RYfVvz7m99Q8e8S6Q=;
        b=C6ovtEUtgaE/B9SblKkKpcDZURFvsQoiJpUgmmQEQ1qNuLiO622jphfhrlnXqcSMyq
         +uaeP0oTA5JKt0FuCLloHBjpSy7oOmVHnTbdTdjesRuGTYEdMKXgWW1qkyFMtVggZN4M
         zusZNN6b3HfqIdIK6d+pbNy0YGnnyupSuqEVLvyjXgMtjMmEZ+i1eg+Quep1T3uuyRSS
         +rKJEFjLkoEhBiWPVYY/f8ZM1pviiGSjLhQZUwXEBop1Y/+kqQRzEG2HNZfe46Fjg2Jf
         yByPmUVSjus2EdpsAHDXn2SPwVqpBlIJ0y9POXobDfP6SlU3xXVsYfsMFajpmV+gIFLT
         JWgA==
X-Gm-Message-State: AAQBX9dMYhuwBiZPR8OWnduXRn2XOjFnAWS1S3rsJZM56mHPRUYZy4hB
        Cb7p0DPVdfIgVduk6mjfrpuHfHLKqGtkHCQlLQc=
X-Google-Smtp-Source: AKy350ZuWd7mugyrAdXnio6VE4crahsS9GEM0wwvqoF62wNhNJD2gHedf/RhJ4yd/a2MqeHzPVvMWDz/osYDZcJOjpo=
X-Received: by 2002:a67:d719:0:b0:42c:8d9c:80d3 with SMTP id
 p25-20020a67d719000000b0042c8d9c80d3mr10196437vsj.0.1681825291407; Tue, 18
 Apr 2023 06:41:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230412135412.1684197-1-amir73il@gmail.com> <20230412135412.1684197-4-amir73il@gmail.com>
 <f3d4d0dacf08cb227661c2145840781915c3c7c2.camel@redhat.com>
In-Reply-To: <f3d4d0dacf08cb227661c2145840781915c3c7c2.camel@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Apr 2023 16:41:20 +0300
Message-ID: <CAOQ4uxgbO_7qcJiGKTJzV9dw5_cQrpVAAJ0DHQRQ+bi5NeUysQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] ovl: implement lookup in data-only layers
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2023 at 3:40=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Wed, 2023-04-12 at 16:54 +0300, Amir Goldstein wrote:
> > Lookup in data-only layers only for a lower metacopy with an absolute
> > redirect xattr.
> >
> > The metacopy xattr is not checked on files found in the data-only
> > layers
> > and redirect xattr are not followed in the data-only layers.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Reviewed-by: Alexander Larsson <alexl@redhat.com>
>
> > ---
> >  fs/overlayfs/namei.c | 77
> > ++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 75 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index ff82155b4f7e..82e103e2308b 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -14,6 +14,8 @@
> >  #include <linux/exportfs.h>
> >  #include "overlayfs.h"
> >
> > +#include "../internal.h"       /* for vfs_path_lookup */
> > +
> >  struct ovl_lookup_data {
> >         struct super_block *sb;
> >         struct vfsmount *mnt;
> > @@ -24,6 +26,8 @@ struct ovl_lookup_data {
> >         bool last;
> >         char *redirect;
> >         bool metacopy;
> > +       /* Referring to last redirect xattr */
> > +       bool absolute_redirect;
> >  };
> >
> >  static int ovl_check_redirect(const struct path *path, struct
> > ovl_lookup_data *d,
> > @@ -33,11 +37,13 @@ static int ovl_check_redirect(const struct path
> > *path, struct ovl_lookup_data *d
> >         char *buf;
> >         struct ovl_fs *ofs =3D OVL_FS(d->sb);
> >
> > +       d->absolute_redirect =3D false;
> >         buf =3D ovl_get_redirect_xattr(ofs, path, prelen +
> > strlen(post));
> >         if (IS_ERR_OR_NULL(buf))
> >                 return PTR_ERR(buf);
> >
> >         if (buf[0] =3D=3D '/') {
> > +               d->absolute_redirect =3D true;
> >                 /*
> >                  * One of the ancestor path elements in an absolute
> > path
> >                  * lookup in ovl_lookup_layer() could have been
> > opaque and
> > @@ -349,6 +355,61 @@ static int ovl_lookup_layer(struct dentry *base,
> > struct ovl_lookup_data *d,
> >         return 0;
> >  }
> >
> > +static int ovl_lookup_data_layer(struct dentry *dentry, const char
> > *redirect,
> > +                                const struct ovl_layer *layer,
> > +                                struct path *datapath)
> > +{
> > +       int err;
> > +
> > +       err =3D vfs_path_lookup(layer->mnt->mnt_root, layer->mnt,
> > redirect,
> > +                       LOOKUP_BENEATH | LOOKUP_NO_SYMLINKS |
> > LOOKUP_NO_XDEV,
> > +                       datapath);
> > +       pr_debug("lookup lowerdata (%pd2, redirect=3D\"%s\", layer=3D%d=
,
> > err=3D%i)\n",
> > +                dentry, redirect, layer->idx, err);
> > +
> > +       if (err)
> > +               return err;
> > +
> > +       err =3D -EREMOTE;
> > +       if (ovl_dentry_weird(datapath->dentry))
> > +               goto out_path_put;
> > +
> > +       err =3D -ENOENT;
> > +       /* Only regular file is acceptable as lower data */
> > +       if (!d_is_reg(datapath->dentry))
> > +               goto out_path_put;
> > +
> > +       return 0;
> > +
> > +out_path_put:
> > +       path_put(datapath);
> > +
> > +       return err;
> > +}
> > +
> > +/* Lookup in data-only layers by absolute redirect to layer root */
> > +static int ovl_lookup_data_layers(struct dentry *dentry, const char
> > *redirect,
> > +                                 struct ovl_path *lowerdata)
> > +{
> > +       struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> > +       const struct ovl_layer *layer;
> > +       struct path datapath;
> > +       int err =3D -ENOENT;
> > +       int i;
> > +
> > +       layer =3D &ofs->layers[ofs->numlayer - ofs->numdatalayer];
> > +       for (i =3D 0; i < ofs->numdatalayer; i++, layer++) {
> > +               err =3D ovl_lookup_data_layer(dentry, redirect, layer,
> > &datapath);
> > +               if (!err) {
> > +                       mntput(datapath.mnt);
> > +                       lowerdata->dentry =3D datapath.dentry;
> > +                       lowerdata->layer =3D layer;
> > +                       return 0;
> > +               }
> > +       }
> > +
> > +       return err;
> > +}
> >
> >  int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool
> > connected,
> >                         struct dentry *upperdentry, struct ovl_path
> > **stackp)
> > @@ -907,7 +968,9 @@ struct dentry *ovl_lookup(struct inode *dir,
> > struct dentry *dentry,
> >
> >         if (!d.stop && ovl_numlower(poe)) {
> >                 err =3D -ENOMEM;
> > -               stack =3D ovl_stack_alloc(ovl_numlowerlayer(ofs));
> > +               /* May need to reserve space in lowerstack for
> > lowerdata */
> > +               stack =3D ovl_stack_alloc(ovl_numlowerlayer(ofs) +
> > +                                       (!d.is_dir && !!ofs-
> > >numdatalayer));
>
> I think this runs into issues if ovl_numlower(poe) is zero, but we
> have a redirect into the lowerdata, due to the if (ovl_numlower(poe))
> check above. We won't be allocating the lowerdata stack space in this
> case.
>

Redirect from upper directly into data-only is not valid.
As the comment below says:
/* Lookup absolute redirect from lower metacopy in data-only layers */
data-only can only be accessed by absolute redirect from
lower layer.
Is that a problem for your use case?

> >                 if (!stack)
> >                         goto out_put_upper;
> >         }
> > @@ -917,7 +980,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> > struct dentry *dentry,
> >
> >                 if (!ofs->config.redirect_follow)
> >                         d.last =3D i =3D=3D ovl_numlower(poe) - 1;
> > -               else
> > +               else if (d.is_dir || !ofs->numdatalayer)
> >                         d.last =3D lower.layer->idx =3D=3D
> > ovl_numlower(roe);
> >
> >                 d.mnt =3D lower.layer->mnt;
> > @@ -1011,6 +1074,16 @@ struct dentry *ovl_lookup(struct inode *dir,
> > struct dentry *dentry,
> >                 }
> >         }
> >
> > +       /* Lookup absolute redirect from lower metacopy in data-only
> > layers */
> > +       if (d.metacopy && ctr && ofs->numdatalayer &&
> > d.absolute_redirect) {
> > +               err =3D ovl_lookup_data_layers(dentry, d.redirect,
> > +                                            &stack[ctr]);
> > +               if (!err) {
> > +                       d.metacopy =3D false;
> > +                       ctr++;
> > +               }
> > +       }
>
> This code runs even if ofs->config.redirect_follow is false. I think
> this is probably correct, but maybe it should be mentioned in the docs?
>

ofs->numdatalayer > 0 depends on ofs->config.metacopy
which depends on ofs->config.redirect or ofs->config.redirect_follow.

Thanks,
Amir.
