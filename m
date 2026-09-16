Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EFD43E071
	for <linux-unionfs@vger.kernel.org>; Wed, 16 Sep 2026 07:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543823; cv=pass; b=AUWLI8T8oO9Bli/61mhvfu0mCjsJ/sF60BOW4wLebiK4CszfJYG5OPJTRNbrX0ti4yKNCenarLWkdtSXNCtMqlRPEM+G13SenFN1JIMt0dIJfhIyaQRb+slW62qJWq7EMMnDm+dF1j/yJivQmTzUU1/yakOOjOVCznYOfi+6t1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543823; c=relaxed/simple;
	bh=9JdG5qSC0tk0ZBwuTZWIN9q74g97zJlNODpRuXQIuvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WCdG5v4qPnUdoZgYeIEKQ+gkSKdjrVHAgy31nXfiIIAuSeh21XGNfOT1t/NdU7PRjuStHAxZ2xOIB3HwpjaltUq+cefLuISRFg1u2C5fOa2VNgK3UqMsuKLiE1+uXSYlbZjN9uoNiXhEiqeJr0CX8N5puahu0dkqSje1hH9Zzw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=slyysVUc; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="slyysVUc"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f6c7a4aso86914166b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Sep 2026 00:30:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789543796; cv=none;
        d=google.com; s=arc-20260327;
        b=P+BxazNnBo1bXGakJw8004HQe9Vbz1JpLNkU7YVKLB7gHOPy2ZnKl1hrIG8c6TYV6p
         7KU9dc/WhcIkuW+gU/zAAoQjTu5M6ruKZFG2UNxMaop2suVmfKtrtq3+HUhb2lY7mgHT
         /p7CHTYriNMYzNY+g/LjgL8Auixq42IvOLeB1i0AY0E5CaZUq7gsXzwNLwdR2g8Aunvf
         4CQocSTT0mTDEPd5/Deghx1ePGf66tQQRUlZExhZRxOrOPyfz0bCPfQRv5ImwcewF16L
         5xYel1O/1d2dBBqiCRPzPdi5X+nJosaXfUhNxkoDGGZj8/P4ge30qAWsCm3waHfTz8iY
         kz4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g71NvPi7wydwxFtIeU+AubwwN2N/zTYMrRDoUqH+bKs=;
        fh=7Vd0DcAQX/VLPanI4XfzutWtsn/COx4xyRa5UaKyziE=;
        b=U6nWeThPHfOzbu9nTcjdu//Qgss3nLZ1LoxutzQCG3nxrLxo+FqDHlXfvQBdt9LrbY
         M640P8ipbNPjYld08B5+8P2Uw9plG+pCe2EcQkW6js/Tl6cneZVosNRoVtLzNRZcgfI1
         2+5Q669EiHqU/JYwU2jRZJYxAwE2tBb+IpkkjwklU6+GOfEeQmxGJKe3QzaMLmghsQES
         0TPbH/L7381CDX0ZzB90IVpaCl/DY6y4AAuwXMGJq/v8TuIZk3bYBdh9dSYmdNtP4CCE
         zfjNmXb76VjVU0TkFfddYX0wNnxYMnx/XNC6hCQTnBp6sYfYaHduntmrY/n5UMwUrEwv
         PQeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789543796; x=1790148596; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g71NvPi7wydwxFtIeU+AubwwN2N/zTYMrRDoUqH+bKs=;
        b=slyysVUcaut4zHyAgLBDk9vWOFpaqVvGpwwhTbbimyUhghlWyLAurG7X0RMTnLAOfo
         KgjsWhWVPaT1EtPnEx9Nm4+bUQ8FKN1JsU4HYrx8RDYn9C4Rp/pqsj6bn+0Su0Vwsi1d
         PtJDGiBpaUFX3nLJ+hFydEXZCDHzPZjPaEcQazBjvK5esqfA3a0LkMoi3NoIaGBqVBkD
         165bSNlneZ3hgUu5VUK2K7sr7PKQw5c+ilSvgjXRfIDcnLrkZKF5azpcgmKPDWyEj4xk
         EqT2lEeR0fIBoj38YiFaobyogDxWRQDytK+5ain1waGZl9TAePgK+jIYtnA5ZDlKEiFT
         bm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789543796; x=1790148596;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g71NvPi7wydwxFtIeU+AubwwN2N/zTYMrRDoUqH+bKs=;
        b=n/ca+OU49bRKFg8ev5oZLN11kFp8GNm3N/+g/gJWBxPU4uvKi+lS2b28vXhtCNPfYE
         nm3OaaBNbCxkvxXOocYWjgi03IeNV0d6eJ/pNpzjzq5ars5FkpF1t5qjjQ1tjGqYQqYp
         URJ0pD5tZ9c++XdZAmq9Pe1Tfev4PbQVl8+/9ENpAe3oLbBV/rv+i8w/PiVCphsx+EYZ
         6yqMFD0ZWEOXJURsucou7taG6rqbIpzeWpcckaHgUqtdkVhcxOKdLxzqpspSCHiSLILs
         4KrpzV15hdZXihbr50/IkTx6GejfaWncOl9Ull4OGTINPw67aRq8+ROGiwLKhEL7BiUN
         Qt0w==
