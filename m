Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC40A2D6409
	for <linux-unionfs@vger.kernel.org>; Mon, 20 Apr 2026 07:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776671962; cv=pass; b=j95wzI0Tt0+vIIhwOYS6afLc5o79T1xz6CSUJiv+MNFSD9RH1MASPfsZA1zuqrht3gYfItpOLxnOwLzqejqz75BYevmnAdQBlFn74slM0CHMs8hmD0TeuWUXvrOVOHiiwY4eFvMgS6z75V1S1ccYljatefHoyV2Zi1dGkvnre9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776671962; c=relaxed/simple;
	bh=skJ5R+wFeOukZf+cjPX17CzqfeE4aSfaDg5kcm2isn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rS3MM4lj7EIoh5EAZGIWUcXeABjCEAS2taQhEZbu8r07qINkD+C9WWLg0klbF8ZN/fMRjt7/TbgXVG70sX+z8iISyO2lZ6LOMQbOKLj1h8zmp9GsyVF5E9Fxf7hj0TiQo+bI6xmeQRddw3G4ptRIJa0kf8ndvnX0F65zU1nY1wU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SmCuiiLd; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmCuiiLd"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9358bc9c50so358455566b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Apr 2026 00:59:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776671959; cv=none;
        d=google.com; s=arc-20240605;
        b=dV8ZENzixKoGt3AgcUV0/1ZF+sGkDVMIQO0CLEuVM3sx4XXAXwPcJGRlIewAv6uxHx
         Nx8WnwLZu6gWGdbYtzMETcmnUHS7TMsY0kDI/3x0Y2H7yDhmNd3Gt1yavdvb+sGeEFPA
         StLacY2vryHyMyCIJiT8MVTiH2mZS5fjvH+LcLg31ExhMguQkqepU3vZthxbMVATa0I6
         a2Bt9Dl8iX61i+t74L+/vKwIWhae0r0R8bxtcgL/BKRBqUeKpcqNmAH2u2RGF/FV74sE
         Rcbpg7fHYZdexQrR43dOVM8qHy7TRfqUB8m5OB2aNLWYujn7sZgiZ1J6287Nl7UqnlPw
         jWUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qX8bL6820CZ5JwymJvdCU8o9V6FV5GdqfCje7/oI55k=;
        fh=0yzybOnX92JUhxzfRQ+zv5+aY8C2k7VZ6nyEn/V1ZaY=;
        b=Kp5909Xv0DCoU8a8VDMm5NOLQuu/CWUzRffEuhUWzrUluSDBa3Qn7VrQXIFe3anHjK
         nMryjS2oybbDVHHZN7tTHESR8jDmkRBFb5NQZu0fwCtK6ShFWJxYuDHUlr91mPijQRxa
         P+/LF9hUeL63Cs/1N1y9MEZLQvXU6RKyh3W6ZLu0v665/CPhR+Z5XPOkqLic8TBDE0wy
         /4OiK7eepRfy3hzCCaiK+MUez1ZNepKvjOWoZYRswHE65Om4efJdk9gG3LFYM3Cu6Pj0
         8NNV7TJiVxTRaneEdKUV9E3rwRi+/Km82tBj0U+U3rlMBe9+e4YZgK+x3pdBsU1ObxMz
         XNhA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776671959; x=1777276759; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qX8bL6820CZ5JwymJvdCU8o9V6FV5GdqfCje7/oI55k=;
        b=SmCuiiLdwNXbGdWDg/x04t78lVcyX5bGk4E4xxNO2HBb/LDafKhWIhZjPfCTkCpkCt
         4U629ZeIPAOFtQ+OExNYoDizYy8QsrmLlmwjmnc3niWcWg9TyOt8qEVRGB9zSeyOCIZO
         o9O7v/TGjnwehDnHfHDTdBwrXiEOPz9LTFjyy+AjMIGFI3A3HnI2qkslePLZMsgwg2Al
         gPRD1ezTLBfDPpFPfrf6cGcGJFYNRjBrfXcjeoPGuFsIQlHZW0RMHORdu8orPJ3fDGtP
         ZNbCeuHeJH8pxZznHir1bo74x8oEIWmQqTeSjJbB0bz+/D9EDFuHZ72hGTzlVzMTtbLk
         j57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776671959; x=1777276759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qX8bL6820CZ5JwymJvdCU8o9V6FV5GdqfCje7/oI55k=;
        b=qLEU8+tdM+RWRRD3wWgqL8SOyID4Cmb61SLQK2f2U7dDTESM50fQC0C8AY133v21KM
         +b4QPhfZ13UNresCWL59uUYpYENddghQ4B0bhk+TxQXR8RIRDXLk9yMHPEhlAcxNXLS5
         HtETNHfTp5iNK0YwQBmKfaKGSs69x/tnxnn5t0cBGM+T0P9as5vJuUSszl1eBc4TcH3k
         FstgAsXc+0zwyyrL2LwNdL/nDxMif4RI38clYFTYPDGXHy2A4wFRzm+jXnkQaoFXcVuO
         zzmF416qZlx2Hjq45MceB5dgnvYiVtUKwtHcUAp9VR0lGo7OLtwfj2okO/b1uGMnpbfp
         FC6Q==
