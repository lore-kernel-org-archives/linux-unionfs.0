Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DC818DB26
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2026 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781546598; cv=pass; b=WDNa+I+rypTCQHnrQKYpK5zC0dhzJ05bi70b+UFzXVlLrat6U34sxKOa7JWvOIV0iKKgfdy1u8d9Z0y3YpKWF5KJ9tz33RLsaW7RoRChNEsgqt2iyEDdqAQhnVIX0esYfQiwB2W9Y2DZ2EtQIhkcvwUpPd9XDbUMwnjt0ShByhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781546598; c=relaxed/simple;
	bh=hBOi3p0V03qyFPtScOsJhsmSy+M+ZuyXWOL5390UOjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=neL0xPDoFq3z/5uY8JIygOQDYrrhpDaHfnswLlcSNvqWJyrJd9cRCrFU30hWDpfcHS1q4sWyIoj9KPYlpSMMrL+eN6qODHtubrsGe4dAxomqYv109ufZdIrFPaEmvCdvgIzO8EyGJ5yJ10KsRD1WhW80AM3yMTSoocbYraBWwLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=myIZemFv; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="myIZemFv"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6913fb25322so4697577a12.1
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2026 11:03:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781546595; cv=none;
        d=google.com; s=arc-20240605;
        b=MGE2hzs53slpVqV3tn51Jc5IB6/ZlZSqOVHiapQsewowSKv8+KUczdSLm8zNSoFtUc
         91+1IX3CJLQJ+PGW0O/7VufYLH+OjaLc2Gs96YnBLGjq9qdPNCVxgWh+Rp7fqQEr76UG
         uPMg3DEtS4qwC9qa1h7axu5J63tjUF5J8cVTIwgM/i9/ftJ6CTMAjkRAyQC5Ju3RCWOL
         3TbdcK6Fjs9p4CTSExnQESktrHShbg083Qis0lQg9hTB+pdftLZF+o2y/hxSYyBJaYfo
         dZeJ/V7WGWZ9cvf38wyIJppZQj7ATuPVXxjQnx5L9PmOOpSh85ZmgmuZYcG/7jnM7VS7
         R7UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hBOi3p0V03qyFPtScOsJhsmSy+M+ZuyXWOL5390UOjQ=;
        fh=IvD2HZo1zteSAB0j5B3L4UVepaV2OLwIfuWKCnqQet0=;
        b=AMuazXpDBVXq8qqjO6eRKBE9ka41G1P4DkJSTyNA7p8EzNTBQf26r4Z6udk7l6uyNO
         Wka4/2r8ZlNq2eN+CBWcSllxzl5q2H2rzkC4a/6COSeq6DMYQSzbXrkxH1N6zavGYsEp
         woye5VJxPxo5Z4HioDh20myWP8t/M66+oDb2ixJvzm3fOQjJE4ecWRzOsPtyOh9WT2eW
         PXRTN17BHL1onFrIEQtOAZqloMY000MPdtAxOQWo0Y4j4BD257R3vwHeyUlRRC9AG5xX
         AnCiEfdcff7wMyI8Z9rcaFna4KtX/SYW9PRO6qNkd1zxeFYRxx3d83tyAGgQNEt0Wj1X
         Bxqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781546595; x=1782151395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBOi3p0V03qyFPtScOsJhsmSy+M+ZuyXWOL5390UOjQ=;
        b=myIZemFvoTlAinWuw3Orhm2XFDBji4wzeW6yNOCib9ozeADZEaYk/q0fhzr6IONarQ
         Yz7KWrYjYwGUX/rDDB49HDNe9DjyVi1MwS6mhgW4R/EG1ZJ2xzGSaa4g4sL1T6maKRpu
         y3LwvoyxIfcw/hh/Eqy1MxPb8NCPXYtPSi0f8dW+Zx2gb4kcwU3gmbGOZCkU1dRpLvVh
         /1XwvNSKM6AbxmIwiG3IPdDitc+bMYCAj2W4iXHkafHWS4UHNgTj946eY63jZLb+61lc
         LTowbs9p0s9ytXozYIKEGLGq2V0fSZ1BXt7MARCqcqyuJTHufK0DKyR/HC/RZVFGFx+G
         c6xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781546595; x=1782151395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hBOi3p0V03qyFPtScOsJhsmSy+M+ZuyXWOL5390UOjQ=;
        b=T8jMLQEur2Wk0eUDutIHBQYe5nCalOxM9B+nyoyJL3oc/2q8o6K/eFXzNdwto7fXCp
         ED3xMMlOnklPfJl/BSdO4u81VMRtifA3DNF3ICmBww/gdvYy60DNo7KRF3Jr3pg5M7iW
         8fi2KU6MZTE3N6kwpGk1fqU3Gz8V0Ekn7Osd4qBzdIFboGn7tCefD/wF2aRX7tDa+qtv
         /+1VP0Sf/IwoXXT2jJIWEGTdw+T9whoMckQfRRNlweAp5zYiCsXDO/CzmTChHfU9KaLh
         f0bBYYrsO8YBJ5rLOVPQjH2aMD5n4Te6a+fLbWI1Z7Uq2kffMnBPl48zWB7UdIgNTBwG
         gcdQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Gp1Mv4Y7KGbWo9+z47zkhJGMvZhU16RwJwqjtwSXI7bV1XCM0p6Hg58RFuCtlIgj70hOAMBSDxe4nKRru@vger.kernel.org
