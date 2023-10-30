Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD219C4332F
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 13:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbjJ3NGn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 09:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbjJ3NGm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 09:06:42 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE7BC4
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 06:06:39 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3af609c5736so2180553b6e.3
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 06:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698671199; x=1699275999; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=niobfvF7F8MJS5mCLMNLFH9DJdsx4GCcievmdMSIqEg=;
        b=krdJ8t6vS1kGE4H8XByjdG+jo6LG+6LoftwB9RcW0mRlWZQ0cZ89RKK6tIqIr7v2uQ
         m9R/8gJWNbyQ3dhkVvrXGOqmqpn+IlQPhp+867iI5HVB8+zmKl9KFiVjixVnwv2vphCC
         XqkZvODdc/wrO+RG9Exf0Wv7DrDWWO9PKVMBvMKdpUvJQ9r9KoosqDTeoHdf/nLRx55H
         DOViR4ipZ2Wr6wbk5ZBjlrSflQIoUQSKGnw26dB+zeXJ8CFdUemS+PvBlI4tCa824j/s
         I4FA526EgboKdQWFUlhQr7rZRtdrL3szsdfK1T7wB6QLzed3jB8qK3SU1yVjDr6t8cBd
         WNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698671199; x=1699275999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=niobfvF7F8MJS5mCLMNLFH9DJdsx4GCcievmdMSIqEg=;
        b=aRsMkiFhfYQVs5RMkb4Ein9DSBLPGdshQk23KxoyFe0EYcLRNM474I3xbROkdDiwKM
         Zqc6fNjLDmBaJg0Fd7HmatAyL4/1CiIo6oPkBgvUf8JiPKy9332iXaZ5AAJDKqB7WAad
         JTg32r4qBTSA3sDXANAzwZTVkBy2YobOEIvhiI9ySozXy01CeQ5eVqIGtAKRny1MBSyy
         EpUlFuo2qPOy2MaOkioZ4EFhfYJ7Fv4yLhJ1GDQ6iJ4dd6nWp/0k9M1ARjp0BXPQPQA9
         DjXAAOQkQPUN0p0SYiBcSPmSiI6PRNfDKKXkynlWHlqwGGidiIH7hrLkfVybDpOfrtWc
         h/2w==
X-Gm-Message-State: AOJu0Yw1vE9axSQRkjjSBf0JTynOAG+ODY2Pklsv7YW5wiGBdyW9zfG9
        JwxP7K3WLjJ4ZNF+k+4N24yGN48nDMoOITGREeGFDFdlCB0=
X-Google-Smtp-Source: AGHT+IEziZw87UO7TSLIGz+8gIH3igd/719SJQBRdqC+ft3EyDlUm2x8LN1IrzOgg03wLdq1n26Y0bvja+H/UtqAZxI=
X-Received: by 2002:a05:6808:bd4:b0:3a9:e8e2:57a7 with SMTP id
 o20-20020a0568080bd400b003a9e8e257a7mr10290705oik.53.1698671199084; Mon, 30
 Oct 2023 06:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <20231030120419.478228-1-amir73il@gmail.com> <20231030120419.478228-5-amir73il@gmail.com>
