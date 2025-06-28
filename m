Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E6A13B5AE;
	Sat, 28 Jun 2025 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751121813; cv=none; b=FYovGvOd39t87WJoXPvfI8TmVZs4HUQlQdrofYIWi6oT2NZ8OwH2bHjhilGRQhJ1InUtZmT+R9yb18kraIRi0U4jfeeRY+BtEPCxqDw8Cj+fV0peVbW34cP498GrrLbwK6IDR+86N2LOPfGOMGjej3ScpvZY6/ayLDXHN0lqino=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751121813; c=relaxed/simple;
	bh=dQ47HoRLF+6X8CtMhDXpv9EgI5dxjY7My+7toAcFBco=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aSciOvP9nKp2ss8R26Tb7Hak3f9wW/1TCRQOCh2GNv+PGqrikOsXGn1JV1wPnDuWI9gQwSEI7+3N13Y8qIoks//VcR/6dtr3I2QdDibz0JzAYDxfcEwiNDKA7bAtfKXkIVf1F+C30iBfZFNndkBjF3eb2segtropVJo+IRHdVko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=AU4cLhih; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="AU4cLhih"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B2515406FF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1751121810; bh=dQ47HoRLF+6X8CtMhDXpv9EgI5dxjY7My+7toAcFBco=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=AU4cLhihukfdLdYDKOTPOcIro/emdB8IFmnCzoD2tIIFYjY9HcPwVtQzZCQDIZhWN
	 ibzkYuMc0R3uGaOIAUor3EWSWjhVIP+9L/gyEDdSw5ODcRC/eX+SOSeJalmp96S96s
	 0tIFeVWyF4iMKdEntTvS0oXCaeaABO1YOSZcpDr7/Y+OtS96wk+iDk2YKNLleFklGR
	 +OUh/kzsBkk3Ue/4L5fOPBmJWUDA+B18Y4wZkcqtAroE92KQwDen4rtpq6aejmUt0o
	 IZo98Nxgs3t/6tI4gUU28CTJ/4CBXcZB61e9IiHJhXsX6IRCZFqQhXN9yN9o9owkI+
	 uWL3wkWZLpDVg==
Received: from localhost (c-73-14-55-248.hsd1.co.comcast.net [73.14.55.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id B2515406FF;
	Sat, 28 Jun 2025 14:43:30 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Amir Goldstein <amir73il@gmail.com>, Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Subject: Re: [PATCH] overlayfs.rst: Fix inode table
In-Reply-To: <CAOQ4uxg=CUmr+6EBPG0MSwDezx3jTxtWaGVLazA3krp7PUU13w@mail.gmail.com>
References: <20250628083205.1066472-1-richard@nod.at>
 <CAOQ4uxg=CUmr+6EBPG0MSwDezx3jTxtWaGVLazA3krp7PUU13w@mail.gmail.com>
Date: Sat, 28 Jun 2025 08:43:29 -0600
Message-ID: <87bjq8exke.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Amir Goldstein <amir73il@gmail.com> writes:

> On Sat, Jun 28, 2025 at 10:32=E2=80=AFAM Richard Weinberger <richard@nod.=
at> wrote:
>>
>> The HTML output seems to be correct, but when reading the raw rst file
>> it's annoying.
>> So use "|" for table the border.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
> Acked-by: Amir Goldstein <amir73il@gmail.com>
>
> John,
>
> Would you mind picking this patch to your tree?

Will do.

Thanks,

jon
