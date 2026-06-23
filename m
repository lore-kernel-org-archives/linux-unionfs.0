Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350343624C8
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 09:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782206141; cv=pass; b=NzJrGWkeHxfujGGjVjzzWKxO2PwMPeCAwGufIuGH6Zs4cDeGR7CxSa38lbW8wxQr3LZZ7G1x6oRwLNUOXzMWXCW48zFOmaYPrV5ZFKOwxeed2s4RCD5vi2+638uxjt/IJvwEvO6Z/LHO+efRxU8bH3fMqJdXL7rutjJ3PAPfvgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782206141; c=relaxed/simple;
	bh=wzXBGCi8T/CCKoIhDrxsUAgJf0LtBli1HekzeRRkLqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aKV8MKVJdIBjaM3saxzsdl7PmbiEmKGu3ByRE8pgoclF+4kpLSLJtUo/Hlt2sBwf0QwjL6A15YDmUSdFYdAMV/IW/bg5mKsnMnDGD6lYYCerQibvLUgY9tQ4AuWdsskqtEm9zmgaKgoGdR5pc/dWV3VR1dIPAzn5AQ55br5FUrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kRFPBBzX; arc=pass smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRFPBBzX"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7ff0645d1d0so45593417b3.0
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 02:15:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782206139; cv=none;
        d=google.com; s=arc-20240605;
        b=dnjHSgySH9iDbzkT9/S1jjNZcT4eRpO/+RPlfEN4ZQz7+vinkRerYTN5GsXmhkM4P0
         hqmRT7Bf4N9unP7rjalQpTukjp71qOyBX3Bjadk++UlhavJVWRlyHd4L/ztdmvBT6wws
         +rTVikhkOjikefWRr1th4nc8xu1u5D0FLnS2/o+F9+HQKLwN6aY5rAWRPRy1MWgJJ427
         h68DW+jiHeAtEhmG1TjBvOVpXlaKoQJ1+wU6twQj9J6aUnVZXJ6f3HpclGY8ARxCAK/y
         R4WCALWgK3DgHXy1ysez5ZzMIcBr06IPLSFfpQ89zh5NYiONHXVM0F0Z7tCXRmYTH+cZ
         ZvSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wzXBGCi8T/CCKoIhDrxsUAgJf0LtBli1HekzeRRkLqE=;
        fh=KLvoLtR4KZnI2zNVPVZve9sGdi+THlojhRHXBSljQlQ=;
        b=P0zC9guHCoJ89iejcvt1BVTJRZFvcINCZOSwK4DKdmdhywt830SlMlWWcV1QTPRqpa
         9Dv1ttBIwQlg3Lktyl5uau0WeSMaSwvXgVi7DkoZ8si+pifMrQQ9UdC3/GlyhAcdftUS
         5fY0bhznW/GUD+nA0Dhlkv97oMH4niPyoXeaozPaWWkGQK39q8079Mq9fCyp1k1jniqW
         DsskkIEQutsdEBhl4UGLdbWE89T1DavFm9jpjfpfKiR3I/3GE22kwDhk3zJCTdMR/4Zm
         NUnIOkaLRLkjrVO5kD29XeDP9E0Z6miBMsU63aH8MdgXyaGUiD1SAP6Fo+CASvMN0aAw
         Y0cQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782206139; x=1782810939; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzXBGCi8T/CCKoIhDrxsUAgJf0LtBli1HekzeRRkLqE=;
        b=kRFPBBzXjLhfMaMa9ieAmc+9eycnHgJyQt0ZxUHFWi3ZV+07FTliPL9hj36TndeWX5
         Dv+8lf5IBnmtlGbxiXSs042vBJQKot1zdih4eXUGi8ClsN6COongbf7UUnAZvDEcgLb5
         6ge0SxoAWfHOq6ucAYTx2lpe/2Lhg33sc9t7y4mJaY+JSTrNj0aHRWUxjK9TRhI6JTXP
         AYE4tFF2AyhPmHILM29m+FlNFLK5FJKlXGPoAEqyfDMfcSHCo47farry44rpoc0U424d
         PoaM/A1msneb2fk3V0vY1drc7psSIdCaxtZxxV9Cmc5IrA9VbYIk5j+huWiH5ube3L9T
         DaHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782206139; x=1782810939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wzXBGCi8T/CCKoIhDrxsUAgJf0LtBli1HekzeRRkLqE=;
        b=ihctHdfO56IBxVPjuKHPX+MW4VCwFCgDN56kP4zkMyUUhiC+NcM78gKt/KinFD3L8S
         VQTIf/fOrl2fZHdfGbDrr2pDRVaAGWK2WlOhbEpPuum08LvOK+D9Upb2Yh2ia6UoRNk4
         MBxX8phsV46GRZsnygTwcDV8/EtWUi/O7hIPLRZEkyARZFfF6mNyb5h2tiZ8A63BW6vF
         rOQhNWLUvAId/5lrXc5VorwnFmJ85t4/E2HI6S6vg8quCnKgzk8G8RQyAt3Yj8lT9dxq
         Wy2g9uZFSdXih+gTsVaQ0Zo8m4x2FoDMM/WBtdCXM2RWbGLUZRzKteEO4qQqVaPBVsbR
         c6Eg==
