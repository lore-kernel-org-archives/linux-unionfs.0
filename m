Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C97D6EB64D8
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jun 2023 12:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjFUMYf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 08:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjFUMYc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2023 08:24:32 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46943172C
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 05:24:25 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id a1e0cc1a2514c-78f689fd0a3so1453757241.2
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 05:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687350264; x=1689942264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HvWdSBaC841Ghb3RNxuzNiMzpxyYiQULqZ4/BAetkyQ=;
        b=n2wRTd2ooFyaX4bc40+VNkgf02ad05DTeRJ/wqgcYj2mKUJae8DBb95QQn44I1FUo7
         70Mn7PEyccQCO2Rw3XZs4oZTpMI5bSZ213VvqNYDcSvxfqu4P7mxfRit95/v0CEEoyBf
         XorAsvrIPzN7GL5EcGwEQYGzplQHU/nTcDLLwY0NLgv/6IqqNgrlSvCItqAnbapnmf1+
         T/bpMEPZ+lFWctl5sx0IGCQMy53mkDYpN8kOiTNB393a1cCkSP9AtPMxP0BkWgkNPrPk
         E+nwcLsmnkCb/6C3Es2c0QH9kR7YWDrn3NbWVMXJy72aZckKT03E/wLOxYSPfnRYPn/p
         mnng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687350264; x=1689942264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HvWdSBaC841Ghb3RNxuzNiMzpxyYiQULqZ4/BAetkyQ=;
        b=MKBiMedUj5rv2kORxnB1g2S0zefnbd3XnOnBeVBhYRNCTbsR/H1Rtc/7hhRYQ1Cz2r
         /WS/hqbdA6lttK5ZhxSvEI9PqfpBGXhvc/qFy7djExRA0BLY+8Vmyf4EsGuopHTUazBQ
         iOWdUKHCCJ2vIirG8U6pDWII4C9heJVlLvyl/vBLw0X3827I9sF1r8zlDj1scnDCG/2s
         oebrXYFinXMLaQF7t9esJA5srwJ5zejuQnrj2aFw7Zq7zpG4UkxGOC25NaPBwO1I2I/X
         fsy0CMDJESWKgLy7dE/c0FgYwSZlr6ZPmlLxWvt6fyl7bcVK+3aBy0/+ziBOU7pmaorq
         1K5g==
X-Gm-Message-State: AC+VfDwiFCno7W7Y1YvL/l6Wz2rzbI5FLf07008dlUOAUz8A2xkuCgYV
        4+8T6IQ4m2Bc5on9JCn8Xed+Xfdt+t7PgmrGkcmSH7B5k9U=
X-Google-Smtp-Source: ACHHUZ7Y9MH+dG6pyzpsgHnYsjU78Mf0IGfFj8yUEo9/puUZPs5VwfuTahZv2JcJZ+dZ2IYl6pmHmDd6e8bDZTVUxK4=
X-Received: by 2002:a67:db03:0:b0:440:dbf8:b259 with SMTP id
 z3-20020a67db03000000b00440dbf8b259mr76998vsj.13.1687350264240; Wed, 21 Jun
 2023 05:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687345663.git.alexl@redhat.com> <5dfdecee8f0260729c4a8e8150587f128a731ccb.1687345663.git.alexl@redhat.com>
In-Reply-To: <5dfdecee8f0260729c4a8e8150587f128a731ccb.1687345663.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Jun 2023 15:24:12 +0300
Message-ID: <CAOQ4uximoDv_9xiDqw0AH3UCEYpF4fCkYdnCd=7QDUrVfoAnqA@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] ovl: Validate verity xattr when resolving lowerdata
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 21, 2023 at 2:18=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> The new digest field in the metacopy xattr is used during lookup to
> record whether the header contained a digest in the OVL_HAS_DIGEST
> flags.
>
> When accessing file data the first time, if OVL_HAS_DIGEST is set, we
> reload the metadata and check that the source lowerdata inode matches
> the specified digest in it (according to the enabled verity
> options). If the verity check passes we store this info in the inode
> flags as OVL_VERIFIED_DIGEST, so that we can avoid doing it again if
> the inode remains in memory.
>
> The verification is done in ovl_maybe_validate_verity() which needs to
> be called in the same places as ovl_maybe_lookup_lowerdata(), so there
> is a new ovl_verify_lowerdata() helper that calls these in the right
> order, and all current callers of ovl_maybe_lookup_lowerdata() are
> changed to call it instead.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>

