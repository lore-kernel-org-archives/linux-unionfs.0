Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A49EB64D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 12:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjFTMKb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 08:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjFTMK1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 08:10:27 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9519E170D
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 05:10:24 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-440b69847bfso659923137.1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 05:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687263023; x=1689855023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5Y7xKI9Gz4hxFUW29vTeY+aza3A9u3z6JOAecQDiy4=;
        b=fv5HMvg4iyuBTCLElPYz/56NL3VMZ2LRXd4cWndDo0huztMD1kWE6XpYluiPckQixg
         0RVb+2pk4i7M8yme8gOWEj1mGuC9Euy4oEDdNplQs399CDzZmCBPYrK7JCMytod8eRkj
         P24CqQzUa68TGB2usbgACtwCR9fK0/rZsXot+qsvfPwTqTaMLJOxHFrzMXXzUMqbSu1l
         y+orAIv5/HVi2A81IpgndOAX/o6dQRIXbu6bXv7LGpgwsyc9Rdk7sTNau7hIpKt3KJb3
         yYgOYay106manXaCtG1wYWyxDMm1VsKm3MEVuQXU0h1HsmRTHkBmFBK4ZEZ++19XWfm3
         /t/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687263023; x=1689855023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5Y7xKI9Gz4hxFUW29vTeY+aza3A9u3z6JOAecQDiy4=;
        b=CPfCY3J4Zo49wH/g9FiE9Q9Tid7ZVw82kwXiuhyCMW+nfdRqYKJnovkwmObJWOB8T9
         350DuK77f/kbyiTlXSR0m7KUd/AsUzGcIOTtohaEE9LR3zt1tpyQO/DzsejYPcV/GcYW
         WNxrEYlpnsi5wvTMnvarYrbCdQulelynCb+KQ34LoGK0k1P+x8u/yxQCcLe+j4FN1pQm
         ZaNUAHFUNUzvqfH5VUuOlerETkFbLf5z95w6o0laHy44AvY96s3FIhGftHPNhw4dr3A+
         ltclYO9HjOkCVW1x04FTk07tAKauvnXhX8L0q/SKX615pLbBWfxJKDxRHDtPUykV9AwR
         0rGw==
X-Gm-Message-State: AC+VfDx3Wge2Zw2SJrrCp30fN+W5xFoE3GuDaBKCnplTPAVLdBtPVcoP
        c5X6MiAsLI5xQczDgLjSYzkP8dKnE6Q+NqVJRsA=
X-Google-Smtp-Source: ACHHUZ4juVxdfx/Nbg1Yapg6m5lJCmSQPzLp3kSQP9wTgOf/LkWMoOs9u0mpa5mqtkvTeB7U1fr5UhSyDefvIqgVX3Y=
X-Received: by 2002:a67:ce8a:0:b0:440:c339:9694 with SMTP id
 c10-20020a67ce8a000000b00440c3399694mr753425vse.27.1687263023560; Tue, 20 Jun
 2023 05:10:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687255035.git.alexl@redhat.com> <14eaa0223125470ec8cf38b6185b2a94b14ee313.1687255035.git.alexl@redhat.com>
In-Reply-To: <14eaa0223125470ec8cf38b6185b2a94b14ee313.1687255035.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 20 Jun 2023 15:10:12 +0300
Message-ID: <CAOQ4uxgxYRupbuKXgYQTt7GB2y4xif4ftx-XqrPV2pqB66cemw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] ovl: Handle verity during copy-up
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 20, 2023 at 1:15=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
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
Minor comments below

> ---
>  fs/overlayfs/copy_up.c   | 45 ++++++++++++++++++++++++++++++++++++++--
>  fs/overlayfs/overlayfs.h |  3 +++
>  fs/overlayfs/util.c      | 32 +++++++++++++++++++++++++++-
>  3 files changed, 77 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 68f01fd7f211..6e6c25836e52 100644
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
> +               if (metacopy_data.digest_algo !=3D 0)

Nit: please drop "!=3D 0"

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
> index c2213a8ad16e..eef4a3243e8a 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -517,11 +517,14 @@ int ovl_set_metacopy_xattr(struct ovl_fs *ofs, stru=
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
> index 66448964f753..3841f04baf35 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -1185,7 +1185,7 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, co=
nst struct path *path, int pa
>  }
>
>  /* Call with mounter creds as it may open the file */
> -static int ovl_ensure_verity_loaded(struct path *datapath)
> +int ovl_ensure_verity_loaded(struct path *datapath)
>  {
>         struct inode *inode =3D d_inode(datapath->dentry);
>         const struct fsverity_info *vi;
> @@ -1263,6 +1263,36 @@ int ovl_validate_verity(struct ovl_fs *ofs,
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
> +       if (digest_size =3D=3D 0) {
|| WARN_ON_ONCE(digest_size > FS_VERITY_MAX_DIGEST_SIZE))

> +               if (ofs->config.verity_mode =3D=3D OVL_VERITY_REQUIRE) {
> +                       pr_warn_ratelimited("lower file '%pd' has no fs-v=
erity digest\n",
> +                                           src->dentry);
> +                       return -EIO;
> +               }
> +               return 0;
> +       }
> +

ovl and fsverity are different modules, so we should have this
fail safety assertion in place.

It may look ridiculous that fsverity_get_digest() would return a size
larger than their own constant, but people may be loading an overlayfs
module not compiled with exact same fsverity code.

The results of this may be undefined, but at least we can make
the problem heard.

Thanks,
Amir.
