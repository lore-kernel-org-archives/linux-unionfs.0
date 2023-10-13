Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F90CCDB47E
	for <linux-unionfs@archiver.kernel.org>; Fri, 13 Oct 2023 15:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjJMPg0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 11:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjJMPgY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Oct 2023 11:36:24 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B7BBE
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Oct 2023 08:36:20 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9b275afb6abso710483266b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Oct 2023 08:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1697211379; x=1697816179; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yyLXtKhVgM7jfQrNyPUn3G2Ltk205pBcWVIPXzr7zUk=;
        b=KYmdRux1BC7s4Y7cmjMExx59EO6id3UVGpcFBKf0qfwx6Neq3+OsMGCwtGau8rf27W
         8PYXO1aY/Ty7ShM7L4odl3wg4Z6vqyHE8JvmH/jsG9d/uAItkG2qmsqDnSX1gcvWTnbi
         jmeY8lNalQ2ZRr0U8eeZN9MkTjB01RVUAJTMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697211379; x=1697816179;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yyLXtKhVgM7jfQrNyPUn3G2Ltk205pBcWVIPXzr7zUk=;
        b=whqI5WrnPLwHLfTAYWgLOHLRoaweKm4lmus6SywPRxNNjaR+mFPKH45z8LqmAmfLCK
         ALUOrhiqf+f4g47tJb8QCaXmSCWQiGTB++bwRg23orOB6DfRZFUBvTqeO0bc2fwT8miF
         vLD3DQqizOBcWH5BCofKLs6bmZyWf9CHBLI7uJAnp5gzc0Bk29bH6QsUhZBZ+7fqP7HJ
         0IgZAm0e24BH5te8NqwdFA48j0JaGYqoFAuVCGeq1XrlBEhqjkZc5XqQmmw5tg4UnA7h
         IaIGL8+aXwHQxKb7kSFjSHdFuKKjxSDiuJk/SEpfh2ngNgUr8PqbrU299evQkhbesNe5
         B7iw==
X-Gm-Message-State: AOJu0YwEBvTSi6gmWkhC+RAX8MnRXeudbg1uqE0OPUBFsUkk4KhvmyG1
        xscD1IN2/CbhZM5AkSQk7F9WpuhaU3a1OaRxOmYtpw==
X-Google-Smtp-Source: AGHT+IE8ZYYOdF0avZwnl/SsMwcsHymBVTm0tojzoxTlnHm59ZkAomEaqGeU5gyhoFCKGAUuBmjyAnJPD2RmCwLgwwE=
X-Received: by 2002:a17:907:9343:b0:9ad:93c8:c483 with SMTP id
 bv3-20020a170907934300b009ad93c8c483mr427488ejc.2.1697211378693; Fri, 13 Oct
 2023 08:36:18 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com>
