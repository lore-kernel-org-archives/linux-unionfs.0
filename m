Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D803EC433ED
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 14:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6581610E8
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 14:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhDHOlM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 10:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhDHOlL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Apr 2021 10:41:11 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAB0C061760
        for <linux-unionfs@vger.kernel.org>; Thu,  8 Apr 2021 07:41:00 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id a11so415053ioo.0
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Apr 2021 07:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KF/mtTv8YgXOgH8Bv7abkki7GzCQXt0pibZp/33180k=;
        b=oQ7hoq3QQdFR+3zP7uBU9zOBbL287xcy+cMMC59B6YS9nXU7i4X3MAJMyTX9+8fL/S
         0OOsik9SzPPhKnBCSDDTs3nNOIBowIjGVt5ull9lqhA8B1NiGt/wr0lVZsokW7HDicY1
         09oQsjoBlCq6Adefrr5i5GsjjahwEsDG47zWpnJZ8tCJkCfzRMPVBd84mZfW8lkCEfjK
         1MJSCEbimiKv2SKaM9wgKYdPw6DzhVPN/yQn8Z0H/ye4uu1LCpxAC4DoP0vR907K1zTE
         XpuitdPdF0+kvmIgYXD3ZEG4aKHh/NvEO/ajfoyqU1g7k3sVKtlMNeyBA+rVqi3GxODN
         ROKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KF/mtTv8YgXOgH8Bv7abkki7GzCQXt0pibZp/33180k=;
        b=jSwflTv7Es62xpsaE1PECUhva8SzhLbo+RJyzlUc9Tw48cGYei26y96VxK4XMJOVOQ
         67i5jDlk7y6sJGeTfXqh2qtwltlvR276k0fY1i9APcaDi+vSuz6mgLvk6KQjTTMe+umE
         z1se4CQcw/iJN+EOKXcucCyLUwlleKWPLC3slmL1O9HZ5Mcv0ruuaCojPr6AvyY/Ph2a
         qS6DpFpBGNPQCMMtywtsGleaPzKX7YB+XsEH1dTNT4RwPu1fFDPJ847Vcb/r5pFX7CXA
         fNC+17+zXew61whNjIRSVvGdrDYXHhut4kWSEb/IWqToO9tXaXj+/ezJZgtoxvrfeN9x
         8q3g==
X-Gm-Message-State: AOAM530kpphdV5q7XhyKgKcX7s1iAZRruGVctNVQTfDQgP4wX/EiCwZF
        ND6lo6teQTahBD1ogv5GeMAJCCEKIm3MSWmrlis=
X-Google-Smtp-Source: ABdhPJxZAy8YZu+OJfoayksi4OX1NYbO1tSEOOdzkeaggKkWibQL2H7bp+oDEsBwlfbXd1duph7qxJDp/XmRm0HczVE=
X-Received: by 2002:a02:b615:: with SMTP id h21mr9303133jam.93.1617892858965;
 Thu, 08 Apr 2021 07:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210406120245.1338326-1-cgxu519@mykernel.net>
 <20210406120245.1338326-3-cgxu519@mykernel.net> <CAOQ4uxg2Rydq1kx-rqguvC=bp4m80o7Yzy5r+HK7sqxXAVtcdA@mail.gmail.com>
 <178b1a73e24.d39bf86c18637.6167819870142236772@mykernel.net>
