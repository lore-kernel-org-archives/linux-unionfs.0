Return-Path: <SRS0=6c+a=5X=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC6DC2BABC
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Apr 2020 09:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB523206F7
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Apr 2020 09:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="J5oci1Vq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgDGJJr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 05:09:47 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25341 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725817AbgDGJJr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Apr 2020 05:09:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586250497;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=Lmqqxrfe457LlgDbxvKMTQp/x00pkCcVp9tsVrSO3VE=;
        b=J5oci1VqbLfK2sA2tq9BAbRjMTc9PwXuTYfcj3LmUgc3bEWzEKgDvc5xn9sQrkOR
        cOp/0Y8+SfE12ytQ5X4NlPFEBK6xzFgLfHCi7WEee4pbSCrV32snOLkZ2Yi7JK+jb4k
        yTp+9cxatUz7TBlD1T/btcndEqB4QAVxL8jhZNMQ=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1586250495291446.4859767250815; Tue, 7 Apr 2020 17:08:15 +0800 (CST)
Date:   Tue, 07 Apr 2020 17:08:15 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>,
        "Hou Tao" <houtao1@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <17153e5b537.c827c90942921.7568518513045332175@mykernel.net>
In-Reply-To: <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
References: <20200403064444.31062-1-cgxu519@mykernel.net> <CAOQ4uxi8eMWRc6uuNt_R9nS9UjrOsqupcCEST4ub-kCwEpx=_Q@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: sharing inode with different whiteout files
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-04-03 17:18:06 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Fri, Apr 3, 2020 at 9:45 AM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
 > >
 > > Sharing inode with different whiteout files for saving
 > > inode and speeding up delete operation.
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 >=20
 > A few more nits.
 > Please wait with v3 until I fix my patches, so you can test in top of
 > them.
 > Please run the overlay xfstests to test your patch.
 >=20
 > I suspect this part of test overlay/031 will fail and will need to fix
 > the test to expect at most single whiteout 'residue' in work dir:
 >=20
 > # try to remove test dir from overlay dir, trigger ovl_remove_and_whiteo=
ut,
 > # it will not clean up the dir and lead to residue.
 > rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
 > ls $workdir/work

It seems no effect to current test case, I passed all test cases in overlay=
 dir
except nfs_export and mmap related cases.

=20
 >=20
 > And you should start writing a test.
 > I suggest setting /sys/module/overlay/parameters/whiteout_link_max to 2
 > (test should _not_run if param does not exist)
 > removing a bunch of files and verify after unmount that:
 > - whiteouts have nlink 2
 > - there is no more than single residue whiteout in work dir
 >=20

I=E2=80=98ll do.

 > > ---
 > >  fs/overlayfs/dir.c       | 50 ++++++++++++++++++++++++++++++++-------=
-
 > >  fs/overlayfs/overlayfs.h | 11 +++++++--
 > >  fs/overlayfs/ovl_entry.h |  4 ++++
 > >  fs/overlayfs/readdir.c   |  3 ++-
 > >  fs/overlayfs/super.c     | 10 ++++++++
 > >  fs/overlayfs/util.c      |  3 ++-
 > >  6 files changed, 68 insertions(+), 13 deletions(-)
 > >
 > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
 > > index 279009dee366..e48ba7de1bcb 100644
 > > --- a/fs/overlayfs/dir.c
 > > +++ b/fs/overlayfs/dir.c
 > > @@ -62,35 +62,66 @@ struct dentry *ovl_lookup_temp(struct dentry *work=
dir)
 > >  }
 > >
 > >  /* caller holds i_mutex on workdir */
 > > -static struct dentry *ovl_whiteout(struct dentry *workdir)
 > > +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry =
