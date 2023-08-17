Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAB4C2FC27
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 13:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbjHQNlX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351568AbjHQNk7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 09:40:59 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDA32D4A
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 06:40:54 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id ada2fe7eead31-447d394d1ebso592178137.1
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 06:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692279653; x=1692884453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RA4zoxa08uTQQEF14vGz9lZH/WVKYkK/MWXWyq6y/4=;
        b=esytggQpqJD+9LGqkHobLivISUdcH+YTROmX4IM70g+JHPveduTQsxq69JQoHVMrg1
         ut6DowHpHX5CclpZ5xNsKoNH+nSPqpAZIS82FqpLM27/QZItmreHShq18f6xx6RXW51V
         DDXf0zxnSJQajeNTF+OPmy7d/WpzUZm55HAVrAC2ZCSN0gp5T7M88h21rY2JDLHUs/WW
         fFSVjj0JhY7H4/yGzzSDMVo5bhOcHjxnpDiwcn91zFq7TvrjdmphR67iEsMU6eort3va
         0P+lG673ui8N/lRwngkLecTB6W8KudXUJKGJgGOD2xq+GHZCno+w6wrXrQowIngeRPh/
         sjeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692279653; x=1692884453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7RA4zoxa08uTQQEF14vGz9lZH/WVKYkK/MWXWyq6y/4=;
        b=PepSFjmGYStoedDtvbRnuq1v22aurXbyRexHqMr0cP6yB/NM81A+CGxjxo0AhqbP/H
         NH6OJFj7ngCelfW6TLJFJIkRNfeatn46ZvFcDMiF/5JTOUDSbVSi/XWRnUKRPSOxyVxw
         eXjqCxVuPcD7A1kSpuj5kQBmIrvTgCdDAESYEO203RKyKjsij2ItriZaEelqCc+Ok5IA
         7jLV2zzulevE7CeUaTFJme4OeSEjxQPVPngYJf8CJ+kLqnIWb/cl4DJRK/JyXAGOBX0x
         4oJuoKh879xdmDfVxoZb3X1cv2W11uPHniceaY65535ke8eXceNmBVw9k9hpjdjaeZUq
         Ajzw==
X-Gm-Message-State: AOJu0Yz/om0D1OpUDCYFM2y/no0aDCtu1P67glMl3NC9wCA504pKU7aM
        d0shWp627+zZolhJp2rGjXTfrCB/0rC06UbcPGXEeZ8Duf0=
X-Google-Smtp-Source: AGHT+IGPkh5Psjwa29aNfOmSkrJYo8qutjnqTwGQH7FG0dpim/DJm/cJi0msSg9p/aEgnzSlVAD+j8Hh+Hr6xjDzRfs=
X-Received: by 2002:a05:6102:3d23:b0:44a:c827:55c1 with SMTP id
 i35-20020a0561023d2300b0044ac82755c1mr2303862vsv.16.1692279653506; Thu, 17
 Aug 2023 06:40:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
