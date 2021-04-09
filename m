Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034BDC433ED
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 03:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1BF6610A5
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 03:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhDIDBQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 23:01:16 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25350 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233105AbhDIDBP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Apr 2021 23:01:15 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617937247; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=mLYtabuWlqLorJR9zCqa1i2frUCuxGQ59uLqxIuMNjqj9U6Ng4NSpPsrgpe0SwWslMexDzSc45Nszgu36LBzuB6yRmLs4rFYCQq9UPAN/BwPwrhS0bPyHHwC18knbbULEbnYsY7WzwSdGhFkX52kOOIdtn+fZHDTlCKKV9Q6Zy0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617937247; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=ZZWUQoBo43JmzrljSa0QxjsAm9vCcYJ5YuuoIoZ6Xqs=; 
        b=nwt4+oX4zxJDs0vV0nJMorJoyO85VX4awvOhb++Cd2YknPv2twzBd3Myg1pDxFxYgiDM8bjFGAQX+qCvGo39L2NCuzvOWoz/YQ2oP23oBEVb1/Y22gJn+309QD4Qf7cq+lceoP4iYGw+TITQvZZgOE0hJRwASNfyjOcfN6EQkZQ=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617937247;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=ZZWUQoBo43JmzrljSa0QxjsAm9vCcYJ5YuuoIoZ6Xqs=;
        b=PjopsCFDvDtDmOyyv7MaIu0dvuKRWWvg0VP3zd8HWF4VLfMPkCgT6PDprYaCPiEv
        wDBpuU7m+lYQHMcS44DxyRwodp0N/9jsD+qSrdyU1Nls1AzCO6+S26LYTZdNWybKeLJ
        13B9EOCqjBROK+DwKwJ26snQmKT8tykw1XcORDyA=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1617937245086672.4056142603018; Fri, 9 Apr 2021 11:00:45 +0800 (CST)
