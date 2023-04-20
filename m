Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3997EC77B72
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 12:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbjDTMGu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 08:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjDTMGt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 08:06:49 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C3530DF
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 05:06:48 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id q10so2031630uas.2
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 05:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681992407; x=1684584407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kh0Tza5X/hVCjLbJmuCvil/DeiezWINbTbkRvetbgJo=;
        b=eHbzaiAm7IDaoBrb1GnXIzGtlUgtJojdgwrEi43gEpCovyXDYKsUo0Bm9KQQk7wXu4
         BtLyI8ILuVsSnlaXojRUq9XG/3H7OGpkFdUz0YGmgyUBhArA8499688Kfpb5i+7BED6o
         FMx+DLzT4X93jGE/ATHd+ndu0VM9tNYM94Q9G3cwye+NlLuxA6JXP95zb9uBwjWGfh42
         YI9oXUwzuCpL62k3vFdz/IZsYfpBIQBc/867lOrlKGbMg3K4gghgs7hPf+BsE59Rsik/
         x/OdCgROXFcJHB3bYP5D6y2OEEBeP2WOWRaw8LUbyk8ZtMaAaBj8hHeH5xk/YYk2hKWA
         fBlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681992407; x=1684584407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kh0Tza5X/hVCjLbJmuCvil/DeiezWINbTbkRvetbgJo=;
        b=YJM8C/ODoa/z9wMCEHY7lqme9z5mkL89u9lKMVKxCoOavESiq/F6hBdossB6HTrxbL
         pTtp7hu9Y/OoabGDKCAd/kU6GgJgifuIRoyEHgEowfNpjaokKRja8iN3NCqQZ4/pCz5+
         2H4//q3Lmneci1cOvq6lwv3hdb9oe7h0RSUtXD3/Zau6uFQZ8Gm05uj6sO3f+7w4RWEr
         WYTO2LwbFC3aCi2yQO0Q2f2cye/SlEl9HjbsDD8chekkmvCv/+VeiZfuuXizcHB1i/3D
         ZFGj1o2eEIgex1GOU/F9mEqlhbD/evsl2MC4mneV1YGVp0AXTnveILKqUJWwfqsK/xUv
         1Zxw==
X-Gm-Message-State: AAQBX9dkVlEJMNZXa+BG8GLG2qKuWkyGLtMiA4zeU17YNh7yszxylWCQ
        FWZzri4G23/u/GcY5sIT+IcP26WZQmyOEC9yXyQ=
X-Google-Smtp-Source: AKy350aXH+zQ5TbHFj3ceJDIuZoxq9tPjYEx0lgX0Ip2DTpLgYdxXjPhjD+UywBm+4iLQD9Q2pjA9T7aX1MwOrnTpqg=
X-Received: by 2002:a1f:a994:0:b0:446:c76f:a7e5 with SMTP id
 s142-20020a1fa994000000b00446c76fa7e5mr842790vke.0.1681992407337; Thu, 20 Apr
 2023 05:06:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681917551.git.alexl@redhat.com> <df41e9dc96ddad9f9e1e684e39c28f4e097e9d9b.1681917551.git.alexl@redhat.com>
