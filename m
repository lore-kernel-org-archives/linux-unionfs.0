Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5D71885AA;
	Thu,  9 Jan 2025 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736448740; cv=none; b=dUPuosbM4sRgzyBArmQuwTawvVLasINBCOuhx2N9QnZt+37eN23YFJffUuyZ16vsPzYgxQ7iVspi8sWIqgyVgJlqzbKFPyz1S0UpaJfeukKWgfhySNioDICdo8tiHT1ZuhyYi7Sr6BcOZRozggH/w1p7thSUYOfPHEIvTr6Ctqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736448740; c=relaxed/simple;
	bh=4VbnyxJPsvFJI9ioTp6YjulEmqkNmoKsW35wonu5C7M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SMLjWaiz2/LWg9NmtO2W/rSTWiFvjl3NwaAH5rHdWALAdVXUAm+PPL5wgLQ/dAGFQppcB2AyHYDqgydsLhf00loZvitab/E3+GWBUI9L7aKGUbsLAeXrRpcYyEEX3EEMCxK3d3VW42YPX88ZDYmSdfoMoQJlBWcu3N/AWif9bNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=s1Bdlq9N; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="s1Bdlq9N"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net CECF2404F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1736448736; bh=1arKNjpAeSPG67yGlAsno8ZO0XDLiTIQrl9AnZR+pi4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=s1Bdlq9N5X2xSpbJg5DdzrH5AIDaQ6FreHLyWJ7SXaRLe1JUXzDcmineEP6PcFvWJ
	 8iymXa+MDiM/YFI4gMhziL2QRYf/tu43+6KEnjrNzUfrmW1IEmxxwd880lfqCsBP5D
	 Dj4m1KNwi+Sc1wXnXf2MyjcWPauaMV9KCsrMae1+uUEN2MGeki+bOlCfLSXW3Sx8nt
	 5FmQ34qfs06ldx/yZ+DVKYaDgtdjs3Rt1acKbcQ+qO2c65/EbD9JdTAOvKiX94FIHN
	 YHQYKwXTUlS+83yTkHw9u2Xmt2zv6Jul3rocpuv2cziJfAFRnPwtGaGBQ/DQOburaA
	 fHoqUCpH8QFmg==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id CECF2404F0;
	Thu,  9 Jan 2025 18:52:15 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Amir Goldstein <amir73il@gmail.com>, Geert Uytterhoeven
 <geert+renesas@glider.be>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] overlayfs.rst: Fix and improve grammar
In-Reply-To: <CAOQ4uxjESOJsb2GDx-c==_cLtF=wqtDAprcDmjwiq25hyzQFwA@mail.gmail.com>
References: <cf07f705d63f04ebf7ba4ecafdc9ab6f63960e3d.1736239148.git.geert+renesas@glider.be>
 <CAOQ4uxjESOJsb2GDx-c==_cLtF=wqtDAprcDmjwiq25hyzQFwA@mail.gmail.com>
Date: Thu, 09 Jan 2025 11:52:14 -0700
Message-ID: <87tta7lt0h.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Amir Goldstein <amir73il@gmail.com> writes:

> On Tue, Jan 7, 2025 at 9:45=E2=80=AFAM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
>>
>>   - Correct "in a way the" to "in a way that",
>>   - Add a comma to improve readability.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Acked-by: Amir Goldstein <amir73il@gmail.com>
>
> John,
>
> Please take this patch via the documentation tree,
> as I have no overlayfs patches queued for v6.14.

OK, applied, thanks.

jon
