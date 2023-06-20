Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF12EB64D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 13:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbjFTNvl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 09:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbjFTNvS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 09:51:18 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A019019AD
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 06:50:49 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id ada2fe7eead31-4301281573aso1112086137.3
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 06:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687269048; x=1689861048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WB+O7ncSMFZb2c8pbqwwUyV5RZxHCB5r2hqVVQc9c5A=;
        b=HISyKVZi0Eh2+nIImmOb3u6lU8dmCXZSJgufZtlXVVG8vwCcX1uNRH5ziPw2elA/Lc
         nFfIS+Z9nFWnFQfiHAZcfzMBfUdlptRGHdzD6dbJmeV/338jYLRUvNzFL51BQ2XiTbmH
         AjTnOYTO6W10V/agMk9azq8GrECruQexc/GKOipdi9Dqi4DE24VvF9WoqdwxfSPPaQJ5
         pHOQ8+oBzibrha5KYLrx8iEDEqvw96kFOt20F28SiRd0YOM0kidhWGcxP4fMOyRYnFh2
         hf/JROGQ99gS0SSCUUAGRJSzcyqdvfPQH5s/aSL8Yu11bPO2DjtmHMUV6LMwHhLfDuvm
         6z3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687269048; x=1689861048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WB+O7ncSMFZb2c8pbqwwUyV5RZxHCB5r2hqVVQc9c5A=;
        b=c4A4nCIKMm2Qw1f95BeXMAUrElnFH6Xa6qAHSgUEeobDemicZszmhqFvSRcSpAJczr
         uFQU1luvMyXVlFFiwJ0UDgAMdjKVdG7D8bPeq8kHVITuaGoeoshBZMqOQY/xJoZ4TBAj
         5ZMEF9Dsib7o/pVm7CROXGkq/iexOKIuo9e4IF8kJHycgXMvVfgyJMMrVwTRVEh8dY56
         1tajkxU/DKopBuJjnyssDxG3NN3T8T6LuroTa2wDSKR5AaYYyL2vQ1480nHXOtAAfC6r
         2ysjvAn3ysnCr9xG6QXhdytdjkt206tASGJuXVgGzuRykQTpgeK4pgm0QIOhIN48YfNp
         bI3g==
X-Gm-Message-State: AC+VfDxG2wtLF06fnScOR+ZIBSV6PXG7nIrR5XURN5lsW7Esac2S9bkK
        68lnLfAI9eNfVKV6ajB+QFrFC9wC4MOqAM2jbXe9548C4zs=
X-Google-Smtp-Source: ACHHUZ71WrBmTpYYmOxdGMIFMEr7/zjOhRq3mIbtBsc3lloSzu0omrtNw++i1Zjmj6/Bzd8dLGSR6rn27Rs4ZuGlv7k=
X-Received: by 2002:a67:f4d6:0:b0:43b:2cad:759e with SMTP id
 s22-20020a67f4d6000000b0043b2cad759emr3162234vsn.10.1687269048052; Tue, 20
 Jun 2023 06:50:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687255035.git.alexl@redhat.com> <41928d51510a72b97c257574a61d2bcc3aff49d1.1687255035.git.alexl@redhat.com>
In-Reply-To: <41928d51510a72b97c257574a61d2bcc3aff49d1.1687255035.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 20 Jun 2023 16:50:36 +0300
Message-ID: <CAOQ4uxjNVSX8J8wJz-8-LuUoXrNVzutfpnAHK-gat9kfj+ijtA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] ovl: Validate verity xattr when resolving lowerdata
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 20, 2023 at 1:15=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> The metacopy xattr is extended from currently empty to a versioned
> header with length, flags and an optional digest. During lookup we
> record whether the header contained a digest in the OVL_HAS_DIGEST
> flags.
>
> When accessing file data the first time, if OVL_HAS_DIGEST is set, we
> reload the metadata and that the source lowerdata inode matches the
> specified digest in it (according to the enabled verity options). If
> the verity check passes we store this info in the inode flags as
> OVL_VERIFIED_DIGEST, so that we can avoid doing it again if the inode
> remains in memory.
>
> The verification is done in ovl_maybe_validate_verity() which needs to
> be called in the same places as ovl_maybe_lookup_lowerdata(), so there
> is a new ovl_verify_lowerdata() helper that calls these in the right
> order, and all current callers of ovl_maybe_lookup_lowerdata() are
> changed to call it instead.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>

Thanks for the on-disk format change.
Overall looking good
some small comments below

