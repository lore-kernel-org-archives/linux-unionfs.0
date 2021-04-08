Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A4BC433B4
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 13:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A45161107
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 13:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhDHNY1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 09:24:27 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25321 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229837AbhDHNY0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Apr 2021 09:24:26 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617888233; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=YMERWeBndodPFAeCxTvprdrn/CSu9C45Eo8Pat5rxSImxKbu1QRYWWMDZNauh83Q2SnHdTTBYSjislQgKG+SXYIA2XogHlhlBQqWoZBQlXgAghVOjQVndaWaQdIwVeO39iuM8LFE25Mn3jSDOSzv2uzS9DokLoMl722brSAxLJ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617888233; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=t7XXCi9ijYlqmrNYb7lAPbLLGu6WkdPQOP3zdRwxd7I=; 
        b=Zu3+hcPUpJvV5RXyLNwWaux6EAbTq3RLVgVLZZscAKxcyu5nBSgKnIQelBUUiTTTpfi0UK/6hELPUgirIhSRYWYpV6zrb2GVWZ1HDe/WPZH4cguh0kGGt69VIkOJkbBoHFEqmD7vJnkTQH2DY92KvLLzco1VjWKQgNfI1eDupjc=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617888233;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=t7XXCi9ijYlqmrNYb7lAPbLLGu6WkdPQOP3zdRwxd7I=;
        b=U4qgOM2kN0iB4sE8AficCDM6H/H+AgMM8m3ixNl+8GUEiQF5pPwBcTRgs68ZlDnw
        JQ1LzODfmS5qXw28aXz9r/lAu9d4fsRQ7/ctiShm7VC/2OeXfsDkdWoBHNxWJhRf0It
        qC81AEgUIIj7hBM2gDWYBbliAA5lsdhnXHHOWmQM=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 161788823095139.482307091703206; Thu, 8 Apr 2021 21:23:50 +0800 (CST)
Date:   Thu, 08 Apr 2021 21:23:50 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <178b1a73e24.d39bf86c18637.6167819870142236772@mykernel.net>
In-Reply-To: <CAOQ4uxg2Rydq1kx-rqguvC=bp4m80o7Yzy5r+HK7sqxXAVtcdA@mail.gmail.com>
References: <20210406120245.1338326-1-cgxu519@mykernel.net> <20210406120245.1338326-3-cgxu519@mykernel.net> <CAOQ4uxg2Rydq1kx-rqguvC=bp4m80o7Yzy5r+HK7sqxXAVtcdA@mail.gmail.com>
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2021-04-07 15:52:15 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Wed, Apr 7, 2021 at 12:04 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > Currently truncate operation on the file which only has
 > > lower will copy-up whole lower file and calling truncate(2)
 > > on upper file. It is not efficient for the case which
 > > truncates to much smaller size than lower file. This patch
 > > tries to avoid unnecessary data copy and truncate operation
 > > after copy-up.
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > ---
 > >  fs/overlayfs/copy_up.c   | 18 +++++++++++-------
 > >  fs/overlayfs/inode.c     |  9 ++++++++-
 > >  fs/overlayfs/overlayfs.h |  2 +-
 > >  3 files changed, 20 insertions(+), 9 deletions(-)
 > >
 > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
 > > index a1a9a150405a..331cc32eac95 100644
 > > --- a/fs/overlayfs/copy_up.c
 > > +++ b/fs/overlayfs/copy_up.c
 > > @@ -874,7 +874,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_=