X-Forwarded-Encrypted: i=1; AFNElJ/K6l4RnfWEU3gRlizAgKa7t2O6x9TW7I2WW8SzBepzAdJSv9936qMR6Xca+YyxmcDG4qkovw05+4XjJ6MA@vger.kernel.org
X-Gm-Message-State: AOJu0YxBnenOCFG+I6mmsK96DRwbkxAuHUXo+ZSMyCPcHba6Al8toBjH
	usZAq8y//CAyVkYBZZWNxUFkCqv6obM+p0maPks0WCxSuH261RntkmoUJ7hdg8OgV9NB6xtjZFM
	6Rpd6vJJYvSvKq4qoUkKUHorRNWiD7/ZCS6ad1yk=
X-Gm-Gg: AeBDiev84V4N2Q+61c182Zs+rRlRMuc9lYszS8oA67ijYeobxyTj7xG+dkIdM92Synp
	VDKcEMkDicoHZTwcwFpaOSLM+BoL25k7YgWnJDIaLshn7zxc+s7B7JbwQ5EbXWNaqd0RkuJ/s5F
	M11MaTEm3lMcPJ548VbT2KkO3COrIuyIRBONHJKPe+SOVS4ocTqZRjTzsItlqFuDbzfK5LhQYLJ
	Gz3SDUMuHSNQn9rZz+5mZ9FBRPY+75N7LUugHxd9jE/Yojd5i7FDmXoT6v2vMXH88N7NG8BQgam
	BRwcvo1U9CSXNceaogQtLviemXu9kp9gx11Wx2X2uwAXObDdq35xU/UDi9vFmI8=
X-Received: by 2002:a17:907:6a16:b0:b9c:2c55:3384 with SMTP id
 a640c23a62f3a-ba41adf9231mr607331666b.31.1776671958701; Mon, 20 Apr 2026
 00:59:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHWLEDHfXZScF5jNDzgOxGXf-MBDcVNtqW0DbNz8Ra8rtcuL+w@mail.gmail.com>
 <CAOdxtTbwipkyAfDakLAB6aVp6YkPWtKpDdVDUTz88WDB-18HXQ@mail.gmail.com>
 <CAOQ4uxhUn6oCBuVJqZu+FcMx8XeAQHZbXFAGon4Xeg2SPLJW_A@mail.gmail.com> <CAOdxtTaWWu_7eJWu68zf28zHQP3Y--vXTfbGFsceO47BpN3qxA@mail.gmail.com>
