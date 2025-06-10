Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C316BE46;
	Tue, 10 Jun 2025 18:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749580457; cv=none; b=kNdremgWvq2qNnTonzYf0PrhV5T0WAaCiHTrVv6PrLX01X2rkmggdkbPulW9qY9fVInL/loPv5AMMHFx+9wY97WJF86atgflk4d3lIZgdxLKH/GoV3A/TAY373asv1+DGL3uOeE91uGe8QbPfFP6iY4GyuTjlxMQRk7dMckMTXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749580457; c=relaxed/simple;
	bh=Cr7X9XzeoPBio6ib8a+QBePtg9vRuQRKXhAvaq/eeX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qjuFKX27razvEAUG/vnGlVL5O5hum4QJMTfHQ2qCIP8w38+lzS0S8kCpydxIezqKI0e+RsXyvxoAWeGxthF6VpnFueNzoqDkZGLpybp6us/IsTkiBZA7c88sSGFCkqrNQREzOm/8e+FPOomAYaLMI90FQ5NTME4/6sAHumPClng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S7Pwunln; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S7Pwunln"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ade326e366dso647678666b.3;
        Tue, 10 Jun 2025 11:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749580454; x=1750185254; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DzDAtX+NyDwRDryEYU0ikeP3dQqUBfBgUAOUdFfFYFw=;
        b=S7Pwunln/LVAVjjybEe4ShAa8uS/OK09+2lLHihcQC/SfDmXOwC4e6SjwUOJTDUxz6
         Qw/uYUnawzXPYmtuE26X8WvjQCcCVS59X60qZ4IPiij6YlRNNrAMO6PLYAh+Cq/43qUa
         lRzYQdmaLfLyFlm9lFVuUFx1VXrF3v0Z1bAmSBLJ/0Rixn3Ff1vHlf1f/M4OZsEAPSak
         9YiiBy1J5pxPTsyG/Jy/tUkIuCybJ/5g0w5yC2jPjctusqkUwkYW7TwMu8OzL/ROexqz
         uQRbyzZq1esO/pwNwv5RGfKp2kBeMRdthtY2sg2V62WCEVt5uKABPUOO7tb+rJi/oVpq
         0rEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749580454; x=1750185254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DzDAtX+NyDwRDryEYU0ikeP3dQqUBfBgUAOUdFfFYFw=;
        b=XkFqQnbpAqOBhX0qc1Me65LcUX4Twin0SeJIsTas5jFKklgKAr48qMiP6bdpMuWF7M
         EwEvJnXSHlBFD0x2CaxSyqb2bqHLq6waiIb+y/7Tb7jh9YdESoPZUG0so40Piiz1GqpM
         zf1sgEjtNq0pyM5vngx0ISqkCYMPqholmtVCVDXxy6xCyBGE9fJhQSee6k0qQkrusMdE
         swLc1QTh0zge++4ywS4C+hfRkb9sDdiDzoed/9krswUiPLiTpJ8ZKYMo6B5myB0wyPvO
         F4RpykuUNKx2TKip7JxRVa4PCZzqveRjFp/m3DZkcXxkD55IEz+FHvLle9koEePoGyv5
         YMRA==
X-Forwarded-Encrypted: i=1; AJvYcCU4CYrI3m1UuacPYovR44vc0x4YV4aE0Fw0ajC4MZV4NhXyFg9hzj5vrUhe42/WbXBEmZ0bqKkN@vger.kernel.org, AJvYcCVb/F8th0DMAH+z/Uu9HhAfhQ727btTEL1FjHOJXZ6wjRTYv32offEuuNx9/pKYxvj1as1P2suLVDCAy+UIaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyF73Rmi3/WsvE7iz9qBeRbtGtDzMzSojVRSoWSBvd88vsTVgtS
	v/vc2Tm3v+7xOGQM6ozViV9/oiS92OTybUrAWvO6xPNHUAYxCzaUQ1sXAk+k9KpPDLWiOSPbkKf
	zHZxZuAGDiB6sx6RJGRoxHuvzvV2GxDMrUpox
X-Gm-Gg: ASbGncsIGdV0Oi6xAOAYXoXtPkQICHRDk1zznEgZT4rwQriQ5jS/Ig7l7vp7izqbLOi
	cEtOYxhKsjRWkU5U1W7P1eNE4TeGfOet7IGtm50cHE/R329cwXXVGAGUS6+yaYgbZ42xeKbPgab
	EYCVFLC/TV7p0d1K28OG0dHqHnnk3WVNE/ZRh5MVD8ES8=
X-Google-Smtp-Source: AGHT+IFhCXuW0w7n2vLXGbuTZlt1kUEwLCCo48pPPdXi6iSf46uiEhhK78YbCQb8WOaZ+5iv62KNs2cn+ad83KJMksU=
X-Received: by 2002:a17:907:3c86:b0:ad8:96d2:f3e with SMTP id
 a640c23a62f3a-ade895314a7mr33342466b.22.1749580453524; Tue, 10 Jun 2025
 11:34:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609151915.2638057-1-amir73il@gmail.com> <20250609151915.2638057-3-amir73il@gmail.com>
 <20250610144206.GB6143@frogsfrogsfrogs>
In-Reply-To: <20250610144206.GB6143@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Jun 2025 20:34:01 +0200
X-Gm-Features: AX0GCFvFDqogjAMY-2yd8s__3UyEaVF-8G4wf-iB3Btcnn9ycPNQoFLoJdQAEjE
Message-ID: <CAOQ4uxiyAu7vkf1WK4f=FPOWLGT5iish4KpscqK=GpTAX6HSQw@mail.gmail.com>
Subject: Re: [PATCH 2/3] fstests: add helper _require_xfs_io_shutdown
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2025 at 4:42=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Mon, Jun 09, 2025 at 05:19:14PM +0200, Amir Goldstein wrote:
> > Requirements for tests that shutdown fs using "xfs_io -c shutdown".
> > The requirements are stricter than the requirement for tests that
> > shutdown fs using _scratch_shutdown helper.
> >
> > Generally, with overlay fs, tests can do _scratch_shutdown, but not
> > xfs_io -c shutdown.
> >
> > Encode this stricter requirement in helper _require_xfs_io_shutdown
> > and use it in test generic/623, to express that it cannot run on
> > overalyfs.
> >
> > Reported-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> > Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1=
493d94@igalia.com/
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Makes sense to me, assuming you don't want to try to integrate the 'open
> shutdown handle' dance into this test.
>
> ioargs=3D(-x -c "mmap 0 4k" -c "mwrite 0 4k")
> case "$FSTYP" in
> overlayfs)
>         ioargs+=3D(-c "open $(_scratch_shutdown_handle)" -c 'shutdown -f =
' -c close)
>         ;;
> *)
>         ioargs+=3D(-c shutdown)
>         ;;
> esac
> ioargs+=3D(-c fsync -c "mwrite 0 4k" $file)
>
> $XFS_IO_PROG "${ioargs[@]}" | _filter_xfs_io
>
> (Though I don't know if you actually tried that and it didn't work, or
> maybe overlayfs mmap is weird, etc...)

I did not try it.
I had briefly considered trying and decided it's not worth it.
overlayfs doesn't have an aops of its own, and mmap results in
a memory map of the underlying file directly, so the test will essentially
testing the base via overlayfs which does not add much test coverage.

I do not object to making this test run on overlayfs, but I do wish to
keep the helper around for future tests that will not do the dance.

Thanks,
Amir.
