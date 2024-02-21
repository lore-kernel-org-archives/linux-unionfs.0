Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF21312A16B
	for <linux-unionfs@vger.kernel.org>; Wed, 21 Feb 2024 23:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559037; cv=none; b=KtpaFkW5VOsPepiR7OhYBovn3kc94/ALftJPYAhVZpp/qbsUEKbUKGp9cDZ3oaWQI9/o3kuIBYUaTSvk0aPClAzf4A+Hf4KYy4Tei/xNgGcjvUIkoJFRS4WG7twZ+9oVUPoXwsSS9KtAObr83A0xBwRgEvXLBPyoRvVfmcL3phI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559037; c=relaxed/simple;
	bh=jXUi7DaHH/tYkfvmdZwdL5O6ldHOILbUbl8SwoK93vk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rdVik8P8vUeda72Lne9ccyQM6mRWuEL9320JBFdOe974boAWLTOtv6k02K9nx0HH6o+L1pg/pxEdXF0ks+kixWvPRsC6tpK9o8srC+G7AjoIKWmh/oyd6keT6m9oMOB9sj218+oABgl69EAZAEYR5qzYpWUdrRr8LA4O+ipmG70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=DMYN6N90; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="DMYN6N90"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dc236729a2bso6909165276.0
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Feb 2024 15:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1708559034; x=1709163834; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozpdHgEMJtLxc8z0f/xCObDDvWnU+f1l4TdamibeEB0=;
        b=DMYN6N90YpElzCrVcquPcjL+68ZSO5M7iyX1Ysv42qTiwp/rotMVr8o6Mewie3EVWH
         6VkCYIDs9OZsceV8eT/715SqP5vipSQq8BJm53ev7Jak8bqLfejNRGC60ZEdngFaBjHD
         yR2Xa+KweEdyCQ1U/IYiFUyc+gff3XevcnQRwIclqaZGPbO7+Gyh/N2bDhHANboRBTfA
         F/SqCwaEdM3e7maAwCzEolx3GWicHLwuXvWGnzGIKmfCUrRrES38YR7gNI3H2wQklfPE
         31p2G69/JMdWuV0Uo5dNqkjAX0N7C3gMXqT723vE4AIFKOiqlqkWwlveEk0rhSpt0vd3
         esLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708559034; x=1709163834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ozpdHgEMJtLxc8z0f/xCObDDvWnU+f1l4TdamibeEB0=;
        b=RKRzCChh+e+QmAwILH0FketQHBTijNfHqP5gQWgKW2cH0jqHx9OYfOIB0ePBMvD0Qx
         SzQBGcxaOY2LDu0Tw3I5qRnPe39zf8YBhlSWARYlTWsNCMEkCLa71ZN25+ke4zTaeovX
         pZEzVdIi/eFZe6Ww+915j+Wt5secycpRe5VLBArcu9VEP0cRnpUnBVT2Z282/fcDX2cR
         vbvlEGAmj4eVxrE/LmnLiG5oQE68CsZ+U7fWLXjooAMQ1M1GYz/onXZygxFC+SPFw46c
         yaKtQAFv2oYm1ZfLqdmyNhheCCChx+qvI85Y1UJo9v+Yv9JklWd9fXQmudm7hw47SppD
         9V6w==
X-Forwarded-Encrypted: i=1; AJvYcCUOoqr4ZY526hXMDyR3aXGMVlGXlmzfs2hXchLeY1YG31jpQH58QTO+Q5Hyurq8ivSS7bmVKQt+jDOogTkpS8m+zPOiZfbHNF7b2RPO7w==
X-Gm-Message-State: AOJu0Yxia9Z3lU5ZIl1A6nPCZaBrpZmaGakCUmDdB9ZdN/qZcIxj/HYM
	7kN3rU112rU9RfpvTsHLwHXVRy2MBsX2bOrmHecycBr+NFDbKGybaI9ict10km+7lcqSEsqbf7S
	Xk2B9yDwnkRd3LvJTeGvfDVymP1m3Daty1lwu
