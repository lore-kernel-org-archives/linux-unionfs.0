Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1370714375D
	for <linux-unionfs@vger.kernel.org>; Fri,  5 Jul 2024 06:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161342; cv=none; b=uTzSbQz29fe1yI8lVaP7QlkgDML07JH5mwXwereJD2BgmMzVZKmW24YZQ5+qyEDbm8ybReccHd8R0m2meA3NTWDvTu3DkU+q15iefRGLM6K4g70fXMWsh+DtvzZVvBsWJnKIboOxLeoiqzcBML8yfDk0ewdR8ACa33Hh1H5iG9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161342; c=relaxed/simple;
	bh=8STcu6iQ9+kRf3nRa7Koo0TrTdoM9lMhjtlsrXJ680Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AIPfeMl/dx0oih3Xw3oVCmK2pBBBGc1X1gvY1I3PMzZrwiGIyZysSJDHfVCGCmmNVvn8At0RLeVtU2BZApg9Tv9t+xqh9IZWi6a7R08VjcOI2xV1UElZPyWDuitEOVWMvCo19kLnpLgz4UlSeBZreVZEfU21l7xiCFXTTk7/40E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cOvm4hWn; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOvm4hWn"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4468ac3c579so6357071cf.0
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jul 2024 23:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720161340; x=1720766140; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLYDt8XDoTTJPbIyU84AOFxJPhGJ2WAYDl/C2dCE4I0=;
        b=cOvm4hWnMlsk/dV8edqiEoh6bFoFq7ID9l9d1pWfZM6OTbz/tvbhftrK4/wmIl7XI3
         uGEGr96fznYx9m6zkLuT8HQi7QFGWxR9AuSFSyUbPysdLaX2XmxJ30MnJHQYcyKnJ6yc
         updkeH5k6nMAOpYXvEI+3MiQCBBOxv8pfuGSuv6DlUzfpANgWwvrpyzCmLQ5YjaYJLoX
         CPZIJz72JS63DV9wqr1qttg7fzantK//24cEHquDuVk4lLRAMQb5p7kV7hh2tHf+7okt
         aVJmHeTvZHpKU+/EG2ZJK8VMWm9bmECL+3Cvs0NKcdFIjHm7auOEIg1E78xBFqW2PSq0
         HIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720161340; x=1720766140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RLYDt8XDoTTJPbIyU84AOFxJPhGJ2WAYDl/C2dCE4I0=;
        b=vokH3R3WbOe0pXsEVYthzO6hj8/3SPUD3/rTQ4KFO7imSXeyrHyuz6h8zwon2juKac
         cURfdAxr2GhIREqnHpiqJotym+zfNLCTTLhgat3TapDKAgXo0LnIJXAznCo06IRiYKJx
         iPZ+BpqK9F/hEoqugU5C9wbPstEgJWjDchQdyJmg3U8s0ywNusEK9rujYCP7QDBEFWwI
         RI9XEGp2Br3rqo2oY3iqLgOeb6ek/SIu4PIHnL9RK5cFRdLpbXok1kBG1iEcF9r5eG4F
         HtiW4PRd4OHWEpf6dv5m07TghQJM1XWPk9hw+UzejlTxzh2UUb8M4+eKvynEpVlHIx2N
         3/Nw==
X-Gm-Message-State: AOJu0Yz+wdmIAwtMR13LIoMMzwuYT+WfqdQNHNtmGf5dm9avpB/YmR8k
	tyYWIa8WP9n0DUnkPetNOyOL5CcGtJ3CmagBAyID51XT6o3DdxgZ2r4teFdBGYR7QKljnbzG+26
	MUnyXC+MTcYTLqjiZLbP0AFlng7M=
X-Google-Smtp-Source: AGHT+IHThQu5+P/OJ3XI5e/5tyGVbDOZujDbekdMJBPNdq06onHUX16B1gmwU55iW2xgXBSNsh4bkDlMyJfAxpCfLfM=
X-Received: by 2002:ac8:5f14:0:b0:43f:fc16:6b3f with SMTP id
 d75a77b69052e-447cbef6300mr35078551cf.34.1720161339889; Thu, 04 Jul 2024
 23:35:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240705042542.2003917-1-mike@mbaynton.com>
