Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B26EB64D7
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jun 2023 12:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjFUMTG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 08:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjFUMTF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2023 08:19:05 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B094C1BD3
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 05:19:03 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a1e0cc1a2514c-78701841ccbso2224676241.2
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 05:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687349943; x=1689941943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RcG/PXVprILUelsPp+MTqIRRWQxWMSs9/fK8XM+y/xk=;
        b=kZDAWe2hJJ0/Sn2HxBIhes845ScFHo/MdKw1jNB3wsaIzKY8LaExDk0aH0D7zrvbdy
         YgwH2GY0rOUqpA8bJaX8XuqClEIfxLL85C4s7jJCO3NNYINvbk5B3DD9FWVjYN7Yx743
         o9KD9NNIahZkOtKooPDdKhFrdKPEKIGV1S9x59B2iZPgXqed2/IhGmY3n3BHEANzNcbD
         nm7JHd/r7bZGEk2jf1G0PjlFVar0yimYPv0VIBW2K8h1rrFl4eghuJuYCluKYgPMj0C+
         3IfoodYFgxCUY15GGnyLel9ZC1mVd09qEM6wz52YH+Bn8UxQjKqpqcBrpYy5vQiOkgfP
         RtVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687349943; x=1689941943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RcG/PXVprILUelsPp+MTqIRRWQxWMSs9/fK8XM+y/xk=;
        b=Vm5UZH4nTdK/QkgW/FFvQJQdB+USFYVVenDJTRu+1v7CbF2n8N0GlgKnaBbLkSbEnF
         L7eksNwRI355lkQjuKjXBvGElulIDSC6ps0GNry9GACPvGfsjucW1SpKbte89e8LL+b2
         nRPdZCrvWPND/p0E4F1LRZCU4ZfjmBmrkF/sLzeA49EaqtVsrq1WFHZnQwI81uV9MPNh
         QuwCK4Een9DN5telQUzZiZBVb5S4EXGfIi+YQc0tiEVsbbkl+CP71mryleaHPXSjywGZ
         8H90tK+0xbZ9vpWNC8OieFEiooajlEGYrfTEtoR7ea/RK17t/ffpvrp1jvbgFN2oy25g
         jSdQ==
X-Gm-Message-State: AC+VfDzNgslBvitB6wxQQDf4jlpNe2atSWeGAHpefngUj9MXCHpUH3oP
        P8KGD7pyppq35D8nemEm2n0XZCOpyJ1UoJ+eD/s=
X-Google-Smtp-Source: ACHHUZ7+GMH5ris52DFtwDkNuWAfV1UF4NeAfC0BmJ0hZUBwsT+HXcnz7K1FsWmxIDN9OBTklv0nP6oaTR9Fez3UpBQ=
X-Received: by 2002:a67:fb16:0:b0:440:b7de:1b79 with SMTP id
 d22-20020a67fb16000000b00440b7de1b79mr4937909vsr.24.1687349942654; Wed, 21
 Jun 2023 05:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687345663.git.alexl@redhat.com> <8bbfe13980cc9aa70e347811280b62eba930ffd2.1687345663.git.alexl@redhat.com>
In-Reply-To: <8bbfe13980cc9aa70e347811280b62eba930ffd2.1687345663.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Jun 2023 15:18:51 +0300
Message-ID: <CAOQ4uxhe2pqEHYtk2GEXmnOXpE4m4_2d+8yBHAyQQq-i4NiX3Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] ovl: Add framework for verity support
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
> This adds the scaffolding (docs, config, mount options) for supporting
> the new digest field in the metacopy xattr. This contains a fs-verity
> digest that need to match the fs-verity digest of the lowerdata
> file. The mount option "verity" specifies how this xattr is handled.
>
> If you enable verity ("verity=3Don") all existing xattrs are validated
> before use, and during metacopy we generate verity xattr in the upper
> metacopy file (if the source file has verity enabled). This means
> later accesses can guarantee that the same data is used.
>
> Additionally you can use "verity=3Drequire". In this mode all metacopy
> files must have a valid verity xattr. For this to work metadata
> copy-up must be able to create a verity xattr (so that later accesses
> are validated). Therefore, in this mode, if the lower data file
> doesn't have fs-verity enabled we fall back to a full copy rather than
> a metacopy.
>
> Actual implementation follows in a separate commit.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>

Looks good.
Pending ack from Eric of documentations:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


