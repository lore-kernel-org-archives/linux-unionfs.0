Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4902F4A1B
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 08:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763107925; cv=none; b=br1pi5MrEo/g8RKJFvPbtWQhg/P3eAn2dL4inWOaRE4yLnWWQxXMTBQ1VpOQVunAhIoWr9MYyd5RMlgLeBHarQ7OJrCS5CnP0afFSVQYDluBKFU4BG1E/oKv1ymAeS0iTFdSfN3NwlJcKxCALZdOPmI4zg/pUdM8jaoSL/ev/pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763107925; c=relaxed/simple;
	bh=2Nn/O+GZJ8UWH7JXYzyAxSsE/VBZL5uhOgeHLPsrSJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pqG+opJDOmQf7pHcIvdUN8yIqsjlKciCofJ+klppAiiyptOXOGEVx8K7fx5xkbB6SFsMfyuVXjLyYPuZ2LG42OAMLrn7Xqsn00ofR+x/3ZWrbCpAzKqZeqmiI0V8IJM+XGLcJqP7vY3njYX+XNuBkkqe2FDklgg4IIN51wbXHlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=JapMT2ri; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="JapMT2ri"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ed83ad277fso11746261cf.0
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 00:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1763107922; x=1763712722; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YLfVcDpI3RAusEuEjFESKY20VJ4qiWxE+QiJxYfv3Ak=;
        b=JapMT2ribPIROP7WfJcXYJ22ItfTSnvPLpVuyqfS3gN15UKuc7OHDazwv01fgmjG00
         4yyk0yZUW8bM+bWuSwAwqDu6gG2UBG9Iz0DO6ZltkyM5VtdazgUh/kfS1VRn/aDmSXEh
         6itWE1cA24DQi7m6xrocRSa0IJdJOqcuNb/uw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763107922; x=1763712722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YLfVcDpI3RAusEuEjFESKY20VJ4qiWxE+QiJxYfv3Ak=;
        b=k9+E0x6oJAHsVO0+DHADa27UEze80zepC4HDTu2WeE/vfJgb74nkmVCc5Pk13bKDQI
         FXMZqtRJOaevywLUM+VYZHN/uZNHA+rkcgQ+8AhkFeT+AcT+vJtMDboA3/0bqkxwVF4w
         /2WzHYYwErMEz8iVd7o5LerckTKZC5B6V5PoD/eQU1gnkLc70jm6liQVbq2HF5CRra5e
         bJkMGFKSkng1vQ8eHkKUrYP9rPOAp/PAn9iFUiQiZbeMigWoFLNKJPi5dsKmzPZn31DL
         z1eaX9OPun6gYkbnd7wttQn+PzrzP36l1TP5odv/7KN6/1OE84nQu1XUU7wYPktm1Yac
         nDVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeIqxivEr61KrPU73Y+VOKh8o703uX1QK8Lu2CHM2mbLiGUYyt+bdSG/AsUh9KazI81tVWN4fcy3DtomHs@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo/hi8/LsUJmTsOY6uIMiRP09cuzaZkySfHwJyIkvDNSHEfm5b
	LLQlYs+hB5HKCrZaoTumgZ6KP/KPzosSJFtLnM5VTGuzUqRlV0ntsp83BC2b1i4sqvOqilq2hsx
	r+/D0WcQXk5ThkKMcif2ofh1KtSyDajMkyw0Zz8WwpA==
X-Gm-Gg: ASbGncv3ceyPcrDtTSBmVfxXo5xx+8RM8InYsf88seXz+WTJryMKoErrH32iRua7iTl
	VvT4GHmf6Eh9IU8XRFXDhsibpNxyXMYAyhS6fgb9yurYB9kQmfk/eGVlKbVRIAiyBf2tKUG72FS
	wGi0DFMTVBfXGw/BDgodQc0AZLk1KKZ5GDULkvN2PfADg48uN7jBuH9WXQOaLZwbbuhpTwxeqEN
	/3O2ALdXJEuPHoAurjbo/LSxT8ArGgDjtBw8gZTCP2FmrYIntBK3P0XthdUMOfnqf89e+PMBKG6
	B6ActVtxQMy8zrj2JWp0o1ztGKu1
