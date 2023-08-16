Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A218C07E8B
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 18:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345602AbjHPSkl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 14:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345651AbjHPSk0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 14:40:26 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1D71B2
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 11:40:24 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id a1e0cc1a2514c-79a2216a2d1so1924892241.2
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 11:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692211224; x=1692816024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6yKglCJOFhopRTALgMGBQP/leZsH+xtSZYFiZmIFOU=;
        b=AwuH4PEnms1C7x8P4ugEf+ZXj/Kf9I/akdM+uPX17FRMeFEPJb81Jo8oJRPnPASheZ
         yBB6rgLOth8+idtnd+2SnAtuxQvB5Q4u4OezuYWP1WFG5NgY/6NCA6L/aMFvN/u6TKO+
         EhZYjbwPvGRnMrMzv/4rvO0cYzTzAwYf76tbCzKd8g6XvkAxbg1Bwb2TluftxhAWc609
         fSECV9qZ4s1CunYykfD3b5llZjjm0XMe7pOKaJG/qa/a5RLy0xc0Tp/dpoYh4U4wWh9X
         lMHK2zToCYfFb9ugd6HLfTqdLQEow+qsiQVwYgBCPQywAnbFXKR6SSnVsQDABG6V7IgT
         6hFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692211224; x=1692816024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M6yKglCJOFhopRTALgMGBQP/leZsH+xtSZYFiZmIFOU=;
        b=UGK8cCB2HRYWpIF3secFCAAKOVYY6vVsgOun7zF8iQAnQH7hLBUaPXUgFekjMdvQsn
         6jv3Mq/iH8+FBX0D3u9RHPakASIT38D8YiPVdofFvuYCCpKRD1q3njV+HrjaUpswTmIw
         wKZqtSWBVBDbMJfDEfAbe6OESVgO2GFTwhzf7VFrknzCFq/AGH+QNxHbEGjvGYEitVXE
         K+Idv6NFGdhK6em7beDLRXATGuJkw/oRKHUy+1uN75MXsv6tlIRoOqxc80ZPBn/C4Ich
         T2ylnDnQF5itBfs/tdWMReozfT0HNgLAmqVLjQ5yesLtFmOHe7jQk7udtEYFfDTdzQN9
         acfw==
X-Gm-Message-State: AOJu0Yy2HyZV+OBm8aC8N/CnfpxxBjIjqV3fKSEMezwhsPrr6faX+yxE
        NC0xkmL0rUpfzb4BN2Us7+ClVGzy9yRpZ+aMUhkoS07Pvr0=
X-Google-Smtp-Source: AGHT+IH54gtxjDCK5OWYEYuG4cSUYgOS3crn+wFHWOgVzwITPjBDlpQrkmueO9XfzqfVnEIdUlZu8cSONF+vLznLLek=
X-Received: by 2002:a67:f859:0:b0:444:c720:6181 with SMTP id
 b25-20020a67f859000000b00444c7206181mr2316963vsp.3.1692211223714; Wed, 16 Aug
 2023 11:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692198910.git.alexl@redhat.com> <debe6ded0419607c9575e72e4956b5d5f74ad63e.1692198910.git.alexl@redhat.com>
In-Reply-To: <debe6ded0419607c9575e72e4956b5d5f74ad63e.1692198910.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 16 Aug 2023 21:40:12 +0300
Message-ID: <CAOQ4uxhQy=hPKsAA3bHazVDDRCGuBiwLSo7K=JaKuUCJn9zqWA@mail.gmail.com>
Subject: Re: [PATCH 3/4] ovl: Support creation of whiteout files on overlayfs
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
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> ---
>  fs/overlayfs/dir.c       | 14 ++++++++------
>  fs/overlayfs/namei.c     | 14 +++++++++-----
>  fs/overlayfs/overlayfs.h | 13 +++++++++++++
>  fs/overlayfs/readdir.c   |  7 ++++++-
>  fs/overlayfs/super.c     |  2 +-
>  fs/overlayfs/util.c      | 20 ++++++++++++++++++++
>  6 files changed, 57 insertions(+), 13 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 033fc0458a3d..4ef3a473700c 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -199,6 +199,12 @@ struct dentry *ovl_create_real(struct ovl_fs *ofs, s=
truct inode *dir,
>                 case S_IFSOCK:
>                         err =3D ovl_do_mknod(ofs, dir, newdentry, attr->m=
ode,
>                                            attr->rdev);
> +
> +                       if (!err && S_ISCHR(attr->mode) && attr->rdev =3D=
=3D WHITEOUT_DEV) {
> +                               err =3D ovl_setxattr(ofs, newdentry, OVL_=
XATTR_NOWHITEOUT,
> +                                                  NULL, 0);
> +                       }
> +

That's not an atomic way to create an escaped whiteout.
You'd want to always take the ovl_create_over_whiteout()
branch when creating a whiteout (even if not over a positive lower)

Thanks,
Amir.

>                         break;
>
>                 case S_IFLNK:
> @@ -477,7 +483,7 @@ static int ovl_create_over_whiteout(struct dentry *de=
ntry, struct inode *inode,
>                 goto out_unlock;
>
>         err =3D -ESTALE;
> -       if (d_is_negative(upper) || !IS_WHITEOUT(d_inode(upper)))
> +       if (d_is_negative(upper) || !ovl_upper_is_whiteout(ofs, upper))
>                 goto out_dput;
>
>         newdentry =3D ovl_create_temp(ofs, workdir, cattr);
> @@ -669,10 +675,6 @@ static int ovl_mkdir(struct mnt_idmap *idmap, struct=
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
> @@ -1219,7 +1221,7 @@ static int ovl_rename(struct mnt_idmap *idmap, stru=
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
> index 1dbd01719f63..853335ff26f7 100644
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
> index 97bc94459f7a..71c650ba5a1a 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -688,7 +688,7 @@ static int ovl_check_rename_whiteout(struct ovl_fs *o=
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
