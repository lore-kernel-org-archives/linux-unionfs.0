Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE27AC77B78
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 May 2023 15:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjECPfq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 May 2023 11:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjECPfo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2023 11:35:44 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D42C1992
        for <linux-unionfs@vger.kernel.org>; Wed,  3 May 2023 08:35:42 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id a1e0cc1a2514c-77d46c7dd10so4166199241.0
        for <linux-unionfs@vger.kernel.org>; Wed, 03 May 2023 08:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683128141; x=1685720141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eDdE+Gc/e+EnGBc769I0+5NhdONv32vPZiBHfoU+7oc=;
        b=VeObm1f7Q5KMVPqi1BVO7/YAJ/40dOHI06OX7Ce23IV30jcfwnrbN3jemkIMIQPJz2
         8uxxEUe2oY/w6qVKH5TqXDRsOajESZetWlcVrVO7OtElkPiA9777C9gcbEReW/xb+J2h
         XVN2kN1UpBqPIQys2jkFr5K4p35i7ZJsA70BKuDrFzeT4iS6v+JjWv0XkBW192lNE5cR
         BZeSL7l3KouhpKLx+NIDYAn1yA2DmKxoNei+YP/Qi+GMFHnS97X7iGnBE6uY8IJlUifx
         eRObjq6JutTPwh8Qo6ZvNCO7IpbiVriNBPCFZSTev3FWM7p6dAGgy6xtvE1joKsKDAN1
         HVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683128141; x=1685720141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eDdE+Gc/e+EnGBc769I0+5NhdONv32vPZiBHfoU+7oc=;
        b=JhZpTDOBywwI94HypOD5L23ymt1H4dznwK4jfCNAjFeaEzrxV++MPWePJ22nhfejVC
         85clklRnLfG0nj560OT3K5rQCCuJQdd1ly523AVpTzvmtoquzVn2btZeLGxAECUeHXF+
         d3kZn54QS1uQIDVHeejVanViyDprdU3oKNfzin1brS0nwe9lC50jDiWNVIF1zexvDAwn
         ykMJ2I+dz+zmOvm5hLE5kIYHxJUv2OEK9/jDXUoxhTTlYgecLvzEkC8Z3WfQsyPB5R5F
         E3QbwiWFugY+PapOuYwbivBAloH6WkRdobP7JtTdXtlvfBGvesEYjoFiRdfVJEYOkdCH
         SiQA==
X-Gm-Message-State: AC+VfDxfhuBEyqjIgrTubr3B1+xDuYwvfZmJ679c+T+09UE994K+j45m
        yXR/l1a1WX/T6+ywBkVKpfXcGd/dSzoni4rirOY=
X-Google-Smtp-Source: ACHHUZ6ObWoETIdYjDgZ4QMcMJ3IRqxhJ5G4TlohBGDXIwI59Njn/vqJ1pc932Xtd/HrNK0DVKD2xoCYB4u9+P1KsBo=
X-Received: by 2002:a05:6102:32c2:b0:42e:4383:783d with SMTP id
 o2-20020a05610232c200b0042e4383783dmr1024967vss.3.1683128141311; Wed, 03 May
 2023 08:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
In-Reply-To: <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 3 May 2023 18:35:30 +0300
Message-ID: <CAOQ4uxj_DKVD2Hp6HpTWeJDb_w3V5q0WGieLLubWWEV7jZVnaQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 3, 2023 at 11:52=E2=80=AFAM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> When resolving lowerdata (lazily or non-lazily) we check the
> overlay.verity xattr on the metadata inode, and if set verify that the
> source lowerdata inode matches it (according to the verity options
> enabled).
>
> Note that this changes the location of the revert_creds() call
> in ovl_maybe_lookup_lowerdata() to ensure that we use the mounter creds
> during the call to ovl_validate_verity() for the possible file access in
> ovl_ensure_verity_loaded().
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>

