Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BA1337688;
	Thu, 16 Jul 2026 14:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212583; cv=none; b=M7rZHTWu9uEsjIrTt7qd/0kp33/JwxgLysSV0RedifC6QdcNUw0UegIjzAc+GihgWCR2cT4mOjDcVa+oor9y2mCrP9K+ZNY/ldfXKJJmhLEyAEVCZdoPTT2JkbR3jIr9qPEA8t+cGzdmwliKlO2Gk9ogCYIT5aq/5AmPxCxbLbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212583; c=relaxed/simple;
	bh=AQWEIij24/Lo+Vr2qAl3/gJTSAEKfvKlRYXCa5wUmXg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gat9Na9a2mciTgDj2RJu5YqKqi/yNNQrEd7BDSm2WLPAbIfA6grZR7uuzEgbjjc7GeJtp8T/tXkRP97jhN1Cs6UhjgpC3ab91zJOkJJUjg5emOBhUe13VVsORipmQD+Fp0dKsPqCG3bHwBWLZYE3RtayMr8Z4kvRHxpJoKpVseg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=E8dJX2E+; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="E8dJX2E+"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 9546440E56
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1784212581; bh=AQWEIij24/Lo+Vr2qAl3/gJTSAEKfvKlRYXCa5wUmXg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=E8dJX2E+NHKkxZfVM6RE14TSx8ZiRS1ChFDYZVHfsSd0Yu2KaW0XMcg/zcK3speTl
	 qtXlv6N99P9rTjrPoXJVBAl+N2ntaxZNAqjFo3kUkgnSptE1Z2FCGxOcr3PL/PGocV
	 NvnBznuSkGUdRVK/KgdXjMWk0fCtrLuv3WSuRPATTgJB+tekrKaxN+yNjbZgrTDTVG
	 ZnmlqxTwjQZaVK0bCxfY4X3JPbHMZ87duaGGbcBcjvC13JY1vgyIPseGQ9I6jdMZ/c
	 EAlwpCOf6QXmYJslaYGubjadKIvshljVuOO4viLLbc5byREl94DaTnniZjN3ml5ORY
	 WIvoM5nWZJdkw==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 9546440E56;
	Thu, 16 Jul 2026 14:36:21 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Amir Goldstein <amir73il@gmail.com>, jesse.vangavere@teledyne.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, Shuah Khan
 <skhan@linuxfoundation.org>, linux-unionfs@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] overlayfs.rst: remove mention of workdir needing to
 be empty
In-Reply-To: <CAOQ4uxj66enKg9jK9gZtqTCxLOSHD1i1Yj8b0Fs+jv+SN4UApw@mail.gmail.com>
References: <20260716-overlayfs-rst-update-v2-1-ba25393ea7a3@teledyne.com>
 <CAOQ4uxj66enKg9jK9gZtqTCxLOSHD1i1Yj8b0Fs+jv+SN4UApw@mail.gmail.com>
Date: Thu, 16 Jul 2026 08:36:20 -0600
Message-ID: <8733xj9f2z.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Amir Goldstein <amir73il@gmail.com> writes:

> On Thu, Jul 16, 2026 at 8:23=E2=80=AFAM Jesse Van Gavere via B4 Relay
> <devnull+jesse.vangavere.teledyne.com@kernel.org> wrote:
>>
>> From: Jesse Van Gavere <jesse.vangavere@teledyne.com>
>>
>> This requirement has not been true since v4.8 when automatic cleanup was
>> added in commit eea2fb4851e9 ("ovl: proper cleanup of workdir")
>>
>> Signed-off-by: Jesse Van Gavere <jesse.vangavere@teledyne.com>
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> Jon,
>
> Can you please pick this one?

Will do.

Thanks,

jon
