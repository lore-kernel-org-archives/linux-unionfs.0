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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC755C433ED
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 05:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D38061108
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 05:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhDIFvE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhDIFvD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Apr 2021 01:51:03 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C29AC061760
        for <linux-unionfs@vger.kernel.org>; Thu,  8 Apr 2021 22:50:50 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id r193so4731009ior.9
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Apr 2021 22:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bOEGFp4ZCX2N46JumzfLgw6FOeb/LUjjAW/nq2nQ/2E=;
        b=XLrGvuStmLl7irM6jkCMdclncRmrEI/E9jVkOvwtknrddUn83POJkqpPAPCDRd5B2p
         Ww6u9fUBMgbJBe8DxbWG2eO52Mz+wMuXzbm2ToabfFY3eApm0UuqoBorDbU0ASVKvJ9Y
         dxK5JI4rwfQg4XYDPZ4gAXSg6OqkMiggvI/kwHRKJlZinSRNi4gmmyLRZdy8JzKDrBJT
         Lbd+jdA/qdx55Uhr33fKI6ITBq1RLiLtepW/lt+ltEl06Kc103wS8QPvdvTSe5ebbZia
         3gxr2ha3bjlMW7ZoqmIWBqYpuGwHmvZYWRfgreruAm/pjbSHE/nQzFZxl2KuvEi4xEDv
         M3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bOEGFp4ZCX2N46JumzfLgw6FOeb/LUjjAW/nq2nQ/2E=;
        b=glCJQkfMxvC1wR1SEVnJTQ5QcF5jLcpgB8cVbtCOJBKlJ+oM5TaYHMFhXIqfXGJz1K
         m/XHf7neOqo11+nhdISywq420TyWSyRuoiB2/pShT41siLVO0TtBrdTG+oDwe4QhC2Ti
         sDdYtKfjCr/5OO478xv/XL7irLsdSPQpGEjrqiw8Cb3PVDQhgWhbHjmFHSnV8MKad0SK
         VD8NFHU5p3Uaek58Dy9y0P1kgmvaNz1AufZUPQ7svCuyqZJq0O1mQkyzQVQPptkGBwC1
         HXLEWPPoAsBGgik1fRqiTZkRbcabOgHl42NubX0yKwzmdj6equyIa17Xg6+iFwUzPPfH
         QMFg==
X-Gm-Message-State: AOAM5302AxTBSWqJyRmas/4VraKFlVRMMit1sINhbpO2uXxfhRpAoZPX
        Emo4VVoTYrJMarNa+d2rM+JZJl6F/JnBj8TuTCJIY0REoZw=
X-Google-Smtp-Source: ABdhPJy0MpFp7XXgl4w4g3pVV8BexugfOd+tIMDa7NZd6IvYIJcwAK2+AWgCXwHOXIB+/N9Kyq4NboaKd8u0f5HJMBo=
X-Received: by 2002:a02:7a53:: with SMTP id z19mr4050155jad.120.1617947449312;
 Thu, 08 Apr 2021 22:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210406120245.1338326-1-cgxu519@mykernel.net>
 <20210406120245.1338326-3-cgxu519@mykernel.net> <CAOQ4uxg2Rydq1kx-rqguvC=bp4m80o7Yzy5r+HK7sqxXAVtcdA@mail.gmail.com>
 <178b1a73e24.d39bf86c18637.6167819870142236772@mykernel.net>
 <CAOQ4uxg592CQWgm=9RQ5sPbOECYnPRrv7A_H-xhjD5TrPM9LaQ@mail.gmail.com> <178b4932399.f88d0a1719390.547968204570738952@mykernel.net>
