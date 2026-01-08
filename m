Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A6332ABEC
	for <linux-unionfs@vger.kernel.org>; Thu,  8 Jan 2026 07:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767856934; cv=none; b=uXySTaOKOmSE3pLZSyvug92JIJyxtrpXKRAdpMOapd4hFITR4xPS6YXnikzy3yZYjCGHBj3L50Mmg9MQtatwZllPWzxYXFEoOD/hz+uxPgViwnbwKDjnA3ZmnUrTAHs2Y2BMBOzQEfwcMgJ5azn9tHbXwBzrSS1qTdS0wEYJ4kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767856934; c=relaxed/simple;
	bh=2ABbdPUUczhvjP+bO1uNWHeWut1Jwh8D2avvX8foP3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VdPNBunXHTgGSFZ/kEFmJUgsSTXvwBN5Wrh5MtB8RGqTXpYtprsusWhXMAqhIZs1ijGk32dPBXM23yMUqqjMvz9EDxDykNm/ZRzQCMokEx3b56zqmu412lGPEqyd2KTjrhD2ut5FF8o7OGX7RBYaJX5ril7DHLOXIuQD5Tkb0uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZgYDu5bM; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZgYDu5bM"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso5873218a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 07 Jan 2026 23:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767856929; x=1768461729; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ABbdPUUczhvjP+bO1uNWHeWut1Jwh8D2avvX8foP3Q=;
        b=ZgYDu5bMxBaEPrXOI9LWvPa2HGdjypjDP14dmnlT6DwUgQORve64+J9PrZsFXQmbXk
         jjFrUzeSy3XnYu2qEBOJk3fjNOip6MdtoS4gATfiemfmGa3nwT4o3MXrqvNOp7eewgFX
         bT2H/MIC3e1Xun2Qc8dFn8wTVeTSF0ObbBoLjXvDH3KSZw4nNyk/xaCFHBmcK2Aht58w
         v51aQmHp2A+wqI40QlMur27RnpPllOhbw0oEm1d4TQeCGL7CSYK/3FR2NhaWEIyOc0di
         9PZvsV5PJj64ScZcr2f0R7QMw5rl3PV16ODgV5guhIJv4i8BjINX1SnjKuIxnkcxp8LM
         X8tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767856929; x=1768461729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2ABbdPUUczhvjP+bO1uNWHeWut1Jwh8D2avvX8foP3Q=;
        b=gNYvxOWy7yr7ay5NBnDgybe7v8wpTXryddwXB3a2ZMMjpOUzZRog5zMcxNl5VRqSIx
         BOzmq/NZ0JUXXwsSODRPXcs1AL4dEZSHETKuRTwrdoKSM6OqbGSCzkNsUHp3/oGsMCpV
         M3sjhpnjBZ7uvZoqafxMVPhrdfSlGafAvfK4Gp3r5Itkloj4ZkCp9DC1f6QL1lpjOmob
         qCDU6gA3F/ujwGgxIdbFfOi1wLvOF3A5hINVmxE3hi1IJMQDiKkgBabqthx3R3CBIN1l
         IRg7PARHw7L1zu7kpP3z68pGfGQSAtR++s/pgAamUfXR03SUnoM7T5s71H6nqvreMORQ
         wZjA==
X-Forwarded-Encrypted: i=1; AJvYcCXVialy6RdEP0jF1fmDnCMuMlIv38YCWsvMANMBuE5XNvB810e7FBqzOTVeJweWDDVH9SUP7sEg+vAJdyuU@vger.kernel.org
X-Gm-Message-State: AOJu0YwYOzKv5q48wNDjnkRA0W6vISQfUVsMCyiWlsIWzbj2VTUMsaER
	GcasfR087yx4xMkLl7BRieAftAe9hLt3ZEvs6S9fGeJcFrP3v85hX14J2w7gqTph1dT09P6EJOM
	w9O1HXBEBKytbnMKNj3D/dSku0EKiXK538+ak
