Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A29452F62;
	Fri, 19 Jul 2024 07:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721373847; cv=none; b=Gz4PIwbn0pIwGf/H3HPehaNJ8Vkf4e69wLt1oRH2UYG509L63vtrfsw0hm+iLk6UK4pc5nLENME7DLzTRkcCgQrfkqAtfu9hEuml7sB33wa3gjKe6Qd9M3j8nO9e4IR0U9jEb1u9Uh16/kAjDo1+J3u1ogg+ZTpz4dr+q4AUzMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721373847; c=relaxed/simple;
	bh=bcG3iA9CsgccbQzWB6XPsy/r1Fiup6iaI8ERvFUJ6lY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sdc6lJpCPIOhp76KhGJ7IlFDmOo1lUDhTLVWSSXldU7I4NpPN7Szn8meGyGGMDFlZSv0WBXvFJJrJedX9TqqzROlw3nC/A255liWw/nNpM34JAdUgpciy8mNZSSWvb/eAacLDB/lkAUxyIvWtwHFb64/mMjShaeTykYoEUvR/Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DhExahyS; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhExahyS"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-79f1be45ca8so74095085a.3;
        Fri, 19 Jul 2024 00:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721373845; x=1721978645; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mhwN9PZ1L5w95E9bGybBlfTUDIiZiGAwjTzsjn1o3CE=;
        b=DhExahySERyzE6tDEB5EzUOmZPCwiPqxIBoYUwgzQ263BvrxPwt5lcn03V9/B3tYzB
         uU/hY+j2UgK7285uU0m8+b92Dg6FrpzRPCvba0gjYUmYpZC+IAp+rfkJ+Y1/pk8YtSE1
         5dj0irQyYlKWSlo6HlXe0gC6WyZjqhqHx2wNaMbuDsAFNRuHswLfywg7xypOsXKlGpuq
         RGc5l3h+iSUKVE1seunEqDpAjZ/iqqmhJmixGfW7/yQaHBGTsbz6gvTP69+Q1Unjb+A9
         btjz88yrnPaxlUOz+6vQBViKWnjpVykdXTp3seJvioVr62w82R/BcRqqirUF72jwj839
         ctTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721373845; x=1721978645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mhwN9PZ1L5w95E9bGybBlfTUDIiZiGAwjTzsjn1o3CE=;
        b=pWglmq7w4paZY8MetABuzgPQJ0+nfVFRq8zfVumEO/YO160BgRvq2p8ibiEakHUHD8
         sTOwQBL+3OLU4NDbSq6F6/X+zrI0CVfobV4ajluYCsBi48UYim/WgNd4AQGimDJZu76W
         CTaxrFgFra94kXnpcx7Tx2aLQGKOFH86ZHUYZo5wazh/5Cc6tCOnRh2x5NLkSVNUtxOV
         bWL87wZjLjgqf/3IXLzwZmZSnk4PqhlkwUp6LCO4+oyJ+FtC6jHk5hqOSTYE0JS2YMVL
         zl85aVqsow7bZB4/LoTrvweDeI6pZ5zbTxxRt6lMIe1whH0FO5kd6M/1ArK5sBsfVSmo
         ZWtw==
X-Forwarded-Encrypted: i=1; AJvYcCVidB5JnjvluPX5XApHpkrzT/PXglhT972ouKJcm+v0ClprQZXtbv8A17wqaxv5EveLQy3o/jZiMbtoEMAvjacHcp8ykNkpN+ZDOT/PArabR8Mc3cCsbvaPb5E+/MOr/2RQZk8MDHxtkTJaIg==
X-Gm-Message-State: AOJu0YwtFSyVhvLhnAT/+vog2IPv7nvIquIDQmGB09LXyVEgL2hHp9CZ
	Fpzn/0hfEk3f3JIo6f9WoHN5lClU5liNuPyMPlvfZvy5LsDy8UHMWaaW1Hs3eOCBYgMkKsKXphl
	yaf0P4FNk4oXu1olPzGdUk51wTuS1Wd4ioIg=
