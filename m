Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794224450;
	b=4BWjPUOb6bZVN1rFyX7omKu1ff9GYH8Fzgdzz/roRcUZpcv3iVDp1o0sH7IwKYHsaIgQ
	 d/c8kt5xasPTI+XODDfIegNQu8RgkHNVdIlutxbO7SKY/YwIY7hs9NE4AGalH9vzeyIyP
	 /0xb4D/c8YjO+CK4YXFnUxi6RVYjFBd7hpdh9DCNyazy1y5F4oP+OtIfNp1uncp2t7xKI
	 RDz7mW2fTzTPkqUP7ibdDUKGK6jWicO4PLl18NmrOLH34ejSYMLdrQA1GxLNsCT3YDyTA
	 tSa0BrWEeZK3sB+ey8PmwPlBAffSVN/2MVF3qqClwUAwIvYnv5lPiGcHNMWDDAXyHBA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224450;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=6JqRxaeIzzt+8Onl3MXJiGJCPA1HU26IuIhXoRLNvF4=;
	b=2uIn2VU3gLNJxs73xAXA4i1hSztwEbClg+5poO7iHEIh3j/Z6LtCtiJ6If7JZFvvNzLw
	 5+km6Ul9vGgq/X/U4ssScPbJiixT9f9nC9le+SoW0g0KCu0qBa9AtvffmjxFJtCSg54H2
	 TcMibye1SnkHq2jeN011Fo00UHW8HF1huE123C8yyWq5KFfwGQIuZS+mNqqBxB6571kk0
	 /8BU4/yRoR1vWlwpDaXRalTOIBhmASOlZEZqYM53d37L0wfjPtDZDB9k6sw/wSvJfwrxU
	 xL0UYro2+wrDUHjoga309i/Fk6oFN0CnAZPjSgQersJvI9/BRhIPcZtCa27RB0KZTug==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rgOwfHoq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41357606A31C
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Nov 2026 11:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41357606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rgOwfHoq
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b70192ebceso1291569a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Nov 2026 03:40:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794224448; cv=none;
        d=google.com; s=arc-20260327;
        b=ME5cjYoK++o04wZasinNzU9r9NGhi12LHHUjBon2QeC97Dgy5wiNXC0ZrKeYCMqet+
         b0fLZUUW7TwKeGcHTPJy/un8mCefCbZwYebNjYhdUxr2PyRtgt1qexe3772fMK/ZdvuL
         yuBLsp675dTi6JxK+QZXsyyVFDpeScBitiQZJBZnVv+TOxCWeZDj1n+cjRx3eshcCIOK
         PdbGm0NgDS3V/jOko2Wc4ny+ZOSYdsZdtzBRQ8p4RlUZ6Lqwu9ZuvKgxoRkbCkv1tvel
         s94z31L0tfndIfsHR8h2ajBlf5wrFx2QDGHcM+rhBd1ptVhrlvoavMezAcpphq40KViC
         2Uvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6JqRxaeIzzt+8Onl3MXJiGJCPA1HU26IuIhXoRLNvF4=;
        fh=MFGww5WWwMbVBAGzYlobFNpyX4w0AV158eWpczIR550=;
        b=O7iqjQmUXyMvEDQbVAsDJwC+SplQwBN7skjzoqrk4MupCyXx0ZIZICK6P+GJFJwGzO
         TfknPgHmQFZCk8Yo7TXfRxdEa8TTnq3IlIlWe+R+jvrvzZIEEgnmxisMlTZbyWRPCwe1
         aWAcjoBbCLUeSa02DaPejPvVfICzc7EUEa8dQu6+YsTHBKR7cMPtbs+hOGeUn/hgc0hd
         N6KuKHNII4yWANmDiuuxux+TPvXTN+Fe/LSeiPJEasgkGiQVZOsLBoEDDs2Z9Hi3ISN8
         OmZMQ1TOOMbOxrwg4OiiQJjFqlpq1mC33SE9BPAeDSOID+DWroJypXSPDTsmRcbzNTk1
         U4ow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794224448; x=1794829248; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6JqRxaeIzzt+8Onl3MXJiGJCPA1HU26IuIhXoRLNvF4=;
        b=rgOwfHoqfUHL9nvwIuzi1OkueMT+KTKwMOuUy3+YjkDFvZ9FD5y7yj5TkCYnRSUQyp
         NIwqK+TUvETXS7M1DtxkqzQw/QHKDjPcr08+OE/vczoC2Go+COJ2fv2rbgfCvG4S2Y/X
         In3k2cUg7cXBTX3Jvg7AlcnOUwC6okFkgxV7pZSE+MzGZlcsSrtqrwt6++5xT6z2zZIt
         KAPiZiSccLmE+ArPO2mQqCHOpUKZ7XjxQCtN3efTpfKskkZVOubpzBxrJGJ+I9rRyuuF
         TRirHiNOggTNDb7D6Z62+Mr+W7Ll32FKgOrnWLSdcLv0mypRpAZTYVC79koE8Yma4Zzb
         qSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794224448; x=1794829248;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6JqRxaeIzzt+8Onl3MXJiGJCPA1HU26IuIhXoRLNvF4=;
        b=Yc2Gr//Q6MiQ/ol9iTRss3D90GtaO1IYVxGwV3CBuPuiBa3EQ7KwH8LJ+Dw/6UtApy
         gfcUITtheYGGckL7dlZf+dClzxVnGFDTMcSVkxzA0ubYGLB6e0NuYY0UZ4w2CazyCqYV
         IcIgPyCB70IHwFjYrstBElNMSrwFdgAGiBjbqS/aLEl8hbAb4MeWGpLDgKq1+rYXExRh
         gBG0Ffi6SvGY9NvOxwLgvTmTUw/ezolZTrmueXLjXNbpfJ/aOAqlnT095fDv+EaZsstC
         k5oAuFbmL08mYzMWVQSutiea4zNum8YXKrifxuX/IFIzZndtdrfEe6x+vmJOXxn+TTU/
         aR+g==
