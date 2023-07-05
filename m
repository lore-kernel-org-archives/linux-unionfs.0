Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4133DEB64DA
	for <linux-unionfs@archiver.kernel.org>; Wed,  5 Jul 2023 09:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjGEJM4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 05:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjGEJMz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2023 05:12:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7B4DD
        for <linux-unionfs@vger.kernel.org>; Wed,  5 Jul 2023 02:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688548326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lHt7fztlcuatzakbLpp3jG3VDU7KOxTlO7qTnhrR9YU=;
        b=M1/O4rAfjCDK6eagPkHfmkl1xk8ZHcyEsywhukojUdz7wK3CmTnzmgEmMxIRCET6K6efV3
        5VzDyR7kBoKBdDswpPqIR0pkbmHgb+30qHNYgxKCXiEkNjbIgpo8XxdDJG/fES3AzKA3WN
        /0WWFgpmeBa/NwfIUO4tNFw6moJUQ9c=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-oiEQcVM-OqSLsa_Dnr4QHA-1; Wed, 05 Jul 2023 05:12:04 -0400
X-MC-Unique: oiEQcVM-OqSLsa_Dnr4QHA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-786596bc0a6so285702639f.3
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Jul 2023 02:12:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688548324; x=1691140324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lHt7fztlcuatzakbLpp3jG3VDU7KOxTlO7qTnhrR9YU=;
        b=c4Iik/uotY2r7sQFyDGln4xpzf4TDJbgQRwPBfIEXXLa2tcV6TnJn0qQ33I/7554Da
         ag2FxX9InMfS+H3bkFTIgdcDFFfXuwgIii1fM8nulTVH0fD4YVble+l+SckVFyrs0otL
         Qmz4Xa4eHARDfsEi8rw/SUZ5wUEEdCNQgBNbr2arJDG/it9yr1itBX6r4u2hjuy0zGKi
         TbeMkRxJ1M2LJr6Z6dpKv4F2I5MpToTfuIO56bb1Xw4ZfH6/dxjRwJfrsqeYvqUkly0E
         yp16pwxzhgRL2jrFiSk3NHf8PlRq1CQUHvVMESQn3MBbby08mKOzsq6kgWxIYrjQdN9c
         O+Rg==
X-Gm-Message-State: ABy/qLbxztQh3Tz+UYUTmLEI67njWildQ6q6vpFOjuHpZshydV8bCM4g
        uXD2N25hApdHvLGIYP/WQ0Pq+c4JSGHnfoH9Z/1A9YgyE0/qJu1i0fbma6PgSn5sfYcENiETf1G
        qPwiz4TNZByikEXXUVkmtEZ2EIPm6zGItxjNftlpWkQ==
X-Received: by 2002:a92:dac4:0:b0:346:e96:7cbb with SMTP id o4-20020a92dac4000000b003460e967cbbmr9494383ilq.30.1688548324152;
        Wed, 05 Jul 2023 02:12:04 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG6lbvhhJut+mleOnP8lhAwoO1V4FEK/MsktYst/YIxG/SYT1S7KjPBjm4/VHsl9K/rs9K73jJ3oQmIpg4NuZM=
X-Received: by 2002:a92:dac4:0:b0:346:e96:7cbb with SMTP id
 o4-20020a92dac4000000b003460e967cbbmr9494373ilq.30.1688548323948; Wed, 05 Jul
 2023 02:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687345663.git.alexl@redhat.com> <8771725be2a8b7d65ea6c50a69bb6392b9e903aa.1687345663.git.alexl@redhat.com>
 <20230703192950.GE1194@sol.localdomain>
