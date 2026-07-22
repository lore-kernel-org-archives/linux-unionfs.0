Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F75D34F498
	for <linux-unionfs@vger.kernel.org>; Wed, 22 Jul 2026 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737777; cv=pass; b=oifGJ4G3wJMkypGqIHLzBo2OmMDC+MExAMpRKf+4QL0Ye72l55JufGHU6fvnxtsyyfu+e29A0E+2k7YIICRQZIIl/ZEn7TGoE6ueu6siNDiYp4X3D0e62ldxr2KPPXSF1HVMjTFScr6d/CH2+/PDzrTSm90I2xgK556jgZhhIAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737777; c=relaxed/simple;
	bh=U+1oSlhoto9RzC80eRCQEK7mIW4plZHyLlmXaf+c5ZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KQcMGy4BUvYY3+I2Y7VzXSuJQcX0WaYPw5gLAE19NnxlDjCDhLCTH8BHd7o0doCffrp8NHQQ+wzz+zZNUuR77IZ+JvJSh/z8XmijiUH+H+VkE4VLTaL6Ck++Uq6xux014NNwbyAiBZGSgbe4FHa2BNn2AYE6CRBE214ETVs/764=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=CGqtQ8Ar; arc=pass smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="CGqtQ8Ar"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b2a44a3b66so2646154e87.1
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Jul 2026 09:29:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784737774; cv=none;
        d=google.com; s=arc-20260327;
        b=kX/x0s9zcow7mwbtPtaLV2iousnTfH9lw1jf0KnOuc95rVw7MkVmU0rFhxkzLnKlN8
         ye7N3Uf8oyp7EVo7QEkHQ6mlT8AQD/iZykLJ3L5s0TxsvhBP2BwYPqvaLWzFwWn6XnSj
         Z5zKkC9X8tV/Mo+MBcoCQgbrBRIvchs9m4h0uqK+3V4vblG+KFZ41avP9bD7AKce5lXE
         3aPTKlWYhXA+MU3nhOoPAUc1SxSk7V2GF8JhmCHyN7bH44O/2rEp3NnvZGf/N5STq2NZ
         oE3D43wMV4US2o4FPYo9AnAb16B33VF+HQZZ4HjmoVPcBXFLqR527G5eKermn9Puonj1
         T30Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=InkY2TqArSmQXaSwMOCoeFzsMAyO72A+PE6OTrxgjrQ=;
        fh=/kCIVio9XmY51wF2kGUqpyuMLqACEqW/vwd0YoQYvF4=;
        b=eL4slJcUKTN+w0JtmGoQHySpZez+852b0NvL1dSoFgoNR1eEfEQmM9IQLRSwAe9mfu
         Wy7NLJKugSZCCkeHSv+BE26HlNqwG6TgYo+embuOa3ZAalVoBjkFVo2QBAToQoM5aI4k
         DhUAWNziznXq+1F5kstUdOF1I+HejYNlwnuOhvLLYi+P435zErNYiscO64B5gxV8OzEK
         Th4lw9oSO8Yf0lCdAcW4kkPdkRRjMf2fm0z2IZtzjaZrp8nRy3CTo1DV7TryB6Nt5D0L
         lEvjLYggSRhFY29K8iD247t/bv79Cy6WESmRjB31UerFskQoUnJj8NfjNKj9UEQk95HU
         AOHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784737774; x=1785342574; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=InkY2TqArSmQXaSwMOCoeFzsMAyO72A+PE6OTrxgjrQ=;
        b=CGqtQ8Ar9zATM56qjLFdcqHMiqXEoB/rmSEZ7gVqOvBXFlL9pqCFP1YfXO4bJXVCKH
         h1t04PL3WCBYh11ZgmBZo7o98zYRUFiU5RsOhFysRGQ6iJIRjAdtEhrCb9pc7F0SVPwu
         iJAGNc9Cr1Avds7+BUX2dhUQkUGpWuR3auL+Bp4o2L0ReFhEO3BAEna2eJ4MM7pubBjK
         CNOGlOkWmm+Q+BTWYPNu8VwJnS/SkJCsWfXEcRB8q1tavuBqCDhFz34/W9ndHTe/kgql
         5MLp/y803L8iPsCXtq01aLZPPox/RU6/V0x0OtAXvvKCnYHnfc35oeKks/YVI5ebUqPP
         5Hog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784737774; x=1785342574;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=InkY2TqArSmQXaSwMOCoeFzsMAyO72A+PE6OTrxgjrQ=;
        b=atW9KVpt0r1ZuxqS6lu9GD034QrRCfn3cYSo1yJN77wtJ/wz/EaLqFMsGq4Kiar9mS
         uYFViNm3E+Fv1mm33MyT8ZOEpUbYlv49B2Rc9YbntidLYX0RqTZAGb1o+PAAC7gTrLIc
         +rPwANKkufLsap5HCnZJ9/0QrLXfU0v5wfR70HhRAHBgC6mwiwGYbYEIGpWrYqAL1ZRS
         IPM727Y4dJjNaIH21SLUBqOr7c6fiJ+wZyhlBZ5Tic0XXs13UvtypN1ds4idYEwbSGsX
         sngOyw3kvrBum0HPNwqXJVsQDkH+JsBTW+5K2ZW/1EYcPHL0TEtB4v7P/siYGseh8C8d
         /hRA==
