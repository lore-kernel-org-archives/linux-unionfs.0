Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142141F8691;
	Wed, 28 May 2025 06:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748415306; cv=none; b=L/3oAkHPLzi9nbAj1LdxxBk5I6IYHXYWXkGOgVIqyB8UX003Ut8IfS0E0CMhNO9wJvrhVlg5Y4gMKk0RMW8FAxPESQsvKRXCsdjBmkwJg3eeZ8MzYwpcHDk7tY7xyZrhMkH01QOsqizfpFwRZw0n4PW/gPbqjKENtKk0CkYxSVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748415306; c=relaxed/simple;
	bh=2WYfsOqsaZ8JJdSmO+sLxARi7POgt1yzChzWajAkBzo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hIOquo4+RoVbSWMAPr8U9cweG/LhtCtdN8YTx/DwJVpgw5V4iK1PR1SQjkGAmXzwSXlnYCRuvdnvYdnFrpvvHIGfekb8DTLyvWLUYncVqLJZB/dY6eo7lI4/VQuhABYCSpHNAG5LpdWlWEXXU7Lte4f+/JhXkg8pwRNYphGTuJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lM1SmOqg; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lM1SmOqg"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad55d6aeb07so40737066b.0;
        Tue, 27 May 2025 23:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748415303; x=1749020103; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7W2Ms8pfk+051RGBTnXZb7nef2LszwdmkgxOwlEO/j0=;
        b=lM1SmOqgT+tsOpnX4fEFOUk3V/s71+nIHuAjc+K7T/BcgzlkFnI1gpUEDXKlPeoqVh
         pES5R197ARQ82PkfCOGIa7G01qEmDCtNbLGGcjHZYrX5l7cl1n34lTD7yloZrcEBciLl
         SdcH9LXTMkFbtjQAwxYSN9nRf6EUWKQ3nFki1dYtlN3mXOGz3XaXpZYKCrfivjZEre3B
         FWvP3SuyHz0m/9fWQwvE1aeGFwmZhsvegrh/YRvXA0aHW0MzGCJmXE41jLvgZRe3aTZF
         ciXdAj221TPkhfPgL3QZ5/YH+qphFKEvpM6benYX3C6DYbN9ZH2+uKTvkiiGYkiGdl/X
         5itg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748415303; x=1749020103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7W2Ms8pfk+051RGBTnXZb7nef2LszwdmkgxOwlEO/j0=;
        b=MMtUDREGQzCzjwcvACuG2HZakT81tWjje1K8LWA7Lnim8C+kRIuTb6JgnzhHQZXr73
         a0hEHGPthMr6OM7YhOzFeMveaXaR/wAfKuHl7FjGgRioq/xauMUFfdH6j+5MK0N+b1bE
         aqIKeU16gZFv/MMu4quOJuT8g7riPj4MckIGxQMdsME/FZpUKK3eODuc96ttW9c8cjNC
         +uOLrLLfgBo/JYyE4kFYhZbph8Cz1VHmWnU89Y2rGQzPaedbxclzG0/WjdNp2lffBUBU
         s7hKtQxWkw2hefX1t0NZjwKFojCtJZd+Dlu2HhyWMT4FIClS29moww6de7z7/SAl8wEK
         Cs3g==
X-Forwarded-Encrypted: i=1; AJvYcCVEW8Io39dkG/Te8CAaGJ17Ze54+2LETTp/Ly2wZS4AimdY72m+3lOA5VVHyNTojHazKgV70uUR@vger.kernel.org, AJvYcCWashIPnKDwayuwppcNwFnP7If/o2eoXE3ZEmaIjujiS6/J2beL22RgQVAgDIZn62XwuTtWyCswl6tlf1R7sg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEoigWglf2laanRrLM28iwzvhhd7NEBSOYmDwAAUrAT7/GC5h7
	5Y93qFZxtqcvDkJ2N+9KzUyphI3xgnj796vNGumNqtFM4jEhPPEfAmkdGeA9+W73bP3Wzdys6L2
	08Kk8U/wF/Qsv3bkKZMZKvLm1RGiW5is=
X-Gm-Gg: ASbGnctYowFIpvrMDIfzvQRl6VRjhcEQ2egrVeetC5AiH4uRY7gFlXXhWxqvV98ExKA
	59cm4oTBgKBbhpGAttfHekpKnynTczjy5M+a2wLXSyflw2HVljHENNnk1UvDVT0YY/FLhpC7zre
	Hxh6hgs5l9wlFYWZrG/D5nWWUEKUTJ30/M