In-Reply-To: <178b1a73e24.d39bf86c18637.6167819870142236772@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 8 Apr 2021 17:40:47 +0300
Message-ID: <CAOQ4uxg592CQWgm=9RQ5sPbOECYnPRrv7A_H-xhjD5TrPM9LaQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: copy-up optimization for truncate
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 8, 2021 at 4:23 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2021-04-07 15:52:15 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Wed, Apr 7, 2021 at 12:04 AM Chengguang Xu <cgxu519@mykernel.net> w=
rote:
>  > >
>  > > Currently truncate operation on the file which only has
>  > > lower will copy-up whole lower file and calling truncate(2)
>  > > on upper file. It is not efficient for the case which
>  > > truncates to much smaller size than lower file. This patch
>  > > tries to avoid unnecessary data copy and truncate operation
>  > > after copy-up.
>  > >
>  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > > ---
>  > >  fs/overlayfs/copy_up.c   | 18 +++++++++++-------
>  > >  fs/overlayfs/inode.c     |  9 ++++++++-
>  > >  fs/overlayfs/overlayfs.h |  2 +-
>  > >  3 files changed, 20 insertions(+), 9 deletions(-)
>  > >
>  > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>  > > index a1a9a150405a..331cc32eac95 100644
>  > > --- a/fs/overlayfs/copy_up.c
>  > > +++ b/fs/overlayfs/copy_up.c
>  > > @@ -874,7 +874,7 @@ static int ovl_copy_up_meta_inode_data(struct ov=
l_copy_up_ctx *c)
>  > >  }
>  > >
>  > >  static int ovl_copy_up_one(struct dentry *parent, struct dentry *de=
ntry,
>  > > -                          int flags)
>  > > +                          int flags, loff_t size)
>  > >  {
>  > >         int err;
>  > >         DEFINE_DELAYED_CALL(done);
>  > > @@ -911,6 +911,8 @@ static int ovl_copy_up_one(struct dentry *parent=
, struct dentry *dentry,
>  > >         /* maybe truncate regular file. this has no effect on dirs *=
/
>  > >         if (flags & O_TRUNC)
>  > >                 ctx.stat.size =3D 0;
>  > > +       if (size)
>  > > +               ctx.stat.size =3D size;
>  >
>  > Not sure about this, but *maybe* instead we re-interpret O_TRUNC
>  > internally as "either O_TRUNC or truncate()" and then:
>  >          if (flags & O_TRUNC)
>  >                  ctx.stat.size =3D size;
>  >
>  > It would simplify the logic in ovl_copy_up_with_data().
>  > If you do that, put a comment to clarify that special meaning.
>  >
>  > >
>  > >         if (S_ISLNK(ctx.stat.mode)) {
>  > >                 ctx.link =3D vfs_get_link(ctx.lowerpath.dentry, &don=
e);
>  > > @@ -937,7 +939,7 @@ static int ovl_copy_up_one(struct dentry *parent=
, struct dentry *dentry,
>  > >         return err;
>  > >  }
>  > >
>  > > -static int ovl_copy_up_flags(struct dentry *dentry, int flags)
>  > > +static int ovl_copy_up_flags(struct dentry *dentry, int flags, loff=
_t size)
>  > >  {
>  > >         int err =3D 0;
>  > >         const struct cred *old_cred =3D ovl_override_creds(dentry->d=
_sb);
>  > > @@ -970,7 +972,7 @@ static int ovl_copy_up_flags(struct dentry *dent=
ry, int flags)
>  > >                         next =3D parent;
>  > >                 }
>  > >
>  > > -               err =3D ovl_copy_up_one(parent, next, flags);
>  > > +               err =3D ovl_copy_up_one(parent, next, flags, size);
>  > >
>  > >                 dput(parent);
>  > >                 dput(next);
>  > > @@ -1002,7 +1004,7 @@ int ovl_maybe_copy_up(struct dentry *dentry, i=
nt flags)
>  > >         if (ovl_open_need_copy_up(dentry, flags)) {
>  > >                 err =3D ovl_want_write(dentry);
>  > >                 if (!err) {
>  > > -                       err =3D ovl_copy_up_flags(dentry, flags);
>  > > +                       err =3D ovl_copy_up_flags(dentry, flags, 0);
>  > >                         ovl_drop_write(dentry);
>  > >                 }
>  > >         }
>  > > @@ -1010,12 +1012,14 @@ int ovl_maybe_copy_up(struct dentry *dentry,=
 int flags)
>  > >         return err;
>  > >  }
>  > >
>  > > -int ovl_copy_up_with_data(struct dentry *dentry)
>  > > +int ovl_copy_up_with_data(struct dentry *dentry, loff_t size)
>  > >  {
>  > > -       return ovl_copy_up_flags(dentry, O_WRONLY);
>  > > +       if (size)
>  > > +               return ovl_copy_up_flags(dentry, O_WRONLY, size);
>  > > +       return  ovl_copy_up_flags(dentry, O_TRUNC | O_WRONLY, 0);
>  >
>  > Best get rid of this helper and put this logic in ovl_setattr(). see b=
elow.
>  >
>  > >  }
>  > >
>  > >  int ovl_copy_up(struct dentry *dentry)
>  > >  {
>  > > -       return ovl_copy_up_flags(dentry, 0);
>  > > +       return ovl_copy_up_flags(dentry, 0, 0);
>  > >  }
>  > > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>  > > index cf41bcb664bc..92f274844947 100644
>  > > --- a/fs/overlayfs/inode.c
>  > > +++ b/fs/overlayfs/inode.c
>  > > @@ -43,13 +43,20 @@ int ovl_setattr(struct dentry *dentry, struct ia=
ttr *attr)
>  > >         if (!full_copy_up)
>  > >                 err =3D ovl_copy_up(dentry);
>  > >         else
>  > > -               err =3D ovl_copy_up_with_data(dentry);
>  > > +               err =3D ovl_copy_up_with_data(dentry, attr->ia_size)=
;
>  >
>  > You do not know that ia_size is valid here.
>
> I think we don't have to worry about validation of ia_size here,
> vfs layer has already done simple check for specified size and upper fs
> will return error when we set invalid file size after copy-up. Am I missi=
ng
> something?
>

ovl_setattr() will be called from any number of places where ia_size has
uninitialized value, such as vfs_utimes().

You are not allowed to access it without checking
(attr->ia_valid & ATTR_SIZE) which here above you don't.

>
>  > Instead of using this if/else and full_copy_up var, use vars 'flags'
>  > and 'size' and call ovl_copy_up_flags().
>  > Instead of full_copy_up =3D true, set flags and size.
>  > Then you may also remove ovl_copy_up_with_data() which has no other
>  > callers.
>  >
>  > >         if (!err) {
>  > >                 struct inode *winode =3D NULL;
>  > >
>  > >                 upperdentry =3D ovl_dentry_upper(dentry);
>  > >
>  > >                 if (attr->ia_valid & ATTR_SIZE) {
>  > > +                       if (full_copy_up && !(attr->ia_valid & ~ATTR=
_SIZE)) {
>  > > +                               inode_lock(upperdentry->d_inode);
>  > > +                               ovl_copyattr(upperdentry->d_inode, d=
entry->d_inode);
>  > > +                               inode_unlock(upperdentry->d_inode);
>  >
>  > All that this is saving is an extra notify_change() call and I am not =
sure it is
>  > worth the special casing.
>  >
>  > Also, I think that is a bug and would make xfstest overlay/013 fail.
>
> I ran testcases in overlay directory and didn't find failure related to t=
his change.
> However, generic/313 failed unexpectedly, the reason is I used full_copy_=
up var
> wrongly, for the file which has upper still needs to go through notify_ch=
ange().
>
> By the way, I don't fully understand calling copy-up function(ovl_copy_up=
() or ovl_copy_up_with_data())
> even for the file which has upper. Maybe it's better to optimize this par=
t first in separated patch.
>

There is a difference between "has upper" and "has upper data".
It's related to metacopy.

>
>  > When lower file is being executed, its true that we copy up anyway
>  > and that it is safe to do that, but test and applications expect to ge=
t
>  > ETXTBSY error all the same.
>
> Actually we have already do the check and return ETXTBSY error, see below=
.
>
> err =3D -ETXTBSY;
> if (atomic_read(&realinode->i_writecount) < 0)
>         goto out_drop_write;
>

Yes, my point exactly. Your code does goto out_drop_write; before that chec=
k
so it will skip it.

Thanks,
Amir.
