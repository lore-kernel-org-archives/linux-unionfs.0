Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E318C07E8B
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 18:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238923AbjHPSpd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 14:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245019AbjHPSpP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 14:45:15 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45C31B2
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 11:45:13 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-78a5384a5daso1566751241.0
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 11:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692211513; x=1692816313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukB7GrSP6rmVhcpUBhZ7aTfjmJxjlDmzhtoU+osJWMI=;
        b=EbSKGbOlPuxohSWUgqDcPSadUBcf32cEfo8mI0ANJQRtJpOzLqXN/Yy+rdy7JnDQyv
         043T93o9eISSpLN9bPnVuXu4kJPv8pdAGoUTy6BtaB30Jb4fu1fQJp2GcJRDCSxrafqp
         SiVNjK0RflP0L8rOgtAykbwNvwaioRtWrGT6ZYWPW6yYbiCGLBn0hcO31Cy2PxDbVwBa
         kzRz5OaTRFI3mAe2Zz5CwcuKITwIiTs6eBKIdFEeNiK9EfKx+TrqHs1nq8HTfidwnz7t
         2/ux6YAVrtrwYJArnsQQydP+e0EynVs9T8EH9PoqJBx1briadQ/t419+d+dVvcv2vPkS
         7B7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692211513; x=1692816313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ukB7GrSP6rmVhcpUBhZ7aTfjmJxjlDmzhtoU+osJWMI=;
        b=gYrvygQbMxQteOuPY8NTXfPvMwSASx1SrRhhUnIe2mNCTatoIdhSjHJvgjkw86OOEs
         Ua5o2qXdtPFFZuilA7PedFxW8djcyhnDKQ4qwETN2zzec1QtvrMIcOLMXThmzD2kFPAL
         nJhEEu1693K492nQ85Aky97WYDLNGGk3F8HgCZ+Q3hUOfQaPRyDeJttVXKB8k4XAj4qK
         72ZGKYoB2Rga7dk2evuVG4BijmWV1s6yBH0Rvw9BQzaqRn63XzUbzl7X7CPbQoAldNO8
         6HsRJyP6FifZado1l4yGolPYOqYKGtITiaAxkuom7rH0If8g1m47YiqaAi1Hnbx1y+zd
         hYJA==
X-Gm-Message-State: AOJu0YwNDMdhw3P0VyeRKJTSfXAv9xgRaHgMAQ+8z5zChHcxRFH+Jukj
        MZlQL98En8OjI3L4D8HUGX7DttSNSw+RquqWS6U=
X-Google-Smtp-Source: AGHT+IEDhvY95Gen5fmMIy4E0CiWLxFQTf0uvcz/Tmz5O/eZp7VvO9d1MA7qtXFYq+VIehQacMFgRiHfKdxeXVSamhI=
X-Received: by 2002:a67:b903:0:b0:443:81a7:63ee with SMTP id
 q3-20020a67b903000000b0044381a763eemr2049624vsn.21.1692211512780; Wed, 16 Aug
 2023 11:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692198910.git.alexl@redhat.com> <511f90c1f5425c4536381aef8146ef2b1b0b1326.1692198910.git.alexl@redhat.com>
In-Reply-To: <511f90c1f5425c4536381aef8146ef2b1b0b1326.1692198910.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 16 Aug 2023 21:45:01 +0300
Message-ID: <CAOQ4uxhN=ufK5cYyBsh68A=vGcZybMTJskdeXxsbyVim8YKx8A@mail.gmail.com>
Subject: Re: [PATCH 2/4] ovl: Support escaped overlay.* xattrs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 16, 2023 at 6:29=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
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
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> ---
>  fs/overlayfs/inode.c     | 27 +++++++++++++++++++--
>  fs/overlayfs/overlayfs.h |  7 ++++++
>  fs/overlayfs/super.c     | 51 ++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 81 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 2dccf3f7fcbe..743951c11534 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -339,6 +339,18 @@ static const char *ovl_get_link(struct dentry *dentr=
y,
>         return p;
>  }
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
> @@ -417,8 +429,8 @@ int ovl_xattr_get(struct dentry *dentry, struct inode=
 *inode, const char *name,
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
> @@ -432,10 +444,12 @@ static bool ovl_can_list(struct super_block *sb, co=
nst char *s)
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
> @@ -443,6 +457,9 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *li=
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
> @@ -455,6 +472,12 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *l=
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
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 33f88b524627..1dbd01719f63 100644
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
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index def266b5e2a3..97bc94459f7a 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -434,11 +434,47 @@ static bool ovl_workdir_ok(struct dentry *workdir, =
struct dentry *upperdir)
>         return ok;
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
> @@ -447,7 +483,18 @@ static int ovl_own_xattr_set(const struct xattr_hand=
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

I thought I posted those comments on github, but I don't see them -
it would be nice to first move the xattr handlers and get/set/listxattr
implementations to xattr.c file before adding escaping support.

We started shrinking down super.c and I'd hate to see it bloat again.
The way I see it, xattr.c only need to export this helper for super.c:

sb->s_xattr =3D ovl_xattr_handlers(ofs);

Thanks,
Amir.
