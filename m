Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DB3442B39
	for <linux-unionfs@vger.kernel.org>; Fri, 16 Oct 2026 07:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792137581; cv=pass; b=F2SKIOAce13+e1K+dvUCAMUgrnSl8jXkN3w5VmN/aA77DrsfLL4U44NxW/tWQUUlUE697Tjpk2h8aBVjZE+My1yWpu74r68RE6172O+wnQXSaZT3wGNewZEDHxcihUGdKD54Famd0kUeaEX6vX7aQNbefd3tnvlFG9JY7f/8GjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792137581; c=relaxed/simple;
	bh=9bth1vD7yHDRAYYXeuMH5rIgXb7rCuLzadFyMCAZY5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NRky7Rn/cTzxrgkfo304W/YAPzSlNh7MGGC7hOd8xdTm3hXnHQBFdhx1NdvdOmcC9SWweK+B+gTp2faZR5DDWFwwu1CNdH/COyAkCFKCgXM80bc7A7sVyphwcu2X1pKy9yrrwuiDMj+oo24OuFqOXtXZEQXhSpPQbqPv3Vc80IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EssNCZU2; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EssNCZU2"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c411e139259so8249366b.2
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Oct 2026 00:59:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792137577; cv=none;
        d=google.com; s=arc-20260327;
        b=bJw786o5zLKtpZmk6nDO8h6a7vxYFnGhCfy4RyrnSeNR9jz9VZE/tKnWtzN0pexRov
         H/EstQSoDMJzzff0ft0XogsoPu5crIKaBfS00ojFrgECMct9NRlsQTpHBxdOne6lkOTb
         bO6xluCVghrJ0C+aG+1CtRPZq1D7E6CpfMVscisK3Q5ae4GD15us/7c2luDIY3ZibpI1
         z36HOI6m63TPlNrGbVXrryF9f/Y35ZFHCy7Q/E6IMlXiv5fYlUGChxV8PUhI1NgEz9A6
         mLlexVB66cpNw7Job6cx6ockwNdx9RRr89nODEq/tqH4ez45Kv5tRLvoM7jFS5UdERDg
         3Aog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CqeWUEBI6e0Y684j10gyEkaIDx00oGMgtXL5mTvqppw=;
        fh=34W39lVGwwYj2fx+qSenXmkA9zcfQxP/o9YQ2L8z654=;
        b=pH0dUEx7k12smw56LV4L5XTsuWnxiVdJWx4N+EX6GLeJz2jj5V6LxzxC7+gDr6xltL
         B94Rn9u0ON72t/eIgEYdmLfiRN+nyDjJ/o8nZGmv0VOp6FO2y5baGlgHjE6LGP3++Rox
         iuK0ZMyloWhEcqg9jVj2+8aCdTeIDQgSkzUkIt7DqJEDRpLTPnH15yf/iUZLxlgRB0sE
         t5ncL7vC2Jb7FlXuhjsu6suTgNthwwhawNJPqWIZsjsDXAxiA7oyJ5XtKsgWnN5oJwSb
         kkvcJ69CsWCv8BboPMnRZBXYa4Csk+8oQEiBlOdeN84mQtba0vEH3HnT5f9sdUgEDXrB
         3qMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792137577; x=1792742377; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CqeWUEBI6e0Y684j10gyEkaIDx00oGMgtXL5mTvqppw=;
        b=EssNCZU22L2PJ54SA3PCvPhbTm4N9Ue8uokPDwtgECJWuzCx0UsehkqK3nxVmZ3sF8
         cpwy/x9l1DH3J5uhVvjcCAwRsD3fA44e40rrZlbRjKMt2b1tpg0IpBqi53l5Wj89LtRI
         DsUp6DRcG0l/qKckcmSbqbI+pgfWp8wtHNXZDGlzaPO99au1FitEVyEv7EfdvGo1lP+G
         zaaP/WpLavMMhpvPCZ31K+g6b/7NtNnvBV9DKdm84DoUBW+qYcAcpQhRR5bc48hj/e8c
         uxCY0+wN659f18zIVixG03TXiWgeY+lrG0+s9JgfXtuYHXku8XoVQ4jjSjQhyKVg4vPn
         yMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792137577; x=1792742377;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CqeWUEBI6e0Y684j10gyEkaIDx00oGMgtXL5mTvqppw=;
        b=OnmKm+Lk2hpBdu6JhzdLYvlvXWtAbaR8fLF2cr63MCNSPz4AcZ9Q/ClX36n2FgYps5
         0usqT/GDz9jqj28ub28cF4KTX5zk3WqlvdOZrhHNBuWFGxS8nHzYR/uaI8JTf/lKy4vi
         fIk1iquDnboAXvIuVAeDYrQxSWxfaWnG9MZ2IzNDBGBMtrpKv4wVUgLJbtO0N1623u3h
         bHHX/J7Ekox99qgRhCDeO/wW1Ig29xQaeOTBxx99U5pefU3wVf+pr604Kob5qu15bQJP
         5FbHb7Kl04fl8d3MVr/FAtC3Ec2HQhwvj+9bbmmeYMMQEijraCRF2dESeGiTEKuKe2AJ
         Ovtg==
