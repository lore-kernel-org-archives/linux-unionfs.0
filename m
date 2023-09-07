Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA42EC8726
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 17:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245581AbjIGR6b (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjIGR6a (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 13:58:30 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EB4199
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 10:57:59 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6bf01bcb1aeso949924a34.3
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 10:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694109479; x=1694714279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SKWhBJcDJOCl6NfEHyblJnO2xC6WQBVj2somUoKpuY4=;
        b=MRKyqSi1rn8uUwKEzMzTIItrUjcJjQDt1e8J7jB2V+VCn+YCeWUb3ngbq8//vJ36l6
         +fi4GerXvWt/rKwJ8lsS9gZg9g7C5CBuxrl0gxOIoFzsxwYSilJeqIsNeFyks+JUyWgk
         4XLf+VjYwiuglWpKNtmr/lHj4s70c0zKgEgsfzcsyHh5FqWSb65r4TIjnr7FhC0z3XSh
         oy7JO86ryWrJV27UaB8mXC9O/LOVEirVWnlb8FsYtNR/IrLdWMdtzm9yJXMFz+G+a5wc
         9BxVdlL6MbyXfwP3FYlD93nCNu9MsxHj1JPJEN0hN2pvMyGwCTLPC89XsMQ/6SEVYCmM
         Wejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694109479; x=1694714279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SKWhBJcDJOCl6NfEHyblJnO2xC6WQBVj2somUoKpuY4=;
        b=c7RIUgp2bQ/h4FyyiFXgk+rJYHkqmHbC5DhuhZrppV+yxxZm+mXWAX4BKBR6J9PmPJ
         BcIJdydhBRmhL973OdkIYpaedY3lg4k2iQlaV4HXGeBqONzyuSLlIDsqt+V91wHpzvvy
         oboqVzcCqLKV6DM4elMfCL5UYNwrE0eqn5yAKjL+xUlqV4gQCFGajA++DWjNDWpjBXXM
         dgR7LffnBTfb3ToW9juU7ljp+/+PYcEF9wKES239XWY2t1uJ/JFeEmzNDcuvQgHs3wY8
         FUNyEbtP1FS20SGmzhKQFH3mG0dAwUvz/9G7y0vi7y4AzcBDegiO2G+W7hAkSqwIwhDM
         3Y2Q==
X-Gm-Message-State: AOJu0YwMylPMaBjh7sgYWrl5o9OlfvtWHAag/OP66ew20xmXUvYc3J0w
        Lm2tQeBiHIIrEt6Km94cUlY9ZG0qvQYz/J9Sqt6ovPuJ/bA=
X-Google-Smtp-Source: AGHT+IG6DoLHQx07YaKgO88b2U7+YNFxsBJcm8kmEkyVFnZ0o4PKRWCe81FBnZ9JCFw+ID61h1DqwW8WsMzi8BQnsIA=
X-Received: by 2002:a05:6808:13d2:b0:3a8:4dfd:4f14 with SMTP id
 d18-20020a05680813d200b003a84dfd4f14mr25275176oiw.27.1694088412013; Thu, 07
 Sep 2023 05:06:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694075674.git.alexl@redhat.com> <e7e8a50a916f8f16a6ad620f53814b56d1400fa7.1694075674.git.alexl@redhat.com>
In-Reply-To: <e7e8a50a916f8f16a6ad620f53814b56d1400fa7.1694075674.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 7 Sep 2023 15:06:40 +0300
Message-ID: <CAOQ4uxiyzLQbs6cQ47_Uufnro10BwRyBZgHQNbvXik7zz7i=Jg@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] ovl: Add an alternative type of whiteout
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
> An xattr whiteout (called "xwhiteout" in the code) is a reguar file of
> zero size with the "overlay.whiteout" xattr set. A file like this in a
> directory with the "overlay.whiteouts" xattrs set will be treated the
> same way as a regular whiteout.
>
> The "overlay.whiteouts" directory xattr is used in order to
> efficiently handle overlay checks in readdir(), as we only need to
> checks xattrs in affected directories.
>
> The advantage of this kind of whiteout is that they can be escaped
> using the standard overlay xattr escaping mechanism. So, a file with a
> "overlay.overlay.whiteout" xattr would be unescaped to
> "overlay.whiteout", which could then be consumed by another overlayfs
> as a whiteout.
>
> Overlayfs itself doesn't create whiteouts like this, but a userspace
> mechanism could use this alternative mechanism to convert images that
> may contain whiteouts to be used with overlayfs.
>
> Note: To work as a whiteout for both regular overlayfs mounts as well
> as userxattr mounts both the user.overlay and the trusted.overlay
> xattr will need to be created. So, for example, when constructing the
> lowerdir for a "trusted.*" mount is should contain whiteouts with both
> "trusted.overlay.overlay.whiteout" and "user.overlay.whiteout" set.
> These will be unescaped to "trusted.overlay.whiteout" and
> "user.overlay.whiteout", which will work like a whiteout for both
> kinds of overlayfs mounts.

I find this paragraph to be over complicated.
In the context of this commit, it should be enough to say that

"To work as a whiteout for both regular overlayfs mounts as well
 as userxattr mounts both the "user.overlay.whiteout*" and the
 "trusted.overlay.whiteout*" xattrs will need to be created."

How these would look inside an escaped lowerdir in the
underlying filesystem if the layer is composed on an overlayfs mount
is way out of context here IMO.
The paragraph above that explains that the use case for the alternative
whiteout in escaped overlayfs is all the mention that's needed IMO.

Otherwise, you may add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> ---
>  fs/overlayfs/dir.c       |  4 ++--
>  fs/overlayfs/namei.c     | 15 ++++++++++-----
>  fs/overlayfs/overlayfs.h | 15 +++++++++++++++
>  fs/overlayfs/readdir.c   | 27 ++++++++++++++++++++-------
>  fs/overlayfs/super.c     |  2 +-
>  fs/overlayfs/util.c      | 40 ++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 88 insertions(+), 15 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 033fc0458a3d..e91d5cd414bd 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -477,7 +477,7 @@ static int ovl_create_over_whiteout(struct dentry *de=
ntry, struct inode *inode,
>                 goto out_unlock;
>
>         err =3D -ESTALE;
> -       if (d_is_negative(upper) || !IS_WHITEOUT(d_inode(upper)))
> +       if (d_is_negative(upper) || !ovl_upper_is_whiteout(ofs, upper))
>                 goto out_dput;
>
>         newdentry =3D ovl_create_temp(ofs, workdir, cattr);
> @@ -1219,7 +1219,7 @@ static int ovl_rename(struct mnt_idmap *idmap, stru=
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
> index 80391c687c2a..8dca5ff2a36c 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -251,7 +251,10 @@ static int ovl_lookup_single(struct dentry *base, st=
ruct ovl_lookup_data *d,
>                 err =3D -EREMOTE;
>                 goto out_err;
>         }
> -       if (ovl_is_whiteout(this)) {
> +
> +       path.dentry =3D this;
> +       path.mnt =3D d->mnt;
> +       if (ovl_path_is_whiteout(OVL_FS(d->sb), &path)) {
>                 d->stop =3D d->opaque =3D true;
>                 goto put_and_out;
>         }
> @@ -264,8 +267,6 @@ static int ovl_lookup_single(struct dentry *base, str=
uct ovl_lookup_data *d,
>                 goto put_and_out;
>         }
>
> -       path.dentry =3D this;
> -       path.mnt =3D d->mnt;
>         if (!d_can_lookup(this)) {
>                 if (d->is_dir || !last_element) {
>                         d->stop =3D true;
> @@ -438,7 +439,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ov=
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
> @@ -1383,7 +1384,11 @@ bool ovl_lower_positive(struct dentry *dentry)
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
> index 736d7f952a8e..2f5cd5f988da 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -49,6 +49,8 @@ enum ovl_xattr {
>         OVL_XATTR_UUID,
>         OVL_XATTR_METACOPY,
>         OVL_XATTR_PROTATTR,
> +       OVL_XATTR_XWHITEOUT,
> +       OVL_XATTR_XWHITEOUTS,
>  };
>
>  enum ovl_inode_flag {
> @@ -469,6 +471,7 @@ void ovl_inode_update(struct inode *inode, struct den=
try *upperdentry);
>  void ovl_dir_modified(struct dentry *dentry, bool impurity);
>  u64 ovl_inode_version_get(struct inode *inode);
>  bool ovl_is_whiteout(struct dentry *dentry);
> +bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path);
>  struct file *ovl_path_open(const struct path *path, int flags);
>  int ovl_copy_up_start(struct dentry *dentry, int flags);
>  void ovl_copy_up_end(struct dentry *dentry);
> @@ -476,9 +479,21 @@ bool ovl_already_copied_up(struct dentry *dentry, in=
t flags);
>  bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *pat=
h,
>                               enum ovl_xattr ox);
>  bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct path *=
path);
> +bool ovl_path_check_xwhiteout_xattr(struct ovl_fs *ofs, const struct pat=
h *path);
> +bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const struct pa=
th *path);
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
> index de39e067ae65..a490fc47c3e7 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -25,6 +25,7 @@ struct ovl_cache_entry {
>         struct ovl_cache_entry *next_maybe_whiteout;
>         bool is_upper;
>         bool is_whiteout;
> +       bool check_xwhiteout;
>         char name[];
>  };
>
> @@ -47,6 +48,7 @@ struct ovl_readdir_data {
>         int err;
>         bool is_upper;
>         bool d_type_supported;
> +       bool in_xwhiteouts_dir;
>  };
>
>  struct ovl_dir_file {
> @@ -162,6 +164,8 @@ static struct ovl_cache_entry *ovl_cache_entry_new(st=
ruct ovl_readdir_data *rdd,
>                 p->ino =3D 0;
>         p->is_upper =3D rdd->is_upper;
>         p->is_whiteout =3D false;
> +       /* Defer check for overlay.whiteout to ovl_iterate() */
> +       p->check_xwhiteout =3D rdd->in_xwhiteouts_dir && d_type =3D=3D DT=
_REG;
>
>         if (d_type =3D=3D DT_CHR) {
>                 p->next_maybe_whiteout =3D rdd->first_maybe_whiteout;
> @@ -301,6 +305,8 @@ static inline int ovl_dir_read(const struct path *rea=
lpath,
>         if (IS_ERR(realfile))
>                 return PTR_ERR(realfile);
>
> +       rdd->in_xwhiteouts_dir =3D rdd->dentry &&
> +               ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry->d_sb)=
, realpath);
>         rdd->first_maybe_whiteout =3D NULL;
>         rdd->ctx.pos =3D 0;
>         do {
> @@ -447,7 +453,7 @@ static u64 ovl_remap_lower_ino(u64 ino, int xinobits,=
 int fsid,
>  }
>
>  /*
> - * Set d_ino for upper entries. Non-upper entries should always report
> + * Set d_ino for upper entries if needed. Non-upper entries should alway=
s report
>   * the uppermost real inode ino and should not call this function.
>   *
>   * When not all layer are on same fs, report real ino also for upper.
> @@ -455,8 +461,11 @@ static u64 ovl_remap_lower_ino(u64 ino, int xinobits=
, int fsid,
>   * When all layers are on the same fs, and upper has a reference to
>   * copy up origin, call vfs_getattr() on the overlay entry to make
>   * sure that d_ino will be consistent with st_ino from stat(2).
> + *
> + * Also checks the overlay.whiteout xattr by doing a full lookup which w=
ill return
> + * negative in this case.
>   */
> -static int ovl_cache_update_ino(const struct path *path, struct ovl_cach=
e_entry *p)
> +static int ovl_cache_update(const struct path *path, struct ovl_cache_en=
try *p, bool update_ino)
>
>  {
>         struct dentry *dir =3D path->dentry;
> @@ -467,7 +476,7 @@ static int ovl_cache_update_ino(const struct path *pa=
th, struct ovl_cache_entry
>         int xinobits =3D ovl_xino_bits(ofs);
>         int err =3D 0;
>
> -       if (!ovl_same_dev(ofs))
> +       if (!ovl_same_dev(ofs) && !p->check_xwhiteout)
>                 goto out;
>
>         if (p->name[0] =3D=3D '.') {
> @@ -481,6 +490,7 @@ static int ovl_cache_update_ino(const struct path *pa=
th, struct ovl_cache_entry
>                         goto get;
>                 }
>         }
> +       /* This checks also for xwhiteouts */
>         this =3D lookup_one(mnt_idmap(path->mnt), p->name, dir, p->len);
>         if (IS_ERR_OR_NULL(this) || !this->d_inode) {
>                 /* Mark a stale entry */
> @@ -494,6 +504,9 @@ static int ovl_cache_update_ino(const struct path *pa=
th, struct ovl_cache_entry
>         }
>
>  get:
> +       if (!ovl_same_dev(ofs) || !update_ino)
> +               goto out;
> +
>         type =3D ovl_path_type(this);
>         if (OVL_TYPE_ORIGIN(type)) {
>                 struct kstat stat;
> @@ -572,7 +585,7 @@ static int ovl_dir_read_impure(const struct path *pat=
h,  struct list_head *list,
>         list_for_each_entry_safe(p, n, list, l_node) {
>                 if (strcmp(p->name, ".") !=3D 0 &&
>                     strcmp(p->name, "..") !=3D 0) {
> -                       err =3D ovl_cache_update_ino(path, p);
> +                       err =3D ovl_cache_update(path, p, true);
>                         if (err)
>                                 return err;
>                 }
> @@ -778,13 +791,13 @@ static int ovl_iterate(struct file *file, struct di=
r_context *ctx)
>         while (od->cursor !=3D &od->cache->entries) {
>                 p =3D list_entry(od->cursor, struct ovl_cache_entry, l_no=
de);
>                 if (!p->is_whiteout) {
> -                       if (!p->ino) {
> -                               err =3D ovl_cache_update_ino(&file->f_pat=
h, p);
> +                       if (!p->ino || p->check_xwhiteout) {
> +                               err =3D ovl_cache_update(&file->f_path, p=
, !p->ino);
>                                 if (err)
>                                         goto out;
>                         }
>                 }
> -               /* ovl_cache_update_ino() sets is_whiteout on stale entry=
 */
> +               /* ovl_cache_update() sets is_whiteout on stale entry */
>                 if (!p->is_whiteout) {
>                         if (!dir_emit(ctx, p->name, p->len, p->ino, p->ty=
pe))
>                                 break;
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
> index 89e0d60d35b6..4321c0abfd19 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -575,6 +575,16 @@ bool ovl_is_whiteout(struct dentry *dentry)
>         return inode && IS_WHITEOUT(inode);
>  }
>
> +/*
> + * Use this over ovl_is_whiteout for upper and lower files, as it also
> + * handles overlay.whiteout xattr whiteout files.
> + */
> +bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path)
> +{
> +       return ovl_is_whiteout(path->dentry) ||
> +               ovl_path_check_xwhiteout_xattr(ofs, path);
> +}
> +
>  struct file *ovl_path_open(const struct path *path, int flags)
>  {
>         struct inode *inode =3D d_inode(path->dentry);
> @@ -676,6 +686,32 @@ bool ovl_path_check_origin_xattr(struct ovl_fs *ofs,=
 const struct path *path)
>         return false;
>  }
>
> +bool ovl_path_check_xwhiteout_xattr(struct ovl_fs *ofs, const struct pat=
h *path)
> +{
> +       struct dentry *dentry =3D path->dentry;
> +       int res;
> +
> +       /* xattr.whiteout must be a zero size regular file */
> +       if (!d_is_reg(dentry) || i_size_read(d_inode(dentry)) !=3D 0)
> +               return false;
> +
> +       res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_XWHITEOUT, NULL, 0=
);
> +       return res >=3D 0;
> +}
> +
> +bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const struct pa=
th *path)
> +{
> +       struct dentry *dentry =3D path->dentry;
> +       int res;
> +
> +       /* xattr.whiteouts must be a directory */
> +       if (!d_is_dir(dentry))
> +               return false;
> +
> +       res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_XWHITEOUTS, NULL, =
0);
> +       return res >=3D 0;
> +}
> +
>  /*
>   * Load persistent uuid from xattr into s_uuid if found, or store a new
>   * random generated value in s_uuid and in xattr.
> @@ -760,6 +796,8 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, con=
st struct path *path,
>  #define OVL_XATTR_UUID_POSTFIX         "uuid"
>  #define OVL_XATTR_METACOPY_POSTFIX     "metacopy"
>  #define OVL_XATTR_PROTATTR_POSTFIX     "protattr"
> +#define OVL_XATTR_XWHITEOUT_POSTFIX    "whiteout"
> +#define OVL_XATTR_XWHITEOUTS_POSTFIX   "whiteouts"
>
>  #define OVL_XATTR_TAB_ENTRY(x) \
>         [x] =3D { [false] =3D OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
> @@ -775,6 +813,8 @@ const char *const ovl_xattr_table[][2] =3D {
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_UUID),
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
>         OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
> +       OVL_XATTR_TAB_ENTRY(OVL_XATTR_XWHITEOUT),
> +       OVL_XATTR_TAB_ENTRY(OVL_XATTR_XWHITEOUTS),
>  };
>
>  int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
> --
> 2.41.0
>