> ---
>  Documentation/filesystems/fsverity.rst  |  2 +
>  Documentation/filesystems/overlayfs.rst | 47 +++++++++++++++++++
>  fs/overlayfs/overlayfs.h                |  6 +++
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/super.c                    | 61 +++++++++++++++++++++++--
>  5 files changed, 114 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/files=
ystems/fsverity.rst
> index cb845e8e5435..13e4b18e5dbb 100644
> --- a/Documentation/filesystems/fsverity.rst
> +++ b/Documentation/filesystems/fsverity.rst
> @@ -326,6 +326,8 @@ the file has fs-verity enabled.  This can perform bet=
ter than
>  FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
>  opening the file, and opening verity files can be expensive.
>
> +.. _accessing_verity_files:
> +
>  Accessing verity files
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index eb7d2c88ddec..b63e0db03631 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -405,6 +405,53 @@ when a "metacopy" file in one of the lower layers ab=
ove it, has a "redirect"
>  to the absolute path of the "lower data" file in the "data-only" lower l=
ayer.
>
>
> +fs-verity support
> +----------------------
> +
> +During metadata copy up of a lower file, if the source file has
> +fs-verity enabled and overlay verity support is enabled, then the
> +digest of the lower file is added to the "trusted.overlay.metacopy"
> +xattr. This is then used to verify the content of the lower file
> +each the time the metacopy file is opened.
> +
> +When a layer containing verity xattrs is used, it means that any such
> +metacopy file in the upper layer is guaranteed to match the content
> +that was in the lower at the time of the copy-up. If at any time
> +(during a mount, after a remount, etc) such a file in the lower is
> +replaced or modified in any way, access to the corresponding file in
> +overlayfs will result in EIO errors (either on open, due to overlayfs
> +digest check, or from a later read due to fs-verity) and a detailed
> +error is printed to the kernel logs. For more details of how fs-verity
> +file access works, see :ref:`Documentation/filesystems/fsverity.rst
> +<accessing_verity_files>`.
> +
> +Verity can be used as a general robustness check to detect accidental
> +changes in the overlayfs directories in use. But, with additional care
> +it can also give more powerful guarantees. For example, if the upper
> +layer is fully trusted (by using dm-verity or something similar), then
> +an untrusted lower layer can be used to supply validated file content
> +for all metacopy files.  If additionally the untrusted lower
> +directories are specified as "Data-only", then they can only supply
> +such file content, and the entire mount can be trusted to match the
> +upper layer.
> +
> +This feature is controlled by the "verity" mount option, which
> +supports these values:
> +
> +- "off":
> +    The metacopy digest is never generated or used. This is the
> +    default if verity option is not specified.
> +- "on":
> +    Whenever a metacopy files specifies an expected digest, the
> +    corresponding data file must match the specified digest. When
> +    generating a metacopy file the verity digest will be set in it
> +    based on the source file (if it has one).
> +- "require":
> +    Same as "on", but additionally all metacopy files must specify a
> +    digest (or EIO is returned on open). This means metadata copy up
> +    will only be used if the data file has fs-verity enabled,
> +    otherwise a full copy-up is used.
> +
>  Sharing and copying layers
>  --------------------------
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 4142d1a457ff..cf92a9aaf934 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -70,6 +70,12 @@ enum {
>         OVL_XINO_ON,
>  };
>
> +enum {
> +       OVL_VERITY_OFF,
> +       OVL_VERITY_ON,
> +       OVL_VERITY_REQUIRE,
> +};
> +
>  /* The set of options that user requested explicitly via mount options *=
/
>  struct ovl_opt_set {
>         bool metacopy;
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 306e1ecdc96d..e999c73fb0c3 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -10,6 +10,7 @@ struct ovl_config {
>         char *workdir;
>         bool default_permissions;
>         int redirect_mode;
> +       int verity_mode;
>         bool index;
>         bool uuid;
>         bool nfs_export;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index c14c52560fd6..a4eb9abd4b52 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -366,6 +366,23 @@ static inline int ovl_xino_def(void)
>         return ovl_xino_auto_def ? OVL_XINO_AUTO : OVL_XINO_OFF;
>  }
>
> +static const struct constant_table ovl_parameter_verity[] =3D {
> +       { "off",        OVL_VERITY_OFF     },
> +       { "on",         OVL_VERITY_ON      },
> +       { "require",    OVL_VERITY_REQUIRE },
> +       {}
> +};
> +
> +static const char *ovl_verity_mode(struct ovl_config *config)
> +{
> +       return ovl_parameter_verity[config->verity_mode].name;
> +}
> +
> +static int ovl_verity_mode_def(void)
> +{
> +       return OVL_VERITY_OFF;
> +}
> +
>  /**
>   * ovl_show_options
>   * @m: the seq_file handle
> @@ -414,6 +431,9 @@ static int ovl_show_options(struct seq_file *m, struc=
t dentry *dentry)
>                 seq_puts(m, ",volatile");
>         if (ofs->config.userxattr)
>                 seq_puts(m, ",userxattr");
> +       if (ofs->config.verity_mode !=3D ovl_verity_mode_def())
> +               seq_printf(m, ",verity=3D%s",
> +                          ovl_verity_mode(&ofs->config));
>         return 0;
>  }
>
> @@ -463,6 +483,7 @@ enum {
>         Opt_xino,
>         Opt_metacopy,
>         Opt_volatile,
> +       Opt_verity,
>  };
>
>  static const struct constant_table ovl_parameter_bool[] =3D {
> @@ -487,6 +508,7 @@ static const struct fs_parameter_spec ovl_parameter_s=
pec[] =3D {
>         fsparam_enum("xino",                Opt_xino, ovl_parameter_xino)=
,
>         fsparam_enum("metacopy",            Opt_metacopy, ovl_parameter_b=
ool),
>         fsparam_flag("volatile",            Opt_volatile),
> +       fsparam_enum("verity",              Opt_verity, ovl_parameter_ver=
ity),
>         {}
>  };
>
> @@ -568,6 +590,9 @@ static int ovl_parse_param(struct fs_context *fc, str=
uct fs_parameter *param)
>         case Opt_userxattr:
>                 config->userxattr =3D true;
>                 break;
> +       case Opt_verity:
> +               config->verity_mode =3D result.uint_32;
> +               break;
>         default:
>                 pr_err("unrecognized mount option \"%s\" or missing value=
\n",
>                        param->key);
> @@ -607,6 +632,18 @@ static int ovl_fs_params_verify(const struct ovl_fs_=
context *ctx,
>                 config->ovl_volatile =3D false;
>         }
>
> +       /* Resolve verity -> metacopy dependency */
> +       if (config->verity_mode && !config->metacopy) {
> +               /* Don't allow explicit specified conflicting combination=
s */
> +               if (set.metacopy) {
> +                       pr_err("conflicting options: metacopy=3Doff,verit=
y=3D%s\n",
> +                              ovl_verity_mode(config));
> +                       return -EINVAL;
> +               }
> +               /* Otherwise automatically enable metacopy. */
> +               config->metacopy =3D true;
> +       }
> +
>         /*
>          * This is to make the logic below simpler.  It doesn't make any =
other
>          * difference, since redirect_dir=3Don is only used for upper.
> @@ -614,13 +651,18 @@ static int ovl_fs_params_verify(const struct ovl_fs=
_context *ctx,
>         if (!config->upperdir && config->redirect_mode =3D=3D OVL_REDIREC=
T_FOLLOW)
>                 config->redirect_mode =3D OVL_REDIRECT_ON;
>
> -       /* Resolve metacopy -> redirect_dir dependency */
> +       /* Resolve verity -> metacopy -> redirect_dir dependency */
>         if (config->metacopy && config->redirect_mode !=3D OVL_REDIRECT_O=
N) {
>                 if (set.metacopy && set.redirect) {
>                         pr_err("conflicting options: metacopy=3Don,redire=
ct_dir=3D%s\n",
>                                ovl_redirect_mode(config));
>                         return -EINVAL;
>                 }
> +               if (config->verity_mode && set.redirect) {
> +                       pr_err("conflicting options: verity=3D%s,redirect=
_dir=3D%s\n",
> +                              ovl_verity_mode(config), ovl_redirect_mode=
(config));
> +                       return -EINVAL;
> +               }
>                 if (set.redirect) {
>                         /*
>                          * There was an explicit redirect_dir=3D... that =
resulted
> @@ -657,7 +699,7 @@ static int ovl_fs_params_verify(const struct ovl_fs_c=
ontext *ctx,
>                 }
>         }
>
> -       /* Resolve nfs_export -> !metacopy dependency */
> +       /* Resolve nfs_export -> !metacopy && !verity dependency */
>         if (config->nfs_export && config->metacopy) {
>                 if (set.nfs_export && set.metacopy) {
>                         pr_err("conflicting options: nfs_export=3Don,meta=
copy=3Don\n");
> @@ -670,6 +712,14 @@ static int ovl_fs_params_verify(const struct ovl_fs_=
context *ctx,
>                          */
>                         pr_info("disabling nfs_export due to metacopy=3Do=
n\n");
>                         config->nfs_export =3D false;
> +               } else if (config->verity_mode) {
> +                       /*
> +                        * There was an explicit verity=3D.. that resulte=
d
> +                        * in this conflict.
> +                        */
> +                       pr_info("disabling nfs_export due to verity=3D%s\=
n",
> +                               ovl_verity_mode(config));
> +                       config->nfs_export =3D false;
>                 } else {
>                         /*
>                          * There was an explicit nfs_export=3Don that res=
ulted
> @@ -681,7 +731,7 @@ static int ovl_fs_params_verify(const struct ovl_fs_c=
ontext *ctx,
>         }
>
>
> -       /* Resolve userxattr -> !redirect && !metacopy dependency */
> +       /* Resolve userxattr -> !redirect && !metacopy && !verity depende=
ncy */
>         if (config->userxattr) {
>                 if (set.redirect &&
>                     config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW) {
> @@ -693,6 +743,11 @@ static int ovl_fs_params_verify(const struct ovl_fs_=
context *ctx,
>                         pr_err("conflicting options: userxattr,metacopy=
=3Don\n");
>                         return -EINVAL;
>                 }
> +               if (config->verity_mode) {
> +                       pr_err("conflicting options: userxattr,verity=3D%=
s\n",
> +                              ovl_verity_mode(config));
> +                       return -EINVAL;
> +               }
>                 /*
>                  * Silently disable default setting of redirect and metac=
opy.
>                  * This shall be the default in the future as well: these
> --
> 2.40.1
>
