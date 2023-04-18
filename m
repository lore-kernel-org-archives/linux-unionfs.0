Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863F4C6FD18
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 14:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjDROBH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 10:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbjDROBE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2023 10:01:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D86CC64E
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 07:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681826414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+W878LdvW6EssoFdA/3YlR7svlrTC2mZw1IgJCrUGKM=;
        b=biPgrAVq1kVeJiTD9CiYrMYr4FtIQyhO0DzppklBc2wJmeE5m7yIhmoTDsVw42hsE2MRng
        1Mh09DBkpPEEdnLuQyqKLrlz7CiWfSXdXHvFkm4+zfB0nGIu0BSOkwYsL+XmvFYbytyvBB
        GJXbNpwbupYAMULI9wDNL9rM7yFfOkM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-tIWTNSE4MeuXcSUfQlwKyA-1; Tue, 18 Apr 2023 10:00:13 -0400
X-MC-Unique: tIWTNSE4MeuXcSUfQlwKyA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-32a8c155f24so48129305ab.0
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 07:00:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826412; x=1684418412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+W878LdvW6EssoFdA/3YlR7svlrTC2mZw1IgJCrUGKM=;
        b=RX/QQdmQaA2Tj+1E0Fc2hBK16SzCbyn6lProAGcvwBo6mQqTeZGx4fmaTrw5rD71yL
         aZgaPaZ/9ZA/5ZgWRVhpjnNLFpOnVCZRydi3S8KVLabcYBOmgeUs4B8zUJG5O4wlTt7J
         xpO9Nac1FRDfs51byNq4jaufoRgEqC1o6aOWY/EPvmV3KFZgUiHYOT479xGSq+8wkvMU
         MVNjE3W1ryL+Meeh58fqJWxgFAd0nUFU+8Y1OhPoOc6+I7GxfEbVxVKS/gECAFdxDt21
         s+lIprRuXhh3pF90zxrlrwFcprxgHCaKrY4Spy7bSu96ajHdwAZdlH/AQj5wPipSS9LP
         Ikvw==
X-Gm-Message-State: AAQBX9dSAnq9h8PxGaS/DSSoXsAnpA0jUZdKBA+Pe8iJQXgP8Iqly7mr
        prglc3xYyUIyVB8c4mZDs8p9LbvCvKQ2uT+Yb05SN2XgBHmmSHcAvBE+gxqFJYa0qZq+sdFvedo
        B9RX5vvPEgkaEy8S1mjpz4lk304OgeOdxeWM+7IXndZ/Pa8Lrh4lZ
X-Received: by 2002:a92:90b:0:b0:326:ce2:df9e with SMTP id y11-20020a92090b000000b003260ce2df9emr8883131ilg.4.1681826412213;
        Tue, 18 Apr 2023 07:00:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yf5ISoHLaoaccQEZV4ey1mSOjpXadOqgF7XnLuI91gwvRuXerZZF+gqxQU2Pyq+x/Sf6agvkKahe+8MhVPVis=
X-Received: by 2002:a92:90b:0:b0:326:ce2:df9e with SMTP id y11-20020a92090b000000b003260ce2df9emr8883117ilg.4.1681826411949;
 Tue, 18 Apr 2023 07:00:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230412135412.1684197-1-amir73il@gmail.com> <20230412135412.1684197-4-amir73il@gmail.com>
 <f3d4d0dacf08cb227661c2145840781915c3c7c2.camel@redhat.com> <CAOQ4uxgbO_7qcJiGKTJzV9dw5_cQrpVAAJ0DHQRQ+bi5NeUysQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxgbO_7qcJiGKTJzV9dw5_cQrpVAAJ0DHQRQ+bi5NeUysQ@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 18 Apr 2023 16:00:00 +0200
