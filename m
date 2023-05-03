Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828CAC77B7F
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 May 2023 11:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjECLwf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 May 2023 07:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjECLwd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2023 07:52:33 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00C76193
        for <linux-unionfs@vger.kernel.org>; Wed,  3 May 2023 04:52:08 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id a1e0cc1a2514c-77d46c7dd10so3110334241.0
        for <linux-unionfs@vger.kernel.org>; Wed, 03 May 2023 04:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683114726; x=1685706726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMNG0hMP+40Gs6QkYfnHliFtC78f++jotWDsmKUrQKw=;
        b=FNUvgPSeC6OK4ubf9KpZPgPn670vudsKlghyLRAGcbmA6GhU+UUV5r6GqIaJaIvv0E
         50xJrK6TahiDavlW9cx++d4Dfjtc6hTKytyd7+g8Mf3daACzENb++VnAJ45ooWdKjqIg
         IwBUkvp6jUH+bug/SPWBFcnoX1rZT6EisJ8R3ys0chMo4iirzNMDE5x+Lz0OkKb81Asd
         cP1jCMx/wV51JG4scdhI80PVvkaSxGlZRqlMyKpdFI57KM2gdc9jPc8Z21WrEjkMynkY
         3avRPol1zAyPL1dxKRYK2482JPlik2rJblJRv8SnTqGsQt7EGVJIMYyiW2OrEnWuNPPQ
         ZQ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683114726; x=1685706726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yMNG0hMP+40Gs6QkYfnHliFtC78f++jotWDsmKUrQKw=;
        b=UD2N8aX36vdZ914uBAVnYlecdW8RVBwKI+EUgJdvgnW3iRzvKtOyldlRgt6eIb/d4k
         ZH9H/7WlYVZzlzx8q62FCjg8JHrJHmwP0JWMlnPrZpaFo7obE7Ctgm3ri61ZlCSPsq2I
         OVOoRDJjiRWEE1rob2D/u9x02zrSk60Bdr7G+iVe6fcUI8P4s3t6/lwKQA89C5/xtyrC
         FLH8mvC/OvZyrZoWgOvcp3MJkwgOK+SP+uv7TgJjL+V1AQT/fZf/e0sbW81eleKR6Fgy
         pFLGoTEiU+3FJXS06cCJKpHDUcJsh4fg8ealgoZBIeeCOFlg4Z3r7DJCElEg5HnS5S8O
         SlQw==
X-Gm-Message-State: AC+VfDxa8t2f/3ZVTnklHljtQfMpmjgk9k2QMbEaCiPlsyQ/wwAAx940
        AjUfWuTbr7zNKd6YsnhTZQmNWeetwuISKIsClKQDHghiAxI=
X-Google-Smtp-Source: ACHHUZ7tRjpVazY2WngZkDeogaLepkDNZgj/ODCpuooj8lmBVGGnUwWbCh8SHXkq/dYrYJ5ndD9/9jfajGkxxEQY56Y=
X-Received: by 2002:a05:6102:511e:b0:42e:63ad:f9b5 with SMTP id
 bm30-20020a056102511e00b0042e63adf9b5mr686001vsb.7.1683114725984; Wed, 03 May
 2023 04:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <0292ade77250a8bb563744f596ecaab5614cbd80.1683102959.git.alexl@redhat.com>
