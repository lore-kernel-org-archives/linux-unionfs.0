Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4C5EB64D7
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jun 2023 12:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjFUMVs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 08:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjFUMVr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2023 08:21:47 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B884019A9
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 05:21:45 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a1e0cc1a2514c-786f7e1ea2fso1451946241.3
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 05:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687350105; x=1689942105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1+V4C/IU0l97HJrDEO45ienftPKECGYIkhtAg9fmJg=;
        b=Wvgr5gK5M6fBcDDun5ow5D2//MhFmg+09ZhY5N3Dt4nYPaqXRffJ1HGmkwTd08rbR2
         Kfby4YvDFXZJdD5YQ7aIvt69fvNo2tCDVdaUe0yKfftLawKxx37KBigshEsR6gRINBxw
         FVeYmZGcxE7PDUmT/GmG4h9FDo6Ba4p9mRMhzBPQ4EfuVZ9S9cfHEF0qNQvp/G9ACnJO
         t6xWoJvMqkhoZDonKt81DAhpoAzddXEtaUS/zgcuoO3xDBUuGGzr1/ynoi9uVf8wjB/x
         yJIAayuLMaD7U6KARMhntr9OopRg4mxLBITCT8M7RUV2oXt/S5/wl3QME9bM2d+x6vRi
         Tctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687350105; x=1689942105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1+V4C/IU0l97HJrDEO45ienftPKECGYIkhtAg9fmJg=;
        b=IUcyHc+oqVvMPIzIZHy7Vcr52BrPM24BrxGyMkzfGkGyJexz7Fo0nMS/nt/suZnAKm
         W05DEyPUqjPpgfyUhYQwY9Cpc//AwnD8HH7hwfrp4OqYVB59Fvv2yUNaeYBSxNmQVlhp
         RZEvo5qYjlYEdldeHZMXXLIbFXjnAafMcGMi3PzStkFJiLFDCEzPrnUqobzoEwHJJkvR
         FLVDow3/FtQ22kRPGP17UJXEqnNij3ML6+J4G31ZNTjzWy3NOlLu5MjgXVOoEDhm9C5u
         TmwOmmd22ZGbQwipsRKivgHl6/6xZkz5W33HphtMMt+NndUHN3Q0L/97fjLjn+RswARI
         BsTw==
X-Gm-Message-State: AC+VfDw1RqDAKcOLErTrK4BgRfiW6n06rxN/JfAokQIN6YdA1AItEpuH
        yaqjMyP7yHWOa0v/fzjuwumAj/rMGyNRz7manYA=
X-Google-Smtp-Source: ACHHUZ5HXqaFuMulS+aPnpdWQyJf1H4Aia2JYbfnfG4B9fYEnaOSwUMOeSX/Pqv6cvODPwe3aP8O5DdRyhuJ0ndAoeE=
X-Received: by 2002:a67:f444:0:b0:440:a548:82c9 with SMTP id
 r4-20020a67f444000000b00440a54882c9mr3797090vsn.12.1687350104721; Wed, 21 Jun
 2023 05:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687345663.git.alexl@redhat.com> <b7a2dfb80e35dda04edd942ad715dc88b784c218.1687345663.git.alexl@redhat.com>
In-Reply-To: <b7a2dfb80e35dda04edd942ad715dc88b784c218.1687345663.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Jun 2023 15:21:33 +0300
Message-ID: <CAOQ4uxh4z-AXtbegpACkAtTz+4=efPr_E1XKHyEd35BJikePbg@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] ovl: Add versioned header for overlay.metacopy xattr
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 21, 2023 at 2:18=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> Historically overlay.metacopy was a zero-size xattr, and it's
> existence marked a metacopy file. This change adds a versioned header
> with a flag field, a length and a digest. The initial use-case of this
> will be for validating a fs-verity digest, but the flags field could
> also be used later for other new features.
>
> ovl_check_metacopy_xattr() now returns the size of the xattr,
> emulating a size of OVL_METACOPY_MIN_SIZE for empty xattrs to
> distinguish it from the no-xattr case.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>