Date:   Fri, 09 Apr 2021 11:00:45 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <178b4932399.f88d0a1719390.547968204570738952@mykernel.net>
In-Reply-To: <CAOQ4uxg592CQWgm=9RQ5sPbOECYnPRrv7A_H-xhjD5TrPM9LaQ@mail.gmail.com>
References: <20210406120245.1338326-1-cgxu519@mykernel.net>
 <20210406120245.1338326-3-cgxu519@mykernel.net> <CAOQ4uxg2Rydq1kx-rqguvC=bp4m80o7Yzy5r+HK7sqxXAVtcdA@mail.gmail.com>
 <178b1a73e24.d39bf86c18637.6167819870142236772@mykernel.net> <CAOQ4uxg592CQWgm=9RQ5sPbOECYnPRrv7A_H-xhjD5TrPM9LaQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: copy-up optimization for truncate
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 22:40:47 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Thu, Apr 8, 2021 at 4:23 PM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2021-04-07 15:52:15 Amir =
Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > On Wed, Apr 7, 2021 at 12:04 AM Chengguang Xu <cgxu519@mykernel.net=
> wrote:
 > >  > >
 > >  > > Currently truncate operation on the file which only has
 > >  > > lower will copy-up whole lower file and calling truncate(2)
 > >  > > on upper file. It is not efficient for the case which
 > >  > > truncates to much smaller size than lower file. This patch
 > >  > > tries to avoid unnecessary data copy and truncate operation
 > >  > > after copy-up.
 > >  > >
 > >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > >  > > ---
 > >  > >  fs/overlayfs/copy_up.c   | 18 +++++++++++-------
 > >  > >  fs/overlayfs/inode.c     |  9 ++++++++-
 > >  > >  fs/overlayfs/overlayfs.h |  2 +-
 > >  > >  3 files changed, 20 insertions(+), 9 deletions(-)
 > >  > >
 > >  > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
 > >  > > index a1a9a150405a..331cc32eac95 100644
 > >  > > --- a/fs/overlayfs/copy_up.c
 > >  > > +++ b/fs/overlayfs/copy_up.c
 > >  > > @@ -874,7 +874,7 @@ static int ovl_copy_up_meta_inode_data(struct=
 ovl_copy_up_ctx *c)
 > >  > >  }
 > >  > >
 > >  > >  static int ovl_copy_up_one(struct dentry *parent, struct dentry =
*dentry,
 > >  > > -                          int flags)
 > >  > > +                          int flags, loff_t size)
 > >  > >  {
 > >  > >         int err;
 > >  > >         DEFINE_DELAYED_CALL(done);
 > >  > > @@ -911,6 +911,8 @@ static int ovl_copy_up_one(struct dentry *par=
ent, struct dentry *dentry,
 > >  > >         /* maybe truncate regular file. this has no effect on dir=
s */
 > >  > >         if (flags & O_TRUNC)
 > >  > >                 ctx.stat.size =3D 0;
 > >  > > +       if (size)
 > >  > > +               ctx.stat.size =3D size;
 > >  >
 > >  > Not sure about this, but *maybe* instead we re-interpret O_TRUNC
 > >  > internally as "either O_TRUNC or truncate()" and then:
 > >  >          if (flags & O_TRUNC)
 > >  >                  ctx.stat.size =3D size;
 > >  >
 > >  > It would simplify the logic in ovl_copy_up_with_data().
 > >  > If you do that, put a comment to clarify that special meaning.
 > >  >
 > >  > >
 > >  > >         if (S_ISLNK(ctx.stat.mode)) {
 > >  > >                 ctx.link =3D vfs_get_link(ctx.lowerpath.dentry, &=
done);
 > >  > > @@ -937,7 +939,7 @@ static int ovl_copy_up_one(struct dentry *par=
ent, struct dentry *dentry,
 > >  > >         return err;
 > >  > >  }
 > >  > >
 > >  > > -static int ovl_copy_up_flags(struct dentry *dentry, int flags)
 > >  > > +static int ovl_copy_up_flags(struct dentry *dentry, int flags, l=
off_t size)
 > >  > >  {
 > >  > >         int err =3D 0;
 > >  > >         const struct cred *old_cred =3D ovl_override_creds(dentry=
->d_sb);
 > >  > > @@ -970,7 +972,7 @@ static int ovl_copy_up_flags(struct dentry *d=
entry, int flags)
 > >  > >                         next =3D parent;
 > >  > >                 }
 > >  > >
 > >  > > -               err =3D ovl_copy_up_one(parent, next, flags);
 > >  > > +               err =3D ovl_copy_up_one(parent, next, flags, size=
);
 > >  > >
 > >  > >                 dput(parent);
 > >  > >                 dput(next);
 > >  > > @@ -1002,7 +1004,7 @@ int ovl_maybe_copy_up(struct dentry *dentry=
, int flags)
 > >  > >         if (ovl_open_need_copy_up(dentry, flags)) {
 > >  > >                 err =3D ovl_want_write(dentry);
 > >  > >                 if (!err) {
 > >  > > -                       err =3D ovl_copy_up_flags(dentry, flags);
 > >  > > +                       err =3D ovl_copy_up_flags(dentry, flags, =
0);
 > >  > >                         ovl_drop_write(dentry);
 > >  > >                 }
 > >  > >         }
 > >  > > @@ -1010,12 +1012,14 @@ int ovl_maybe_copy_up(struct dentry *dent=
ry, int flags)
 > >  > >         return err;
 > >  > >  }
 > >  > >
 > >  > > -int ovl_copy_up_with_data(struct dentry *dentry)
 > >  > > +int ovl_copy_up_with_data(struct dentry *dentry, loff_t size)
 > >  > >  {
 > >  > > -       return ovl_copy_up_flags(dentry, O_WRONLY);
 > >  > > +       if (size)
 > >  > > +               return ovl_copy_up_flags(dentry, O_WRONLY, size);
 > >  > > +       return  ovl_copy_up_flags(dentry, O_TRUNC | O_WRONLY, 0);
 > >  >
 > >  > Best get rid of this helper and put this logic in ovl_setattr(). se=
e below.
 > >  >
 > >  > >  }
 > >  > >
 > >  > >  int ovl_copy_up(struct dentry *dentry)
 > >  > >  {
 > >  > > -       return ovl_copy_up_flags(dentry, 0);
 > >  > > +       return ovl_copy_up_flags(dentry, 0, 0);
 > >  > >  }
 > >  > > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
 > >  > > index cf41bcb664bc..92f274844947 100644
 > >  > > --- a/fs/overlayfs/inode.c
 > >  > > +++ b/fs/overlayfs/inode.c
 > >  > > @@ -43,13 +43,20 @@ int ovl_setattr(struct dentry *dentry, struct=
 iattr *attr)
 > >  > >         if (!full_copy_up)
 > >  > >                 err =3D ovl_copy_up(dentry);
 > >  > >         else
 > >  > > -               err =3D ovl_copy_up_with_data(dentry);
 > >  > > +               err =3D ovl_copy_up_with_data(dentry, attr->ia_si=
ze);
 > >  >
 > >  > You do not know that ia_size is valid here.
 > >
 > > I think we don't have to worry about validation of ia_size here,
 > > vfs layer has already done simple check for specified size and upper f=
s
 > > will return error when we set invalid file size after copy-up. Am I mi=
ssing
 > > something?
 > >
 >=20
 > ovl_setattr() will be called from any number of places where ia_size has
 > uninitialized value, such as vfs_utimes().
 >=20
 > You are not allowed to access it without checking
 > (attr->ia_valid & ATTR_SIZE) which here above you don't.
 >=20

Currently, (attr->ia_valid & ATTR_SIZE) is equal to var full_copy_up,
so the size will be valid in this case.

 > >
 > >  > Instead of using this if/else and full_copy_up var, use vars 'flags=
'
 > >  > and 'size' and call ovl_copy_up_flags().
 > >  > Instead of full_copy_up =3D true, set flags and size.
 > >  > Then you may also remove ovl_copy_up_with_data() which has no other
 > >  > callers.
 > >  >
 > >  > >         if (!err) {
 > >  > >                 struct inode *winode =3D NULL;
 > >  > >
 > >  > >                 upperdentry =3D ovl_dentry_upper(dentry);
 > >  > >
 > >  > >                 if (attr->ia_valid & ATTR_SIZE) {
 > >  > > +                       if (full_copy_up && !(attr->ia_valid & ~A=
TTR_SIZE)) {
 > >  > > +                               inode_lock(upperdentry->d_inode);
 > >  > > +                               ovl_copyattr(upperdentry->d_inode=
, dentry->d_inode);
 > >  > > +                               inode_unlock(upperdentry->d_inode=
);
 > >  >
 > >  > All that this is saving is an extra notify_change() call and I am n=
ot sure it is
 > >  > worth the special casing.
 > >  >
 > >  > Also, I think that is a bug and would make xfstest overlay/013 fail=
.
 > >
 > > I ran testcases in overlay directory and didn't find failure related t=
o this change.
 > > However, generic/313 failed unexpectedly, the reason is I used full_co=
py_up var
 > > wrongly, for the file which has upper still needs to go through notify=
_change().
 > >
 > > By the way, I don't fully understand calling copy-up function(ovl_copy=
_up() or ovl_copy_up_with_data())
 > > even for the file which has upper. Maybe it's better to optimize this =
part first in separated patch.
 > >
 >=20
 > There is a difference between "has upper" and "has upper data".
 > It's related to metacopy.
 >=20

I see, my point here is we can skip calling copy-up function for files whic=
h already have upper data.



 > >
 > >  > When lower file is being executed, its true that we copy up anyway
 > >  > and that it is safe to do that, but test and applications expect to=
 get
 > >  > ETXTBSY error all the same.
 > >
 > > Actually we have already do the check and return ETXTBSY error, see be=
low.
 > >
 > > err =3D -ETXTBSY;
 > > if (atomic_read(&realinode->i_writecount) < 0)
 > >         goto out_drop_write;
 > >
 >=20
 > Yes, my point exactly. Your code does goto out_drop_write; before that c=
heck
 > so it will skip it.
 >=20

No, if you look at the code more closely , you'll find the goto in my code =
is actually after the check, :-).

Thanks,
Chengguang


=20