> ---
>  fs/overlayfs/copy_up.c   |   2 +-
>  fs/overlayfs/file.c      |   8 +--
>  fs/overlayfs/namei.c     |  97 +++++++++++++++++++++++++++---
>  fs/overlayfs/overlayfs.h |  43 ++++++++++---
>  fs/overlayfs/super.c     |   5 +-
>  fs/overlayfs/util.c      | 126 +++++++++++++++++++++++++++++++++++++--
>  6 files changed, 256 insertions(+), 25 deletions(-)
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
> index 39737c2aaa84..6583d08fdb7a 100644
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
> index 57adf911735f..0ba8266a8125 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -26,6 +26,7 @@ struct ovl_lookup_data {
>         bool last;
>         char *redirect;
>         bool metacopy;
> +       bool metacopy_digest;

This extra bool state is not needed.
What I meant was:
-         bool metacopy;
-         int metacopy;

to be used as tristate:
0 - no metacopy
=3D OVL_METACOPY_MIN_SIZE - metacopy without digest
> OVL_METACOPY_MIN_SIZE - metacopy with digest

propagated all the way up
and then...

>         /* Referring to last redirect xattr */
>         bool absolute_redirect;
>  };
> @@ -233,6 +234,7 @@ static int ovl_lookup_single(struct dentry *base, str=
uct ovl_lookup_data *d,
>  {
>         struct dentry *this;
>         struct path path;
> +       int metacopy_size;
>         int err;
>         bool last_element =3D !post[0];
>
> @@ -270,11 +272,14 @@ static int ovl_lookup_single(struct dentry *base, s=
truct ovl_lookup_data *d,
>                         d->stop =3D true;
>                         goto put_and_out;
>                 }
> -               err =3D ovl_check_metacopy_xattr(OVL_FS(d->sb), &path);
> -               if (err < 0)
> +               metacopy_size =3D ovl_check_metacopy_xattr(OVL_FS(d->sb),=
 &path, NULL);
> +               if (metacopy_size < 0) {
> +                       err =3D metacopy_size;
>                         goto out_err;
> +               }
>
> -               d->metacopy =3D err;
> +               d->metacopy =3D metacopy_size;
> +               d->metacopy_digest =3D d->metacopy && metacopy_size > OVL=
_METACOPY_MIN_SIZE;

No need for the above changes at all...

>                 d->stop =3D !d->metacopy;
>                 if (!d->metacopy || d->last)
>                         goto out;
> @@ -889,8 +894,59 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct=
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
> +       if (ovl_test_flag(OVL_HAS_DIGEST, inode) &&
> +           !ovl_test_flag(OVL_VERIFIED_DIGEST, inode)) {
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
> @@ -935,6 +991,17 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dentry=
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
> @@ -952,9 +1019,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>         bool upperopaque =3D false;
>         char *upperredirect =3D NULL;
>         struct dentry *this;
> +       int metacopy_size;
>         unsigned int i;
>         int err;
>         bool uppermetacopy =3D false;
> +       bool metacopy_digest =3D false;

I think this can be rebranded as
int metacopy_size =3D 0;

which refers to any topmost metacopy either lower or upper.

>         struct ovl_lookup_data d =3D {
>                 .sb =3D dentry->d_sb,
>                 .name =3D dentry->d_name,
> @@ -964,6 +1033,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct =
dentry *dentry,
>                 .last =3D ovl_redirect_follow(ofs) ? false : !ovl_numlowe=
r(poe),
>                 .redirect =3D NULL,
>                 .metacopy =3D false,
> +               .metacopy_digest =3D false,
>         };
>
>         if (dentry->d_name.len > ofs->namelen)
> @@ -997,8 +1067,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>                         if (err)
>                                 goto out_put_upper;
>
> -                       if (d.metacopy)
> +                       if (d.metacopy) {
>                                 uppermetacopy =3D true;
> +                               metacopy_digest =3D d.metacopy_digest;
> +                       }

... this would just be (no need for if)
metacopy_size =3D d.metacopy;

>                 }
>
>                 if (d.redirect) {
> @@ -1076,6 +1148,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>                         origin =3D this;
>                 }
>
> +               if (!upperdentry && !d.is_dir && !ctr && d.metacopy)
> +                       metacopy_digest =3D d.metacopy_digest;

Same here also (because it is distinguished from positive upperdentry case)=
:
                            metacopy_size =3D d.metacopy;

> +
>                 if (d.metacopy && ctr) {
>                         /*
>                          * Do not store intermediate metacopy dentries in
> @@ -1211,10 +1286,13 @@ struct dentry *ovl_lookup(struct inode *dir, stru=
ct dentry *dentry,
>                         upperredirect =3D NULL;
>                         goto out_free_oe;
>                 }
> -               err =3D ovl_check_metacopy_xattr(ofs, &upperpath);
> -               if (err < 0)
> +               metacopy_size =3D ovl_check_metacopy_xattr(ofs, &upperpat=
h, NULL);
> +               if (metacopy_size < 0) {
> +                       err =3D metacopy_size;
>                         goto out_free_oe;
> -               uppermetacopy =3D err;
> +               }
> +               uppermetacopy =3D metacopy_size;
> +               metacopy_digest =3D metacopy_size >  OVL_METACOPY_MIN_SIZ=
E;

Same here.
No need for the rest of the changes.

>         }
>
>         if (upperdentry || ctr) {
> @@ -1236,6 +1314,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>                         goto out_free_oe;
>                 if (upperdentry && !uppermetacopy)
>                         ovl_set_flag(OVL_UPPERDATA, inode);
> +
> +               if ((uppermetacopy || ctr > 1) && metacopy_digest)

Unless I am mistaken this simply becomes:

                     if (metacopy_size >  OVL_METACOPY_MIN_SIZE)
> +                       ovl_set_flag(OVL_HAS_DIGEST, inode);
>         }
>
>         ovl_dentry_init_reval(dentry, upperdentry, OVL_I_E(inode));
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 7414d6d8fb1c..c2213a8ad16e 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -7,6 +7,7 @@
>  #include <linux/kernel.h>
>  #include <linux/uuid.h>
>  #include <linux/fs.h>
> +#include <linux/fsverity.h>
>  #include <linux/namei.h>
>  #include <linux/posix_acl.h>
>  #include <linux/posix_acl_xattr.h>
> @@ -49,6 +50,8 @@ enum ovl_inode_flag {
>         OVL_UPPERDATA,
>         /* Inode number will remain constant over copy up. */
>         OVL_CONST_INO,
> +       OVL_HAS_DIGEST,
> +       OVL_VERIFIED_DIGEST,
>  };
>
>  enum ovl_entry_flag {
> @@ -141,6 +144,24 @@ struct ovl_fh {
>  #define OVL_FH_FID_OFFSET      (OVL_FH_WIRE_OFFSET + \
>                                  offsetof(struct ovl_fb, fid))
>
> +/* On-disk format for "metacopy" xattr (if non-zero size) */
> +struct ovl_metacopy {
> +       u8 version;     /* 0 */
> +       u8 len;         /* size of this header, not including unused dige=
st bytes */

len is including the used digest bytes, so above it tad confusing
maybe /* size of this header + used digest bytes */ ?

> +       u8 flags;
> +       u8 digest_algo; /* FS_VERITY_HASH_ALG_* constant, 0 for no digest=
 */
> +       u8 digest[FS_VERITY_MAX_DIGEST_SIZE];  /* Only the used part on d=
isk */
> +} __packed;
> +
> +#define OVL_METACOPY_MAX_SIZE (sizeof(struct ovl_metacopy))
> +#define OVL_METACOPY_MIN_SIZE (OVL_METACOPY_MAX_SIZE - FS_VERITY_MAX_DIG=
EST_SIZE)
> +#define OVL_METACOPY_INIT { 0, OVL_METACOPY_MIN_SIZE }
> +
> +static inline int ovl_metadata_digest_size(const struct ovl_metacopy *me=
tacopy)
> +{
> +       return (int)metacopy->len - OVL_METACOPY_MIN_SIZE;

Please fortify that to return 0 for len < OVL_METACOPY_MIN_SIZE

> +}
> +
>  extern const char *const ovl_xattr_table[][2];
>  static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr o=
x)
>  {
> @@ -241,7 +262,7 @@ static inline ssize_t ovl_do_getxattr(const struct pa=
th *path, const char *name,
>         WARN_ON(path->dentry->d_sb !=3D path->mnt->mnt_sb);
>
>         err =3D vfs_getxattr(mnt_idmap(path->mnt), path->dentry,
> -                              name, value, size);
> +                          name, value, size);
>         len =3D (value && err > 0) ? err : 0;
>
>         pr_debug("getxattr(%pd2, \"%s\", \"%*pE\", %zu, 0) =3D %i\n",
> @@ -263,9 +284,9 @@ static inline ssize_t ovl_getxattr_upper(struct ovl_f=
s *ofs,
>  }
>
>  static inline ssize_t ovl_path_getxattr(struct ovl_fs *ofs,
> -                                        const struct path *path,
> -                                        enum ovl_xattr ox, void *value,
> -                                        size_t size)
> +                                       const struct path *path,
> +                                       enum ovl_xattr ox, void *value,
> +                                       size_t size)
>  {
>         return ovl_do_getxattr(path, ovl_xattr(ofs, ox), value, size);
>  }
> @@ -352,7 +373,7 @@ static inline struct file *ovl_do_tmpfile(struct ovl_=
fs *ofs,
>  {
>         struct path path =3D { .mnt =3D ovl_upper_mnt(ofs), .dentry =3D d=
entry };
>         struct file *file =3D vfs_tmpfile_open(ovl_upper_mnt_idmap(ofs), =
&path, mode,
> -                                       O_LARGEFILE | O_WRONLY, current_c=
red());
> +                                            O_LARGEFILE | O_WRONLY, curr=
ent_cred());
>         int err =3D PTR_ERR_OR_ZERO(file);
>
>         pr_debug("tmpfile(%pd2, 0%o) =3D %i\n", dentry, mode, err);
> @@ -490,9 +511,17 @@ bool ovl_need_index(struct dentry *dentry);
>  int ovl_nlink_start(struct dentry *dentry);
>  void ovl_nlink_end(struct dentry *dentry);
>  int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upper=
dir);
> -int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
);
> +int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
,
> +                            struct ovl_metacopy *data);
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
> @@ -612,7 +641,7 @@ struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, s=
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
> index 3f8bbd158a2a..2175e64d3b64 100644
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
> index 7ef9e13c404a..66448964f753 100644
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
> @@ -1054,8 +1055,9 @@ int ovl_lock_rename_workdir(struct dentry *workdir,=
 struct dentry *upperdir)
