Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9041F3914FF
	for <linux-unionfs@vger.kernel.org>; Sun, 19 Jul 2026 14:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784470378; cv=pass; b=BM3O50kJgl6+L9X1Fy0cET3Mf+M8aTDxvH4qaXaxTp952GN30xA4n9+x/wVvUGxjW3p0X2txtdwtkAk6bq5O8VSon4ITndjM/0cjJIQ7VppZDSH/rDFv7iUnnylhJkuFd4pRrzaPczbf9+6IqafdXFreD84ArjYQt99c3jJCxkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784470378; c=relaxed/simple;
	bh=Gf39QtDs1NJUG97yBMAnk9ZJwy/ZHg7aeBsaEUjF3/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QH9nIWSifTVJrUe0pDAWXy8UstfPxzoycrxPIwsMxR3YWDBJ3VL52UN0/ohBcHRYx1f8xDN9tosGS4kuFfhVwkbQvwBhWE9xAqK6V9ZzuNXIMvpkbNe2t6aZp/KDHibAW8hkOoJNDh7zqKkcE8mEhN8rUHzcBae7C9MVBtorWPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=d9wy5ZKV; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="d9wy5ZKV"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39c908d6cb6so82984441fa.1
        for <linux-unionfs@vger.kernel.org>; Sun, 19 Jul 2026 07:12:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784470375; cv=none;
        d=google.com; s=arc-20260327;
        b=Q6tFg6TRwe0CXmuq8nljvAzrQgVJKJCJncofGdNhCjbtlAtzqRSCzRk09Nm9tbZCiE
         oDmlgp81GgvhvtmBetHIJ8H673ywPG1aGIgJ0/Z7wKEJndnnlyXjDuS96Me/CbMmUoli
         r0HXsttsh/FvZrp0h4iD77Bv8w5WzTTq6raWGUyhQAUv3Vz324kyo2+Y3rHivBdr6wYB
         OcCRT6OCEvRowBKrWDiy/Y5cheN+QmV8ipIca69e+0BxFK34E69Q+amuR2hOYP2sbCXV
         w3WQbgZkBU03WVfQLNOBQyrXoDJWcfFyaFFHclrkxFjInTihtqnCEUQ1eSY4I2m267Iw
         mVuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8fnfVrhkwP422PxO/5FsFZHAUY1r3GNO+87kR51xMWc=;
        fh=cB+cJN3tkubkBIGZ7ANQ1G+rmphW0LcKmmnK5g5xgsc=;
        b=f1f1bLSlyHS6vUDMgaWpq/NfXuwVikEInlPE6qy1CCXMEE2MbhR6y2Bp5yHWiU7P3p
         z+hYnSfo4IL3GPXQgzxN2ZIEf9ZB/0JHSTdmZ3UTWLgYqrgKg1VjJCF2JIvBGCfXU7VZ
         M8tAOtZdfHcb/3IwtV52/AN0zZHJzDOxQ0eXI+LRYvDnijmOPxQLr0XMLdBrZEO+xdox
         Y6mSP939Arta0+Rn3Fklyb3cVLxUzT1CE4hXnS7o45mcGoJhAtKrzmYrwZ65jziqZvmI
         R9ROJDD6OcavK+EdFZA4ex60sQK5i2q7lAAtjpL8ZxK/pz6vsgt+lY0fSJZ8KB2jJIbF
         HP8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784470375; x=1785075175; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8fnfVrhkwP422PxO/5FsFZHAUY1r3GNO+87kR51xMWc=;
        b=d9wy5ZKVfznR4qbSmLHM5wLxuSjQRPGy4i0VLYQtK5dLLnwGkRiddDA/VLgetiMi05
         Y+I5UVuKvV9E3SM3HWug7hMlD4PFdtZXvAOxx5/lQIh2bzY+pz1wpzt6Bzg0w3hILDMW
         e3GsK76nCbgIptHRnYDLRt9rCOZy8ameABUXCEZA8dK9EblMfR74xzbuPGYobV75OCGT
         5dmKGa4DA83unOer5/p/6wDrCqXELBQgzfxOhfojRcG7ht8/0nlpdK50hruoJQPTrjAj
         m2PabkRjHvH6MgKwQzHgdBgP8HHyIdR7r2EMuqKn+CkNA0aIbcifu3rVZlrjzFttBdzl
         Ph6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784470375; x=1785075175;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8fnfVrhkwP422PxO/5FsFZHAUY1r3GNO+87kR51xMWc=;
        b=He651yMYbgDIUksPid3nxsRYa6L2UP6QFWs07OUO7ZVRql7iFC2nDHbfLzEh5AhdeO
         r6OpeDGhO6+/LR526MVP1fb8eZAQa7ZueU2vvGqV1jq43JUuVK7z5uibK4EHHBkqvecV
         MI8toxbP78i2XX0slu7kNccggUikHtG3FmLOmQgnygS3z5TkwU7WFd2mwi6nfK4CHDmI
         TBMxIpY3vVDhQv0znpYICRRx0TTl//uY6fOH9YTUVVFO8rWIo+BczBia6nLrxeVh/SF/
         sMJw3GGkXE1PXVGOKIN9efqrfArpUG3LnJq49rzwUSVy6YBzdsakVuCjl8omfSlu0ZU3
         0TAg==
