Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8F630BF79
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Jan 2026 11:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769512201; cv=pass; b=H+80Hu/gGP02Wmmfibe2i4i/LXZKMnvX5zQHTogMPidbSsrkZbtCIJJWq4P9sauhlJtAhSYzAZBwdzveXpHJhRA8+XWj+QHjDiyzUQCQI9BIIScxx65LPgNX9nTdnHVF+r2bvpHiV8ovoc1m/YwYM3/tKiwgq+wD2k8rhPAjs8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769512201; c=relaxed/simple;
	bh=9ZdR+sZGP2XGtsRSmoxOUTr/CtgQZw+TI/HhDB3nEHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AwkKjrjF5I9ZWKh6jsqTIE5+mWQYA3FXmqzSxhPn/LwYCUDACfudgDX26yjJFQoRo+Fc/HU78YHJPnBKeNP+rqJd5w4YbH3rSCyL372myMJKPrWGdFlMb5vLfUnVEZdW5bC3USC+fMf652xqRC9fJBOTCWkVJwK2juYSe2Hb5vM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ib450wDY; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ib450wDY"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64c893f3a94so10446125a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jan 2026 03:10:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769512199; cv=none;
        d=google.com; s=arc-20240605;
        b=SG4gga41UvS2SOtbQ9L/CF5WHMkUaHzm39I3RFCxlkboP5W0H1flD2vLSA3/NuzyMn
         FL9U28gwu27ZYh4Z5/NwMMJaHMvNfwMzqB8jaUBhzOIJRyD8ihBFySXzD8p6CCSEKEfn
         aMxXvBXpw1pKRUiZ8AcdH0Hp0EFVPp36srvNs5pLb3r7HzcxQHOxJLZlL7LGiYclb/eg
         WJReHmyOWpJYwSustiqrLz4E8iph7ERp71BNIH/pktJ7AfPFanXPuzdahlxGF6WYb5GL
         LoSwc24lHjx9HnmRrTUYu5dIdL/G+CbB6coqkMH3f/Nporu0N29a3/1LFZ+aJJQ/7tx9
         IaDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yoPextEhbKL1b/3Ka7dvWVUZkRw2uul/j8Afr1cp8r4=;
        fh=buxdOg/uAYvTjxMftX3HQxiezdN36qFLQnpOHoSWgd4=;
        b=ddtcpQvYJ5mqZD9Mx3tnvjwhwjj26LSV0wXdhde3gE6KcMnAwVEvNHMdAc8sdliZNR
         6anbM9MKWT8wvWltXX2LOKIXaXu5tLZtIqzRKw0I5yYtcSYuRbC2tOGtXVY3uEbgnoIM
         GUhc55u0qCr9bClX2q6mNkwv/lGZNFDvJtcfigm5wwo1oboZEWihl47Oidcmg/s9KTOU
         +CR4l73Y/9xKHyhJ/SRCaDodTK3d80H9fKb91NR6i2Hq8x2ZhFLqgVKUKaZTQONxr+G9
         xFZe/0dyH8zInHiCumAv5RhkJak46TKwPKCYCvkwc31FbVoilWSEkUR4Fx7u2k7Evk/q
         M6kg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769512199; x=1770116999; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yoPextEhbKL1b/3Ka7dvWVUZkRw2uul/j8Afr1cp8r4=;
        b=Ib450wDYqoU/m/2OWKHz9/PN/RB5KbLRgNxoFfBSfE/yARviTubmhH8eR0tKSkFM5u
         N6mHaN/wTFnqLhkdHCD2rMZBF+afONsfMl90paDNLlNUnnhYPNpBylBmEB4BdGN0OD7Z
         YBYJZA6QfdQS39Wv9Gwd2OYXcEuiytB+U9oeEYJpjiLlGleP1EuAmLj+P6IQfmzsM38Q
         tT2Fx7InMCuwR+SORZRP7CurwJAEkg3lUPeOlx5veZ7FaUHOegfc0ueLltuHBB43sLLb
         NRDbMK3vHW405IFaZBRPk0waOkW5URkEDIUhYMBURJozBtf81+P3mHxgHJwMgPXsBcHQ
         S8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769512199; x=1770116999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yoPextEhbKL1b/3Ka7dvWVUZkRw2uul/j8Afr1cp8r4=;
        b=iJLT7PDb4nUAMjPvZPIm1vFrpwpih9j0NSOa/m38ytVOkQsVJRqK17XRV4rIeb9hB1
         0M3Znp8l8kgjJWf3o9wJ2JAY8vVHGKf5Q1CiEI9RzGbtY5Ni+pgD7oCzfe/vq0YToPnu
         ddgT3v4BEwvB0kTreqhNTTtj5/F26+xaKSd2LyUxytp+HNKLali2zYo8m7oR9TSWOiVe
         6CasLGl8lUst3PuDjyeRM8IE/Obr9DqBjWQx6EBl0WGhE5YZpMGrRsYVzagPhyKEeBpG
         B8VhTmr6aYQTgSRnadLApd9TX4R17bWBrHcTK23BO8TG4v2spI75u3hzUgNsFu3clex0
         UK8w==