Looks good.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/namei.c     | 10 +++++-----
>  fs/overlayfs/overlayfs.h | 24 +++++++++++++++++++++++-
>  fs/overlayfs/util.c      | 37 +++++++++++++++++++++++++++++++++----
>  3 files changed, 61 insertions(+), 10 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 57adf911735f..3dd480253710 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -25,7 +25,7 @@ struct ovl_lookup_data {
>         bool stop;
>         bool last;
>         char *redirect;
> -       bool metacopy;
> +       int metacopy;
>         /* Referring to last redirect xattr */
>         bool absolute_redirect;
>  };
> @@ -270,7 +270,7 @@ static int ovl_lookup_single(struct dentry *base, str=
uct ovl_lookup_data *d,
>                         d->stop =3D true;
>                         goto put_and_out;
>                 }
> -               err =3D ovl_check_metacopy_xattr(OVL_FS(d->sb), &path);
> +               err =3D ovl_check_metacopy_xattr(OVL_FS(d->sb), &path, NU=
LL);
>                 if (err < 0)
>                         goto out_err;
>
> @@ -963,7 +963,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct d=
entry *dentry,
>                 .stop =3D false,
>                 .last =3D ovl_redirect_follow(ofs) ? false : !ovl_numlowe=
r(poe),
>                 .redirect =3D NULL,
> -               .metacopy =3D false,
> +               .metacopy =3D 0,
>         };
>
>         if (dentry->d_name.len > ofs->namelen)
> @@ -1120,7 +1120,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>
>         /* Defer lookup of lowerdata in data-only layers to first access =
*/
>         if (d.metacopy && ctr && ofs->numdatalayer && d.absolute_redirect=
) {
> -               d.metacopy =3D false;
> +               d.metacopy =3D 0;
>                 ctr++;
>         }
>
> @@ -1211,7 +1211,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>                         upperredirect =3D NULL;
>                         goto out_free_oe;
>                 }
> -               err =3D ovl_check_metacopy_xattr(ofs, &upperpath);
> +               err =3D ovl_check_metacopy_xattr(ofs, &upperpath, NULL);
>                 if (err < 0)
>                         goto out_free_oe;
>                 uppermetacopy =3D err;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index cf92a9aaf934..6d4e08df0dfe 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -7,6 +7,7 @@
>  #include <linux/kernel.h>
>  #include <linux/uuid.h>
>  #include <linux/fs.h>
> +#include <linux/fsverity.h>
>  #include <linux/namei.h>
>  #include <linux/posix_acl.h>
>  #include <linux/posix_acl_xattr.h>
> @@ -140,6 +141,26 @@ struct ovl_fh {
>  #define OVL_FH_FID_OFFSET      (OVL_FH_WIRE_OFFSET + \
>                                  offsetof(struct ovl_fb, fid))
>
> +/* On-disk format for "metacopy" xattr (if non-zero size) */
> +struct ovl_metacopy {
> +       u8 version;     /* 0 */
> +       u8 len;         /* size of this header + used digest bytes */
> +       u8 flags;
> +       u8 digest_algo; /* FS_VERITY_HASH_ALG_* constant, 0 for no digest=
 */
> +       u8 digest[FS_VERITY_MAX_DIGEST_SIZE];  /* Only the used part on d=
isk */
> +} __packed;
> +
> +#define OVL_METACOPY_MAX_SIZE (sizeof(struct ovl_metacopy))
> +#define OVL_METACOPY_MIN_SIZE (OVL_METACOPY_MAX_SIZE - FS_VERITY_MAX_DIG=
EST_SIZE)
> +#define OVL_METACOPY_INIT { 0, OVL_METACOPY_MIN_SIZE }
> +
> +static inline int ovl_metadata_digest_size(const struct ovl_metacopy *me=
tacopy)
> +{
> +       if (metacopy->len < OVL_METACOPY_MIN_SIZE)
> +               return 0;
> +       return (int)metacopy->len - OVL_METACOPY_MIN_SIZE;
> +}
> +
>  extern const char *const ovl_xattr_table[][2];
>  static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr o=
x)
>  {
> @@ -490,7 +511,8 @@ bool ovl_need_index(struct dentry *dentry);
>  int ovl_nlink_start(struct dentry *dentry);
>  void ovl_nlink_end(struct dentry *dentry);
>  int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upper=
dir);
> -int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
);
> +int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
,
> +                            struct ovl_metacopy *data);
>  bool ovl_is_metacopy_dentry(struct dentry *dentry);
>  char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path=
, int padding);
>  int ovl_sync_status(struct ovl_fs *ofs);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 7ef9e13c404a..921747223991 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -1054,8 +1054,12 @@ int ovl_lock_rename_workdir(struct dentry *workdir=
, struct dentry *upperdir)
>         return -EIO;
>  }
>
> -/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
> -int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
)
> +/*
> + * err < 0, 0 if no metacopy xattr, metacopy data size if xattr found.
> + * an empty xattr returns OVL_METACOPY_MIN_SIZE to distinguish from no x=
attr value.
> + */
> +int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
,
> +                            struct ovl_metacopy *data)
>  {
>         int res;
>
> @@ -1063,7 +1067,8 @@ int ovl_check_metacopy_xattr(struct ovl_fs *ofs, co=
nst struct path *path)
>         if (!S_ISREG(d_inode(path->dentry)->i_mode))
>                 return 0;
>
> -       res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_METACOPY, NULL, 0)=
;
> +       res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_METACOPY,
> +                               data, data ? OVL_METACOPY_MAX_SIZE : 0);
>         if (res < 0) {
>                 if (res =3D=3D -ENODATA || res =3D=3D -EOPNOTSUPP)
>                         return 0;
> @@ -1077,7 +1082,31 @@ int ovl_check_metacopy_xattr(struct ovl_fs *ofs, c=
onst struct path *path)
>                 goto out;
>         }
>
> -       return 1;
> +       if (res =3D=3D 0) {
> +               /* Emulate empty data for zero size metacopy xattr */
> +               res =3D OVL_METACOPY_MIN_SIZE;
> +               if (data) {
> +                       memset(data, 0, res);
> +                       data->len =3D res;
> +               }
> +       } else if (res < OVL_METACOPY_MIN_SIZE) {
> +               pr_warn_ratelimited("metacopy file '%pd' has too small xa=
ttr\n",
> +                                   path->dentry);
> +               return -EIO;
> +       } else if (data) {
> +               if (data->version !=3D 0) {
> +                       pr_warn_ratelimited("metacopy file '%pd' has unsu=
pported version\n",
> +                                           path->dentry);
> +                       return -EIO;
> +               }
> +               if (res !=3D data->len) {
> +                       pr_warn_ratelimited("metacopy file '%pd' has inva=
lid xattr size\n",
> +                                           path->dentry);
> +                       return -EIO;
> +               }
> +       }
> +
> +       return res;
>  out:
>         pr_warn_ratelimited("failed to get metacopy (%i)\n", res);
>         return res;
> --
> 2.40.1
>
