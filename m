Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795004339;
	b=MF3pHl4f1WKyR4f5nx7o3h4fuCSTb8O1+bngWEratrRairLDARwrE4yI5jlp7+SsAgYl
	 5qWEYMcyg57S5sm1c9fxwt25IDuG/SbbUW1TvFhm7i3tKd4NNfsLPbnwp6LAckR46xNS3
	 ppJ0t4BTzctE+1kjXHa95Vd9REjidit5dfI2o678LFGXU3uWHDSZNSMdit7XxZipN2zDZ
	 85MCK1m4i4WqnlHQQIROz5sLXbZdIikRJY4V6+SMzzcbNmfJJSqNFHe/dYznc/vebTsUx
	 vrs+mPIPl+Hjs5CtaGHLpMC7jyQgCSOjwUk37kO6g1Za1CILIwo3KyJgPtL58jj31uA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795004339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=o9aKWm+SqAHOn/oQI+zXHjehk+aUQHjPL9nMoWUaiPk=;
	b=mA8NeDxL9Z3cBPxIUS+7VHO+J5EglosLeIS07QJjOWYx7yUSszGm81ZlrhJphG/R5RGG
	 7mdT3We/DbHkBUljmhUCiBE15qNUae6KsKSw6SCjuZ2Z7t3bWqyn+RDfyTYQSe0TQ1nN5
	 lhwiMavOLC/ePxsBo+JBAnAQPqxC7OjvIdmbpoYEOPiqxQI248jvumME8BZeHvo3J7Ahy
	 ITEOQnbG9m8N0F1Oe3/S1GRbr92vz0Zdke9eN3YQght1BEq+76SD+wBgNXLvW4lT9eRIU
	 XNlFV7F6wohKL1hGHQT3Womtal7nTIb8gUqyYALQBjfMFjbLu39FG5SGO2CMzkEFVPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kgpzyzFD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A11606A320
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 12:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5A11606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kgpzyzFD
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b86fcbd647so1521447a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 04:18:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795004337; cv=none;
        d=google.com; s=arc-20260327;
        b=me6WCQyE0GR5/ndEgYnXxKuABqAVWnC3qsFxyUXLjunMkhKC+nGxJPDhSIAqCkuGbu
         UfzIkgu28t6DsyawYpPmkdNVH7gMSJBpIX1DYIHNhi6qPE6DFNTir85qNesu6YqOe+4H
         GgwZzIOlWlrjQIohDhkWqgiA27Nd3YZmBQT8qy4pLw5vMUHDTlm45LhJkw43BeN4WIll
         2V4lNGiT4nmeaqbkjBLL2Uiw75ABCVpE5DQ+4ZViGpI3nCWnch8Vt8MVJqCh9jOlJ1dL
         08p5s5PlIPe/jXg8Mz3d0zzLilSczrWDFCZamWw+keCtCDy5Ea+NXAKJISNvqkhzgwD3
         pzeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o9aKWm+SqAHOn/oQI+zXHjehk+aUQHjPL9nMoWUaiPk=;
        fh=ujibTDMvLSj/hcU7Fe0V9mB1ntaTq9N3nXAQvwfeYAY=;
        b=m0BSjNh8q4IXh3e0Z3k3rU6xXUMT52sTRjZRchsHehG1CEIPGUWbtlc7xmCVISsgzb
         Y0F9rxtrk13N5Ur59lIsNUgjqj5C0WzKYxcxNAaM/SO8cvbdKs/n42h632f3jUXgzUKz
         ctrdmPUGdpLAILt8Np08V082mGxhHRyhhORylUinQWCvVYboQcJzD4vIpoAbzoOXB2sI
         HBMCmxwvnDT14vjInRDNi3KHucsywTEJKyy24uDiJnHuMSO3Oa+uNVZm7CwSV0SHAxEk
         qhp4X2dCnmbQ+39tW18k4+QFwBpB7Bvd/z/f690fWqkITLzVqKMmnlwUeIjNUyPRVUzV
         E9Cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795004337; x=1795609137; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o9aKWm+SqAHOn/oQI+zXHjehk+aUQHjPL9nMoWUaiPk=;
        b=kgpzyzFDoGYIXwu2LZPf/7z9Q2nXwRR4+/2w+5VJFN0eBcfTLr73QEZk3oU22iCP7g
         FWA4Nir6Im0Kfn0IxDtaKoGjjDH6r6wexNqZKg9mEtWr1mTUSssLDH0HpAtMD807Tuno
         BdVmXZlr9uvc5AfkAO07AZNpEoSzyPgpQ0CmQGZSI2Bw5liDvzgLTw6B4GkM3dKe4t1x
         LF6nYH5aD6jULUhNFyBx3zwNPl9nBBILXDWsSY9XaxzWTpw2vt7SGYn9h5otgRfRAnvo
         ZNYCqfuCLQdOtbn6OFm3CX2S3RIQkRJ3RGeJ7z7C9KJxyp6BMC8UhUH8VfbIjhxYDBMO
         S/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795004337; x=1795609137;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o9aKWm+SqAHOn/oQI+zXHjehk+aUQHjPL9nMoWUaiPk=;
        b=Iv1mxr3TALnvyyiAAIeXEmR5kcupBIuzDZ/kPB9vARrbHPP3womqj0hIdNrc1BE+DY
         acfIoN5hh/xQXh05x36LfoWIexGeBYbjnLzm8JPlgJwj7oCcwcPUfrA7E3BLcjVt2YCi
         ApfwFzAenYQ3omPpvE12qoQJp/g3DMA5MnJz8+3ZsnscM9zdcXb9lF6CEVhKu+F3DpYO
         6dDjZHDJjJ0QCpaj9t+yS6RLnNtd4j4fzmZWB9pu+t+7DVPogoUIxLrUzydkW7zpcGPy
         r0k0mypAoYomAxfCJrcCJbfQA+mm415T/tJxP20S41+igERgig5qB16oNfdZkNsYQqaC
         Oz2A==