X-Forwarded-Encrypted: i=1; AHgh+RqBl7G8//3JPjEYdw85H7fLC0gmkp7kjPh4qECO5myciJWkxcj26msxhK4Y534wVGtGwfr6bYwnfUyF4dku@vger.kernel.org
X-Gm-Message-State: AOJu0YxnUy9RvkYEIhYu7+Yiw2VffxjzSLEx2+17s0ypFrz2x2/LyuyF
	LbQy/3Oul0kAxSevdRTt8SSvPX5HWbg/NVmAkX1VdqFmJwFQnCHAfJeq01Fr732vX5NDKOP2v7h
	sm2oZyLAezCkJTHRJeBGcOWNGaFzn3Cw=
X-Gm-Gg: AfdE7cmqhg9t15Cwz0km7tDGa6mg8jELNOg8MTCwwyNuy1+Qf9XaCTTOYYKoi61Qtbq
	4g2xMjXe5l3bINmvtUgp1gKSudwT1eNBDO8zujZWxL7a7/X0CvJHmvrAcG68fim8kWgcbIsc4tq
	DtW6mgknawdKf1C3suYlSomnhxsQPvJFJxXEftdfJzqheJFPDACZbqgPGqUTBdffiAV0SXXf/ID
	hnv7jC+H9qkYxFrShOeKujY24c25tjT2ASsUlaehXDs7iqpiCCqJr6IqUfe18G3eVp5SX3/f2Ts
	L4LzOk6c/VbOsLDiipElHC4dUnpkng==
X-Received: by 2002:a05:690c:48c9:b0:7ff:1399:7ebf with SMTP id
 00721157ae682-806dc817bd1mr15521307b3.15.1782206139175; Tue, 23 Jun 2026
 02:15:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623084337.54344-1-laoar.shao@gmail.com> <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
In-Reply-To: <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 23 Jun 2026 17:15:03 +0800
X-Gm-Features: AVVi8Cd5cpPbRsuefCkpRej7ywLmIB6EyFd6wjtajEQAocklqZH6ZGzkIuA6mqs
Message-ID: <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 5:00=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
>
>
> On 2026/6/23 16:43, Yafang Shao wrote:
> > We have enabled "volatile" fsync_mode on our Kubernetes production
> > environment to prevent container exit from being blocked when there
> > are many dirty pages to flush. This has worked well without introducing
> > any issues.
> >
> > However, on some of our production servers, upgrading the container
> > runtime to support the "volatile" mount option is not straightforward [=
0].
> > To address this, we want to enable it by default within the kernel.
>
> Just a side note: "upgrade the container runtime is not
> straightforward", how? it seems that issue is already resolved and
> there is no more discussion.

We still have many production servers running Docker, while the
"volatile" mount option is only supported by containerd. Upgrading
from Docker to containerd is a difficult process.

>
> Not quite sure applying a default volatile policy is quite feasible,
> especially the issue documented in
> https://github.com/containerd/containerd/pull/10274/files#diff-9239161e2a=
f83fd84df5792f9fe64701c517fe4598eae60d4d245d039955f46cR33
>
> then userspace cannot drop `volatile` option as a somewhat
> workaround now.

OS vendors can still set "auto" as the default config, while customers
can override it dynamically via sysfs. We have been running with
"volatile" on many production servers across different workloads for
over a year, and it has worked as expected without any issues.

--=20
Regards
Yafang
