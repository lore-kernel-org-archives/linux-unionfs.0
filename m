Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D171E481;
	Wed, 20 Nov 2024 12:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732106094; cv=none; b=pr8sBqSNbGFcKt2tazI/TUV7PvjHJ8Izurm0SfqnNqdGfK/VdZl1rtEH6Ziidh1D3iWzPyAF2TBvGE4jAq+Mb4NIxv37mNiWpxMfhVgOOvOhCxwaCAnXwPSmCkKulizwhZNfk+1ePKSoj9IwNVEcr8ZKdZ1dBJZYnaV3w3GWsPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732106094; c=relaxed/simple;
	bh=tCqXrE4hGPCCeFZVd2gCAn8G+VfER0VRfIIuMoPCZQw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m0BWlOWWMjlmjSUAYxUdq8LcOr3X4uCz/mk37d0mFthz1eKaGrDLjshPX7ZlbDMIMHu/60vdxBENJYsl6oe/ahVkcX00Pql94Ei3iRkT2WjDO7dkMfLOBrnvgi/s6bN2z+VBQzkp0vO+mvU0WaIc5jAeeV/PI00ylX5gZqO1DzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZjYQsQb; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZjYQsQb"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9ec86a67feso384741566b.1;
        Wed, 20 Nov 2024 04:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732106091; x=1732710891; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s9be3oshnUjRS174lvbHheMcbFfB0AWJTZEVzgfguJI=;
        b=VZjYQsQb3itd53KbCF35Ng7gNi8euwn/4BH3Nsvokrf1FNPIEg8xxVMdhNGAOPfnAM
         vVuEStI8jy9X1yVwkxVGF/PaSrQArMDges2BCNkrJiWxlHD56jZdS1BL02Hq+IEWnGUU
         lmMoVdOWYGvSvSg5hxmvGLJFpIKtg2aKZMz6dwdhOCO56be2Po03dc+Xcsdf1c2Q6RGs
         jr4ZdfH3Y1QlIa2mgAhYHG4hjf4BGWBmkG8datNjZc4HPp6GWdZ8M/D2M9Dp+cXTwoHK
         Wtq4BPtLndLZnXTulafvr7cnDcJ37UV8PKXQ65WzgAH4SvBU3AiKrP33EyeYE+a4xoOL
         1tSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732106091; x=1732710891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s9be3oshnUjRS174lvbHheMcbFfB0AWJTZEVzgfguJI=;
        b=QXwVPoU/CEW2i0uihSLYTXKaJcaeeEj99fhx5MXAzGB3BgdrN98CclTV/b1ZteSsaW
         9g6AaPCh+4JvtnJr/i8iYb+TVHzwrTvj3nuqBdu+rSqoGk/J94/Agt6wISR/cVQ14WR7
         UmM3RrN1Kb1aVf3sJUe4C6g2VeM5DmKSUn2RLOcT+q8QoIKeK/s+J0V5AO9Xmr1ZvsPh
         YSdg+HJoSJijskJrm3dMoPluWDnmfKW161TBdIX78zoKyVbjArxsQS2o/VdSGFGAO/cD
         zQ9yx2shCIXa4qFTx+1MGKxEpKqw3bzfOdMCXlW/NP/HylHotqjRRHDAsKvlKR6plZYJ
         adtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCXxoyxm6JvQQRUsDQUmjPrnc6d0Yu+WAQt9EQfTAOjJgqDSKXxncg/s0LiV7A5B3f7171yqlNyQ6+Djc=@vger.kernel.org, AJvYcCVvK46q+4Nyn0WoUEFqrs8V+X3iX6riCncLcExMIMN209VLNBWWCH9YnCZilHDiD0mIwvGqQOu14YwJ4uOVxg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzM5Z/P13p5i6jvVnvII1YfndwilGZJkzQrp8e8T8s3vJGSERtJ
	G1pNFtFOFCfVjWTEP1Hr3ol23+/mqoJLicUXuG4fhPYYxJBgld5CPQkwY8eH3OA5FxC0az+M7un
	SNrMRSxdJKk2iW1ld3tUJvEOt7oIZ24Fs
X-Google-Smtp-Source: AGHT+IGLH3ySfyfw8VX5rYvejtffct7dyhAxmZDlWXw4R0+0MyaWqXkkffo27tVWqmXnK2GYzpN/5t6uz9YmAVgB0M4=
X-Received: by 2002:a17:907:8689:b0:a99:ebcc:bfbe with SMTP id
 a640c23a62f3a-aa4dd57ba6bmr257815766b.27.1732106090692; Wed, 20 Nov 2024
 04:34:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxhc9-MMF1nEpoxC5X41FRqSygGdVcTuvdJKurMxWU1U0Q@mail.gmail.com>
 <20241119155817.83651-1-kovalev@altlinux.org>
In-Reply-To: <20241119155817.83651-1-kovalev@altlinux.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 20 Nov 2024 13:34:39 +0100
Message-ID: <CAOQ4uxhOTYZdjuVajBV_-wrQnVOERUOz7UmJJvcDUkWpkXkDvw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: Filter invalid inodes with missing lookup function
To: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 4:58=E2=80=AFPM Vasiliy Kovalev <kovalev@altlinux.o=
rg> wrote:
>
> Add a check to the ovl_dentry_weird() function to prevent the
> processing of directory inodes that lack the lookup function.
> This is important because such inodes can cause errors in overlayfs
> when passed to the lowerstack.
>
> Reported-by: syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Da8c9d476508bd14a90e5
> Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
> Cc: <stable@vger.kernel.org>
> ---
>  fs/overlayfs/util.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 3bb107471fb42..9aa7493b1e103 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -202,6 +202,9 @@ void ovl_dentry_init_flags(struct dentry *dentry, str=
uct dentry *upperdentry,
>
>  bool ovl_dentry_weird(struct dentry *dentry)
>  {
> +       if (!d_can_lookup(dentry) && !d_is_file(dentry) && !d_is_symlink(=
dentry))
> +               return true;
> +
>         return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
>                                   DCACHE_MANAGE_TRANSIT |
>                                   DCACHE_OP_HASH |
> --
> 2.33.8
>

Applied to overlayfs-next. Will send along with 6.13 PR

Thanks,
Amir.