X-Forwarded-Encrypted: i=1; AKwUvBzYi7yXTw57TDfJaoNVy5qsbZHgvtFIKgGqlfSdgmt6rq8oSy0Q/KD7ncBYppw6Ood0z79ab8o/XjPHX6ng@vger.kernel.org
X-Gm-Message-State: AFuF++kxIzoVV+lJK6sQeJEOrSSurclvRRvoWZQLRV6Qq5Dk9AMhu+/p
	9Sms6A7vDQv1XUWc5pGXYm6KPORpAy88cxCzr6sWt4HCCFCqfuf/M1ju8PLPfTQ4FCeV0uwkKR5
	ldmyZOGpPCwVApnAmw9TKGoHUnX/upjhatZhDkvs=
X-Gm-Gg: AYBFou0seFdynEBBNup61dpyOxaSthg6m00REbRPJzf2TxtHZxOfgN8QFaFw1uhmPBv
	Dnh0qE0xmeKarMIOA+UvLQeleCcXotc87MQrD4KmoCh346PdG35wCH3+Umsn5BYnNdP4Y9z+1sR
	kx9VrCR1XSYCzzyHoLPuMjnqCSUBD1AWWqbgHV/gRpveTNLrmMDmUDQrh0UMO+1O7h0W2Y/9MSV
	3ijCdMwkC8gc4xppFFZyeeQHZ2l9GKWsH06gT8q++DalUy6ZVmJLFqZ4nZrPuWyVHcgRui2FxUG
	WYw3N2KtS6R+M0IUqymrZN4MNFipDz4xEv/R+thirLMc2RLRy1ORwQ4m
X-Received: by 2002:a17:907:9621:b0:c29:4415:2ec6 with SMTP id
 a640c23a62f3a-c29e520778fmr98720666b.12.1789543795984; Wed, 16 Sep 2026
 00:29:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915153608.5197-1-prabhakar.pujeri@dell.com> <20260915153608.5197-2-prabhakar.pujeri@dell.com>
In-Reply-To: <20260915153608.5197-2-prabhakar.pujeri@dell.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 16 Sep 2026 09:29:44 +0200
X-Gm-Features: AcwNN1UTUoHAQpOF4OttlFsJqQJKPO8Hys6tqOdmdDnflGDEHZzWukJCOGRyPYQ
Message-ID: <CAOQ4uxgCgHhLsxonj4vjcJombbOjEmxZqS4adx-+VVn+BB6b2Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] common/overlay: let _check_overlay_feature handle
 param-less options
To: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 5:36=E2=80=AFPM Prabhakar Pujeri
<prabhakar.pujeri@dell.com> wrote:
>
> overlayfs mount options like uuid, xino, verity and fsync have no
> on/off module parameter of the same name, so _get_fs_module_param
> returns nothing for them and _require_scratch_overlay_features notruns
> before the probe mount is even tried.
>
> Per Amir's suggestion on the overlay/081 review thread, a missing
> parameter for such options means 'defaults off' rather than
> 'unsupported': generalize _check_overlay_feature to treat a missing or
> non-boolean parameter as default N, and drop the parameter existence
> pre-check from _require_scratch_overlay_features.  Support is then
> validated by the probe mount itself - a too-old kernel that does not
> know the option rejects it with EINVAL and the require notruns as
> before.
>
> This lets tests require param-less options uniformly, e.g.
> _require_scratch_overlay_features xino / uuid.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>

Hi Prabhakar,

Thanks for following up.
Feel free to add
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

After fixing one small nits below...

> ---
>  common/overlay | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/common/overlay b/common/overlay
> index d32f3219..89413933 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -172,8 +172,15 @@ _check_overlay_feature()
>         # parameter (the system default) and per mount by mount
>         # option ${feature}=3D[on|off].
>         local default=3D`_get_fs_module_param ${feature}`
> -       [ "$default" =3D Y ] || [ "$default" =3D N ] || \
> -               _notrun "feature '${feature}' not supported by ${FSTYP}"
> +       if [ "$default" !=3D Y ] && [ "$default" !=3D N ]; then
> +               # Some mount options (e.g. uuid, xino, verity, fsync)

fsync does not have on/off so better take it off this list to avoid confusi=
on


> +               # have no on/off module parameter of the same name.
> +               # For those, a missing (or non-boolean) parameter means
> +               # that the feature defaults to off rather than that it
> +               # is unsupported.  Unsupported options are rejected by
> +               # the probe mount in _require_scratch_overlay_features.
> +               default=3DN
> +       fi
>
>         # Check options to be sure. For example, Overlayfs will fallback =
to
>         # index=3Doff if underlying fs does not support file handles.
> @@ -192,10 +199,10 @@ _require_scratch_overlay_features()
>         local opts=3D"rw"
>
>         for feature in ${features[*]}; do
> -               # If the module parameter does not exist then there is no
> -               # point in checking the mount option.
> -               _get_fs_module_param ${feature} > /dev/null 2>&1 || \
> -                       _notrun "feature '${feature}' not supported by ov=
erlay"
> +               # Some mount options (e.g. uuid, xino, verity, fsync)
> +               # have no on/off module parameter of the same name.
> +               # For those the probe mount below is what validates
> +               # support, so a missing parameter is fine.
>                 opts+=3D",${feature}=3Don"
>         done


Apart from repeating the fsync option mistake, this comment
feels out of context after removing the _get_fs_module_param
line. Does it document the past code?
I think that a simple "Validate that mount option can be enabled"
comment will be enough here.

Thanks,
Amir.