Nice! looks much cleaner than v4.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


> ---
>  fs/overlayfs/copy_up.c   |  2 +-
>  fs/overlayfs/file.c      |  8 ++--
>  fs/overlayfs/namei.c     | 72 +++++++++++++++++++++++++++++++-
>  fs/overlayfs/overlayfs.h | 11 ++++-
>  fs/overlayfs/super.c     |  5 ++-
>  fs/overlayfs/util.c      | 90 ++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 180 insertions(+), 8 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 568f743a5584..68f01fd7f211 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -1078,7 +1078,7 @@ static int ovl_copy_up_flags(struct dentry *dentry,=
 int flags)
>          * not very important to optimize this case, so do lazy lowerdata=
 lookup
>          * before any copy up, so we can do it before taking ovl_inode_lo=
ck().
>          */
> -       err =3D ovl_maybe_lookup_lowerdata(dentry);
> +       err =3D ovl_verify_lowerdata(dentry);
>         if (err)
>                 return err;
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index cb53c84108fc..859a833c1035 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -115,8 +115,8 @@ static int ovl_real_fdget_meta(const struct file *fil=
e, struct fd *real,
>         if (allow_meta) {
>                 ovl_path_real(dentry, &realpath);
>         } else {
> -               /* lazy lookup of lowerdata */
> -               err =3D ovl_maybe_lookup_lowerdata(dentry);
> +               /* lazy lookup and verify of lowerdata */
> +               err =3D ovl_verify_lowerdata(dentry);
>                 if (err)
>                         return err;
>
> @@ -159,8 +159,8 @@ static int ovl_open(struct inode *inode, struct file =
*file)
>         struct path realpath;
>         int err;
>
> -       /* lazy lookup of lowerdata */
> -       err =3D ovl_maybe_lookup_lowerdata(dentry);
> +       /* lazy lookup and verify lowerdata */
> +       err =3D ovl_verify_lowerdata(dentry);
>         if (err)
>                 return err;
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 3dd480253710..d00ec43f2376 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -889,8 +889,58 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct=
 dentry *dentry,
>         return err;
>  }
>
> +static int ovl_maybe_validate_verity(struct dentry *dentry)
> +{
> +       struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
> +       struct inode *inode =3D d_inode(dentry);
> +       struct path datapath, metapath;
> +       int err;
> +
> +       if (!ofs->config.verity_mode ||
> +           !ovl_is_metacopy_dentry(dentry) ||
> +           ovl_test_flag(OVL_VERIFIED_DIGEST, inode))
> +               return 0;
> +
> +       if (!ovl_test_flag(OVL_HAS_DIGEST, inode)) {
> +               if (ofs->config.verity_mode =3D=3D OVL_VERITY_REQUIRE) {
> +                       pr_warn_ratelimited("metacopy file '%pd' has no d=
igest specified\n",
> +                                           dentry);
> +                       return -EIO;
> +               }
> +               return 0;
> +       }
> +
> +       ovl_path_lowerdata(dentry, &datapath);
> +       if (!datapath.dentry)
> +               return -EIO;
> +
> +       ovl_path_real(dentry, &metapath);
> +       if (!metapath.dentry)
> +               return -EIO;
> +
> +       err =3D ovl_inode_lock_interruptible(inode);
> +       if (err)
> +               return err;
> +
> +       if (!ovl_test_flag(OVL_VERIFIED_DIGEST, inode)) {
> +               const struct cred *old_cred;
> +
> +               old_cred =3D ovl_override_creds(dentry->d_sb);
> +
> +               err =3D ovl_validate_verity(ofs, &metapath, &datapath);
> +               if (err =3D=3D 0)
> +                       ovl_set_flag(OVL_VERIFIED_DIGEST, inode);
> +
> +               revert_creds(old_cred);
> +       }
> +
> +       ovl_inode_unlock(inode);
> +
> +       return err;
> +}
> +
>  /* Lazy lookup of lowerdata */
> -int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
> +static int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
>  {
>         struct inode *inode =3D d_inode(dentry);
>         const char *redirect =3D ovl_lowerdata_redirect(inode);
> @@ -935,6 +985,17 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dentry=
)
>         goto out;
>  }
>
> +int ovl_verify_lowerdata(struct dentry *dentry)
> +{
> +       int err;
> +
> +       err =3D ovl_maybe_lookup_lowerdata(dentry);
> +       if (err)
> +               return err;
> +
> +       return ovl_maybe_validate_verity(dentry);
> +}
> +
>  struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                           unsigned int flags)
>  {
> @@ -955,6 +1016,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct =
dentry *dentry,
>         unsigned int i;
>         int err;
>         bool uppermetacopy =3D false;
> +       int metacopy_size =3D 0;
>         struct ovl_lookup_data d =3D {
>                 .sb =3D dentry->d_sb,
>                 .name =3D dentry->d_name,
> @@ -999,6 +1061,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct =
dentry *dentry,
>
>                         if (d.metacopy)
>                                 uppermetacopy =3D true;
> +                       metacopy_size =3D d.metacopy;
>                 }
>
>                 if (d.redirect) {
> @@ -1076,6 +1139,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>                         origin =3D this;
>                 }
>
> +               if (!upperdentry && !d.is_dir && !ctr && d.metacopy)
> +                       metacopy_size =3D d.metacopy;
> +
>                 if (d.metacopy && ctr) {
>                         /*
>                          * Do not store intermediate metacopy dentries in
> @@ -1215,6 +1281,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>                 if (err < 0)
>                         goto out_free_oe;
>                 uppermetacopy =3D err;
> +               metacopy_size =3D err;
>         }
>
>         if (upperdentry || ctr) {
> @@ -1236,6 +1303,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>                         goto out_free_oe;
>                 if (upperdentry && !uppermetacopy)
>                         ovl_set_flag(OVL_UPPERDATA, inode);
> +
> +               if (metacopy_size > OVL_METACOPY_MIN_SIZE)
> +                       ovl_set_flag(OVL_HAS_DIGEST, inode);
>         }
>
>         ovl_dentry_init_reval(dentry, upperdentry, OVL_I_E(inode));
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 6d4e08df0dfe..9fbbc077643b 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -50,6 +50,8 @@ enum ovl_inode_flag {
>         OVL_UPPERDATA,
>         /* Inode number will remain constant over copy up. */
>         OVL_CONST_INO,
> +       OVL_HAS_DIGEST,
> +       OVL_VERIFIED_DIGEST,
>  };
>
>  enum ovl_entry_flag {
> @@ -513,8 +515,15 @@ void ovl_nlink_end(struct dentry *dentry);
>  int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upper=
dir);
>  int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
,
>                              struct ovl_metacopy *data);
> +int ovl_set_metacopy_xattr(struct ovl_fs *ofs, struct dentry *d,
> +                          struct ovl_metacopy *metacopy);
>  bool ovl_is_metacopy_dentry(struct dentry *dentry);
>  char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path=
, int padding);
> +int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
> +                        u8 *digest_buf, int *buf_length);
> +int ovl_validate_verity(struct ovl_fs *ofs,
> +                       struct path *metapath,
> +                       struct path *datapath);
>  int ovl_sync_status(struct ovl_fs *ofs);
>
>  static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
> @@ -634,7 +643,7 @@ struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, s=
truct ovl_fh *fh);
>  struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper=
,
>                                 struct dentry *origin, bool verify);
>  int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
> -int ovl_maybe_lookup_lowerdata(struct dentry *dentry);
> +int ovl_verify_lowerdata(struct dentry *dentry);
>  struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                           unsigned int flags);
>  bool ovl_lower_positive(struct dentry *dentry);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index a4eb9abd4b52..457a5bc439cb 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -63,6 +63,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>                                  const struct inode *inode)
>  {
>         struct dentry *real =3D NULL, *lower;
> +       int err;
>
>         /* It's an overlay file */
>         if (inode && d_inode(dentry) =3D=3D inode)
> @@ -89,7 +90,9 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>          * uprobes on offset within the file, so lowerdata should be avai=
lable
>          * when setting the uprobe.
>          */
> -       ovl_maybe_lookup_lowerdata(dentry);
> +       err =3D ovl_verify_lowerdata(dentry);
> +       if (err)
> +               goto bug;
>         lower =3D ovl_dentry_lowerdata(dentry);
>         if (!lower)
>                 goto bug;
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 921747223991..927a1133859d 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -10,6 +10,7 @@
>  #include <linux/cred.h>
>  #include <linux/xattr.h>
>  #include <linux/exportfs.h>
> +#include <linux/file.h>
>  #include <linux/fileattr.h>
>  #include <linux/uuid.h>
>  #include <linux/namei.h>
> @@ -1112,6 +1113,18 @@ int ovl_check_metacopy_xattr(struct ovl_fs *ofs, c=
onst struct path *path,
>         return res;
>  }
>
> +int ovl_set_metacopy_xattr(struct ovl_fs *ofs, struct dentry *d, struct =
ovl_metacopy *metacopy)
> +{
> +       size_t len =3D metacopy->len;
> +
> +       /* If no flags or digest fall back to empty metacopy file */
> +       if (metacopy->version =3D=3D 0 && metacopy->flags =3D=3D 0 && met=
acopy->digest_algo =3D=3D 0)
> +               len =3D 0;
> +
> +       return ovl_check_setxattr(ofs, d, OVL_XATTR_METACOPY,
> +                                 metacopy, len, -EOPNOTSUPP);
> +}
> +
>  bool ovl_is_metacopy_dentry(struct dentry *dentry)
>  {
>         struct ovl_entry *oe =3D OVL_E(dentry);
> @@ -1174,6 +1187,83 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, c=
onst struct path *path, int pa
>         return ERR_PTR(res);
>  }
>
> +/* Call with mounter creds as it may open the file */
> +static int ovl_ensure_verity_loaded(struct path *datapath)
> +{
> +       struct inode *inode =3D d_inode(datapath->dentry);
> +       const struct fsverity_info *vi;
> +       struct file *filp;
> +
> +       vi =3D fsverity_get_info(inode);
> +       if (vi =3D=3D NULL && IS_VERITY(inode)) {
> +               /*
> +                * If this inode was not yet opened, the verity info hasn=
't been
> +                * loaded yet, so we need to do that here to force it int=
o memory.
> +                */
> +               filp =3D kernel_file_open(datapath, O_RDONLY, inode, curr=
ent_cred());
> +               if (IS_ERR(filp))
> +                       return PTR_ERR(filp);
> +               fput(filp);
> +       }
> +
> +       return 0;
> +}
> +
> +int ovl_validate_verity(struct ovl_fs *ofs,
> +                       struct path *metapath,
> +                       struct path *datapath)
> +{
> +       struct ovl_metacopy metacopy_data;
> +       u8 actual_digest[FS_VERITY_MAX_DIGEST_SIZE];
> +       int xattr_digest_size, digest_size;
> +       int xattr_size, err;
> +       u8 verity_algo;
> +
> +       if (!ofs->config.verity_mode ||
> +           /* Verity only works on regular files */
> +           !S_ISREG(d_inode(metapath->dentry)->i_mode))
> +               return 0;
> +
> +       xattr_size =3D ovl_check_metacopy_xattr(ofs, metapath, &metacopy_=
data);
> +       if (xattr_size < 0)
> +               return xattr_size;
> +
> +       if (!xattr_size || !metacopy_data.digest_algo) {
> +               if (ofs->config.verity_mode =3D=3D OVL_VERITY_REQUIRE) {
> +                       pr_warn_ratelimited("metacopy file '%pd' has no d=
igest specified\n",
> +                                           metapath->dentry);
> +                       return -EIO;
> +               }
> +               return 0;
> +       }
> +
> +       xattr_digest_size =3D ovl_metadata_digest_size(&metacopy_data);
> +
> +       err =3D ovl_ensure_verity_loaded(datapath);
> +       if (err < 0) {
> +               pr_warn_ratelimited("lower file '%pd' failed to load fs-v=
erity info\n",
> +                                   datapath->dentry);
> +               return -EIO;
> +       }
> +
> +       digest_size =3D fsverity_get_digest(d_inode(datapath->dentry), ac=
tual_digest,
> +                                         &verity_algo, NULL);
> +       if (digest_size =3D=3D 0) {
> +               pr_warn_ratelimited("lower file '%pd' has no fs-verity di=
gest\n", datapath->dentry);
> +               return -EIO;
> +       }
> +
> +       if (xattr_digest_size !=3D digest_size ||
> +           metacopy_data.digest_algo !=3D verity_algo ||
> +           memcmp(metacopy_data.digest, actual_digest, xattr_digest_size=
) !=3D 0) {
> +               pr_warn_ratelimited("lower file '%pd' has the wrong fs-ve=
rity digest\n",
> +                                   datapath->dentry);
> +               return -EIO;
> +       }
> +
> +       return 0;
> +}
> +
>  /*
>   * ovl_sync_status() - Check fs sync status for volatile mounts
>   *
> --
> 2.40.1
>
