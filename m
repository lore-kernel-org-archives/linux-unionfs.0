Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDD53D96D
	for <linux-unionfs@vger.kernel.org>; Fri, 18 Oct 2024 07:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729237461; cv=none; b=ltW961cxQGRsP1YILilDtGByJ8AuU0F1PTBh7mhOnAWtVxWO/sCk+8oAP5Xcyo54r53IGZg5RXfWMVbgbL2orggYACDM5yYuQLu/KXi+lIErTsjwSIU3f7EXcmYNAV29s+X03dW8T1Ct1Q9sCzv54YoLhIDS8V/JohD1sVIqZHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729237461; c=relaxed/simple;
	bh=gAYaJkqvsGVJIhJpt6gkmJ9q6zPDeTu54KDIYXdvTDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hsAZ1UIRDFfgDpkXt15VU09jqTSG755ZBlacLs9OlEJvlgQRaCDnKqEOegmdHUP4IH+EoT5X+c94A28Sr+Lig3U6TuLOs5C88TT4MsY/xCbhtWWmXQPOyKvU9DzD/gSYBFVKYG5REEZ3/MzTL8ILQDVg0yPLmaPv1gnt1tQfMrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=g665Ipob; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="g665Ipob"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso228874966b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Oct 2024 00:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1729237455; x=1729842255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9GQQ6Z8pAZHpDQrA+EkcHNsSGUK1cfIY+DynaWtF0A8=;
        b=g665Ipobrl/5Qn1h1qNfLwjE22HGlpZiMBZ2WqTUiRmaDvAhvlxa8MM/qsN2PZXy+Q
         e4uwZfScJGAWljFpe1UO8BNnSj9uGNk2Y+tpenC/Un2QFBtFCTpsKHI8ElrqzGtInzS0
         p9XMC3tOzQU16/blpdNmumBG5Lhs/tjBwDJos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729237455; x=1729842255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9GQQ6Z8pAZHpDQrA+EkcHNsSGUK1cfIY+DynaWtF0A8=;
        b=qIw3mtmodOZWfoB589n6BLZ1n4iFDClLNE5KdEWmPhpEBPh8bYhMUOtCqyduOTqCob
         hXtmxYVCWhP1sqSXTerwflGx/rYUt6yrwsVVBbzROe+A2+Pq/kziqpmKfWuS0Feq9AyY
         1LZ2j9vmDUU2mXkBfWodFFWMJ+BSBq/YrnERNI96yf2pEINP47YABG4snF9JGAUFxkzy
         wY0mkmdYByANnccWYfi5db9tFUOWoANa5zhWKfyC2995spFZXiBqymAYhJPh3d5OHHdy
         swSx0oNtwuLToboGKp3M/T2fvI06WWrlnt4b9ISl/6VCA6qVhMPnxzBM5piO+ejcDgSH
         IohA==
X-Forwarded-Encrypted: i=1; AJvYcCVW83f9rIucTsRMArh7gxiFTxzDJvwH6gML5ayoSy0VuSJQZAh53bPJ+n2ZioeZeauPuCkf0bGOXZFB0cfe@vger.kernel.org
X-Gm-Message-State: AOJu0YzZduzcNDusVYOcTpg2AF2ViH84j+/lS/0BboKQo51bPDXsmMrc
	aS2bw2VLMYGpuIsqAUpoFxRWUTv4OAi1A0A7ZWr1RBfwkxAnFwcVew8HBRYVdkxkbwtukJbVkar
	Zs7WMjX2QR502ikGMbYhDQPVb7U0HfX47VjSHbNz+OMiOVQBn
X-Google-Smtp-Source: AGHT+IFh2AGgdGfKZEdJoJseozKfl6fopR6KDUiqkM4PUV7YZYDzsmi0GbVtNpW15YJEYeJ86x5RvVL/4Bj5yC6Pn6E=
X-Received: by 2002:a17:907:7f8c:b0:a9a:3013:2ea1 with SMTP id
 a640c23a62f3a-a9a697748dfmr107911766b.1.1729237455199; Fri, 18 Oct 2024
 00:44:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241017064923.1585214-1-zhengzucheng@huawei.com>
In-Reply-To: <20241017064923.1585214-1-zhengzucheng@huawei.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Oct 2024 09:44:03 +0200
Message-ID: <CAJfpeguKB2k6jnzNKOdx9390bKwx8TktY7xp-wcy-h7wO08Vpw@mail.gmail.com>
Subject: Re: [PATCH -next] fs: Fix build error
To: Zheng Zucheng <zhengzucheng@huawei.com>
Cc: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Oct 2024 at 08:50, Zheng Zucheng <zhengzucheng@huawei.com> wrote=
:
>
> The following build error report:
> fs/overlayfs/file.c: In function =E2=80=98ovl_file_end_write=E2=80=99:
> fs/overlayfs/file.c:292:51: error: parameter name omitted
>   292 | static void ovl_file_end_write(struct file *file, loff_t, ssize_t=
)
>       |                                                   ^~~~~~
> fs/overlayfs/file.c:292:59: error: parameter name omitted
>   292 | static void ovl_file_end_write(struct file *file, loff_t, ssize_t=
)
>                                                                   ^~~~~~~
>
> Fixes: 291f180e5929 ("fs: pass offset and result to backing_file end_writ=
e() callback")
> Signed-off-by: Zheng Zucheng <zhengzucheng@huawei.com>

Thanks for the patch.   The fix is already folded into the original
patch in fuse.git/for-next.

Miklos
