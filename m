Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0143128C0
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 11:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763121194; cv=none; b=J2zhzQJgmoB3+GFPdU1FZ0qXtGET03JY4y+sj3YVFmr8pnfsvVwnNN7JWzF4JwhIlNje+8MJvW4e62GV/BGVST17xOEcIPHPUpwiLdEgA5iatVr4igLtOT1Qc4poczdedjJ0viAMqI7YCWN25mNfug+wm/TnYqlN7gzlyFzHjOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763121194; c=relaxed/simple;
	bh=tCwBw4AnF2vtIl9rSeHRKWGJE+A+XndJ29JaC2CBIps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VmqX6HE+xeaeYpCI9t8pfwZaUxHeyuExwsrhGWJlUiQwgLpNst/HWy6QtsVAO9Gs+fXDq9+697XVgIO0pflqBULTXyCZ1uKZa/QoB4G2zioGW28fLrRO15SZAkqJ8gkGrnsZpatCf6U0Y5jXC5IWwbbVo13Z1mgikuG3qEf+VAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jNK46nwF; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNK46nwF"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640860f97b5so3089054a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 03:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763121190; x=1763725990; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ksUowDiMBBw0jAf3Vm8E59fNicG0SGTHjGTGP1KX/Rc=;
        b=jNK46nwFz076NcnM8Kw/MYbGa0ePwD8HKqOPj4mn1tSDkIP0VkY7fBp50a4I0uZBdr
         UACnW2ct5H0O4hYOzyS5kJOUCgg+o92FBdgJkWq7DRlJ3Kc7XGQMii4eCT3A1Bp1hkTU
         qinmVtgAAvEX1c4d4sftmIiXpuIqVYT9ApT3eJfi7KTLlYs4EolCWR3zndMpCS/8Mhgz
         B2OhiedvC+OufyR+U5zdXmNG86s6qGBbcBrBcpxPIfauONoWv2G3Yz1XHoV4T5eGMcvK
         u9yY/merK3TuiEwRRyN9qcfBY2BAVWfuUosNja+DdEU/KW/97KibzY1k2MF78F9J5Kng
         9Ofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763121190; x=1763725990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ksUowDiMBBw0jAf3Vm8E59fNicG0SGTHjGTGP1KX/Rc=;
        b=fwj/cByMurI+e2+k4cqOwoAeVvmGdZpyhD/oqS+HzFGuDkpRjWXxp7TxTo+TvYwiXd
         VgP+6Lx9Gt2HivEFKakfjnGbwoDrON1lywP7a0rcq2jwW+Z+fMhNqLvxuSO9qb6hD3Hw
         JYlmbFyuF+w7K0bScj932iflFYumEB2zP+9wum2IPaIWGSfkfzew6keqKH4xG5r+Lo+G
         p3Oz++bCJWKtUArfBaG0y8lk+jJ+dbIGC/CeOHQSHtWe0nHqUYP1TO3a/cTMibrqc81j
         XAh0QGHE5/MTJaG5wkpBLGWmd5EVWn3xyhQG0aEhvAfQBg2RMes1QI4NudiiYIerWCD+
         q0Cg==
X-Forwarded-Encrypted: i=1; AJvYcCU2y21ZXQIiLMuahWOgMNQj8f7R3dplvGiafSIdEAMiD6H5GJgqc5pL1rApF+634+DpBaUlNJPteJGTWU+9@vger.kernel.org
X-Gm-Message-State: AOJu0YwPI9NsCvS1IuuTFCf9Zqz5smXMqrQ57PEyTBk8hAA0IAXhhRo2
	Aw0W0n6Lv0r9FCpsM95Wicg0xq/yKg+gzu61ONuwg5jISWjPgdMcLiahesYA72Akb6SWZJTRrlZ
	4ewY6ZAOtxQidZVsLmQrZDaIySGRwyPw=