X-Gm-Gg: AY/fxX5U+kPB7oXCHlLiS9VdWdJqxBkXWdDUVPazg8jOH6V74wugU316JylhYIxrlhn
	VkODEQnPPqSRyfEHCZ6HkbtdbqFotqfLc6/uH56kY+ywWTu06P+3GTlz8DdMkGIZWEzbsfEHuMu
	tXhipd6C2yrQnZjckitJDPhgH9aoWy3UX3lmplVdxgmRyOrUU0DTjhXxg+5GRql5LaRg6H8E+TR
	YHKoC31ZlwB2AzdCcpek5HdZeOOg3GtPJX+RjZeL/apdMkt9iJ2nWA8GnzUURIhUlsm1AlphHQr
	nfQFNK76IQtG3f9V9NM+OWf94wkw6w==
X-Google-Smtp-Source: AGHT+IEKho5/95w0mw1isGhGEzAqmiNc9AwO44hAU/FLcqRyfxbyQMZB866nPF4cm7DzN0DeUeLV6ErXSjsokbziLz4=
X-Received: by 2002:a05:6402:42c4:b0:64d:ab6b:17c9 with SMTP id
 4fb4d7f45d1cf-65097ce5c61mr4606989a12.0.1767856928990; Wed, 07 Jan 2026
 23:22:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107034551.439-1-luochunsheng@ustc.edu> <CAOQ4uxhjWwTdENS2GqmOxtx4hdbv=N4f90iLVuxHNgH=NLem9w@mail.gmail.com>
 <c5e3cce3-5953-4060-ae62-76e33022f4aa@ustc.edu>
In-Reply-To: <c5e3cce3-5953-4060-ae62-76e33022f4aa@ustc.edu>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Jan 2026 08:21:57 +0100
X-Gm-Features: AQt7F2oLduIJm1jHYSGoSjXIDkoMd-Mb0Kc2cWkavzs2levI1s9rT8SuC5cCilk
Message-ID: <CAOQ4uxgxGktn4YYH28+gytqPEJnG2NDx7Qjw9_dYae0_cGXyGA@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: mask d_type high bits before whiteout check
To: Chunsheng Luo <luochunsheng@ustc.edu>
Cc: miklos@szeredi.hu, bschubert@ddn.com, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 4:48=E2=80=AFAM Chunsheng Luo <luochunsheng@ustc.edu=
> wrote:
>
>
>
> On 1/8/26 4:43 AM, Amir Goldstein wrote:
> > On Wed, Jan 7, 2026 at 4:46=E2=80=AFAM Chunsheng Luo <luochunsheng@ustc=
.edu> wrote:
> >>
> >> Commit c31f91c6af96 ("fuse: don't allow signals to interrupt getdents
> >> copying") introduced the use of high bits in d_type as flags. However,
> >> overlayfs was not adapted to handle this change.
> >>
> >> In ovl_cache_entry_new(), the code checks if d_type =3D=3D DT_CHR to
> >> determine if an entry might be a whiteout. When fuse is used as the
> >> lower layer and sets high bits in d_type, this comparison fails,
> >> causing whiteout files to not be recognized properly and resulting in
> >> incorrect overlayfs behavior.
> >>
> >> Fix this by masking out the high bits with S_DT_MASK before checking.
> >>
> >> Fixes: c31f91c6af96 ("fuse: don't allow signals to interrupt getdents =
copying")
> >> Link: https://github.com/containerd/stargz-snapshotter/issues/2214
> >> Signed-off-by: Chunsheng Luo <luochunsheng@ustc.edu>
> >
> > Hi Chunsheng,
> >
> > Thanks for the report and the suggested fix.
> >
> > This time overlayfs was surprised by unexpected d_type flags and next
> > time it could be another user.
> >
> > I prefer to fix this in a more profound way -
> > Instead of making overlafys aware of d_type flags, require the users th=
at
> > use the d_type flags to opt-in for them.
> >
> > Please test/review the attached patch.
> >
> > Thanks,
> > Amir.
> >
>
> Thank you for the profound solution!
>
> The attached patch has been tested and verified to effectively address
> the d_type high bits usage issue by enforcing the opt-in mechanism.
>
> The variable `dt_flag_mask` might be clearer if renamed to
> `dt_flags_mask` (plural "flags").

Agreed.

>
> Reviewed-by: Chunsheng Luo <luochunsheng@ustc.edu>
> Tested-by: Chunsheng Luo <luochunsheng@ustc.edu>
>

Thanks for review and testing!
Amir.
