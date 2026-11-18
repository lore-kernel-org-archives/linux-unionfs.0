Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795020858;
	b=ms04uOu/BypWrxV3/+AiaiZ2sOcB+cqG/60QskTZaClVHC4JDK7Jd32s8sKE4pDYjEAG
	 kM3VG2x1bOhGIVDVmxZdZVT/HFsn+9kLXM7QeRvWuJp/KCzeNthWhmQC5Ok0JrM04DOsZ
	 qNpgg8WaBpPEMdcUzF1Imq4fDUrsucNMEgvZaStYmXo3lYCRNVbECiygrtGepbsM8Kork
	 lnrf2nbDG2GSEgnHtVqmCFU9/znucRTN5qzJ6qFCT6VdBwEifJmo8Xn8jGgQAbT36a84l
	 gwW5DKyHzV0OyNbMhD5NGemfERqnhoYBxadtV3RreETJ1k/X7PebJ/eF8LwGPoPbMgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020858;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=CDJiK8ulCmGPXt6juYUEqx4i/lVoMjTSowTa2yTzZD8=;
	b=qMq5LeRGD4LV6Ci5IpiOIJoqrgjbA3b1Q25rah0xAsqXdSiy7anTslqR+nqIb6dtn7Cm
	 UFZDQL6YmQH+R1UuyIx0vYWQ3tj8Mfll+y42BmRUSg9SoTzJi+75ZLFC7edQGn4oLvDTp
	 rGdsbIikVebopZNoTwEJeF3SRRz7ABzQ2ePVAOmgQOQs+LPO2j6NIoesQNwS7NR2mOLA0
	 q6jcTylja5PoAtddcss5cbb5KRJbkIZwnlGk7vy/qpC3vbAapGslhaS4IiS7ZqlKDsFsg
	 +hYgNNAMQgDDsBzEC6oPnOFFSxcY9GQoAfbNmF0flYMqv9Yhund+Xy0Ux1slsTkbD6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KsQdPKwp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0BA606A338
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 16:54:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D0BA606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KsQdPKwp
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b6f42095bcso1996430a12.3
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 08:54:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795020856; cv=none;
        d=google.com; s=arc-20260327;
        b=ZFvgITlPNR9gY9VDRz6VA6rKJqtDOouAXUro7pd6KKQBbxA9t2ME9TNp4Ry1essiSS
         Z14HCp9vjMxdv1nQSbU76CS2NR4a/vi42d8Mx6oZIHOuMnmmqeNeWfdrjK779w6d2nm3
         TvN5LLFVaie/1oXEOausHkZ1mOEo3ijI7WA/75ThOq9Y3l54hrbdvfK1iSl3zRzDhy6g
         TMVTu2Ia5T2/L8/pwZOMcXQmBx7cP4ZMBV7JoMkLTmaLCJ32znAu1IQuus7UbfBhiLQJ
         eMdcpRTZWiGAlTNMf8g1ESyfAYKFaX3vxumSmVDlWBQOp46UXz7q2S0qtNExfnXEHsHB
         i/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CDJiK8ulCmGPXt6juYUEqx4i/lVoMjTSowTa2yTzZD8=;
        fh=FI1PQ/4eijmXbP0EPxXx+tG3E5xcZPp58QHcPIa5O0s=;
        b=k2SQN5P5RuRQEP2vKwEzgzgEMMt8zjZ635ReNrq8Y7kv4Vw4smbXnWYeQBS+LiBoIE
         m72FhtHqAgM+vTsvLP+S4fqRZZhJ4YEYg9oiTmSPiaOaR9gtUsdf23amzpwGLdRFk9He
         q+62S/ekAjoO9J15W7WXVrjWC+E8f5mCjBOADe18Kp6BXSzbFMKqYmX4J6EYu08H6LSm
         f/u3/Ky3jr6nxzvuBle9KKNCTc3CaYxYChLkQ+6qO+n4lasS4HyxvwvAayr/bRytVTRz
         KLQ1991cEzGn/FqbLzH7IUHDGn655stc6wlOMyHlYgsJMPlQKXCKIJvBtopDzl9QHbE6
         Rn9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795020856; x=1795625656; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CDJiK8ulCmGPXt6juYUEqx4i/lVoMjTSowTa2yTzZD8=;
        b=KsQdPKwptjdtytQXQpi8tV1PrrJApryKPo8FzWoGYo4agivvqGhqaDdnhaz8a8YlpD
         byLUXbJp/iX9nWNoPaip7gbWOSBmMhzNk/HVadWmsmCIWqMuSmAVdFTlx5pXgE0IcOwp
         e0AWwpif5wLARK20RmPAvsfutHn+6WoDiGgkTXLezOa+NuIgK+c8OcZsbX4I7CoukABF
         CPa44YgRSyY2ECidbL3iZ6og1R4mHs6LBK/7lnjPx9tzl2wttHLIMZtPdd3/ae56kPB/
         u6W4Az8jGilGmP2W4Nh8LNm9cFiPxfBQTam+J4Y1ClLYYdq/7yvHQt14uiy1pWOu9AYX
         viCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795020856; x=1795625656;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CDJiK8ulCmGPXt6juYUEqx4i/lVoMjTSowTa2yTzZD8=;
        b=yrEmp3bXzViBwN2tmTELj0cn8FaAx47FVbgl2c+DwvlcLuxeoJ1Vk5MNC0k5c+Y/B/
         0ccMzR6OQa3RsqOB+NMIeA86IcumlJ3OuyYrVNR6q07kvecP0/3K2glsII4GhXVFQFOR
         eb3COr/wuhVXQ1mQeAxH06N6nAuWh/AHmCBGnCFNCWqniFKQmv3DkUDpNuaxx8h3xTGV
         2CU/BkalIbukjcZMj2adUhaHuljeyRds/A+OHCj+tGWN20fItgte3vW7F0wsdjOxjnT/
         8qDAudtCu4uxyzTfgpWfRJIffrzt/2rZNHJuE00pHW9P9LnK3wI9capnwy8ElIjFTIYc
         jlVw==
