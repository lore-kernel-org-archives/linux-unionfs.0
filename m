Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB8321772A
	for <linux-unionfs@vger.kernel.org>; Mon,  5 May 2025 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746446728; cv=none; b=qsL1Hmn8BOQXWSqtr19ylIutYKtS5oxHeutIasKdBEIYeV/6dfM35mm3Wr9Bri3q81xXlCeYPcROGibK/xs+wAz+dW6H6/BfmEIDAlH5ENFdASqI+NVokwW58G5rNyOWS1+QVmvjkVzVub/12zUJGEPDtA+cegsoWPvq0eoCmqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746446728; c=relaxed/simple;
	bh=MSmFqzFcT96hsMGWWU/+4kI2d4kvC5FO4xXgyupJZRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VYfICkCQbIzQ8PvByzEzKSlMsWh5NsSSxO/PvRuM2F9rIwakLwPfx4hyDOe1JMP/lAwapZG4FlZr9OXrCGr1Q4CErdAw5P4WI3xcVfZkdFwvuJuB3yuXd6TZ7lAOhFdy2hO3qxH2SxrKqL6XxHC/JJUqinLY2GVT4BZjXFSjYm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=m/DwMp7M; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="m/DwMp7M"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4811fca8658so53208851cf.3
        for <linux-unionfs@vger.kernel.org>; Mon, 05 May 2025 05:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1746446724; x=1747051524; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MSmFqzFcT96hsMGWWU/+4kI2d4kvC5FO4xXgyupJZRA=;
        b=m/DwMp7MQeBJVvBMVghMcYf7mBXeDRBodW7o8Csv7KDw6Etjq5GHOez1mnW8IxLTzE
         EuNbmuaYpaY3CXmVFD2RDcTf0+D6oIPigjbb12JJddTYDS/oFTgSGaAJld41qJkyuGQK
         Cc17+q2zrmVXN0JvY+MsrtQlwMdbb5kaL0yP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746446724; x=1747051524;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MSmFqzFcT96hsMGWWU/+4kI2d4kvC5FO4xXgyupJZRA=;
        b=FtgEijKJvjpb2CHT7LwOduYBknEGzGk+YOk6OxsCq01jn2wSIizhufXh5cwrMLm37z
         Uyoa9s6Q6cmZ+BaCcLKOzdVyVj4z77n2E3iFCAd1IOBFZcBj4S5XBiUWeVs/ZhH++ygw
         GjYGp2zqj8JMdeGFehAniE+pneJI2lJ8IzNvvA32tXMY6ixhFvtjanJaFCV6xfMgqjmX
         o715fxYuBQevg+OoC0rn4DJ/ewpcHEwFl/xqToLdQXkZNamunRJPcXIigS7aROHRo9Mz
         z4yk/mr2bsisTeP9xn2oIa94O9G00IyF37Zy0HVzQt9T8Ua1eVPiuUv8g1psKaR1Dp2A
         fQuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUF1yyBCubX+SVZdHO7gcuCPlPIJqH1/ixlHElBk1SYvQ+H0EIYO07rLEF8UjTSaoj40uvbjuHvlTdsicAT@vger.kernel.org
X-Gm-Message-State: AOJu0YyGnomCEtqOYBMu/i/WnTHBt1IHdzZW5OfSccepLp3mIqYinrWw
	/amUjMdtbIHo9eJzDUzqSDH1GRZDuMpnzk0F5hRXWByDh/qffmeD2yGGfyR3i/soLVyvNP143GI
	mqbhy/xRrRb4OZE3aBm7bc0Kzwmg3ylL85kzyfA==
X-Gm-Gg: ASbGnct4JDJBGFJqk5D7ZkSq7ZC6Fjs+6KaoP0V7E+QVNatV/MLDDdKXGO7kOUsfTyj
	f5l+Oz4+gnlHPDwzqPWvS5KcX56Itq2/lqWCGNIIlYI481Hpvldw73unUaFBeSWfX0iB/THV4MY
	XZX6G3NKtPwCYk/r3to49Lh2mF07SipcgvzQ==
X-Google-Smtp-Source: AGHT+IEiXnbdzV3BWwZ5IPUbUHubnoQaoHBY5S71LTjH+YEkNGnRrCKP8XO7R8Sf3Kz0X2/HrOGmLWiEOeiS3HMJDAU=
X-Received: by 2002:ac8:584a:0:b0:476:ac03:3c2a with SMTP id
 d75a77b69052e-48d5d954187mr120305351cf.43.1746446724283; Mon, 05 May 2025
 05:05:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250503115202.342582-2-thorsten.blum@linux.dev>
In-Reply-To: <20250503115202.342582-2-thorsten.blum@linux.dev>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 5 May 2025 14:05:12 +0200
X-Gm-Features: ATxdqUE1WWGK6G84AJhRV9PFwu5vZGrOC5PYN7D35zd1oYWKXW2d-jpEXjo97Sc
Message-ID: <CAJfpegvY9SznVvsos1a7zk__FNbhtmhPWt-7uSXegF_DxT_dDw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: Replace offsetof() with struct_size() in ovl_cache_entry_new()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 3 May 2025 at 13:52, Thorsten Blum <thorsten.blum@linux.dev> wrote:
>
> Compared to offsetof(), struct_size() provides additional compile-time
> checks for structs with flexible arrays (e.g., __must_be_array()).
>
> No functional changes intended.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Applied, thanks.

Miklos
