Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038DCC77B72
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 12:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbjDTMSM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 08:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbjDTMSL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 08:18:11 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2377A4EF6
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 05:18:10 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id x8so1994224uau.9
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 05:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681993089; x=1684585089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Am4xXpNJ5iAaCrSeXiaBl/58mWnfGbAPREwFXIRt0Uw=;
        b=gv1zek9msh69P4nePIQqGrlderOhL2bztEwFkWBjn4LWGWv79NYZ84U9qV7sUjpmuS
         l/sT/LNifKDQ0NWbTyAg7WQvQe39dSekUAzXca0txgGXZqo4DFn2ztgA0vgIibFkmy7V
         elO929lO14W3tAUR1HxAQNW6JQ97a9wDRVq2mXIFlmJU12L2HR4GpU9KfU0FYT99ZD3H
         0l2/BfteLljEiwU+lDgWBA/GKsf+CoAXK0Nm0P7TKuoOCMtETp9jb/mtoWdpIjYApw3k
         2pBfK4jP4WKaiH8FV7n5Jk6L6dfJOf4OXPN/Ijv1jyJZ/6Frz/omo8EDFCaxNw4KqY2O
         6Bcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681993089; x=1684585089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Am4xXpNJ5iAaCrSeXiaBl/58mWnfGbAPREwFXIRt0Uw=;
        b=ksTdSj6Fczt6+xhcPFlzqMK1vF35Czb07A8YCBANwUZsLsoHTwlIFXqGBMIiV++O1V
         FM2gA676QU1c52DADW1ZsPNp5qxMdaLGiNP2Yi1efuduCLB39CLr9460ZZzbziAQJ6al
         un1qmyfV0R4LhgQ5bBAxYlzgS6Y0fDWSNj9amOLItzSvAyWWvyK0akN2jTMr1tZLJbS8
         s7R4JK/nQAfOacmfz2T38xVJVRI0lzM8Xlb2z3P4HaLYF1/gLYpnxjMeK45u+QPulvrJ
         3DBYJtd+ZfBu1KTSJJxQUdqAS8Vfo/CGppNPUXnHGwurG9jrudMdeDkYUpW/5y19XX3C
         3e7Q==
X-Gm-Message-State: AAQBX9cbGj4HEhOaudn2h19fJixd9olO+zbx1n9P6MVaP1m7r2DRF8C2
        2nodWVXc+RrhqT3wmcw/AnA+HzL3kTl1lfudVLs=
X-Google-Smtp-Source: AKy350bNYKkwiFtoNUh65kRvj9h1H5v0jS47ttn3k6tlNydY8gtrOUweY6HDRFkYaVm2NDJAnDjYC6ea4M1XivT6+RA=
X-Received: by 2002:a1f:a994:0:b0:446:c76f:a7e5 with SMTP id
 s142-20020a1fa994000000b00446c76fa7e5mr865247vke.0.1681993089076; Thu, 20 Apr
 2023 05:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681917551.git.alexl@redhat.com> <2f6d812147236c33a41b67bb4eabab3f568dd045.1681917551.git.alexl@redhat.com>