X-Forwarded-Encrypted: i=1; AL+hErEaZilD3p9PZWqsBxm09D2hjsM0/laplJ5+wZgrAVHApMLBWk5jqNop515ZJNuSc/IOjGIAegGMmtvg1fQ9@vger.kernel.org
X-Gm-Message-State: APuU4Z+inRXY88SMGPxdASWKsKy6/T88f7Tzvq69dZGRYgmnEkmTM0g+
	aUrr1mAPXO79+2pn+DMdG45KDUsdy+fg0/rDx+a9Bh7Yetvbam5EyL42WMpV+DFsVYl3wnfev0m
	z4Q3j2EUZKJ8V6plfQzk1O+/u4HNHH2k=
X-Gm-Gg: AYBFou0jc8theMbX9hekdgdfp4gPIDgAGuPqmLub5YB1Oz3VmkUI6OVBILygNqF/8ge
	AcqpcehVmSWM2A4iXMkpfIfNzZCqOgmEyrEQ6DWCQdSJr8ipBzKI0wWF/Lx2SVbwXgP6yOMbn76
	PItwIUrIostcqd2z/4zDeoyQKXqii/1oP8U449QXK7wsNq8XC3F55wSJkgDoAEf7h/sp0kzDB/k
	Go3tX59xW61amzeZLLgxWJ99flEKg/PpUhE3XV7x1L+KbnQ6w1GKUUY8/ZbY8EaK3C3oy8KL7vg
	OHcOzJZ1EuT/mxKhI1u78IkZego+kAAWsnb7/x43/X4Mg0LphpFRaLLv2myEAKnbLLnj+om30Ip
	T0DI/FN4HxoazdDjjXXAttoPGQd9KpI3J1cvHFBVJKET0Jln+VWeqQKYxNMTd4TYW0sO3zQ==
X-Received: by 2002:a05:6402:446:b0:6b5:669d:a4aa with SMTP id
 4fb4d7f45d1cf-6b859bb8770mr3421492a12.20.1795004336484; Wed, 18 Nov 2026
 04:18:56 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAOQ4uxg5baphOjo+_A=3nZBmFEmMV7KOiv_W=rjEVYV41eTEaA@mail.gmail.com>
 <20261118113241.29101-1-dingf3ng@gmail.com>
In-Reply-To: <20261118113241.29101-1-dingf3ng@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 13:18:44 +0100
X-Gm-Features: AclHuK9FoYJUa1p-vY7Lz3sAya4iQaiog_UjZvBgKmW500nBxyznHeTRsAFiz5A
Message-ID: <CAOQ4uxgk=Teyci_b1PVaTgDip-UHXXsnXFCQQatFTSVxSHynYw@mail.gmail.com>
Subject: Re: ovl: sync_file_range() does nothing on overlayfs files
To: Ding Feng <dingf3ng@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Josef Bacik <josef@toxicpanda.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 12:32=E2=80=AFPM Ding Feng <dingf3ng@gmail.com> wro=
te:
>
> Amir Goldstein wrote:
> > Like this?
> >
> > Completely untested.
>
> Thanks, Amir. I tested it on v7.4-rc3 (20eef29b7c84), where it applies
> with an 8-line offset in mm/filemap.c.
>
> Setup: arm64 defconfig in QEMU; overlayfs with lower and upper on one
> ext4 disk; periodic writeback off (dirty_writeback_centisecs=3D0). Each
> case writes 64 MiB (16384 pages) through the overlay and calls
> sync_file_range(fd, 0, 0, flags). Dirty pages are read with cachestat()
> on the upper file's ext4 path, before and after the call.
>
>                                    before patch       with patch
>   ext4 file, flags=3D7              16384 -> 0         16384 -> 0
>   overlay new file, flags=3D7       16384 -> 16384     16384 -> 0
>   overlay new file, flags=3D2       16384 -> 16384     16384 -> 0 (4096 u=
nder writeback)
>   read-only fd opened before
>   copy-up, written via another
>   fd, flags=3D7                     16384 -> 16384     16384 -> 0
>
> cachestat() on the overlay fd reported cache=3D0 dirty=3D0 before the pat=
ch
> and cache=3D16384 dirty=3D16384 with it, in all three overlay cases. All
> calls returned 0, and the kernel log showed no warnings.
>
> Tested-by: Ding Feng <dingf3ng@gmail.com>
>
> Two questions:
>
> 1. FUSE passthrough also keeps data in a backing file
> (fs/fuse/passthrough.c) and already forwards ->fadvise(). Does it need
> ->f_real() too? I have not tested that.

Yes it does, although FUSE does not have d_real(), meaning
that nobody probably tested uprobes with FUSE passthrough
I don't know if IMA/EVM/IPE are applicable to FUSE.
There is no obligation to implement FUSE f_real() from the start
if sync_range doesnt work now it can continue not to work.

>
> 2. In the copy-up case, sync_file_range() on a read-only fd can now
> open the upper file and return that open's error. The man page lists
> none of those codes. I assume that is acceptable, as a write would see
> the same error, but I wanted to mention it.

The man page never covers all possible errors
especially general errors like EIO, EACCESS, EPERM should
always be anticipated.
I am sure this is documented somewhere but I don't know where.

Thanks,
Amir.
