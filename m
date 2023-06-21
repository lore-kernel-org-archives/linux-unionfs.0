Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94070EB64D7
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jun 2023 12:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbjFUM03 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 08:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjFUM01 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2023 08:26:27 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528731717
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 05:26:22 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id a1e0cc1a2514c-78f638a7be3so1049042241.1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 05:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687350381; x=1689942381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKMNuLHa40TQT523RMSFak/Pn/iXfQ6Pm6GlVQboRV8=;
        b=geo5K5p7x25Hc6Q40tEa76YCjk+cHVfDKCz9Cw91l4w7bxAMrCeuThxfVob3GzFR2n
         R6WxVZ0EE6RRgW7OEytq+mJ2MePHHplj3levVqToIVP49WVpRnrHgf5FwGvz8T0AdvaC
         V3NgpRvsRRIZsIC3DBCytd3hmvVVtalQfz9PP8OuRW3uOuv2wMnlHK/Ezn+h+t5YwTFc
         o/Fryxw13dOyLaD8eqyUjhUTo9glHVATukR9d4DAZYlyS8KWY/02WySVcHl756w/y4LY
         0cMrnp29mqwHYIlij/OV9Q9nqII9DcEoCPcOt/AybD1f8i1WCpEGPbdWViYEv4qtUnjF
         hzsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687350381; x=1689942381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKMNuLHa40TQT523RMSFak/Pn/iXfQ6Pm6GlVQboRV8=;
        b=CIUyIYFPJnUnFkKk3tawmrUP67S3/DRwFeyb6paAkZF2dY9oRp1WYcEbuY7psRXblJ
         EcbqIr4zu1dyE2xmAzgDsAWpuUY1T4qIuh2Cc4zbSd8mK3tc6evSLihl9vhdLH/PpXcy
         BlTJxg8V5I33TZ/xD0S8QNl6fB3oD9UrILBoiSOgCYJyPXH345uEp28Y+G5e1Bns8GaA
         AlHowcRv/Voih37IqDxNlzc9SjEfzMi5eM6UrhlKNFwtKoAvECEP7M9hv/Ea7R/YMd2e
         1d3cwPpZVajfL6ru7fLuZbNKi9q3/PTMKGuf/zzZd8lRR6QzuBs6UaeYpG0sluzsAmTC
         77jg==
X-Gm-Message-State: AC+VfDxnje9iSwyLPEFEk2PQYbOlH70mOuRki1n4jJ1P9KpCeLjq2SLS
        8/1OVMrP/gXk3S2ngp9YhiFlSdwJUIJ2sVWgAY2qhb4GwMw=
X-Google-Smtp-Source: ACHHUZ4mBqDoGzEzB2Nkszh7tMxzeLoakMj7OkvYk/p5F61BRlUyxhTHiBQYH9mYpluEILIAS5f+VNvxH7mPE6qdN3U=
X-Received: by 2002:a67:fe0c:0:b0:43d:c0e1:53ff with SMTP id
 l12-20020a67fe0c000000b0043dc0e153ffmr3983683vsr.16.1687350381165; Wed, 21
 Jun 2023 05:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687345663.git.alexl@redhat.com> <8771725be2a8b7d65ea6c50a69bb6392b9e903aa.1687345663.git.alexl@redhat.com>
In-Reply-To: <8771725be2a8b7d65ea6c50a69bb6392b9e903aa.1687345663.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Jun 2023 15:26:09 +0300
Message-ID: <CAOQ4uxjzmyK_Q1NkikL2XeUpqWLwnv4mDgyR1Bu0C2TmeYwvGA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] ovl: Handle verity during copy-up
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
> During regular metacopy, if lowerdata file has fs-verity enabled, and
> the verity option is enabled, we add the digest to the metacopy xattr.
>
> If verity is required, and lowerdata does not have fs-verity enabled,
> fall back to full copy-up (or the generated metacopy would not
> validate).
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>