In-Reply-To: <178b4932399.f88d0a1719390.547968204570738952@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 9 Apr 2021 08:50:37 +0300
Message-ID: <CAOQ4uxhj3F_KQLyxEz3u7L-se-zWj40XiEsUKcuFurvYK_5S0w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: copy-up optimization for truncate
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 9, 2021 at 6:00 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 22:40:47 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Thu, Apr 8, 2021 at 4:23 PM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
>  > >
>  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2021-04-07 15:52:15 Ami=
r Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > >  > On Wed, Apr 7, 2021 at 12:04 AM Chengguang Xu <cgxu519@mykernel.n=
et> wrote:
>  > >  > >
>  > >  > > Currently truncate operation on the file which only has
>  > >  > > lower will copy-up whole lower file and calling truncate(2)
>  > >  > > on upper file. It is not efficient for the case which
>  > >  > > truncates to much smaller size than lower file. This patch
>  > >  > > tries to avoid unnecessary data copy and truncate operation
>  > >  > > after copy-up.
>  > >  > >
>  > >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > >  > > ---
>  > >  > >  fs/overlayfs/copy_up.c   | 18 +++++++++++-------
>  > >  > >  fs/overlayfs/inode.c     |  9 ++++++++-
>  > >  > >  fs/overlayfs/overlayfs.h |  2 +-
>  > >  > >  3 files changed, 20 insertions(+), 9 deletions(-)
>  > >  > >
>  > >  > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>  > >  > > index a1a9a150405a..331cc32eac95 100644
>  > >  > > --- a/fs/overlayfs/copy_up.c
>  > >  > > +++ b/fs/overlayfs/copy_up.c
>  > >  > > @@ -874,7 +874,7 @@ static int ovl_copy_up_meta_inode_data(stru=
ct ovl_copy_up_ctx *c)
>  > >  > >  }
>  > >  > >
>  > >  > >  static int ovl_copy_up_one(struct dentry *parent, struct dentr=
y *dentry,
>  > >  > > -                          int flags)
>  > >  > > +                          int flags, loff_t size)
>  > >  > >  {
>  > >  > >         int err;
>  > >  > >         DEFINE_DELAYED_CALL(done);
>  > >  > > @@ -911,6 +911,8 @@ static int ovl_copy_up_one(struct dentry *p=
arent, struct dentry *dentry,
>  > >  > >         /* maybe truncate regular file. this has no effect on d=
irs */
>  > >  > >         if (flags & O_TRUNC)
>  > >  > >                 ctx.stat.size =3D 0;
>  > >  > > +       if (size)
>  > >  > > +               ctx.stat.size =3D size;
>  > >  >
>  > >  > Not sure about this, but *maybe* instead we re-interpret O_TRUNC
>  > >  > internally as "either O_TRUNC or truncate()" and then:
>  > >  >          if (flags & O_TRUNC)
>  > >  >                  ctx.stat.size =3D size;
>  > >  >
>  > >  > It would simplify the logic in ovl_copy_up_with_data().
>  > >  > If you do that, put a comment to clarify that special meaning.
>  > >  >
>  > >  > >
>  > >  > >         if (S_ISLNK(ctx.stat.mode)) {
>  > >  > >                 ctx.link =3D vfs_get_link(ctx.lowerpath.dentry,=
 &done);
>  > >  > > @@ -937,7 +939,7 @@ static int ovl_copy_up_one(struct dentry *p=
arent, struct dentry *dentry,
>  > >  > >         return err;
>  > >  > >  }
>  > >  > >
>  > >  > > -static int ovl_copy_up_flags(struct dentry *dentry, int flags)
>  > >  > > +static int ovl_copy_up_flags(struct dentry *dentry, int flags,=
 loff_t size)
>  > >  > >  {
>  > >  > >         int err =3D 0;
>  > >  > >         const struct cred *old_cred =3D ovl_override_creds(dent=
ry->d_sb);
>  > >  > > @@ -970,7 +972,7 @@ static int ovl_copy_up_flags(struct dentry =
*dentry, int flags)
>  > >  > >                         next =3D parent;
>  > >  > >                 }
>  > >  > >
>  > >  > > -               err =3D ovl_copy_up_one(parent, next, flags);
>  > >  > > +               err =3D ovl_copy_up_one(parent, next, flags, si=
ze);
>  > >  > >
>  > >  > >                 dput(parent);
>  > >  > >                 dput(next);
>  > >  > > @@ -1002,7 +1004,7 @@ int ovl_maybe_copy_up(struct dentry *dent=
ry, int flags)
>  > >  > >         if (ovl_open_need_copy_up(dentry, flags)) {
>  > >  > >                 err =3D ovl_want_write(dentry);
>  > >  > >                 if (!err) {
>  > >  > > -                       err =3D ovl_copy_up_flags(dentry, flags=
);
>  > >  > > +                       err =3D ovl_copy_up_flags(dentry, flags=
, 0);
>  > >  > >                         ovl_drop_write(dentry);
>  > >  > >                 }
>  > >  > >         }
>  > >  > > @@ -1010,12 +1012,14 @@ int ovl_maybe_copy_up(struct dentry *de=
ntry, int flags)
>  > >  > >         return err;
>  > >  > >  }
>  > >  > >
>  > >  > > -int ovl_copy_up_with_data(struct dentry *dentry)
>  > >  > > +int ovl_copy_up_with_data(struct dentry *dentry, loff_t size)
>  > >  > >  {
>  > >  > > -       return ovl_copy_up_flags(dentry, O_WRONLY);
>  > >  > > +       if (size)
>  > >  > > +               return ovl_copy_up_flags(dentry, O_WRONLY, size=
);
>  > >  > > +       return  ovl_copy_up_flags(dentry, O_TRUNC | O_WRONLY, 0=
);
>  > >  >
>  > >  > Best get rid of this helper and put this logic in ovl_setattr(). =
see below.
>  > >  >
>  > >  > >  }
>  > >  > >
>  > >  > >  int ovl_copy_up(struct dentry *dentry)
>  > >  > >  {
>  > >  > > -       return ovl_copy_up_flags(dentry, 0);
>  > >  > > +       return ovl_copy_up_flags(dentry, 0, 0);
>  > >  > >  }
>  > >  > > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>  > >  > > index cf41bcb664bc..92f274844947 100644
>  > >  > > --- a/fs/overlayfs/inode.c
>  > >  > > +++ b/fs/overlayfs/inode.c
>  > >  > > @@ -43,13 +43,20 @@ int ovl_setattr(struct dentry *dentry, stru=
ct iattr *attr)
>  > >  > >         if (!full_copy_up)
>  > >  > >                 err =3D ovl_copy_up(dentry);
>  > >  > >         else
>  > >  > > -               err =3D ovl_copy_up_with_data(dentry);
>  > >  > > +               err =3D ovl_copy_up_with_data(dentry, attr->ia_=
size);
>  > >  >
>  > >  > You do not know that ia_size is valid here.
>  > >
>  > > I think we don't have to worry about validation of ia_size here,
>  > > vfs layer has already done simple check for specified size and upper=
 fs
>  > > will return error when we set invalid file size after copy-up. Am I =
missing
>  > > something?
>  > >
>  >
>  > ovl_setattr() will be called from any number of places where ia_size h=
as
>  > uninitialized value, such as vfs_utimes().
>  >
>  > You are not allowed to access it without checking
>  > (attr->ia_valid & ATTR_SIZE) which here above you don't.
>  >
>
> Currently, (attr->ia_valid & ATTR_SIZE) is equal to var full_copy_up,
> so the size will be valid in this case.

Right. I still prefer killing the ovl_copy_up_with_data() helper.
It hurts more than it helps at this point IMO.

>
>  > >
>  > >  > Instead of using this if/else and full_copy_up var, use vars 'fla=
gs'
>  > >  > and 'size' and call ovl_copy_up_flags().
>  > >  > Instead of full_copy_up =3D true, set flags and size.
>  > >  > Then you may also remove ovl_copy_up_with_data() which has no oth=
er
>  > >  > callers.
>  > >  >
>  > >  > >         if (!err) {
>  > >  > >                 struct inode *winode =3D NULL;
>  > >  > >
>  > >  > >                 upperdentry =3D ovl_dentry_upper(dentry);
>  > >  > >
>  > >  > >                 if (attr->ia_valid & ATTR_SIZE) {
>  > >  > > +                       if (full_copy_up && !(attr->ia_valid & =
~ATTR_SIZE)) {
>  > >  > > +                               inode_lock(upperdentry->d_inode=
);
>  > >  > > +                               ovl_copyattr(upperdentry->d_ino=
de, dentry->d_inode);
>  > >  > > +                               inode_unlock(upperdentry->d_ino=
de);
>  > >  >
>  > >  > All that this is saving is an extra notify_change() call and I am=
 not sure it is
>  > >  > worth the special casing.
>  > >  >
>  > >  > Also, I think that is a bug and would make xfstest overlay/013 fa=
il.
>  > >
>  > > I ran testcases in overlay directory and didn't find failure related=
 to this change.
>  > > However, generic/313 failed unexpectedly, the reason is I used full_=
copy_up var
>  > > wrongly, for the file which has upper still needs to go through noti=
fy_change().
>  > >
>  > > By the way, I don't fully understand calling copy-up function(ovl_co=
py_up() or ovl_copy_up_with_data())
>  > > even for the file which has upper. Maybe it's better to optimize thi=
s part first in separated patch.
>  > >
>  >
>  > There is a difference between "has upper" and "has upper data".
>  > It's related to metacopy.
>  >
>
> I see, my point here is we can skip calling copy-up function for files wh=
ich already have upper data.
>

ovl_copy_up() already does all those optimizations internally.
We can pre-check upper data if it helps anything.

>
>
>  > >
>  > >  > When lower file is being executed, its true that we copy up anywa=
y
>  > >  > and that it is safe to do that, but test and applications expect =
to get
>  > >  > ETXTBSY error all the same.
>  > >
>  > > Actually we have already do the check and return ETXTBSY error, see =
below.
>  > >
>  > > err =3D -ETXTBSY;
>  > > if (atomic_read(&realinode->i_writecount) < 0)
>  > >         goto out_drop_write;
>  > >
>  >
>  > Yes, my point exactly. Your code does goto out_drop_write; before that=
 check
>  > so it will skip it.
>  >
>
> No, if you look at the code more closely , you'll find the goto in my cod=
e is actually after the check, :-).
>

I don't see it?? I see get_write_access() check after your goto.
What are we missing?
Anyway, I hold my opinion that the optimization of skipping notify_change()
has little benefit and is a potential for bugs, even if the specific
bug I pointed
out is not real.

Thanks,
Amir.
