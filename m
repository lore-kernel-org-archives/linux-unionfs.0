Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEE2C77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 06:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242942AbjD0GHZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 02:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbjD0GHY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 02:07:24 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8655CE78
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 23:07:23 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-42e371846d9so5228798137.2
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 23:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682575642; x=1685167642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QcIjrhO2p4YXbstRcfx6Meur53Uf1eNaWIaewm45UE=;
        b=GaMkNmVR9O75NRID0Lwz3LjcPD7f0CR00Qvcr3u2llHjeXSJMuLJ78YTtV6lcQ7Z7i
         VNbKvGrmdICZzmOLh5MuZYzz6d1ycdSlorMqV27D5HctSBal23ik9MCG9wvA0EX/hDx+
         uVVX/7jYhBo1DCny8bMT/vXRwSmPmpPSQbFq88U5MSLyKjKeQjcHPE+CG38nM0vzZbJ2
         PvsWsFxs2rS0TB2NaDNzQrExN7fup7FjR/lyDn6pkpxAS1K1aRic/NXYg/x/k6+XK60z
         zwolmgIcI1UZIXJNzkI34lLt4jeHWEQ0xC1HG5HkUl4iEd/U50iG7fjUn7hVoB5pjv3F
         zogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682575642; x=1685167642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6QcIjrhO2p4YXbstRcfx6Meur53Uf1eNaWIaewm45UE=;
        b=aewVwwyNysXb59XBIqxiCy8uZZja8kGOLOqRinJ6OSno/3OPr6yctyHFlb9XQTonFQ
         t9cVJ7CQ4lssVRd+UQ2WNgQWtw6SF6pF7i13/kcYsjYX8pzUW2537IX0A8pM0uxi47+q
         kKNIfLFNSdZP73OFez8NuTlovsJIcPh0Bm9vxOGSN2eYGRsK0RA2Tj6n6T+e/3JfC0/t
         ihrzcRcUrtAYDpVJ5TfmgtQifrOsCwwwwHzfzn0xgjQ96X8b9Mx/Mr5HTlexSFyesNwO
         U7D+b/W7K3zZAaxTGhBUJdYb++u8DXuKIwTlxd+88pO2ThPUoFRYGMW+ztpGCQprW5NY
         bCAg==
X-Gm-Message-State: AC+VfDxqn/VO/pjf+BZLpnTH13pJNiuvsGZubCA8vPXe5h2OHv/dvzGg
        SbaUOLRJe68iBJg5oju8Ule8JLhjVtFKLyqQIII=
X-Google-Smtp-Source: ACHHUZ6rL/2ek7QLWuqSRz4FFsg/EmDsQCdp4VTuc00YryHYaU8uZBB8OdK5+HweuXkdM2Ti5WbzA9mXNtWlin7AQnI=
X-Received: by 2002:a67:f88f:0:b0:430:6bdc:ee24 with SMTP id
 h15-20020a67f88f000000b004306bdcee24mr247451vso.18.1682575642445; Wed, 26 Apr
 2023 23:07:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230408164302.1392694-1-amir73il@gmail.com> <20230408164302.1392694-6-amir73il@gmail.com>
 <fb201464e525cc82d6abf81805bac3d2298b85d6.camel@redhat.com>
In-Reply-To: <fb201464e525cc82d6abf81805bac3d2298b85d6.camel@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Apr 2023 09:07:11 +0300
Message-ID: <CAOQ4uxhm7A2sa1T3gQAQsz1SBFLO_6+JWLJP770KtvQPM=148w@mail.gmail.com>
Subject: Re: [PATCH 5/7] ovl: move ovl_entry into ovl_inode
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2023 at 10:55=E2=80=AFAM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> On Sat, 2023-04-08 at 19:43 +0300, Amir Goldstein wrote:
> > The lower stacks of all the ovl inode aliases should be identical
> > and there is redundant information in ovl_entry and ovl_inode.
> >
> > Move lowerstack into ovl_inode and keep only the OVL_E_FLAGS
> > per overlay dentry.
> >
> > Following patches will deduplicate redundant ovl_inode fields.
> >
> > Note that for a negative dentry, OVL_E(dentry) can now be NULL,
> > so it is imporatnt to use the ovl_numlower() accessor.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
>
> Reviewed-by: Alexander Larsson <alexl@redhat.com>
>
> > ---
> >  fs/overlayfs/dir.c       |  2 +-
> >  fs/overlayfs/export.c    | 22 ++++++++++++----------
> >  fs/overlayfs/inode.c     |  8 ++++----
> >  fs/overlayfs/namei.c     |  5 ++---
> >  fs/overlayfs/overlayfs.h |  6 ++++--
> >  fs/overlayfs/ovl_entry.h | 36 ++++++++++++++++++------------------
> >  fs/overlayfs/super.c     | 18 ++++--------------
> >  fs/overlayfs/util.c      |  8 ++++----
> >  8 files changed, 49 insertions(+), 56 deletions(-)
> >
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index 9be52d8013c8..92bdcedfaaec 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -269,7 +269,7 @@ static int ovl_instantiate(struct dentry *dentry,
> > struct inode *inode,
> >
> >         ovl_dir_modified(dentry->d_parent, false);
> >         ovl_dentry_set_upper_alias(dentry);
> > -       ovl_dentry_init_reval(dentry, newdentry);
> > +       ovl_dentry_init_reval(dentry, newdentry, NULL);
> >
> >         if (!hardlink) {
> >                 /*
> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > index ddb546627749..d4caf57c8e17 100644
> > --- a/fs/overlayfs/export.c
> > +++ b/fs/overlayfs/export.c
> > @@ -286,7 +286,7 @@ static struct dentry *ovl_obtain_alias(struct
> > super_block *sb,
> >         struct dentry *lower =3D lowerpath ? lowerpath->dentry : NULL;
> >         struct dentry *upper =3D upper_alias ?: index;
> >         struct dentry *dentry;
> > -       struct inode *inode;
> > +       struct inode *inode =3D NULL;
> >         struct ovl_entry *oe;
> >         struct ovl_inode_params oip =3D {
> >                 .lowerpath =3D lowerpath,
> > @@ -298,9 +298,19 @@ static struct dentry *ovl_obtain_alias(struct
> > super_block *sb,
> >         if (d_is_dir(upper ?: lower))
> >                 return ERR_PTR(-EIO);
> >
> > +       oe =3D ovl_alloc_entry(!!lower);
> > +       if (!oe)
> > +               goto nomem;
>
> You goto nomem here, but that will dput(dentry), and dentry is not
> initialized yet. I think you should just return an error directly here.
>

Good catch!
Thanks for the review.

Amir.