X-Google-Smtp-Source: AGHT+IEceFiYaf2uOCjFuiEPhz7R61Azfv4Q4tmWp1KD3dKcXMc7ZY5Jflpwe+ILbQUP11FY5AtCoqQSrJFcyT2fvaI=
X-Received: by 2002:a05:620a:4102:b0:79d:759d:4016 with SMTP id
 af79cd13be357-7a187446684mr769994585a.11.1721373844691; Fri, 19 Jul 2024
 00:24:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240718034316.29844-1-feilv@asrmicro.com>
In-Reply-To: <20240718034316.29844-1-feilv@asrmicro.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 19 Jul 2024 10:23:53 +0300
Message-ID: <CAOQ4uxgqdOHJOT--sqf-HLtur6uKyk8mh=dkKzmdf8wupCVPhw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fsync after metadata copy-up via mount option "upsync=strict"
To: Fei Lv <feilv@asrmicro.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lianghuxu@asrmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2024 at 6:43=E2=80=AFAM Fei Lv <feilv@asrmicro.com> wrote:
>
> If a directory only exist in low layer, create a new file in it trigger
> directory copy-up. Permission lost of the new directory in upper layer
> was observed during power-cut stress test.

You should specify that this outcome happens on very specific upper fs
(i.e. ubifs) which does not enforce ordering on storing of metadata
changes.

>
> Fix by adding new mount opion "upsync=3Dstrict", make sure data/metadata =
of
> copied up directory written to disk before renaming from tmp to final
> destination.
>
> Signed-off-by: Fei Lv <feilv@asrmicro.com>
> ---
> OPT_sync changed to OPT_upsync since mount option "sync" already used.

I see. I don't like the name "upsync" so much, it has other meanings
how about using the option "fsync"?

Here is a suggested documentation (which should be accompanied to any patch=
)

diff --git a/Documentation/filesystems/overlayfs.rst
b/Documentation/filesystems/overlayfs.rst
index 165514401441..f8183ddf8c4d 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -742,6 +742,42 @@ controlled by the "uuid" mount option, which
supports these values:
     mounted with "uuid=3Don".


+Durability and copy up
+----------------------
+
+The fsync(2) and fdatasync(2) system calls ensure that the metadata and da=
ta
+of a file, respectively, are safely written to the backing storage, which =
is
+expected to guarantee the existence of the information post system crash.
+
+Without the fdatasync(2) call, there is no guarantee that the observed dat=
a
+after a system crash will be either the old or the new data, but in practi=
ce,
+the observed data after crash is often the old or new data or a mix of bot=
h.
+
+When overlayfs file is modified for the first time, copy up will create a =
copy
+of the lower file and its parent directories in the upper layer.  In case =
of a
+system crash, if fdatasync(2) was not called after the modification, the u=
pper
+file could end up with no data at all (i.e. zeros), which would be an unus=
ual
+outcome.  To avoid this experience, overlayfs calls fsync(2) on the upper =
file
+before completing the copy up with rename(2) to make the copy up "atomic".
+
+Depending on the backing filesystem (e.g. ubifs), fsync(2) before rename(2=
) may
+not be enough to provide the "atomic" copy up behavior and fsync(2) on the
+copied up parent directories is required as well.
+
+Overlayfs can be tuned to prefer performance or durability when storing to=
 the
+underlying upper layer.  This is controlled by the "fsync" mount option,
+which supports these values:
+
+- "ordered": (default)
+    Call fsync(2) on upper file before completion of copy up.
+- "strict":
+    Call fsync(2) on upper file and directories before completion of copy =
up.
+- "volatile": [*]
+    Prefer performance over durability (see `Volatile mount`_)
+
+[*] The mount option "volatile" is an alias to "fsync=3Dvolatile".
+
+
 Volatile mount
 --------------

