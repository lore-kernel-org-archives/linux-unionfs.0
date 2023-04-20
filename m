Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF69EC77B72
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 08:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbjDTIkF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 04:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbjDTIjw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 04:39:52 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C0340C7
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 01:39:47 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id a1e0cc1a2514c-771d9ec5aa5so1312424241.0
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 01:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681979986; x=1684571986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SD17R47OkxboxfnjBjDccew2cSCqa1XXZ0JxDkWS52o=;
        b=bWpkjC+2FtRGRy15JfdTN9NITvc+rs6aoP+b7i2radDfDG0oHoPBssLvxovfWENLbx
         jtokm+oVFwbjgANc6n6Ux5EadqZUjCYK4cQbYpk6BdwfKZOOnHFiKsPhDSZ1mMLXlgy6
         PMipovjnsYvTPX5GMOUE4cJW5fHOMCXhwlih8eoMu+E4kLHcSKNoMe/M1LZosFVNxk5v
         gArPWHdvGHrzu71Ns7CHVdCWVIorDVeHcdTleCcxKCkCXDpQg9sdjCXe8yJZSsG1xI3c
         yjXfpIZaUZZv5kNf3caMK05aArqRU2pdVQ91lSO7Fo+bB6S9LPDv6PLaoBmk3PO9oTYH
         GDTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681979986; x=1684571986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SD17R47OkxboxfnjBjDccew2cSCqa1XXZ0JxDkWS52o=;
        b=V91bXJZAhBkgCrGDmzh+WMII6pmwUcP+uDTIak7iB03hvVGIOtpPUFEWJX3CgQBYaZ
         8xDH6CQVVMK702fa+zeJ577dERdz3d4MbIkefyS0u0ejSfZ2AjQpqo47u/UEcQmucwn6
         6ZeOfG77wiVkUWUW5eGuZi+o5mbw0fcNU5g7z+gBpPHl7bpUQKx7piAoI/lkHJ9mjeWj
         Y93tB8fXdQU9rOp6xkLUctll4pDad935xtsJPSB1UpdwD1YVVlcM5fR+RrpjIc0Fya9z
         c5ygTC+h8GhjMsAeBOGmBoH/6KXbAr4Ctp/77DMDJ9n37SAD4nx1aPLTYQQLIeRranj0
         xefA==
X-Gm-Message-State: AAQBX9dVq0edtiIPAh4bnJp8nXHc4uH8Fk6Z6Q0BEUAx36v2qBoDERBf
        jG8Y45CRwwUCoSgufJ5J8HAoMB85AjQ5OkYhodg5ZaGKWSU=
X-Google-Smtp-Source: AKy350b/h5kRgligMh/liP/OUAHtdKnf6rArSCZ1zYDDGL17r3pKFxZIn5FSPzzXExRXcFGJ71e9lSZl/4FvgKvaXrg=
X-Received: by 2002:a9f:305a:0:b0:73f:f15b:d9e3 with SMTP id
 i26-20020a9f305a000000b0073ff15bd9e3mr352788uab.0.1681979985809; Thu, 20 Apr
 2023 01:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681917551.git.alexl@redhat.com> <2b2c5ecaf80f810f46791a94d8638ec4027a3a0e.1681917551.git.alexl@redhat.com>