In-Reply-To: <df41e9dc96ddad9f9e1e684e39c28f4e097e9d9b.1681917551.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 20 Apr 2023 15:06:35 +0300
Message-ID: <CAOQ4uxgdX-bphreqvO9UZXHa5vdP_weyK0aqAgSY-BuhwU1ZJA@mail.gmail.com>
Subject: Re: [PATCH 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ovl_maybe_lookup_lowerdata

On Thu, Apr 20, 2023 at 10:44=E2=80=AFAM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> When resolving lowerdata (lazily or non-lazily) we chech the
> overlay.verity xattr on the metadata inode, and if set verify that the
> source lowerdata inode matches it (according to the verity options
> enabled).
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> ---
>  fs/overlayfs/namei.c     | 34 ++++++++++++++
>  fs/overlayfs/overlayfs.h |  6 +++
>  fs/overlayfs/util.c      | 97 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 137 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ba2b156162ca..49f3715c582d 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -892,6 +892,7 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct =
dentry *dentry,
>  /* Lazy lookup of lowerdata */
>  int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
>  {
> +       struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
>         struct inode *inode =3D d_inode(dentry);
>         const char *redirect =3D ovl_lowerdata_redirect(inode);
>         struct ovl_path datapath =3D {};
> @@ -919,6 +920,21 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dentry=
)
>         if (err)
>                 goto out_err;
>
> +       if (ofs->config.verity_validate) {
> +               struct path data =3D { .mnt =3D datapath.layer->mnt, .den=
try =3D datapath.dentry, };
> +               struct path metapath =3D {};
> +
> +               ovl_path_real(dentry, &metapath);
> +               if (!metapath.dentry) {
> +                       err =3D -EIO;
> +                       goto out_err;
> +               }
> +
> +               err =3D ovl_validate_verity(ofs, &metapath, &data);
> +               if (err)
> +                       goto out_err;
> +       }
> +
>         err =3D ovl_dentry_set_lowerdata(dentry, &datapath);
>         if (err)
>                 goto out_err;
> @@ -1186,6 +1202,24 @@ struct dentry *ovl_lookup(struct inode *dir, struc=
t dentry *dentry,
>         if (err)
>                 goto out_put;
>
> +       /* Validate verity of lower-data */
> +       if (ofs->config.verity_validate &&
> +           !d.is_dir && (uppermetacopy || ctr > 1)) {
> +               struct path datapath;
> +
> +               ovl_entry_path_lowerdata(&oe, &datapath);
> +
> +               /* Is NULL for lazy lookup, will be verified later */
> +               if (datapath.dentry) {
> +                       struct path metapath;
> +
> +                       ovl_entry_path_real(ofs, &oe, upperdentry, &metap=
ath);
> +                       err =3D ovl_validate_verity(ofs, &metapath, &data=
path);
> +                       if (err < 0)
> +                               goto out_free_oe;
> +               }
> +       }
> +
>         if (upperopaque)
>                 ovl_dentry_set_opaque(dentry);
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 3d14770dc711..b1d639ccd5ac 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -38,6 +38,7 @@ enum ovl_xattr {
>         OVL_XATTR_UPPER,
>         OVL_XATTR_METACOPY,
>         OVL_XATTR_PROTATTR,
> +       OVL_XATTR_VERITY,
>  };
>
>  enum ovl_inode_flag {
> @@ -467,6 +468,11 @@ int ovl_lock_rename_workdir(struct dentry *workdir, =
struct dentry *upperdir);
>  int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
);
>  bool ovl_is_metacopy_dentry(struct dentry *dentry);
>  char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path=
, int padding);
> +int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
> +                        u8 *digest_buf, int *buf_length);
> +int ovl_validate_verity(struct ovl_fs *ofs,
> +                       struct path *metapath,
> +                       struct path *datapath);
>  int ovl_sync_status(struct ovl_fs *ofs);
>
>  static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 17eff3e31239..55e90aa0978a 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -10,7 +10,9 @@
>  #include <linux/cred.h>
>  #include <linux/xattr.h>
>  #include <linux/exportfs.h>
> +#include <linux/file.h>
>  #include <linux/fileattr.h>
> +#include <linux/fsverity.h>
>  #include <linux/uuid.h>
>  #include <linux/namei.h>
>  #include <linux/ratelimit.h>
> @@ -742,6 +744,7 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, con=
st struct path *path,
>  #define OVL_XATTR_UPPER_POSTFIX                "upper"
>  #define OVL_XATTR_METACOPY_POSTFIX     "metacopy"
>  #define OVL_XATTR_PROTATTR_POSTFIX     "protattr"
> +#define OVL_XATTR_VERITY_POSTFIX       "verity"
>
>  #define OVL_XATTR_TAB_ENTRY(x) \
>         [x] =3D { [false] =3D OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
> @@ -756,6 +759,7 @@ const char *const ovl_xattr_table[][2] =3D {
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_UPPER),
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
> +       OVL_XATTR_TAB_ENTRY(OVL_XATTR_VERITY),
>  };
>
>  int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
> @@ -1188,6 +1192,99 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, c=
onst struct path *path, int pa
>         return ERR_PTR(res);
>  }
>
> +int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
> +                        u8 *digest_buf, int *buf_length)
> +{
> +       int res;
> +
> +       res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_VERITY, digest_buf=
, *buf_length);
> +       if (res =3D=3D -ENODATA || res =3D=3D -EOPNOTSUPP)
> +               return -ENODATA;
> +       if (res < 0) {
> +               pr_warn_ratelimited("failed to get digest (%i)\n", res);
> +               return res;
> +       }
> +
> +       *buf_length =3D res;
> +       return 0;
> +}
> +
> +static int ovl_ensure_verity_loaded(struct ovl_fs *ofs,
> +                                   struct path *datapath)
> +{
> +       struct inode *inode =3D d_inode(datapath->dentry);
> +       const struct fsverity_info *vi;
> +       const struct cred *old_cred;
> +       struct file *filp;
> +
> +       vi =3D fsverity_get_info(inode);
> +       if (vi =3D=3D NULL && IS_VERITY(inode)) {
> +               /*
> +                * If this inode was not yet opened, the verity info hasn=
't been
> +                * loaded yet, so we need to do that here to force it int=
o memory.
> +                */
> +               old_cred =3D override_creds(ofs->creator_cred);

Even though it may work, that's the wrong place for override_creds(),
because you are calling this helper from within ovl_lookup() with
mounter creds already.

Better to move revert_creds() in ovl_maybe_lookup_lowerdata()
to out_revert_creds: goto label and call ovl_validate_verity() with
mounter creds from all call sites.

> +               filp =3D dentry_open(datapath, O_RDONLY, current_cred());

You could use open_with_fake_path() here to avoid ENFILE
not sure if this is critical.

> +               revert_creds(old_cred);
> +               if (IS_ERR(filp))
> +                       return PTR_ERR(filp);
> +               fput(filp);
> +       }
> +
> +       return 0;
> +}
> +
> +int ovl_validate_verity(struct ovl_fs *ofs,
> +                       struct path *metapath,
> +                       struct path *datapath)
> +{
> +       u8 required_digest[FS_VERITY_MAX_DIGEST_SIZE];
> +       u8 actual_digest[FS_VERITY_MAX_DIGEST_SIZE];
> +       enum hash_algo verity_algo;
> +       int digest_len;
> +       int err;
> +
> +       if (!ofs->config.verity_validate ||
> +           /* Verity only works on regular files */
> +           !S_ISREG(d_inode(metapath->dentry)->i_mode))
> +               return 0;
> +
> +       digest_len =3D sizeof(required_digest);
> +       err =3D ovl_get_verity_xattr(ofs, metapath, required_digest, &dig=
est_len);
> +       if (err =3D=3D -ENODATA) {
> +               if (ofs->config.verity_require) {
> +                       pr_warn_ratelimited("metacopy file '%pd' has no o=
verlay.verity xattr\n",
> +                                           metapath->dentry);
> +                       return -EIO;
> +               }
> +               return 0;
> +       }

Thinking out loud: feels to me that verity xattr is a property that is
always "coupled" with metacopy xattr.

I wonder if we should check and store them together during lookup.

On one hand that means using a bit more memory per inode
before we need it.

OTOH, getxattr on metapath during lazy lookup may incur extra
IO to the metapath inode xattr block that will have been amortized
if done during lookup.

I have no strong feelings one way or the other.

Thanks,
Amir.

> +       if (err < 0)
> +               return err;
> +
> +       err =3D ovl_ensure_verity_loaded(ofs, datapath);
> +       if (err < 0) {
> +               pr_warn_ratelimited("lower file '%pd' failed to load fs-v=
erity info\n",
> +                                   datapath->dentry);
> +               return -EIO;
> +       }
> +
> +       err =3D fsverity_get_digest(d_inode(datapath->dentry), actual_dig=
est, &verity_algo);
> +       if (err < 0) {
> +               pr_warn_ratelimited("lower file '%pd' has no fs-verity di=
gest\n", datapath->dentry);
> +               return -EIO;
> +       }
> +
> +       if (digest_len !=3D hash_digest_size[verity_algo] ||
> +           memcmp(required_digest, actual_digest, digest_len) !=3D 0) {
> +               pr_warn_ratelimited("lower file '%pd' has the wrong fs-ve=
rity digest\n",
> +                                   datapath->dentry);
> +               return -EIO;
> +       }
> +
> +       return 0;
> +}
> +
>  /*
>   * ovl_sync_status() - Check fs sync status for volatile mounts
>   *
> --
> 2.39.2
>
