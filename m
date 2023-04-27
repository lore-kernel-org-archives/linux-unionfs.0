Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DDCC77B73
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 06:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242920AbjD0G3k (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 02:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242951AbjD0G3k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 02:29:40 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C212422B
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 23:29:39 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id ada2fe7eead31-42e35b7290fso2997905137.3
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 23:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682576978; x=1685168978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sEzqtB3HJTKeyXatyO56vK9yTZyCXQxsIoja3ZfinvQ=;
        b=E/5gjj61UauCm30en12z5ffsK7y4p9MbL+N2qDeAHBtDafN0rBPAvbt0rWIbHHTWlw
         JOA4/xcfDbfnTGhV2nU4twZk9FgLJe6Npt78HDq466joeyCfSN0YnkjAa75NkRPvhnPS
         KTgxW9LYoVNdVBQL0sf1dit676KbtMZ9W8q0YR3z3jPfgj5AHTx5mevT9Eagz8lu5TcO
         pozEg4/Z8vLB+mndt1cWdjYzvgs5+XFBEl/1nTiGAOowgjjJ5bybBEc4jcSXiQXKhfzd
         VPfXs/a9AkONFtag5KlNBu4+VTRtSrYcm74Ut/L2h5x1tFAjZThSf4cxf8oLLXFNRutm
         Pxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682576978; x=1685168978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sEzqtB3HJTKeyXatyO56vK9yTZyCXQxsIoja3ZfinvQ=;
        b=U5vVcVjtPVTzq4qWbnK7zE++AC+PVhKyIYvlOjFNXxrIBJU22gTKW+Q+MQZF4xoGDm
         8E92zh2CD6DIa61KOdkSkqiI9AqNOHw1slGuk/oNbRFjRSbnu1/aWEwO5An2OY7U5OzI
         xp7mJXvwPNcXNkNuqVUW+Xfr2eXWK/ed7aA4QX86TbgEYfIt0Q5pZSLjy6Jst4W8FuhP
         /twUKt6JAPLPxfzbBHPUHaGw0DJK9Vv0bKshmf1dxN9HFw22m5XRhBr8MlgkouWUtKoa
         wmmFqNNhV3biCmhrinG+KOEH0XsOmI8pcJvELGOeyeJxvZHzb8NBVKaR5aEgRAJxGHnY
         lbug==
X-Gm-Message-State: AC+VfDw8P7FTiogEvHrqXnRXGNqn4UU4Y+EId5yAuNkMXa2osIpTJoA7
        dVWLzUeV1NLkx64/PxHS2aU1E59iy3KHsF+Cv+8C+4x7Tiw=
X-Google-Smtp-Source: ACHHUZ4+BBzsLNPlSAW9S0x+4SXdpuxAjLS7ne3duozduX7EmhFNiNQOp1hp/x5k4RuYH8nyocXSEraVk/SV/lkZS9E=
X-Received: by 2002:a67:eb14:0:b0:42e:549d:617d with SMTP id
 a20-20020a67eb14000000b0042e549d617dmr248193vso.7.1682576978012; Wed, 26 Apr
 2023 23:29:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230408164302.1392694-1-amir73il@gmail.com> <20230408164302.1392694-7-amir73il@gmail.com>
 <e46a122924384758e784db584c21c56358c88390.camel@redhat.com>
In-Reply-To: <e46a122924384758e784db584c21c56358c88390.camel@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Apr 2023 09:29:27 +0300
Message-ID: <CAOQ4uxh5f_rX9KbwrKtGUp_QV8LN7jMkC1bYwNi7Cji0UPmz3A@mail.gmail.com>
Subject: Re: [PATCH 6/7] ovl: deduplicate lowerpath and lowerstack[0]
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2023 at 11:10=E2=80=AFAM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> On Sat, 2023-04-08 at 19:43 +0300, Amir Goldstein wrote:
> > For the common case of single lower layer, embed ovl_entry with a
> > single lower path in ovl_inode, so no stack allocation is needed.
> >
> > For directory with more than single lower layer and for regular file
> > with lowerdata, the lower stack is stored in an external allocation.
> >
> > Use accessor ovl_lowerstack() to get the embedded or external stack.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Reviewed-by: Alexander Larsson <alexl@redhat.com>
>
> > ---
> >  fs/overlayfs/dir.c       |  2 ++
> >  fs/overlayfs/export.c    | 18 +++++----------
> >  fs/overlayfs/inode.c     | 12 ++++------
> >  fs/overlayfs/namei.c     | 15 +++++--------
> >  fs/overlayfs/overlayfs.h | 10 +++++----
> >  fs/overlayfs/ovl_entry.h | 14 +++++++-----
> >  fs/overlayfs/super.c     | 41 +++++++++++++---------------------
> >  fs/overlayfs/util.c      | 48 +++++++++++++++++++++++++++++---------
> > --
> >  8 files changed, 81 insertions(+), 79 deletions(-)
> >
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index 92bdcedfaaec..aa0465c61064 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -262,9 +262,11 @@ static int ovl_set_opaque(struct dentry *dentry,
> > struct dentry *upperdentry)
> >  static int ovl_instantiate(struct dentry *dentry, struct inode
> > *inode,
> >                            struct dentry *newdentry, bool hardlink)
> >  {
> > +       struct ovl_entry oe =3D {};
> >         struct ovl_inode_params oip =3D {
> >                 .upperdentry =3D newdentry,
> >                 .newinode =3D inode,
> > +               .oe =3D &oe,
> >         };
> >
> >         ovl_dir_modified(dentry->d_parent, false);
> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > index d4caf57c8e17..9951c504fb8d 100644
> > --- a/fs/overlayfs/export.c
> > +++ b/fs/overlayfs/export.c
> > @@ -287,30 +287,22 @@ static struct dentry *ovl_obtain_alias(struct
> > super_block *sb,
> >         struct dentry *upper =3D upper_alias ?: index;
> >         struct dentry *dentry;
> >         struct inode *inode =3D NULL;
> > -       struct ovl_entry *oe;
> > +       struct ovl_entry oe;
> >         struct ovl_inode_params oip =3D {
> > -               .lowerpath =3D lowerpath,
> > +               .oe =3D &oe,
> >                 .index =3D index,
> > -               .numlower =3D !!lower
> >         };
> >
> >         /* We get overlay directory dentries with ovl_lookup_real()
> > */
> >         if (d_is_dir(upper ?: lower))
> >                 return ERR_PTR(-EIO);
> >
> > -       oe =3D ovl_alloc_entry(!!lower);
> > -       if (!oe)
> > -               goto nomem;
> > -
>
> Ah, I see that the goto nomem goes away here, so I guess ignore my
> comment on previous patch.
>
>

No need to ignore, we do not leave mid series bugs.
It is bad for bisection.

Thanks,
Amir.
