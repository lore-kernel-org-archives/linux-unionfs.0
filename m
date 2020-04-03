Return-Path: <SRS0=JwOv=5T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5653C2D0E8
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 06:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 455122073B
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 06:39:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="OqoF7ED8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbgDCGjk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 02:39:40 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25326 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730550AbgDCGjj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Apr 2020 02:39:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1585895910;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=LWTu2tonZ+eJ0Z4YeMZ7Qq/5RyeByX80Iqqqn0QRBvU=;
        b=OqoF7ED8NUUyB6T3yByYO+gd5oAaKFrtNoXC+JwbLY+vEQoVVQH5JQjzugzC+IWn
        RreSceA1u6mVw3ZQFHDLs5L6b34egR/XRcZLQaHWmlJtHEFW/twepfQ5BG3/EDMcEOm
        9m66NoMR3mHkF8VD1s54CRLyg9Pl9hUZp4yB0Esc=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1585895907558465.9574851266344; Fri, 3 Apr 2020 14:38:27 +0800 (CST)
Date:   Fri, 03 Apr 2020 14:38:27 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>,
        "Hou Tao" <houtao1@huawei.com>, "cgxu519" <cgxu519@mykernel.net>
Message-ID: <1713ec320e1.f990d9b035470.9003463355312118650@mykernel.net>
In-Reply-To: <CAOQ4uxhwNpz-83xeTmDBvP7WtL=OXvjLH_gnUQ548PKj7=rvtw@mail.gmail.com>
References: <20200402085808.17695-1-cgxu519@mykernel.net> <CAOQ4uxhwNpz-83xeTmDBvP7WtL=OXvjLH_gnUQ548PKj7=rvtw@mail.gmail.com>
Subject: Re: [PATCH] ovl: sharing inode with different whiteout files
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Priority: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-04-03 10:46:52 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Thu, Apr 2, 2020 at 11:58 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > Sharing inode with different whiteout files for saving
 > > inode and speeding up delete opration.
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > ---
 > >
 > > Hi Miklos, Amir
 > >
 > > This is another inode sharing approach for whiteout files compare
 > > to Tao's previous patch. I didn't receive feedback from Tao for
 > > further update and this new approach seems more simple and reliable.
 > > Could you have a look at this patch?
 > >
 >=20
 > I like the simplification, but there are some parts of Tao's patch you
 > removed without understanding they need to be restored.
 >=20
 > The main think you missed is that it is not safe to protect ofs->whiteou=
t
 > with i_mutex on workdir, because workdir in ovl_whiteout() can be
 > one of 2 directories.
 > This is the point were the discussion on V3 got derailed.
 >=20
 > I will try to work on a patch unifying index/work dirs to solve this
 > problem, so you won't need to change anything in your patch,
 > but it will depend on this prerequisite.
 > As alternative, if you do not wish to wait for my patch,
 > please see the check for (workdir =3D=3D ofs->workdir) in Tao's patch.
 >=20

Hi Amir,

Thanks for your review, the check is quite simple so I will add the check i=
n V2
and we can remove it after your patch get merged. I will also fix all  nits=
 below
in V2.

Thanks,
cgxu


 > More below...
 >=20
 > >
 > >  fs/overlayfs/dir.c       | 53 ++++++++++++++++++++++++++++++++++-----=
