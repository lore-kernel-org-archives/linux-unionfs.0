Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6613B27FE
	for <linux-unionfs@vger.kernel.org>; Tue,  7 Apr 2026 12:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775564090; cv=pass; b=IT6QQi5Ib9eS2MJLlJYI9u7SdROja3jNRozmXoL4ZrMMogyBIYsz+0D42vQRCulOHla8rw2VkNBNqeHQ/9BcIZtvAz2MTgWHMdxK6RaIXGrBn79nNOC00vpLDLWiignAWuXxqaDaKCeiCH/CsRbtCTLoV8EsckP3YazTMjxTASo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775564090; c=relaxed/simple;
	bh=DYtH3ovqeZiNqkreX7Nz4nkPWobgUXsJ5dwCB2BpWgA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lh/9rPVw3IDOM6n6Lku37lQXGzyjsM5Tzl6anSZ4KMVE5EnfV53tWkhhMTUUKthwoL4YQlS5N8KoXdMD4hRos902GN9L0n7sSLtfFusvIeRNijrA22oI1hyrH/4MLiUT4qLT2RvUy6sSTCyPJtlPVesT4CeCBNiTczQeCo1CRz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mVZPYGFy; arc=pass smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mVZPYGFy"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35d9f68d011so3209943a91.2
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Apr 2026 05:14:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775564088; cv=none;
        d=google.com; s=arc-20240605;
        b=OBNO82Plcgv9LdLHKJZF78sCr1ThDOENUI+W/bbLCXrFocFv+5hJ8kfzxe8Wibiplk
         qdBFrGRn77eAF48sU6lEUzjhvtA1sweDjSGre4X5D3rIkbePzb7N185iBnnUmzXqUwiy
         9d5hKHSP0qV6//Ns1z22LOV1hpd4ZdHBmucjbUWy4z1UJ4AGSpt4wizLWG75y85Bjcw6
         HzM31BgsGd4GWeROlC0FIZSjPehEw/z67QCBzWpte+TKtO9JY/G2CiraB4Pn67XzxktB
         ZsV5XtOU1t2jGsWGO7u6mzH+PH2VQDdEBdsWswwq7Cnwx8Hba05VkHgxEiyVZV7oz5yZ
         ZcGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zTDkABRGJ7UHzKZMFM6DSH1URUE3mRRr3uWbQhi8EKg=;
        fh=13ooZJkf+dkVFE8B6Rjvo43F4VfAncKlukd8OSQmJak=;
        b=CkgLIo4VIH6yclTdwwve7N/k0h7LYzp2cU4Xu/HJnGkrEx772Tiwl3RaRsbqFh/Wl3
         pa6fgDwHhl/dw5sEGv3dAoK9kG6catd5gQyatz/S1mpZ9yqszgmFh+6w+4j77RXWkwkt
         PbVhJ9AGslpn/rPzIjKCHy+WsmK1V4lQbqMTgTzYWaeKjYRicuddQqVQwUC/fd6f0d26
         n/my3stj7mQ85WE3b++UG80MBYmCrwrOpyPeS/Pc/6gzmR5CzM9blfXXMvBLslZ9UN/7
         K0kTNUSDSfhVQ8m2GmaE7uNnuBp/sXAkSH8Gw0P8+jPbhoMtCd3PCHCeQRU8ljH7LJoy
         9Cdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775564088; x=1776168888; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTDkABRGJ7UHzKZMFM6DSH1URUE3mRRr3uWbQhi8EKg=;
        b=mVZPYGFyBgGtpWk4sX37nuVl392e96R4bjfs0ORNcxHmm4repjBBJl6wER9s05QPRx
         u9yMmyrIxhKtFPIgahhJkUem9XXnOt0Y4udHqUe5ZV5JLiunPgHbLwuF5YVLX9xOMwfS
         SHajj6jRYt56S5BkSVItPD2zTTs+S886TqgSWf6wGsfmVf48l/adO1vgGfcBxFHMUdKk
         98zAae8oxZWozMTxhB3oIy7PG5AaxmT0a1YdtlKIlVFcGbOdculw91xtDE6pfiAGsJ+L
         dEx4POQKFfhhxVSIboL7SSA5JB8IVPNytMGFiSoathMYqf1+sLX8Za9GGxj7OoZpqzGF
         gAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775564088; x=1776168888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zTDkABRGJ7UHzKZMFM6DSH1URUE3mRRr3uWbQhi8EKg=;
        b=i1u+BuVTa375RGYLp1BOe6EUgQl/Dqo89w435+ypspzLy/+OPkbWQ6gWjb4wR7f27X
         kLIJdc8CAIJgYT75MwUuD4PsQJjuS2JVntSkKsMU0XYrwwl7fPWrMOh+/BRobL/NUEp9
         1JQqXPOatzcV/Dhriwp/6WLlFJ7W8XckOQ8q2giQLwaFhl5geeAp9LkbBQREKsXD0TCT
         1XLoOrU8jRDRXXFrMrarWlcR/USX87UjI5H7+shGnqCdnDNw7cxLuHupebU9GB1w7TbV
         49YeCvR18higca0mSLdr0bDvRthU7yoCea/QfvbsNGvwpiXrgN/3rJw74T8jxpFlLfX7
         abPg==