In-Reply-To: <20240705042542.2003917-1-mike@mbaynton.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 5 Jul 2024 09:35:28 +0300
Message-ID: <CAOQ4uxj2x1t4J51penjLJD5c0U7Xm=3ytJZoW37jY2AKxHDknw@mail.gmail.com>
Subject: Re: [PATCH] Data-only layer mount time validations
To: Mike Baynton <mike@mbaynton.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Larsson <alexl@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 5, 2024 at 7:25=E2=80=AFAM Mike Baynton <mike@mbaynton.com> wro=
te:
>
> There seem to be a few scenarios where it is possible to successfully
> mount up an overlay filesystem including data-only layer(s), but in
> configurations where it will never be possible to read data successfully
> from the data-only layers. I think this should result in a mount-time
> error instead of the current behavior of being unable to read data from
> the files that should normally return data from a data-only layer.
>
> Both cases were found by attempting to use data-only lower layers from a
> user namespace, a proposition that appears to be guaranteed to not end
> well since data-only lower layers requires use of trusted xattrs, but
> trusted xattrs can only be accessed in the initial user namespace.
>
> Case 1: upper dirs in use but xattrs cannot be written to the filesystem
> containing workdir (for any reason, user namespace-related or not.) This
> triggers a fallback behavior of disabling metacopy after an existing
> validation in ovl_fs_params_verify ensured metacopy is on when
> data-only layers are present. This is now rechecked after possibly
> disabling metacopy.
>
> Case 2: upper dirs are not in use, data-only layer(s) in use, mount
> initiated from a user namespace other than the initial one.
>
> When the filesystem consists of only lower layers, the test of xattrs
> is not performed and so metacopy remains on, satisfying Case 1.
> Therefore it is also neceessary to explicitly check for data-only layers
> in a mount whose initiator lacks CAP_SYS_ADMIN in the initial user
> namespace.
>
> Signed-off-by: Mike Baynton <mike@mbaynton.com>
> ---
>  fs/overlayfs/super.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 06a231970cb5..4382f21c36a0 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1394,6 +1394,19 @@ int ovl_fill_super(struct super_block *sb, struct =
fs_context *fc)
>         if (IS_ERR(oe))
>                 goto out_err;
>
> +       if (ofs->numdatalayer) {
> +               if (!ofs->config.metacopy) {
> +                       pr_err("lower data-only dirs require metacopy sup=
port.\n");
> +                       err =3D -EINVAL;
> +                       goto out_err;
> +               }

Is that not already handled by?

int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
                         struct ovl_config *config)
{
        struct ovl_opt_set set =3D ctx->set;

        if (ctx->nr_data > 0 && !config->metacopy) {
                pr_err("lower data-only dirs require metacopy support.\n");
                return -EINVAL;
        }

Probably because of:

                        ofs->config.metacopy =3D false;
                        pr_warn("...falling back to metacopy=3Doff.\n");

in xattr check, but it could also happen from:

        /* Resolve userxattr -> !redirect && !metacopy && !verity dependenc=
y */
        if (config->userxattr) {
...
                /*
                 * Silently disable default setting of redirect and metacop=
y.
                 * This shall be the default in the future as well: these
                 * options must be explicitly enabled if used together with
                 * userxattr.
                 */
                config->redirect_mode =3D OVL_REDIRECT_NOFOLLOW;
                config->metacopy =3D false;
        }

So maybe also the lowerdatadirs vs metacopy conflict should be moved
to the end of
ovl_fs_params_verify()?

> +               if (!capable(CAP_SYS_ADMIN)) {
> +                       pr_err("lower data-only dirs require CAP_SYS_ADMI=
N in the initial user namespace.\n");
> +                       err =3D -EPERM;
> +                       goto out_err;
> +               }

This is too specific IMO.

If we really want to check CAP_SYS_ADMIN at mount time, we should error
on any configuration that requires trusted xattrs and suggest that the user
will use -o userxattr, and maybe disable the conflicting config if it was n=
ot
explicitly specified in mount options.

Of course, userxattr conflicts with some other options including
redirect_dir, metacopy and verity, but that just means that the errors
will have to be smarter and the check for CAP_SYS_ADMIN should
definitely be in ovl_fs_params_verify() if we add them.

Thanks,
Amir.
