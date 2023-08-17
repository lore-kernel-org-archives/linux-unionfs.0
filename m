Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA42C2FC1F
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 12:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350939AbjHQMsv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 08:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350975AbjHQMsh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 08:48:37 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA19B2D78
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 05:48:34 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id 71dfb90a1353d-488f2add3deso906951e0c.3
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 05:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692276514; x=1692881314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKNtvlvRVUyYUC4ln5Sog+Pw7t3XwLg3rWyz6B7GlCQ=;
        b=ilkbdN5xw0wIQSs1gvuG5STf828CXxQWbdiI/fwxFzYJuXT9iEk9lzwcxNh85bh3kT
         F7inZCe/68EoezyYc+FH3t6VIgLobdL9cPe5uaw4PLZzqF1K5llPL/HcEsGl896aEWkp
         08nMQI8Ldvlq6yDVzlFEFb718sCj1yRsr8hX893ifzpm4vucBohjFMPZnz3rHSY/CxCd
         jG5bbSo/Q0x7ua+GzD7ez2TU7WZveWXoZukRQ/KF1qWqrYRQx5eVyP89AlW5JXqy1CkP
         SrmGlnsXfqgHWNYjCl2eD1lGbAQJ1Lf3VlUJkI+CIf/8JZSH64Zx9rG5fjZ0z7KzbPFD
         gRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692276514; x=1692881314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKNtvlvRVUyYUC4ln5Sog+Pw7t3XwLg3rWyz6B7GlCQ=;
        b=PkTIF0DDeBrnNckxyGs5eAkmgi3PQRkDJ0wESJZNFIJRJ0UGJgl5XPY/vv4Dwhucu4
         i6x23pBIT/4E6svFansEBOTGaKjEavei8yDva/WGGqhZYSqOjBpufIHG5MItlmk6euRV
         Qw/T4b5VHor5E8gS6umzJ2yU/H8tmR/mdMFMJG+BSuU8ahOO9NdJBHoMGY/zYzSqf1pN
         u/rdZIbJgS+LS/ScKAJl39bvtdRz1kozaOKSWmkQVhNoDyg6jGX6d/RbzFBgiRpV5gee
         zn4jVuimp6J+nM33G+SlcsKyx6nFoBa88CqKwSqSyVCMubj8P1w7DxJKzP0f438xDKgx
         RaSg==
X-Gm-Message-State: AOJu0Yx3JEpzNPb3D8QRV5e+gMNlPGEYyMRm/BFHaq3rtyyOmr94SeD0
        lpKmjdWqevp/oLZvwBTUDXJwoQgJRClFB49HyvKwdtnIvSY=
X-Google-Smtp-Source: AGHT+IH85Ei5gmTQf6s7HRC6Unnc2J+pLD9dCJQYy3hu4wK6pUuE2UlOhJS2gnHSa5fTd/ECNxkjJe5GUdZrhV3SqBg=
X-Received: by 2002:a67:af11:0:b0:443:7170:b048 with SMTP id
 v17-20020a67af11000000b004437170b048mr3695639vsl.27.1692276513881; Thu, 17
 Aug 2023 05:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <681cd83a4835ae8517ed156374a67b12f7b4a861.1692270188.git.alexl@redhat.com>
In-Reply-To: <681cd83a4835ae8517ed156374a67b12f7b4a861.1692270188.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Aug 2023 15:48:22 +0300
Message-ID: <CAOQ4uxiwPs7NVchjX_YdKB4pNOWdpK+qQAeT9WpXijHZZL6Jxg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: Move xattr support to new xattrs.c file
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
> This moves the code from from super.c and inode.c, and makes
> ovl_xattr_get/set() static.
>
> This is in preparation for doing more work on xattrs support.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>