-
 > >  fs/overlayfs/overlayfs.h |  2 +-
 > >  fs/overlayfs/ovl_entry.h |  2 ++
 > >  fs/overlayfs/readdir.c   |  3 ++-
 > >  fs/overlayfs/super.c     |  3 +++
 > >  fs/overlayfs/util.c      |  3 ++-
 > >  6 files changed, 56 insertions(+), 10 deletions(-)
 > >
 > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
 > > index 279009dee366..d5c2e1ada624 100644
 > > --- a/fs/overlayfs/dir.c
 > > +++ b/fs/overlayfs/dir.c
 > > @@ -61,36 +61,74 @@ struct dentry *ovl_lookup_temp(struct dentry *work=
dir)
 > >         return temp;
 > >  }
 > >
 > > +const unsigned int ovl_whiteout_link_max =3D 60000;
 >=20
 > Please keep this a module param as in V3.
 > A module param is also a way to disable whiteout linking
 > if for some reason it causes problems.
 >=20
 > > +
 > > +static bool ovl_whiteout_linkable(struct dentry *dentry)
 > > +{
 > > +       unsigned int max;
 > > +
 > > +       max =3D min_not_zero(dentry->d_sb->s_max_links, ovl_whiteout_l=
ink_max);
 > > +       if (dentry->d_inode->i_nlink >=3D max)
 > > +               return false;
 > > +       return true;
 >=20
 > return (dentry->d_inode->i_nlink < max);
 >=20
 > > +}
 > > +
 > >  /* caller holds i_mutex on workdir */
 > > -static struct dentry *ovl_whiteout(struct dentry *workdir)
 > > +static struct dentry *ovl_whiteout(struct dentry *workdir, struct ovl=
_fs *ofs)
 >=20
 > Please keep ofs argument first as per convention.
 >=20
 > >  {
 > >         int err;
 > > +       bool again =3D true;
 >=20
 > bool again =3D (ovl_whiteout_link_max > 1);
 >=20
 > assuming that it is changed to a module param.
 >=20
 > >         struct dentry *whiteout;
 > >         struct inode *wdir =3D workdir->d_inode;
 > >
 > > +retry:
 > >         whiteout =3D ovl_lookup_temp(workdir);
 > >         if (IS_ERR(whiteout))
 > >                 return whiteout;
 > >
 > > +
 > > +       if (ofs->whiteout) {
 > > +               if (ovl_whiteout_linkable(ofs->whiteout)) {
 > > +                       err =3D ovl_do_link(ofs->whiteout, wdir, white=
out);
 > > +                       if (!err)
 > > +                               return whiteout;
 > > +
 > > +                       if (!again)
 > > +                               goto out;
 > > +               }
 > > +
 > > +               err =3D ovl_do_unlink(ofs->workdir->d_inode, ofs->whit=
eout);
 >=20
 > use 'wdir'
 >=20
 > > +               ofs->whiteout =3D NULL;
 >=20
 > dput(ofs->whiteout); before reset
 >=20
 > > +               if (err)
 > > +                       goto out;
 > > +       }
 > > +
 > >         err =3D ovl_do_whiteout(wdir, whiteout);
 > > -       if (err) {
 > > -               dput(whiteout);
 > > -               whiteout =3D ERR_PTR(err);
 > > +       if (!err) {
 > > +               ofs->whiteout =3D whiteout;
 >=20
 > only set ofs->whiteout if (again) and get a reference.
 > otherwise return the whiteout.
 >=20
 > > +               if (again) {
 > > +                       again =3D false;
 >=20
 > dget(whiteout);
 >=20
 > > +                       goto retry;
 > > +               }
 > > +               return ERR_PTR(-EIO);
 >=20
 > Why fail? just return the whiteout.
 >=20
 > >         }
 > >
 > > +out:
 > > +       dput(whiteout);
 > > +       whiteout =3D ERR_PTR(err);
 > >         return whiteout;
 >=20
 > return ERR_PTR(err);
 >=20
 >=20
 > >  }
 > >
 > >  /* Caller must hold i_mutex on both workdir and dir */
 > >  int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *di=
r,
 > > -                            struct dentry *dentry)
 > > +                            struct dentry *dentry, struct ovl_fs *ofs=
)
 >=20
 > ofs arg first
 >=20
 > >  {
 > >         struct inode *wdir =3D workdir->d_inode;
 > >         struct dentry *whiteout;
 > >         int err;
 > >         int flags =3D 0;
 > >
 > > -       whiteout =3D ovl_whiteout(workdir);
 > > +       whiteout =3D ovl_whiteout(workdir, ofs);
 > >         err =3D PTR_ERR(whiteout);
 > >         if (IS_ERR(whiteout))
 > >                 return err;
 > > @@ -715,6 +753,7 @@ static bool ovl_matches_upper(struct dentry *dentr=
y, struct dentry *upper)
 > >  static int ovl_remove_and_whiteout(struct dentry *dentry,
 > >                                    struct list_head *list)
 > >  {
 > > +       struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
 > >         struct dentry *workdir =3D ovl_workdir(dentry);
 > >         struct dentry *upperdir =3D ovl_dentry_upper(dentry->d_parent)=
;
 > >         struct dentry *upper;
 > > @@ -748,7 +787,7 @@ static int ovl_remove_and_whiteout(struct dentry *=
dentry,
 > >                 goto out_dput_upper;
 > >         }
 > >
 > > -       err =3D ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), u=
pper);
 > > +       err =3D ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), u=
pper, ofs);
 > >         if (err)
 > >                 goto out_d_drop;
 > >
 > > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
 > > index e6f3670146ed..6212feef36c5 100644
 > > --- a/fs/overlayfs/overlayfs.h
 > > +++ b/fs/overlayfs/overlayfs.h
 > > @@ -456,7 +456,7 @@ static inline void ovl_copyflags(struct inode *fro=
m, struct inode *to)
 > >  /* dir.c */
 > >  extern const struct inode_operations ovl_dir_inode_operations;
 > >  int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *di=
r,
 > > -                            struct dentry *dentry);
 > > +                            struct dentry *dentry, struct ovl_fs *ofs=
);
 > >  struct ovl_cattr {
 > >         dev_t rdev;
 > >         umode_t mode;
 > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
 > > index 5762d802fe01..408aa6c7a3bd 100644
 > > --- a/fs/overlayfs/ovl_entry.h
 > > +++ b/fs/overlayfs/ovl_entry.h
 > > @@ -77,6 +77,8 @@ struct ovl_fs {
 > >         int xino_mode;
 > >         /* For allocation of non-persistent inode numbers */
 > >         atomic_long_t last_ino;
 > > +       /* Whiteout dentry cache */
 > > +       struct dentry *whiteout;
 > >  };
 > >
 > >  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
 > > index e452ff7d583d..0c8c7ff4fc9e 100644
 > > --- a/fs/overlayfs/readdir.c
 > > +++ b/fs/overlayfs/readdir.c
 > > @@ -1146,7 +1146,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 > >                          * Whiteout orphan index to block future open =
by
 > >                          * handle after overlay nlink dropped to zero.
 > >                          */
 > > -                       err =3D ovl_cleanup_and_whiteout(indexdir, dir=
, index);
 > > +                       err =3D ovl_cleanup_and_whiteout(indexdir, dir=
, index,
 > > +                                                      ofs);
 > >                 } else {
 > >                         /* Cleanup orphan index entries */
 > >                         err =3D ovl_cleanup(dir, index);
 > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
 > > index 732ad5495c92..fae9729ff018 100644
 > > --- a/fs/overlayfs/super.c
 > > +++ b/fs/overlayfs/super.c
 > > @@ -240,6 +240,9 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 > >         kfree(ofs->config.redirect_mode);
 > >         if (ofs->creator_cred)
 > >                 put_cred(ofs->creator_cred);
 > > +       if (ofs->whiteout)
 > > +               ovl_do_unlink(ofs->workdir->d_inode,
 > > +                          ofs->whiteout);
 >=20
 > You cannot and should not do that here.
 > It will be cleaned up on next mount.
 > You need here unconditional:
 > dputt(whiteout);
 >=20
 > Thanks,
 > Amir.
 >
