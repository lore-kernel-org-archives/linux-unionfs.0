Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3871A3D994
	for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 07:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724398443; cv=none; b=gq4hBdeg72lQcpz3qYaw6Sx//FEF1QGU2SplsEG/pTb84eLdKss6RaiwPwjgqax4nh+053O4LORMlM0lWTUHW3hqB3A9OKrGJGOobf811G/8+v5edR8LwNFodwsuEVAvwVC8/sRo2njkekkYv9UU6yo6/MXkhaaPU/BR5EskmzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724398443; c=relaxed/simple;
	bh=A/Rlr2YTmJNTtujfqk9pPaGMz4xAB1NGX4juiw/OgM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JpM2QnBU7rkZxurXZ5jf7VIZj0t//sORqgFnhcXfpYY068uRIw6FD9fxtxNoAtQIqkkmJ00jTQYYjTUxkkbyaP7o83u8U1OuBPhQ7l28g1gG/CAUgSd/V0+XwMpORB1Jw7+Vil+KHdF7w7o4cuBDpoI8sNfb8kZ+vOEZiYzpbJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZhOcvOS; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZhOcvOS"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7a1dea79e1aso101400185a.1
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 00:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724398441; x=1725003241; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tz6kmot8/wwIayVlQ8sYHx3olROoe4c55rw8G42/G2E=;
        b=mZhOcvOSRq7NNhdCYlmDONP7cg6tfyH5k0USKymNJLG2LcFOAaPGR/KL32SUYfAa0S
         suWHvIJA8wtkeyQzsKYokyNwUN4J2goytvxjtnQjwQyxfor2uuvmYvdRsIyDQF0yBfW9
         aO8dVvzJ6SMYxhpIXZXG4s9fZURM9sTMtw4o0c0draY7EEUPtBWc+cxv85rwTyY7hIE3
         UWW6oPfafumJLq0Q+Zg0pk3tTWiUhOtwykst5XCrjJFG83ca1pXja/bxo6PEPBiCUme0
         OEN9i/XUtnaQy+/ayso82LsHlbh7BVD25ewzXLPGf3V1ox2jCQzR28TfwcqSmHz8hVGP
         AIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724398441; x=1725003241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tz6kmot8/wwIayVlQ8sYHx3olROoe4c55rw8G42/G2E=;
        b=CJ9jb27pfNzWeLyjv4BiZy/ggJgRydiUh3ap69ciFVOco5gsBZAzxbKBKfcworVkS9
         74dPKkJ1qvu5TICkbnEw0XguDXJcSeuLbU+f59nFI8HRJwP7LUOHSWp6KEnkglZHtNy2
         j9ZyZeh3gnOgC/fZ565l8meomqtxhskoWsgQCayOtctHWMP4OP/j9L6MESOdLSzgpCtt
         yVC2c5PvkSJgg3xm0C2Iqqh7MzAfrRR2cdtgKa/tzqRRSK/AisaqMDbuhPZljyS6K8zS
         ZMakt5iWJ4QrSDQ6vJ92p8aZoVCLBVSiiZe1D22s0sYPu0CjQcVt9lJ9zJUf093PAwJo
         pNVA==
X-Forwarded-Encrypted: i=1; AJvYcCUF8AQAPE3LrQc58f08Tp1uKjTypDVVeIZfoAVLujnjuPvgIqw6DrHroK88CJFniB3RqEpxe5dx8lXazZ1s@vger.kernel.org
X-Gm-Message-State: AOJu0YynZPqzsgV2LPW4LMKnZBo+UzfPhwKQnfxN8LPMJtY+D3gj4JeR
	vHLe60lOtEVMC651zbrmUiKBr5QuGHAcrOLAvf2hPE/TIBV162fPykkYS58Zo9JnNl/jciEvNCt
	MANHO9FceNrSlV+hfCxH94lXVESeTf/++Q1w=
X-Google-Smtp-Source: AGHT+IF4Zj43wFalknuPn1WmDMvkAsUgVKPMpUs3A/Hi7jqN6K4LVIzAjKOhLQ1izvFXII8NHk7VV4t4Ih7iiL63IHw=
X-Received: by 2002:a05:620a:2953:b0:7a6:68d1:7dfa with SMTP id
 af79cd13be357-7a689701b32mr104160485a.17.1724398440907; Fri, 23 Aug 2024
 00:34:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816064100.1993219-1-lihongbo22@huawei.com>
In-Reply-To: <20240816064100.1993219-1-lihongbo22@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 23 Aug 2024 09:33:49 +0200
Message-ID: <CAOQ4uxjWA+MGMoVuj5RtZsjOintviRdowhKN07dK3+R==bzvYA@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: Use in_group_or_capable() helper to simplify
 the code
To: Hongbo Li <lihongbo22@huawei.com>, Christian Brauner <brauner@kernel.org>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 8:33=E2=80=AFAM Hongbo Li <lihongbo22@huawei.com> w=
rote:
>
> Since in_group_or_capable has been exported, we can use
> it to simplify the code when check group and capable.
>
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/overlayfs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 35fd3e3e1778..a0692595a5d6 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -554,8 +554,8 @@ int ovl_set_acl(struct mnt_idmap *idmap, struct dentr=
y *dentry,
>          * be done with mounter's capabilities and so that won't do it fo=
r us).
>          */
>         if (unlikely(inode->i_mode & S_ISGID) && type =3D=3D ACL_TYPE_ACC=
ESS &&
> -           !in_group_p(inode->i_gid) &&
> -           !capable_wrt_inode_uidgid(&nop_mnt_idmap, inode, CAP_FSETID))=
 {
> +           !in_group_or_capable(&nop_mnt_idmap, inode,
> +                                i_gid_into_vfsgid(&nop_mnt_idmap, inode)=
)) {
>                 struct iattr iattr =3D { .ia_valid =3D ATTR_KILL_SGID };
>
>                 err =3D ovl_setattr(&nop_mnt_idmap, dentry, &iattr);


I will need Christian to comment on this patch, but it feels to me
like the checks
in ovl should mimic the checks in posix_acl_update_mode(), so it feels odd
to update one without the other.

Thanks,
Amir.
