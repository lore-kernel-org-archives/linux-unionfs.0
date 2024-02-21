Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D59A12880F
	for <linux-unionfs@vger.kernel.org>; Wed, 21 Feb 2024 23:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708558317; cv=none; b=nBvItNhOLmpSjh6tJCDpEikqaYavGETwYDdE5WfGb3S81zwjxIGUH5m7k6ET/Wg4nAlstEjb013tH12takePf+YWVpZOrNaDpkj77mkSfZglDG4ysnFy5LGXorrwX5lddQO6ov/cW+J0W17iDIl9uTbsY99cAxdVADAXDDdKdlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708558317; c=relaxed/simple;
	bh=WgLwLSocZ7FS/OEk2fPe2rx5sR/6WFIAnJST+HRVhCc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lv0uEBU+mRIKtNahxVkjFJB/6Ufg3FfEpQQPwq/Sn8U3WT7HotXmuV9aT/wPoc5FhAuy/HV7HqCEVszkYIgULkKJkocfofbLOzoxRePnCIaqQdG8ZYVjKueoyfvu33q0orCHCgypTxUk8Buaeu1iuc6YnC287OE52l6IdysvM8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=GwG5Xtha; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="GwG5Xtha"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-db4364ecd6aso5863697276.2
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Feb 2024 15:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1708558313; x=1709163113; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZu2GPrrRR4joejlRHI45PmLXsG4a+4mbcvu2KMsfNQ=;
        b=GwG5Xtha5H1vqGrGKMhJTy7HsndGLVt/3YtlVxa9bl/MkQxHqP7KlJmCG2AfacfGNx
         75ZCNWavwgS6x9vOLCE+TdATKrHN0FExiLxmZb0uBY2gfMtC+yCla+N9ez6TWjcTAyYJ
         M3+uRdoPqQuADsyoLrdxIibK91zUl+K40eL3mAUlkf40CFd0eTwpGTvKnk82MWfubbuP
         fFZVyBar9aJ+glrmmOb5y/g6TtnZcbrLj0Zv3c5QuTfJQqi34ovQwSOugA5MBXt2Zes2
         JR1bqiSQC8toLOiFsOJT8P4vJMvObpe00mMlyO8FgSyb5Q7MxcwBI+91Qq3x3gcTx07f
         ypxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708558313; x=1709163113;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fZu2GPrrRR4joejlRHI45PmLXsG4a+4mbcvu2KMsfNQ=;
        b=dROBGnJ1DLIkwO9qTQNWzijKodbDtCuLRKYjcZVtbFnkNXgqd0HhglgSUzvIh5Fltw
         3wrevKsnig7bJBTm17nOHn3wTCoXRmAb9IQxzmkGnHT62m/rWh5rpZPvSM1XiKhVAwxu
         SnoecYLV/m4rt7B0Chr84XH+9bI69D3Gp6HNyFbfjJnFoMnNt9NDyMCtnUyNh6OL8fqs
         hufQQ8e9RhO+QfHCEJjnJ7/D5Ye8/LJaaNi7/xWv6Y+soHuSVKqLfvYY+s8HgkInxRC5
         VdN9Op5SYb1TvgLbcl6gPkja5vcgg0/tGdCMADwzaVsaQ0NJ8BAUOQw+fnNIPsdMy7yf
         8dIQ==
X-Forwarded-Encrypted: i=1; AJvYcCW82T6uYqVaKQVcTFhM4LUDxsobpnJpO8K2DX33iMIQ9C2EaqH/M9oXpJzEmMhnJfYrvThm2/LHgx/OFyP4h+jQsVoiYQ/IXRByeii62g==
X-Gm-Message-State: AOJu0YwdDsfHfhoaBY9BFkoJyoIM9gsOckzvVuaI/e2sgDlg975/mG73
	Fzd16yxVchlDirVcB5u7vTTkkRYXlnSCPXugx4xl6mv/mvs/igOYktuoYF00UFIxSULh61XUYYr
	nVsddLmNW+Ei1r9bBNAHNpj2/G6uSwJxpUiey
X-Google-Smtp-Source: AGHT+IH2hhk/+Fh5m9DmgNGJCqgA2pQu6OP5c4JBKagU6C5V3tlE/W9NCn7tcgM5vKu+Evy4U6qhYX/TuSKBbQJJqnw=
X-Received: by 2002:a25:8881:0:b0:dcb:e82c:f7d with SMTP id
 d1-20020a258881000000b00dcbe82c0f7dmr840538ybl.41.1708558313639; Wed, 21 Feb
 2024 15:31:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240221-idmap-fscap-refactor-v2-0-3039364623bd@kernel.org> <20240221-idmap-fscap-refactor-v2-11-3039364623bd@kernel.org>
In-Reply-To: <20240221-idmap-fscap-refactor-v2-11-3039364623bd@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 21 Feb 2024 18:31:42 -0500
Message-ID: <CAHC9VhQ5QK_4BaHCj9SEvW9M_suWa9edDXrbw2MiNcn56eoWPg@mail.gmail.com>
Subject: Re: [PATCH v2 11/25] security: add hooks for set/get/remove of fscaps
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

On Wed, Feb 21, 2024 at 4:26=E2=80=AFPM Seth Forshee (DigitalOcean)
<sforshee@kernel.org> wrote:
>
> In preparation for moving fscaps out of the xattr code paths, add new
> security hooks. These hooks are largely needed because common kernel
> code will pass around struct vfs_caps pointers, which EVM will need to
> convert to raw xattr data for verification and updates of its hashes.
>
> Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> ---
>  include/linux/lsm_hook_defs.h |  7 +++++
>  include/linux/security.h      | 33 +++++++++++++++++++++
>  security/security.c           | 69 +++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 109 insertions(+)

One minor problem below, but assuming you fix that, this looks okay to me.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/security/security.c b/security/security.c
> index 3aaad75c9ce8..0d210da9862c 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2351,6 +2351,75 @@ int security_inode_remove_acl(struct mnt_idmap *id=
map,

...

> +/**
> + * security_inode_get_fscaps() - Check if reading fscaps is allowed
> + * @dentry: file

You are missing an entry for the @idmap parameter.

> + * Check permission before getting fscaps.
> + *
> + * Return: Returns 0 if permission is granted.
> + */
> +int security_inode_get_fscaps(struct mnt_idmap *idmap, struct dentry *de=
ntry)
> +{
> +       if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
> +               return 0;
> +       return call_int_hook(inode_get_fscaps, 0, idmap, dentry);
> +}

--=20
paul-moore.com