Message-ID: <CAL7ro1EhRJbiDq5rYbPmeUTa-BwJYr2CV7ufCAgD2mmL+yWhZA@mail.gmail.com>
Subject: Re: [PATCH 3/5] ovl: implement lookup in data-only layers
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2023 at 3:41=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Tue, Apr 18, 2023 at 3:40=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > On Wed, 2023-04-12 at 16:54 +0300, Amir Goldstein wrote:
> > > Lookup in data-only layers only for a lower metacopy with an absolute
> > > redirect xattr.
> > >
> > > The metacopy xattr is not checked on files found in the data-only
> > > layers
> > > and redirect xattr are not followed in the data-only layers.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > Reviewed-by: Alexander Larsson <alexl@redhat.com>
> >
> > > ---
> > >  fs/overlayfs/namei.c | 77
> > > ++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 75 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > > index ff82155b4f7e..82e103e2308b 100644
> > > --- a/fs/overlayfs/namei.c
> > > +++ b/fs/overlayfs/namei.c
> > > @@ -14,6 +14,8 @@
> > >  #include <linux/exportfs.h>
> > >  #include "overlayfs.h"
> > >
> > > +#include "../internal.h"       /* for vfs_path_lookup */
> > > +
> > >  struct ovl_lookup_data {
> > >         struct super_block *sb;
> > >         struct vfsmount *mnt;
> > > @@ -24,6 +26,8 @@ struct ovl_lookup_data {
> > >         bool last;
> > >         char *redirect;
> > >         bool metacopy;
> > > +       /* Referring to last redirect xattr */
> > > +       bool absolute_redirect;
> > >  };
> > >
> > >  static int ovl_check_redirect(const struct path *path, struct
> > > ovl_lookup_data *d,
> > > @@ -33,11 +37,13 @@ static int ovl_check_redirect(const struct path
> > > *path, struct ovl_lookup_data *d
> > >         char *buf;
> > >         struct ovl_fs *ofs =3D OVL_FS(d->sb);
> > >
> > > +       d->absolute_redirect =3D false;
> > >         buf =3D ovl_get_redirect_xattr(ofs, path, prelen +
> > > strlen(post));
> > >         if (IS_ERR_OR_NULL(buf))
> > >                 return PTR_ERR(buf);
> > >
> > >         if (buf[0] =3D=3D '/') {
> > > +               d->absolute_redirect =3D true;
> > >                 /*
> > >                  * One of the ancestor path elements in an absolute
> > > path
> > >                  * lookup in ovl_lookup_layer() could have been
> > > opaque and
> > > @@ -349,6 +355,61 @@ static int ovl_lookup_layer(struct dentry *base,
> > > struct ovl_lookup_data *d,
> > >         return 0;
> > >  }
> > >
> > > +static int ovl_lookup_data_layer(struct dentry *dentry, const char
> > > *redirect,
> > > +                                const struct ovl_layer *layer,
> > > +                                struct path *datapath)
> > > +{
> > > +       int err;
> > > +
> > > +       err =3D vfs_path_lookup(layer->mnt->mnt_root, layer->mnt,
> > > redirect,
> > > +                       LOOKUP_BENEATH | LOOKUP_NO_SYMLINKS |
> > > LOOKUP_NO_XDEV,
> > > +                       datapath);
> > > +       pr_debug("lookup lowerdata (%pd2, redirect=3D\"%s\", layer=3D=
%d,
> > > err=3D%i)\n",
> > > +                dentry, redirect, layer->idx, err);
> > > +
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       err =3D -EREMOTE;
> > > +       if (ovl_dentry_weird(datapath->dentry))
> > > +               goto out_path_put;
> > > +
> > > +       err =3D -ENOENT;
> > > +       /* Only regular file is acceptable as lower data */
> > > +       if (!d_is_reg(datapath->dentry))
> > > +               goto out_path_put;
> > > +
> > > +       return 0;
> > > +
> > > +out_path_put:
> > > +       path_put(datapath);
> > > +
> > > +       return err;
> > > +}
> > > +
> > > +/* Lookup in data-only layers by absolute redirect to layer root */
> > > +static int ovl_lookup_data_layers(struct dentry *dentry, const char
> > > *redirect,
> > > +                                 struct ovl_path *lowerdata)
> > > +{
> > > +       struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> > > +       const struct ovl_layer *layer;
> > > +       struct path datapath;
> > > +       int err =3D -ENOENT;
> > > +       int i;
> > > +
> > > +       layer =3D &ofs->layers[ofs->numlayer - ofs->numdatalayer];
> > > +       for (i =3D 0; i < ofs->numdatalayer; i++, layer++) {
> > > +               err =3D ovl_lookup_data_layer(dentry, redirect, layer=
,
> > > &datapath);
> > > +               if (!err) {
> > > +                       mntput(datapath.mnt);
> > > +                       lowerdata->dentry =3D datapath.dentry;
> > > +                       lowerdata->layer =3D layer;
> > > +                       return 0;
> > > +               }
> > > +       }
> > > +
> > > +       return err;
> > > +}
> > >
> > >  int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool
> > > connected,
> > >                         struct dentry *upperdentry, struct ovl_path
> > > **stackp)
> > > @@ -907,7 +968,9 @@ struct dentry *ovl_lookup(struct inode *dir,
> > > struct dentry *dentry,
> > >
> > >         if (!d.stop && ovl_numlower(poe)) {
> > >                 err =3D -ENOMEM;
> > > -               stack =3D ovl_stack_alloc(ovl_numlowerlayer(ofs));
> > > +               /* May need to reserve space in lowerstack for
> > > lowerdata */
> > > +               stack =3D ovl_stack_alloc(ovl_numlowerlayer(ofs) +
> > > +                                       (!d.is_dir && !!ofs-
> > > >numdatalayer));
> >
> > I think this runs into issues if ovl_numlower(poe) is zero, but we
> > have a redirect into the lowerdata, due to the if (ovl_numlower(poe))
> > check above. We won't be allocating the lowerdata stack space in this
> > case.
> >
>
> Redirect from upper directly into data-only is not valid.

Ah.

> As the comment below says:
> /* Lookup absolute redirect from lower metacopy in data-only layers */
> data-only can only be accessed by absolute redirect from
> lower layer.
> Is that a problem for your use case?

No, just something I noticed that looked wrong.

> > >                 if (!stack)
> > >                         goto out_put_upper;
> > >         }
> > > @@ -917,7 +980,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> > > struct dentry *dentry,
> > >
> > >                 if (!ofs->config.redirect_follow)
> > >                         d.last =3D i =3D=3D ovl_numlower(poe) - 1;
> > > -               else
> > > +               else if (d.is_dir || !ofs->numdatalayer)
> > >                         d.last =3D lower.layer->idx =3D=3D
> > > ovl_numlower(roe);
> > >
> > >                 d.mnt =3D lower.layer->mnt;
> > > @@ -1011,6 +1074,16 @@ struct dentry *ovl_lookup(struct inode *dir,
> > > struct dentry *dentry,
> > >                 }
> > >         }
> > >
> > > +       /* Lookup absolute redirect from lower metacopy in data-only
> > > layers */
> > > +       if (d.metacopy && ctr && ofs->numdatalayer &&
> > > d.absolute_redirect) {
> > > +               err =3D ovl_lookup_data_layers(dentry, d.redirect,
> > > +                                            &stack[ctr]);
> > > +               if (!err) {
> > > +                       d.metacopy =3D false;
> > > +                       ctr++;
> > > +               }
> > > +       }
> >
> > This code runs even if ofs->config.redirect_follow is false. I think
> > this is probably correct, but maybe it should be mentioned in the docs?
> >
>
> ofs->numdatalayer > 0 depends on ofs->config.metacopy
> which depends on ofs->config.redirect or ofs->config.redirect_follow.
>
> Thanks,
> Amir.
>


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