>         return -EIO;
>  }
>
> -/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
> -int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
)
> +/* err < 0, 0 if no metacopy xattr, metacopy data size if xattr found */

I guess we should document the emulated size return value.
Something like, "an empty xattr returns OVL_METACOPY_MIN_SIZE to
distinguish from no xattr value".

> +int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path=
,
> +                            struct ovl_metacopy *data)
>  {
>         int res;
>
> @@ -1063,7 +1065,8 @@ int ovl_check_metacopy_xattr(struct ovl_fs *ofs, co=
nst struct path *path)
>         if (!S_ISREG(d_inode(path->dentry)->i_mode))
>                 return 0;
>
> -       res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_METACOPY, NULL, 0)=
;
> +       res =3D ovl_path_getxattr(ofs, path, OVL_XATTR_METACOPY,
> +                               data, data ? OVL_METACOPY_MAX_SIZE : 0);
>         if (res < 0) {
>                 if (res =3D=3D -ENODATA || res =3D=3D -EOPNOTSUPP)
>                         return 0;
> @@ -1077,12 +1080,48 @@ int ovl_check_metacopy_xattr(struct ovl_fs *ofs, =
const struct path *path)
>                 goto out;
>         }
>
> -       return 1;
> +       if (res =3D=3D 0) {
> +               /* Emulate empty data for zero size metacopy xattr */
> +               res =3D OVL_METACOPY_MIN_SIZE;
> +               if (data) {
> +                       memset(data, 0, res);
> +                       data->len =3D res;
> +               }
> +       } else if (res < OVL_METACOPY_MIN_SIZE) {
> +               pr_warn_ratelimited("metacopy file '%pd' has too small xa=
ttr\n",
> +                                   path->dentry);
> +               return -EIO;
> +       } else if (data) {
> +               if (data->version !=3D 0) {
> +                       pr_warn_ratelimited("metacopy file '%pd' has unsu=
pported version\n",
> +                                           path->dentry);
> +                       return -EIO;
> +               }
> +               if (res !=3D data->len) {
> +                       pr_warn_ratelimited("metacopy file '%pd' has inva=
lid xattr size\n",
> +                                           path->dentry);
> +                       return -EIO;
> +               }
> +       }
> +
> +       return res;
>  out:
>         pr_warn_ratelimited("failed to get metacopy (%i)\n", res);
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
> @@ -1145,6 +1184,85 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, c=
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
> +                * We use open_with_fake_path to avoid ENFILE.
> +                */
> +               filp =3D open_with_fake_path(datapath, O_RDONLY, inode, c=
urrent_cred());

You will also need to rebase on top of Christian's vfs.all branch in linux-=
next
where this helper is split into two different helpers.
You should use kernel_file_open() (same arguments).

For convenience, you can rebase on top of the 'next' branch in my
github which collects the vfs+fsnotify+fsverity+ovl branches from
linux-next ) or use a local branch of your own that does the same.


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
> +       u8 verity_algo;
> +       int xattr_digest_size;
> +       int digest_size;
> +       int err;
> +
> +       if (!ofs->config.verity_mode ||
> +           /* Verity only works on regular files */
> +           !S_ISREG(d_inode(metapath->dentry)->i_mode))
> +               return 0;
> +
> +       err =3D ovl_check_metacopy_xattr(ofs, metapath, &metacopy_data);
> +       if (err < 0)
> +               return err;
> +
> +       if (err =3D=3D 0 || metacopy_data.digest_algo =3D=3D 0) {

To me !metacopy_data.digest_algo reads nicer
but I will not insist.

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

As I promised, just some small comments ;-)

Thanks,
Amir.