In-Reply-To: <2b2c5ecaf80f810f46791a94d8638ec4027a3a0e.1681917551.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 20 Apr 2023 11:39:34 +0300
Message-ID: <CAOQ4uxj14qKWbz7j2Ynvoj5fBhiw-B2A9XA8AOE28kOus=RVKQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] ovl: Add framework for verity support
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 20, 2023 at 10:44=E2=80=AFAM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> This adds the scaffolding (docs, config, mount options) for supporting
> for a new overlay xattr "overlay.verity", which contains a fs-verity
> digest. This is used for metacopy files, and the actual fs-verity
> digest of the lowerdata file needs to match it. The mount option
> "verity" specifies how this xattrs is handled.
>
> Unless you explicitly disable it ("verity=3Doff") all existing xattrs
> are validated before use. This is all that happens by default
> ("verity=3Dvalidate"), but, if you turn on verity ("verity=3Don") then
> during metacopy we generate verity xattr in the upper metacopy file if
> the source file has verity enabled. This means later accesses can
> guarantee that the correct data is used.
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
>  Documentation/filesystems/overlayfs.rst | 33 +++++++++++++++++
>  fs/overlayfs/Kconfig                    | 14 +++++++
>  fs/overlayfs/ovl_entry.h                |  4 ++
>  fs/overlayfs/super.c                    | 49 +++++++++++++++++++++++++
>  4 files changed, 100 insertions(+)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index c8e04a4f0e21..66895bf71cd1 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -403,6 +403,39 @@ when a "metacopy" file in one of the lower layers ab=
ove it, has a "redirect"
>  to the absolute path of the "lower data" file in the "data-only" lower l=
ayer.
>
>
> +fs-verity support
> +----------------------
> +
> +When metadata copy up is used for a file, then the xattr
> +"trusted.overlay.verity" may be set on the metacopy file. This
> +specifies the expected fs-verity digest of the lowerdata file. This
> +may then be used to verify the content of the source file at the time
> +the file is opened. If enabled, overlayfs can also set this xattr
> +during metadata copy up.
> +
> +This is controlled by the "verity" mount option, which supports
> +these values:
> +
> +- "off":
> +    The verity xattr is never used.
> +- "validate":
> +    Whenever a metacopy files specifies an expected digest, the
> +    corresponding data file must match the specified digest.
> +- "on":
> +    Same as validate, but additionally, when generating a metacopy
> +    file the verity xattr will be set from the source file fs-verity
> +    digest (if it has one).
> +- "require":
> +    Same as "on", but additionally all metacopy files must specify a
> +    verity xattr. Additionally metadata copy up will only be used if
> +    the data file has fs-verity enabled, otherwise a full copy-up is
> +    used.
> +
> +There are two ways to tune the default behaviour. The kernel config
> +option OVERLAY_FS_VERITY, or the module option "verity=3DBOOL". If
> +either of these are enabled, then verity mode is "on" by default,
> +otherwise it is "validate".
> +
>  Sharing and copying layers
>  --------------------------
>
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 6708e54b0e30..98d6b1a7baf5 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -124,3 +124,17 @@ config OVERLAY_FS_METACOPY
>           that doesn't support this feature will have unexpected results.
>
>           If unsure, say N.
> +
> +config OVERLAY_FS_VERITY
> +       bool "Overlayfs: turn on verity feature by default"
> +       depends on OVERLAY_FS
> +       depends on OVERLAY_FS_METACOPY
> +       help
> +         If this config option is enabled then overlay filesystems will
> +         try to copy fs-verity digests from the lower file into the
> +         metacopy file at metadata copy-up time. It is still possible
> +         to turn off this feature globally with the "verity=3Doff"
> +         module option or on a filesystem instance basis with the
> +         "verity=3Doff" or "verity=3Dvalidate" mount option.
> +
> +         If unsure, say N.
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index a7b1006c5321..f759e476dfc7 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -13,6 +13,10 @@ struct ovl_config {
>         bool redirect_dir;
>         bool redirect_follow;
>         const char *redirect_mode;
> +       bool verity_validate;
> +       bool verity_generate;
> +       bool verity_require;
> +       const char *verity_mode;
>         bool index;
>         bool uuid;
>         bool nfs_export;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index ef78abc21998..953d76f6a1e3 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -59,6 +59,11 @@ module_param_named(metacopy, ovl_metacopy_def, bool, 0=
644);
>  MODULE_PARM_DESC(metacopy,
>                  "Default to on or off for the metadata only copy up feat=
ure");
>
> +static bool ovl_verity_def =3D IS_ENABLED(CONFIG_OVERLAY_FS_VERITY);
> +module_param_named(verity, ovl_verity_def, bool, 0644);
> +MODULE_PARM_DESC(verity,
> +                "Default to on or validate for the metadata only copy up=
 feature");
> +
>  static struct dentry *ovl_d_real(struct dentry *dentry,
>                                  const struct inode *inode)
>  {
> @@ -235,6 +240,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>         kfree(ofs->config.upperdir);
>         kfree(ofs->config.workdir);
>         kfree(ofs->config.redirect_mode);
> +       kfree(ofs->config.verity_mode);
>         if (ofs->creator_cred)
>                 put_cred(ofs->creator_cred);
>         kfree(ofs);
> @@ -325,6 +331,11 @@ static const char *ovl_redirect_mode_def(void)
>         return ovl_redirect_dir_def ? "on" : "off";
>  }
>
> +static const char *ovl_verity_mode_def(void)
> +{
> +       return ovl_verity_def ? "on" : "validate";
> +}
> +
>  static const char * const ovl_xino_str[] =3D {
>         "off",
>         "auto",
> @@ -374,6 +385,8 @@ static int ovl_show_options(struct seq_file *m, struc=
t dentry *dentry)
>                 seq_puts(m, ",volatile");
>         if (ofs->config.userxattr)
>                 seq_puts(m, ",userxattr");
> +       if (strcmp(ofs->config.verity_mode, ovl_verity_mode_def()) !=3D 0=
)
> +               seq_printf(m, ",verity=3D%s", ofs->config.verity_mode);
>         return 0;
>  }
>
> @@ -429,6 +442,7 @@ enum {
>         OPT_METACOPY_ON,
>         OPT_METACOPY_OFF,
>         OPT_VOLATILE,
> +       OPT_VERITY,
>         OPT_ERR,
>  };
>
> @@ -451,6 +465,7 @@ static const match_table_t ovl_tokens =3D {
>         {OPT_METACOPY_ON,               "metacopy=3Don"},
>         {OPT_METACOPY_OFF,              "metacopy=3Doff"},
>         {OPT_VOLATILE,                  "volatile"},
> +       {OPT_VERITY,                    "verity=3D%s"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -500,6 +515,25 @@ static int ovl_parse_redirect_mode(struct ovl_config=
 *config, const char *mode)
>         return 0;
>  }
>
> +static int ovl_parse_verity_mode(struct ovl_config *config, const char *=
mode)
> +{
> +       if (strcmp(mode, "validate") =3D=3D 0) {
> +               config->verity_validate =3D true;
> +       } else if (strcmp(mode, "on") =3D=3D 0) {
> +               config->verity_validate =3D true;
> +               config->verity_generate =3D true;
> +       } else if (strcmp(mode, "require") =3D=3D 0) {
> +               config->verity_validate =3D true;
> +               config->verity_generate =3D true;
> +               config->verity_require =3D true;
> +       } else if (strcmp(mode, "off") !=3D 0) {
> +               pr_err("bad mount option \"verity=3D%s\"\n", mode);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
>  static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  {
>         char *p;
> @@ -511,6 +545,10 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
g *config)
>         if (!config->redirect_mode)
>                 return -ENOMEM;
>
> +       config->verity_mode =3D kstrdup(ovl_verity_mode_def(), GFP_KERNEL=
);
> +       if (!config->verity_mode)
> +               return -ENOMEM;
> +
>         while ((p =3D ovl_next_opt(&opt)) !=3D NULL) {
>                 int token;
>                 substring_t args[MAX_OPT_ARGS];
> @@ -611,6 +649,13 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
g *config)
>                         config->userxattr =3D true;
>                         break;
>
> +               case OPT_VERITY:
> +                       kfree(config->verity_mode);
> +                       config->verity_mode =3D match_strdup(&args[0]);
> +                       if (!config->verity_mode)
> +                               return -ENOMEM;
> +                       break;
> +
>                 default:
>                         pr_err("unrecognized mount option \"%s\" or missi=
ng value\n",
>                                         p);
> @@ -642,6 +687,10 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
g *config)
>         if (err)
>                 return err;
>
> +       err =3D ovl_parse_verity_mode(config, config->verity_mode);
> +       if (err)
> +               return err;
> +
>         /*
>          * This is to make the logic below simpler.  It doesn't make any =
other
>          * difference, since config->redirect_dir is only used for upper.
>

Need to add code to resolve verity -> metacopy dependency
same as for metacopy -> redirect_dir dependency.

However, note that the nfs_export,userxattr -> !metacopy dependencies
also imply nfs_export,userxattr -> !verity.

But unlike metacopy, I am not sure of we can auto disable verity (?)
I guess it is fine to set veritfy=3Doff *along with* metacopy=3Doff because
trying to follow a metacopy would result in EIO anyway when metacopy
is disabled, so the verity mode is meaningless.

Thanks,
Amir.
