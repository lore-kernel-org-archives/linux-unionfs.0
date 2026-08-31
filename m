Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C146B3E022B
	for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2026 11:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788175167; cv=pass; b=b/BEB5QzJAvk72tbCOccbs8ZcBMPghrQvy6dLi4uBH53aSEO9VGypVrp4ojDQE/+NCEk8S6kIRllM7cVlrESR3kWwqas76DhyYJpOaAG8Tm5w46052s4YxwhSd2lx6sSTxJ8gwXX/zjZdOyrudJ2PTveuhRBYLXnt91WXaLiIfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788175167; c=relaxed/simple;
	bh=sPwZ2rjGa4ORrMcBhiUq14r5UiTivTsJ0F6CWmTx5Uc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eemvDs9AZ+yxeTN6boPjXDdvuD30+rlgT8Fu95pVBVXLu1/A5Tu4WnFn9tas6fTBje9c+akiEYujjkCmtkc9KMLQQ0EazdAyVFJzHDfc4Z9uu5929+kqJA14nITQrxq968/QaSO5qa3jp43yX1nXIkR4Z5C5DSYQ8Yf0IrToPaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qyCq6hqb; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qyCq6hqb"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a5f968ada7so6701757a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2026 04:19:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788175163; cv=none;
        d=google.com; s=arc-20260327;
        b=CANrIYqmcBirvhsh7RvHiHjffmVAkjfnG9zfsZ83/7mUJqH69RpcW/Amw6Xa3Sv47u
         w6BGMfl3AFX9aYHlgeN1viQdmk2OKTrL2ARoIh2vc3aFuMtsJfcTBTynWt8vMQalxBSI
         o8l2Bx4dH82xllB6UvrjBOScjl+qlcJIsC7g17bBZZFg7XPsUCkFsVVk6iEnc42H2vvQ
         /EcglvmSnxtpzeusQ0OgUTVuQ7z1F9tRQmqIRQx6BSrNrF5qW0Wo3EYz/ZJww56FWoT+
         +ZJW0Eybg2mQMQaIbJRDseiWp0gYCldTLwhj7hHE4vaohMt6KfJa1A+4z3scbW1BsncY
         +D1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WPMZR1wY182SIo0vTA+fOa1hLZEIFYqeqqv+4/YgvXM=;
        fh=L52ytDfRonJT3McK7Tfv96H0RxU6rbFWUU2QClYtMpI=;
        b=mKyqJRlJfpFUaR/IXmdBeMUpPE0RAd9KrXpq7eSqZzDhNffNMFaG2QITwTsqA81SUO
         vEttCCiv6W3ptx8t/mqAwd+yVkkh3lPLT2Cjb7WMeSQbI24zuxQvLTDnstx5mgB+rdXL
         YvbBtTaQTOysIm2Qu+yaYWKdE52fjBOd2x50aLvWOEIrcfYQuFicAg3YMHgJy1SpNUv8
         OmhlY32j3ek0fLQUWlQjrLK9ThrbnNoEWGgdTES66m8RmTqHmAUHv6fm6T8S8kJ9f+UE
         vQi7Ym/ajpekQp6TxXyRMfdnjb5Hk96fxyQlfPtVWTa39xa1PLqwSVql54s1f8gPyiRD
         JqxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788175163; x=1788779963; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WPMZR1wY182SIo0vTA+fOa1hLZEIFYqeqqv+4/YgvXM=;
        b=qyCq6hqbVGW3o82MQ3x5y0C96Bqw50li1H4cx77OkHq51awNsfIvR/foHHpn+ZHRr3
         D+C5xJKEBydK3vchTAB0YNr+oGMnHELUm+ks+L7nZafvP//EOrtVZzkglkpXNo7+jPGE
         IOplyxsfZtWrkn03S5h87VXCGZCt8s/+GlAII32GKfg8KuGS4+1/7iCye63UNEft/+Rm
         8jCcVScaqmv0GSOIfGa3LGMx3pq29i/WkExRBc2KYWoq9kj5MbNzzWaHi1tnVe3oSYn/
         DJxUi4hzUDBV9onSNZb1xXIthRx44S/kaG26z+VKrOpn802C+p9LaIbH2vsEggM7RMDs
         RuvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788175163; x=1788779963;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WPMZR1wY182SIo0vTA+fOa1hLZEIFYqeqqv+4/YgvXM=;
        b=ClfuKGZBf2/AVSJ7a6u3PwEnVw1NAu1Hd7tN+YZLWCiv9T7LXS38ykjivPLhkpECd6
         uQP1Mcb4J8sAVnro88ZecOZ2Z0RCUoHGW+DN/nk2H1VhqyKBDpwS5KNJiDiln9lCeKK7
         y6d2aXiXwluxAVh8QmwGJRj6YMB92ictwsKOH/RbuoJfDH7gWONc/C+VEPF6x4ETeEek
         ui4cJ9LuDEQJNuIfR+p8reSP/hzxnmMge8xjtNeZL6HUsLYLB7pKMwG/ZQSlNTmdqAeb
         0AFxTKM9XPUCJc8EHIb0IwYA2tKcUu3HBFHZv+eLSLpdmHkRPxO3/JIv8L4VOgf4ZYAS
         V8eQ==