X-Google-Smtp-Source: AGHT+IGadAGNcFcdAdb/04exHSPXgTFKB0l4KBUiWi6IfjylhVErO0YgD4ptGNDymmPAMQwLLKRTS98z38/10DlXuzA=
X-Received: by 2002:a17:907:3e8d:b0:ad8:a41a:3cd2 with SMTP id
 a640c23a62f3a-ad8a41a3fd2mr51728866b.16.1748415302753; Tue, 27 May 2025
 23:55:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250526143500.1520660-1-amir73il@gmail.com> <20250526143500.1520660-2-amir73il@gmail.com>
 <CAJfpegtYTpJXYOiyckcfQA=YTVXcLQZRGV4=sjueLenJpTp7Lw@mail.gmail.com>
In-Reply-To: <CAJfpegtYTpJXYOiyckcfQA=YTVXcLQZRGV4=sjueLenJpTp7Lw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 May 2025 08:54:51 +0200
X-Gm-Features: AX0GCFuHYFk_biWx-ebgt8U39p7yb8c0byoygBlXpzvyI_2EOsdljoIK7DwTqwU
Message-ID: <CAOQ4uxjh9u3DE_HKExa=kK08efzDsxVuCVuA0tUMjwSeLX=jnQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] overlay: workaround libmount failure to remount,ro
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Zorro Lang <zlang@redhat.com>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2025 at 4:49=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Mon, 26 May 2025 at 16:35, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > libmount v1.41 calls several unneeded fsconfig() calls to reconfigure
> > lowerdir/upperdir when user requests only -o remount,ro.
>
> Isn't this a libmount bug then?
>
> Working around it in xfstests just hides this, which seems counter produc=
tive.
>

Yes, to some extent, however, IMO the purpose of fstests is to test the
filesystem and the vfs and for very fs-specific tests it also tests the
*progs utils.

I do not think we can afford fstest being a test for libc+libmount and the
entire ecosystem. That's part of the reason that fstest implements
some of its own utilities to exercise syscalls.

If we leave the tests failing, we will loose test coverage from all
the people that are running with not-cutting-edge distro.
I don't think this is a desired outcome for us.
Test coverage for remount,ro is pretty important IMO.

FWIW, we already used LIBMOUNT_FORCE_MOUNT2 to workaround
another libmount bug I believe you were in the loop when we did that
(see blow).

Any other idea how to address those libmount bugs in the test suite
other than keeping the tests failing or not running for libmount >=3D v1.39=
?

Thanks,
Amir.

commit 30fc8ed13aa241e7caf1c27d1b60c64ab3ae7a18
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Mon Oct 23 19:32:59 2023 +0300

    overlay: add test for lowerdir mount option parsing

    Check parsing and display of spaces and escaped colons and commans in
    lowerdir mount option.

    This is a regression test for two bugs introduced in v6.5 with the
    conversion to new mount api.

    There is another regression of new mount api related to libmount parsin=
g
    of escaped commas, but this needs a fix in libmount - this test only
    verifies the fixes in the kernel, so it uses LIBMOUNT_FORCE_MOUNT2=3Dal=
ways
    to force mount(2) and kernel pasring of the comma separated options lis=
t.

...

+# Kernel commit c34706acf40b fixes parsing of mount options with escaped c=
omma
+# when the mount options string is provided via data argument to
mount(2) syscall.
+# With libmount >=3D 2.39, libmount itself will try to split the comma sep=
arated
+# options list provided to mount(8) commnad line and call fsconfig(2) for =
each
+# mount option seperately.  Since libmount does not obay to overlayfs esca=
ped
+# commas format, it will call fsconfig(2) with the wrong path (i.e.
".../lower3")
+# and this test will fail, but the failure would indicate a libmount issue=
, not
+# a kernel issue.  Therefore, force libmount to use mount(2) syscall,
so we only
+# test the kernel fix.
+LIBMOUNT_FORCE_MOUNT2=3Dalways $MOUNT_PROG -t overlay
$OVL_BASE_SCRATCH_DEV $SCRATCH_MNT \
+       -o"upperdir=3D$upperdir,workdir=3D$workdir,lowerdir=3D$lowerdir_com=
mas_esc"
2>> $seqres.full || \
+       echo "ERROR: incorrect parsing of escaped comma in lowerdir
mount option"
