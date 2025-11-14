Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC002DCBF8
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 08:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763110524; cv=none; b=fzhmgzQJxKH76hU3UzENTnv09kJPlu1ejFwGgic4Qib+MEi5ie6iO5nvDymZ21AB1jwU88rvmlsqFZQ9091B+o/H9gdWhC42+y7poe3irQ5uRPtv4vBD1clu7uesm4rhiw0VTWOgvKbM2Ii+5Owia5nufqQMnZC1H9FDRXY9emU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763110524; c=relaxed/simple;
	bh=7QWyEaWPUG/dP82AsIRFxyl4HGCEfS7+WMTPWWej19w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EfC0fnfWAV7kwanz8X8Ud9lhpRAFOpHAnWkYJMp14giZpQZJ5ccxU1D0G05G2fYs3F+HfXg8pGVrOBKUDzm0xPJO6dfewbl5HXOmSKNPcGNiqTfDYaNy912KmJ23HQnTmTuvXjCIVHGFFZ3hZDKQlWITVCneROiDfoc/TAZOWXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=lvqgDMe+; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="lvqgDMe+"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8824ce98111so21646466d6.0
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 00:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1763110522; x=1763715322; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7QWyEaWPUG/dP82AsIRFxyl4HGCEfS7+WMTPWWej19w=;
        b=lvqgDMe+4ALyHXRYirCDOIiThCH5UKgjsiAgqVVIPcc52CVLOfJD79ppT2YVrdp9Yo
         24RTWShWi8X6F8RIyzI68XVljErIEKgSlwzv0VKSFOo8FpHSauqv6EzWLaI0YjDb7KPh
         cJk1LR7T/3C0qR/MVRoSBVQIERzQXTY4IwSkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763110522; x=1763715322;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7QWyEaWPUG/dP82AsIRFxyl4HGCEfS7+WMTPWWej19w=;
        b=ixUNYstVPba2TMQkKJUv2ZuIxG0+2GfzN14COvA6VFT7rtD8bIPm3vhvH1OUDe0ITa
         AGhABiflZhMFhVaTL09Tpr9uRzajNbloAoyRPX06OIOD+a+MNgTuDlEjUr58UANT3Co0
         k0sZwPJ86WxNaKgelkCkVnD0pUH2kzihprpqNgpgqQNp/M0vh5NNssdVnuMDk6e8mOeQ
         GG7FkrSbL4BcYzBQrXqzfA44UD1FNOJ/IzKb/taaioHD8ai7yHNjMC1bAXlYl0pDfyeZ
         DjXBKOc/FbxX039fRRwQDLf7kX9yt9iM9/jj/pW1nVxc9NsopKULrddJmvNMXxFu15dk
         XT9g==
X-Forwarded-Encrypted: i=1; AJvYcCXyZMgNM9aFWwvldGT2hXI18C7eCM1eEkgzyDC1Eu8nKL5SSu1mXekbLsZYCq0QFK+k0E+jTh+hLMYcSETB@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu5ICBb8idgIyINIXQqlsAXYKjgh6h5OlOC34nZ1VcG0OSL94b
	Tu6XfOH4a19K5mKfrIbjZB5hRWPRl/uAaO+CXLXDcr4Ejnd5fZQkIHj9KcMRCum+QHipj1efh6y
	oOjLAigT6CLcAaJw80x7o/yYMa36mwdXwz+diKxmHoA==
X-Gm-Gg: ASbGncuzXFFfQTNOC8VXyS1LxVoTMPWWYBPaMTSsvwJoiF7AnpSOXh3JOrxLc5nWbEq
	eZstG7aXW3T1szKXlScpt3NlnxsmLXiTLKw2XPK9tReQzC2EdjmIROh0DDmU/lXjVeKrfLiQMgw
	VUAX2A9TZaQgVbVrhweuVX4lKb9oNeI/AqJZlF/P1LztpdmeAGCythK1FOpvNcbWFRM0AUVDXJC
	F/FGLQevEbuIddArH091um9/DxTrI8FzidmS7b41YLtZsyH8M1NrPTsUfOeKlN/AacSkiJesfT5
	NRNG90lGR6NV4xUVLg==
X-Google-Smtp-Source: AGHT+IHFOnYN8Yb+30eRqq4OIG/XqDhxG47QkCyDhPhoPo+n9+yo2rSsEgKlid6IjLr5km5pwKQxSfx3pTNFESrelRw=
X-Received: by 2002:ad4:5bab:0:b0:882:3759:9155 with SMTP id
 6a1803df08f44-882925b3364mr27129646d6.21.1763110522067; Fri, 14 Nov 2025
 00:55:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org>
 <20251113-work-ovl-cred-guard-v3-3-b35ec983efc1@kernel.org>
 <CAJfpegtLkj_+W_rZxoMQ3zO_ZYrcKstWHPaRd6BmD4j80+SCdA@mail.gmail.com> <20251114-tyrannisieren-esstisch-9a596bcdeb7c@brauner>
In-Reply-To: <20251114-tyrannisieren-esstisch-9a596bcdeb7c@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Nov 2025 09:55:10 +0100
X-Gm-Features: AWmQ_bmR62PzN-GIUHUeulqHbWxi5iB-_xxM8bQk7cBq0kWzSZBAuSsjjpdtUqw
Message-ID: <CAJfpeguuzPB0O2suV4F_KDCMY3n8n27ct1gT27fepmG5-GDu8Q@mail.gmail.com>
Subject: Re: [PATCH v3 03/42] ovl: port ovl_create_or_link() to cred guard
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Nov 2025 at 09:53, Christian Brauner <brauner@kernel.org> wrote:

> The function doesn't but the cleanup macro (as is customary) does:
> DEFINE_FREE(put_cred, struct cred *, if (!IS_ERR_OR_NULL(_T)) put_cred(_T))

Ah, missed that.

Thanks,
Miklos
