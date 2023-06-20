Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C4EEB64D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 12:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjFTMly (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 08:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjFTMlx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 08:41:53 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D47210F0
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 05:41:51 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id a1e0cc1a2514c-78f628079eeso1052200241.1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 05:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687264910; x=1689856910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+pGGh1WBBl1BloYHsK+Z47Awu245Jrer09gTZXUqo6k=;
        b=oYkken0MTwizR5ulehDU+5YVJWCC4+vE5+16KZxA/d/Po0eSHc0WHmWO+eaNUaZEYg
         GBHfP84wY/xWqTBlPY4REdILBSARqTr2E0hFwVsKOmgJAZzWSy0do/wTElDW8qsQg0xQ
         /WtHMz/IAiNhiP7GylcbkIAIhHsKYOJXZzgPWL4HfsJylyy5rJyV+Rl0AJEmknlEemO5
         MnqtFy0DSJNVYu6PUwPwC5G2w0G9cPUitw8206r7V9oXCDWPmb75piRQYoRRpd9O6xy9
         Zda3Jzp+yb+uXlLKll0aKxg6Qh1kHDhi1A0SqQuh1uOrIWd/9rtjD4THUsDCUX08yXll
         Y7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687264910; x=1689856910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+pGGh1WBBl1BloYHsK+Z47Awu245Jrer09gTZXUqo6k=;
        b=XYLqpYSSUT9C4oKOEllJnsP+HfOBgNgWWBf7sQGQ2VpaPUaTB2IR8AIj+80rBmrmQG
         1v6/J7MPZV01EA++yIq+lamNBFJcgS+BOr00jjpmcWWq8HGCUO2B4wq5VlVY/1kOEWdE
         kBZG1bpFbyO/MdX2euKPpFbTiPubBmNE3TBrAWlpI9Pc/OWj3cqqBTHDvJ78UhYKUlwb
         XAbOxf6dradVMnE9k8bUZghBJxjWqTrxlRhHupngPYGzF/VEtdhKBluRnM/vgrTWAaf1
         hLP+TSe5BZX/D/J37aNmA7VY8BKQYpK2OegmvlzxpT5cX7jpP3h8fQr56GY4v7d2REL5
         SFsw==
X-Gm-Message-State: AC+VfDw65nWFQ4ZgVRtoUz4WIok5vXQlATLyA9AYo++KQhmX6K/Yjqos
        RVHnmrRgaqw8zfQyQxzi8PbOOymCQCLeOxKr/qg=
X-Google-Smtp-Source: ACHHUZ5N+WW1Ws24bAYNS7J+H8fZ/GyDIZTfW4cxE2+aqq0cbIFjUphFleNwfe/f4ID2Af1SC9o6Wxea67EQCT7yeU8=
X-Received: by 2002:a67:fe01:0:b0:43b:4b0a:1349 with SMTP id
 l1-20020a67fe01000000b0043b4b0a1349mr4452098vsr.14.1687264910444; Tue, 20 Jun
 2023 05:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687255035.git.alexl@redhat.com> <42967a7766fe73deca9ab9412923e11df1ceef50.1687255035.git.alexl@redhat.com>
In-Reply-To: <42967a7766fe73deca9ab9412923e11df1ceef50.1687255035.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 20 Jun 2023 15:41:39 +0300
Message-ID: <CAOQ4uxgqVRch9z+EKBL_JsR6Q8wm+v8VPQxB18gBoJ4rfRSy=A@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] ovl: Add framework for verity support
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
> This adds the scaffolding (docs, config, mount options) for supporting
> the new digest field in the metacopy xattr. This which contains a
> fs-verity digest that need to match the actual fs-verity digest of the
> lowerdata file. The mount option "verity" specifies how this xattr is
> handled.
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
> ---
>  Documentation/filesystems/fsverity.rst  |  2 +
>  Documentation/filesystems/overlayfs.rst | 48 +++++++++++++++++++
>  fs/overlayfs/overlayfs.h                |  7 +++
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/super.c                    | 64 ++++++++++++++++++++++---
>  5 files changed, 116 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/files=
ystems/fsverity.rst
> index ede672dedf11..b3ba548e7b86 100644
> --- a/Documentation/filesystems/fsverity.rst
> +++ b/Documentation/filesystems/fsverity.rst
> @@ -324,6 +324,8 @@ the file has fs-verity enabled.  This can perform bet=
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
> index eb7d2c88ddec..b639d9efe9ae 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -405,6 +405,54 @@ when a "metacopy" file in one of the lower layers ab=
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
> +"trusted.overlay.verity" xattr

