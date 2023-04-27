Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE25C77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 07:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbjD0HeG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 03:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242667AbjD0HeE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 03:34:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64E2E7
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 00:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682580796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CkTJjHz8YvOq17cohFjEGQz6b6sMDd0/OeuVd05mpgg=;
        b=dBvKlLKEi6DAH1w02IX1xLD/mYzydA4Et0/Tj6vTpU9qxl34Wxv7jx+3hzRmxzI/lwiZAK
        8WncadtzEhJPSeFulO7/Vl7IqBnmQE6uNOhAG3ULNJjzUA4FJQoR8kQhaYCtMhQcIqdTt9
        gY3tkzTMFSTQOPj0evftJHEEjfhiI68=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-IeZ9O95cO7GzNNKRjxuBqw-1; Thu, 27 Apr 2023 03:33:14 -0400
X-MC-Unique: IeZ9O95cO7GzNNKRjxuBqw-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-32b65428489so60579065ab.1
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 00:33:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682580794; x=1685172794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CkTJjHz8YvOq17cohFjEGQz6b6sMDd0/OeuVd05mpgg=;
        b=W2dE3WlxUmRFDB6ImTjhzKIB3BSiGUSk2IzNnbvda6z65WAICeTkd1ELaZZJv2k2ZN
         FnvoGgTJ28ChHkYAKycaG5F+n56dSIPCuYB9NyND3gdKvq893HL18iRHhHNK8wwBG4Tw
         GCsD3fx0AQQbgJnLhfVzdDYeqHKNnc+4mmKdLwG+mskcXwVrsg/JQyYQG8NWfLwwaPuv
         SzuwYXhlS1U3n7OU0J1Qjfh5NSsVV5C58EQXgJV8gt1lBe/60ucWDQHlsf/cQ85ZX+Yl
         rCcD2pWe3fP5JKR82RMw0NWM8rV4zSoVZWRqt7mrZ1ZECr7jhDCc/ACOoud1Fd7uS4pA
         YjJQ==
X-Gm-Message-State: AC+VfDwuL2TdeRYHnZXybdsVaFsG52FDAeJN0MDS4ZbrZkSftw5Kl+IF
        BohexQGo5nnpaq3AIgwVffzlz7j3F/ZFR3/7bjCAPmnSRBVEJWUp5BHPYbFW5WC/agO83hrr0AT
        OmHwon9WELf+rggPfVEX0Lm/7oI7JMrIbMJN1Rgz0BTXZtTMMZw==
X-Received: by 2002:a92:d38a:0:b0:32c:8bb7:75bd with SMTP id o10-20020a92d38a000000b0032c8bb775bdmr642224ilo.29.1682580793816;
        Thu, 27 Apr 2023 00:33:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4djPr8NhTvBqL2kv5aXsbtiw8WwZfOF7xk+FAnM77KRv/ak+ZOYOJKhpLl/JWDwhajgGrLcaSGK1/o69a9lc8=
X-Received: by 2002:a92:d38a:0:b0:32c:8bb7:75bd with SMTP id
 o10-20020a92d38a000000b0032c8bb775bdmr642215ilo.29.1682580793501; Thu, 27 Apr
 2023 00:33:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681917551.git.alexl@redhat.com> <df41e9dc96ddad9f9e1e684e39c28f4e097e9d9b.1681917551.git.alexl@redhat.com>
 <CAOQ4uxgdX-bphreqvO9UZXHa5vdP_weyK0aqAgSY-BuhwU1ZJA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgdX-bphreqvO9UZXHa5vdP_weyK0aqAgSY-BuhwU1ZJA@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 27 Apr 2023 09:33:02 +0200
