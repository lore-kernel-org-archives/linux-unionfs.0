Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA2921D594
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Dec 2024 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733411550; cv=none; b=itmv3Q/Rtyn7upPgObLs+S1Vdp88yURWAiL4f2YgEtLunu/77aDM9XC5F5TJLZkYkv7HUkFtkxitEH/yuIucjT4xwgFpE1kPNWX657c+ZjaWCIJQ46moCKtQve8yt9YowXPlhV4xq+P13Rj6IHp/Cr2IYNpPqgYeBZERt82cWmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733411550; c=relaxed/simple;
	bh=pY9d8xE9bxVvui7JeLzM44a/O5oUGXIiVbTOg6Svdb0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uuh6LoPf4oGqKhJZBHgPz6t8BFtyEAXUqqw4oe7JT65Bpzu5Gug0VcdqwdyB0RBq99r6s4IAfzBnSxF93muYvoFWbeO1UNlei+59Nftnp5ZdJCR2MWwYqrRCsYLGUejz6mHnRVD7bnC3eIZYGJ5Oi++UJu/FLbhbSqamb5EDH9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aWubJg3O; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aWubJg3O"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa5302a0901so114559266b.0
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Dec 2024 07:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733411544; x=1734016344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=22+sRwABD4TsULmuQGwY0XteY5m/N+4UW8zh0IGgdA0=;
        b=aWubJg3Oe9vWlM4bwaPsT2EZ+ZHU/fqRJY+VLixfbmddTXBFd7nd5Qpu5iEayZ7GzA
         gjblFSFD63sjIGUlnyXOt10ABQ5z2F9A0coVXv/TiPmjYh9xYONrRA6YKCvajK0ISgU4
         umWPtrNVMZ2a7eEgr+VPTZtEbutM3IJ2FHQmhOaCIxqzWvVVtX8cvpY9mJWQfTm0eyom
         JLdGEy0fVjb1FYRTxZSZV2v1/yviLFvYqJpZdXQrmjiJTvNakR3mqdDyoHI+/ANrHJoe
         3xYqUW5dYIyzGl6LX12xewcgLYHSBnUk/l20lLkghxZxyH0hZL9P4Dig6NzoUZiIWh9L
         l7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733411544; x=1734016344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=22+sRwABD4TsULmuQGwY0XteY5m/N+4UW8zh0IGgdA0=;
        b=DDuJrvO05SLcS/EJlOCSC5DszNd48M9tXLg71RcEgSH2v1QUTw8t5IBr4K4ghuPr2B
         nqGjx/o/Wk1yLrR7nzvtdCDuVXTBSqU+4f7XcwTROIOOAKsAXnMzzDWT0f9Fh0EEIoSS
         /qXdujCn4q7k0jMnyypFloMYZiTV6P1knTMOY3UTsmrbPXrzVFG8csQiZf7ch2DC4n+o
         HubRYUaQsV+2X9qwb2CG80rCivo3A1L1RbCJVpPNbdowPCS/DdiIJowbM4JiVxmznMXd
         2PG//GxvNsfN+jZXk5+3YjanmqopViXg7dWhy8XXVcphpepNHODg6A0/nKEnFtwTDv7c
         jalQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8qZ2nECZb4O0uO6uHK33HT+rP1WwLUdPbg18qHL03EyJTlqbMNG1S0jJImHqT7IvLTu6dD7nYmYVzrdGR@vger.kernel.org
X-Gm-Message-State: AOJu0YzpKSeJfSvnsfWHpZw5lCZfNWKUJDvYv/QKDvd1h9hHNlZL8MGN
	O1E9ocXGtJD9+fDE4bmOn1Byy98ieHTvvr8NZKyjuSBww2DNm0Iz/8FnivEI7SPZet8dDeoV/iN
	gY1KSvmXmReb+vzATQ847sTK5JZc=
X-Gm-Gg: ASbGncuZbFzAm06Pmu6WOmtpWXC1f27XUFEC/oIE4HFTedCDYwu9LIgpwNvboBBPFsL
	sQv/tVkPVKNklIZt6uqiBi9h4IKYw2sU=
X-Google-Smtp-Source: AGHT+IGBfmAAGw1LFiSiin+rL8yu62i8IyQB4MeO6gdxogmo++x+m4vYobcYK9MzG2737rUsF8Sv1a16AJm9Cw9Hkik=
X-Received: by 2002:a17:906:3099:b0:aa5:47f8:b91c with SMTP id
 a640c23a62f3a-aa5f7de33f2mr788717466b.25.1733411544057; Thu, 05 Dec 2024
 07:12:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241205143038.3260233-1-tujinjiang@huawei.com> <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
In-Reply-To: <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 5 Dec 2024 16:12:12 +0100
Message-ID: <CAOQ4uxjLZJXDm+7aiFsEtiUhvux5U=dftw7eNBpk55J6wW9XBw@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's get_unmapped_area()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, miklos@szeredi.hu, akpm@linux-foundation.org, 
	vbabka@suse.cz, jannh@google.com, linux-mm@kvack.org, 
	linux-unionfs@vger.kernel.org, wangkefeng.wang@huawei.com, 
	sunnanyong@huawei.com, yi.zhang@huawei.com, tujinjiang@huawe.com, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 4:04=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> + Matthew for large folio aspect
>
> On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
> > During our tests in containers, there is a read-only file (i.e., shared
> > libraies) in the overlayfs filesystem, and the underlying filesystem is
> > ext4, which supports large folio. We mmap the file with PROT_READ prot,
> > and then call madvise(MADV_COLLAPSE) for it. However, the madvise call
> > fails and returns EINVAL.
> >
> > The reason is that the mapping address isn't aligned to PMD size. Since
> > overlayfs doesn't support large folio, __get_unmapped_area() doesn't ca=
ll
> > thp_get_unmapped_area() to get a THP aligned address.
> >
> > To fix it, call get_unmapped_area() with the realfile.
>
> Isn't the correct solution to get overlayfs to support large folios?
>
> >
> > Besides, since overlayfs may be built with CONFIG_OVERLAY_FS=3Dm, we sh=
ould
> > export get_unmapped_area().
>
> Yeah, not in favour of this at all. This is an internal implementation
> detail. It seems like you're trying to hack your way into avoiding
> providing support for large folios and to hand it off to the underlying
> file system.
>
> Again, why don't you just support large folios in overlayfs?
>

This whole discussion seems moot.
overlayfs does not have address_space operations
It does not have its own page cache.

The file in  vma->vm_file is not an overlayfs file at all - it is the
real (e.g. ext4) file
when returning from ovl_mmap() =3D> backing_file_mmap()
so I have very little clue why the proposed solution even works,
but it certainly does not look correct.

Thanks,
Amir.
