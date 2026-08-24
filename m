Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F419126A1A4
	for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 12:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787575999; cv=pass; b=mRZrJ5lnA6GyDcHf0uYh5j/HA2tNnMvjOVSC34InMYQWe+vIYLvnyv2XAxbhW1NIUQnaI9JxRLHXgoUmldLHoKUAaFdFX0lelYM5W0y/n1YyCUHSYMgaF4NeG+oqy4Vmlmba4nFNkwWPUIeln+afQtpj9BLdOJvUJ6Dqi9nhISE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787575999; c=relaxed/simple;
	bh=LZFjpb9lXURhzbS/CoAdgyKyJvfoaiCSYSWBisfzp0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fp+evSVbxMTNFt/7RrXYEx80KDe7zwjVAHIWd0cBxhVBsrEq3RssEYl6X+6uosYeISI+x3zszmLbEMokgDTjGKytsUbtOJt/2X9Q4cJRUfuYAKnSLUnVVt7cux2CQXubrdN+7ah4dkN3O3+J3sESXCHSCtG9+PHmAUV3sj3xgos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=WdELMEMT; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="WdELMEMT"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c0ecfaee7so22318721cf.0
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 05:53:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787575997; cv=none;
        d=google.com; s=arc-20260327;
        b=lUwMcZzqL2AE++pK4YEVEAJcUmc++USUPaknvyG5Atm6iHWBJ6qDcqwFpoErxG91OT
         R5p/yN6v+OIg9q2Ws+0Qrs+qa+vcn0QleH7MAWCmbFLIdBOjQSO/ifaZCutVq6Ngmndp
         f+NLd4BMQ+D5AV6RdAYQSCTs6yzKuS6S94/XDn8W43ZAkW32QpfHSQL6QZFMBW7Hcr8C
         duGKrxo77TEhXq3/UObfKBs21Kn53lFSjHVGg+fDvsMIUgVeKx4CGl15Uummd/jIjhyo
         yexWE6yf141WbLZ8MZQvYXeCG5bMGLJBXJ1j5jxp1SjcThJLfWoz5AaV+lt4wvhYSotl
         VLCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0IX1RRllwYXbu1MmF/rjjTVoWXY5K0/uFpmcxvfdldE=;
        fh=Xf0fS9QdWgQnu7pUmW7hUDKS9IwN3jzsIoVz0cwI9VU=;
        b=mzMUh0qIZTakQaHSDt0RoL+ZHgpVgLAZjZ5Ymt2cgww50hflx/Wfd9HlTVoCGfmmn2
         tbF6Vnq6/xmQbSLT8pojUm5hKD6DN5RQCrJBCtX3yaz60Yf8Nim2IaRFNLLwPyYLWBVg
         eyay5BJWT/h3mpUJxHZyIA2lMCr4qqJObdg6sbIFtLRdPRdH2xeu3TrhFwx1lVeldM67
         jG30usud2yXh54h3lXcE/Yp6XsS19U+8bMM5BUONb+5fYYW1PKYC/3/Swou0unKWnPkV
         ED1EuNc5+BtmIYudhnzkC6E+TP0H/xcGygHbITfIYE6EZbdFW28sNiTGuRG17bsaFbmR
         N5FA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787575997; x=1788180797; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0IX1RRllwYXbu1MmF/rjjTVoWXY5K0/uFpmcxvfdldE=;
        b=WdELMEMTM+Foq6M51D7qBB4RWbI/QF9aYjMqceLDKUpFJxdRzZPTCLe38NXymwTN8C
         QQWbrQGErWPWZj+vP7KVrHarIn7foHFmUtwEGyccxaTL1vqvcrJm6/xBA0S6w+o71RWh
         61QKTv4KpAATflwGrx8H2tLlt0w0fzm3ru4IQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787575997; x=1788180797;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0IX1RRllwYXbu1MmF/rjjTVoWXY5K0/uFpmcxvfdldE=;
        b=aU+cqH2WPoKvRVUfFKsRSGlDDUT36JbCUmm2xqDd1miR7LzUwgKBe+rX9+HOs30mhy
         Wer/fpNoQ2j03C6lF+JHxWKWkpXx0yCqHTozbbTKOnwvBBm+M55xhCBfZAvBG+3+XFnd
         dTREETMCOLXyv3ah5MtGsGb4h0OvE+p1p4Io/rJX5ejgNNLnNkP7aJIVH6VHGhJXIYzg
         TXBJq5WfT7lIF1sac5WUO0f0oSuWO8W3KMwuGSyC/n7k4eTQIDenRSGr800y5pP5/435
         3FUjrKhfLcOF6G2sPi3ywE+gYZIMSR9wnOlsU7fhwezDu1KtZVTtHinIoXIokIty3FQX
         35Mw==