As far as I can tell without knowing fsverity to well...

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/namei.c     | 42 +++++++++++++++++-
>  fs/overlayfs/overlayfs.h |  6 +++
>  fs/overlayfs/util.c      | 96 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 142 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 292b8a948f1a..d664ecc93e0f 100644
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
> @@ -915,9 +916,25 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dentry=
)
>
>         old_cred =3D ovl_override_creds(dentry->d_sb);
>         err =3D ovl_lookup_data_layers(dentry, redirect, &datapath);
> -       revert_creds(old_cred);
>         if (err)
> -               goto out_err;
> +               goto out_revert_creds;
> +
> +       if (ofs->config.verity) {
> +               struct path data =3D { .mnt =3D datapath.layer->mnt, .den=
try =3D datapath.dentry, };
> +               struct path metapath =3D {};
> +
> +               ovl_path_real(dentry, &metapath);
> +               if (!metapath.dentry) {
> +                       err =3D -EIO;
> +                       goto out_revert_creds;
> +               }
> +
> +               err =3D ovl_validate_verity(ofs, &metapath, &data);
> +               if (err)
> +                       goto out_revert_creds;
> +       }
> +
> +       revert_creds(old_cred);
>
>         err =3D ovl_dentry_set_lowerdata(dentry, &datapath);
>         if (err)
> @@ -929,6 +946,9 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
>
>         return err;
>
> + out_revert_creds:
> +       revert_creds(old_cred);
> +
>  out_err:
>         pr_warn_ratelimited("lazy lowerdata lookup failed (%pd2, err=3D%i=
)\n",
>                             dentry, err);
> @@ -1187,6 +1207,24 @@ struct dentry *ovl_lookup(struct inode *dir, struc=
t dentry *dentry,
>
>         ovl_stack_cpy(ovl_lowerstack(oe), stack, ctr);
>
> +       /* Validate verity of lower-data */
> +       if (ofs->config.verity &&
> +           !d.is_dir && (uppermetacopy || ctr > 1)) {
> +               struct path datapath;
> +
> +               ovl_e_path_lowerdata(oe, &datapath);
> +
> +               /* Is NULL for lazy lookup, will be verified later */
> +               if (datapath.dentry) {
> +                       struct path metapath;
> +
> +                       ovl_e_path_real(ofs, oe, upperdentry, &metapath);
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
> index a4867ff97115..07475eaae2ca 100644
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
> @@ -463,6 +464,11 @@ int ovl_lock_rename_workdir(struct dentry *workdir, =
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
> index 74077ef50bb3..ee296614bd73 100644
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
> @@ -720,6 +722,7 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, con=
st struct path *path,
>  #define OVL_XATTR_UPPER_POSTFIX                "upper"
>  #define OVL_XATTR_METACOPY_POSTFIX     "metacopy"
>  #define OVL_XATTR_PROTATTR_POSTFIX     "protattr"
> +#define OVL_XATTR_VERITY_POSTFIX       "verity"
>
>  #define OVL_XATTR_TAB_ENTRY(x) \
>         [x] =3D { [false] =3D OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
> @@ -734,6 +737,7 @@ const char *const ovl_xattr_table[][2] =3D {
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_UPPER),
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
> +       OVL_XATTR_TAB_ENTRY(OVL_XATTR_VERITY),
>  };
>
>  int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
> @@ -1166,6 +1170,98 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, c=
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
> +/* Call with mounter creds as it may open the file */
> +static int ovl_ensure_verity_loaded(struct path *datapath)
> +{
> +       struct inode *inode =3D d_inode(datapath->dentry);
> +       const struct fsverity_info *vi;
> +       struct file *filp;
> +
> +       vi =3D fsverity_get_info(inode);
> +       if (vi =3D=3D NULL && IS_VERITY(inode)) {
> +               /*
> +                * If this inode was not yet opened, the verity info hasn=
't been
> +                * loaded yet, so we need to do that here to force it int=
o memory.
> +                * We use open_with_fake_path to avoid ENFILE.
> +                */
> +               filp =3D open_with_fake_path(datapath, O_RDONLY, inode, c=
urrent_cred());
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
> +       u8 xattr_data[1+FS_VERITY_MAX_DIGEST_SIZE];
> +       u8 actual_digest[FS_VERITY_MAX_DIGEST_SIZE];
> +       enum hash_algo verity_algo;
> +       int xattr_len;
> +       int err;
> +
> +       if (!ofs->config.verity ||
> +           /* Verity only works on regular files */
> +           !S_ISREG(d_inode(metapath->dentry)->i_mode))
> +               return 0;
> +
> +       xattr_len =3D sizeof(xattr_data);
> +       err =3D ovl_get_verity_xattr(ofs, metapath, xattr_data, &xattr_le=
n);
> +       if (err =3D=3D -ENODATA) {
> +               if (ofs->config.require_verity) {
> +                       pr_warn_ratelimited("metacopy file '%pd' has no o=
verlay.verity xattr\n",
> +                                           metapath->dentry);
> +                       return -EIO;
> +               }
> +               return 0;
> +       }
> +       if (err < 0)
> +               return err;
> +
> +       err =3D ovl_ensure_verity_loaded(datapath);
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
> +       if (xattr_len !=3D 1 + hash_digest_size[verity_algo] ||
> +           xattr_data[0] !=3D (u8) verity_algo ||
> +           memcmp(xattr_data+1, actual_digest, xattr_len - 1) !=3D 0) {
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