X-Forwarded-Encrypted: i=1; AJvYcCW0yJTHIPpwH5dscCmlmVvA4Y8trt7JlYQIZiuVVROTEIYeiJjxiAMeYnEpbPDmEYrJch9yQKEV1RwuVILN@vger.kernel.org
X-Gm-Message-State: AOJu0YwFlhf7lQ2SZHqhIr8ukQrK0s9RkJXn4nRMj7n3Qc3qWfOQQ1UU
	aRlpD/Ys5n25tiCtaiLPiT+R8hzdKDO7vEliIsn53VaVa85J5yjATIsPMW8+LXRoIVYECRPaZWn
	I7vfCu40KA0MozVzZO3hjnFeO3qO8gpw=
X-Gm-Gg: AZuq6aIZ6boMCb56ATLeaww/JheO2/HBbAqqr83mT83O33SDY2ohSVy5p7JHcTddx/j
	ComFfyBkD9HzbwyCBq2c7T1LYhOdZxyQkPFhK/1ft9mC3hC/nO+6n+CeAV74qWtBMUNKgupdHvZ
	2sTt++LBxy+GZJqoGR5IVdBaElIQyHfKFBFHDRcyKX4ZAH/4M0Oe446EsPIkDyT/RivxkZyWcMY
	JWhOUdwRb1ZVLTxif+ANT8cd6KVnMhNU2lLeJ3SsQ7YJm/+3DygWvkK6LCB1WbM3eIG0XJziHTK
	IBxfXd/c5toPn84f1QeSAM9nFCylQQ==
X-Received: by 2002:a05:6402:1e88:b0:649:c6fb:1f5c with SMTP id
 4fb4d7f45d1cf-658a7156280mr876590a12.5.1769512198446; Tue, 27 Jan 2026
 03:09:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegt_n85jDSe9k9GcC_9KB=+R_oUeJTPt+3XSPkhjBPm3NQ@mail.gmail.com>
 <20260127105248.1485922-1-wangqing7171@gmail.com>
In-Reply-To: <20260127105248.1485922-1-wangqing7171@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 27 Jan 2026 12:09:47 +0100
X-Gm-Features: AZwV_Qjh3CEvzKw2SN-TPmgXYHIsCTvc2zmXso_TbW3-HyNvMf6zVs-oORj9Xaw
Message-ID: <CAOQ4uxg2Zwuyorw50iKzwbQJO4wD2NfqhE21KPFZrDVMJAYzNQ@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: Fix uninit-value in ovl_fill_real
To: Qing Wang <wangqing7171@gmail.com>, Eric Biggers <ebiggers@kernel.org>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, 
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2026 at 11:52=E2=80=AFAM Qing Wang <wangqing7171@gmail.com>=
 wrote:
>
> Syzbot reported a KMSAN uninit-value issue in ovl_fill_real.
>
> This iusse's call chain is:
> __do_sys_getdents64()
>     -> iterate_dir()
>         ...
>             -> ext4_readdir()
>                 -> fscrypt_fname_alloc_buffer() // alloc
>                 -> fscrypt_fname_disk_to_usr // write without tail '\0'
>                 -> dir_emit()
>                     -> ovl_fill_real() // read by strcmp()
>
> The string is used to store the decrypted directory entry name for an
> encrypted inode. As shown in the call chain, fscrypt_fname_disk_to_usr()
> write it wthout null-terminate. However, ovl_fill_real() uses strcmp() to

typo: without

> compare the name against "..", which assumes a null-terminated string and
> may trigger a KMSAN uninit-value warning when the buffer tail contains
> uninit data.
>
> Reported-by: syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd130f98b2c265fae5297
> Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
> Signed-off-by: Qing Wang <wangqing7171@gmail.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/readdir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 160960bb0ad0..9ea3cd11dd93 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -755,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, co=
nst char *name,
>         struct dir_context *orig_ctx =3D rdt->orig_ctx;
>         bool res;
>
> -       if (rdt->parent_ino && strcmp(name, "..") =3D=3D 0) {
> +       if (rdt->parent_ino && namelen =3D=3D 2 && !strncmp(name, "..", n=
amelen)) {
>                 ino =3D rdt->parent_ino;
>         } else if (rdt->cache) {
>                 struct ovl_cache_entry *p;
> --
> 2.34.1
>

Eric,

Considering that fscrypt_fname_alloc_buffer() anyway allocates the byte for=
 NUL
termination and that decrypted names are zero padded (right?).

How about reinforcing this fix with:

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index a9a4432d12ba1..97e00af49bb9f 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -276,6 +276,7 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode=
,
        if (fscrypt_is_dot_dotdot(&qname)) {
                oname->name[0] =3D '.';
                oname->name[iname->len - 1] =3D '.';
+               oname->name[iname->len] =3D 0;
                oname->len =3D iname->len;
                return 0;
        }

Thanks,
Amir.
