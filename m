Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68EB19006B
	for <linux-unionfs@vger.kernel.org>; Fri,  5 Dec 2025 13:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764940239; cv=none; b=gBravg5qk/v2DZ3jzNrAmD4GAu4+Nuy4ZPwfgCIvyMZd950Fqlm5yFd8KjLA3tGatn2sPUrdKgyJNuKUEOKfamLzm0LXw8UIPezj3nLVrmhExJXJmOhtVy9xwsLlCbvSKg8DcgLEYvkX1nILouxU7kiPu4LIQzsisU1Z+3qinsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764940239; c=relaxed/simple;
	bh=4xT4/pFJO58+sUQqy+VKD18mXqMmuLjv58AdpSWrsqo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eXco9UV7DHOklj0pcfnqh6PSI92nc9KRMMqal+oE5ff+lG4BRmkzowFqeN0J+rfT5VX+VLCXqidHL2xWExzy6lXbEB4xI4vBf5+HIGAcTFYFYTEJQBZwvTYHq0rT5QCwk12MNKs/gESp/thyNcPEXWMBD0+EnLRwc8BqcHELwNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jANnTY5C; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jANnTY5C"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-644fcafdce9so3360086a12.1
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Dec 2025 05:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764940232; x=1765545032; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BcX4laLHRubdDtehon4atANvt8XPKg8C/L9HFHj0XXM=;
        b=jANnTY5CKI/iWOxZj4Gux9ylngOhasqpEi7Y2aPgB49Ej4PZXGQ15SMJcCHVeUoOvr
         pGZr5drc4iyc5013evVuE+vNh2HyHJ3KneaTHkjbzaAyBrk5R5F/aMrcLS3coTPsResl
         GflWxCOAx/qv28K9JIaAUYXQPge4vFeg3bbgYq5BpNDbUz7OaepXCyWVbR3Rk1PJg0yn
         +nTTl7B/1Pe5FSW3VWCJPDthkembivvx07s58kMo/vMFMlP8Yysm1mKc1em/o8MNmR25
         efaeko1falL8SAcMhD3seEES/V6IeWoQ5QRbCCf0H0rfFAF3QE8XfPVNiryinxKq/5Y0
         FDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764940232; x=1765545032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BcX4laLHRubdDtehon4atANvt8XPKg8C/L9HFHj0XXM=;
        b=qK22xbljwrb+ZogIFAlNc0fOgKfVwoCL8LmowanUjEo79lnBoqS9uOhg8RKh8g2Trx
         GcDrnqpmVohQkkHUE/JOP7YmVrFYc/dm6xqQsxeK/82y2HEuLhx390tuxRbfoN1xoM99
         BeulJ9n8LrwFzNnmFryrJEkeZ25oetcSSmTSq4px/AYs7DdMbVgnQ2Ayotrqz4FGtAO/
         4PLHTFuiQ3UaTZ/Q0CGtEmCeS7eIN5JJ6Uv0/5vMiOIW9xV8g0F8BNctvqvSVW9jPKIV
         MqX32CbcCo2xbuxWeGLjAswcqRM96MHLjJznzUBWrKfNwp/pZWzQwmoUuhl2pVHlwkeR
         CqJA==
X-Forwarded-Encrypted: i=1; AJvYcCWcLo+Nc43jNH9i6NLAtI65GszJygx3xUYORmhnT1LrkAhGx6/4bBqGBarNzRtRKvB7HtodUs2R5zPpULSy@vger.kernel.org
X-Gm-Message-State: AOJu0Yxoof4e5rSK6CRea2WNG3Fy9vw9dcWKHZmsfRH++HpFqMsc3AC8
	4kiwm1ZhHeqX7mCK4fKTit4lgxKK3r5FpPxf7whe2L1wCdxdI1lt+M0L3TmvH2uvQS+Ok/zrn/t
	E64xbKslf7fwthQ9VMOH7LB5hf/3mjxc=
X-Gm-Gg: ASbGncspNZ7p3VPPMFgKpIZRrAd1G0XH9PKqsU+h3xETJ5w+rgd0RX68WhY9UN4GuY2
	vwxZrCzsV3no/WWlUQbQlxBSICFNRfVLU32BGAX45SoDUVzzMS0C1b+PqVmGbBXub8Gfy3FUM3I
	9QwuugSV65Xl+EnxfPGGcnPNG3um3oXQVielaPR6eRENAc7oVpQpeFvOjfuOPgxv1B7LVu1nnmO
	oSmkpJotmudWaWRhzcWSlIRQqNupMCEgEx8PAiral4HCQWrmuHek5kGvwMwoAp1wwNDiGTWOdPC
	8U5FithdbxLymere8cjjN/3Gk5FcIw==
X-Google-Smtp-Source: AGHT+IH+bjqgyF4OybLZ1CaPOMTtMUxyQI+oBWVuVFxhRMeYZbs+FAfFHkppRjihAVO8Xel8hzJQI9GT1FDKtcuBEeM=
X-Received: by 2002:a17:907:3d89:b0:b73:5e4d:fae0 with SMTP id
 a640c23a62f3a-b79ec472670mr615900466b.23.1764940232062; Fri, 05 Dec 2025
 05:10:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205-tortur-amtieren-1273b2eef469@brauner>
