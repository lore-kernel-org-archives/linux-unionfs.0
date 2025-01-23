Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2114F320B
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 08:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737620614; cv=none; b=cHFOipUzkLnwRMQrbhfo4wagF2IPzCLjwTuLZL3fnouTrDZ5bXr4CulgP/gw6H4oMSX2WteyWvtEcXKyKrHpPTnN331iIgmOXiQpCJQvPrzK7p4u8hH/JGmvXjjbM0L5NFxs9hgN84jc9WRIsyIF9IaOPniqu/QzvmoKEPFJVNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737620614; c=relaxed/simple;
	bh=AhbhB8IYyQMEdacYv3qHRABRAFCpg16VPIXsepvxKoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XDuq1u2+wZ7SpCSMYEZXHm+hrIjmVTz3vbPWm01N5B4an/BW2cFsc2HP/e4ReGsjBRDiaXV0tF9MbVVwLdqUM0HgQ8A6T0r0nsnXo5ObYMu5AIIhQa9yEpWuBOunIp46NHe+WXw2LNpX8vbwVKWkHe4uSSVHQPYq158FD0dCf3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=engflow.com; spf=pass smtp.mailfrom=engflow.com; dkim=pass (1024-bit key) header.d=engflow.com header.i=@engflow.com header.b=WJbDVlTq; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=engflow.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=engflow.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=engflow.com header.i=@engflow.com header.b="WJbDVlTq"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-304e4562516so6506861fa.1
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 00:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engflow.com; s=google; t=1737620610; x=1738225410; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AhbhB8IYyQMEdacYv3qHRABRAFCpg16VPIXsepvxKoY=;
        b=WJbDVlTqwu3nRjqcMnebSl6KaRNIAKygp3n822fAyG9R1/27LM47Q44G2hFXEVVn4V
         fXiSC1Gzzqc3Oaaw66yalo1UK0DFIhs9fPvvDUGCu5DhWluTizxwDXO1nzENof+g9F1v
         C1Y2XjXIglUdzANfypuNdt+wYu4BwYrufqb1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737620610; x=1738225410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AhbhB8IYyQMEdacYv3qHRABRAFCpg16VPIXsepvxKoY=;
        b=W2hCprWljLHXfzkUNU4ukvft7HttbPEh2OrK/gg3xd9Tx6RI8qehQF9704xHA8I5Q9
         chRDzqbkWjWXg6t9KAgfQlH6dqHz2bhs2ZW0XtiSQd2ITPp5Twn/xCVPZKAobjO1gw28
         LYffgkd2w+2gYd6DMNL3d1/dcYr2jUTq5vbFa0zC6fX4s55YV66LEc7qc1n5GbC4dmcC
         GqR+YEUb3C/EYZyq7eac6s/0NuRWaWN5TyOS1RyYo6cKgcEMv58qUK1Qe9cfIUmrqeIC
         cjN62ysIj9Ev8kpgs9isGWZ9T5xV2BktdbmPeFbrbl3+18QY7DEg6hzv9+McA45Hr53u
         sQVA==
X-Gm-Message-State: AOJu0YyT6pgZ+JRIiDwgSUT91QOAb3WC+ho7hs93vaERpJxyaLO+Te0K
	3bMp7HWb/k1RAqv4UFtaW7/hA314H6rDIM1b0XIGFX/VwoD4ggBR055oPVK2Bo4weD9p7Xw1DrU
	6J4rgd4WTiRhzmH5i0aO6/IJpcyTEuAu7D2YhzMD/0HjshVdc+Ysaew==
X-Gm-Gg: ASbGnctMh2Fb5jALRBwPk7V7KJ6wv56EiQ4kqyR7C+Mz1eW1aoPMPHO7GuA5omopMXM
	BeD3rB5pNKuabEYjZtItGrWSSCbX6zX0HcxJGxDDxEOa4UMefuQydz17EA50lpEwSxhg/gQIKGv
	kqqEsrbJL+XkiD94Q5Lw==
X-Google-Smtp-Source: AGHT+IGp+yRe7xkSt3/c7z/Ryk6ZTjaiHUdYqN8n0XDF6J4I13s2DJHPAwXoLVRyFRkc6iZGKM2hvqPd+MLWdzBaOYo=
X-Received: by 2002:a2e:930e:0:b0:2ff:5589:5a1a with SMTP id
 38308e7fff4ca-30761bd452cmr6317731fa.6.1737620609889; Thu, 23 Jan 2025
 00:23:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250123081804.550042-1-hanwen@engflow.com>
In-Reply-To: <20250123081804.550042-1-hanwen@engflow.com>
From: Han-Wen Nienhuys <hanwen@engflow.com>
Date: Thu, 23 Jan 2025 09:23:19 +0100
X-Gm-Features: AWEUYZmZafa7ueCVif8Ttj-r-SgmZSE_u5y0RciGbiXWJY24m7lXmkKBsKzmW44
Message-ID: <CAOjC7oPVsf=o7tzNH3MH4qFrJ1ZYTmezKG+jxRrtxCokewc5vg@mail.gmail.com>
Subject: Re: [PATCH] fs: support cross-type copy_file_range in overlayfs.
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Whoops, I should have sent a cover letter.

I thought this could speed a lot of operations in docker/podman.

This is my first time patching the kernel, so please be gentle. I
don't really know what I'm doing, but it seems to work. I tested this
manually using qemu; is there an official test suite where I could add
a test?

--=20
Han-Wen Nienhuys | hanwen@engflow.com | EngFlow GmbH
Fischerweg 51, 82194 Gr=C3=B6benzell, Germany
Amtsgericht M=C3=BCnchen, HRB 255664
Gesch=C3=A4ftsf=C3=BChrer (Managing Director): Ulf Adams
https://www.engflow.com/
