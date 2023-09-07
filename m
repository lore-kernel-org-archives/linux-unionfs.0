Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C77EC8750
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 17:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245505AbjIGRsI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245581AbjIGRrx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 13:47:53 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88181BF9
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 10:47:35 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-68bed2c786eso1076150b3a.0
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 10:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694108852; x=1694713652; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcUPTKdasGRQCPr0wzhmDQn0EX2M1MhnUd83ojpqxg8=;
        b=dOot2ABTULpgYxbAqp/lkERR38NQq0+LSBsHK/sfuY+2R1uS2ztM97gcSRt/ejfvwZ
         vLvW5bnGchJDmfe8UqtXfSdMJwUaD3+sfTWRpIr/lIRllgrly/dveNqBk2hVw/fZPiOk
         V1qU176GmI9U8ziGAdwZAcYxziF0GaFZiAylY2BITXBmLKudY+imWaQqswO3xpWpJ2WX
         xFV86HeEPaWwIvL5iETxWamUsjhN0btqZFUhl1KaVyvvekkqEoVlQpIUnKKKoenJQbdi
         Eksvv2KX/zr9omdBtbFW6bCg00tyMGzUFsKXzHKsNSnoViFmGeFw5bJ9Elnr2jN11zXr
         8arA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694108852; x=1694713652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AcUPTKdasGRQCPr0wzhmDQn0EX2M1MhnUd83ojpqxg8=;
        b=MkHyrZFunc104PsqvUx/NRk5b9qNZTNdZNGrcNuFZuFFpE1mPJlcbLvrv8rJzv1J+3
         AtN1wLSsAqpvJVE1zVWwYIzk22JgbX2REy4kaqj8QGbGkGKBWC8No8a+MTnUDkgpwSAi
         bNN4zD3AwMIHn2URg4CD8TiW9quR6NBH+FlKx2VcgzMH22xC5/BuvD/UY8e5Z9xrj/h9
         nMqCcnCQO+gyga0ByH9v5qzNbN1dQwsY+x9wmpye5BL0ltB7wQRBo4/TLmZyc2rp32xm
         1bge1u79vjDDHQKXoOtHwednvmrUg9tObmz4IL7ys9sP9+aIHNG6azydVH2ht7Fp0C/O
         roeQ==
X-Gm-Message-State: AOJu0YyAxYeZSadcQkbeLKHGrMxD0UFmLe3FVIbSFbsWcvQDPKsh8AD2
        T1qdro1yyULuWerG70snyeEfS3vjPGezw4+5j/QzKxD2EMc=
X-Google-Smtp-Source: AGHT+IHJ6y2gCr+qyt0Xfg65faBzehWQatIvJoj+eTviTGWEoI9TWV++81qSKG1zgt5w5YbgFIIS4ulVMNo8dQtfUEM=
X-Received: by 2002:a67:ce8c:0:b0:44e:8e28:2852 with SMTP id
 c12-20020a67ce8c000000b0044e8e282852mr6861010vse.10.1694085899183; Thu, 07
 Sep 2023 04:24:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694075674.git.alexl@redhat.com> <5c18d058e189f488ff87b7fdba231cf356e91789.1694075674.git.alexl@redhat.com>
In-Reply-To: <5c18d058e189f488ff87b7fdba231cf356e91789.1694075674.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 7 Sep 2023 14:24:48 +0300
Message-ID: <CAOQ4uxgujnxEugNqbd-BwH1GuH+HeiNf5ZUsTSnPqy163MaQsg@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] ovl: Support escaped overlay.* xattrs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 7, 2023 at 11:44=E2=80=AFAM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> There are cases where you want to use an overlayfs mount as a lowerdir
> for another overlayfs mount. For example, if the system rootfs is on
> overlayfs due to composefs, or to make it volatile (via tmps), then
> you cannot currently store a lowerdir on the rootfs. This means you
> can't e.g. store on the rootfs a prepared container image for use
> using overlayfs.
>
> To work around this, we introduce an escapment mechanism for overlayfs
> xattrs. Whenever the lower/upper dir has a xattr named
> `overlay.overlay.XYZ`, we list it as overlay.XYZ in listxattrs, and
> when the user calls getxattr or setxattr on `overlay.XYZ`, we apply to
> `overlay.overlay.XYZ` in the backing directories.