Message-ID: <CAL7ro1GpSUGo_ZcQNpstfzcxeX4husUnazYWPBGs3c+FLtx+sw@mail.gmail.com>
Subject: Re: [PATCH 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 20, 2023 at 2:06=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> ovl_maybe_lookup_lowerdata
>
> On Thu, Apr 20, 2023 at 10:44=E2=80=AFAM Alexander Larsson <alexl@redhat.=
com> wrote:
> >
> > When resolving lowerdata (lazily or non-lazily) we chech the
> > overlay.verity xattr on the metadata inode, and if set verify that the
> > source lowerdata inode matches it (according to the verity options
> > enabled).
> >
> > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > ---
> >  fs/overlayfs/namei.c     | 34 ++++++++++++++
> >  fs/overlayfs/overlayfs.h |  6 +++
> >  fs/overlayfs/util.c      | 97 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 137 insertions(+)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index ba2b156162ca..49f3715c582d 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -892,6 +892,7 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struc=
t dentry *dentry,
> >  /* Lazy lookup of lowerdata */
> >  int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
> >  {
> > +       struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
> >         struct inode *inode =3D d_inode(dentry);
> >         const char *redirect =3D ovl_lowerdata_redirect(inode);
> >         struct ovl_path datapath =3D {};
> > @@ -919,6 +920,21 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dent=
ry)
> >         if (err)
> >                 goto out_err;
> >
> > +       if (ofs->config.verity_validate) {
> > +               struct path data =3D { .mnt =3D datapath.layer->mnt, .d=
entry =3D datapath.dentry, };
> > +               struct path metapath =3D {};
> > +
> > +               ovl_path_real(dentry, &metapath);
> > +               if (!metapath.dentry) {
> > +                       err =3D -EIO;
> > +                       goto out_err;
> > +               }
> > +
> > +               err =3D ovl_validate_verity(ofs, &metapath, &data);
> > +               if (err)
> > +                       goto out_err;
> > +       }
> > +
> >         err =3D ovl_dentry_set_lowerdata(dentry, &datapath);
> >         if (err)
> >                 goto out_err;
> > @@ -1186,6 +1202,24 @@ struct dentry *ovl_lookup(struct inode *dir, str=
uct dentry *dentry,
> >         if (err)
> >                 goto out_put;
> >
> > +       /* Validate verity of lower-data */
> > +       if (ofs->config.verity_validate &&
> > +           !d.is_dir && (uppermetacopy || ctr > 1)) {
> > +               struct path datapath;
> > +
> > +               ovl_entry_path_lowerdata(&oe, &datapath);
> > +
> > +               /* Is NULL for lazy lookup, will be verified later */
> > +               if (datapath.dentry) {
> > +                       struct path metapath;
> > +
> > +                       ovl_entry_path_real(ofs, &oe, upperdentry, &met=
apath);
> > +                       err =3D ovl_validate_verity(ofs, &metapath, &da=
tapath);
> > +                       if (err < 0)
> > +                               goto out_free_oe;
> > +               }
> > +       }
> > +
> >         if (upperopaque)
> >                 ovl_dentry_set_opaque(dentry);
> >
> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > index 3d14770dc711..b1d639ccd5ac 100644
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -38,6 +38,7 @@ enum ovl_xattr {
> >         OVL_XATTR_UPPER,
> >         OVL_XATTR_METACOPY,
> >         OVL_XATTR_PROTATTR,
> > +       OVL_XATTR_VERITY,
> >  };
> >
> >  enum ovl_inode_flag {
> > @@ -467,6 +468,11 @@ int ovl_lock_rename_workdir(struct dentry *workdir=
, struct dentry *upperdir);
> >  int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *pa=
th);
> >  bool ovl_is_metacopy_dentry(struct dentry *dentry);
> >  char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *pa=
th, int padding);
> > +int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
> > +                        u8 *digest_buf, int *buf_length);
> > +int ovl_validate_verity(struct ovl_fs *ofs,
> > +                       struct path *metapath,
> > +                       struct path *datapath);
> >  int ovl_sync_status(struct ovl_fs *ofs);
> >
> >  static inline void ovl_set_flag(unsigned long flag, struct inode *inod=
e)
> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > index 17eff3e31239..55e90aa0978a 100644
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -10,7 +10,9 @@
> >  #include <linux/cred.h>
> >  #include <linux/xattr.h>
> >  #include <linux/exportfs.h>
> > +#include <linux/file.h>
> >  #include <linux/fileattr.h>
> > +#include <linux/fsverity.h>
> >  #include <linux/uuid.h>
> >  #include <linux/namei.h>
> >  #include <linux/ratelimit.h>
> > @@ -742,6 +744,7 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, c=
onst struct path *path,
> >  #define OVL_XATTR_UPPER_POSTFIX                "upper"
> >  #define OVL_XATTR_METACOPY_POSTFIX     "metacopy"
> >  #define OVL_XATTR_PROTATTR_POSTFIX     "protattr"
> > +#define OVL_XATTR_VERITY_POSTFIX       "verity"
> >
> >  #define OVL_XATTR_TAB_ENTRY(x) \
> >         [x] =3D { [false] =3D OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
> > @@ -756,6 +759,7 @@ const char *const ovl_xattr_table[][2] =3D {
> >         OVL_XATTR_TAB_ENTRY(OVL_XATTR_UPPER),
> >         OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
> >         OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
> > +       OVL_XATTR_TAB_ENTRY(OVL_XATTR_VERITY),
> >  };
> >
> >  int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
> > @@ -1188,6 +1192,99 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs,=
 const struct path *path, int pa
> >         return ERR_PTR(res);
> >  }
> >
> > +int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
> > +                        u8 *digest_buf, int *buf_length)
> > +{
> > +       int res;
> > +
> > +       res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_VERITY, digest_b=
uf, *buf_length);
> > +       if (res =3D=3D -ENODATA || res =3D=3D -EOPNOTSUPP)
> > +               return -ENODATA;
> > +       if (res < 0) {
> > +               pr_warn_ratelimited("failed to get digest (%i)\n", res)=
;
> > +               return res;
> > +       }
> > +
> > +       *buf_length =3D res;
> > +       return 0;
> > +}
> > +
> > +static int ovl_ensure_verity_loaded(struct ovl_fs *ofs,
> > +                                   struct path *datapath)
> > +{
> > +       struct inode *inode =3D d_inode(datapath->dentry);
> > +       const struct fsverity_info *vi;
> > +       const struct cred *old_cred;
> > +       struct file *filp;
> > +
> > +       vi =3D fsverity_get_info(inode);
> > +       if (vi =3D=3D NULL && IS_VERITY(inode)) {
> > +               /*
> > +                * If this inode was not yet opened, the verity info ha=
sn't been
> > +                * loaded yet, so we need to do that here to force it i=
nto memory.
> > +                */
> > +               old_cred =3D override_creds(ofs->creator_cred);
>
> Even though it may work, that's the wrong place for override_creds(),
> because you are calling this helper from within ovl_lookup() with
> mounter creds already.
>
> Better to move revert_creds() in ovl_maybe_lookup_lowerdata()
> to out_revert_creds: goto label and call ovl_validate_verity() with
> mounter creds from all call sites.

I'll do that. Although In practice I wonder how much this matters
anyway, because we're not using the result of the open, other than the
side affect of the first open loading the fs-verity info into the
inode.

> > +               filp =3D dentry_open(datapath, O_RDONLY, current_cred()=
);
>
> You could use open_with_fake_path() here to avoid ENFILE
> not sure if this is critical.
>
> > +               revert_creds(old_cred);
> > +               if (IS_ERR(filp))
> > +                       return PTR_ERR(filp);
> > +               fput(filp);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +int ovl_validate_verity(struct ovl_fs *ofs,
> > +                       struct path *metapath,
> > +                       struct path *datapath)
> > +{
> > +       u8 required_digest[FS_VERITY_MAX_DIGEST_SIZE];
> > +       u8 actual_digest[FS_VERITY_MAX_DIGEST_SIZE];
> > +       enum hash_algo verity_algo;
> > +       int digest_len;
> > +       int err;
> > +
> > +       if (!ofs->config.verity_validate ||
> > +           /* Verity only works on regular files */
> > +           !S_ISREG(d_inode(metapath->dentry)->i_mode))
> > +               return 0;
> > +
> > +       digest_len =3D sizeof(required_digest);
> > +       err =3D ovl_get_verity_xattr(ofs, metapath, required_digest, &d=
igest_len);
> > +       if (err =3D=3D -ENODATA) {
> > +               if (ofs->config.verity_require) {
> > +                       pr_warn_ratelimited("metacopy file '%pd' has no=
 overlay.verity xattr\n",
> > +                                           metapath->dentry);
> > +                       return -EIO;
> > +               }
> > +               return 0;
> > +       }
>
> Thinking out loud: feels to me that verity xattr is a property that is
> always "coupled" with metacopy xattr.
>
> I wonder if we should check and store them together during lookup.
>
> On one hand that means using a bit more memory per inode
> before we need it.
>
> OTOH, getxattr on metapath during lazy lookup may incur extra
> IO to the metapath inode xattr block that will have been amortized
> if done during lookup.
>
> I have no strong feelings one way or the other.

Currently the metacopy xattrs content is not used. We only check
whether it exists or not. In theory we could extend it to also store
the verity digest itself. Then you only need one lookup. Having
non-zero size metacopy attrs seems to be backwards compatible given
current code.

But, as you say, then we would need to store the digest (which is not
small) for later use. We would have to increase inode size by a
pointer, and then temporarily store the allocated space for the digest
until lazy lookup happens.

> Thanks,
> Amir.
>
> > +       if (err < 0)
> > +               return err;
> > +
> > +       err =3D ovl_ensure_verity_loaded(ofs, datapath);
> > +       if (err < 0) {
> > +               pr_warn_ratelimited("lower file '%pd' failed to load fs=
-verity info\n",
> > +                                   datapath->dentry);
> > +               return -EIO;
> > +       }
> > +
> > +       err =3D fsverity_get_digest(d_inode(datapath->dentry), actual_d=
igest, &verity_algo);
> > +       if (err < 0) {
> > +               pr_warn_ratelimited("lower file '%pd' has no fs-verity =
digest\n", datapath->dentry);
> > +               return -EIO;
> > +       }
> > +
> > +       if (digest_len !=3D hash_digest_size[verity_algo] ||
> > +           memcmp(required_digest, actual_digest, digest_len) !=3D 0) =
{
> > +               pr_warn_ratelimited("lower file '%pd' has the wrong fs-=
verity digest\n",
> > +                                   datapath->dentry);
> > +               return -EIO;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> >  /*
> >   * ovl_sync_status() - Check fs sync status for volatile mounts
> >   *
> > --
> > 2.39.2
> >
>


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

