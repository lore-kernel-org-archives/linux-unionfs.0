Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61853373BE0
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783525073; cv=pass; b=JABpJdsloSpNcjYhfPEZJEZvulDih52I5hYVmtHiipnDHdWEj6F4zC81yyRgBjoLoSVlBYL0jPxx0MyvEX7qy+4QdgTdeigaLFvP7lJj+pljvjQ5Kk2jmQMXnRngxMEkS+fPP3oFs2lfCEKLjEuclFr5u+3D14TUoVKnYeotn20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783525073; c=relaxed/simple;
	bh=WEa0OR9IElvwaCWw2siqSbeNFwXC1Rtf30r1klHV9/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tMYZYVdRI5fqv/Tx6jhNEcRpgQj3JYnDtpOrGrx/K8WZB8OGGqMHJJ1gMefYkyrv5n1BLakZlsAOoGzzbGXO4IGEE94i9i9xpNydGDLbQ/AYKOXBR5JJnE4bnyJNtB5w8cBQO+y6K0RbqMXXYzj+m+hjhZS1EgPsCDQewhJdc6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=CfxeooCZ; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="CfxeooCZ"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c1372f84dso4883651cf.2
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2026 08:37:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783525071; cv=none;
        d=google.com; s=arc-20260327;
        b=mlbJ5mvj0LTpj44fgp88/0djiREs5Wyn8aXExiGR1zdPFsM1P5rcgM4JNfCx3e279I
         nXdz6fHrV/zknapgHxPsvjf9nY5B6MYedia5ht8LMq3xGcoRDkhOA9293Ne/EoN1tzd8
         gAZU3rhAKIPe816UNYdTjQYAwyGP3E3eoeFIWm5YtJWj4LbsHqyo8nDC7PLAF3o7P5Xl
         66zdKLLfOZBKBAOd/jNJWXgkl05Q8YZlXHNfi9pqqJuJoexWFLkMCaeUiYzDhk2mdgLy
         FVrXLjicognpDB6UZ4e9IVkk0c+TOL6qszhP8gljaThyZG9dzkyC+UVvDq2xr/2q7RZR
         uKFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qkeAjSrfipPZ3gYTMXBLe77/aSlGkx1MoDJPCEzD0Ok=;
        fh=j5JwwigJtOdAgwfHt+JB1Fn2X0f6lNWWWVOy5dVX198=;
        b=ZkxOdrC75Pr+G6c/dQ6yQsTN/uYypzlUavnz6OuPbb4vAr/OG0bqNG3jfaZ/KWHTVK
         OpqElmG77hMkViJL5jfGi/EV/G5iDx0yY84RBqRQ0HBDvd30NvHrjDBBsfJnMQjfZMGN
         W+IChPvjr4J77ag3Ra4IrV+a7Eqtdz/R+vgxNSKP2hdN+gNVTAjMpv8KbOJMjSgyprr+
         mrZWKL7fEMJeJIginOO2BVMMZGpAqgo+kQvE22/35ME6DAC29HaaRDMqX3Pm0bJ/auTc
         4/ghlI/jVZ9iFVtrKBKIyA7J1CnmiCOu13aTBnZK9VqUkUUnZOx3sHSKRXjXB/LCZ+ZF
         luHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1783525071; x=1784129871; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qkeAjSrfipPZ3gYTMXBLe77/aSlGkx1MoDJPCEzD0Ok=;
        b=CfxeooCZqaSrdwi28QEVCapXEmZ+UNJ9JNHRzdjYh9wEyoLuNv8bVSqQKlXPuf4bs6
         E2Mczkycu1BZMmfcskfPLiv/3x1KoTLz9ENujsVPqj9ANro42Ffa1s+71ilozzYwtrAi
         JwbKK5HtKlBOjxiIBgiMqzuhA9ilvgig/Lo4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783525071; x=1784129871;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qkeAjSrfipPZ3gYTMXBLe77/aSlGkx1MoDJPCEzD0Ok=;
        b=KlYB2IJfk/aKi3gBXNVt9B5M836SpCd5L6/Kx/t79WOWcR0d9w5yjlsau/2a4Syokg
         EkO6SqF8shIM7ZGVSQHV5Mer+8qP8cBrLyb9AzSos4u07sxOwOeJ/TeyTKA5Nc2wQHfs
         LH0gIcK3IgifCLpKHPNVV67jpLq5yt4V/3WSqrXAOisdq2Ag7gbhQvR8OVeACVNWIkHl
         /rnQGdwoLz7/8b4lo6gd9gK8G2Ccv19qH+h5S20TSNW0r99QEJMm1STbr3CY6P7FQnGO
         IiDy6zG97SpczZFvcIsm8e+q3XB2iy2v3wRb4wj2zixzdIF6z3isJ1iigNYFbOmqcdlT
         5LGQ==
X-Gm-Message-State: AOJu0YzKt7HVJB7F1/6h11uNhswBc0NuZ3ob552WkR0dtPFPV2T1ucuv
	JIKX5zSUTj3i3Pk3nHEBBIm+RbyDTXACZCJ3Iwx4IUCPqL1D3OrcVqGZ0/Kmv+8y6BJVZb2pC9s
	R2QyX8jGGmwIhliG0g3vKz5uuNbNOrDd6HFs38KjUpLjS9BIqexes
X-Gm-Gg: AfdE7cm4ZlNy9uCbK8QlKYyb6w49fn7SVv/d1CE1gm2OwTc28ddbl2CzZV2ozpMI/Rl
	nfqZGZoNhD9FxhxgCZdTnxorhzj0Yg/o1C9z4D3XAzw8gSGVUxCHXhc1IvRH/0KkRkiqXKufWQ6
	TmQRhgY632pCZ+OWQkPkOMdov6On1anrSYzr54lZyqok474NrEN4uMVflmfG/UulFPvK1iqBMmO
	kH1B6zAvzjW2fptMbHwSaYpCShgLgvVFxMRdYbQgDv7auyEI5Y0UlYl5dej4rzWwNqns7mJIbPU
	HwoJtsXFMRdYfwrfY2MuCxLMFUN/+5R4CD68tQ==
X-Received: by 2002:a05:622a:410d:b0:51b:ff78:f221 with SMTP id
 d75a77b69052e-51c8b2f174dmr33523261cf.29.1783525071383; Wed, 08 Jul 2026
 08:37:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com> <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
 <878q7l8y4y.fsf@redhat.com> <CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
 <87wlv57dt1.fsf@redhat.com>
In-Reply-To: <87wlv57dt1.fsf@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 8 Jul 2026 17:37:40 +0200
X-Gm-Features: AVVi8CfqzC9eOvDm8nHA-5UYAS5HPZI131ACQtCWE5J--FkjXHyF6qlMxysQysU
Message-ID: <CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 Jul 2026 at 16:32, Giuseppe Scrivano <gscrivan@redhat.com> wrote:

> Amir suggested to add that functionality when I've asked for some
> feedback before sending the patch here.  I am fine to drop it if this is
> the consensus although I see its utility from user space.

How about a completely different interface:

int get_fd_opt(const char *name, unsigned int index, unsigned int flags);

Enumerating layers would be as easy as passing an index stating from
zero and stopping when -ERANGE is received.

It would work for all filesystems that use files as options.  No more
fs specific ioctls.

Thanks,
Miklos
