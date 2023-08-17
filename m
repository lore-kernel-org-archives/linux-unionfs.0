Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40247C2FC2E
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 14:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351897AbjHQOcM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 10:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351960AbjHQOb5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 10:31:57 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AD81FFF
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 07:31:55 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-56ce156bd37so5361314eaf.3
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 07:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692282715; x=1692887515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kG/gXYYjrHqe8cAFWPT+yzf+bi+9Xe87BJw5pXwLqfw=;
        b=IKmFLW3cmMiixSEhZJo6mhW3NiDoAOtT90mUqUrQfJzdbbaxfx0v1EF7Phkcw+Dv2M
         f118vg0t+KHYSLD8z5QWZZoKxLPxDshNYyW0tc4D6IA2u8dfkv8nU+aIeAd6Thk/aAbe
         R4ULN/1+FY1g5BegTzJmKSh7IdeyvDv2eb4YOwFxZtiG5CdB9gOO1X7H3Wad8lU3SKvT
         hxVcF+1h4Q9fLous9JUjtMTo2j21IgHvzkz/lA0JbezTM+u5hTuhiL8u5C1aUt8ebv3d
         LCulDeE/N+QE/iwuE6mfFHYxSDe9SrE8hMMJMIo3hIsApG3eGkhWZhRhbfkB3okDR6co
         W/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692282715; x=1692887515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kG/gXYYjrHqe8cAFWPT+yzf+bi+9Xe87BJw5pXwLqfw=;
        b=CsUN9TR9TEaQ8RmlagESRmerrvD5KtsJfDW5ecEDVnQZVqdY1RCoSDD8nuD9yZNytF
         nwuCksUl31Pn7wAX065/8kkoidBnG/rgw1VOdPsbYy3baua3igtmwA15EffR4rl++Krr
         mpa5IelwIkD8+mRIJFoTd9LQKyiVDG7SxFNUTprrzOmUne8626Xg7QvTXyMaauhnQ+gK
         gFW4A678uPbforVXsLB40CB8C/Rm+G7Cm5GhOIF69vW1FkKhwVz/UAzYMWwW16l+qiZR
         TYmY/0OpigTprxPBW3mKhBONZ0fSLQyIN0g+oq7NJLp9xSw4aFWgqFXHc6R8fS9f45mb
         52Gw==
X-Gm-Message-State: AOJu0YyJwRk0LTc6u6Vz41ZM6roKVm1zV6u1PqBolPNKZmGqdU8ZLyk+
        IhzCw3bNp8fJ7KDrIfRv0bB0prsyQ68K/tl8ttU=
X-Google-Smtp-Source: AGHT+IGF1RGwtmrMhsM7/czccaBHy6UgiC98/qf5cfkC0tX6DfLa4ptKFJ6EhjLJwjEcmtaEw3S6NqGldPS8UWL//9E=
X-Received: by 2002:a05:6358:990d:b0:139:b911:f3f1 with SMTP id
 w13-20020a056358990d00b00139b911f3f1mr6026637rwa.0.1692282714999; Thu, 17 Aug
 2023 07:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <c303fe8cdcafade9583b390d13b2a5d56e122d58.1692270188.git.alexl@redhat.com>
In-Reply-To: <c303fe8cdcafade9583b390d13b2a5d56e122d58.1692270188.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Aug 2023 17:31:43 +0300
Message-ID: <CAOQ4uxij9_F7MwK6d76mnNNZ-NqoQQ1T-DzDHjbHYpw6TYhULw@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] ovl: Support escaped overlay.* xattrs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 17, 2023 at 2:05=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
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
>
> This allows storing any kind of overlay xattrs in a overlayfs mount
> that can be used as a lowerdir in another mount. It is possible to
> stack this mechanism multiple times, such that
> overlay.overlay.overlay.XYZ will survive two levels of overlay mounts,
> however this is not all that useful in practice because of stack depth
> limitations of overlayfs mounts.
>

Please elaborate what happens when lower overlayfs is trusted.overlay
and nested overlayfs is user.overlay or the other way around.
Is it true that this patch would not be needed at all if this was the case?

In any case, I think that this case would not be uncommon, so it is worth
adding it in the tests.

Thanks,
Amir.

> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> ---
>  fs/overlayfs/overlayfs.h |  7 ++++
>  fs/overlayfs/xattrs.c    | 78 +++++++++++++++++++++++++++++++++++++---
>  2 files changed, 81 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index ef993a543b2a..311e1f37ce84 100644
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