Thanks for this cleanup!

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/Makefile    |   2 +-
>  fs/overlayfs/inode.c     | 124 ------------------------
>  fs/overlayfs/overlayfs.h |  18 ++--
>  fs/overlayfs/super.c     |  65 +------------
>  fs/overlayfs/xattrs.c    | 198 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 209 insertions(+), 198 deletions(-)
>  create mode 100644 fs/overlayfs/xattrs.c
>
> diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
> index 4e173d56b11f..5648954f8588 100644
> --- a/fs/overlayfs/Makefile
> +++ b/fs/overlayfs/Makefile
> @@ -6,4 +6,4 @@
>  obj-$(CONFIG_OVERLAY_FS) +=3D overlay.o
>
>  overlay-objs :=3D super.o namei.o util.o inode.o file.o dir.o readdir.o =
\
> -               copy_up.o export.o params.o
> +               copy_up.o export.o params.o xattrs.o
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index b395cd84bfce..375edf832641 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -339,130 +339,6 @@ static const char *ovl_get_link(struct dentry *dent=
ry,
>         return p;
>  }
>
> -bool ovl_is_private_xattr(struct super_block *sb, const char *name)
> -{
> -       struct ovl_fs *ofs =3D OVL_FS(sb);
> -
> -       if (ofs->config.userxattr)
> -               return strncmp(name, OVL_XATTR_USER_PREFIX,
> -                              sizeof(OVL_XATTR_USER_PREFIX) - 1) =3D=3D =
0;
> -       else
> -               return strncmp(name, OVL_XATTR_TRUSTED_PREFIX,
> -                              sizeof(OVL_XATTR_TRUSTED_PREFIX) - 1) =3D=
=3D 0;
> -}
> -
> -int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char=
 *name,
> -                 const void *value, size_t size, int flags)
> -{
> -       int err;
> -       struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> -       struct dentry *upperdentry =3D ovl_i_dentry_upper(inode);
> -       struct dentry *realdentry =3D upperdentry ?: ovl_dentry_lower(den=
try);
> -       struct path realpath;
> -       const struct cred *old_cred;
> -
> -       err =3D ovl_want_write(dentry);
> -       if (err)
> -               goto out;
> -
> -       if (!value && !upperdentry) {
> -               ovl_path_lower(dentry, &realpath);
> -               old_cred =3D ovl_override_creds(dentry->d_sb);
> -               err =3D vfs_getxattr(mnt_idmap(realpath.mnt), realdentry,=
 name, NULL, 0);
> -               revert_creds(old_cred);
> -               if (err < 0)
> -                       goto out_drop_write;
> -       }
> -
> -       if (!upperdentry) {
> -               err =3D ovl_copy_up(dentry);
> -               if (err)
> -                       goto out_drop_write;
> -
> -               realdentry =3D ovl_dentry_upper(dentry);
> -       }
> -
> -       old_cred =3D ovl_override_creds(dentry->d_sb);
> -       if (value) {
> -               err =3D ovl_do_setxattr(ofs, realdentry, name, value, siz=
e,
> -                                     flags);
> -       } else {
> -               WARN_ON(flags !=3D XATTR_REPLACE);
> -               err =3D ovl_do_removexattr(ofs, realdentry, name);
> -       }
> -       revert_creds(old_cred);
> -
> -       /* copy c/mtime */
> -       ovl_copyattr(inode);
> -
> -out_drop_write:
> -       ovl_drop_write(dentry);
> -out:
> -       return err;
> -}
> -
> -int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char=
 *name,
