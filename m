Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680973921FB
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 09:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782207329; cv=pass; b=q6pLNFXzs43IvItQSpdi8vktSKARwNoUOOd1InPGzUeihyXqFsFtXg64Ybe5STgHg2W3F5MFFLW49q3vxi4rbF/yf772mNbzE+xpvXLDEuS3swGsBq0aziK/zj2oxQjIDp1V8QjEqO35v7SXtQc5sCd4lFFirZ5yMXqVGdWOlUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782207329; c=relaxed/simple;
	bh=t+Tjk1yQcjbe6TGlq+zQLMRCMSQaVie6E8D/1SXM/EU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HTqTy8jdGKKJCjhvyccT1xdPtuEr9QTiPIc1OyxWQyyX77iMNBb4+W2uuMx6L+r144pvNOaA2nKX/fS2DpCsbxkpu8ATjsUBbtH3LlMlUom8HwW9n2LNJiBuLNDoNSzBAIP5VXm+vgGbawr1DAcZuLuw+6n7XCzCa5BhFH9HQZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dyi2I9nZ; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dyi2I9nZ"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7e86d46b02dso60001327b3.3
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 02:35:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782207327; cv=none;
        d=google.com; s=arc-20240605;
        b=dENbJMfUsS+fGoyPX4dqOQLZzQw9dnKLrQLYm9xNFr9xLWY4mOw8tWPnvyB7Xd8C4M
         OaBuWaV3PDBgUfQ7jLphLbg1GIoQn2Ib2jk40PtHnSu8r38Co6g4xcYzooQpHUKe1eCv
         t+4eXSzP7bo2E9wggZuSa5KYDPaaiNhYmZEZox7iyldbKoFOeJcNOR6msXMZZ714+f5v
         wclalFAR6CqHs+Jpj4A+U95Z4A0gz6QIG52cMQrFpVeKwgvm7+wUjfZTr1fnqtFKIl8m
         jNgcWjyAT13eSGeajA7MUyTS30Tcpcig08GSHi+tgDTJ35PEWJCb1QYbsrcayUAzCVD1
         yKvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t+Tjk1yQcjbe6TGlq+zQLMRCMSQaVie6E8D/1SXM/EU=;
        fh=cusL3k8uWHn9gsbeYyQ1p9ARzzaqsqtULBOvaEF0cVQ=;
        b=NRxPEdeY2tkBSEbjx/uVOW4o5QWsXnTElTvyGjnfcw9iebY1MJgXsu6KVgfQKL5F8A
         xObNH+8RsslsqhhDRZM5/LoSNQErO/vuGAv/Dke7UA+M0CI9cmByORcRlyPp3i/VHuVg
         owVNtwRE++kkwPfi+sroT3v7zxtWQ9x4BH2UTc3ywFXIVUF2teK8GzDMawr27fn97J73
         HTvoa2S6s/dDXGnzqCAmwOKpvXMJB3754RmBJBuG915ENJTPTbnvwgckwDccgtvwF8A/
         EmaAG7S21r3AYOYZbCGoN1Vquutcnvkkg3IlD8VSi/VdRJEbA0M34UOGpHavvKPMDZds
         rRgg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782207327; x=1782812127; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+Tjk1yQcjbe6TGlq+zQLMRCMSQaVie6E8D/1SXM/EU=;
        b=Dyi2I9nZFC++YErZqnPphNP0AI1riwP7C9FBFhcG4CeV7Eu726obeYfmLbOvwRoQRw
         6KaeRfuMnBUxPoTa0M8t2IeTq+h4HzOmOMgPh2EmC6AvcVYfhEI364ie5Tl0Gn4Ih8m2
         VP4m8ZirCFsmvDUYAej0T/A7fLoJvT1Cr6WvGQMnst6WFIuK15TDtJfxFwbb9dkAsbWg
         a3H2d+Z5BBo1k0+nMPGoXMpnd/a0cICtQ+SVzIoEE7sTrCLRxeqmLQtLPwAEPPVrzvdB
         pgl66I4ztk3WyfQgCnffoA0ZRA3n36rYnNPReOoWptq/qfM0wjDy+9Ea2hXk4QYcgOs/
         T4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782207327; x=1782812127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t+Tjk1yQcjbe6TGlq+zQLMRCMSQaVie6E8D/1SXM/EU=;
        b=BkJb8nCjBKpndKBV33PKGJhCwIZHjqQ+LB0fAqJjdve7xueOE53ubHfxnScwzaHJqi
         KhjZomXCYxw3FgCa0mcOhliHSgyx+JRB2YBxj9a1rs9sP2yAn8LDRmsY40/EQHJBih3C
         XqyWv1g+bbBBpgNch7hy/eik0zDS0jXGWUqD9DOzIDBuVGG2NfBZDVytSt9X/MsruLdQ
         ckk61O9Bt1Mtl9uKLSw2/MdeVUtFZfn3fOQn+GvNAAbtfAinDbtjAob+rvzym15y75jL
         gqCrPGwJuMo4+yE9UQxm1tFkq5Zy6ORRd+yQ5QoML9LlgLzlWj4y+YwRdod9E3hDj3ju
         GjNw==