X-Forwarded-Encrypted: i=1; AL+hErGOyDC9NlmxNS0McLEw0H5Oqai78J/QLz2gHz3JMXgWj7nieSfP9TNFq02NiAcN0t+sbruNOtFhoCk9iWgM@vger.kernel.org
X-Gm-Message-State: APuU4Z/1eGf8km8IGQri5DmDhDrawS+nxlQGos+cx5ZSphwx1JsOuh0t
	BnGpa0UgubzT5P/oEN05CbjEXhIIQrV2AimfwqDwbg+xhWqx8ZR1ZC+25gvMn1kaOThHC7GLaWB
	d8pIrlg2p1H3YC1JOn3jAF0xz/ZQAznc=
X-Gm-Gg: AYBFou0LcWShBW8IsB5H1oGC3UM0GF1GSaafSni4II/9qxp9PgPt8GIciVFvDAdKa0e
	LMo0EPNirXVJJ9LQFI/DBpLz1JJ73+Q9CokV5S0/vFnMB+v7qf7Itjb8kIgeQU4rkbLKX8TeV9Q
	3olWB4VnoXxkaSogPoXTOqSODRqDfBdk9uYqm5zteX5/WIv3Na4R5tRNDzGJkCd6yH7P/lZ1tIe
	zunfTqdpeDydmD8OpSNcOgvT28CUXGdPdj0pOeFxaBou+xKaeVyMABtxdFLywnfNE3T3eKQTKVI
	SKDB/0D7QodiNyNDuYTqzXYj0VpD7FOh1wZ0/ej5anSCiwoPqzoo6labtqi44/+bh1IUv53AxlY
	4JbcqzFgZdP8s3pL5mlH7q80tnfHYNRZfk3Iks42Xaq+nqat0fydNXMuNLxixgc/WbuM74g==
X-Received: by 2002:a05:6402:1f12:b0:6b1:e8e1:a3cd with SMTP id
 4fb4d7f45d1cf-6b887ec81ecmr2799883a12.35.1795020856100; Wed, 18 Nov 2026
 08:54:16 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118073102.1216568-1-amir73il@gmail.com> <20261118073102.1216568-5-amir73il@gmail.com>
 <20261118-wildwasser-raketen-hierbei-10c9d844ca6f@brauner>
In-Reply-To: <20261118-wildwasser-raketen-hierbei-10c9d844ca6f@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 17:54:04 +0100
X-Gm-Features: AclHuK-Q9fUaoJA1bUQRbqr_aK3VHd-DiceNuxoLUwcVldFRusbtcGe0YcFhEoI
Message-ID: <CAOQ4uxh7ri8hF_4+2p4M5rotQ5UF9bKEXr_mQLQU2DDLe6NdOQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] ovl: refuse pseudo lower layers unless offline lower
 changes are allowed
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 5:26=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Wed, Nov 18, 2026 at 08:31:00AM +0100, Amir Goldstein wrote:
> > -             /* Pseudo filesystems don't hold data for metacopy files.=
 */
> > -             if (i >=3D ctx->nr - ctx->nr_data &&
> > +             /* Pseudo filesystems don't mix with new overlayfs featur=
es */
> > +             if (!ovl_allow_offline_changes(ofs) &&
> >                   (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
>
> sashiko.dev <sashiko@sashiko.dev>:
>
> [Severity: Medium]
> Does checking ovl_allow_offline_changes(ofs) here run before
> ofs->config.index has been finalized?
>
> [...]
>
> Because most pseudo filesystems do not implement export operations,
> evaluating ovl_allow_offline_changes(ofs) before those fallbacks run
> causes a regression where mounting with an upperdir over a pseudo lower
> layer fails with -EINVAL instead of falling back to index=3Doff, and make=
s
> multi-layer mounts depend on whether a non-exportfs lower layer appears
> before or after the pseudo layer in lowerdir.

This has the opposite effect of what I want to achieve with this patch set.

If I could ban pseudo layers completely I would have but I am afraid
to cause a regression to some legacy use case.

index=3Don which falls back to index=3Doff is not a legacy use case.

Thanks,
Amir.