In-Reply-To: <20251205-tortur-amtieren-1273b2eef469@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 5 Dec 2025 14:10:20 +0100
X-Gm-Features: AQt7F2o5_v64pqrTjhaGm5Wj_Gk-rT48H5Sc9ihWo997QO_hAZaF5Fa4k5_WQKw
Message-ID: <CAOQ4uxjxcNW174cdJzjPErPkKarpM=zyXhexXWc3YRJLB1mSHg@mail.gmail.com>
Subject: Re: [PATCH] ovl: pass original credentials, not mounter credentials
 during create
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 1:11=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> When creating new files the security layer expects the original
> credentials to be passed. When cleaning up the code this was accidently
> changed to pass the mounter's credentials by relying on current->cred
> which is already overriden at this point. Pass the original credentials
> directly.
>
> Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
> Reported-by: Paul Moore <paul@paul-moore.com>
> Fixes: e566bff96322 ("ovl: port ovl_create_or_link() to new ovl_override_=
creator_creds")
> Link: https://lore.kernel.org/CAFqZXNvL1ciLXMhHrnoyBmQu1PAApH41LkSWEhrcvz=
AAbFij8Q@mail.gmail.com
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Looks sane
Thanks,

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/dir.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 06b860b9ded6..ff3dbd1ca61f 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -581,7 +581,8 @@ static int ovl_create_over_whiteout(struct dentry *de=
ntry, struct inode *inode,
>         goto out_dput;
>  }
>
> -static const struct cred *ovl_override_creator_creds(struct dentry *dent=
ry, struct inode *inode, umode_t mode)
> +static const struct cred *ovl_override_creator_creds(const struct cred *=
original_creds,
> +                                                    struct dentry *dentr=
y, struct inode *inode, umode_t mode)
>  {
>         int err;
>
> @@ -596,7 +597,7 @@ static const struct cred *ovl_override_creator_creds(=
struct dentry *dentry, stru
>         override_cred->fsgid =3D inode->i_gid;
>
>         err =3D security_dentry_create_files_as(dentry, mode, &dentry->d_=
name,
> -                                             current->cred, override_cre=
d);
> +                                             original_creds, override_cr=
ed);
>         if (err)
>                 return ERR_PTR(err);
>
> @@ -614,8 +615,11 @@ static void ovl_revert_creator_creds(const struct cr=
ed *old_cred)
>  DEFINE_CLASS(ovl_override_creator_creds,
>              const struct cred *,
>              if (!IS_ERR_OR_NULL(_T)) ovl_revert_creator_creds(_T),
> -            ovl_override_creator_creds(dentry, inode, mode),
> -            struct dentry *dentry, struct inode *inode, umode_t mode)
> +            ovl_override_creator_creds(original_creds, dentry, inode, mo=
de),
> +            const struct cred *original_creds,
> +            struct dentry *dentry,
> +            struct inode *inode,
> +            umode_t mode)
>
>  static int ovl_create_handle_whiteouts(struct dentry *dentry,
>                                        struct inode *inode,
> @@ -633,7 +637,7 @@ static int ovl_create_or_link(struct dentry *dentry, =
struct inode *inode,
>         int err;
>         struct dentry *parent =3D dentry->d_parent;
>
> -       with_ovl_creds(dentry->d_sb) {
> +       scoped_class(override_creds_ovl, original_creds, dentry->d_sb) {
>                 /*
>                  * When linking a file with copy up origin into a new par=
ent, mark the
>                  * new parent dir "impure".
> @@ -661,7 +665,7 @@ static int ovl_create_or_link(struct dentry *dentry, =
struct inode *inode,
>                 if (attr->hardlink)
>                         return ovl_create_handle_whiteouts(dentry, inode,=
 attr);
>
> -               scoped_class(ovl_override_creator_creds, cred, dentry, in=
ode, attr->mode) {
> +               scoped_class(ovl_override_creator_creds, cred, original_c=
reds, dentry, inode, attr->mode) {
>                         if (IS_ERR(cred))
>                                 return PTR_ERR(cred);
>                         return ovl_create_handle_whiteouts(dentry, inode,=
 attr);
> @@ -1364,8 +1368,8 @@ static int ovl_create_tmpfile(struct file *file, st=
ruct dentry *dentry,
>         int flags =3D file->f_flags | OVL_OPEN_FLAGS;
>         int err;
>
> -       with_ovl_creds(dentry->d_sb) {
> -               scoped_class(ovl_override_creator_creds, cred, dentry, in=
ode, mode) {
> +       scoped_class(override_creds_ovl, original_creds, dentry->d_sb) {
> +               scoped_class(ovl_override_creator_creds, cred, original_c=
reds, dentry, inode, mode) {
>                         if (IS_ERR(cred))
>                                 return PTR_ERR(cred);
>
> --
> 2.47.3
>
