Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.170
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795002788;
	b=xLjr/E/7s9Ih5hbOBjTsa+NBDPu4eQ7VLkEclEERfCiYooKFs1ejZuXs5erkvxBiNojz
	 qd4NpwgQ16fH2LIOyUv9iLdAaOQ/QwYeDvt45tEYPoOf6zxWkcZZkOuVIcIihujzdkiE+
	 09AV9FsSBrvHcA2A4JAPdNJP+j5ZD24yBSJ8L7MnnTtosYDACQsrQBlcmv31JHdXPAtJd
	 bRigZjAuJmkNDH8SJfVv18FjlnVvNeTAP6T4U5jkOxWMrqA5zh/Hz/qG5Ogf3IqJ5eJ5J
	 YreORylwvOqjF888w2bOwGLWbl/V4KQIvwqgQvX44L+P7IwhoOar4e9MXUecMvqXWOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002788;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YOemy4vy8MWHVR40UGX19+QReF1uG2SByZYvNpsd4oA=;
	b=jasJT3XY3bIvGIRjQPMZqAnWlRz/e4LXBBcJ2eONvxFo668Wo3xqcCD3cxD7l0QMExW0
	 fVcBTrZrsPV/5AQ0t+HjgnEMdQqxrVww7eb5915lxB90NL9qgsFygOunFCsutek3UnUb9
	 ROPz+E8W5ny0d5UCPHkNYBspVm9BI/m4Te+IJXJTjinATx77X6j0gZU+Sj3H+6S1PlOnZ
	 J9QtlX9mxDrN9qsi9X+Dl94GyYoFlz34v/lhV5z5daf6PDBpMAh3qgkIjLDRL64xTy9iv
	 wWtZLB1AHEBu8GObkpjgSBPxfaxBvMFWCjHZrZukIHkXWZXLDcQylBgLvGatsuFA98g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=szeredi.hu;
	spf=pass smtp.mailfrom=szeredi.hu;
	dkim=pass header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=WQuSux+g;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.170
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D338606A325
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 11:53:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D338606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=WQuSux+g
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-55c48582654so8874281cf.0
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 03:53:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795002782; cv=none;
        d=google.com; s=arc-20260327;
        b=kwBSmdFG3aPL2lz79qveDgaCSs+mrd8r2XVzKWmfe34Zx86xZrzTna7dAbuGFKUKgA
         Cq7+tmdCHpT5vwRQSGrTsmcn1xDxiHRZ2DU0mLNbgoGkg94vBKSoiFsB7rGuG1cGkL8B
         HBwUwRzI4uF1G2zsCb1m8HVwPKvMDHvTknyeVHopp5FiIufUq/lmd+olO8W+umrrnIMf
         tqnJnc2HxzTMa/pE60o3DsCi60FCxBDu/iQGtMbeXvxQMSAvUmXKUNHfCQdF8vm5MV7Z
         U8hf5PzKDKeaY+6ffy+vGQ8mMYNoBZVsveWdt4QIHxfKNxV+cb98iEK9VYqT2XhLWn2V
         pX/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YOemy4vy8MWHVR40UGX19+QReF1uG2SByZYvNpsd4oA=;
        fh=MTgu5uKN6XeVnnRSJ6sLwx7AjFo7KiTF6aKbudQwosw=;
        b=NHorYRUWC3QL9t6oOg9Mopt7rJqNnqW57H5vz0jYMiR4beB/69/l8j8qbP0j/U9col
         PJDv/7ABZDjBy+xWYbKSC2OYcS/8YTtuWpHfnRxis2+ChbvENLKBEwsiyH/5GavxzonJ
         u0e2hyd/gES3MbwalF58WpYNuRhStRnuPP5h3RajaL4hfKcpDU5Xtf9hhdAnnc6LA+WW
         QKMxpYkctt98Px41WeQsHCWd2Ko5JZ2vLBsDKSfZL92Bv04PK1ZQgbjHJd5krYug0NoF
         QxAJC9WL3XBCcXTl5iLeUrE9GYKXiR2aDuj2OHxnCVCrr1LnEuwXDBqTb/sgmxcZQWOI
         YiVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1795002782; x=1795607582; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YOemy4vy8MWHVR40UGX19+QReF1uG2SByZYvNpsd4oA=;
        b=WQuSux+geT4BihdtfnZi6446nTgtD5+9/isM5YP/X7fHClnPhiELyMYopCdszDNrhC
         7DBSN+dE6I3Y/8FsMUI9jWhoYTSzo0ufLcPJvvLOA8f5NdRthvfmtSXFhmu+5pyle2om
         7XRHXksLJr7ad1Ufey0e7N20tYHCH8oXQVhLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795002782; x=1795607582;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YOemy4vy8MWHVR40UGX19+QReF1uG2SByZYvNpsd4oA=;
        b=jgAENiaEDkbMLegS7uCExkKJY1FQP0IiwP01OJCWKv3Dh646qQJMiI6B7Uc+LvKxUY
         1PezGommXuUNFKkAYs0W25VDRyks7CykFTRLAiyFqbpxrMeMN1g+KhSIKWdK+FbJNwA2
         pJIYsffcToWQkVOzzxfgqpGO+Oz5THCXYPUf4Ittl121f3NDVctsG1a4p5JvBsEEk1Dm
         rjEMQsGLk4pyzG1McktbxUUDFocyjIDa65TEadgRmV6Xg4Eb6GJSLu1KwSqnSaqWYorb
         BSNtMXhfKdDa/vfC/OsFgIRKaOiVmkGl55uLjnh6DKwJgLl+VsyIprCRuADB6Q/9lbXU
         0tfQ==