X-Forwarded-Encrypted: i=1; AHgh+Rp7HAO/ibYQZb6ewkSIkUE6FmRE4aTGlRSZPp6BisF0bT4hU29x7YNSQrFr0awS5OQOw6CYFCKYDWJeOy+j@vger.kernel.org
X-Gm-Message-State: AFuF++niAOXfEaaw50n24WZKiJUAromLNxCPQcsE8GFtBhSoF/nXLrlN
	L2DGMtwoiNv3yF6r3gnyLtvcJlN6GNqjxpTl0x2J1SL6pHWlZS1/9FQ0qLeTrg1zQjK0x3ymGzE
	IlFzSJZfgdSibNLKgy7F4zY4YuKKrBBbYMoaQulrqXw==
X-Gm-Gg: AR+sD11S0SwPO4nOFa/3ZYQ9B6Wu7jyBBF6mEwv7P56qisO3GUBJfuPYxoOK4YNwCFL
	A8l/wVNpbbOAG+w2mFb+hWHCYQIw2Ut9uKQvJbNF94r2aJvkBCyoZPLki1PKDQD1lfOLhptq3GI
	Ikm8JAdDpj939OiusU/MJIGk/qwQN4I3A1hR6CWpDj9S9OyrZUdPe8etfsTtND1HDo6qoK/EWSx
	56vfoj/BgihtmOK2YFWqiWAXksVzoLlrAxnEB2nGV12knagl+TY0LeOhEiWVJZ2vBMcyBfU9UBw
	qP+J2PlfoHU62EbkFAAcrYsF8pP8DxgTZPjBficsZrRd4cZFy1OgG/oFk0K9LHuSOfTr/aSOrGR
	LSLuJR6mIC9AKrwLffHxsfEv0Vg==
X-Received: by 2002:a05:622a:514e:b0:516:d781:589a with SMTP id
 d75a77b69052e-52e09c6fe74mr192671201cf.22.1787575996851; Mon, 24 Aug 2026
 05:53:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2026082150-autograph-perky-e3cb@gregkh> <20260823224256.2724025-1-fahad@codepure.com>
 <CAOQ4uxjhfpNVvoVrTayj46H2CViTOc3oxzM6xdb8+E7ikE2CSA@mail.gmail.com>
 <CAJfpegt1WinKmP5nOGv8Yx9VLf4Mk1ojg7e3xR5iUz=7yDAh0Q@mail.gmail.com>
 <CAOQ4uxj+GRa8CaCONwPQzLCjx=R8MRr6PTYYC+QW7VrK0PEhMQ@mail.gmail.com>
 <CAJfpegsVoUyqy0dYkTvBGRZvgdv_nmzmCw_uF+LP-Vq3EhEkSg@mail.gmail.com> <CAOQ4uxhX_neohTAjZDOT0oSWC-JNiqNWqnfE5YSa7Ln05QPQ-A@mail.gmail.com>
In-Reply-To: <CAOQ4uxhX_neohTAjZDOT0oSWC-JNiqNWqnfE5YSa7Ln05QPQ-A@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2026 14:53:05 +0200
X-Gm-Features: AcwNN1WHBei9qmI1SLzVZk7vatFLte10goznOMhdg7Wfikdfth6HYnN4vftGbC0
Message-ID: <CAJfpegut15YWZyS5zJ9-WmG0+fVPgRJp+c0aoGQv-0KM8iYj=Q@mail.gmail.com>
Subject: Re: ovl_copy_xattr() can write uninitialised heap into the upper
 file's xattr
To: Amir Goldstein <amir73il@gmail.com>
Cc: Fahad Alharbi <fahad@codepure.com>, security@kernel.org, 
	overlayfs <linux-unionfs@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Aug 2026 at 14:46, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Aug 24, 2026 at 11:49=E2=80=AFAM Miklos Szeredi <miklos@szeredi.h=
u> wrote:
> >
> > On Mon, 24 Aug 2026 at 11:30, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> > > It's not really a retry loop, it is an opportunistic buffer auto grow
> > > loop, see
> > > e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
> >
> > Ah, okay.
> >
> > The logic is too complicated, though.
> >
> > I'd still go with a separate helper  that gets passed (..., void
> > **bufp, size_t *bufsizep). Single caller of ovl_getxattr_value() can
> > also be converted to that.
>
> OK. something like this?

Perfect, thanks.

Miklos