In-Reply-To: <20230703192950.GE1194@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 5 Jul 2023 11:11:53 +0200
Message-ID: <CAL7ro1FcWWvTd2Fzac-VkyikAYzv_ffEvssHAgHYKuZhKf30JQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] ovl: Handle verity during copy-up
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 3, 2023 at 9:30=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Wed, Jun 21, 2023 at 01:18:28PM +0200, Alexander Larsson wrote:
> > During regular metacopy, if lowerdata file has fs-verity enabled, and
> > the verity option is enabled, we add the digest to the metacopy xattr.
> >
> > If verity is required, and lowerdata does not have fs-verity enabled,
> > fall back to full copy-up (or the generated metacopy would not
> > validate).
> >
> > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c   | 45 ++++++++++++++++++++++++++++++++++++++--
> >  fs/overlayfs/overlayfs.h |  3 +++
> >  fs/overlayfs/util.c      | 33 ++++++++++++++++++++++++++++-
> >  3 files changed, 78 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 68f01fd7f211..fce7d048673c 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -544,6 +544,7 @@ struct ovl_copy_up_ctx {
> >       bool origin;
> >       bool indexed;
> >       bool metacopy;
> > +     bool metacopy_digest;
> >  };
> >
> >  static int ovl_link_up(struct ovl_copy_up_ctx *c)
> > @@ -641,8 +642,21 @@ static int ovl_copy_up_metadata(struct ovl_copy_up=
_ctx *c, struct dentry *temp)
> >       }
> >
> >       if (c->metacopy) {
> > -             err =3D ovl_check_setxattr(ofs, temp, OVL_XATTR_METACOPY,
> > -                                      NULL, 0, -EOPNOTSUPP);
> > +             struct path lowerdatapath;
> > +             struct ovl_metacopy metacopy_data =3D OVL_METACOPY_INIT;
> > +
> > +             ovl_path_lowerdata(c->dentry, &lowerdatapath);
> > +             if (WARN_ON_ONCE(lowerdatapath.dentry =3D=3D NULL))
> > +                     err =3D -EIO;
> > +             else
> > +                     err =3D ovl_set_verity_xattr_from(ofs, &lowerdata=
path, &metacopy_data);
>
> There's no dedicated verity xattr anymore, so maybe ovl_set_verity_xattr_=
from()
> should be renamed to something like ovl_get_verity_digest().

Yeah, that makes a lot of sense.

> > +
> > +             if (metacopy_data.digest_algo)
> > +                     c->metacopy_digest =3D true;
> > +
> > +             if (!err)
> > +                     err =3D ovl_set_metacopy_xattr(ofs, temp, &metaco=
py_data);
> > +
> >               if (err)
> >                       return err;
>
> The error handling above is a bit weird.  Some early returns would make i=
t
> easier to read:
>
>                 ovl_path_lowerdata(c->dentry, &lowerdatapath);
>                 if (WARN_ON_ONCE(lowerdatapath.dentry =3D=3D NULL))
>                         return -EIO;
>                 err =3D ovl_get_verity_digest(ofs, &lowerdatapath, &metac=
opy_data);
>                 if (err)
>                         return err;
>
>                 if (metacopy_data.digest_algo)
>                         c->metacopy_digest =3D true;
>
>                 err =3D ovl_set_metacopy_xattr(ofs, temp, &metacopy_data)=
;
>                 if (err)
>                         return err;

Yeah.

> >       }
> > @@ -751,6 +765,12 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_=
ctx *c)
> >       if (err)
> >               goto cleanup;
> >
> > +     if (c->metacopy_digest)
> > +             ovl_set_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
> > +     else
> > +             ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
> > +     ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
> > +
> >       if (!c->metacopy)
> >               ovl_set_upperdata(d_inode(c->dentry));
> >       inode =3D d_inode(c->dentry);
>
> Maybe the line 'inode =3D d_inode(c->dentry);' should be moved earlier, a=
nd then
> 'inode' used instead of 'd_inode(c->dentry)' later on.

I wonder why this wasn't already done for the ovl_set_upperdata(), but
it seems ok so I did this.

> > +     if (ofs->config.verity_mode =3D=3D OVL_VERITY_REQUIRE) {
> > +             struct path lowerdata;
> > +
> > +             ovl_path_lowerdata(dentry, &lowerdata);
> > +
> > +             if (WARN_ON_ONCE(lowerdata.dentry =3D=3D NULL) ||
> > +                 ovl_ensure_verity_loaded(&lowerdata) ||
> > +                 !fsverity_get_info(d_inode(lowerdata.dentry))) {
> > +                     return false;
>
> Please use !fsverity_active() instead of !fsverity_get_info().

Done.

All these changes are in git:
https://github.com/alexlarsson/linux/commits/overlay-verity

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