In-Reply-To: <CAOdxtTaWWu_7eJWu68zf28zHQP3Y--vXTfbGFsceO47BpN3qxA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 20 Apr 2026 09:59:06 +0200
X-Gm-Features: AQROBzDzAqpFjrbD5bTYNQHJCrGk2bhPT57K41uT-FxOcAInwVKNr2-vgwcmqn0
Message-ID: <CAOQ4uxhCNhGinePrnkSfT9Mtf4o5FmBX7mTA2m4miCMOt3mJqA@mail.gmail.com>
Subject: Re: [REGRESSION] Return change in 6.12.80+ with volatile mounting
To: Chenglong Tang <chenglongtang@google.com>
Cc: Derek Taylor <ddtaylor@google.com>, stable@vger.kernel.org, 
	regressions@lists.linux.dev, Kevin Berry <kpberry@google.com>, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 8:31=E2=80=AFAM Chenglong Tang <chenglongtang@googl=
e.com> wrote:
>
> Hi, Amir,
>
> Thanks for looking into this! To answer your questions:
>
> 1. Production vs. Test Suite Impact
>
> The immediate failure we encountered is in containerd's integration
> test suite (TestImageVolumeCheckVolatileOption). The test explicitly
> reads /proc/mounts and expects the exact string "volatile".
>
> In default production, containerd passes the legacy "volatile" string
> to the mount syscall, which your patch correctly handles under the
> hood. So the standard "happy path" is not broken in production.
>
> 2. The purpose of WithTempMount() / RemoveVolatileOption
>
> Containerd regularly makes temporary overlay mounts (e.g., for
> unpacking layers). Because overlayfs rejects reusing upper/work dirs
> from a volatile mount, containerd uses RemoveVolatileOption to strip
> the volatile flag before these temporary mounts.
>
> Currently, containerd's RemoveVolatileOption does an exact string
> match for "volatile". While it works for the default path, there is a
> production edge case: if a user explicitly configures their container
> runtime to use the new "fsync=3Dvolatile" option, older containerd
> binaries will fail to strip it, and the temporary mounts will be
> rejected by the kernel.

I need to challenge this specific argument because I do not agree
that this edge case could be considered a regression at all.

An admin from the past could not have set an explicit
"fsync=3Dvolatile" mount option.

Though experiment - overlayfs adds a new mode fsync=3Doff
which is more loose than "volatile" because "volatile" can actually
return error on fsync in some cases.

Overlayfs would also not allow to reuse workdir from such
a mount.

So would you then claim that adding the new mount option
"fsync=3Doff" is a regression because of the edge case that an admin
decided to explicitly add "fsync=3Doff" and RemoveVolatileOption()
does not handle it.

I don't buy it.

There is a more correct way to handle this situation and it is
documented in overlayfs.rst:

"When overlay is mounted with "volatile" option, the directory
"$workdir/work/incompat/volatile" is created.  During next mount, overlay
checks for this directory and refuses to mount if present. This is a strong
indicator that the user should discard upper and work directories and creat=
e
fresh ones. In very limited cases where the user knows that the system has
not crashed and contents of upperdir are intact, the "volatile" directory
can be removed."

containerd unpacking layers falls under this very limited case.
containerd can syncfs() workdir after unpack & unmount of temp
overlayfs and remove the "incompat/volatile" directory and then
the upperdir/workdir are are free to be remounted.

>
> Conclusion
>
> While containerd could theoretically patch their code to accept
> strings.Contains() or fsync=3Dvolatile going forward, there are many

Following the documentation advise would be better.

> existing containerd binaries in the wild. Given that this patch breaks
> containerd's CI tests and introduces an edge case for
> RemoveVolatileOption, it might be safest to fix ovl_show_options in
> the kernel to continue outputting the legacy "volatile" string to
> strictly guarantee backwards compatibility with userspace.
>

Considering my comments above, I think we have not yet reached
the point where the backward compat "volatile" string is called for,
but with other reports from production workloads, we could get there.

Thanks for the clear and honest explanations of the containerd situation!
Amir.
