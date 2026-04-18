Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB86A242D84
	for <linux-unionfs@vger.kernel.org>; Sat, 18 Apr 2026 15:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776526804; cv=pass; b=lFKFe6McCIAG4Nws/OAm/9D9qFQ2nRMocwkPKImkwMipq3HNcVM7qVx+r4wtFuRe0pkWxnS3ZT2XAAfw2oP9b/hb+vbluVQKJ4dDkdx5Ml8GEc52OMQlaRLwm9tniZC6WU6pRajacjkihucnbaj4reVkK+8nJMmPxyOmQrH39Y0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776526804; c=relaxed/simple;
	bh=cEvYDuFXuVic9scYpdvaU/f/zI61Ha5D07vebOF2hUA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MjeefHt4j/2aCWA8KGRMFqEY9QC4DaXvb0TMaC19Wk/sUuIIaXLJ2QgbPcb/GX02s5BVdRkoIjE3Gbw1x42TvFfFiY03Ai1KxyzkjKLQAuy7IvEZSpHorE5moBLLcXX7R2s5Wnkn/Sg61AO1RIKztL4KuChG+Fx22Xlwdi4LCaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GmnlTe6G; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GmnlTe6G"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9c1da7ac63so313231466b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 18 Apr 2026 08:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776526801; cv=none;
        d=google.com; s=arc-20240605;
        b=RPVHZ/PFlCHj6yaShrkni03rTtRxiaYqv2UmbivpuOOpgqQ1REk53/2zejUXJ86vaZ
         U1EknBVClNFEh6yajik/Mf2k9AJY23YRuRwx5LXURvwfrevfNOBpIhm3J4DiXIcuBdiI
         PVje3Ddb5gnkqYS37x7tbq1ddr8AeQCRHfNSocBs4Pfhz1UnXt6QDtHZV3w4ZE7PxBS1
         9fMuu1PAcHGwmketjOS1PXnX5SqpPWpYWd4B6Rja8ftO/8pwfN3TIzjMnUmGwM1nSO4M
         wYF/N8eISQD75Nb7lZhJuJsGch7HuzWPPNBYQhiBIgczrbt2Qn9HwEsWZpLjuYLGWlR7
         yz+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cEvYDuFXuVic9scYpdvaU/f/zI61Ha5D07vebOF2hUA=;
        fh=ovNvZ6sv5LLQIeIPL6jSgEns1EQoTOlBRxlQtHXRDMc=;
        b=Qkow/IBo+2Nh3gGNR+OMBiBXQIJtCD5K82PCu+RMP+0/eKvQ7r01qmeu36DYGOkis9
         EVrTqOkYVXD1VVZtFa2fzMrOLgf4cFg8YHmkb6gK3DHLK6WPiztLG4/GEZXp5jBKa98q
         Y40xWcCvJcDf7cCqpKrTtaXPV9c+9tahBxoOS/q3saCX6/LbzTgqN46oyFgucH66MFet
         CZcRq5nh06LFHQTOk5nkk/OWx//ZOlgeYc7oQhi6HJvkhEEWg8BgoYeidvXAdfmZpATO
         j1QAUrFwG17/+pnV4yRIawzxN4nH+7jNcne1QlBW5CujYnU/PYQnpf+h4YzPeAeWzZdm
         ESaw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776526801; x=1777131601; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEvYDuFXuVic9scYpdvaU/f/zI61Ha5D07vebOF2hUA=;
        b=GmnlTe6Gt7g3mzOQJ3eMbzSphORZe47kZXX05KSaCBXAkhnxOaW6lpXZMabnSySTC2
         S6PzjSDN7oViDfAES1IdHkJ6Gkg74uEIu9BTRqtgAFww/ILi5Shag42ZjiEeZyoMMrMv
         GT6gNnKPyP6Ly8xBjQ+sUIgA/z3MeEhbzsr3KNxP5FAq+KUK5nxQu8vStidreIWEkUTS
         0cP7ewpgut8blDQ76qVl+sSap+wFHWaSe7gqfFGVeRBHvTEoeG8tUv7+Fte4o954cyWU
         NBEVmhh2DF3MZxVVD4AUoGunI8KPRZWg11narsSYaG3qXUmg3Z9dq6tcSqoUr4WcSIQw
         zFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776526801; x=1777131601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cEvYDuFXuVic9scYpdvaU/f/zI61Ha5D07vebOF2hUA=;
        b=iax8wzn9o1AmJUPvxRuzbNOxAxfH6KjxEPV/+hpPjfcrT7Z+Q6aD8jUyRa/jmL1JOU
         vEBN8JgVuWPlox+ZBQwUAepVB49Z1y+cdEfxsqlttCPDA8Ng2qreGxhrJQw/nYANUgZc
         QsneG2aurmZGR90TFVR/SYEsB/MN2B8FB4PcMJ2LVkG+5+NBQTKccMbkYOCx2nSZZX46
         XeZbUJ+yN94l7fR1RmeMQiDEK0XASmcnyHyy1hz0NyHkoc41whdynvdi5MbukZPomVLN
         D5mpbJdT/SHUfwkokA7css4UgWpvBnaF9BhBpjyzexwjaYM9Z5NIub9Nplvu6YUVqopB
         PjTg==