X-Forwarded-Encrypted: i=1; AL+hErHJTwldFstjJY2QP6sj+YqkLYWW3rqdU8nwNpoaIt1EoyWLyAUlocMoYlN68YAXc5/8o9qP+My/Zgbwi/TQ@vger.kernel.org
X-Gm-Message-State: APuU4Z9ADtGNGrRbHZB3Rbd5a7aw/9MG9bHSexigPmDuocaNA4LLUgdn
	M/kN0OvxAySv1EH1l2xpLYi/KgG8HlDNiGHTg2bTtJe9q/c0SIRJgyRCOpdn3MPzEzsWv0K2g32
	EaDrQnN02hcnBoUp4Qcc8y2elbb7NIhynbnLtHvaW74Zd0fMM2Y08
X-Gm-Gg: AYBFou2s+Dz1Mqea1Kowfkk8iKZbUcDVcjM95fWjrFrIMUwG1lR3/ncMDARfy1NbBun
	Xjl4STkk8xnLM0pk9T5UweJ8+ruVKCAlUDdh88Zg+rSlhN6H1oAOI/zX/KPSWvz7CmT7eXxRPnf
	07PMDxftf7S+S9h4LIRLlA23+1KpIxoYM6lJmzMp1aZA7cF2d/qhc01bioqR3j5bkSaXhVy0iN8
	yaD+uzLpizJU0CcJEI3axhP886Ky8hCMtmkkM71DnIhoMmCVqWR4XUihKzXugLUUW1HCkxe8et2
	JuLgI13y8KgqD4DniyfhHqEoG7DI5QtnlXDN7IkpkuiOv6oXydObL3prFcltuFZ9qqweRGoVDvI
	nruPaaCvjCDorNm45Uzr5oqx3FLqDOvlEkGKipajJEXQsMK+aF0iVzACyr1baONZizE+E/O56Hy
	aa1rt1+VJwaOA=
X-Received: by 2002:a05:622a:1b9e:b0:55d:2d44:9ae5 with SMTP id
 d75a77b69052e-55d5a5543e6mr34027371cf.18.1795002781647; Wed, 18 Nov 2026
 03:53:01 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260903132636.1113789-1-cui.tao@linux.dev> <CAOQ4uxg6_0wnzBmA+-rZeADBTKwLsWFdEM5ZVGa6YvWX6mAGXA@mail.gmail.com>
In-Reply-To: <CAOQ4uxg6_0wnzBmA+-rZeADBTKwLsWFdEM5ZVGa6YvWX6mAGXA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 18 Nov 2026 12:52:49 +0100
X-Gm-Features: AclHuK-v802KVD0LHoWjY5iM0tjQ6zHZvpD7dHxxWrixnWgNNbm10gK44m_ypRE
Message-ID: <CAJfpegsfjfEamq5=+0Pu0+E2EFRzf5Yk7iSp9-z4kved9jNjLQ@mail.gmail.com>
Subject: Re: [PATCH v2] overlayfs.rst: clarify the scope of file locks taken
 through the overlay
To: Amir Goldstein <amir73il@gmail.com>
Cc: Tao Cui <cui.tao@linux.dev>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	brauner@kernel.org, jlayton@kernel.org, Tao Cui <cuitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Sept 2026 at 15:51, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Sep 3, 2026 at 3:26=E2=80=AFPM Tao Cui <cui.tao@linux.dev> wrote:

> > +Note that file locks and leases taken on files through the overlay
> > +mount only provide mutual exclusion between tasks that access the
> > +files through the same overlay mount, and a lease taken through the
> > +overlay is broken by opens through that overlay.  They do not
> > +conflict with locks taken on the same files by anything that changes
> > +the underlying filesystems directly, so file locking cannot be relied
> > +on for mutual exclusion between overlay users and such direct
> > +changes.

Locks: completely agree.

Leases: independence on overlay and backing is not guaranteed, as open
and read/write/etc. may trigger an open on the real file, which checks
for conflicting leases.

Thanks,
Miklos