X-Google-Smtp-Source: AGHT+IEOOLPA2Vz2a8o6ePEs13VnvFpU+d4CJUKkLnlVnfKTf5HEFL/JokcFdJIUBaveIyTl86u8Ryz1YZG91FRmGzk=
X-Received: by 2002:ac8:5d08:0:b0:4ed:b6aa:ee13 with SMTP id
 d75a77b69052e-4edf2048517mr27830481cf.13.1763107921940; Fri, 14 Nov 2025
 00:12:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org> <20251113-work-ovl-cred-guard-v3-24-b35ec983efc1@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v3-24-b35ec983efc1@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Nov 2025 09:11:50 +0100
X-Gm-Features: AWmQ_blmlrX7aK71yUPHFTI6Pz3X49d6a6ZAw8kI-vVkPe14egOcQPWSJ9rtF7c
Message-ID: <CAJfpegtrXoywfudc+x7tP_riDeSM2AGFwgGwWjdUa3UqQ85ndA@mail.gmail.com>
Subject: Re: [PATCH v3 24/42] ovl: don't override credentials for ovl_check_whiteouts()
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Nov 2025 at 22:32, Christian Brauner <brauner@kernel.org> wrote:
>
> The function is only called when rdd->dentry is non-NULL:
>
> if (!err && rdd->first_maybe_whiteout && rdd->dentry)
>     err =3D ovl_check_whiteouts(realpath, rdd);
>
> | Caller                        | Sets rdd->dentry? | Can call ovl_check_=
whiteouts()? |
> |-------------------------------|-------------------|--------------------=
-------------|
> | ovl_dir_read_merged()         | =E2=9C=93 Yes (line 430)  | =E2=9C=93 Y=
ES                           |
> | ovl_dir_read_impure()         | =E2=9C=97 No              | =E2=9C=97 N=
O                            |
> | ovl_check_d_type_supported()  | =E2=9C=97 No              | =E2=9C=97 N=
O                            |
> | ovl_workdir_cleanup_recurse() | =E2=9C=97 No              | =E2=9C=97 N=
O                            |
> | ovl_indexdir_cleanup()        | =E2=9C=97 No              | =E2=9C=97 N=
O                            |
>
> VFS layer (.iterate_shared file operation)
>   =E2=86=92 ovl_iterate()
>       [CRED OVERRIDE]
>       =E2=86=92 ovl_cache_get()
>           =E2=86=92 ovl_dir_read_merged()
>               =E2=86=92 ovl_dir_read()
>                   =E2=86=92 ovl_check_whiteouts()
>       [CRED REVERT]
>
> ovl_unlink()
>   =E2=86=92 ovl_do_remove()
>       =E2=86=92 ovl_check_empty_dir()
>           [CRED OVERRIDE]
>           =E2=86=92 ovl_dir_read_merged()
>               =E2=86=92 ovl_dir_read()
>                   =E2=86=92 ovl_check_whiteouts()
>           [CRED REVERT]
>
> ovl_rename()
>   =E2=86=92 ovl_check_empty_dir()
>       [CRED OVERRIDE]
>       =E2=86=92 ovl_dir_read_merged()
>           =E2=86=92 ovl_dir_read()
>               =E2=86=92 ovl_check_whiteouts()
>       [CRED REVERT]
>
> All valid callchains already override credentials so drop the override.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/overlayfs/readdir.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 1e9792cc557b..12f0bb1480d7 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -348,11 +348,7 @@ static bool ovl_fill_merge(struct dir_context *ctx, =
const char *name,
>
>  static int ovl_check_whiteouts(const struct path *path, struct ovl_readd=
ir_data *rdd)
>  {
> -       int err =3D 0;
>         struct dentry *dentry, *dir =3D path->dentry;
> -       const struct cred *old_cred;
> -
> -       old_cred =3D ovl_override_creds(rdd->dentry->d_sb);

Myabe ovl_assert_override_creds()?