X-Gm-Gg: ASbGncvCWuZbOHczwXmOYjBML5n3zRblbjZu523meQVnzOtITButdH9mr6A837wg5Y3
	P3ncWcMrhk+08R58FBjGmtwGxyLZT1DS7Rp10jOqnWuxrZQJdaWiiaPm8dyFksVGji5QcEF0HP8
	edDF5wwarQ62QsfhCkKjwPF9HU7/8l8Liy7GnwMU1GK1uFQaw5OEbfFudbHmcvJan1jJWjPDaXb
	p46e5/51n39nwfOpk8udArxrY5TV/0yhalelW/goZ9Mb5vKOrcy0hx0QRlC8x9aH/0ixqclzDAA
	arAmsdNwtf0ZnUh5voX9Lwi/dv5vgQ==
X-Google-Smtp-Source: AGHT+IFkNCbCK3wtGpbvZ8sWyqGdvw8H6M3hi3GmiaEXmGlh4THeFELMo16lZrrcznsxz7tUwsSSgqFG6UbMZJsfjjE=
X-Received: by 2002:a05:6402:13c8:b0:63b:f67b:3782 with SMTP id
 4fb4d7f45d1cf-64350e9e7b4mr2686740a12.27.1763121190367; Fri, 14 Nov 2025
 03:53:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114-work-ovl-cred-guard-prepare-v1-0-4fc1208afa3d@kernel.org>
 <20251114-work-ovl-cred-guard-prepare-v1-3-4fc1208afa3d@kernel.org>
In-Reply-To: <20251114-work-ovl-cred-guard-prepare-v1-3-4fc1208afa3d@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 14 Nov 2025 12:52:58 +0100
X-Gm-Features: AWmQ_bmj3WV3e9oB_pc-wmTp-eN0ihrkNcdAYjq3ylUYQU-O6HjG8yRlK0U2GcQ
Message-ID: <CAOQ4uxhB2am_xAGugZvAiuEx7ud+8QGPJBwcA+M+LmRvWC-nsA@mail.gmail.com>
Subject: Re: [PATCH 3/6] ovl: reflow ovl_create_or_link()
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 11:15=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> Reflow the creation routine in preparation of porting it to a guard.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/overlayfs/dir.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index a276eafb5e78..ff30a91e07f8 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -644,14 +644,23 @@ static const struct cred *ovl_setup_cred_for_create=
(struct dentry *dentry,
>         return override_cred;
>  }
>
> +static int do_ovl_create_or_link(struct dentry *dentry, struct inode *in=
ode,
> +                                struct ovl_cattr *attr)

Trying to avert the bikesheding over do_ovl_ helper name...

> +{
> +       if (!ovl_dentry_is_whiteout(dentry))
> +               return ovl_create_upper(dentry, inode, attr);
> +
> +       return ovl_create_over_whiteout(dentry, inode, attr);
> +}
> +
>  static int ovl_create_or_link(struct dentry *dentry, struct inode *inode=
,
>                               struct ovl_cattr *attr, bool origin)
>  {
>         int err;
> -       const struct cred *new_cred __free(put_cred) =3D NULL;
>         struct dentry *parent =3D dentry->d_parent;
>
>         scoped_class(override_creds_ovl, old_cred, dentry->d_sb) {
> +               const struct cred *new_cred __free(put_cred) =3D NULL;
>                 /*
>                  * When linking a file with copy up origin into a new par=
ent, mark the
>                  * new parent dir "impure".
> @@ -662,7 +671,6 @@ static int ovl_create_or_link(struct dentry *dentry, =
struct inode *inode,
>                                 return err;
>                 }
>
> -               if (!attr->hardlink) {
>                 /*
>                  * In the creation cases(create, mkdir, mknod, symlink),
>                  * ovl should transfer current's fs{u,g}id to underlying
> @@ -676,16 +684,15 @@ static int ovl_create_or_link(struct dentry *dentry=
, struct inode *inode,
>                  * create a new inode, so just use the ovl mounter's
>                  * fs{u,g}id.
>                  */
> +
> +               if (attr->hardlink)
> +                       return do_ovl_create_or_link(dentry, inode, attr)=
;
> +

^^^ This looks like an optimization (don't setup cred for hardlink).
Is it really an important optimization that is worth complicating the code =
flow?
What if we just drop the optimization instead?
Would that creak anything?

Thanks,
Amir.