In-Reply-To: <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Aug 2023 16:40:42 +0300
Message-ID: <CAOQ4uxjG4=Vgd+FsEWn3DqiD6hy_zKKpcQgUe4Rp7f5s61Le4w@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
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
> This is needed to properly stack overlay filesystems, I.E, being able
> to create a whiteout file on an overlay mount and then use that as
> part of the lowerdir in another overlay mount.
>
> The way this works is that we create a regular whiteout, but set the
> `overlay.nowhiteout` xattr on it. Whenever we check if a file is a
> whiteout we check this xattr and don't treat it as a whiteout if it is
> set. The xattr itself is then stripped and when viewed as part of the
> overlayfs mount it looks like a regular whiteout.
>
> In order to make the creation of the whiteout file with xattr atomic
> we always take ovl_create_over_whiteout() codepath when creating
> whiteouts.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/dir.c       | 24 +++++++++++++++++-------
>  fs/overlayfs/namei.c     | 14 +++++++++-----
>  fs/overlayfs/overlayfs.h | 13 +++++++++++++
>  fs/overlayfs/readdir.c   |  7 ++++++-
>  fs/overlayfs/super.c     |  2 +-
>  fs/overlayfs/util.c      | 20 ++++++++++++++++++++
>  6 files changed, 66 insertions(+), 14 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 033fc0458a3d..2f3442f5430d 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -442,6 +442,11 @@ static int ovl_set_upper_acl(struct ovl_fs *ofs, str=
uct dentry *upperdentry,
>         return ovl_do_set_acl(ofs, upperdentry, acl_name, acl);
>  }
>
> +static bool ovl_cattr_is_whiteout(struct ovl_cattr *attr)
> +{
> +       return S_ISCHR(attr->mode) && attr->rdev =3D=3D WHITEOUT_DEV;
> +}
> +
>  static int ovl_create_over_whiteout(struct dentry *dentry, struct inode =
*inode,
>                                     struct ovl_cattr *cattr)
>  {
> @@ -477,7 +482,8 @@ static int ovl_create_over_whiteout(struct dentry *de=
ntry, struct inode *inode,
>                 goto out_unlock;
>
>         err =3D -ESTALE;
> -       if (d_is_negative(upper) || !IS_WHITEOUT(d_inode(upper)))
> +       if (!ovl_cattr_is_whiteout(cattr) &&
> +           (d_is_negative(upper) || !ovl_upper_is_whiteout(ofs, upper)))
>                 goto out_dput;
>
>         newdentry =3D ovl_create_temp(ofs, workdir, cattr);
> @@ -485,6 +491,13 @@ static int ovl_create_over_whiteout(struct dentry *d=
entry, struct inode *inode,
>         if (IS_ERR(newdentry))
>                 goto out_dput;
>
> +       if (ovl_cattr_is_whiteout(cattr)) {
> +               err =3D ovl_setxattr(ofs, newdentry, OVL_XATTR_NOWHITEOUT=
,
> +                                  NULL, 0);
> +               if (err < 0)
> +                       goto out_cleanup;
> +       }
> +
>         /*
>          * mode could have been mutilated due to umask (e.g. sgid directo=
ry)
>          */
> @@ -606,7 +619,8 @@ static int ovl_create_or_link(struct dentry *dentry, =
struct inode *inode,
>                 put_cred(override_cred);
>         }
>
> -       if (!ovl_dentry_is_whiteout(dentry))
> +       /* Create whiteouts in workdir so we can atomically set nowiteout=
 xattr */
> +       if (!ovl_dentry_is_whiteout(dentry) && !ovl_cattr_is_whiteout(att=
r))
>                 err =3D ovl_create_upper(dentry, inode, attr);
>         else
>                 err =3D ovl_create_over_whiteout(dentry, inode, attr);
> @@ -669,10 +683,6 @@ static int ovl_mkdir(struct mnt_idmap *idmap, struct=
 inode *dir,
>  static int ovl_mknod(struct mnt_idmap *idmap, struct inode *dir,
>                      struct dentry *dentry, umode_t mode, dev_t rdev)
>  {
> -       /* Don't allow creation of "whiteout" on overlay */
> -       if (S_ISCHR(mode) && rdev =3D=3D WHITEOUT_DEV)
> -               return -EPERM;
> -
>         return ovl_create_object(dentry, mode, rdev, NULL);
>  }
>
> @@ -1219,7 +1229,7 @@ static int ovl_rename(struct mnt_idmap *idmap, stru=
ct inode *olddir,
>                 }
>         } else {
>                 if (!d_is_negative(newdentry)) {
> -                       if (!new_opaque || !ovl_is_whiteout(newdentry))
> +                       if (!new_opaque || !ovl_upper_is_whiteout(ofs, ne=
wdentry))
>                                 goto out_dput;
>                 } else {
>                         if (flags & RENAME_EXCHANGE)
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 80391c687c2a..e90167789a13 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -251,7 +251,9 @@ static int ovl_lookup_single(struct dentry *base, str=
uct ovl_lookup_data *d,
>                 err =3D -EREMOTE;
>                 goto out_err;
>         }
> -       if (ovl_is_whiteout(this)) {
> +       path.dentry =3D this;
> +       path.mnt =3D d->mnt;
> +       if (ovl_path_is_whiteout(OVL_FS(d->sb), &path)) {
>                 d->stop =3D d->opaque =3D true;
>                 goto put_and_out;
>         }
> @@ -264,8 +266,6 @@ static int ovl_lookup_single(struct dentry *base, str=
uct ovl_lookup_data *d,
>                 goto put_and_out;
>         }
>
> -       path.dentry =3D this;
> -       path.mnt =3D d->mnt;
>         if (!d_can_lookup(this)) {
>                 if (d->is_dir || !last_element) {
>                         d->stop =3D true;
> @@ -438,7 +438,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ov=
l_fh *fh, bool connected,
>         else if (IS_ERR(origin))
>                 return PTR_ERR(origin);
>
> -       if (upperdentry && !ovl_is_whiteout(upperdentry) &&
> +       if (upperdentry && !ovl_upper_is_whiteout(ofs, upperdentry) &&
>             inode_wrong_type(d_inode(upperdentry), d_inode(origin)->i_mod=
e))
>                 goto invalid;
>
> @@ -1383,7 +1383,11 @@ bool ovl_lower_positive(struct dentry *dentry)
>                                 break;
>                         }
>                 } else {
> -                       positive =3D !ovl_is_whiteout(this);
> +                       struct path path =3D {
> +                               .dentry =3D this,
> +                               .mnt =3D parentpath->layer->mnt,
> +                       };
> +                       positive =3D !ovl_path_is_whiteout(OVL_FS(dentry-=
>d_sb), &path);
>                         done =3D true;
>                         dput(this);
>                 }
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 311e1f37ce84..33d4c0011bb9 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -49,6 +49,7 @@ enum ovl_xattr {
>         OVL_XATTR_UUID,
>         OVL_XATTR_METACOPY,
>         OVL_XATTR_PROTATTR,
> +       OVL_XATTR_NOWHITEOUT,
>  };
>
>  enum ovl_inode_flag {
> @@ -469,16 +470,28 @@ void ovl_inode_update(struct inode *inode, struct d=
entry *upperdentry);
>  void ovl_dir_modified(struct dentry *dentry, bool impurity);
>  u64 ovl_inode_version_get(struct inode *inode);
>  bool ovl_is_whiteout(struct dentry *dentry);
> +bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path);
>  struct file *ovl_path_open(const struct path *path, int flags);
>  int ovl_copy_up_start(struct dentry *dentry, int flags);
>  void ovl_copy_up_end(struct dentry *dentry);
>  bool ovl_already_copied_up(struct dentry *dentry, int flags);
>  bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *pat=
h,
>                               enum ovl_xattr ox);
> +bool ovl_path_check_nowhiteout_xattr(struct ovl_fs *ofs, const struct pa=
th *path);
>  bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct path *=
path);
>  bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
>                          const struct path *upperpath);
>
> +static inline bool ovl_upper_is_whiteout(struct ovl_fs *ofs,
> +                                        struct dentry *upperdentry)
> +{
> +       struct path upperpath =3D {
> +               .dentry =3D upperdentry,
> +               .mnt =3D ovl_upper_mnt(ofs),
> +       };
> +       return ovl_path_is_whiteout(ofs, &upperpath);
> +}
> +
>  static inline bool ovl_check_origin_xattr(struct ovl_fs *ofs,
>                                           struct dentry *upperdentry)
>  {
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index de39e067ae65..9cf8e7e2961c 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -280,7 +280,12 @@ static int ovl_check_whiteouts(const struct path *pa=
th, struct ovl_readdir_data
>                         rdd->first_maybe_whiteout =3D p->next_maybe_white=
out;
>                         dentry =3D lookup_one(mnt_idmap(path->mnt), p->na=
me, dir, p->len);
>                         if (!IS_ERR(dentry)) {
> -                               p->is_whiteout =3D ovl_is_whiteout(dentry=
);
> +                               struct path childpath =3D {
> +                                       .dentry =3D dentry,
> +                                       .mnt =3D path->mnt,
> +                               };
> +                               p->is_whiteout =3D ovl_path_is_whiteout(O=
VL_FS(rdd->dentry->d_sb),
> +                                                                     &ch=
ildpath);
>                                 dput(dentry);
>                         }
>                 }
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index a3be13306c73..995c21349bb9 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -579,7 +579,7 @@ static int ovl_check_rename_whiteout(struct ovl_fs *o=
fs)
>         if (IS_ERR(whiteout))
>                 goto cleanup_temp;
>
> -       err =3D ovl_is_whiteout(whiteout);
> +       err =3D ovl_upper_is_whiteout(ofs, whiteout);
>
>         /* Best effort cleanup of whiteout and temp file */
>         if (err)
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 0f387092450e..da6d2abf64dd 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -575,6 +575,16 @@ bool ovl_is_whiteout(struct dentry *dentry)
>         return inode && IS_WHITEOUT(inode);
>  }
>
> +/*
> + * Use this over ovl_is_whiteout for upper and lower files, as it also
> + * handles escaped whiteout files.
> + */
> +bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path)
> +{
> +       return ovl_is_whiteout(path->dentry) &&
> +               !ovl_path_check_nowhiteout_xattr(ofs, path);
> +}
> +
>  struct file *ovl_path_open(const struct path *path, int flags)
>  {
>         struct inode *inode =3D d_inode(path->dentry);
> @@ -663,6 +673,14 @@ void ovl_copy_up_end(struct dentry *dentry)
>         ovl_inode_unlock(d_inode(dentry));
>  }
>
> +bool ovl_path_check_nowhiteout_xattr(struct ovl_fs *ofs, const struct pa=
th *path)
> +{
> +       int res;
> +
> +       res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_NOWHITEOUT, NULL, =
0);
> +       return res >=3D 0;
> +}
> +
>  bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct path *=
path)
>  {
>         int res;
> @@ -760,6 +778,7 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, con=
st struct path *path,
>  #define OVL_XATTR_UUID_POSTFIX         "uuid"
>  #define OVL_XATTR_METACOPY_POSTFIX     "metacopy"
>  #define OVL_XATTR_PROTATTR_POSTFIX     "protattr"
> +#define OVL_XATTR_NOWHITEOUT_POSTFIX   "nowhiteout"
>
>  #define OVL_XATTR_TAB_ENTRY(x) \
>         [x] =3D { [false] =3D OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
> @@ -775,6 +794,7 @@ const char *const ovl_xattr_table[][2] =3D {
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_UUID),
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
> +       OVL_XATTR_TAB_ENTRY(OVL_XATTR_NOWHITEOUT),
>  };
>
>  int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
> --
> 2.41.0
>
