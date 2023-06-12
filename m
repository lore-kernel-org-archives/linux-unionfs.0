Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42375C7EE43
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jun 2023 11:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbjFLLE3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 07:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237145AbjFLLEP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jun 2023 07:04:15 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894AD86A4
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 03:52:20 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id a1e0cc1a2514c-78cbc8176c7so461946241.0
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 03:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686567139; x=1689159139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BY0nnvkAsU0s9Yyq9P4+eIGHl7OnLRukyFML9k84YvE=;
        b=UYRT+akyGDbYY895Fj2UizqhhQ8PKWW+GPm1bj5iDJg+nERp6P+8dG1V43fVBzT0VR
         eh3XvOz0WLSkGsHIzYI+c1Ekb61A14AwdRHN6V31bY7GtEoynfln+tPZ84vUJTy7caC/
         4eHWMNuosYNdcucDOm2f5FG8cPfV+ZrqGAioMx5JBfOicvgvesw/++f2IfvMfMllj/k7
         Jmz+bmkYdS1zyupV7befK5r7CWXg+hxjP17jbyuF2G2vVBOqVLOaZmnlp7yyasQoSuDR
         RfV//lmB/B02Bw6u3s5XOlU06wku2YpvZFbFgUAFRy9yDIJdNOxcrMUSZz7sDnT5yqoq
         oXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686567139; x=1689159139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BY0nnvkAsU0s9Yyq9P4+eIGHl7OnLRukyFML9k84YvE=;
        b=hu51yv8YT5YB11HbVqN3sMqQy/yK0XYUtUZ6Jyduz1kyfi6vnofMv4AAPWQWgfjr01
         LZz8pJYlYCeet44iOMCjqL/o6uJYokbrTl8norNKUNRCxNE25VkU9HB2B/1RXwS9u+57
         PmoVbjqCltpwFQxTeSe3xkoCpxrQPTOrKHSKuLvi96I4E1POc6rLxrszEhsYRxFBfbke
         dcr55loz3YddlK5MonZmrLpC92C7jis5XvmWmKo+zxTaNdSa/CN7DKbijWSFwe4xnlCX
         H69g0XHU+MBMlZtqlgU7cEWgUmrH7ZtvcVdYJwueA0gnozDJ9VfOEM1cOWo3gI2rytBR
         kUHg==
X-Gm-Message-State: AC+VfDzMIj9/jV0z/6CU0raAv2qxMvFFep71RnrkMdX5Q+RxfxE/M+qb
        zc3QLP3ZCERWG6uG4R0yjOLyHz3oGEh5SOMbXN4=
X-Google-Smtp-Source: ACHHUZ7xCP28gE/k5HmDE92p/ZqHwYOTV5QYC9C7gO2oTCvn6WtTKVlcHU8mad6uHxXsSDzv7WpOz1sVBuFbW1/n6tc=
X-Received: by 2002:a05:6102:1354:b0:43b:3574:fb7b with SMTP id
 j20-20020a056102135400b0043b3574fb7bmr3043898vsl.7.1686567139574; Mon, 12 Jun
 2023 03:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <4548bcf591f7928606c2f487274292b512927d4f.1686565330.git.alexl@redhat.com>
In-Reply-To: <4548bcf591f7928606c2f487274292b512927d4f.1686565330.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 12 Jun 2023 13:52:08 +0300
Message-ID: <CAOQ4uxj65YcC3zfWQE1n2M4PRYWihWoSp3Yr=oW3QsyRECre6A@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ovl: Handle verity during copy-up
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 12, 2023 at 1:29=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
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
> ---
>  fs/overlayfs/copy_up.c   | 31 +++++++++++++++++++++++++++++++
>  fs/overlayfs/overlayfs.h |  3 +++
>  fs/overlayfs/util.c      | 39 ++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 72 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 68f01fd7f211..67c4f14c694c 100644
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
> @@ -643,6 +644,18 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_c=
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
> @@ -918,6 +931,19 @@ static bool ovl_need_meta_copy_up(struct dentry *den=
try, umode_t mode,
>         if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRU=
NC)))
>                 return false;
>
> +       /* Fall back to full copy if no fsverity on source data and we re=
quire verity */
> +       if (ofs->config.require_verity) {
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
> @@ -984,6 +1010,11 @@ static int ovl_copy_up_meta_inode_data(struct ovl_c=
opy_up_ctx *c)
>         if (err)
>                 goto out_free;
>
> +       err =3D ovl_removexattr(ofs, upperpath.dentry, OVL_XATTR_VERITY);
> +       if (err && err !=3D -ENODATA)

-EOPNOTSUPP is also not a failure, although you could do:
if (!ofs->noxattr) ...

to avoid this error

> +               goto out_free;
> +
> +       err =3D 0;
>         ovl_set_upperdata(d_inode(c->dentry));
>  out_free:
>         kfree(capability);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 66e3f79ed6d0..472bef93cb0b 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -462,11 +462,14 @@ int ovl_lock_rename_workdir(struct dentry *workdir,=
 struct dentry *upperdir);
>  int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
);
>  bool ovl_is_metacopy_dentry(struct dentry *dentry);
>  char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path=
, int padding);
> +int ovl_ensure_verity_loaded(struct path *path);
>  int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
>                          u8 *digest_buf, int *buf_length);
>  int ovl_validate_verity(struct ovl_fs *ofs,
>                         struct path *metapath,
>                         struct path *datapath);
> +int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct dentry *dst,
> +                             struct path *src);
>  int ovl_sync_status(struct ovl_fs *ofs);
>
>  static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index a4666ba3d5a3..cef907ff66bc 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -1174,7 +1174,7 @@ int ovl_get_verity_xattr(struct ovl_fs *ofs, const =
struct path *path,
>  }
>
>  /* Call with mounter creds as it may open the file */
> -static int ovl_ensure_verity_loaded(struct path *datapath)
> +int ovl_ensure_verity_loaded(struct path *datapath)
>  {
>         struct inode *inode =3D d_inode(datapath->dentry);
>         const struct fsverity_info *vi;
> @@ -1248,6 +1248,43 @@ int ovl_validate_verity(struct ovl_fs *ofs,
>         return 0;
>  }
>
> +int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct dentry *dst,
> +                             struct path *src)
> +{
> +       int err;
> +       u8 src_digest[1+FS_VERITY_MAX_DIGEST_SIZE];
> +       enum hash_algo verity_algo;
> +
> +       if (!ofs->config.verity || !S_ISREG(d_inode(dst)->i_mode))
> +               return 0;
> +
> +       err =3D -EIO;
> +       if (src) {
> +               err =3D ovl_ensure_verity_loaded(src);
> +               if (err < 0) {
> +                       pr_warn_ratelimited("lower file '%pd' failed to l=
oad fs-verity info\n",
> +                                           src->dentry);
> +                       return -EIO;
> +               }
> +
> +               err =3D fsverity_get_digest(d_inode(src->dentry), src_dig=
est + 1, &verity_algo);
> +       }
> +       if (err =3D=3D -ENODATA) {
> +               if (ofs->config.require_verity) {
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
> +       src_digest[0] =3D (u8)verity_algo;
> +       return ovl_check_setxattr(ofs, dst, OVL_XATTR_VERITY,
> +                                 src_digest, 1 + hash_digest_size[verity=
_algo], -EOPNOTSUPP);
> +}
> +
>  /*
>   * ovl_sync_status() - Check fs sync status for volatile mounts
>   *
> --
> 2.40.1
>
