Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0184812F36D
	for <linux-unionfs@vger.kernel.org>; Thu,  7 Mar 2024 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709828030; cv=none; b=i4gWnhllcCDezJ5jvWIJubu+ubpVgqZkuifPqRiuSD6/lxHdfxxQ0RMPOEoHW0ENU+GMrx5gxGgJ8RUaFyKaJuBIMV4NtTSGRNJjwHEvZ7b3mbTP/cveLLQclqgi8l8smCSu7U0vERyXIF9wKGlJZXKbqhwDpLtSGQvlkeDe4+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709828030; c=relaxed/simple;
	bh=i0U24/urDM3ZStm8ZkCHIYCnC1hztYjfNpKOAHUwB5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AujP4D/xv5625zBQRgcwTortKTP+Lsh/LGu2H4vt7ynGR4ULh8BrhXwDuuCB/0sSuIu2tODmSho854gJj8fvVskoQ/Kuu23lptUq1oi/ftP3Y5sVIPk3jg69UvKe5iZkaKasE/HfHgNiN3We0YE3mGusbpGTIJnaGTYF7mAeggA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=HBlENkZv; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="HBlENkZv"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a441d7c6125so122403866b.2
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Mar 2024 08:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1709828027; x=1710432827; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i0U24/urDM3ZStm8ZkCHIYCnC1hztYjfNpKOAHUwB5o=;
        b=HBlENkZvuZMko93KWDs3qXNVESLeeYLQdqfafMaCTE/0a+2/RWu3goeni1mbPHTl1Y
         JubgKNHkqDCJaP9kJMvzpMFg5GMh9Lzb5T8Yep3TAaQHM7zq7iX5Ks4UBr3Ud2Fyr30v
         wTXoGX59BLiDJPklUTL8f19yO4OQL9FjJ6aKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709828027; x=1710432827;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i0U24/urDM3ZStm8ZkCHIYCnC1hztYjfNpKOAHUwB5o=;
        b=FoxQEWHp0yTGytk+Doh5dnVxI9FVjtjYK8Rjv0QAG3lnCMH4Jcfp3Yup/y7s6lwTGG
         kOFXeyhcmolIo2rcqbKAhC1vuLZtBgH4zhfzX5uF65Sp9xE8U/5pB8rayZMium7XkYgk
         hiLItsLHkujIcNoQl1+cP8+HrZU1/yzlcTFg2xZhBkeklnkyHLZFjBKY2IlVSZYBYTfB
         9Fh4suk/TSyCV+BS13IIocw3zCndJe0rIVeniKGgL3Rl/oorYYy2XM1GlJXGdVFyvyMo
         hgtyUNwk9bBS78FW8+zG+jUj7fcs4WVt2cCTfer6VtRVMM5XhDpBcG0GrV/H2lLz/dUA
         QGSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQAwb9u2NSssj62lbE33mYgeSzeWc8DNQqyWkC7Xa8/TFjcY61wyOpuzm39AhqN/H/RThkaiUvwPlQPOjdfzLl/9eZa0ofEd8wE1SlTA==
X-Gm-Message-State: AOJu0YxWxWDXCAOxT5YdfuufvoP748oVUzODrs/CjNLEpve0c4vRqk2C
	emjUV9ptI2wiVP3/XeY7qVObXpzm5Bn2aDEldAACWq23+Ty9SaM1ZjkKnSPJg6xx9l9EqDGQQjg
	08PqEXO8PGd2pbrmP8cAs2uY5LO+ftPOISc223g==
X-Google-Smtp-Source: AGHT+IHk/9+/evK2ilREFWV6zHusdSb+zwWTXNf21peTvmXuM5pPqvESUAKu6ZWeHfE2GiSv/7MakcpK2jorozDiHlo=
X-Received: by 2002:a17:906:2417:b0:a45:ad5d:98ac with SMTP id
 z23-20020a170906241700b00a45ad5d98acmr5201835eja.44.1709828027330; Thu, 07
 Mar 2024 08:13:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307110217.203064-1-mszeredi@redhat.com> <20240307110217.203064-3-mszeredi@redhat.com>
 <CAOQ4uxh9sKB0XyKwzDt74MtaVcBGbZhVJMLZ3fyDTY-TUQo7VA@mail.gmail.com> <CAJfpegsQrwuG7Cm=1WaMChUg_ZtBE9eK-jK1m_69THZEG3JkBQ@mail.gmail.com>
In-Reply-To: <CAJfpegsQrwuG7Cm=1WaMChUg_ZtBE9eK-jK1m_69THZEG3JkBQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 7 Mar 2024 17:13:35 +0100
Message-ID: <CAJfpegv8RyP_FaCWGZPkhQoEV2_WcM0_z5gwb=mVELNcExY5zQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] ovl: only lock readdir for accessing the cache
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 7 Mar 2024 at 15:09, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, 7 Mar 2024 at 14:11, Amir Goldstein <amir73il@gmail.com> wrote:

> > P.S. A guard for ovl_inode_lock() would have been useful in this patch set,
> > but it's up to you if you want to define one and use it.

I like the concept of guards, though documentation and examples are
lacking and the API is not trivial to understand at first sight.

For overlayfs I'd start with ovl_override_creds(), since that is used
much more extensively than ovl_inode_lock().

Thanks,
Miklos