X-Forwarded-Encrypted: i=1; AHgh+RqfjBMzITnynH2YZItBg/kYiRNGzE213ynrLsTNuXQCUCitk9hla128GfGqF9QnrHocm0itZ/eSSt5aIUZy@vger.kernel.org
X-Gm-Message-State: AOJu0Yzasap15RRz2pIb+9+hDRK24O4/FREZfZtlJ3UdO5yjGEO2BHE8
	k1Nf8DV/rxOas6vsnqTyC/1gtRztrbgbCnlfah8oSECtOgfcrQeD1OZRmrGhM+1UTs2Li42bwuK
	BGuHYs1RP4WZryJNYJoVHW5iE3bcJMww=
X-Gm-Gg: AfdE7clZkLxTEs4hcu4UhABKq7fawxnelyhfr6MiCoGAN/MHSOFd6yaFlZzZRcU8vC3
	kWbvt9e1Kuod/JQ5+OtRrZH1J0kA8kYuXfB4nObp08dKSGC6dB6uTHAJV80apMdHtPoBgl8MqA2
	fFgElPPP67VyOx/odNCVW+t6LTlCx9SIgaAhItZktOO5/tzqhxFQW2AmqY4wGCrTThLHrdexKW6
	rQw2cirqZr86I5ubL7E/T4n5CtYZMd1d1wND14RP0z9N1bI6xFsa4utKaXxYqXPAY+aaE4cTg06
	mCnOu7w4Dtdiof0V5pSA57UceCVhLA==
X-Received: by 2002:a05:690c:6703:b0:7ff:83b:72ac with SMTP id
 00721157ae682-806dc723260mr16585017b3.12.1782207327327; Tue, 23 Jun 2026
 02:35:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623084337.54344-1-laoar.shao@gmail.com> <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
 <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com> <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com>
In-Reply-To: <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 23 Jun 2026 17:34:51 +0800
X-Gm-Features: AVVi8CdwrarYCteWaesPDxg--Nxx-TLjvvMWptPmhRObw6SWTqxFBmxZ2mKMxwE
Message-ID: <CALOAHbAKVF7bLcT_RA8xP8djkSFBXfQiw8h=jCs_-jknnqHioQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 5:25=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
>
>
> On 2026/6/23 17:15, Yafang Shao wrote:
> > On Tue, Jun 23, 2026 at 5:00=E2=80=AFPM Gao Xiang <hsiangkao@linux.alib=
aba.com> wrote:
> >>
> >>
> >>
> >> On 2026/6/23 16:43, Yafang Shao wrote:
> >>> We have enabled "volatile" fsync_mode on our Kubernetes production
> >>> environment to prevent container exit from being blocked when there
> >>> are many dirty pages to flush. This has worked well without introduci=
ng
> >>> any issues.
> >>>
> >>> However, on some of our production servers, upgrading the container
> >>> runtime to support the "volatile" mount option is not straightforward=
 [0].
> >>> To address this, we want to enable it by default within the kernel.
> >>
> >> Just a side note: "upgrade the container runtime is not
> >> straightforward", how? it seems that issue is already resolved and
> >> there is no more discussion.
> >
> > We still have many production servers running Docker, while the
> > "volatile" mount option is only supported by containerd. Upgrading
> > from Docker to containerd is a difficult process.
>
> But docker can be patched too: if upgrading the userspace is
> hard, why upgrading the linux kernel is easy?

It is quite easy since the kernel can be livepatched without
rebooting. My employer is a heavy livepatch user. [1]

[1]. https://lore.kernel.org/live-patching/

>
> >
> >>
> >> Not quite sure applying a default volatile policy is quite feasible,
> >> especially the issue documented in
> >> https://github.com/containerd/containerd/pull/10274/files#diff-9239161=
e2af83fd84df5792f9fe64701c517fe4598eae60d4d245d039955f46cR33
> >>
> >> then userspace cannot drop `volatile` option as a somewhat
> >> workaround now.
> >
> > OS vendors can still set "auto" as the default config, while customers
> > can override it dynamically via sysfs. We have been running with
> > "volatile" on many production servers across different workloads for
> > over a year, and it has worked as expected without any issues.
>
> but sysfs setting still applies as system-wide, and there
> are some edge cases that we cannot apply volatile as
> default, that is my one concern.

It is unclear whether there are mixed workloads on the same server
that require both "volatile" and "strict" modes, but we have not
encountered such use cases across our large fleet of servers.

>
> The other concern is that since `volatile` omits fsync, so
> it's a posix violation (even that makes sense for container
> writable layers), not sure if we have to use it as the
> system-wide default configuration too.

We have use cases for setting this as a system-wide configuration. It
is unclear whether others have similar needs.

--=20
Regards
Yafang
