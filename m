Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F025A2BB
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 14:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763042811; cv=none; b=hEJQu8H+V2OPqZKgwdM1z+YFUCf3Uwlx/NioaOqCr+2jjKXU1+nyR6Wx6T9AH6G2jWXOB6Z2D6kaLH5qiDsmu5AVRovZZpYdHTXFuKXz6NNup9n1LJHMZgLzofPo3bf34PYZnD6NRqM2Y1o0CKNOqNZW99Ze7Mz3JP8/nRO+QB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763042811; c=relaxed/simple;
	bh=D2ODdD/q9ZSb4oKVWcEmQAHLH0t0auUFL11Ew77g4sA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jeHGe+rbwaTjOisQXQEWN4r5mEOMUeNxHV7aNSUvQc24u979H3ttrIV6Eu+nSlN+ZV+UDcZCm/s8QXww8XIemDGRRsz6TfKiSLHZLPo7/vBudcpb5dkR5hycf4mmGLcii+yp2+WLYFiQ8igSRv6g69Hc74Ih0Q34ArjYXsej+1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJ18IiLs; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJ18IiLs"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso1467180a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 06:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763042808; x=1763647608; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4ymCy60GrQlR96Zc3ezzNbIHD34h6VuRNXowZp2kjw=;
        b=KJ18IiLs3Z1v7tZmuUDbVmsV2mPvVLVV80UndceXE3PXDZEnSgZ3s4sSbY8Q2hAVyw
         gNCwBTU42CY6eooXveg3/iQX7f7YjiQ2dBoGN/XEd5FscSgCmYoILfPcoY1cfv+4X0EA
         SX2n/IA5saoNu8Dz2C5uL3tQGCemm2DLyUQOXwWh3DKk8aUP38QJ2xjJr7bno/IRndtc
         st8ySLx6J4RTwrxA5Zpo/d/NkmK93oq/vIevu8ZtGfU8zY4PazFGXWtTUW0ZQKOCvLaE
         x/fO+hsSJufLEopGRwWkJHk6sQbaemZO3c9y7DyF4+7maHOnkAcsG63wbAdH7Z7hwV5+
         /Lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763042808; x=1763647608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X4ymCy60GrQlR96Zc3ezzNbIHD34h6VuRNXowZp2kjw=;
        b=CVmCGCKP8yvzoZHg0ywforvU87l5tOyreBNjRuptvVuOIZ3MAd/mBH/RSWRdgaCbD+
         Jpk8oHp6vgq5K3kvXNICr1t+cw2VwTKcjV7kDVrntX7iLg40AsQjnNymJIAv6xUFy66W
         jrOLtt0IfQ5uYBIQbC7e+tir0yhyxcoPgmikd7sRYAL6AcqbGvOaRKZmp7hJZPF4F06F
         iaJzaEaNoktuSZ9zFFEcuezIGoXlMHrxyIARjTuykvrOC4sQg7npHaF57PdzQTMKLord
         XbXHcwWRIH/FRzm3nziV+2jTBTyOU93WRPXKmnM2Nk7unIlSlBpsc0wXOuOGZ657mvft
         x5aA==
X-Forwarded-Encrypted: i=1; AJvYcCV7k7HEtRgnymBu5rZNZKYuxv3xNq9z0NnNnsxUBgvN5l1fpP3KefUl2CQnBy/xAeW6db/NhsylWGMbk0k4@vger.kernel.org
X-Gm-Message-State: AOJu0YzP/pv/FvBVgjRR1SGz7tS5moJP3u3piv10n27k83hAp3SiguPJ
	Ky9P9Kz5b+DQjHp9d951Et5q4DlsNSD8Ub7pO40thEpe2tyh+UcK/DoAnXUvFbog3OVV2eoTMtQ
	gTkXVOmCDn0kbHnciadmc/pVZg159yl0=
X-Gm-Gg: ASbGncsC2YU4CFHREwsFzW9FsJCMNqLPSZaZZGlepfzUk7mZOVq9VFQob3Ou1Ffl/Bk
	1i1yABROilROQFt8QduhJwc0iuj1uYvHgBuTIyugk+dORmwiRZn128dQ8p5aCQczTKSYNzVrATH
	ybQAUB7ISSVB1W6WxOppljGmAddFkdnLo1SKpw5NoSLuPfcr195bz4HZ5Cgt4jbmzzfKN89ODLJ
	TMiRbl9YEnRnW4foo1npCnQiSf9+ff+te2ikpR/sHq6mTkSEYgBXFBVUNtGIjUpjT7Fi1C2x8Xo
	0MzafvKqJaxnUNWCD8Y1K/Q9gqXxFg==
X-Google-Smtp-Source: AGHT+IGqErlwzPMt/1KLk2kiKyv4l15eEIq5n8jxdRYYN2NkCTT5305DVCpYoJVu688dJqFu8vpLFhTHWj9Bm64apog=
X-Received: by 2002:a05:6402:455c:b0:641:8f8d:e633 with SMTP id
 4fb4d7f45d1cf-6431a55e40bmr5319833a12.28.1763042808257; Thu, 13 Nov 2025
 06:06:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org> <20251113-work-ovl-cred-guard-v1-32-fa9887f17061@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v1-32-fa9887f17061@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Nov 2025 15:06:37 +0100
X-Gm-Features: AWmQ_bnJUW7KqpuHQYoAwalgT17XbhBu-qlvnsRxyJbqopd1_u_HI7AB6S5xs5c
Message-ID: <CAOQ4uxhr_UTkEJiJD51KZqh065f=XV0GS8KFYszaR0rzN_Rorg@mail.gmail.com>
Subject: Re: [PATCH RFC 32/42] ovl: port ovl_xattr_set() to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:03=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Use the scoped ovl cred guard.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---

Typo in subject (wrongly ovl_xattr_set())

Thanks,
Amir.

>  fs/overlayfs/xattrs.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
> index 787df86acb26..788182fff3e0 100644
> --- a/fs/overlayfs/xattrs.c
> +++ b/fs/overlayfs/xattrs.c
> @@ -81,15 +81,11 @@ static int ovl_xattr_set(struct dentry *dentry, struc=
t inode *inode, const char
>  static int ovl_xattr_get(struct dentry *dentry, struct inode *inode, con=
st char *name,
>                          void *value, size_t size)
>  {
> -       ssize_t res;
> -       const struct cred *old_cred;
>         struct path realpath;
>
>         ovl_i_path_real(inode, &realpath);
> -       old_cred =3D ovl_override_creds(dentry->d_sb);
> -       res =3D vfs_getxattr(mnt_idmap(realpath.mnt), realpath.dentry, na=
me, value, size);
> -       ovl_revert_creds(old_cred);
> -       return res;
> +       with_ovl_creds(dentry->d_sb)
> +               return vfs_getxattr(mnt_idmap(realpath.mnt), realpath.den=
try, name, value, size);
>  }
>
>  static bool ovl_can_list(struct super_block *sb, const char *s)
>
> --
> 2.47.3
>