X-Forwarded-Encrypted: i=1; AJvYcCUUbOoLGiKs9MmOJmVKWJj+nzu8Jrk0nl5RtHIwjY4OZ4s9AwzUIeF1ThuhS9yt6Svv9R483nCGITgNlCC0@vger.kernel.org
X-Gm-Message-State: AOJu0Ywao4iwCCznrzwCT23LUu1A+hLYj2BgUrUjhKBTWPo6hkq0ni/h
	VzCI9C3Q5wmeHjyOsj3Nplm1+/Cv/786RpT/vHiQVEOu8ncKdvdnchzAEEr5fy3eHFiS4LNrCIw
	KkJKNyTenhl4YLrCKWraPWj7x8U0Pgu8=
X-Gm-Gg: AeBDieupdkoCwTMt//ZABntnbKc30S/yl82maR6cz4tjoEIVO5ShqopAxHUSyzNaTSW
	Mxkt91errA483YrBVJiYPgLDeLNOQG1tUYvbNZ0csu5ISLx0UeSei9bu+RqaWQ5D5Mg363pe0fa
	HM1veYyQ1qTFtXNJ/NzUd8vXw8Uzn2/S0Cyvs7yGxME4JTX/zwCMbSQEoX6XM3BR6ggw81j1QPZ
	6m6GZ8BpEkehi6YliKEN5hPv5E2A7LOJzg8CGK52dcko4RofwMP0dg7VVB1fRsiZTTv8U+6Xg2j
	5kQzsxY=
X-Received: by 2002:a17:90b:3d4d:b0:35c:d37:6024 with SMTP id
 98e67ed59e1d1-35de67ea9d5mr15645164a91.11.1775564088070; Tue, 07 Apr 2026
 05:14:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403030848.731867-5-paul@paul-moore.com> <20260403030848.731867-8-paul@paul-moore.com>
In-Reply-To: <20260403030848.731867-8-paul@paul-moore.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Tue, 7 Apr 2026 08:14:36 -0400
X-Gm-Features: AQROBzAHeiE5r-KOh8TmARe6SlYgAd0n8yvhwUwHmTAae_PdDX5ZmAScFcPTcfU
Message-ID: <CAEjxPJ4nqeuPhve3Fe-tFuNW9R5grnWwfYJv7q2cRu+UPQ5c4A@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] selinux: fix overlayfs mmap() and mprotect()
 access checks
To: Paul Moore <paul@paul-moore.com>, Ondrej Mosnacek <omosnace@redhat.com>
Cc: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <xiang@kernel.org>, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 2, 2026 at 11:09=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> The existing SELinux security model for overlayfs is to allow access if
> the current task is able to access the top level file (the "user" file)
> and the mounter's credentials are sufficient to access the lower
> level file (the "backing" file).  Unfortunately, the current code does
> not properly enforce these access controls for both mmap() and mprotect()
> operations on overlayfs filesystems.
>
> This patch makes use of the newly created security_mmap_backing_file()
> LSM hook to provide the missing backing file enforcement for mmap()
> operations, and leverages the backing file API and new LSM blob to
> provide the necessary information to properly enforce the mprotect()
> access controls.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Moore <paul@paul-moore.com>

Do you have tests for these changes showing the before and after (i.e.
failing without your patches, passing with them)? I tried running an
earlier set from Ondrej but they failed.