X-Forwarded-Encrypted: i=1; AHgh+RrI/+TXPvq/lMLeNoMqA9oJunQGCULMvqSfnw5kOw6bka+T5CTSTi8xuOVTrajOP0afJbq41SEQPx1W/n0S@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7hU47vpW73DwoA15qkOIgNdQ8Ybq8fRnaW+ExBFwp9iBZejOG
	vp53gpX38GgfO9vRTvrg7RVd3dMqsKsw4C5yZjbOHAsfJ5TT6QE0eug1hSqsqTKrqHe3mKgsXra
	FbdvaWoPWGhUIYpJwPl+UAvR8N54CLpt0tskFwZGl
X-Gm-Gg: AfdE7cmyTYtiAmf3J5M/2/SEdnQgLkuN/q5q26IKMEeeQmKES+ykvDhRfYW+0tukzfo
	zxIoswHyx5J4v6rj2h2i0HVWERXtRwycGfoIxe/ybKBSPwJVhi1qk6e6qh+LbTFCRn4GDOI+xyU
	dLoE5uc+B89zpdhLo6jwTyuxm6hcKJ8kDYtqXPMRVVf4kMnXAnhL/fwkR3AClUuKk5f9ow8NZ5Q
	z56X8oZlIws7Db0cmfv4+3BunbO4NPKroP04AvY5nxH7tV/ssq4JzyuJAg=
X-Received: by 2002:a05:6512:3d8f:b0:5b0:1879:1ba9 with SMTP id
 2adb3069b0e04-5b28f9a5720mr2256451e87.33.1784470374426; Sun, 19 Jul 2026
 07:12:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com>
In-Reply-To: <20260715101107.973997-1-mszeredi@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 19 Jul 2026 07:12:42 -0700
X-Gm-Features: AUfX_mx-VrWAtPNuDviKfVjbn51tqQht-nWAXr-HfoWBbjn3eDOh3hiCtUPefpg
Message-ID: <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 3:17=E2=80=AFAM Miklos Szeredi <mszeredi@redhat.com=
> wrote:
>
> This is a prototype patch. Needs to be split up!
>
> 1) O_ALT / OPEN_TREE_ALT
>
>   These open an alternative namespace rooted at dfd - instead of resolvin=
g
>   the path in the real filesystem, it resolves it in a virtual tree that
>   exposes metadata about that file.
>
>   This is intended to provide an alternative to adding new ioctls:
>
>    - provides structured namespace
>    - allows accessing data through fs ops
>
>   Could call this O_META, but O_ALT seems more generic and there could be
>   uses beyond metadata (e.g. seekable, in-place decompression).

This gives me the willies a bit.  It's very cool, but it has some
potential security issues that I think we need to watch out for.  As
sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
supported files-as-directories.

Some questions that we would need to consider:

1. Can you open an fd referring to a "directory" within an O_ALT tree?
 What happens when an unsuspecting process gets such an fd?  Can you
fchdir to it?  chroot to it?  clone its tree and possibly bind-mount
it somewhere?

2. Can you bind-mount *onto* something inside O_ALT?

3. Whose creds are used for which operations?

4. Can you mmap the things in O_ALT?  Is this determined per object or
generically?

5. Would we ever allow FUSE to expose custom things inside O_ALT?
What contents of O_ALT can a program trust come from the kernel and
have the expected semantics?

--Andy

--=20
Andy Lutomirski
AMA Capital Management, LLC