X-Forwarded-Encrypted: i=1; AFNElJ+EIwqMFnLe1Lem4gmp1AfPZ9Kosoxey5JJHx8LXm7ygzDBleg2NTA21KuFOa1mTFiq+dJlG9H8w253jb0c@vger.kernel.org
X-Gm-Message-State: AOJu0YyPZ+0CPRJV/vADWalDIFbv/ZSQyswZYLBIEd5cofxQ7C+03Dvs
	MBkWbt4MFetFmUf9vPxjsZLPOWYHL3rqK8u3Dxn6wpzmkWPNDL+XYzbCXnEaZXGc22HNw2MjllR
	ZkKa7387o/V+mCCRxi/soLxJXh/uPgg8=
X-Gm-Gg: AeBDievunplfWzLTtZoKZDTWOmX9lm5PsvXPT1rl+wGwxD7zUA7fD+S5W7Kfuo24qPl
	TlYvslbqVHUeD0xztASfi+faEvBwq0kzXiFfwyIXXtEA9+Neqh6x5h+S+jo9rwqyDYTPlZuPoEM
	Hnb4C2QL44Dojh1gdQbYAbt7vy16IjFfwBFSOcrYx7j+7VPlVr7ZM5byVmTxji2CpL0iaG5+w3e
	Zat417+L/u1eqOC4TxtEEETuVZdPYwZ6S9qJWt/tmxQbR1yv3avXjH4n6fjcmwMpucoIXXbPpM/
	hO0++NWxUwbAuv/G/SWdk40KFwzDOUGtnUGkU3C5QFFh0vDE
X-Received: by 2002:a17:906:fe45:b0:ba5:7cce:979f with SMTP id
 a640c23a62f3a-ba57cce99dbmr117469966b.40.1776526800916; Sat, 18 Apr 2026
 08:40:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHWLEDHfXZScF5jNDzgOxGXf-MBDcVNtqW0DbNz8Ra8rtcuL+w@mail.gmail.com>
 <CAOdxtTbwipkyAfDakLAB6aVp6YkPWtKpDdVDUTz88WDB-18HXQ@mail.gmail.com>
In-Reply-To: <CAOdxtTbwipkyAfDakLAB6aVp6YkPWtKpDdVDUTz88WDB-18HXQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 18 Apr 2026 17:39:49 +0200
X-Gm-Features: AQROBzCvSbGA03ROsg6cVMJlbAynfy2yIZAnavXEgKUY8bnKpwlWeH4xlKzfKLE
Message-ID: <CAOQ4uxhUn6oCBuVJqZu+FcMx8XeAQHZbXFAGon4Xeg2SPLJW_A@mail.gmail.com>
Subject: Re: [REGRESSION] Return change in 6.12.80+ with volatile mounting
To: Chenglong Tang <chenglongtang@google.com>
Cc: Derek Taylor <ddtaylor@google.com>, stable@vger.kernel.org, 
	regressions@lists.linux.dev, Kevin Berry <kpberry@google.com>, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18, 2026 at 1:33=E2=80=AFAM Chenglong Tang <chenglongtang@googl=
e.com> wrote:
>
> CC Amir,
>
> For example, containerd 2.2.0 uses `volatile` instead of `fsync=3Dvolatil=
e`:
> https://github.com/containerd/containerd/blob/main/core/mount/temp.go#L91=
C1-L92C1
>
> On Fri, Apr 17, 2026 at 3:41=E2=80=AFPM Derek Taylor <ddtaylor@google.com=
> wrote:
> >
> > This change seems to have so far affected at least containerd in an
> > issue reported here
> > https://github.com/containerd/containerd/issues/13250.
> >
> > In stable versions 6.12.80+, commit
> > 6c0cfbe020c0fcd2a544fcd2931fbc366ee3cd12 with the specific change
> > being:
> > [*] The mount option "volatile" is an alias to "fsync=3Dvolatile".
> > In this scenario, code relying on checking "volatile" will now fail
> > due to the return being "fsync=3Dvolatile".
> >
> > #regzbot introduced:v6.12.80

Hi Chenglong,

Thanks for the report.

Is this problem in production containerd or in a test suite?
I did not understand the purpose of WithTempMount().

Is it possible to fix this function to use string.Contains() instead of
exact match to the "volatile" mount option?

If needed I can fix the kernel to show the legacy "volatile" option,
but I would like to first understand how bad the impact of this regression
is on real production workloads.

Thanks,
Amir.