copy_up_ctx *c)
 > >  }
 > >
 > >  static int ovl_copy_up_one(struct dentry *parent, struct dentry *dent=
ry,
 > > -                          int flags)
 > > +                          int flags, loff_t size)
 > >  {
 > >         int err;
 > >         DEFINE_DELAYED_CALL(done);
 > > @@ -911,6 +911,8 @@ static int ovl_copy_up_one(struct dentry *parent, =
struct dentry *dentry,
 > >         /* maybe truncate regular file. this has no effect on dirs */
 > >         if (flags & O_TRUNC)
 > >                 ctx.stat.size =3D 0;
 > > +       if (size)
 > > +               ctx.stat.size =3D size;
 >=20
 > Not sure about this, but *maybe* instead we re-interpret O_TRUNC
 > internally as "either O_TRUNC or truncate()" and then:
 >          if (flags & O_TRUNC)
 >                  ctx.stat.size =3D size;
 >=20
 > It would simplify the logic in ovl_copy_up_with_data().
 > If you do that, put a comment to clarify that special meaning.
 >=20
 > >
 > >         if (S_ISLNK(ctx.stat.mode)) {
 > >                 ctx.link =3D vfs_get_link(ctx.lowerpath.dentry, &done)=
;
 > > @@ -937,7 +939,7 @@ static int ovl_copy_up_one(struct dentry *parent, =
struct dentry *dentry,
 > >         return err;
 > >  }
 > >
 > > -static int ovl_copy_up_flags(struct dentry *dentry, int flags)
 > > +static int ovl_copy_up_flags(struct dentry *dentry, int flags, loff_t=
 size)
 > >  {
 > >         int err =3D 0;
 > >         const struct cred *old_cred =3D ovl_override_creds(dentry->d_s=
b);
 > > @@ -970,7 +972,7 @@ static int ovl_copy_up_flags(struct dentry *dentry=
, int flags)
 > >                         next =3D parent;
 > >                 }
 > >
 > > -               err =3D ovl_copy_up_one(parent, next, flags);
 > > +               err =3D ovl_copy_up_one(parent, next, flags, size);
 > >
 > >                 dput(parent);
 > >                 dput(next);
 > > @@ -1002,7 +1004,7 @@ int ovl_maybe_copy_up(struct dentry *dentry, int=
 flags)
 > >         if (ovl_open_need_copy_up(dentry, flags)) {
 > >                 err =3D ovl_want_write(dentry);
 > >                 if (!err) {
 > > -                       err =3D ovl_copy_up_flags(dentry, flags);
 > > +                       err =3D ovl_copy_up_flags(dentry, flags, 0);
 > >                         ovl_drop_write(dentry);
 > >                 }
 > >         }
 > > @@ -1010,12 +1012,14 @@ int ovl_maybe_copy_up(struct dentry *dentry, i=
nt flags)
 > >         return err;
 > >  }
 > >
 > > -int ovl_copy_up_with_data(struct dentry *dentry)
 > > +int ovl_copy_up_with_data(struct dentry *dentry, loff_t size)
 > >  {
 > > -       return ovl_copy_up_flags(dentry, O_WRONLY);
 > > +       if (size)
 > > +               return ovl_copy_up_flags(dentry, O_WRONLY, size);
 > > +       return  ovl_copy_up_flags(dentry, O_TRUNC | O_WRONLY, 0);
 >=20
 > Best get rid of this helper and put this logic in ovl_setattr(). see bel=
ow.
 >=20
 > >  }
 > >
 > >  int ovl_copy_up(struct dentry *dentry)
 > >  {
 > > -       return ovl_copy_up_flags(dentry, 0);
 > > +       return ovl_copy_up_flags(dentry, 0, 0);
 > >  }
 > > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
 > > index cf41bcb664bc..92f274844947 100644
 > > --- a/fs/overlayfs/inode.c
 > > +++ b/fs/overlayfs/inode.c
 > > @@ -43,13 +43,20 @@ int ovl_setattr(struct dentry *dentry, struct iatt=
r *attr)
 > >         if (!full_copy_up)
 > >                 err =3D ovl_copy_up(dentry);
 > >         else
 > > -               err =3D ovl_copy_up_with_data(dentry);
 > > +               err =3D ovl_copy_up_with_data(dentry, attr->ia_size);
 >=20
 > You do not know that ia_size is valid here.

I think we don't have to worry about validation of ia_size here,
vfs layer has already done simple check for specified size and upper fs
will return error when we set invalid file size after copy-up. Am I missing
something?


 > Instead of using this if/else and full_copy_up var, use vars 'flags'
 > and 'size' and call ovl_copy_up_flags().
 > Instead of full_copy_up =3D true, set flags and size.
 > Then you may also remove ovl_copy_up_with_data() which has no other
 > callers.
 >=20
 > >         if (!err) {
 > >                 struct inode *winode =3D NULL;
 > >
 > >                 upperdentry =3D ovl_dentry_upper(dentry);
 > >
 > >                 if (attr->ia_valid & ATTR_SIZE) {
 > > +                       if (full_copy_up && !(attr->ia_valid & ~ATTR_S=
IZE)) {
 > > +                               inode_lock(upperdentry->d_inode);
 > > +                               ovl_copyattr(upperdentry->d_inode, den=
try->d_inode);
 > > +                               inode_unlock(upperdentry->d_inode);
 >=20
 > All that this is saving is an extra notify_change() call and I am not su=
re it is
 > worth the special casing.
 >=20
 > Also, I think that is a bug and would make xfstest overlay/013 fail.

I ran testcases in overlay directory and didn't find failure related to thi=
s change.
However, generic/313 failed unexpectedly, the reason is I used full_copy_up=
 var
wrongly, for the file which has upper still needs to go through notify_chan=
ge().

By the way, I don't fully understand calling copy-up function(ovl_copy_up()=
 or ovl_copy_up_with_data())
even for the file which has upper. Maybe it's better to optimize this part =
first in separated patch.


 > When lower file is being executed, its true that we copy up anyway
 > and that it is safe to do that, but test and applications expect to get
 > ETXTBSY error all the same.

Actually we have already do the check and return ETXTBSY error, see below.

err =3D -ETXTBSY;
if (atomic_read(&realinode->i_writecount) < 0)
        goto out_drop_write;


Thanks,
Chengguang

 >=20
 > Please run xfstests at least the generic/quick and overlay/quick groups
 > with -overlay.
 >=20
 > There are a lot of generic and overlay tests that do truncate(size), but=
 it's
 > hard to say if test coverage for your change is sufficient, so unless yo=
u find
 > tests that cover it, you may need to write a specialized overlay truncat=
e test.
 >=20
 > Thanks,
 > Amir.
 >=20
