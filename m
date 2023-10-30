Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89DDC4332F
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 15:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbjJ3PhF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjJ3PhE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 11:37:04 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F03A9
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 08:37:01 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9d274222b5dso276630866b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 08:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1698680220; x=1699285020; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lVFy2Ky6OSfI1q0IJlEkLFaL1Na0mSq8Av/9pE1RR3I=;
        b=VmN5Uwh/sV99/3pxahZdsDl1hYDPStGU87nlT3C3Pt8tYNO6bI/lcWPsOwGVIwl7iq
         gXg3KDWGLL3LiC4ScV4hX3EYKumBKkFOKvTKudvDy5t4aP7x+0vUcgFfp3EFyVa+m4L7
         qY52ac3Jc2N90ea3OIbphX0WsQ14wC7zimVTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698680220; x=1699285020;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lVFy2Ky6OSfI1q0IJlEkLFaL1Na0mSq8Av/9pE1RR3I=;
        b=CqIg3/ggZkhWcNu8+rwI/3uwDIOIplejaKgi3fQSDpNdiwWqyTHC9iTp+/VMnU4L8o
         7p0nftKl+RQBGOqz7vOL6Oi0hslOY3ySGYE9I8zDO7Hv+MpcYo9bb+P/ZFgTOApq/sfT
         jlrK45i7ur4Xel07ncdrLBhjFZPcb2Y+58MjmSpC9xY2CEUschPWvgAND2AiImf4OmDQ
         jRZAUqpeLRa62Qr/+0RgRHjExIzOnsRuI0UiVUTVgHTYY7W2odzCvT+wKOgQ2LXuFS+F
         B+V541ltKNkG/OhwZNrvBVX82lrBVIfWzlNHGCW1bKIU9GlbjiLXjddzo60/KUkfTzc1
         UUMA==
X-Gm-Message-State: AOJu0YylIk4XpCFTcm7t/nIRgbNgHE7PDWVah9UbZZyDGigdfpQ5WEAo
        UDf70//mQXHplXz/a3tbY4MTFPj1Nv5JJbMmZ+OPyA==
X-Google-Smtp-Source: AGHT+IGBq+XZ3Fu15w7l+OY3ETbpkPWXWW0EaXGEcpTYidXfCWZODb+wswJLlldT9nOEmUghVi0+RDTixJ90J5xupVg=
X-Received: by 2002:a17:907:980b:b0:9be:fc60:32d9 with SMTP id
 ji11-20020a170907980b00b009befc6032d9mr8317150ejc.47.1698680220091; Mon, 30
 Oct 2023 08:37:00 -0700 (PDT)
MIME-Version: 1.0
References: <20231030120419.478228-1-amir73il@gmail.com> <20231030120419.478228-4-amir73il@gmail.com>
In-Reply-To: <20231030120419.478228-4-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 30 Oct 2023 16:36:48 +0100
Message-ID: <CAJfpegs79eNFC_+ZV6mCu9Q__PNQmT-uM5=_ysufZAuTkJdK0w@mail.gmail.com>
Subject: Re: [PATCH 3/4] ovl: refactor layer parsing helpers
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 30 Oct 2023 at 13:04, Amir Goldstein <amir73il@gmail.com> wrote:
>
> In preparation for new mount options to add lowerdirs one by one,
> generalize ovl_parse_param_upperdir() into helper ovl_parse_layer()
> with bool @upper argument that will be false for adding lower layers.
>
> Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
> Link: https://lore.kernel.org/r/CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/params.c | 116 ++++++++++++++++++++++--------------------
>  1 file changed, 62 insertions(+), 54 deletions(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 0bf754a69e91..9a9238eac730 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -43,7 +43,7 @@ module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
>  MODULE_PARM_DESC(metacopy,
>                  "Default to on or off for the metadata only copy up feature");
>
> -enum {
> +enum ovl_opt {
>         Opt_lowerdir,
>         Opt_upperdir,
>         Opt_workdir,
> @@ -238,19 +238,8 @@ static int ovl_mount_dir_noesc(const char *name, struct path *path)
>                 pr_err("failed to resolve '%s': %i\n", name, err);
>                 goto out;
>         }
> -       err = -EINVAL;
> -       if (ovl_dentry_weird(path->dentry)) {
> -               pr_err("filesystem on '%s' not supported\n", name);
> -               goto out_put;
> -       }
> -       if (!d_is_dir(path->dentry)) {
> -               pr_err("'%s' not a directory\n", name);
> -               goto out_put;
> -       }

This will lose the check for lowerdir, no?

>         return 0;
>
> -out_put:
> -       path_put_init(path);
>  out:
>         return err;
>  }
> @@ -268,7 +257,7 @@ static void ovl_unescape(char *s)
>         }
>  }
>
> -static int ovl_mount_dir(const char *name, struct path *path, bool upper)
> +static int ovl_mount_dir(const char *name, struct path *path)
>  {
>         int err = -ENOMEM;
>         char *tmp = kstrdup(name, GFP_KERNEL);
> @@ -276,60 +265,81 @@ static int ovl_mount_dir(const char *name, struct path *path, bool upper)
>         if (tmp) {
>                 ovl_unescape(tmp);
>                 err = ovl_mount_dir_noesc(tmp, path);
> -
> -               if (!err && upper && path->dentry->d_flags & DCACHE_OP_REAL) {
> -                       pr_err("filesystem on '%s' not supported as upperdir\n",
> -                              tmp);
> -                       path_put_init(path);
> -                       err = -EINVAL;
> -               }
>                 kfree(tmp);
>         }
>         return err;
>  }
>
> -static int ovl_parse_param_upperdir(const char *name, struct fs_context *fc,
> -                                   bool workdir)
> +static int ovl_mount_dir_check(struct fs_context *fc, const struct path *path,
> +                              enum ovl_opt layer, const char *name, bool upper)
>  {
> -       int err;
> -       struct ovl_fs *ofs = fc->s_fs_info;
> -       struct ovl_config *config = &ofs->config;
> -       struct ovl_fs_context *ctx = fc->fs_private;
> -       struct path path;
> -       char *dup;
> +       if (ovl_dentry_weird(path->dentry))
> +               return invalfc(fc, "filesystem on %s not supported", name);
>
> -       err = ovl_mount_dir(name, &path, true);
> -       if (err)
> -               return err;
> +       if (!d_is_dir(path->dentry))
> +               return invalfc(fc, "%s is not a directory", name);

This can result in:

  overlay: lowerdir+ is not a directory

Which is somewhat confusing.  Not sure how mount/libmount will present
such option error messages, as that does not currently work.

So the kernel could be really nice about it and tell the user which
lowerdir (layer index).   But libmount could also indicate which
option failed, in which case indicating the layer would not be needed.
  OTOH when using the legacy API we do need to tell the user whether
it was upperdir or workdir, but that doesn't affect lowerdir+.   So
some compromise and negotiation with util-linux devs is needed.

Thanks,
Miklos