Looks good.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/copy_up.c   | 45 ++++++++++++++++++++++++++++++++++++++--
>  fs/overlayfs/overlayfs.h |  3 +++
>  fs/overlayfs/util.c      | 33 ++++++++++++++++++++++++++++-
>  3 files changed, 78 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 68f01fd7f211..fce7d048673c 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -544,6 +544,7 @@ struct ovl_copy_up_ctx {
>         bool origin;
>         bool indexed;
>         bool metacopy;
> +       bool metacopy_digest;
>  };
>
>  static int ovl_link_up(struct ovl_copy_up_ctx *c)
> @@ -641,8 +642,21 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_c=
tx *c, struct dentry *temp)
>         }
>
>         if (c->metacopy) {
> -               err =3D ovl_check_setxattr(ofs, temp, OVL_XATTR_METACOPY,
> -                                        NULL, 0, -EOPNOTSUPP);
> +               struct path lowerdatapath;
> +               struct ovl_metacopy metacopy_data =3D OVL_METACOPY_INIT;
> +
> +               ovl_path_lowerdata(c->dentry, &lowerdatapath);
> +               if (WARN_ON_ONCE(lowerdatapath.dentry =3D=3D NULL))
> +                       err =3D -EIO;
> +               else
> +                       err =3D ovl_set_verity_xattr_from(ofs, &lowerdata=
path, &metacopy_data);
> +
> +               if (metacopy_data.digest_algo)
> +                       c->metacopy_digest =3D true;
> +
> +               if (!err)
> +                       err =3D ovl_set_metacopy_xattr(ofs, temp, &metaco=
py_data);
> +
>                 if (err)
>                         return err;
>         }
> @@ -751,6 +765,12 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ct=
x *c)
>         if (err)
>                 goto cleanup;
>
> +       if (c->metacopy_digest)
> +               ovl_set_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
> +       else
> +               ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
> +       ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
> +
>         if (!c->metacopy)
>                 ovl_set_upperdata(d_inode(c->dentry));
>         inode =3D d_inode(c->dentry);
> @@ -813,6 +833,12 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ct=
x *c)
>         if (err)
>                 goto out_fput;
>
> +       if (c->metacopy_digest)
> +               ovl_set_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
> +       else
> +               ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
> +       ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
> +
>         if (!c->metacopy)
>                 ovl_set_upperdata(d_inode(c->dentry));
>         ovl_inode_update(d_inode(c->dentry), dget(temp));
> @@ -918,6 +944,19 @@ static bool ovl_need_meta_copy_up(struct dentry *den=
try, umode_t mode,
>         if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRU=
NC)))
>                 return false;
>
> +       /* Fall back to full copy if no fsverity on source data and we re=
quire verity */
> +       if (ofs->config.verity_mode =3D=3D OVL_VERITY_REQUIRE) {
> +               struct path lowerdata;
> +
> +               ovl_path_lowerdata(dentry, &lowerdata);
> +
> +               if (WARN_ON_ONCE(lowerdata.dentry =3D=3D NULL) ||
> +                   ovl_ensure_verity_loaded(&lowerdata) ||
> +                   !fsverity_get_info(d_inode(lowerdata.dentry))) {
> +                       return false;
> +               }
> +       }
> +
>         return true;
>  }
>
> @@ -984,6 +1023,8 @@ static int ovl_copy_up_meta_inode_data(struct ovl_co=
py_up_ctx *c)
>         if (err)
>                 goto out_free;
>
> +       ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
> +       ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
>         ovl_set_upperdata(d_inode(c->dentry));
>  out_free:
>         kfree(capability);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 9fbbc077643b..e728360c66ff 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -519,11 +519,14 @@ int ovl_set_metacopy_xattr(struct ovl_fs *ofs, stru=
ct dentry *d,
>                            struct ovl_metacopy *metacopy);
>  bool ovl_is_metacopy_dentry(struct dentry *dentry);
>  char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path=
, int padding);
> +int ovl_ensure_verity_loaded(struct path *path);
>  int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
>                          u8 *digest_buf, int *buf_length);
>  int ovl_validate_verity(struct ovl_fs *ofs,
>                         struct path *metapath,
>                         struct path *datapath);
> +int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct path *src,
> +                             struct ovl_metacopy *metacopy);
>  int ovl_sync_status(struct ovl_fs *ofs);
>
>  static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 927a1133859d..439e23496713 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -1188,7 +1188,7 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, co=
nst struct path *path, int pa
>  }
>
>  /* Call with mounter creds as it may open the file */
> -static int ovl_ensure_verity_loaded(struct path *datapath)
> +int ovl_ensure_verity_loaded(struct path *datapath)
>  {
>         struct inode *inode =3D d_inode(datapath->dentry);
>         const struct fsverity_info *vi;
> @@ -1264,6 +1264,37 @@ int ovl_validate_verity(struct ovl_fs *ofs,
>         return 0;
>  }
>
> +int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct path *src,
> +                             struct ovl_metacopy *metacopy)
> +{
> +       int err, digest_size;
> +
> +       if (!ofs->config.verity_mode || !S_ISREG(d_inode(src->dentry)->i_=
mode))
> +               return 0;
> +
> +       err =3D ovl_ensure_verity_loaded(src);
> +       if (err < 0) {
> +               pr_warn_ratelimited("lower file '%pd' failed to load fs-v=
erity info\n",
> +                                   src->dentry);
> +               return -EIO;
> +       }
> +
> +       digest_size =3D fsverity_get_digest(d_inode(src->dentry),
> +                                         metacopy->digest, &metacopy->di=
gest_algo, NULL);
> +       if (digest_size =3D=3D 0 ||
> +           WARN_ON_ONCE(digest_size > FS_VERITY_MAX_DIGEST_SIZE)) {
> +               if (ofs->config.verity_mode =3D=3D OVL_VERITY_REQUIRE) {
> +                       pr_warn_ratelimited("lower file '%pd' has no fs-v=
erity digest\n",
> +                                           src->dentry);
> +                       return -EIO;
> +               }
> +               return 0;
> +       }
> +
> +       metacopy->len +=3D digest_size;
> +       return 0;
> +}
> +
>  /*
>   * ovl_sync_status() - Check fs sync status for volatile mounts
>   *
> --
> 2.40.1
>