X-Gm-Message-State: APuU4Z+TKEeB1MXMTv0DMgeJoe4/vU/wIVRghnO07keLgs/amjyL50hl
	K9wVEpCszvk4uo0d1qmLKwY54UByCF0+p6BBqivXePXQLKpn95gPpYtJ/diqzAKmGFEAoCxPfYw
	+MDDqPdaSHrXY75xfM7uHlgaD7Ikg1SbvJ7rY7Ho=
X-Gm-Gg: AYBFou0UMIzj3B2KhXR9XiCFHDdIjlwj/jC69V7nawvknj6HREgw7aqNBizs4ghcVFn
	FG96Jsl/42nLB3E2/MwtUhNgV4lBo1ebNyAFxSWPm0SQvxT+hECUGZxJVlnCMYREOpqhvbA3SSw
	T8OazjSozO3bLJ9nggnO8vcR000MVavIngXtS6BgHv75U22dy1KPF3Ya7IEvzRe5m+f1r2Lp5W/
	V7+VqQFcIFsYSqDwy+eVRFoh5RwhsEEq1+rTBZejIaKgxshU1PZ7MTCQKJeKHCO7vyN2zH+u1f5
	jYWrhNGEhFHcuHKDiWxCXzZVxDGMYARLWeS18FDs4Hf/O5rDlEqxYTs99tnu4HcFdu0tPORLFDk
	CRIX9d2UT5y2w7vnLC34M8yhfamwIILTuU3d6Ve8/DplAG37SNGYVajw4aJ1XNQi0gQZ8VzoBxU
	gf
X-Received: by 2002:aa7:da0f:0:b0:6b4:8d5c:f8b with SMTP id
 4fb4d7f45d1cf-6b6fb976d73mr3042710a12.15.1794224448406; Mon, 09 Nov 2026
 03:40:48 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261107203427.1739067-1-giuseppe@scrivano.org>
In-Reply-To: <20261107203427.1739067-1-giuseppe@scrivano.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 9 Nov 2026 12:40:36 +0100
X-Gm-Features: AclHuK-7iu2C-6TfY8dKd63VP6CNneRl0rKhOnnDtEeZSuzYZI7Lv9CfabbBUXs
Message-ID: <CAOQ4uxj2VO1RhLvzjteEbogKnyLN2gNtiH-z=XYg6a_+51nHkw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: follow lower to lowerdata redirects from any
 lower layer
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: linux-unionfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000e53af4065fd66efa"

--000000000000e53af4065fd66efa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 9:34=E2=80=AFPM Giuseppe Scrivano <giuseppe@scrivano=
.org> wrote:
>
> Without metacopy=3Don, a metacopy file with an absolute redirect into a
> data-only layer is followed only from the lowest lower layer.  From any
> other lower layer, the lookup fails with EPERM.  This is always the
> case with userxattr, which cannot be used with metacopy=3Don, and with
> redirect_dir=3Dnofollow.
>
> Add redirect_dir=3Dfollowdata, which follows only redirects from lower to
> lowerdata, and select it when there are data-only layers, unless
> redirect_dir=3Dfollow or redirect_dir=3Don is in effect.  Without
> metacopy=3Don, the absolute redirect of a lower metacopy file stops the
> lookup in the lower layers and the data is looked up in the data-only
> layers.  Data-only layers cannot be used without following redirects,
> so reject redirect_dir=3Dnofollow with data-only layers.
>
> Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for lower=
 -> data redirect")
> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
> ---
> v1: https://lore.kernel.org/linux-unionfs/CAOQ4uxhVD=3DOjY7ro4rpbYu7aRC_e=
LybG+crLAQBFgMyHdw2Fgg@mail.gmail.com/T/#t
>

Hi Giuseppe,

Generally this looks good, but I found a few more redirect related bugs
during review and I applied them as separate fixes to ovl-fixes banch
so I also rebased your patch over these fixes and resolved conflicts.

I also fixes some semantic nits as below...

> Documentation/filesystems/overlayfs.rst | 16 ++++++++------
>  fs/overlayfs/namei.c                    | 28 ++++++++++++++++++++++---
>  fs/overlayfs/overlayfs.h                |  6 ++++++
>  fs/overlayfs/params.c                   | 25 ++++++++++++++++++++--
>  fs/overlayfs/super.c                    | 16 +++++++++-----
>  5 files changed, 75 insertions(+), 16 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 16c35b491dad..5d947eda09e5 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -239,6 +239,9 @@ Mount options:
>      Redirects are enabled.
>  - "redirect_dir=3Dfollow":
>      Redirects are not created, but followed.
> +- "redirect_dir=3Dfollowdata":
> +    Redirects are not created.
> +    Only redirects from lower to lowerdata are followed.
>  - "redirect_dir=3Dnofollow":
>      Redirects are not created and not followed.
>  - "redirect_dir=3Doff":
> @@ -418,8 +421,8 @@ pointed by REDIRECT. This should not be possible on l=
ocal system as setting
>  "trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
>  for untrusted layers like from a pen drive.
>
> -Note: redirect_dir=3D{off|nofollow|follow[*]} and nfs_export=3Don mount =
options
> -conflict with metacopy=3Don, and will result in an error.
> +Note: redirect_dir=3D{off|nofollow|follow[*]|followdata} and nfs_export=
=3Don
> +mount options conflict with metacopy=3Don, and will result in an error.
>
>  [*] redirect_dir=3Dfollow only conflicts with metacopy=3Don if upperdir=
=3D... is
>  given.
> @@ -460,10 +463,11 @@ to the absolute path of the "lower data" file in th=
e "data-only" lower layer.
>
>  Instead of explicitly enabling "metacopy=3Don" it is sufficient to speci=
fy at
>  least one data-only layer to enable redirection of data to a data-only l=
ayer.
> -In this case other forms of metacopy are rejected.  Note: this way, data=
-only
> -layers may be used together with "userxattr", in which case careful atte=
ntion
> -must be given to privileges needed to change the "user.overlay.redirect"=
 xattr