*workdir)
 > >  {
 > >         int err;
 > > +       bool same =3D true;
 >=20
 > 'same' is not the best name, but I expect you won't need it anyway.
 > I would replace this with:
 > bool should_link =3D (ofs->whiteout_link_max > 1);

I'll fix in V3.

 >=20
 > > +       bool again =3D true;
 > >         struct dentry *whiteout;
 > >         struct inode *wdir =3D workdir->d_inode;
 > >
 > > +       if (ofs->workdir !=3D workdir)
 > > +               same =3D false;
 > > +retry:
 > >         whiteout =3D ovl_lookup_temp(workdir);
 > >         if (IS_ERR(whiteout))
 > >                 return whiteout;
 > >
 > > +       if (same && ofs->whiteout) {
 > > +               if (ovl_whiteout_linkable(ofs, workdir, ofs->whiteout)=
) {
 > > +                       err =3D ovl_do_link(ofs->whiteout, wdir, white=
out);
 > > +                       if (!err)
 > > +                               return whiteout;
 > > +
 > > +                       if (!again)
 > > +                               goto out;
 > > +               }
 > > +
 >=20
 > We actually need to also cleanup this whiteout:
 >=20

I slightly changed the logic here and in this case it will be work just lik=
e before.

 > ovl_cleanup(wdir, ofs->whiteout);
 >=20
 > > +               dput(ofs->whiteout);
 > > +               ofs->whiteout =3D NULL;
 > > +       }
 > > +
 > >         err =3D ovl_do_whiteout(wdir, whiteout);
 > > -       if (err) {
 > > -               dput(whiteout);
 > > -               whiteout =3D ERR_PTR(err);
 > > +       if (!err) {
 >=20
 > save the nesting:
 > if (err)
 >     goto out;
 >=20

I'll fix in V3.

 > > +               if (!same || ofs->whiteout_link_max =3D=3D 1)
 > > +                       return whiteout;
 > > +
 > > +               if (!again) {
 > > +                       WARN_ON_ONCE(1);
 >=20
 > Definitely no WARN on this case.
 > We can consider setting whiteout_link_max to 0 and pr_warn()
 > about auto disabling whiteout linking due to unexpected failure.
 >=20

I'll fix in V3.

 > > +                       return whiteout;
 > > +               }
 > > +
 > > +               dget(whiteout);
 > > +               ofs->whiteout =3D whiteout;
 >=20
 > Shorter:
 >                ofs->whiteout =3D dget(whiteout);
 >=20

Here, we don't need to grab the dentry again, I think we have already got
the reference in lookup.


 > > +               again =3D false;
 > > +               goto retry;
 > >         }
 > >
 > > -       return whiteout;
 > > +out:
 > > +       dput(whiteout);
 > > +       return ERR_PTR(err);
 > >  }
 > >
 > >  /* Caller must hold i_mutex on both workdir and dir */
 > > -int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *di=
r,
 > > -                            struct dentry *dentry)
 > > +int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workd=
ir,
 > > +                            struct inode *dir, struct dentry *dentry)
 > >  {
 > >         struct inode *wdir =3D workdir->d_inode;
 > >         struct dentry *whiteout;
 > >         int err;
 > >         int flags =3D 0;
 > >
 > > -       whiteout =3D ovl_whiteout(workdir);
 > > +       whiteout =3D ovl_whiteout(ofs, workdir);
 > >         err =3D PTR_ERR(whiteout);
 > >         if (IS_ERR(whiteout))
 > >                 return err;
 > > @@ -715,6 +746,7 @@ static bool ovl_matches_upper(struct dentry *dentr=
y, struct dentry *upper)
 > >  static int ovl_remove_and_whiteout(struct dentry *dentry,
 > >                                    struct list_head *list)
 > >  {
 > > +       struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
 > >         struct dentry *workdir =3D ovl_workdir(dentry);
 > >         struct dentry *upperdir =3D ovl_dentry_upper(dentry->d_parent)=
;
 > >         struct dentry *upper;
 > > @@ -748,7 +780,7 @@ static int ovl_remove_and_whiteout(struct dentry *=
dentry,
 > >                 goto out_dput_upper;
 > >         }
 > >
 > > -       err =3D ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), u=
pper);
 > > +       err =3D ovl_cleanup_and_whiteout(ofs, workdir, d_inode(upperdi=
r), upper);
 > >         if (err)
 > >                 goto out_d_drop;
 > >
 > > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
 > > index e6f3670146ed..cc7bcc3fb916 100644
 > > --- a/fs/overlayfs/overlayfs.h
 > > +++ b/fs/overlayfs/overlayfs.h
 > > @@ -225,6 +225,13 @@ static inline bool ovl_open_flags_need_copy_up(in=
t flags)
 > >         return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)=
);
 > >  }
 > >
 > > +static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs,
 > > +                                        struct dentry *workdir,
 >=20
 > workdir unused.

