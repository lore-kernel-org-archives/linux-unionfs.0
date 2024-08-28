Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D92E1A3BDE
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Aug 2024 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724858267; cv=none; b=WK+n8jnYUfTjEItnE0XgMv0d35mEF3B9YmT6cTn94DdvRhWCzn+267iLMQKvqIsM7hemzZ4HgfS/4lJV6OGWRm4M8zEMAO5jF2IBPNOl0b66tDYdNRK4SdjvEqMJEdzf6vGqrQsoN0EwQDDYELzcn4dVS+Um9oPDLzmsLGpZalU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724858267; c=relaxed/simple;
	bh=aAwn3cAUveA4wLLNazS1vhYF4ShryD/k7iU74VPJxmU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mLt3l8tS+THIBjuFrl9v9bYxyXXoYjbPMOp4y+w7a4HCIXf8z8xou1pn5vax0cbIuo065B+APeo6zDLZ47/gCn0wVYcW9Qbq03vClm/IPuL54x1hKCVJJWajvgnN3XW6w0ddHsginmRvltuBF/Oo9MGxkvoadbIhk3pLD05ie+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=efFkZlzG; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="efFkZlzG"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7a1d42da3e9so429903385a.1
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Aug 2024 08:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724858264; x=1725463064; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPfO1dwZPfgu84+sALMa6tKd/jhCZAcnrobOZcO7u8o=;
        b=efFkZlzGekY9B2l1Wd6cxszqcAim7xnJjFo+2cIuHNcEMhpKAcfjmYkSJGrywFdFpL
         XGD/or+/Zl3WxhSQpJsO3L7PSYZ/hLqlhpDEZDe7NrM4nv+g32HhcveJBZ589vC71WM4
         415TmZFapQod7JZPtKRQwNKFN24mfxhJpPrGk9e7+aBgbUdmgi5D3kq5S85F+Mo1wtlP
         ci2/WfNSfyLdNn1q0GJlR7OoiW5rdoGg6+2SuQ+sttpFUjLW9FWKTFlSujueZLdkocMP
         CJAzSbE7GWo3tGjaARDKJ4N0Ho2E6k5un2LwBrMoPoHakxxgWpgZ8V2isj4VFwBcb1Kz
         tnYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724858264; x=1725463064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPfO1dwZPfgu84+sALMa6tKd/jhCZAcnrobOZcO7u8o=;
        b=dPrNhpqpl0D0UesBeR8HbHHGYDtdySufPu7gnbZrYJUoB713cA0Wiz4BHKUGa/UtON
         oqU8SoiBCrDDGABNBV6TrFXQ/JLHIsxBDBTBoW/WiuAzxXtV5hyRAsAy1wPyJENlm1gi
         zsUfz5WBRSg6/akvSTKsns4613k6xkeyEvml+10Qlc+xaPvPTdAdQUEQHXz5VyQKj0Hk
         cqWZqTvIUWOVvYG6zWz3RiGyrPxa+DkFcWevTbA7ydxAiWRUyak1ex+NTvoZozJNnmzG
         PmzQ8zkfKOKjlWGvM9z+513vpcznwK7m5fCE7nJHsv1zEIKC6xAMZ1T5uwe4RBFxj8qx
         NgMA==
X-Forwarded-Encrypted: i=1; AJvYcCUdc4PAicR9YbjKUNT/Rliec2bC3sQunrBcU3G3SR7NL+jCgPTTCPb0awQ8Ezgk9ghm9ug/6O8I/LswxzPg@vger.kernel.org
X-Gm-Message-State: AOJu0YytwPuNZ9i7mSAGGv0RTMUWO1jzTZ610d0JUYIhIIXaO9s0GQKg
	+rERA2IUPG4d1OGOof8VYadeIja6Qux4wy3haq5J155OYrzKEwvfc/erREsbXT341u/ait2Vx1k
	A4bG31V9MICaROcU5HTofkNPwRuyaLtyM
X-Google-Smtp-Source: AGHT+IGrosXW9iJtuI5r52Uz04SS9V92jVvJvc6tP8rUw9maPa2EpRx9Gw5y+nZnk8+RAWvofpDn9lByD3LgHzyJAwY=
X-Received: by 2002:a05:620a:45a6:b0:7a2:bb:31d3 with SMTP id
 af79cd13be357-7a68970528cmr1844255485a.22.1724858264043; Wed, 28 Aug 2024
 08:17:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828120514.3695742-1-lihongbo22@huawei.com>
In-Reply-To: <20240828120514.3695742-1-lihongbo22@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 Aug 2024 17:17:32 +0200
Message-ID: <CAOQ4uxiBsGpEb3FUmp1Bn_9ch1Xa1aAqfpJa0qwVnN=23Mcfag@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: obtain fs magic from superblock
To: Hongbo Li <lihongbo22@huawei.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 1:57=E2=80=AFPM Hongbo Li <lihongbo22@huawei.com> w=
rote:
>
> The sb->s_magic holds the file system magic, we can use
> this to avoid use file system magic macro directly.

That we can do something, does not mean that we need to do it.
I don't see any benefit in this patch.
Please explain.

Thanks,
Amir.

>
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/overlayfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 06a231970cb5..c809e845765f 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -256,7 +256,7 @@ static int ovl_statfs(struct dentry *dentry, struct k=
statfs *buf)
>         err =3D vfs_statfs(&path, buf);
>         if (!err) {
>                 buf->f_namelen =3D ofs->namelen;
> -               buf->f_type =3D OVERLAYFS_SUPER_MAGIC;
> +               buf->f_type =3D sb->s_magic;
>                 if (ovl_has_fsid(ofs))
>                         buf->f_fsid =3D uuid_to_fsid(sb->s_uuid.b);
>         }
> --
> 2.34.1
>