> -to prevent misuse.
> +In this case other forms of metacopy are rejected.  A data-only layer se=
lects
> +"redirect_dir=3Dfollowdata", unless "redirect_dir=3Dfollow" or "redirect=
_dir=3Don" is
> +in effect.  Note: this way, data-only layers may be used together with
> +"userxattr", in which case careful attention must be given to privileges=
 needed
> +to change the "user.overlay.redirect" xattr to prevent misuse.
>
>  Since kernel version v6.8, "data-only" lower layers can also be added us=
ing
>  the "datadir+" mount options and the fsconfig syscall from new mount api=
.
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ca899fdfaafd..b354d8f4b1fd 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1069,7 +1069,12 @@ static bool ovl_check_follow_redirect(struct ovl_l=
ookup_data *d)
>                 pr_warn_ratelimited("refusing to follow metacopy origin f=
or (%pd2)\n", d->dentry);
>                 return false;
>         }
> -       if ((d->redirect || d->upperredirect) && !ovl_redirect_follow(ofs=
)) {
> +       /*
> +        * redirect_dir=3Dfollowdata follows only the lower to lowerdata
> +        * redirects, which are not checked here.
> +        */
> +       if ((d->redirect || d->upperredirect) &&
> +           (!ovl_redirect_follow(ofs) || ovl_redirect_followdata(ofs))) =
{

I still don't like this due, I turned this into:

/* Check follow to lower layer, redirects to lowerdata are not checked here=
 */
if ((d->redirect || d->upperredirect) && !ovl_redirect_follow_lower(ofs)) {

...

/* Are redirects followed into lower layers? */
static inline bool ovl_redirect_follow_lower(struct ovl_fs *ofs)
{
        return ofs->config.redirect_mode =3D=3D OVL_REDIRECT_FOLLOW ||
               ofs->config.redirect_mode =3D=3D OVL_REDIRECT_ON;
}

/* Are redirects followed into lower or lowerdata layers? */
static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
{
        return ofs->config.redirect_mode !=3D OVL_REDIRECT_NOFOLLOW;
}

/* Are redirects created in upper dir? */
static inline bool ovl_redirect_dir(struct ovl_fs *ofs)
{
        return ofs->config.redirect_mode =3D=3D OVL_REDIRECT_ON;
}


>                 pr_warn_ratelimited("refusing to follow redirect for (%pd=
2)\n", d->dentry);
>                 return false;
>         }
> @@ -1087,13 +1092,26 @@ struct ovl_lookup_ctx {
>         unsigned int ctr;
>  };
>
> +/*
> + * Without metacopy=3Don, the absolute redirect of a lower metacopy file=
 is
> + * followed only into the data-only layers.
> + */
> +static bool ovl_is_lowerdata_redirect(struct ovl_lookup_ctx *ctx,
> +                                     struct ovl_lookup_data *d)
> +{
> +       struct ovl_fs *ofs =3D OVL_FS(d->sb);
> +
> +       return ofs->numdatalayer && !ofs->config.metacopy && ctx->ctr &&
> +              d->metacopy && d->absolute_redirect;
> +}
> +
>  static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_look=
up_data *d)
>  {
>         struct dentry *dentry =3D ctx->dentry;
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         struct ovl_entry *poe =3D OVL_E(dentry->d_parent);
>         struct ovl_entry *roe =3D OVL_E(dentry->d_sb->s_root);
> -       bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs->numdata=
layer);
> +       bool check_redirect =3D ovl_redirect_follow(ofs);
>         struct dentry *upperdir;
>         struct dentry *this;
>         struct dentry *origin =3D NULL;
> @@ -1224,6 +1242,10 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx=
 *ctx, struct ovl_lookup_data
>                         ctx->ctr++;
>                 }
>
> +               /* Lookup of lowerdata in the data-only layers only */
> +               if (ovl_is_lowerdata_redirect(ctx, d))
> +                       d->stop =3D true;
> +
>                 if (d->stop)
>                         break;
>
> @@ -1384,7 +1406,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>  {
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         struct ovl_entry *poe =3D OVL_E(dentry->d_parent);
> -       bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs->numdata=
layer);
> +       bool check_redirect =3D ovl_redirect_follow(ofs);
>         int err;
>         struct ovl_lookup_ctx ctx =3D {
>                 .dentry =3D dentry,
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 92da556598da..411690ea3ae3 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -78,6 +78,7 @@ enum ovl_entry_flag {
>  enum {
>         OVL_REDIRECT_OFF,       /* "off" mode is never used. In effect  *=
/
>         OVL_REDIRECT_FOLLOW,    /* ...it translates to either "follow"  *=
/
> +       OVL_REDIRECT_FOLLOWDATA,
>         OVL_REDIRECT_NOFOLLOW,  /* ...or "nofollow".                    *=
/
>         OVL_REDIRECT_ON,
>  };
> @@ -632,6 +633,11 @@ static inline bool ovl_redirect_follow(struct ovl_fs=
 *ofs)
>         return ofs->config.redirect_mode !=3D OVL_REDIRECT_NOFOLLOW;
>  }
>
> +static inline bool ovl_redirect_followdata(struct ovl_fs *ofs)
> +{
> +       return ofs->config.redirect_mode =3D=3D OVL_REDIRECT_FOLLOWDATA;
> +}
> +
>  static inline bool ovl_redirect_dir(struct ovl_fs *ofs)
>  {
>         return ofs->config.redirect_mode =3D=3D OVL_REDIRECT_ON;
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 5a15e5478a6b..2dd965121a68 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -107,6 +107,7 @@ static int ovl_xino_def(void)
>  const struct constant_table ovl_parameter_redirect_dir[] =3D {
>         { "off",        OVL_REDIRECT_OFF      },
>         { "follow",     OVL_REDIRECT_FOLLOW   },
> +       { "followdata", OVL_REDIRECT_FOLLOWDATA },
>         { "nofollow",   OVL_REDIRECT_NOFOLLOW },
>         { "on",         OVL_REDIRECT_ON       },
>         {}
> @@ -991,7 +992,8 @@ int ovl_fs_params_verify(const struct ovl_fs_context =
*ctx,
>         /* Resolve userxattr -> !redirect && !metacopy dependency */
>         if (config->userxattr) {
>                 if (set.redirect &&
> -                   config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW) {
> +                   config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW &&
> +                   config->redirect_mode !=3D OVL_REDIRECT_FOLLOWDATA) {
>                         pr_err("conflicting options: userxattr,redirect_d=
ir=3D%s\n",
>                                ovl_redirect_mode(config));
>                         return -EINVAL;
> @@ -1006,10 +1008,29 @@ int ovl_fs_params_verify(const struct ovl_fs_cont=
ext *ctx,
>                  * options must be explicitly enabled if used together wi=
th
>                  * userxattr.
>                  */
> -               config->redirect_mode =3D OVL_REDIRECT_NOFOLLOW;
> +               if (!set.redirect)
> +                       config->redirect_mode =3D OVL_REDIRECT_NOFOLLOW;
>                 config->metacopy =3D false;
>         }
>
> +       /*
> +        * Data-only layers are reached through redirects, so they cannot=
 be
> +        * used with redirect_dir=3Dnofollow: use followdata instead, or =
fail
> +        * if nofollow was requested explicitly.
> +        */
> +       if (ctx->nr_data && config->redirect_mode =3D=3D OVL_REDIRECT_NOF=
OLLOW) {
> +               if (set.redirect) {
> +                       pr_err("conflicting options: data-only layers,red=
irect_dir=3D%s\n",
> +                              ovl_redirect_mode(config));
> +                       return -EINVAL;
> +               }
> +               config->redirect_mode =3D OVL_REDIRECT_FOLLOWDATA;

I've made some changes so that the combination nofollow,daradir is only
reachable from explicit user options, so this is simplified.

> +       }
> +       if (!ctx->nr_data && config->redirect_mode =3D=3D OVL_REDIRECT_FO=
LLOWDATA) {
> +               pr_err("redirect_dir=3Dfollowdata requires data-only laye=
rs\n");
> +               return -EINVAL;
> +       }
> +
>         /*
>          * Fail if we don't have trusted xattr capability and a feature w=
as
>          * explicitly requested that requires them.
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 19b6d54c4500..d5352a95f7f6 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -680,7 +680,7 @@ static int ovl_create_volatile_dirty(struct ovl_fs *o=
fs)
>  }
>
>  static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
> -                           const struct path *workpath)
> +                           const struct path *workpath, size_t nr_data)
>  {
>         struct vfsmount *mnt =3D ovl_upper_mnt(ofs);
>         struct dentry *workdir;
> @@ -744,7 +744,12 @@ static int ovl_make_workdir(struct super_block *sb, =
struct ovl_fs *ofs,
>         if (err) {
>                 pr_warn("failed to set xattr on upper\n");
>                 ofs->noxattr =3D true;
> -               if (ovl_redirect_follow(ofs)) {
> +               /* Data-only layers require at least redirect_dir=3Dfollo=
wdata */
> +               if (nr_data && ovl_redirect_follow(ofs) &&
> +                   !ovl_redirect_followdata(ofs)) {
> +                       ofs->config.redirect_mode =3D OVL_REDIRECT_FOLLOW=
DATA;
> +                       pr_warn("...falling back to redirect_dir=3Dfollow=
data.\n");

This becomes:

                if (ovl_redirect_follow_lower(ofs)) {
                        ofs->config.redirect_mode =3D
ovl_redirect_nofollow_mode(nr_data);
                        pr_warn("...falling back to redirect_dir=3D%s.\n",
                                ovl_redirect_mode(&ofs->config));
...

/* Data-only layers cannot be used without following redirects to them */
static inline int ovl_redirect_nofollow_mode(size_t nr_data)
{
        return nr_data ? OVL_REDIRECT_FOLLOWDATA : OVL_REDIRECT_NOFOLLOW;
}


Attached full cosmetic patch (after the rebase).
Tested with your fstest.

Thanks,
Amir.

--000000000000e53af4065fd66efa
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-ovl-fixes-for-followdata.patch"
Content-Disposition: attachment; 
	filename="0001-ovl-fixes-for-followdata.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mw94rpih0>
X-Attachment-Id: f_mw94rpih0

RnJvbSBlMzY4NGExOTQ4NTA3MGI3ZTgyYWRjODI3ZWQzZjcwMGVhYmUwNGIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPgpE
YXRlOiBTdW4sIDggTm92IDIwMjYgMTY6NDE6MjAgKzAxMDAKU3ViamVjdDogW1BBVENIXSBvdmw6
IGZpeGVzIGZvciBmb2xsb3dkYXRhCgotLS0KIERvY3VtZW50YXRpb24vZmlsZXN5c3RlbXMvb3Zl
cmxheWZzLnJzdCB8ICAyICstCiBmcy9vdmVybGF5ZnMvbmFtZWkuYyAgICAgICAgICAgICAgICAg
ICAgfCAgOCArKy0tLS0KIGZzL292ZXJsYXlmcy9vdmVybGF5ZnMuaCAgICAgICAgICAgICAgICB8
IDE4ICsrKysrKysrKystLS0KIGZzL292ZXJsYXlmcy9wYXJhbXMuYyAgICAgICAgICAgICAgICAg
ICB8IDM0ICsrKysrKysrKysrKy0tLS0tLS0tLS0tLS0KIGZzL292ZXJsYXlmcy9wYXJhbXMuaCAg
ICAgICAgICAgICAgICAgICB8ICAxICsKIGZzL292ZXJsYXlmcy9zdXBlci5jICAgICAgICAgICAg
ICAgICAgICB8IDEyICsrKy0tLS0tLQogNiBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCsp
LCAzNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1z
L292ZXJsYXlmcy5yc3QgYi9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1zL292ZXJsYXlmcy5yc3QK
aW5kZXggY2Y4ZjYxNTkxNTc1Yy4uYjQ5OGM4ZTU2YzVhZCAxMDA2NDQKLS0tIGEvRG9jdW1lbnRh
dGlvbi9maWxlc3lzdGVtcy9vdmVybGF5ZnMucnN0CisrKyBiL0RvY3VtZW50YXRpb24vZmlsZXN5
c3RlbXMvb3ZlcmxheWZzLnJzdApAQCAtNDIxLDcgKzQyMSw3IEBAIHBvaW50ZWQgYnkgUkVESVJF
Q1QuIFRoaXMgc2hvdWxkIG5vdCBiZSBwb3NzaWJsZSBvbiBsb2NhbCBzeXN0ZW0gYXMgc2V0dGlu
ZwogInRydXN0ZWQuIiB4YXR0cnMgd2lsbCByZXF1aXJlIENBUF9TWVNfQURNSU4uIEJ1dCBpdCBz
aG91bGQgYmUgcG9zc2libGUKIGZvciB1bnRydXN0ZWQgbGF5ZXJzIGxpa2UgZnJvbSBhIHBlbiBk
cml2ZS4KIAotTm90ZTogcmVkaXJlY3RfZGlyPXtvZmZ8bm9mb2xsb3d8Zm9sbG93WypdfGZvbGxv
d2RhdGF9IGFuZCBuZnNfZXhwb3J0PW9uCitOb3RlOiByZWRpcmVjdF9kaXI9e29mZnxub2ZvbGxv
d3xmb2xsb3dkYXRhfGZvbGxvd1sqXX0gYW5kIG5mc19leHBvcnQ9b24KIG1vdW50IG9wdGlvbnMg
Y29uZmxpY3Qgd2l0aCBtZXRhY29weT1vbiwgYW5kIHdpbGwgcmVzdWx0IGluIGFuIGVycm9yLgog
CiBbKl0gcmVkaXJlY3RfZGlyPWZvbGxvdyBvbmx5IGNvbmZsaWN0cyB3aXRoIG1ldGFjb3B5PW9u
IGlmIHVwcGVyZGlyPS4uLiBpcwpkaWZmIC0tZ2l0IGEvZnMvb3ZlcmxheWZzL25hbWVpLmMgYi9m
cy9vdmVybGF5ZnMvbmFtZWkuYwppbmRleCAwN2YzMjI5OTA3NTJjLi5kODQ2YzhkMTViMWNjIDEw
MDY0NAotLS0gYS9mcy9vdmVybGF5ZnMvbmFtZWkuYworKysgYi9mcy9vdmVybGF5ZnMvbmFtZWku
YwpAQCAtMTA3OSwxMiArMTA3OSw4IEBAIHN0YXRpYyBib29sIG92bF9jaGVja19mb2xsb3dfcmVk
aXJlY3Qoc3RydWN0IG92bF9sb29rdXBfZGF0YSAqZCkKIAkJcHJfd2Fybl9yYXRlbGltaXRlZCgi
cmVmdXNpbmcgdG8gZm9sbG93IG1ldGFjb3B5IG9yaWdpbiBmb3IgKCVwZDIpXG4iLCBkLT5kZW50
cnkpOwogCQlyZXR1cm4gZmFsc2U7CiAJfQotCS8qCi0JICogcmVkaXJlY3RfZGlyPWZvbGxvd2Rh
dGEgZm9sbG93cyBvbmx5IHRoZSBsb3dlciB0byBsb3dlcmRhdGEKLQkgKiByZWRpcmVjdHMsIHdo
aWNoIGFyZSBub3QgY2hlY2tlZCBoZXJlLgotCSAqLwotCWlmICgoZC0+cmVkaXJlY3QgfHwgZC0+
dXBwZXJyZWRpcmVjdCkgJiYKLQkgICAgKCFvdmxfcmVkaXJlY3RfZm9sbG93KG9mcykgfHwgb3Zs
X3JlZGlyZWN0X2ZvbGxvd2RhdGEob2ZzKSkpIHsKKwkvKiBDaGVjayBmb2xsb3cgdG8gbG93ZXIg
bGF5ZXIsIHJlZGlyZWN0cyB0byBsb3dlcmRhdGEgYXJlIG5vdCBjaGVja2VkIGhlcmUgKi8KKwlp
ZiAoKGQtPnJlZGlyZWN0IHx8IGQtPnVwcGVycmVkaXJlY3QpICYmICFvdmxfcmVkaXJlY3RfZm9s
bG93X2xvd2VyKG9mcykpIHsKIAkJcHJfd2Fybl9yYXRlbGltaXRlZCgicmVmdXNpbmcgdG8gZm9s
bG93IHJlZGlyZWN0IGZvciAoJXBkMilcbiIsIGQtPmRlbnRyeSk7CiAJCXJldHVybiBmYWxzZTsK
IAl9CmRpZmYgLS1naXQgYS9mcy9vdmVybGF5ZnMvb3ZlcmxheWZzLmggYi9mcy9vdmVybGF5ZnMv
b3ZlcmxheWZzLmgKaW5kZXggMWVkNjUzMTczNmVkMi4uOWY4YzI1ZmRmZmVkYSAxMDA2NDQKLS0t
IGEvZnMvb3ZlcmxheWZzL292ZXJsYXlmcy5oCisrKyBiL2ZzL292ZXJsYXlmcy9vdmVybGF5ZnMu
aApAQCAtNjM5LDE2ICs2MzksMjYgQEAgc3RhdGljIGlubGluZSBjaGFyIG92bF9nZXRfb3BhcXVl
ZGlyX3ZhbChzdHJ1Y3Qgb3ZsX2ZzICpvZnMsCiAJcmV0dXJuIG92bF9nZXRfZGlyX3hhdHRyX3Zh
bChvZnMsIHBhdGgsIE9WTF9YQVRUUl9PUEFRVUUpOwogfQogCi1zdGF0aWMgaW5saW5lIGJvb2wg
b3ZsX3JlZGlyZWN0X2ZvbGxvdyhzdHJ1Y3Qgb3ZsX2ZzICpvZnMpCisvKiBEYXRhLW9ubHkgbGF5
ZXJzIGNhbm5vdCBiZSB1c2VkIHdpdGhvdXQgZm9sbG93aW5nIHJlZGlyZWN0cyB0byB0aGVtICov
CitzdGF0aWMgaW5saW5lIGludCBvdmxfcmVkaXJlY3Rfbm9mb2xsb3dfbW9kZShzaXplX3QgbnJf
ZGF0YSkKIHsKLQlyZXR1cm4gb2ZzLT5jb25maWcucmVkaXJlY3RfbW9kZSAhPSBPVkxfUkVESVJF
Q1RfTk9GT0xMT1c7CisJcmV0dXJuIG5yX2RhdGEgPyBPVkxfUkVESVJFQ1RfRk9MTE9XREFUQSA6
IE9WTF9SRURJUkVDVF9OT0ZPTExPVzsKIH0KIAotc3RhdGljIGlubGluZSBib29sIG92bF9yZWRp
cmVjdF9mb2xsb3dkYXRhKHN0cnVjdCBvdmxfZnMgKm9mcykKKy8qIEFyZSByZWRpcmVjdHMgZm9s
bG93ZWQgaW50byBsb3dlciBsYXllcnM/ICovCitzdGF0aWMgaW5saW5lIGJvb2wgb3ZsX3JlZGly
ZWN0X2ZvbGxvd19sb3dlcihzdHJ1Y3Qgb3ZsX2ZzICpvZnMpCiB7Ci0JcmV0dXJuIG9mcy0+Y29u
ZmlnLnJlZGlyZWN0X21vZGUgPT0gT1ZMX1JFRElSRUNUX0ZPTExPV0RBVEE7CisJcmV0dXJuIG9m
cy0+Y29uZmlnLnJlZGlyZWN0X21vZGUgPT0gT1ZMX1JFRElSRUNUX0ZPTExPVyB8fAorCSAgICAg
ICBvZnMtPmNvbmZpZy5yZWRpcmVjdF9tb2RlID09IE9WTF9SRURJUkVDVF9PTjsKK30KKworLyog
QXJlIHJlZGlyZWN0cyBmb2xsb3dlZCBpbnRvIGxvd2VyIG9yIGxvd2VyZGF0YSBsYXllcnM/ICov
CitzdGF0aWMgaW5saW5lIGJvb2wgb3ZsX3JlZGlyZWN0X2ZvbGxvdyhzdHJ1Y3Qgb3ZsX2ZzICpv
ZnMpCit7CisJcmV0dXJuIG9mcy0+Y29uZmlnLnJlZGlyZWN0X21vZGUgIT0gT1ZMX1JFRElSRUNU
X05PRk9MTE9XOwogfQogCisvKiBBcmUgcmVkaXJlY3RzIGNyZWF0ZWQgaW4gdXBwZXIgZGlyPyAq
Lwogc3RhdGljIGlubGluZSBib29sIG92bF9yZWRpcmVjdF9kaXIoc3RydWN0IG92bF9mcyAqb2Zz
KQogewogCXJldHVybiBvZnMtPmNvbmZpZy5yZWRpcmVjdF9tb2RlID09IE9WTF9SRURJUkVDVF9P
TjsKZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9wYXJhbXMuYyBiL2ZzL292ZXJsYXlmcy9wYXJh
bXMuYwppbmRleCAwOWY1ZTEyYjZkMGMxLi43MjVjNWFmY2FiODc4IDEwMDY0NAotLS0gYS9mcy9v
dmVybGF5ZnMvcGFyYW1zLmMKKysrIGIvZnMvb3ZlcmxheWZzL3BhcmFtcy5jCkBAIC0xMTgsMjEg
KzExOCwyNiBAQCBzdGF0aWMgY29uc3QgY2hhciAqb3ZsX3JlZGlyZWN0X21vZGVfbmFtZShpbnQg
cmVkaXJlY3RfbW9kZSkKIAlyZXR1cm4gb3ZsX3BhcmFtZXRlcl9yZWRpcmVjdF9kaXJbcmVkaXJl
Y3RfbW9kZV0ubmFtZTsKIH0KIAotc3RhdGljIGNvbnN0IGNoYXIgKm92bF9yZWRpcmVjdF9tb2Rl
KHN0cnVjdCBvdmxfY29uZmlnICpjb25maWcpCitjb25zdCBjaGFyICpvdmxfcmVkaXJlY3RfbW9k
ZShzdHJ1Y3Qgb3ZsX2NvbmZpZyAqY29uZmlnKQogewogCXJldHVybiBvdmxfcmVkaXJlY3RfbW9k
ZV9uYW1lKGNvbmZpZy0+cmVkaXJlY3RfbW9kZSk7CiB9CiAKLXN0YXRpYyBpbnQgb3ZsX3JlZGly
ZWN0X2ZvbGxvd19tb2RlKHZvaWQpCitzdGF0aWMgaW50IG92bF9yZWRpcmVjdF9mb2xsb3dfbW9k
ZShzaXplX3QgbnJfZGF0YSkKIHsKIAlyZXR1cm4gb3ZsX3JlZGlyZWN0X2Fsd2F5c19mb2xsb3cg
PyBPVkxfUkVESVJFQ1RfRk9MTE9XIDoKLQkJCQkJICAgIE9WTF9SRURJUkVDVF9OT0ZPTExPVzsK
KwkJCQkJICAgIG92bF9yZWRpcmVjdF9ub2ZvbGxvd19tb2RlKG5yX2RhdGEpOwogfQogCisvKgor
ICogVGhlIGRlZmF1bHQgZm9yIHNob3dfb3B0aW9ucygpIGlzIHJlc29sdmVkIGFzIGlmIHRoZXJl
IGFyZSBubyBkYXRhLW9ubHkgbGF5ZXJzLAorICogc28gdGhhdCByZWRpcmVjdF9kaXI9Zm9sbG93
ZGF0YSwgd2hpY2ggaXMgYXV0byBzZWxlY3RlZCB3aXRoIGRhdGEtb25seSBsYXllcnMsCisgKiBp
cyBkaXNwbGF5ZWQgaW4gbW91bnQgb3B0aW9ucy4KKyAqLwogc3RhdGljIGludCBvdmxfcmVkaXJl
Y3RfbW9kZV9kZWYodm9pZCkKIHsKIAlyZXR1cm4gb3ZsX3JlZGlyZWN0X2Rpcl9kZWYgPyBPVkxf
UkVESVJFQ1RfT04gOgotCQkJCSAgICAgIG92bF9yZWRpcmVjdF9mb2xsb3dfbW9kZSgpOworCQkJ
CSAgICAgIG92bF9yZWRpcmVjdF9mb2xsb3dfbW9kZSgwKTsKIH0KIAogc3RhdGljIGNvbnN0IHN0
cnVjdCBjb25zdGFudF90YWJsZSBvdmxfcGFyYW1ldGVyX3Zlcml0eVtdID0gewpAQCAtODMwLDcg
KzgzNSw4IEBAIGludCBvdmxfaW5pdF9mc19jb250ZXh0KHN0cnVjdCBmc19jb250ZXh0ICpmYykK
IAkgKiB1cHBlciBkaXIuICBJZiB0aGV5IGFyZSBub3QsIHRoZSByZWRpcmVjdCBmb2xsb3cgbW9k
ZSB3aWxsIGJlCiAJICogZGV0ZXJtaW5lZCBsYXRlci4KIAkgKi8KLQlvZnMtPmNvbmZpZy5yZWRp
cmVjdF9tb2RlCT0gb3ZsX3JlZGlyZWN0X21vZGVfZGVmKCk7CisJb2ZzLT5jb25maWcucmVkaXJl
Y3RfbW9kZQk9IG92bF9yZWRpcmVjdF9kaXJfZGVmID8KKwkJCQkJICBPVkxfUkVESVJFQ1RfT04g
OiBPVkxfUkVESVJFQ1RfT0ZGOwogCW9mcy0+Y29uZmlnLmluZGV4CQk9IG92bF9pbmRleF9kZWY7
CiAJb2ZzLT5jb25maWcudXVpZAkJPSBvdmxfdXVpZF9kZWYoKTsKIAlvZnMtPmNvbmZpZy5uZnNf
ZXhwb3J0CQk9IG92bF9uZnNfZXhwb3J0X2RlZjsKQEAgLTkxOCw3ICs5MjQsNyBAQCBpbnQgb3Zs
X2ZzX3BhcmFtc192ZXJpZnkoY29uc3Qgc3RydWN0IG92bF9mc19jb250ZXh0ICpjdHgsCiAKIAkv
KiBSZXNvbHZlIHJlZGlyZWN0X2Rpcj1vZmYgdG8gdGhlIGRlZmF1bHQgcmVkaXJlY3QgZm9sbG93
IG1vZGUgKi8KIAlpZiAoY29uZmlnLT5yZWRpcmVjdF9tb2RlID09IE9WTF9SRURJUkVDVF9PRkYp
Ci0JCWNvbmZpZy0+cmVkaXJlY3RfbW9kZSA9IG92bF9yZWRpcmVjdF9mb2xsb3dfbW9kZSgpOwor
CQljb25maWctPnJlZGlyZWN0X21vZGUgPSBvdmxfcmVkaXJlY3RfZm9sbG93X21vZGUoY3R4LT5u
cl9kYXRhKTsKIAogCS8qCiAJICogVGhpcyBpcyB0byBtYWtlIHRoZSBsb2dpYyBiZWxvdyBzaW1w
bGVyLiAgSXQgZG9lc24ndCBtYWtlIGFueSBvdGhlcgpAQCAtMTAzMiwyMiArMTAzOCwxNCBAQCBp
bnQgb3ZsX2ZzX3BhcmFtc192ZXJpZnkoY29uc3Qgc3RydWN0IG92bF9mc19jb250ZXh0ICpjdHgs
CiAJCSAqIHVzZXJ4YXR0ci4KIAkJICovCiAJCWlmICghc2V0LnJlZGlyZWN0KQotCQkJY29uZmln
LT5yZWRpcmVjdF9tb2RlID0gT1ZMX1JFRElSRUNUX05PRk9MTE9XOworCQkJY29uZmlnLT5yZWRp
cmVjdF9tb2RlID0gb3ZsX3JlZGlyZWN0X25vZm9sbG93X21vZGUoY3R4LT5ucl9kYXRhKTsKIAkJ
Y29uZmlnLT5tZXRhY29weSA9IGZhbHNlOwogCX0KIAotCS8qCi0JICogRGF0YS1vbmx5IGxheWVy
cyBhcmUgcmVhY2hlZCB0aHJvdWdoIHJlZGlyZWN0cywgc28gdGhleSBjYW5ub3QgYmUKLQkgKiB1
c2VkIHdpdGggcmVkaXJlY3RfZGlyPW5vZm9sbG93OiB1c2UgZm9sbG93ZGF0YSBpbnN0ZWFkLCBv
ciBmYWlsCi0JICogaWYgbm9mb2xsb3cgd2FzIHJlcXVlc3RlZCBleHBsaWNpdGx5LgotCSAqLwor
CS8qIERhdGEtb25seSBsYXllcnMgYXJlIHJlYWNoZWQgdGhyb3VnaCByZWRpcmVjdHMgKi8KIAlp
ZiAoY3R4LT5ucl9kYXRhICYmIGNvbmZpZy0+cmVkaXJlY3RfbW9kZSA9PSBPVkxfUkVESVJFQ1Rf
Tk9GT0xMT1cpIHsKLQkJaWYgKHNldC5yZWRpcmVjdCkgewotCQkJcHJfZXJyKCJjb25mbGljdGlu
ZyBvcHRpb25zOiBkYXRhLW9ubHkgbGF5ZXJzLHJlZGlyZWN0X2Rpcj0lc1xuIiwKLQkJCSAgICAg
ICBvdmxfcmVkaXJlY3RfbW9kZV9uYW1lKHJlZGlyZWN0X29wdCkpOwotCQkJcmV0dXJuIC1FSU5W
QUw7Ci0JCX0KLQkJY29uZmlnLT5yZWRpcmVjdF9tb2RlID0gT1ZMX1JFRElSRUNUX0ZPTExPV0RB
VEE7CisJCXByX2VycigicmVkaXJlY3RfZGlyPW5vZm9sbG93IGlzIG5vdCBzdXBwb3J0ZWQgd2l0
aCBkYXRhLW9ubHkgbGF5ZXJzXG4iKTsKKwkJcmV0dXJuIC1FSU5WQUw7CiAJfQogCWlmICghY3R4
LT5ucl9kYXRhICYmIGNvbmZpZy0+cmVkaXJlY3RfbW9kZSA9PSBPVkxfUkVESVJFQ1RfRk9MTE9X
REFUQSkgewogCQlwcl9lcnIoInJlZGlyZWN0X2Rpcj1mb2xsb3dkYXRhIHJlcXVpcmVzIGRhdGEt
b25seSBsYXllcnNcbiIpOwpkaWZmIC0tZ2l0IGEvZnMvb3ZlcmxheWZzL3BhcmFtcy5oIGIvZnMv
b3ZlcmxheWZzL3BhcmFtcy5oCmluZGV4IGZmZDUzY2RkODQ4MjcuLjMxNjFhYTFlZTlkZGMgMTAw
NjQ0Ci0tLSBhL2ZzL292ZXJsYXlmcy9wYXJhbXMuaAorKysgYi9mcy9vdmVybGF5ZnMvcGFyYW1z
LmgKQEAgLTQyLDMgKzQyLDQgQEAgaW50IG92bF9mc19wYXJhbXNfdmVyaWZ5KGNvbnN0IHN0cnVj
dCBvdmxfZnNfY29udGV4dCAqY3R4LAogCQkJIHN0cnVjdCBvdmxfY29uZmlnICpjb25maWcpOwog
aW50IG92bF9zaG93X29wdGlvbnMoc3RydWN0IHNlcV9maWxlICptLCBzdHJ1Y3QgZGVudHJ5ICpk
ZW50cnkpOwogY29uc3QgY2hhciAqb3ZsX3hpbm9fbW9kZShzdHJ1Y3Qgb3ZsX2NvbmZpZyAqY29u
ZmlnKTsKK2NvbnN0IGNoYXIgKm92bF9yZWRpcmVjdF9tb2RlKHN0cnVjdCBvdmxfY29uZmlnICpj
b25maWcpOwpkaWZmIC0tZ2l0IGEvZnMvb3ZlcmxheWZzL3N1cGVyLmMgYi9mcy9vdmVybGF5ZnMv
c3VwZXIuYwppbmRleCA1YjViNjJhOWQ3MTQ2Li41OGYyOTk0YTZiZWNlIDEwMDY0NAotLS0gYS9m
cy9vdmVybGF5ZnMvc3VwZXIuYworKysgYi9mcy9vdmVybGF5ZnMvc3VwZXIuYwpAQCAtNzY1LDE0
ICs3NjUsMTAgQEAgc3RhdGljIGludCBvdmxfbWFrZV93b3JrZGlyKHN0cnVjdCBzdXBlcl9ibG9j
ayAqc2IsIHN0cnVjdCBvdmxfZnMgKm9mcywKIAlpZiAoZXJyKSB7CiAJCXByX3dhcm4oImZhaWxl
ZCB0byBzZXQgeGF0dHIgb24gdXBwZXJcbiIpOwogCQlvZnMtPm5veGF0dHIgPSB0cnVlOwotCQkv
KiBEYXRhLW9ubHkgbGF5ZXJzIHJlcXVpcmUgYXQgbGVhc3QgcmVkaXJlY3RfZGlyPWZvbGxvd2Rh
dGEgKi8KLQkJaWYgKG5yX2RhdGEgJiYgb3ZsX3JlZGlyZWN0X2ZvbGxvdyhvZnMpICYmCi0JCSAg
ICAhb3ZsX3JlZGlyZWN0X2ZvbGxvd2RhdGEob2ZzKSkgewotCQkJb2ZzLT5jb25maWcucmVkaXJl
Y3RfbW9kZSA9IE9WTF9SRURJUkVDVF9GT0xMT1dEQVRBOwotCQkJcHJfd2FybigiLi4uZmFsbGlu
ZyBiYWNrIHRvIHJlZGlyZWN0X2Rpcj1mb2xsb3dkYXRhLlxuIik7Ci0JCX0gZWxzZSBpZiAoIW5y
X2RhdGEgJiYgb3ZsX3JlZGlyZWN0X2ZvbGxvdyhvZnMpKSB7Ci0JCQlvZnMtPmNvbmZpZy5yZWRp
cmVjdF9tb2RlID0gT1ZMX1JFRElSRUNUX05PRk9MTE9XOwotCQkJcHJfd2FybigiLi4uZmFsbGlu
ZyBiYWNrIHRvIHJlZGlyZWN0X2Rpcj1ub2ZvbGxvdy5cbiIpOworCQlpZiAob3ZsX3JlZGlyZWN0
X2ZvbGxvd19sb3dlcihvZnMpKSB7CisJCQlvZnMtPmNvbmZpZy5yZWRpcmVjdF9tb2RlID0gb3Zs
X3JlZGlyZWN0X25vZm9sbG93X21vZGUobnJfZGF0YSk7CisJCQlwcl93YXJuKCIuLi5mYWxsaW5n
IGJhY2sgdG8gcmVkaXJlY3RfZGlyPSVzLlxuIiwKKwkJCQlvdmxfcmVkaXJlY3RfbW9kZSgmb2Zz
LT5jb25maWcpKTsKIAkJfQogCQlpZiAob2ZzLT5jb25maWcubWV0YWNvcHkpIHsKIAkJCW9mcy0+
Y29uZmlnLm1ldGFjb3B5ID0gZmFsc2U7Ci0tIAoyLjU2LjAKCg==
--000000000000e53af4065fd66efa--
