Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E712B672;
	Tue, 15 Jul 2025 19:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752609369; cv=none; b=BXTWXx9xXwG7P0+laXpgXwS7pH8P5ogTyEI+m4EIx+7iDEVvFIcrEmB55CHEF3rdvOqR4Zp+Bkpvzao9niouflSPHmMPAwqK/AmUMzTrCKKdtLWEpSOSemvzIgYb/RczsCUZR7xoZVhXxxOmZkM3ZUbROGJdYa+FPwD2yFWHAb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752609369; c=relaxed/simple;
	bh=+DV65RaR/WOE0wdNHoxnOcGlMqc1eC9PhAek4flM/yw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cl4Y7Yq+1CFTwlE4WBPGNYySUhQOqXXvwxXyWEV/QNAgqBUCTiTeCgK7WNi62c2naLiRhEDhdHnZpyX2jbefMB9FRz/SShwfphRHkdBjdzt+L0/5BAA+Src5dvJzPyorWv+DklPmnWiP1Jjv480Saa4iOGbYV4ov6ZLqsGG1SR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=lQLbfZmz; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="lQLbfZmz"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net C15A34040B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1752609366; bh=+DV65RaR/WOE0wdNHoxnOcGlMqc1eC9PhAek4flM/yw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=lQLbfZmzAkecYZs3sHU8dR7tfMTK0caXL/g+e1VUzV4np+RqZ1S/el7367btY0dwG
	 aiM5djHyKkSygwj147il00Rxt/aaF7oLXz7onw4457JPokoV6cGV2/N5AuAGd1sCrD
	 AkgwKkpBHr9BUme/kxgF6+M77uZLzz8rkBW1BueLcaWOokBCnQehi9Jp35TKWC2GX4
	 jig8nSjGYJW7w/7r70zBD/dos8yA2wCKXgQOddACT1P6NAYpexfthQ14oAwmUpvg/r
	 l7khsOd6BZRgQsMUobQuDJB1iYqUSI3yBssKoRyPMZysXUX0tgcEl8FH8UuyrxjiNA
	 jc5ydprrjZUYQ==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id C15A34040B;
	Tue, 15 Jul 2025 19:56:06 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Amir Goldstein <amir73il@gmail.com>, Matthias Frank <frank.mt125@gmail.com>
Cc: linux-doc@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
 linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] overlayfs.rst: fix typos
In-Reply-To: <CAOQ4uxhvBMJLWrDtuK3kOKDv0enMtAgpgV3WeR9Z9ZEDpOeu+A@mail.gmail.com>
References: <20250710050607.2891-1-frank.mt125@gmail.com>
 <CAOQ4uxhvBMJLWrDtuK3kOKDv0enMtAgpgV3WeR9Z9ZEDpOeu+A@mail.gmail.com>
Date: Tue, 15 Jul 2025 13:56:06 -0600
Message-ID: <87frexfctl.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Amir Goldstein <amir73il@gmail.com> writes:

> On Thu, Jul 10, 2025 at 7:06=E2=80=AFAM Matthias Frank <frank.mt125@gmail=
.com> wrote:
>>
>> Grammatical fixes
>>
>> Signed-off-by: Matthias Frank <frank.mt125@gmail.com>
>> Acked-by: Amir Goldstein <amir73il@gmail.com>
>
> Hi Matthias,
>
> Thanks for making overlayfs.rst better!
>
> Since my ACK was given off-list, I reaffirm it publicly.
>
> Jon,
>
> Can you please pick up this patch?

Done.

Thanks,

jon