X-Forwarded-Encrypted: i=1; AHgh+RqW907olhzwO7gNbRej291HrBoblJzJpuFOMGmuGevoOiEgOjsgvEXJJs7mZSRyw2G5JyJSs4xlbVG1mLx6@vger.kernel.org
X-Gm-Message-State: AOJu0Yy35GAURXcnTycOJW/AQHSRqed3VSzky30GAHakGwxuqyD+WXum
	R2SGXqI6x+eGZ34xjx3j76QJ3lbcYMW+LR9lzcQFotr8VLztUDG3AsSRr1wACemkMBhkcs9fweS
	HJt1aJC3lr7GEIA7n7OhrQ22RaDJ3DbMyj5Pd2n6C
X-Gm-Gg: AR+sD100fnvaIChpvWhRdG8YeHFE+LJzTj7+i+ZFwSxSvoYAV3pmECw8IDLMVkYJa0s
	QpcYcl4LWqlaeslss1FFratJ4bfxuOv2yDV7nTgQo/7euJY+CWepvcGnaElm6uLOcHZg1Ki/MpN
	k3UewGqQRJxBIQjoIO3WKmKz602KVTW+ccLl+hXiKrAuty9EdSJKSR8I/F7FU1nriwK6MYzicJy
	s2spk5JAYwWkGmRqtmvBNHFZQEq99sCE2MvDPMA0ODSRGCKv/6TxRPB31AJyw==
X-Received: by 2002:a05:6512:1328:b0:5b0:eda:de2a with SMTP id
 2adb3069b0e04-5b28f998d04mr4374814e87.35.1784737774129; Wed, 22 Jul 2026
 09:29:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
In-Reply-To: <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 22 Jul 2026 09:29:22 -0700
X-Gm-Features: AUfX_mwycQYWu9rMPFRhnxWdDLtR5J98EpUP47SKtC-4N4S0g7pVJ9n5XWZrccs
Message-ID: <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 9:06=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:

> Like I said before: I'm fine with an API where we can use open_tree() to
> see through into underlying layers, and given the right permission pull
> a mount out of it. That is a narrow, checkable primitive and it needs
> none of this. No new open flag, no second ->show_options, no metafs, no
> mnt_devname surgery. That part we can potentially do.

What, exactly, do you mean as the distinction between "[seeing]
through into underlying layers" and "[pulling] a mount out of it".  I
have a guess, but I'm not convinced that my guess is right.


Other than that question, I think I generally agree with you.  The
interesting operations here (getting an fd to something that was
previously inaccessible) are different enough from normal path lookups
that I think they deserve to be explicit syscalls or syscall modes,
not magic links.

--Andy
