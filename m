Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811E43AC26
	for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2024 19:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706730560; cv=none; b=hA66gljkfOVb9ATgcjKe5arJQilo1Fg6tE7pQD9QQOIxbDG3hBlQQjh7/N20Gzs8QB8NdU7mKh5LwPZpLxIEw9ts5E0Cou32nQWjAcRiAmajBH433XqYu0KzTjSKkXat5HeRe5NTykvgVjm6CnKQPg9R66xLrADa11n+AAuzYWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706730560; c=relaxed/simple;
	bh=tZcubABWP4p+PUyhfH6FzH0uYN3/AZjH0UMh30BsGAk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hxy20+uutXb5GpR3D5g0HS1oUB2x0p26+fpN1FQMFvCzXsojnEN43HzcwCVxop3oPg6ex2mw0zYExwK8JRnBqxW7dW0EWFnnt1mzsMoHcbOu8THnctYWQF2AjMlDGYmHpqO8xcz3pDIz9QiKWOEKPioracRH7v28IodyhkQd0Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=nWs6NzYV; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="nWs6NzYV"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a35385da5bbso16116066b.3
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2024 11:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1706730556; x=1707335356; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w4m92Mg3PsLlecNHbIrvq/RMmBhqIGNNfRvOCBsW06g=;
        b=nWs6NzYVdMA1rbfYpj9pwtxVLh/tL2KvOiez2XbNN+Csya/CkPW1xxBGa7rUjMbR0m
         2D/eXEFHyrqADx/cFuZkjBHCKwW8fZ8gsuExN8ymJUZXGIQ+xPFPCX8rN9YR+CPZzjLR
         /zE9zJgB5jTCPQj6ToxgpDOiO175+PkqCTuHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706730556; x=1707335356;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w4m92Mg3PsLlecNHbIrvq/RMmBhqIGNNfRvOCBsW06g=;
        b=kAHKqe1gWCJaZUcrluiXk9IPNeuaTlCG8r0Eq3/arFzL4YtLYBX+T00IZwfzM/NKy+
         X3Qx6wNkrGL/0YGyi8C3u4CE15/extjmvJqHtQOkY19KFmc5ou3AvscjEjpeLEV5+4kd
         Ma+chmqsoFbN4i6K33wjxZL1LWNx0/oZXK4kXnaMKajY8c5AEONP6Qw+XPJaNooTTyJF
         bKKYg2htQwPLi4kzS+iq4jxM9Yp9hAaLPx67NW5gAuA81jfQVeh65iEgpGqzx3ZZJp46
         tm8nKw8mg7adkjQqi2aHIt9el97u5itsjxjaGJFuf7lB79mSsuirOZP4rvo++vNyZ4kW
         a3lw==
X-Gm-Message-State: AOJu0YzdEbyLNG2blYS7zBI0OzGPQFjETvL2wMESq919LWt7ij4EWgCi
	FTkXxXtl8z5nU0vV0nsi2uKm+P8D7WGvRvBzh6U7SxXVjJQXWFZjBuqMrcT8Sesp1eFH5YaOsp6
	Ux7/RwQEEHaaeLFRNzgFpFLxfMVbYKyVBT5q8Cg==
X-Google-Smtp-Source: AGHT+IHVYHuwadO5hyl6t0OmWzVHrSNscBOHXCRtlHwexAU0/RB7Ya+T4rewpZRYpgtj8PqFc3QE7gtiQpCqTa2uo5w=
X-Received: by 2002:a17:906:5acf:b0:a2f:68cb:dbe3 with SMTP id
 x15-20020a1709065acf00b00a2f68cbdbe3mr1757941ejs.75.1706730556370; Wed, 31
 Jan 2024 11:49:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <VI1PR08MB31011DF4722B9E720A251892827C2@VI1PR08MB3101.eurprd08.prod.outlook.com>
In-Reply-To: <VI1PR08MB31011DF4722B9E720A251892827C2@VI1PR08MB3101.eurprd08.prod.outlook.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 31 Jan 2024 20:49:04 +0100
Message-ID: <CAJfpegvBc+Md51ubYv9iDnST+Xps9P=g51NcWJONKy4fq=O8+Q@mail.gmail.com>
Subject: Re: [overlay] [fuse] Potential bug with large file support for FUSE
 based lowerdir
To: Lukasz Okraszewski <Lukasz.Okraszewski@arm.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	Matthew Clarkson <Matthew.Clarkson@arm.com>, Brandon Jones <Brandon.Jones@arm.com>, nd <nd@arm.com>, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 31 Jan 2024 at 17:38, Lukasz Okraszewski
<Lukasz.Okraszewski@arm.com> wrote:
>
> Hello all,
>
> I have stumbled into what I suspect may be a bug in the overlayfs/fuse stack.
>
> The repro script looks like this:
> ```sh
> #!/bin/bash
>
> set -xe
>
> for i in large1 large2;
> do
>   if [ -f $i.squashfs ]; then
>     continue
>   fi
>   mkdir -p $i
>   pushd $i || exit 1
>   yes $i | head -c 4GB > test.file
>   popd || exit 1
>   mksquashfs $i $i.squashfs
> done
>
> rm -rf work
> mkdir -p work/{lower0,lower1,lower2,upper,work,mnt}
>
> squashfuse -o allow_other large1.squashfs work/lower1
> squashfuse -o allow_other large2.squashfs work/lower2
>
> trap "set +e; fusermount -u $(realpath work/lower1); fusermount -u $(realpath work/lower2); sudo umount --verbose -l $(realpath work/mnt)" EXIT
>
> sudo mount \
>   -t overlay \
>   -o lowerdir=work/lower2:work/lower1:work/lower0,upperdir=work/upper,workdir=work/work\
>   overlay \
>   work/mnt
>
> pushd work/mnt
> dd if=/dev/zero of=test.file bs=4k count=80
> popd
> ```
>
> When writing to the file I see the following error:
> ```
> test.file: Value too large for defined data type
> ```
>
> The file can be read just fine, stat works.
> Mounting the squashfs with sudo and a loop device does not have this problem.
>
> Now, dmesg shows:
> ```
> [Jan31 08:38] overlayfs: failed to retrieve lower fileattr (/test.file, err=-75)

So this is a FUSE_IOCTL/FS_IOC_GETFLAGS request for which the server
replies with EOVERFLOW.  This looks like a server issue, but it would
be good to see the logs and/or strace related to this particular
request.

Thanks,
Miklos