>
>  fs/overlayfs/copy_up.c   | 21 +++++++++++++++++++++
>  fs/overlayfs/ovl_entry.h | 20 ++++++++++++++++++--
>  fs/overlayfs/params.c    | 33 +++++++++++++++++++++++++++++----
>  fs/overlayfs/super.c     |  2 +-
>  4 files changed, 69 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index a5ef2005a2cc..b6f021ad7a43 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -243,6 +243,21 @@ static int ovl_verify_area(loff_t pos, loff_t pos2, =
loff_t len, loff_t totlen)
>         return 0;
>  }
>
> +static int ovl_copy_up_sync(struct path *path)
> +{
> +       struct file *new_file;
> +       int err;
> +
> +       new_file =3D ovl_path_open(path, O_LARGEFILE | O_WRONLY);

I don't think any of those O_ flags are needed for fsync.
Can a directory be opened O_WRONLY???

> +       if (IS_ERR(new_file))
> +               return PTR_ERR(new_file);
> +
> +       err =3D vfs_fsync(new_file, 0);
> +       fput(new_file);
> +
> +       return err;
> +}
> +
>  static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
>                             struct file *new_file, loff_t len)
>  {
> @@ -701,6 +716,9 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ct=
x *c, struct dentry *temp)
>                 err =3D ovl_set_attr(ofs, temp, &c->stat);
>         inode_unlock(temp->d_inode);
>
> +       if (!err && ovl_should_sync_strict(ofs))
> +               err =3D ovl_copy_up_sync(&upperpath);
> +
>         return err;
>  }
>
> @@ -1104,6 +1122,9 @@ static int ovl_copy_up_meta_inode_data(struct ovl_c=
opy_up_ctx *c)
>         ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
>         ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
>         ovl_set_upperdata(d_inode(c->dentry));
> +
> +       if (!err && ovl_should_sync_strict(ofs))
> +               err =3D ovl_copy_up_sync(&upperpath);

fsync was probably already called in ovl_copy_up_file()
making this call redundant and fsync of the removal
of metacopy xattr does not add any safety.