X-Forwarded-Encrypted: i=1; AKwUvBxoERRcDD6cT9QfRuhiRYHMq8hACZ1Q8v5QZBHjA5DopaU7a3H2jt4djUbxQr6ZgfNGwC2Z4yDwBbub2vm0@vger.kernel.org
X-Gm-Message-State: AFq9FYIblWul1UmfWRAa8jyGKBkmudpPHhypDvYkYqWDO8JN5AGjXc8A
	ATBZA3ytjZyRfTNSe1RJ1IEkx38rNJTIZmpvRODCOXmdGhtKfMK9QgSiCW/KHrj74w/IM0a1ip0
	LUQ4ODxPs7rgqjmRGBoYEMK5rAlgaErk=
X-Gm-Gg: AYBFou1fyLi3dHq0rMHX8u/3dwtTMpSpR0yFu3JgyklCrXRgely7mUTN+JQsnk2IffJ
	G3WCuwRWG7ebsSlu59wLe/0GFl0JeFJzcQCBrI8UtduoRuVYYaEO0Ufzry9Vm279PBTZoDb7haw
	cJ83zMDNcDG8u56jT+09rsfcLzJqAFtMtIntY31+zJwCHVESxKy28yGa0+ROfJZZr654e2HF5Mj
	ndaDW/nrloQzN/nhIzVhEhO9aSwuGKXQ0PP6v5Kqepk2LpYijQakT8h/1U/JzycEup7zAuC+nFk
	5WeLJCy8Ejp/xu7XYUmckfVqGbGwFNcQEACwP6e7Vy37HwggsxMaX3A0gVMS78IRoz4=
X-Received: by 2002:a17:907:3e05:b0:c41:10ca:b4f9 with SMTP id
 a640c23a62f3a-c4110cabb6dmr32561566b.20.1792137577402; Fri, 16 Oct 2026
 00:59:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxhX_neohTAjZDOT0oSWC-JNiqNWqnfE5YSa7Ln05QPQ-A@mail.gmail.com>
 <20260824204534.1951414-1-fahad@codepure.com> <CAJfpegvbvmznSSdjZH_XqrGZHWgwb4fGux80h02ncopBC48RqA@mail.gmail.com>
In-Reply-To: <CAJfpegvbvmznSSdjZH_XqrGZHWgwb4fGux80h02ncopBC48RqA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Oct 2026 09:59:26 +0200
X-Gm-Features: AclHuK808ARhKGpUcEpEJymoXXkrPYwYvO8--c-MHfLrBM82Xx-BFnxmgYwNSJM
Message-ID: <CAOQ4uxgZRdWYdBCqhbz1FyH06WM8cLub6ysbqzP05FcAyah6yw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fortify ovl_copy_xattr() against underlying layer modifications
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Fahad Alharbi <fahad@codepure.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 10:21=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Mon, 24 Aug 2026 at 22:47, Fahad Alharbi <fahad@codepure.com> wrote:
> >
> > TL;DR: your patch fixes it.  On v7.2-rc6, FUSE probe LEAK -> NO LEAK, a=
nd the
> > unprivileged tmpfs racer goes from 78 of 5,000,000 copy-ups leaking (5 =
of 5
> > boots) to 0 of 5,000,000 (0 of 5 boots).  51 of 51 functional xattr che=
cks
> > unchanged.  One behaviour change worth a look: under a racing lower fs =
about
> > 6% of copy-ups now fail with EIO.  Tested-by below.
>
> > Tested-by: Fahad Alharbi <fahad@codepure.com>
>
> Thanks for the detailed test and analysis.
>

Sorry guys, I guess I dropped the ball on this.

However, on second thought, I prefer to break this up into two patches -
the smaller backportable EIO fix first and then the ovl_getxattr_value()
bigger change which is harder to backport.

I will prepare this for ovl-fixes PR.

Thanks,
Amir.