Please use ""

>
> This allows storing any kind of overlay xattrs in a overlayfs mount
> that can be used as a lowerdir in another mount. It is possible to
> stack this mechanism multiple times, such that
> overlay.overlay.overlay.XYZ will survive two levels of overlay mounts,
> however this is not all that useful in practice because of stack depth
> limitations of overlayfs mounts.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>

With comment in ovl_listxattr() below fixed you may add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/overlayfs.h |  7 ++++
>  fs/overlayfs/xattrs.c    | 78 +++++++++++++++++++++++++++++++++++++---
>  2 files changed, 81 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index dff7232b7bf5..736d7f952a8e 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -32,6 +32,13 @@ enum ovl_path_type {
>  #define OVL_XATTR_USER_PREFIX XATTR_USER_PREFIX OVL_XATTR_NAMESPACE
>  #define OVL_XATTR_USER_PREFIX_LEN (sizeof(OVL_XATTR_USER_PREFIX) - 1)
>
> +#define OVL_XATTR_ESCAPE_PREFIX OVL_XATTR_NAMESPACE
> +#define OVL_XATTR_ESCAPE_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_PREFIX) - 1=
)
> +#define OVL_XATTR_ESCAPE_TRUSTED_PREFIX OVL_XATTR_TRUSTED_PREFIX OVL_XAT=
TR_ESCAPE_PREFIX
> +#define OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_TRU=
STED_PREFIX) - 1)
> +#define OVL_XATTR_ESCAPE_USER_PREFIX OVL_XATTR_USER_PREFIX OVL_XATTR_ESC=
APE_PREFIX
> +#define OVL_XATTR_ESCAPE_USER_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_USER_P=
REFIX) - 1)
> +
>  enum ovl_xattr {
>         OVL_XATTR_OPAQUE,
>         OVL_XATTR_REDIRECT,
> diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
> index b8ea96606ea8..27b31f812eb1 100644
> --- a/fs/overlayfs/xattrs.c
> +++ b/fs/overlayfs/xattrs.c
> @@ -4,6 +4,18 @@
>  #include <linux/xattr.h>
>  #include "overlayfs.h"
>
> +bool ovl_is_escaped_xattr(struct super_block *sb, const char *name)
> +{
> +       struct ovl_fs *ofs =3D sb->s_fs_info;
> +
> +       if (ofs->config.userxattr)
> +               return strncmp(name, OVL_XATTR_ESCAPE_USER_PREFIX,
> +                              OVL_XATTR_ESCAPE_USER_PREFIX_LEN) =3D=3D 0=
;
> +       else
> +               return strncmp(name, OVL_XATTR_ESCAPE_TRUSTED_PREFIX,
> +                              OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN - 1) =
=3D=3D 0;
> +}
> +
>  bool ovl_is_private_xattr(struct super_block *sb, const char *name)
>  {
>         struct ovl_fs *ofs =3D OVL_FS(sb);
> @@ -82,8 +94,8 @@ static int ovl_xattr_get(struct dentry *dentry, struct =
inode *inode, const char
>
>  static bool ovl_can_list(struct super_block *sb, const char *s)
>  {
> -       /* Never list private (.overlay) */
> -       if (ovl_is_private_xattr(sb, s))
> +       /* Never list non-escaped private (.overlay) */
> +       if (ovl_is_private_xattr(sb, s) && !ovl_is_escaped_xattr(sb, s))
>                 return false;
>
>         /* List all non-trusted xattrs */
> @@ -97,10 +109,12 @@ static bool ovl_can_list(struct super_block *sb, con=
st char *s)
>  ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
>  {
>         struct dentry *realdentry =3D ovl_dentry_real(dentry);
> +       struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         ssize_t res;
>         size_t len;
>         char *s;
>         const struct cred *old_cred;
> +       size_t prefix_len;
>
>         old_cred =3D ovl_override_creds(dentry->d_sb);
>         res =3D vfs_listxattr(realdentry, list, size);
> @@ -108,6 +122,9 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *li=
st, size_t size)
>         if (res <=3D 0 || size =3D=3D 0)
>                 return res;
>
> +       prefix_len =3D ofs->config.userxattr ?
> +               OVL_XATTR_USER_PREFIX_LEN : OVL_XATTR_TRUSTED_PREFIX_LEN;
> +
>         /* filter out private xattrs */
>         for (s =3D list, len =3D res; len;) {
>                 size_t slen =3D strnlen(s, len) + 1;
> @@ -120,6 +137,12 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *l=
ist, size_t size)
>                 if (!ovl_can_list(dentry->d_sb, s)) {
>                         res -=3D slen;
>                         memmove(s, s + slen, len);
> +               } else if (ovl_is_escaped_xattr(dentry->d_sb, s)) {
> +                       memmove(s + prefix_len,
> +                               s + prefix_len + OVL_XATTR_ESCAPE_PREFIX_=
LEN,
> +                               slen - (prefix_len + OVL_XATTR_ESCAPE_PRE=
FIX_LEN) + len);
> +                       res -=3D OVL_XATTR_ESCAPE_PREFIX_LEN;
> +                       s +=3D slen - OVL_XATTR_ESCAPE_PREFIX_LEN;

It's a bit hard to follow. how about:

res -=3D OVL_XATTR_ESCAPE_PREFIX_LEN;
name_len =3D slen - prefix_len - OVL_XATTR_ESCAPE_PREFIX_LEN;
s +=3D prefix_len;
memmove(s, s + OVL_XATTR_ESCAPE_PREFIX_LEN, name_len + len);
s +=3D OVL_XATTR_ESCAPE_PREFIX_LEN + name_len;


>                 } else {
>                         s +=3D slen;
>                 }
> @@ -128,11 +151,47 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *=
list, size_t size)
>         return res;
>  }
>
> +static char *ovl_xattr_escape_name(const char *prefix, const char *name)
> +{
> +       size_t prefix_len =3D strlen(prefix);
> +       size_t name_len =3D strlen(name);
> +       size_t escaped_len;
> +       char *escaped, *s;
> +
> +       escaped_len =3D prefix_len + OVL_XATTR_ESCAPE_PREFIX_LEN + name_l=
en;
> +       if (escaped_len > XATTR_NAME_MAX)
> +               return ERR_PTR(-EOPNOTSUPP);
> +
> +       escaped =3D kmalloc(escaped_len + 1, GFP_KERNEL);
> +       if (escaped =3D=3D NULL)
> +               return ERR_PTR(-ENOMEM);
> +
> +       s =3D escaped;
> +       memcpy(s, prefix, prefix_len);
> +       s +=3D prefix_len;
> +       memcpy(s, OVL_XATTR_ESCAPE_PREFIX, OVL_XATTR_ESCAPE_PREFIX_LEN);
> +       s +=3D OVL_XATTR_ESCAPE_PREFIX_LEN;
> +       memcpy(s, name, name_len + 1);
> +
> +       return escaped;
> +}
> +
>  static int ovl_own_xattr_get(const struct xattr_handler *handler,
>                              struct dentry *dentry, struct inode *inode,
>                              const char *name, void *buffer, size_t size)
>  {
> -       return -EOPNOTSUPP;
> +       char *escaped;
> +       int r;
> +
> +       escaped =3D ovl_xattr_escape_name(handler->prefix, name);
> +       if (IS_ERR(escaped))
> +               return PTR_ERR(escaped);
> +
> +       r =3D ovl_xattr_get(dentry, inode, escaped, buffer, size);
> +
> +       kfree(escaped);
> +
> +       return r;
>  }
>
>  static int ovl_own_xattr_set(const struct xattr_handler *handler,
> @@ -141,7 +200,18 @@ static int ovl_own_xattr_set(const struct xattr_hand=
ler *handler,
>                              const char *name, const void *value,
>                              size_t size, int flags)
>  {
> -       return -EOPNOTSUPP;
> +       char *escaped;
> +       int r;
> +
> +       escaped =3D ovl_xattr_escape_name(handler->prefix, name);
> +       if (IS_ERR(escaped))
> +               return PTR_ERR(escaped);
> +
> +       r =3D ovl_xattr_set(dentry, inode, escaped, value, size, flags);
> +
> +       kfree(escaped);
> +
> +       return r;
>  }
>
>  static int ovl_other_xattr_get(const struct xattr_handler *handler,
> --
> 2.41.0
>
