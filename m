Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867AF324B07
	for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 09:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763373335; cv=none; b=UR4sUU08PI1cnaz8leh9EnEuaBIPjSRxvJCazYk9cQaOQohOsEzGuTHuQbzaLNnk0sPY+HzycBzk7JWVqHoXiakwNTcLmzzD6OEuMSMg/6pYIYNhFC2WpNsOrUM2FukQXxJp2yQKKLb1HCeXVdEBH0GqDU6ll3TtXnk3fUVpsNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763373335; c=relaxed/simple;
	bh=mbfqgMlgAZGEp1MTsFHP9p0GINPHMCO4aTwfngB/Kmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uvAR58PIlZKUiEZPVr1kond5YD+garoiTHRu2ZyXHQlocHvbYzmWv3lykIzRjKh+xCUc71bbHRAv7tQRGPAf0EgcWO3ouVnTdXDle930c5prqMdF69deDSat/teMdTA8IwJyX8BdE8FJvg0PF3vd8fQk9P9M0Iafp2tgBrO/5OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gA72PwZi; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gA72PwZi"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6418738efa0so7008020a12.1
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 01:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763373332; x=1763978132; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kaM20/LebyWp7KNDcj2dnq1btlcS+CDQ9mPs7xg6lq4=;
        b=gA72PwZiqsmmQ54blHlX0l4JB/YlIsWQ/J0GtFtW+lu6FBW3U3qv7Y/65TBieD1N8/
         SieRUGMfjVluB5NMHjl34UbCDFxPqHjM6ImRgx1g7UJy/uf+WOkTTcaDEDBA7k5hALuV
         6ah0KFdQL1yaqDYj65rzlpynkaq/8SqqCvma79yxHBzn2I6uQkSdYHXbgAmqgYwrHXbd
         X9/htT1vavAGZ6w84b5C5PG8moXvfmIdb4WeReYCy1U0x+qqutUWke90BK8TfNoZwDaS
         il0AgMtt0H3TIEsJnTpmwrW6FvtcRecxNt8ybwHdHzzLFoPR9YZ1CG1ZGBf88+3W1lJG
         k4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763373332; x=1763978132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kaM20/LebyWp7KNDcj2dnq1btlcS+CDQ9mPs7xg6lq4=;
        b=KMp3lbZsF/KWqYaBm5+W/zWR+zzYpUjm72DSs/+jF7q4/aqMwrGT5Dudf8d78Oi0f+
         oAVdCq/w88ySAaUTaRGS69SqINzxZ9PI9VvUTryX8er/thZ2w/DrIluBeFvx7YGRFj21
         R6sTokFcYtS5Z4r1Os7CZXV6c/4VZzzulXaxUdnpDuG7KBCkLFJV9gAS3XknRMKQvJ14
         U8c6N2UFwx8pgdSou9rqI2+lS69DJrqLDx9h4px1WqyqMhQUEDDGbkRpBmudsb461Ykf
         6wT2PKgsCPw2APxkNlg+vhKHWzwSCsfmbsMpfcwMPTSLU/oD9fxgYySYpaPbfUyIKY+C
         o3Tw==
X-Forwarded-Encrypted: i=1; AJvYcCWWSxpMNRbT2cbM8qmnP+QMzODkr8o9B03hmc5d0QU8sdm9fUfSWbuOqhuAsM5VVGOIt2dASAmEcW7Ov5S+@vger.kernel.org
X-Gm-Message-State: AOJu0YxCY7K7Yl2bP8f+sVPA0uy1pFUfHYhXIS5zQSCTCb3TIIRj2isn
	mjjZyjWxZKdHl9hMP17yYhW85pOxOHt75A73d9VY0voAx+PDAIkLZkVXHxcKB7wVsKBbZI4mwQ1
	xCFzo8OEafXIm83FpVCPlEEE3OSLmbKzeSwH7MGrEHQ==
X-Gm-Gg: ASbGnct/b5Ccsla2aWX2OE2czouDTAKJEK6IYHhF1u8VZ/ANBahS3/TMxIL8ylnhKF2
	ULd+DwmhM0CVRFBxpfleOZczEcB6t4UJGFIKDqFcj3MYRwMaYQiBdEMWs/b94WREJcI1ekqyTEr
	0kA5OwM6c5ocjZAwHEplZNa43qd4YktFgXlCiWwQhVaQY8FBBUf3FXJg39w6pSm+MQHux/m5p4x
	ligxN/yfZmXG3q6KHFBXCjZhh/j+sH9wAjIhZweJUTTLewGDT0EMwZtMfaSAzZwMQLvjtmeGjcM
	6q3dFv/+9rNE1v7ziA==
X-Google-Smtp-Source: AGHT+IFOzQhT+umUUhEWEDUzuJIovDuUNO/O/raziapLXfMFVK7nryiKwf2fSS/oKvTZPuD8Def+UvAJhdPaZfP5ZC4=
X-Received: by 2002:a05:6402:5188:b0:63c:66b5:bbbf with SMTP id
 4fb4d7f45d1cf-64350e76061mr11447399a12.20.1763373331702; Mon, 17 Nov 2025
 01:55:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117-work-ovl-cred-guard-prepare-v2-0-bd1c97a36d7b@kernel.org>
 <20251117-work-ovl-cred-guard-prepare-v2-5-bd1c97a36d7b@kernel.org>
In-Reply-To: <20251117-work-ovl-cred-guard-prepare-v2-5-bd1c97a36d7b@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 17 Nov 2025 10:55:20 +0100
X-Gm-Features: AWmQ_bmvfkdb1mmo-rGl_lHW_kxSD_AM6Svdg9h8eCI97ENz8trjfvjbKCc5JKk
Message-ID: <CAOQ4uxiUWs+ZG5ce7M+oXuj-xg8+wKeRMcJngtG3E4ApVa4KHA@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ovl: port ovl_create_or_link() to new
 ovl_override_creator_creds cleanup guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 10:35=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> This clearly indicates the double-credential override and makes the code
> a lot easier to grasp with one glance.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 1bb311a25303..cb474b649ed2 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -657,10 +657,9 @@ static int ovl_create_or_link(struct dentry *dentry,=
 struct inode *inode,
>                               struct ovl_cattr *attr, bool origin)
>  {
>         int err;
> -       const struct cred *new_cred __free(put_cred) =3D NULL;
>         struct dentry *parent =3D dentry->d_parent;
>
> -       scoped_class(override_creds_ovl, old_cred, dentry->d_sb) {
> +       with_ovl_creds(dentry->d_sb) {
>                 /*
>                  * When linking a file with copy up origin into a new par=
ent, mark the
>                  * new parent dir "impure".
> @@ -688,12 +687,12 @@ static int ovl_create_or_link(struct dentry *dentry=
, struct inode *inode,
>                 if (attr->hardlink)
>                         return do_ovl_create_or_link(dentry, inode, attr)=
;
>
> -               new_cred =3D ovl_setup_cred_for_create(dentry, inode, att=
r->mode, old_cred);
> -               if (IS_ERR(new_cred))
> -                       return PTR_ERR(new_cred);
> -
> +               scoped_class(ovl_override_creator_creds, cred, dentry, in=
ode, attr->mode) {
> +                       if (IS_ERR(cred))
> +                               return PTR_ERR(cred);
>                         return do_ovl_create_or_link(dentry, inode, attr)=
;
>                 }
> +       }
>         return err;
>  }
>
>
> --
> 2.47.3
>
