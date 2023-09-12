Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877FCCA0EC3
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 12:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjILMFY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 08:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbjILMFX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 08:05:23 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF2010D2
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 05:05:19 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-3a7e68f4214so4205941b6e.1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 05:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694520319; x=1695125119; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+6c2JhTji0Suck65jPMHLrMvvWMOIR1EHUZt6PSI0bQ=;
        b=l7f1XqJTjkxWDXjP8mBShdpfbdGF5k/JGYTHbUq3i2twwqTp1DD7SG6TiAns6wVRIX
         xiinFk628McPGFeuAOkfMJyvODWnMHsf6jiJQRG2J8d3X5KYqE29SkEE96blFdD1wmr4
         O6BqNHTnlB5kkAXK3Uk3u7tH2XlY1SMuUo+lt+VLnoIdtPOgNfBDXpwouJZseF/RWKsH
         4OcS4sYI117sgjiUH888qzv0KB3TD39bid4Sa8uPMKoJ5MFPATuh9q/OVPvbZbHpokXd
         zuZNSKppCmnWSpd5jMaUM3cl9Ba/DFZW3AWZjj+WYrzAr6eNXgDZsZV1VoLaSqG25A8U
         eVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694520319; x=1695125119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+6c2JhTji0Suck65jPMHLrMvvWMOIR1EHUZt6PSI0bQ=;
        b=eHyoYkAN4CY7aPYnbeFiX0ruBbJ/IGGgBzACo8BVT8mdqhMoYYqtzz2gkWKf9bLHxg
         ojSCJw4gJt46i+pPtHjf+bHin9CtRmAlVaD0Rgr7IpCvkIn0G336gLGIH2KJEryJu/RD
         huaEW9Pvk5dc713YPIcBJbjZxjSJSM+uBc3oEGrfyv5VPuEJx3o9DTeYvV5Pgld055Eu
         2j7iCGiYdhNjTtDsQ/Qm+CBvgcaffgEn098polLHDDwIcbinoRrbb5qRw3NULxuol239
         7Lw0dUDYhj25BfNyftvcnAczkL5jwpN72AMWfIefmyY3T+ryiuS9mJStlnJNnBxCbS4J
         0lNA==
X-Gm-Message-State: AOJu0YyqQnoiByMvCIzNQ8CGUKx+YS+pXwKXn+t3E+Wizlgm7U8jVgzQ
        pDLDkA+7PajH7tGMIXKfhmBYn+H5XBDUYB/4nJZiOXN8uew=
X-Google-Smtp-Source: AGHT+IGhLqLIe1s0yymL58Q5OKH5Rq9K6sUYABCC8bjUVvJw5RHEaaNJOrzgWb2ol102JMi3GPFoui4OoTEuUfsMcNU=
X-Received: by 2002:a05:6808:490:b0:3a8:4f87:f92c with SMTP id
 z16-20020a056808049000b003a84f87f92cmr13442418oid.44.1694520319068; Tue, 12
 Sep 2023 05:05:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694512044.git.alexl@redhat.com> <852732d9ae04ed940957a9fd2194af7a55d81c82.1694512044.git.alexl@redhat.com>
In-Reply-To: <852732d9ae04ed940957a9fd2194af7a55d81c82.1694512044.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 12 Sep 2023 15:05:07 +0300
Message-ID: <CAOQ4uxjh1Ar-qjLGJJDaCPJq9sxJUZqvGUsks=id=byKO-G0Jg@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] ovl: Support escaped overlay.* xattrs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:56=E2=80=AFPM Alexander Larsson <alexl@redhat.co=
m> wrote:
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
> "overlay.overlay.XYZ", we list it as "overlay.XYZ" in listxattrs, and
> when the user calls getxattr or setxattr on "overlay.XYZ", we apply to
> "overlay.overlay.XYZ" in the backing directories.
>
> This allows storing any kind of overlay xattrs in a overlayfs mount
> that can be used as a lowerdir in another mount. It is possible to
> stack this mechanism multiple times, such that
> "overlay.overlay.overlay.XYZ" will survive two levels of overlay mounts,
> however this is not all that useful in practice because of stack depth
> limitations of overlayfs mounts.
>
> Note: These escaped xattrs are copied to upper during copy-up.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Now I really reviewed ;-)
I like this patch - it is much smaller.

I'd rename the helper s/ovl_is_prefixed_xattr/ovl_is_own_xattr
to match ovl_own_xattr_{get,set}, but don't worry about it,
I can rename on commit.

Thanks,
Amir.

> ---
>  fs/overlayfs/overlayfs.h |  7 ++++
>  fs/overlayfs/xattrs.c    | 81 ++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 85 insertions(+), 3 deletions(-)
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
> index b8ea96606ea8..55ab56e982ea 100644
> --- a/fs/overlayfs/xattrs.c
> +++ b/fs/overlayfs/xattrs.c
> @@ -4,7 +4,19 @@
>  #include <linux/xattr.h>
>  #include "overlayfs.h"
>
> -bool ovl_is_private_xattr(struct super_block *sb, const char *name)
> +static bool ovl_is_escaped_xattr(struct super_block *sb, const char *nam=
e)
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
> +static bool ovl_is_prefixed_xattr(struct super_block *sb, const char *na=
me)
>  {
>         struct ovl_fs *ofs =3D OVL_FS(sb);
>
> @@ -16,6 +28,11 @@ bool ovl_is_private_xattr(struct super_block *sb, cons=
t char *name)
>                                OVL_XATTR_TRUSTED_PREFIX_LEN) =3D=3D 0;
>  }
>
> +bool ovl_is_private_xattr(struct super_block *sb, const char *name)
> +{
> +       return ovl_is_prefixed_xattr(sb, name) && !ovl_is_escaped_xattr(s=
b, name);
> +}
> +
>  static int ovl_xattr_set(struct dentry *dentry, struct inode *inode, con=
st char *name,
>                          const void *value, size_t size, int flags)
>  {
> @@ -97,10 +114,12 @@ static bool ovl_can_list(struct super_block *sb, con=
st char *s)
>  ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
>  {
>         struct dentry *realdentry =3D ovl_dentry_real(dentry);
> +       struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         ssize_t res;
>         size_t len;
>         char *s;
>         const struct cred *old_cred;
> +       size_t prefix_len, name_len;
>
>         old_cred =3D ovl_override_creds(dentry->d_sb);
>         res =3D vfs_listxattr(realdentry, list, size);
> @@ -108,6 +127,9 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *li=
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
> @@ -120,6 +142,12 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *l=
ist, size_t size)
>                 if (!ovl_can_list(dentry->d_sb, s)) {
>                         res -=3D slen;
>                         memmove(s, s + slen, len);
> +               } else if (ovl_is_escaped_xattr(dentry->d_sb, s)) {
> +                       res -=3D OVL_XATTR_ESCAPE_PREFIX_LEN;
> +                       name_len =3D slen - prefix_len - OVL_XATTR_ESCAPE=
_PREFIX_LEN;
> +                       s +=3D prefix_len;
> +                       memmove(s, s + OVL_XATTR_ESCAPE_PREFIX_LEN, name_=
len + len);
> +                       s +=3D name_len;
>                 } else {
>                         s +=3D slen;
>                 }
> @@ -128,11 +156,47 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *=
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
> @@ -141,7 +205,18 @@ static int ovl_own_xattr_set(const struct xattr_hand=
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