X-Forwarded-Encrypted: i=1; AKwUvByrftecRHx34ypwlapK23SbTEVVvam0I4X1Q0pH2SMjgy8nxNvasU3eHfFt/ib75WbaPyLs8M8e3irFwHOD@vger.kernel.org
X-Gm-Message-State: AFuF++nlhQyfN8Ysx1wAQRF7y27Af6MJGckkK2D5EIg3l1FyxRVDOKUz
	fMrT8JWsbex36SktC8EWf1Rpkw95H0H4PndQnxaj0KYefOzM27e4g9V1gdNQRcsec9DLQxJ2SdG
	FGx7rn+SVQWK/BdTo/lzXMTHh/eLPfZ8=
X-Gm-Gg: AYBFou2JZ9Y1b2h/Craa7E5qyr7g/uEKiKEY2/1uABKbuRDTX5Uk9gKQHrsj+Osx4LC
	nGwdQEEJWZ67tVriQUU6pCs1Tncnsg+CkKlbMM//ZsSHJWKO0+rlGaRQYMpKkKP7DhLZLjZMJ3U
	bTXzna1jnFAQflc5pCDHFcRKluC4EvKIlP9CO2kU6B8wPbmxFrzE8M8+vCQ98NcmOp4xKZivGXs
	k7oCqQHlhA1ECe10XM2H/kzLpRVYlIb6gZK5DPW422/YsEed13HaTZU3ILWXpxiksMV4ifsYJbk
	PjHXRvWyQK9ukS/zgCWJtaQDAdD9cndD7xfzo+ONfDxfDg==
X-Received: by 2002:a05:6402:21c1:b0:6a6:32e2:fb49 with SMTP id
 4fb4d7f45d1cf-6a647796951mr4553257a12.11.1788175162309; Mon, 31 Aug 2026
 04:19:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831104154.2256-1-prabhakar.pujeri@dell.com>
In-Reply-To: <20260831104154.2256-1-prabhakar.pujeri@dell.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 31 Aug 2026 13:19:11 +0200
X-Gm-Features: AcwNN1XbV_zf11XWhT_g0nhVI9-LiZR6z645IAaToD4j_bzMvZZShqeTlCOznoU
Message-ID: <CAOQ4uxhg5qtjYHoCvGU=NCawg664HJmDkdau7HNScDRrV0-xSw@mail.gmail.com>
Subject: Re: [PATCH] overlay/081: add missing _require_scratch_nocheck check
To: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 12:42=E2=80=AFPM Prabhakar Pujeri
<prabhakar.pujeri@dell.com> wrote:
>
> The test runs _scratch_mkfs without first requiring a scratch device, so
> it fails messily instead of skipping when no scratch device is
> configured.  Use _require_scratch_nocheck like the neighbouring tests
> overlay/079 and overlay/080, as the test mounts overlay on the base
> scratch fs.
>
> Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
> ---
>  tests/overlay/081 | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tests/overlay/081 b/tests/overlay/081
> index 2270a04..a13b785 100755
> --- a/tests/overlay/081
> +++ b/tests/overlay/081
> @@ -14,6 +14,9 @@ _begin_fstest auto quick
>  . ./common/filter
>  . ./common/attr
>
> +# We use non-default scratch underlying overlay dirs, we need to check
> +# them explicitly after test.
> +_require_scratch_nocheck

This copied comment is not true for this test
Not that it matters much because fsck.overlay is not maintained for
a long time, but I don't like to spread this wrong pattern, so please
use _require_scratch in this test.

Otherwise you can add
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