X-Gm-Message-State: AOJu0YyZM0ykXHZu2R0bNnUPiWkrGSBqkCLVyH6gvjxbQPJUHUGg+Svj
	FVmruNvL2bbaPkmvyDcQCA/yPs/2qbdjdyQg1MkrGDIwj4JYGsxX0Qt+kgwWvJ+W/erq8SZ7q8T
	q8Houg7z4kQhnw5ujVEq5K6eNgOFwTpA=
X-Gm-Gg: Acq92OFQnfjr7CVmDJfwEFeeDnBvVvQjaMMWPoFax31r1bML8uRM8NjQd2gkHiTrBl6
	u1/usFhpmQaT9Y+tRD2l04azmdWMo0i34OnEt+l3jsotCzQfnI3SLMP7O+4cbGm/nYSFaISQLe/
	mYaJMqKNUQCnECLKYOIfjTXt1m/khprXVFjo1N0dv7tAQ+l1bI2YfUKlMXAue9nKiQ+co6HT6e4
	sU+9oyUyUMxVcBVHRHZp+nFnrl2dSww+BvAFyAI7EykinViEw58i6SMNRFCPhY3PoFHbuCZrYNF
	zFh8/sq8aGQ3PD8a4wwVhOzdtOQPgq25mnFaZpU4xg==
X-Received: by 2002:a05:6402:5d0:b0:691:706b:183a with SMTP id
 4fb4d7f45d1cf-693788fb0c2mr7319496a12.6.1781546595064; Mon, 15 Jun 2026
 11:03:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org> <20260615-overlay-idmapped-vfstest-v1-2-c6b3b2228092@kernel.org>
In-Reply-To: <20260615-overlay-idmapped-vfstest-v1-2-c6b3b2228092@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 15 Jun 2026 20:03:02 +0200
X-Gm-Features: AVVi8CdpMlwPdMYy_oKn-YBrEOug14SXeIqtiRTYC62U7wjb_HcLETp8cI_hDMM
Message-ID: <CAOQ4uxjtTd0H=DjyyxaOm56be0JOy2y4ZYV8AbVRnsdGnv4hxA@mail.gmail.com>
Subject: Re: [PATCH 2/2] src/vfs: skip whiteout-device fixtures on overlayfs
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Zorro Lang <zlang@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 5:33=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> The idmapped mount tests create a whiteout device,
> mknod(S_IFCHR, makedev(0, 0)), as a fixture: a whiteout device is the
> only character device an unprivileged caller may create, since it is
> exempt from the CAP_MKNOD check. overlayfs reserves a 0:0 character
> device as its on-disk whiteout marker, so ovl_mknod() returns -EPERM
> and the fixture cannot be created, failing generic/633, generic/696 and
> generic/697 on overlayfs.
>
> Add an is_overlayfs() helper and skip the whiteout-device fixtures and
> the checks that depend on them on overlayfs. The makedev(5, 1)
> "creation must fail" probes are unaffected and keep running. No-op on
> every other filesystem.

I have no strong objection to this patch but there was actually a request t=
o
support makedev(0, 0) in overlayfs for creating overlayfs on an overlayfs r=
oot,
so perhaps it would be better to probe for makedev(0, 0) by fs owner instea=
d
of the is_overlayfs() check.

Thanks,
Amir.