I'll fix in V3.

 >=20
 > > +                                        struct dentry *dentry)
 > > +{
 > > +       return dentry->d_inode->i_nlink < ofs->whiteout_link_max;
 > > +}
 > > +
 > >  /* util.c */
 > >  int ovl_want_write(struct dentry *dentry);
 > >  void ovl_drop_write(struct dentry *dentry);
 > > @@ -455,8 +462,8 @@ static inline void ovl_copyflags(struct inode *fro=
m, struct inode *to)
 > >
 > >  /* dir.c */
 > >  extern const struct inode_operations ovl_dir_inode_operations;
 > > -int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *di=
r,
 > > -                            struct dentry *dentry);
 > > +int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workd=
ir,
 > > +                            struct inode *dir, struct dentry *dentry)=
;
 > >  struct ovl_cattr {
 > >         dev_t rdev;
 > >         umode_t mode;
 > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
 > > index 5762d802fe01..de5f230b6e6b 100644
 > > --- a/fs/overlayfs/ovl_entry.h
 > > +++ b/fs/overlayfs/ovl_entry.h
 > > @@ -77,6 +77,10 @@ struct ovl_fs {
 > >         int xino_mode;
 > >         /* For allocation of non-persistent inode numbers */
 > >         atomic_long_t last_ino;
 > > +       /* Whiteout dentry cache */
 > > +       struct dentry *whiteout;
 > > +       /* Whiteout max link count */
 > > +       unsigned int whiteout_link_max;
 > >  };
 > >
 > >  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
 > > index e452ff7d583d..1e921115e6aa 100644
 > > --- a/fs/overlayfs/readdir.c
 > > +++ b/fs/overlayfs/readdir.c
 > > @@ -1146,7 +1146,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 > >                          * Whiteout orphan index to block future open =
by
 > >                          * handle after overlay nlink dropped to zero.
 > >                          */
 > > -                       err =3D ovl_cleanup_and_whiteout(indexdir, dir=
, index);
 > > +                       err =3D ovl_cleanup_and_whiteout(ofs, indexdir=
, dir,
 > > +                                                      index);
 > >                 } else {
 > >                         /* Cleanup orphan index entries */
 > >                         err =3D ovl_cleanup(dir, index);
 > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
 > > index 732ad5495c92..340c4c05c410 100644
 > > --- a/fs/overlayfs/super.c
 > > +++ b/fs/overlayfs/super.c
 > > @@ -26,6 +26,10 @@ struct ovl_dir_cache;
 > >
 > >  #define OVL_MAX_STACK 500
 > >
 > > +static unsigned int ovl_whiteout_link_max_def =3D 60000;
 > > +module_param_named(whiteout_link_max, ovl_whiteout_link_max_def, uint=
, 0644);
 > > +MODULE_PARM_DESC(whiteout_link_max, "Maximum count of whiteout file l=
ink");
 > > +
 > >  static bool ovl_redirect_dir_def =3D IS_ENABLED(CONFIG_OVERLAY_FS_RED=
IRECT_DIR);
 > >  module_param_named(redirect_dir, ovl_redirect_dir_def, bool, 0644);
 > >  MODULE_PARM_DESC(redirect_dir,
 > > @@ -219,6 +223,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 > >         iput(ofs->upperdir_trap);
 > >         dput(ofs->indexdir);
 > >         dput(ofs->workdir);
 > > +       dput(ofs->whiteout);
 > >         if (ofs->workdir_locked)
 > >                 ovl_inuse_unlock(ofs->workbasedir);
 > >         dput(ofs->workbasedir);
 > > @@ -1762,6 +1767,11 @@ static int ovl_fill_super(struct super_block *s=
b, void *data, int silent)
 > >
 > >                 if (!ofs->workdir)
 > >                         sb->s_flags |=3D SB_RDONLY;
 > > +               else
 > > +                       ofs->whiteout_link_max =3D min_not_zero(
 > > +                                       ofs->workdir->d_sb->s_max_link=
s,
 > > +                                       ovl_whiteout_link_max_def ?
 > > +                                       ovl_whiteout_link_max_def : 1)=
;
 > >
 >=20
 > ovl_whiteout_link_max_def ?: 1);

I'll fix in V3.

Thanks,
cgxu