> -                 void *value, size_t size)
> -{
> -       ssize_t res;
> -       const struct cred *old_cred;
> -       struct path realpath;
> -
> -       ovl_i_path_real(inode, &realpath);
> -       old_cred =3D ovl_override_creds(dentry->d_sb);
> -       res =3D vfs_getxattr(mnt_idmap(realpath.mnt), realpath.dentry, na=
me, value, size);
> -       revert_creds(old_cred);
> -       return res;
> -}
> -
> -static bool ovl_can_list(struct super_block *sb, const char *s)
> -{
> -       /* Never list private (.overlay) */
> -       if (ovl_is_private_xattr(sb, s))
> -               return false;
> -
> -       /* List all non-trusted xattrs */
> -       if (strncmp(s, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) !=
=3D 0)
> -               return true;
> -
> -       /* list other trusted for superuser only */
> -       return ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
> -}
> -
> -ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
> -{
> -       struct dentry *realdentry =3D ovl_dentry_real(dentry);
> -       ssize_t res;
> -       size_t len;
> -       char *s;
> -       const struct cred *old_cred;
> -
> -       old_cred =3D ovl_override_creds(dentry->d_sb);
> -       res =3D vfs_listxattr(realdentry, list, size);
> -       revert_creds(old_cred);
> -       if (res <=3D 0 || size =3D=3D 0)
> -               return res;
> -
> -       /* filter out private xattrs */
> -       for (s =3D list, len =3D res; len;) {
> -               size_t slen =3D strnlen(s, len) + 1;
> -
> -               /* underlying fs providing us with an broken xattr list? =
*/
> -               if (WARN_ON(slen > len))
> -                       return -EIO;
> -
> -               len -=3D slen;
> -               if (!ovl_can_list(dentry->d_sb, s)) {
> -                       res -=3D slen;
> -                       memmove(s, s + slen, len);
> -               } else {
> -                       s +=3D slen;
> -               }
> -       }
> -
> -       return res;
> -}
> -
>  #ifdef CONFIG_FS_POSIX_ACL
>  /*
>   * Apply the idmapping of the layer to POSIX ACLs. The caller must pass =
a clone
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 72f57d919aa9..1283b7126b94 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -684,17 +684,8 @@ int ovl_set_nlink_lower(struct dentry *dentry);
>  unsigned int ovl_get_nlink(struct ovl_fs *ofs, struct dentry *lowerdentr=
y,
>                            struct dentry *upperdentry,
>                            unsigned int fallback);
> -int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> -               struct iattr *attr);
> -int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
> -               struct kstat *stat, u32 request_mask, unsigned int flags)=
;
>  int ovl_permission(struct mnt_idmap *idmap, struct inode *inode,
>                    int mask);
> -int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char=
 *name,
> -                 const void *value, size_t size, int flags);
> -int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char=
 *name,
> -                 void *value, size_t size);
> -ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
>
>  #ifdef CONFIG_FS_POSIX_ACL
>  struct posix_acl *do_ovl_get_acl(struct mnt_idmap *idmap,
> @@ -830,3 +821,12 @@ static inline bool ovl_force_readonly(struct ovl_fs =
*ofs)
>  {
>         return (!ovl_upper_mnt(ofs) || !ofs->workdir);
>  }
> +
> +/* xattr.c */
> +
> +const struct xattr_handler **ovl_xattr_handlers(struct ovl_fs *ofs);
> +int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +               struct iattr *attr);
> +int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
> +               struct kstat *stat, u32 request_mask, unsigned int flags)=
;
> +ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index def266b5e2a3..a3be13306c73 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -434,68 +434,6 @@ static bool ovl_workdir_ok(struct dentry *workdir, s=
truct dentry *upperdir)
>         return ok;
>  }
>
> -static int ovl_own_xattr_get(const struct xattr_handler *handler,
> -                            struct dentry *dentry, struct inode *inode,
> -                            const char *name, void *buffer, size_t size)
> -{
> -       return -EOPNOTSUPP;
> -}
> -
> -static int ovl_own_xattr_set(const struct xattr_handler *handler,
> -                            struct mnt_idmap *idmap,
> -                            struct dentry *dentry, struct inode *inode,
> -                            const char *name, const void *value,
> -                            size_t size, int flags)
> -{
> -       return -EOPNOTSUPP;
> -}
> -
> -static int ovl_other_xattr_get(const struct xattr_handler *handler,
> -                              struct dentry *dentry, struct inode *inode=
,
> -                              const char *name, void *buffer, size_t siz=
e)
> -{
> -       return ovl_xattr_get(dentry, inode, name, buffer, size);
> -}
> -
> -static int ovl_other_xattr_set(const struct xattr_handler *handler,
> -                              struct mnt_idmap *idmap,
> -                              struct dentry *dentry, struct inode *inode=
,
> -                              const char *name, const void *value,
> -                              size_t size, int flags)
> -{
> -       return ovl_xattr_set(dentry, inode, name, value, size, flags);
> -}
> -
> -static const struct xattr_handler ovl_own_trusted_xattr_handler =3D {
> -       .prefix =3D OVL_XATTR_TRUSTED_PREFIX,
> -       .get =3D ovl_own_xattr_get,
> -       .set =3D ovl_own_xattr_set,
> -};
> -
> -static const struct xattr_handler ovl_own_user_xattr_handler =3D {
> -       .prefix =3D OVL_XATTR_USER_PREFIX,
> -       .get =3D ovl_own_xattr_get,
> -       .set =3D ovl_own_xattr_set,
> -};
> -
> -static const struct xattr_handler ovl_other_xattr_handler =3D {
> -       .prefix =3D "", /* catch all */
> -       .get =3D ovl_other_xattr_get,
> -       .set =3D ovl_other_xattr_set,
> -};
> -
> -static const struct xattr_handler *ovl_trusted_xattr_handlers[] =3D {
> -       &ovl_own_trusted_xattr_handler,
> -       &ovl_other_xattr_handler,
> -       NULL
> -};
> -
> -static const struct xattr_handler *ovl_user_xattr_handlers[] =3D {
> -       &ovl_own_user_xattr_handler,
> -       &ovl_other_xattr_handler,
> -       NULL
> -};
> -
>  static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
>                           struct inode **ptrap, const char *name)
>  {
> @@ -1478,8 +1416,7 @@ int ovl_fill_super(struct super_block *sb, struct f=
s_context *fc)
>         cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
>
>         sb->s_magic =3D OVERLAYFS_SUPER_MAGIC;
> -       sb->s_xattr =3D ofs->config.userxattr ? ovl_user_xattr_handlers :
> -               ovl_trusted_xattr_handlers;
> +       sb->s_xattr =3D ovl_xattr_handlers(ofs);
>         sb->s_fs_info =3D ofs;
>         sb->s_flags |=3D SB_POSIXACL;
>         sb->s_iflags |=3D SB_I_SKIP_SYNC | SB_I_IMA_UNVERIFIABLE_SIGNATUR=
E;
> diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
> new file mode 100644
> index 000000000000..edc7cc49a7c4
> --- /dev/null
> +++ b/fs/overlayfs/xattrs.c
> @@ -0,0 +1,198 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/fs.h>
> +#include <linux/xattr.h>
> +#include "overlayfs.h"
> +
> +bool ovl_is_private_xattr(struct super_block *sb, const char *name)
> +{
> +       struct ovl_fs *ofs =3D OVL_FS(sb);
> +
> +       if (ofs->config.userxattr)
> +               return strncmp(name, OVL_XATTR_USER_PREFIX,
> +                              sizeof(OVL_XATTR_USER_PREFIX) - 1) =3D=3D =
0;
> +       else
> +               return strncmp(name, OVL_XATTR_TRUSTED_PREFIX,
> +                              sizeof(OVL_XATTR_TRUSTED_PREFIX) - 1) =3D=
=3D 0;
> +}
> +
> +static int ovl_xattr_set(struct dentry *dentry, struct inode *inode, con=
st char *name,
> +                        const void *value, size_t size, int flags)
> +{
> +       int err;
> +       struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> +       struct dentry *upperdentry =3D ovl_i_dentry_upper(inode);
> +       struct dentry *realdentry =3D upperdentry ?: ovl_dentry_lower(den=
try);
> +       struct path realpath;
> +       const struct cred *old_cred;
> +
> +       err =3D ovl_want_write(dentry);
> +       if (err)
> +               goto out;
> +
> +       if (!value && !upperdentry) {
> +               ovl_path_lower(dentry, &realpath);
> +               old_cred =3D ovl_override_creds(dentry->d_sb);
> +               err =3D vfs_getxattr(mnt_idmap(realpath.mnt), realdentry,=
 name, NULL, 0);
> +               revert_creds(old_cred);
> +               if (err < 0)
> +                       goto out_drop_write;
> +       }
> +
> +       if (!upperdentry) {
> +               err =3D ovl_copy_up(dentry);
> +               if (err)
> +                       goto out_drop_write;
> +
> +               realdentry =3D ovl_dentry_upper(dentry);
> +       }
> +
> +       old_cred =3D ovl_override_creds(dentry->d_sb);
> +       if (value) {
> +               err =3D ovl_do_setxattr(ofs, realdentry, name, value, siz=
e,
> +                                     flags);
> +       } else {
> +               WARN_ON(flags !=3D XATTR_REPLACE);
> +               err =3D ovl_do_removexattr(ofs, realdentry, name);
> +       }
> +       revert_creds(old_cred);
> +
> +       /* copy c/mtime */
> +       ovl_copyattr(inode);
> +
> +out_drop_write:
> +       ovl_drop_write(dentry);
> +out:
> +       return err;
> +}
> +
> +static int ovl_xattr_get(struct dentry *dentry, struct inode *inode, con=
st char *name,
> +                        void *value, size_t size)
> +{
> +       ssize_t res;
> +       const struct cred *old_cred;
> +       struct path realpath;
> +
> +       ovl_i_path_real(inode, &realpath);
> +       old_cred =3D ovl_override_creds(dentry->d_sb);
> +       res =3D vfs_getxattr(mnt_idmap(realpath.mnt), realpath.dentry, na=
me, value, size);
> +       revert_creds(old_cred);
> +       return res;
> +}
> +
> +static bool ovl_can_list(struct super_block *sb, const char *s)
> +{
> +       /* Never list private (.overlay) */
> +       if (ovl_is_private_xattr(sb, s))
> +               return false;
> +
> +       /* List all non-trusted xattrs */
> +       if (strncmp(s, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) !=
=3D 0)
> +               return true;
> +
> +       /* list other trusted for superuser only */
> +       return ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
> +}
> +
> +ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
> +{
> +       struct dentry *realdentry =3D ovl_dentry_real(dentry);
> +       ssize_t res;
> +       size_t len;
> +       char *s;
> +       const struct cred *old_cred;
> +
> +       old_cred =3D ovl_override_creds(dentry->d_sb);
> +       res =3D vfs_listxattr(realdentry, list, size);
> +       revert_creds(old_cred);
> +       if (res <=3D 0 || size =3D=3D 0)
> +               return res;
> +
> +       /* filter out private xattrs */
> +       for (s =3D list, len =3D res; len;) {
> +               size_t slen =3D strnlen(s, len) + 1;
> +
> +               /* underlying fs providing us with an broken xattr list? =
*/
> +               if (WARN_ON(slen > len))
> +                       return -EIO;
> +
> +               len -=3D slen;
> +               if (!ovl_can_list(dentry->d_sb, s)) {
> +                       res -=3D slen;
> +                       memmove(s, s + slen, len);
> +               } else {
> +                       s +=3D slen;
> +               }
> +       }
> +
> +       return res;
> +}
> +
> +static int ovl_own_xattr_get(const struct xattr_handler *handler,
> +                            struct dentry *dentry, struct inode *inode,
> +                            const char *name, void *buffer, size_t size)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static int ovl_own_xattr_set(const struct xattr_handler *handler,
> +                            struct mnt_idmap *idmap,
> +                            struct dentry *dentry, struct inode *inode,
> +                            const char *name, const void *value,
> +                            size_t size, int flags)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static int ovl_other_xattr_get(const struct xattr_handler *handler,
> +                              struct dentry *dentry, struct inode *inode=
,
> +                              const char *name, void *buffer, size_t siz=
e)
> +{
> +       return ovl_xattr_get(dentry, inode, name, buffer, size);
> +}
> +
> +static int ovl_other_xattr_set(const struct xattr_handler *handler,
> +                              struct mnt_idmap *idmap,
> +                              struct dentry *dentry, struct inode *inode=
,
> +                              const char *name, const void *value,
> +                              size_t size, int flags)
> +{
> +       return ovl_xattr_set(dentry, inode, name, value, size, flags);
> +}
> +
> +static const struct xattr_handler ovl_own_trusted_xattr_handler =3D {
> +       .prefix =3D OVL_XATTR_TRUSTED_PREFIX,
> +       .get =3D ovl_own_xattr_get,
> +       .set =3D ovl_own_xattr_set,
> +};
> +
> +static const struct xattr_handler ovl_own_user_xattr_handler =3D {
> +       .prefix =3D OVL_XATTR_USER_PREFIX,
> +       .get =3D ovl_own_xattr_get,
> +       .set =3D ovl_own_xattr_set,
> +};
> +
> +static const struct xattr_handler ovl_other_xattr_handler =3D {
> +       .prefix =3D "", /* catch all */
> +       .get =3D ovl_other_xattr_get,
> +       .set =3D ovl_other_xattr_set,
> +};
> +
> +static const struct xattr_handler *ovl_trusted_xattr_handlers[] =3D {
> +       &ovl_own_trusted_xattr_handler,
> +       &ovl_other_xattr_handler,
> +       NULL
> +};
> +
> +static const struct xattr_handler *ovl_user_xattr_handlers[] =3D {
> +       &ovl_own_user_xattr_handler,
> +       &ovl_other_xattr_handler,
> +       NULL
> +};
> +
> +const struct xattr_handler **ovl_xattr_handlers(struct ovl_fs *ofs)
> +{
> +       return ofs->config.userxattr ? ovl_user_xattr_handlers :
> +               ovl_trusted_xattr_handlers;
> +}
> +
> --
> 2.41.0
>