In-Reply-To: <20231011164613.1766616-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 13 Oct 2023 17:36:07 +0200
Message-ID: <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 11 Oct 2023 at 18:46, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Before commit b36a5780cb44 ("ovl: modify layer parameter parsing"),
> spaces and commas in lowerdir mount option value used to be escaped using
> seq_show_option().
>
> In current upstream, when lowerdir value has a space, it is not escaped
> in /proc/mounts, e.g.:
>
>   none /mnt overlay rw,relatime,lowerdir=l l,upperdir=u,workdir=w 0 0
>
> which results in broken output of the mount utility:
>
>   none on /mnt type overlay (rw,relatime,lowerdir=l)
>
> Store the original lowerdir mount options before unescaping and show
> them using the same escaping used for seq_show_option() in addition to
> escaping the colon separator character.
>
> Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/params.c | 38 +++++++++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 95b751507ac8..1429767a84bc 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -164,7 +164,8 @@ static ssize_t ovl_parse_param_split_lowerdirs(char *str)
>
>         for (s = d = str;; s++, d++) {
>                 if (*s == '\\') {
> -                       s++;
> +                       /* keep esc chars in split lowerdir */
> +                       *d++ = *s++;
>                 } else if (*s == ':') {
>                         bool next_colon = (*(s + 1) == ':');
>
> @@ -239,7 +240,7 @@ static void ovl_unescape(char *s)
>         }
>  }
>
> -static int ovl_mount_dir(const char *name, struct path *path)
> +static int ovl_mount_dir(const char *name, struct path *path, bool upper)
>  {
>         int err = -ENOMEM;
>         char *tmp = kstrdup(name, GFP_KERNEL);
> @@ -248,7 +249,7 @@ static int ovl_mount_dir(const char *name, struct path *path)
>                 ovl_unescape(tmp);
>                 err = ovl_mount_dir_noesc(tmp, path);
>
> -               if (!err && path->dentry->d_flags & DCACHE_OP_REAL) {
> +               if (!err && upper && path->dentry->d_flags & DCACHE_OP_REAL) {
>                         pr_err("filesystem on '%s' not supported as upperdir\n",
>                                tmp);
>                         path_put_init(path);
> @@ -269,7 +270,7 @@ static int ovl_parse_param_upperdir(const char *name, struct fs_context *fc,
>         struct path path;
>         char *dup;
>
> -       err = ovl_mount_dir(name, &path);
> +       err = ovl_mount_dir(name, &path, true);
>         if (err)
>                 return err;
>
> @@ -472,7 +473,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
>                 l = &ctx->lower[nr];
>                 memset(l, 0, sizeof(*l));
>
> -               err = ovl_mount_dir_noesc(dup_iter, &l->path);
> +               err = ovl_mount_dir(dup_iter, &l->path, false);
>                 if (err)
>                         goto out_put;
>
> @@ -950,16 +951,23 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         struct super_block *sb = dentry->d_sb;
>         struct ovl_fs *ofs = OVL_FS(sb);
>         size_t nr, nr_merged_lower = ofs->numlayer - ofs->numdatalayer;
> -       char **lowerdatadirs = &ofs->config.lowerdirs[nr_merged_lower];
> -
> -       /* lowerdirs[] starts from offset 1 */
> -       seq_printf(m, ",lowerdir=%s", ofs->config.lowerdirs[1]);
> -       /* dump regular lower layers */
> -       for (nr = 2; nr < nr_merged_lower; nr++)
> -               seq_printf(m, ":%s", ofs->config.lowerdirs[nr]);
> -       /* dump data lower layers */
> -       for (nr = 0; nr < ofs->numdatalayer; nr++)
> -               seq_printf(m, "::%s", lowerdatadirs[nr]);
> +
> +       /*
> +        * lowerdirs[] starts from offset 1, then
> +        * >= 0 regular lower layers prefixed with : and
> +        * >= 0 data-only lower layers prefixed with ::
> +        *
> +        * we need to escase comma and space like seq_show_option() does and
> +        * we also need to escape the colon separator from lowerdir paths.
> +        */
> +       seq_puts(m, ",lowerdir=");
> +       for (nr = 1; nr < ofs->numlayer; nr++) {
> +               if (nr > 1)
> +                       seq_putc(m, ':');
> +               if (nr >= nr_merged_lower)
> +                       seq_putc(m, ':');
> +               seq_escape(m, ofs->config.lowerdirs[nr], ":,= \t\n\\");

This is too eager.   Just need to escape what seq_show_option() would
escape, which is comma and whitespace.   The '=' is  not need escaped
in values only in keys (and that likely never triggers).  Colons
should have stayed escaped as "\:", so no point in adding another
level of escape.

Yes, this two level escape is pretty confusing, considering that
commas are escaped on both levels if using the old API.  When using
the new API commas need not be escaped, but can be, since the same
unescaping is done.   Not a serious issue as backslash in filenames is
basically nonexistent, but an inconsistency nonetheless.

Following choices exist:

1) should the redundant escaping be left in mountinfo?

2) should FSCONFIG_SET_STRING accept escaped commas?

3) should unescaped commas on FSCONFIG_SET_STRING (and
FSCONFIG_SET_PATH) be double escaped in mountinfo?

Currently it's yes, yes, no.  I'm fine with leaving things as they
are, but at least the documentation should be clear on what should
happen.

Thanks,
Miklos