In-Reply-To: <20231030120419.478228-5-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 30 Oct 2023 15:06:27 +0200
Message-ID: <CAOQ4uxi9dggtyGsOmgO89rQ-LesCpPT+JjQ-n8k7AExJ0Zvd6g@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: add support for appending lowerdirs one by one
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 30, 2023 at 2:04=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Add new mount options lowerdir+ and datadir+ that can be used to add
> layers to lower layers stack one by one.
>
> Unlike the legacy lowerdir mount option, special characters (i.e. colons
> and cammas) are not unescaped with these new mount options.
>
> The new mount options can be repeated to compose a large stack of lower
> layers, but they may not be mixed with the lagacy lowerdir mount option,
> because for displaying lower layers in mountinfo, we do not want to mix
> escaped with unescaped lower layers path syntax.
>
> Similar to data-only layer rules with the lowerdir mount option, the
> datadir+ option must follow at least one lowerdir+ option and the
> lowerdir+ option must not follow the datadir+ option.
>
> If the legacy lowerdir mount option follows lowerdir+ and datadir+
> mount options, it overrides them.  Sepcifically, calling:
>
>   fsconfig(FSCONFIG_SET_STRING, "lowerdir", "", 0);
>
> can be used to reset previously setup lower layers.
>
> Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
> Link: https://lore.kernel.org/r/CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=3D=
QFUxpFJE+=3DRQ@mail.gmail.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/params.c | 78 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 76 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 9a9238eac730..1c390e93d060 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -45,6 +45,8 @@ MODULE_PARM_DESC(metacopy,
>
>  enum ovl_opt {
>         Opt_lowerdir,
> +       Opt_lowerdir_add,
> +       Opt_datadir_add,
>         Opt_upperdir,
>         Opt_workdir,
>         Opt_default_permissions,
> @@ -140,8 +142,11 @@ static int ovl_verity_mode_def(void)
>  #define fsparam_string_empty(NAME, OPT) \
>         __fsparam(fs_param_is_string, NAME, OPT, fs_param_can_be_empty, N=
ULL)
>
> +
>  const struct fs_parameter_spec ovl_parameter_spec[] =3D {
>         fsparam_string_empty("lowerdir",    Opt_lowerdir),
> +       fsparam_string("lowerdir+",         Opt_lowerdir_add),
> +       fsparam_string("datadir+",          Opt_datadir_add),
>         fsparam_string("upperdir",          Opt_upperdir),
>         fsparam_string("workdir",           Opt_workdir),
>         fsparam_flag("default_permissions", Opt_default_permissions),
> @@ -273,6 +278,8 @@ static int ovl_mount_dir(const char *name, struct pat=
h *path)
>  static int ovl_mount_dir_check(struct fs_context *fc, const struct path =
*path,
>                                enum ovl_opt layer, const char *name, bool=
 upper)
>  {
> +       struct ovl_fs_context *ctx =3D fc->fs_private;
> +
>         if (ovl_dentry_weird(path->dentry))
>                 return invalfc(fc, "filesystem on %s not supported", name=
);
>
> @@ -289,16 +296,44 @@ static int ovl_mount_dir_check(struct fs_context *f=
c, const struct path *path,
>                         return invalfc(fc, "filesystem not supported as %=
s", name);
>                 if (__mnt_is_readonly(path->mnt))
>                         return invalfc(fc, "%s is read-only", name);
> +       } else {
> +               if (ctx->lowerdir_all)
> +                       return invalfc(fc, "%s cannot follow lowerdir mou=
nt option", name);
> +               if (ctx->nr_data && layer =3D=3D Opt_lowerdir_add)
> +                       return invalfc(fc, "regular lower layers cannot f=
ollow data layers");
> +               if (ctx->nr =3D=3D OVL_MAX_STACK)
> +                       return invalfc(fc, "too many lower directories, l=
imit is %d",
> +                                      OVL_MAX_STACK);
>         }
>         return 0;
>  }
>
> +static int ovl_ctx_realloc_lower(struct fs_context *fc)
> +{
> +       struct ovl_fs_context *ctx =3D fc->fs_private;
> +       struct ovl_fs_context_layer *l;
> +       size_t nr;
> +
> +       if (ctx->nr < ctx->capacity)
> +               return 0;
> +
> +       nr =3D min(max(4096 / sizeof(*l), ctx->capacity * 2), (size_t) OV=
L_MAX_STACK);
> +       l =3D krealloc_array(ctx->lower, nr, sizeof(*l), GFP_KERNEL_ACCOU=
NT);
> +       if (!l)
> +               return -ENOMEM;
> +
> +       ctx->lower =3D l;
> +       ctx->capacity =3D nr;
> +       return 0;
> +}
> +
>  static void ovl_add_layer(struct fs_context *fc, enum ovl_opt layer,
>                          struct path *path, char **pname)
>  {
>         struct ovl_fs *ofs =3D fc->s_fs_info;
>         struct ovl_config *config =3D &ofs->config;
>         struct ovl_fs_context *ctx =3D fc->fs_private;
> +       struct ovl_fs_context_layer *l;
>
>         switch (layer) {
>         case Opt_workdir:
> @@ -309,6 +344,16 @@ static void ovl_add_layer(struct fs_context *fc, enu=
m ovl_opt layer,
>                 swap(config->upperdir, *pname);
>                 swap(ctx->upper, *path);
>                 break;
> +       case Opt_datadir_add:
> +               ctx->nr_data++;
> +               fallthrough;
> +       case Opt_lowerdir_add:
> +               WARN_ON(ctx->nr >=3D ctx->capacity);
> +               l =3D &ctx->lower[ctx->nr++];
> +               memset(l, 0, sizeof(*l));
> +               swap(l->name, *pname);
> +               swap(l->path, *path);
> +               break;
>         default:
>                 WARN_ON(1);
>         }
> @@ -324,7 +369,10 @@ static int ovl_parse_layer(struct fs_context *fc, st=
ruct fs_parameter *param,
>         if (!name)
>                 return -ENOMEM;
>
> -       err =3D ovl_mount_dir(name, &path);
> +       if (upper)
> +               err =3D ovl_mount_dir(name, &path);
> +       else
> +               err =3D ovl_mount_dir_noesc(name, &path);
>         if (err)
>                 goto out_free;
>
> @@ -332,6 +380,12 @@ static int ovl_parse_layer(struct fs_context *fc, st=
ruct fs_parameter *param,
>         if (err)
>                 goto out_put;
>
> +       if (!upper) {
> +               err =3D ovl_ctx_realloc_lower(fc);
> +               if (err)
> +                       goto out_put;
> +       }
> +
>         /* Store the user provided path string in ctx to show in mountinf=
o */
>         ovl_add_layer(fc, layer, &path, &name);
>
> @@ -514,6 +568,10 @@ static int ovl_parse_param(struct fs_context *fc, st=
ruct fs_parameter *param)
>         case Opt_lowerdir:
>                 err =3D ovl_parse_param_lowerdir(param->string, fc);
>                 break;
> +       case Opt_lowerdir_add:
> +       case Opt_datadir_add:
> +               err =3D ovl_parse_layer(fc, param, opt, false);
> +               break;
>         case Opt_upperdir:
>         case Opt_workdir:
>                 err =3D ovl_parse_layer(fc, param, opt, true);

Sorry, ovl_parse_layer() doesn't need bool upper arg.
Your POC didn't have it.

I removed that and pushed to overlayfs-next.

Thanks,
Amir.