In-Reply-To: <2f6d812147236c33a41b67bb4eabab3f568dd045.1681917551.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 20 Apr 2023 15:17:58 +0300
Message-ID: <CAOQ4uxig6XTBsQi=sHUQd9iva+VxN6p4fc1X-d0iw7EpQ812pg@mail.gmail.com>
Subject: Re: [PATCH 6/6] ovl: Handle verity during copy-up
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 20, 2023 at 10:44=E2=80=AFAM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> During regular metacopy, if lowerdata file has fs-verity enabled,
> set the new overlay.verity xattr (if enabled).
>
> During real data copy up, remove any old overlay.verity xattr.
>
> If verity is required, and lowerdata does not have fs-verity enabled,
> fall back to full copy-up (or the generated metacopy would not validate).
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/copy_up.c   | 27 +++++++++++++++++++++++++++
>  fs/overlayfs/overlayfs.h |  2 ++
>  fs/overlayfs/util.c      | 36 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 65 insertions(+)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index eb266fb68730..a5c3862911d1 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -19,6 +19,7 @@
>  #include <linux/fdtable.h>
>  #include <linux/ratelimit.h>
>  #include <linux/exportfs.h>
> +#include <linux/fsverity.h>
>  #include "overlayfs.h"
>
>  #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
> @@ -644,6 +645,18 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_c=
tx *c, struct dentry *temp)
>         if (c->metacopy) {
>                 err =3D ovl_check_setxattr(ofs, temp, OVL_XATTR_METACOPY,
>                                          NULL, 0, -EOPNOTSUPP);
> +
> +               /* Copy the verity digest if any so we can validate the c=
opy-up later */
> +               if (!err) {
> +                       struct path lowerdatapath;
> +
> +                       ovl_path_lowerdata(c->dentry, &lowerdatapath);
> +                       if (WARN_ON_ONCE(lowerdatapath.dentry =3D=3D NULL=
))
> +                               err =3D -EIO;
> +                       else
> +                               err =3D ovl_set_verity_xattr_from(ofs, te=
mp, &lowerdatapath);
> +               }
> +
>                 if (err)
>                         return err;
>         }
> @@ -919,6 +932,15 @@ static bool ovl_need_meta_copy_up(struct dentry *den=
try, umode_t mode,
>         if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRU=
NC)))
>                 return false;
>
> +       /* Fall back to full copy if no fsverity on source data and we re=
quire verity */
> +       if (ofs->config.verity_require) {
> +               struct dentry *lowerdata =3D ovl_dentry_lowerdata(dentry)=
;
> +
> +               if (WARN_ON_ONCE(lowerdata =3D=3D NULL) ||
> +                   !fsverity_get_info(d_inode(lowerdata)))
> +                       return false;
> +       }
> +
>         return true;
>  }
>
> @@ -985,6 +1007,11 @@ static int ovl_copy_up_meta_inode_data(struct ovl_c=
opy_up_ctx *c)
>         if (err)
>                 goto out_free;
>
> +       err =3D ovl_removexattr(ofs, upperpath.dentry, OVL_XATTR_VERITY);
> +       if (err && err !=3D -ENODATA)
> +               goto out_free;
> +
> +       err =3D 0;
>         ovl_set_upperdata(d_inode(c->dentry));
>  out_free:
>         kfree(capability);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index b1d639ccd5ac..710dd816518f 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -473,6 +473,8 @@ int ovl_get_verity_xattr(struct ovl_fs *ofs, const st=
ruct path *path,
>  int ovl_validate_verity(struct ovl_fs *ofs,
>                         struct path *metapath,
>                         struct path *datapath);
> +int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct dentry *dst,
> +                             struct path *src);
>  int ovl_sync_status(struct ovl_fs *ofs);
>
>  static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 55e90aa0978a..2bd9c9e68bf4 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -1285,6 +1285,42 @@ int ovl_validate_verity(struct ovl_fs *ofs,
>         return 0;
>  }
>
> +int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct dentry *dst,
> +                             struct path *src)
> +{
> +       int err;
> +       u8 src_digest[FS_VERITY_MAX_DIGEST_SIZE];
> +       enum hash_algo verity_algo;
> +
> +       if (!ofs->config.verity_generate || !S_ISREG(d_inode(dst)->i_mode=
))
> +               return 0;
> +
> +       err =3D -EIO;
> +       if (src) {
> +               err =3D ovl_ensure_verity_loaded(ofs, src);
> +               if (err < 0) {
> +                       pr_warn_ratelimited("lower file '%pd' failed to l=
oad fs-verity info\n",
> +                                           src->dentry);
> +                       return -EIO;
> +               }
> +
> +               err =3D fsverity_get_digest(d_inode(src->dentry), src_dig=
est, &verity_algo);
> +       }
> +       if (err =3D=3D -ENODATA) {
> +               if (ofs->config.verity_require) {
> +                       pr_warn_ratelimited("lower file '%pd' has no fs-v=
erity digest\n",
> +                                           src->dentry);
> +                       return -EIO;
> +               }
> +               return 0;
> +       }
> +       if (err < 0)
> +               return err;
> +
> +       return ovl_check_setxattr(ofs, dst, OVL_XATTR_VERITY,
> +                                 src_digest, hash_digest_size[verity_alg=
o], -EOPNOTSUPP);
> +}
> +
>  /*
>   * ovl_sync_status() - Check fs sync status for volatile mounts
>   *
> --
> 2.39.2
>