X-Google-Smtp-Source: AGHT+IGHrH5g+9KgtuY77JnAmJfeyj21kEZdzhwPpy55HJt0kZAi28H0jeAtPv8SyPEbdcHCUbHgVHOylR1JMSl3Amo=
X-Received: by 2002:a25:a285:0:b0:dc6:db0c:4ff0 with SMTP id
 c5-20020a25a285000000b00dc6db0c4ff0mr912234ybi.32.1708559033944; Wed, 21 Feb
 2024 15:43:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240221-idmap-fscap-refactor-v2-0-3039364623bd@kernel.org> <20240221-idmap-fscap-refactor-v2-15-3039364623bd@kernel.org>
In-Reply-To: <20240221-idmap-fscap-refactor-v2-15-3039364623bd@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 21 Feb 2024 18:43:43 -0500
Message-ID: <CAHC9VhRQ7Xa2_rAjKYA_nkpmfUd9jn2D0SNcb6SjQFg=k8rn=w@mail.gmail.com>
Subject: Re: [PATCH v2 15/25] security: call evm fscaps hooks from generic
 security hooks
To: "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Serge Hallyn <serge@hallyn.com>, Eric Paris <eparis@redhat.com>, 
	James Morris <jmorris@namei.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jonathan Corbet <corbet@lwn.net>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, audit@vger.kernel.org, 
	selinux@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 4:25=E2=80=AFPM Seth Forshee (DigitalOcean)
<sforshee@kernel.org> wrote:
>
> Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> ---
>  security/security.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)

First off, you've got to write *something* for the commit description,
even if it is just a single sentence.

> diff --git a/security/security.c b/security/security.c
> index 0d210da9862c..f515d8430318 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2365,9 +2365,14 @@ int security_inode_remove_acl(struct mnt_idmap *id=
map,
>  int security_inode_set_fscaps(struct mnt_idmap *idmap, struct dentry *de=
ntry,
>                               const struct vfs_caps *caps, int flags)
>  {
> +       int ret;
> +
>         if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
>                 return 0;
> -       return call_int_hook(inode_set_fscaps, 0, idmap, dentry, caps, fl=
ags);
> +       ret =3D call_int_hook(inode_set_fscaps, 0, idmap, dentry, caps, f=
lags);
> +       if (ret)
> +               return ret;
> +       return evm_inode_set_fscaps(idmap, dentry, caps, flags);
>  }
>
>  /**
> @@ -2387,6 +2392,7 @@ void security_inode_post_set_fscaps(struct mnt_idma=
p *idmap,
>         if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
>                 return;
>         call_void_hook(inode_post_set_fscaps, idmap, dentry, caps, flags)=
;
> +       evm_inode_post_set_fscaps(idmap, dentry, caps, flags);
>  }
>
>  /**
> @@ -2415,9 +2421,14 @@ int security_inode_get_fscaps(struct mnt_idmap *id=
map, struct dentry *dentry)
>   */
>  int security_inode_remove_fscaps(struct mnt_idmap *idmap, struct dentry =
*dentry)
>  {
> +       int ret;
> +
>         if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
>                 return 0;
> -       return call_int_hook(inode_remove_fscaps, 0, idmap, dentry);
> +       ret =3D call_int_hook(inode_remove_fscaps, 0, idmap, dentry);
> +       if (ret)
> +               return ret;
> +       return evm_inode_remove_fscaps(dentry);
>  }

If you take a look at linux-next or the LSM tree's dev branch you'll
see that we've gotten rid of the dedicated IMA and EVM hooks,
promoting both IMA and EVM to "proper" LSMs that leverage the existing
LSM hook infrastructure.  In this patchset, and moving forward, please
don't add dedicated IMA/EVM hooks like this, instead register them as
LSM hook implementations with LSM_HOOK_INIT().

--=20
paul-moore.com