In-Reply-To: <0292ade77250a8bb563744f596ecaab5614cbd80.1683102959.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 3 May 2023 14:51:54 +0300
Message-ID: <CAOQ4uxh6zg2NxuTtQgtLHhCF6dLfr_HLMVxhOViCvRO2+PoVcA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] ovl: Add framework for verity support
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 3, 2023 at 11:52=E2=80=AFAM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> This adds the scaffolding (docs, config, mount options) for supporting
> for a new overlay xattr "overlay.verity", which contains a fs-verity
> digest. This is used for metacopy files, and the actual fs-verity
> digest of the lowerdata file needs to match it. The mount option
> "verity" specifies how this xattrs is handled.
>
> If you enable verity it ("verity=3Don") all existing xattrs are
> validated before use, and during metacopy we generate verity xattr in
> the upper metacopy file if the source file has verity enabled. This
> means later accesses can guarantee that the correct data is used.
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  Documentation/filesystems/overlayfs.rst | 27 +++++++++
>  fs/overlayfs/ovl_entry.h                |  3 +
>  fs/overlayfs/super.c                    | 74 ++++++++++++++++++++++++-
>  3 files changed, 102 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index bc95343bafba..7e2b445a4139 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -407,6 +407,33 @@ when a "metacopy" file in one of the lower layers ab=
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
> +the file is opened. During metacopy copy up overlayfs can also set
> +this xattr.
> +
> +This is controlled by the "verity" mount option, which supports
> +these values:
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
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index c6c7d09b494e..95464a1cb371 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -13,6 +13,9 @@ struct ovl_config {
>         bool redirect_dir;
>         bool redirect_follow;
>         const char *redirect_mode;
> +       bool verity;
> +       bool require_verity;
> +       const char *verity_mode;
>         bool index;
>         bool uuid;
>         bool nfs_export;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index c6209592bb3f..a4662883b619 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -244,6 +244,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>         kfree(ofs->config.upperdir);
>         kfree(ofs->config.workdir);
>         kfree(ofs->config.redirect_mode);
> +       kfree(ofs->config.verity_mode);
>         if (ofs->creator_cred)
>                 put_cred(ofs->creator_cred);
>         kfree(ofs);
> @@ -334,6 +335,11 @@ static const char *ovl_redirect_mode_def(void)
>         return ovl_redirect_dir_def ? "on" : "off";
>  }
>
> +static const char *ovl_verity_mode_def(void)
> +{
> +       return "off";
> +}
> +
>  static const char * const ovl_xino_str[] =3D {
>         "off",
>         "auto",
> @@ -383,6 +389,8 @@ static int ovl_show_options(struct seq_file *m, struc=
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
> @@ -438,6 +446,7 @@ enum {
>         OPT_METACOPY_ON,
>         OPT_METACOPY_OFF,
>         OPT_VOLATILE,
> +       OPT_VERITY,
>         OPT_ERR,
>  };
>
> @@ -460,6 +469,7 @@ static const match_table_t ovl_tokens =3D {
>         {OPT_METACOPY_ON,               "metacopy=3Don"},
>         {OPT_METACOPY_OFF,              "metacopy=3Doff"},
>         {OPT_VOLATILE,                  "volatile"},
> +       {OPT_VERITY,                    "verity=3D%s"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -509,6 +519,21 @@ static int ovl_parse_redirect_mode(struct ovl_config=
 *config, const char *mode)
>         return 0;
>  }
>
> +static int ovl_parse_verity_mode(struct ovl_config *config, const char *=
mode)
> +{
> +       if (strcmp(mode, "on") =3D=3D 0) {
> +               config->verity =3D true;
> +       } else if (strcmp(mode, "require") =3D=3D 0) {
> +               config->verity =3D true;
> +               config->require_verity =3D true;
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
> @@ -520,6 +545,10 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
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
> @@ -620,6 +649,13 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
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
> @@ -651,6 +687,22 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
g *config)
>         if (err)
>                 return err;
>
> +       err =3D ovl_parse_verity_mode(config, config->verity_mode);
> +       if (err)
> +               return err;
> +
> +       /* Resolve verity -> metacopy dependency */
> +       if (config->verity && !config->metacopy) {
> +               /* Don't allow explicit specified conflicting combination=
s */
> +               if (metacopy_opt) {
> +                       pr_err("conflicting options: metacopy=3Doff,verit=
y=3D%s\n",
> +                              config->verity_mode);
> +                       return -EINVAL;
> +               }
> +               /* Otherwise automatically enable metacopy. */
> +               config->metacopy =3D true;
> +       }
> +
>         /*
>          * This is to make the logic below simpler.  It doesn't make any =
other
>          * difference, since config->redirect_dir is only used for upper.
> @@ -665,6 +717,11 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
g *config)
>                                config->redirect_mode);
>                         return -EINVAL;
>                 }
> +               if (config->verity && redirect_opt) {
> +                       pr_err("conflicting options: verity=3D%s,redirect=
_dir=3D%s\n",
> +                              config->verity_mode, config->redirect_mode=
);
> +                       return -EINVAL;
> +               }
>                 if (redirect_opt) {
>                         /*
>                          * There was an explicit redirect_dir=3D... that =
resulted
> @@ -700,7 +757,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config=
 *config)
>                 }
>         }
>
> -       /* Resolve nfs_export -> !metacopy dependency */
> +       /* Resolve nfs_export -> !metacopy && !verity dependency */
>         if (config->nfs_export && config->metacopy) {
>                 if (nfs_export_opt && metacopy_opt) {
>                         pr_err("conflicting options: nfs_export=3Don,meta=
copy=3Don\n");
> @@ -713,6 +770,14 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
g *config)
>                          */
>                         pr_info("disabling nfs_export due to metacopy=3Do=
n\n");
>                         config->nfs_export =3D false;
> +               } else if (config->verity) {
> +                       /*
> +                        * There was an explicit verity=3D.. that resulte=
d
> +                        * in this conflict.
> +                        */
> +                       pr_info("disabling nfs_export due to verity=3D%s\=
n",
> +                               config->verity_mode);
> +                       config->nfs_export =3D false;
>                 } else {
>                         /*
>                          * There was an explicit nfs_export=3Don that res=
ulted
> @@ -724,7 +789,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config=
 *config)
>         }
>
>
> -       /* Resolve userxattr -> !redirect && !metacopy dependency */
> +       /* Resolve userxattr -> !redirect && !metacopy && !verity depende=
ncy */
>         if (config->userxattr) {
>                 if (config->redirect_follow && redirect_opt) {
>                         pr_err("conflicting options: userxattr,redirect_d=
ir=3D%s\n",
> @@ -735,6 +800,11 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
g *config)
>                         pr_err("conflicting options: userxattr,metacopy=
=3Don\n");
>                         return -EINVAL;
>                 }
> +               if (config->verity) {
> +                       pr_err("conflicting options: userxattr,verity=3D%=
s\n",
> +                              config->verity_mode);
> +                       return -EINVAL;
> +               }
>                 /*
>                  * Silently disable default setting of redirect and metac=
opy.
>                  * This shall be the default in the future as well: these
> --
> 2.39.2
>