outdated old format

> is set on the new metacopy file. This
> +specifies the expected fs-verity digest of the lowerdata file, which
> +is used to verify the content of the lower file at the time the
> +metacopy file is opened.
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
> +    The verity xattr is never used. This is the default if verity
> +    option is not specified.
> +- "on":
> +    Whenever a metacopy files specifies an expected digest, the
> +    corresponding data file must match the specified digest.
> +    When generating a metacopy file the verity xattr will be set
> +    from the source file fs-verity digest (if it has one).
> +- "require":
> +    Same as "on", but additionally all metacopy files must specify a
> +    verity xattr. This means metadata copy up will only be used if
> +    the data file has fs-verity enabled, otherwise a full copy-up is
> +    used.
> +
>  Sharing and copying layers
>  --------------------------
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 5b6ac03af192..7414d6d8fb1c 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -70,12 +70,19 @@ enum {
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
>         bool redirect;
>         bool nfs_export;
>         bool index;
> +       bool verity;

There is no need for that because there is no kconfig/module
option to enable verity and we never implicitly enable verity
because of some other option...

>  };
>
>  /*
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
> index ed4b35c9d647..3f8bbd158a2a 100644
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
> @@ -557,6 +579,10 @@ static int ovl_parse_param(struct fs_context *fc, st=
ruct fs_parameter *param)
>         case Opt_userxattr:
>                 config->userxattr =3D true;
>                 break;
> +       case Opt_verity:
> +               config->verity_mode =3D result.uint_32;
> +               ctx->set.verity =3D true;

...so config->verity_mode is enough for all the conflict checks...

> +               break;
>         default:
>                 pr_err("unrecognized mount option \"%s\" or missing value=
\n",
>                        param->key);
> @@ -596,6 +622,18 @@ static int ovl_fs_params_verify(const struct ovl_fs_=
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

Nice :)

I think the comments below should be changed to clarify
the indirect dependency that they also check for, e.g.:

        /* Resolve verity -> metacopy -> redirect_dir dependency */


>         /*
>          * This is to make the logic below simpler.  It doesn't make any =
other
>          * difference, since redirect_dir=3Don is only used for upper.
> @@ -610,11 +648,12 @@ static int ovl_fs_params_verify(const struct ovl_fs=
_context *ctx,
>                                ovl_redirect_mode(config));
>                         return -EINVAL;
>                 }
> +               if (set.verity && set.redirect) {
> +                       pr_err("conflicting options: verity=3D%s,redirect=
_dir=3D%s\n",

verity=3Doff,redirect=3D... is never a conflict
so the correct condition is (config->verity_mode && set.redirect)

> +                              ovl_verity_mode(config), ovl_redirect_mode=
(config));
> +                       return -EINVAL;
> +               }
>                 if (set.redirect) {
> -                       /*
> -                        * There was an explicit redirect_dir=3D... that =
resulted
> -                        * in this conflict.
> -                        */
>                         pr_info("disabling metacopy due to redirect_dir=
=3D%s\n",
>                                 ovl_redirect_mode(config));
>                         config->metacopy =3D false;
> @@ -646,7 +685,7 @@ static int ovl_fs_params_verify(const struct ovl_fs_c=
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
> @@ -659,6 +698,14 @@ static int ovl_fs_params_verify(const struct ovl_fs_=
context *ctx,
>                          */
>                         pr_info("disabling nfs_export due to metacopy=3Do=
n\n");
>                         config->nfs_export =3D false;
> +               } else if (set.verity) {

} else if (config->nfs_export && config->verity_mode) {

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
> @@ -670,7 +717,7 @@ static int ovl_fs_params_verify(const struct ovl_fs_c=
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
> @@ -682,6 +729,11 @@ static int ovl_fs_params_verify(const struct ovl_fs_=
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

This one looks right :)

Thanks,
Amir.
