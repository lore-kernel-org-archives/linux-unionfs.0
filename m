Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471EE1EB5DB
	for <linux-unionfs@vger.kernel.org>; Fri,  5 Dec 2025 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764943077; cv=none; b=hE4KElLsDxHGZKxdB9pnd85aFnBsjdaS/MbibdvsP6o/wjyXi4s6t/InZM1QZKo2HLwzQgkZ9xpFvpaaIvq7goXadFxrBNop6u0wEXo8dY5sc77UHk3rUtScKzpqcyumnaEMF2TBRms9iG0hJJx2DtIs80U5wpiMub72agIXV44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764943077; c=relaxed/simple;
	bh=+BXdtm4tyTi/wKYv5NAtpRXBLiD0v6xAF2vGz4Lxo1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kNEbVUrJuHKJCqNzzu1Dk45ja5J7bYKWrasIRLSodI6TXTRwxEPKKEGP+nK0zI6BwSLW1+V4/IcgOOGoM7poMl+H+L+67jhXakCZffKPtz/9QgzzHnjMLXjY0lO5Rrmws3p+D5+zoRYpu2AkomnzZojUOaJAnoZyeoZ/LNYHE5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sm9ILzB1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WukgQx1L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sm9ILzB1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WukgQx1L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764943073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnVj39dJvqvU+lgRXhMvk2k6Z6VI84+sYStT3+jYej8=;
	b=Sm9ILzB1mAPBRJsRLQz3SadR9CFdy7hoM5fheZIkMP0PR5/S6MMr2qpzWKrY7CAfI8w1p4
	1pnQ7N0DM4Btt36QRPrx1l/ykHvPCVkV0sKn3derS6E+wJyMy4IDccbt+ll+NmsmdO5VQs
	M1foUP+TpXeJpBrgm+rWZjINE57oHPc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-kSvkO0QmNQGC1QxwskCK2Q-1; Fri, 05 Dec 2025 08:57:51 -0500
X-MC-Unique: kSvkO0QmNQGC1QxwskCK2Q-1
X-Mimecast-MFC-AGG-ID: kSvkO0QmNQGC1QxwskCK2Q_1764943071
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-340c261fb38so3440127a91.0
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Dec 2025 05:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764943071; x=1765547871; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PnVj39dJvqvU+lgRXhMvk2k6Z6VI84+sYStT3+jYej8=;
        b=WukgQx1LP4eYudlBtRMavKQmUuSdsxELiNTVx6D7nnHcAaFAxqfFSR2qWIpmGnfYQN
         Vs1Jbwh73wWoPoGttF+Yj4bx+URlqDEJ/cA7tnREBDTsOBIfdgIwhS9wAMJsvDprAIy2
         0d7BmSI86P6y9gKFPrSIErq8VwZfGVNtCozVoRwDrgwdhGdFrtgYpDfDerMpXfiy/K8U
         Q+dCWgrt9O/YOSToOfxK464FPFkJdVed4A1dSYFI2Ek3Ltiuct2FAP50o1fts8LNmoe/
         YfuTcKVDjlnEt60fL1YABzKjFAOmqN8OBwG4RFxjjhZrvXSr6EUC6uW7m0DJT6/m01qK
         vfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764943071; x=1765547871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PnVj39dJvqvU+lgRXhMvk2k6Z6VI84+sYStT3+jYej8=;
        b=bFg8Mu1H/Lo4CPNRfB1l6CPcZYpy7v5129/0RQG/6RBHqMAFdM6482lu9p+yfdvU7T
         4l2N2RFjgYfAELJRqGHppWiHnvtbQZflkzJDIXG7/YdEZe5OfD5vek/8fJrYdpK6CQOo
         mPHeGgEdsUDmAhyYGqU//7MZiH65kF2Yz2G4XP5A1JaAG79Hr3Ha+xve+ugyp0gmJlww
         p0nmPR7+HuZFx6jH9ZuFcy3qzfKfFDw/4U2gu5P6RxcmHWjT4OpNlkxwmXK1uxDtAf0S
         l4oX4mpu1MinEVpTOYbUGkQ61BEZyj40DptJELVAMTBxmiWNtNcbgbgjqOa35HAB473o
         rmzw==
X-Forwarded-Encrypted: i=1; AJvYcCVIxp6umrDPXVU4sgoekO6MDaVI8rLKfL4EDU2cMPCxThTt7nv3ripRZ/qQFh+GdjJ/YTHIFIC35mTk2VYr@vger.kernel.org
X-Gm-Message-State: AOJu0YzuBZNrLJvmXVN7fprwBxog/cVMYZQritrSmtlu5qRVYXYnKfZG
	SOenywrL2yak3CVlhER4pHCHAaOZE0I75dnkqwCtXiJZ105TU/liOVZL1iJ9t8YTWjEyPEgxPC/
	mGsLI03aWOaYXO8TfU4QiddIx0hgmrNyofgIZJGVqJ75/7M5Ozzze57QuJANghGZn1+pEi3/9ep
	CTVU3PnMvYW1xIqHP8VePqGTlLDJwMXvPU5OSQK86q1g==
X-Gm-Gg: ASbGncvrnjf6UmZhst3drnQP0wupXjwFkMbW75rxPAIheRhG1nyn6KJkZ18wKNqpQvO
	Jy2dJLk21uwdtiVvGCh6d8b49ggp43hggy7At7OFxrKEAqGXnL4SsfVrtTZ7AjJrHQp1HkrK2lu
	24VY5732meTSv25pLohwoiEr3/HQtU69tHKz9KFeHm5i9R6XNYPNZJEDzc6vxxfg5QoLgZDuNWF
	YPEgEDk90BZQNrPSrzisCTkBMU=
X-Received: by 2002:a17:90b:3b81:b0:313:1c7b:fc62 with SMTP id 98e67ed59e1d1-349126c86a6mr9808407a91.22.1764943070758;
        Fri, 05 Dec 2025 05:57:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFoegNfFc0zc9ROKiTg2YCb+eE5Eqjtu9ZhU5KIKpBraoQUMnUObucMeGtxUpF0wL0KtvcdLzYGduYPZ0Al4iQ=
X-Received: by 2002:a17:90b:3b81:b0:313:1c7b:fc62 with SMTP id
 98e67ed59e1d1-349126c86a6mr9808393a91.22.1764943070367; Fri, 05 Dec 2025
 05:57:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205-tortur-amtieren-1273b2eef469@brauner>
In-Reply-To: <20251205-tortur-amtieren-1273b2eef469@brauner>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Fri, 5 Dec 2025 14:57:39 +0100
X-Gm-Features: AWmQ_bk3sPfst03CQ4S4jHGlmem27hNP2Zk_oCcIzARsjmMEO4vTJou6icyRekk
Message-ID: <CAFqZXNvMxoTk1MQq96r=QQGjLqWwLrbdUVJ+nkSD3dzB2yTEYA@mail.gmail.com>
Subject: Re: [PATCH] ovl: pass original credentials, not mounter credentials
 during create
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
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

Fixes the issue according to my testing.

Tested-by: Ondrej Mosnacek <omosnace@redhat.com>

Thanks!

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

--
Ondrej Mosnacek
Senior Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