>  out_free:
>         kfree(capability);
>  out:
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index cb449ab310a7..4592e6f7dcf7 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -5,6 +5,12 @@
>   * Copyright (C) 2016 Red Hat, Inc.
>   */
>
> +enum {
> +       OVL_SYNC_DATA,
> +       OVL_SYNC_STRICT,
> +       OVL_SYNC_OFF,
> +};
> +
>  struct ovl_config {
>         char *upperdir;
>         char *workdir;
> @@ -18,7 +24,7 @@ struct ovl_config {
>         int xino;
>         bool metacopy;
>         bool userxattr;
> -       bool ovl_volatile;
> +       int sync_mode;
>  };
>
>  struct ovl_sb {
> @@ -120,7 +126,17 @@ static inline struct ovl_fs *OVL_FS(struct super_blo=
ck *sb)
>
>  static inline bool ovl_should_sync(struct ovl_fs *ofs)
>  {
> -       return !ofs->config.ovl_volatile;
> +       return ofs->config.sync_mode =3D=3D OVL_SYNC_DATA;

    return ofs->config.sync_mode !=3D OVL_SYNC_OFF;
or
    return ofs->config.sync_mode !=3D OVL_FSYNC_VOLATILE;

> +}
> +
> +static inline bool ovl_should_sync_strict(struct ovl_fs *ofs)
> +{
> +       return ofs->config.sync_mode =3D=3D OVL_SYNC_STRICT;
> +}
> +
> +static inline bool ovl_is_volatile(struct ovl_config *config)
> +{
> +       return config->sync_mode =3D=3D OVL_SYNC_OFF;
>  }
>
>  static inline unsigned int ovl_numlower(struct ovl_entry *oe)
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 4860fcc4611b..5d5538dd3de7 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -58,6 +58,7 @@ enum ovl_opt {
>         Opt_xino,
>         Opt_metacopy,
>         Opt_verity,
> +       Opt_upsync,
>         Opt_volatile,
>  };
>
> @@ -139,6 +140,23 @@ static int ovl_verity_mode_def(void)
>         return OVL_VERITY_OFF;
>  }
>
> +static const struct constant_table ovl_parameter_upsync[] =3D {
> +       { "data",       OVL_SYNC_DATA      },
> +       { "strict",     OVL_SYNC_STRICT    },
> +       { "off",        OVL_SYNC_OFF       },
> +       {}
> +};
> +
> +static const char *ovl_upsync_mode(struct ovl_config *config)
> +{
> +       return ovl_parameter_upsync[config->sync_mode].name;
> +}
> +
> +static int ovl_upsync_mode_def(void)
> +{
> +       return OVL_SYNC_DATA;
> +}
> +
>  const struct fs_parameter_spec ovl_parameter_spec[] =3D {
>         fsparam_string_empty("lowerdir",    Opt_lowerdir),
>         fsparam_string("lowerdir+",         Opt_lowerdir_add),
> @@ -154,6 +172,7 @@ const struct fs_parameter_spec ovl_parameter_spec[] =
=3D {
>         fsparam_enum("xino",                Opt_xino, ovl_parameter_xino)=
,
>         fsparam_enum("metacopy",            Opt_metacopy, ovl_parameter_b=
ool),
>         fsparam_enum("verity",              Opt_verity, ovl_parameter_ver=
ity),
> +       fsparam_enum("upsync",              Opt_upsync, ovl_parameter_ups=
ync),
>         fsparam_flag("volatile",            Opt_volatile),
>         {}
>  };
> @@ -617,8 +636,11 @@ static int ovl_parse_param(struct fs_context *fc, st=
ruct fs_parameter *param)
>         case Opt_verity:
>                 config->verity_mode =3D result.uint_32;
>                 break;
> +       case Opt_upsync:
> +               config->sync_mode =3D result.uint_32;
> +               break;
>         case Opt_volatile:
> -               config->ovl_volatile =3D true;
> +               config->sync_mode =3D OVL_SYNC_OFF;
>                 break;
>         case Opt_userxattr:
>                 config->userxattr =3D true;
> @@ -802,9 +824,9 @@ int ovl_fs_params_verify(const struct ovl_fs_context =
*ctx,
>                 config->index =3D false;
>         }
>
> -       if (!config->upperdir && config->ovl_volatile) {
> +       if (!config->upperdir && ovl_is_volatile(config)) {
>                 pr_info("option \"volatile\" is meaningless in a non-uppe=
r mount, ignoring it.\n");

This message would be confusing if mount option is "syncup=3Doff"
but if the option is "fsync=3Dvolatile" I think the message can stay as it =
is.

Thanks,
Amir.

> -               config->ovl_volatile =3D false;
> +               config->sync_mode =3D ovl_upsync_mode_def();
>         }
>
>         if (!config->upperdir && config->uuid =3D=3D OVL_UUID_ON) {
> @@ -997,8 +1019,11 @@ int ovl_show_options(struct seq_file *m, struct den=
try *dentry)
>         if (ofs->config.metacopy !=3D ovl_metacopy_def)
>                 seq_printf(m, ",metacopy=3D%s",
>                            ofs->config.metacopy ? "on" : "off");
> -       if (ofs->config.ovl_volatile)
> +       if (ovl_is_volatile(&ofs->config))
>                 seq_puts(m, ",volatile");
> +       else if (ofs->config.sync_mode !=3D ovl_upsync_mode_def())
> +               seq_printf(m, ",upsync=3D%s",
> +                          ovl_upsync_mode(&ofs->config));
>         if (ofs->config.userxattr)
>                 seq_puts(m, ",userxattr");
>         if (ofs->config.verity_mode !=3D ovl_verity_mode_def())
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 06a231970cb5..824cbcf40523 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -750,7 +750,7 @@ static int ovl_make_workdir(struct super_block *sb, s=
truct ovl_fs *ofs,
>          * For volatile mount, create a incompat/volatile/dirty file to k=
eep
>          * track of it.
>          */
> -       if (ofs->config.ovl_volatile) {
> +       if (ovl_is_volatile(&ofs->config)) {
>                 err =3D ovl_create_volatile_dirty(ofs);
>                 if (err < 0) {
>                         pr_err("Failed to create volatile/dirty file.\n")=
;
>
> base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
> --
> 2.45.2
>
