Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B0E24E4AF;
	Tue, 27 May 2025 09:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748337088; cv=none; b=XlJFzZFYPwPxIxHElmcsvyCmgZWeuj5DX8w355pjr3P4+5pd3MEzQGs7su7yc8ot/JnpggnUl0eEuTnEgnqxmEy8hEgnrXMEo/xq81k+IDgPNkhE05TK6OD1noaNy/oGa3Jo1W1vtd2QZii2Q/BkLJsc2RrHPFEat9Xeitl1n1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748337088; c=relaxed/simple;
	bh=pVUXiQk4mzFjM1ISXLY887xZssO3EaKjuSF36p+jEAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=slFU4gcvwAdy2Djp9kK3K76bDuxHq446i0opwpyADJcEzxafX94hwc2sHxQtHmwW78i0Ojywe7Jdej93GV3cd6T2USnMQwssji6jVQDdqMSV4bUVX6HXPDOWZESrwjaUgbRPndPoRy1g5dbZOgaHHBcLmBW/eDGDowUf9/EO1b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c3FDe2jB; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c3FDe2jB"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ad5273c1fd7so604835266b.1;
        Tue, 27 May 2025 02:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748337085; x=1748941885; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcGm7f3bxDxYQOUxtAGzo7FJmxxWmSLjFYAvCe60WKA=;
        b=c3FDe2jBkKgLYBnGLBXgDr939raxYt+b/t/3Q7oOUULmpOadtoBTMxHhQ47DsrHjZn
         6chnrRgpdKLYLTvxFIPCsWBZnW9XAkB1JTzoRVCHhE2ka2zncWYR3FK3et6i2Jc6E6Rt
         0U0JWivPm/n1pHgKj1EzaA9Se1mK7rvABvSNFRTTW7bgaVOZkSFbvQTzVkR/scmvDzkg
         X8Eo5/EBUbjBYs+RhCnio92RvRRNx2hk04yZwTMcSCBpWJCVNR0KxBjeHDXk3tZecCvP
         WbGTN0sG8GQJVs1l6KLI1/y7/rDr1MsCCgSdy0xWIk6M0KRVHuXsOMXX8WbbdYJdv8f/
         Xd4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748337085; x=1748941885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IcGm7f3bxDxYQOUxtAGzo7FJmxxWmSLjFYAvCe60WKA=;
        b=cCbOewll6C9rF76RCzThIcSWauRReoMgS7jAzVkJ7HN2RGC/UMt0xytBOqvaSR/dDd
         RE5TXLlnaOcUymOyAbwdaBGmGEK7oLvsCWsaju0l/qSGR6h0goMrlBfrvbqL5DgvM7XZ
         GrYXtIV/xwmcOff0/o/wRPte9QFxmoM7A2vDQBCrL2M8V7uvr/dq3VGnoP3ESbS1mfza
         La2AKnKinuHukhKR4hw+8vjQSVFNkA7BYVX/gci8LWpBgy8YC8tyB8OggHvGTwvWL0oh
         hhbrQdP2QT4tWOhUi/9fIopvWPnxEAvuNKa9SWwu7czWRipDT3KwvvBkA72+FgMWkHgQ
         te/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU6y2A/wMbIjMMpCYFTPRNFOJ9UV8RzSMdlbe/7zL5hv4zJlPQsss/u+F3/NOq0ao3qzqQ3vuosu1NKwxRQrw==@vger.kernel.org, AJvYcCVT1VRzF5Loj5/JAFlmbz8NfVYMXQRJPVZfnRTppQ0Ev/2+7cHK0WxM6WyZ13O3a3El+34h2hIH@vger.kernel.org
X-Gm-Message-State: AOJu0YxXIOXvi5u+hDI17SCEHIU68Mr82G8YEeVGznk56Jqqf0tpdz4r
	0TnMQXSdXHBFen1LJkoo1D8aoAhS6D7eafmkN2y1jtT/5YKpRL1NAMk5SdKZXDmYYiKt/MHBWmz
	9nUlzY4cMp/QYgNJLsfQtBsrCgytBH5T7pzniTedO3A==
X-Gm-Gg: ASbGncufv7gxWNHFs49WESvc1A3lYWAf4ilKLI4i7E2cd/NjK6Fd0xj6GVNKuAuqHFw
	/v8/FMSOIrUBv/AoRhPF/XbxhJyxGKNAEZoe3lEUwFLlY0PM1rGmUcJMAqUv/CNPFTwwGJh1QYf
	ZR0Ghrgk4/cmst1vQc9fkOIqk4Pvg3BYtr
X-Google-Smtp-Source: AGHT+IFnrsH8eLu2exr5rsvcicAetaj4rPjM28knUp23tM0hcEvrpssGNktptRaMU+yd6V13MVt5Z1Q6BYOVGsFXiMA=
X-Received: by 2002:a17:907:7e9a:b0:ad4:fd7f:a4 with SMTP id
 a640c23a62f3a-ad85b20acb8mr946939466b.47.1748337084332; Tue, 27 May 2025
 02:11:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250526143500.1520660-1-amir73il@gmail.com> <0b4a524d-52e3-46e8-b119-255e3e134ef7@igalia.com>
In-Reply-To: <0b4a524d-52e3-46e8-b119-255e3e134ef7@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 27 May 2025 11:11:11 +0200
X-Gm-Features: AX0GCFsopirBCrI7cb3Ea9BRz8jNTUYeab_Cep5n3mCiSFkXzXyfCY5nyO_oXw8
Message-ID: <CAOQ4uxjUTkjuyWEkFd1UeGcems43dPS2GMGRGZJERjuMGSxm=w@mail.gmail.com>
Subject: Re: [PATCH 0/4] fstests overlay fixes for v2025.05.25
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, kernel-dev@igalia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2025 at 7:05=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@iga=
lia.com> wrote:
>
> Hi Amir,
>
> Thanks for the fixes!
>
> First of all, you sent two patches for 3/4:
> [PATCH 3/4] generic/604: do not run with overlayfs
> [PATCH 3/4] generic/604: opt-out with overlayfs

OOPS I meant to post the first one - it's just a change of
wording in the title.

>
> I tested this with Linux 6.15 with the following command:
>    $ sudo FSTYPE=3Dext4 TEST_DIR=3D/tmp/dir1 TEST_DEV=3D/dev/vdb
> SCRATCH_DEV=3D/dev/vdc SCRATCH_MNT=3D/tmp/dir2 ./check -overlay
>
> These are the results before applying this patchset:
>
>    Failures: generic/294 generic/306 generic/452 generic/599 generic/623
> overlay/019 overlay/035
>    Failed 7 of 859 tests
>
> After applying:
>
>    Failures: generic/294 overlay/019
>    Failed 2 of 859 tests
>

Those two tests pass for me on both xfs and ext4 base fs.

I am running with trixie libmount v1.41
with fstests tag v25.05.2025 (+my patches).

Please analyse the failures so we know if I am missing
something again.

> So the tests that I reported in my thread are now working.
>
> All patches are:
> Tested-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
>

Thanks!
Amir.
