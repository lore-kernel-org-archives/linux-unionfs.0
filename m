Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794407548;
	b=O3Az8rCXBvyxgN8CVQdtDry9HqzpxCCLZJ5Jhh0S0+Wxsc66l9Pem7yP8mxxaH5rxD9B
	 2/2572HaVMX4ZMeQ2yToPwLsx5UBpxIhVB4cFAShgw22btzlWZqJ014pm64t7devCmJQa
	 6QyyP/GBNH6FC+dvzMXy04Q11AR26lHCBACPoVa4DLsxnsUJcWTBnD2ERZvmUvnDkAc9g
	 MuyrHb1HXOFpq4iUN6rxNFB1zNQuOafGx/CryTIt1L/KDygggvX/a4db/mOrEZNWhjkWL
	 ShUrJpjrRnTt0MFYcRWtzyW/n4LErb+qHmUs0GvejvmKCmM/sf03fxX0M0c8+wH3UEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794407548;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=H45KpFDCK+g+SsvdHkrZW+WnPt+fiQcRq1w1UXAbFIw=;
	b=sDHFnHahgVzOrbkjeDR+Uife8wburVOjzXwvbhA3QzjBfCT2KeNMv/rnGABIooFTAvqw
	 KvKbttUEU9aZM6d4EOn8yazh8Bz9jIuRLC10LZnnUMOG1zHhPJUG7DPkoJi1Xjjq7SmsR
	 rQDB4UYLhlxi2QwEAzkFultzz86Y1xDstjnZvk8NjXgXAdUu+D6W0oQ1EzWmOaV+f8IDY
	 QNCKjyrCa2Vm/Pr0pilE44snzPn6VzDLXf71etTzUu7EjrxMyLq1GDPwaAMm8reuNlLgq
	 FCAE7A2Ubl9By08Y90rUYO3Y7+l58wsRYSvt46ZrgCvidK/bwl+ZOz56AqTCpaKWNHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n0PUxDQW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A61660A2622
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 14:32:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A61660A2622
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n0PUxDQW
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b577addee9so4490179a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 06:32:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794407545; cv=none;
        d=google.com; s=arc-20260327;
        b=jjEuVqWxTGs86QpanzTNPpeQZX84W7A04c2aI0G0djOOKCop4/u0vzMnu05RCq+oVb
         7V2/qOY7XSyBMBcH7YYwATVIL1wQ0GpkUp0dl/oFMixGfU2XG7Eh/Ydu/STWNZi9Fr5F
         1XFgnfuHNim3UEJ+a/+gew7zxiuL7LxM9I26PKuJL7Kg3E500fD7M3XtYkUDqkjS7Uie
         XGC1lLJtcOhWQxQGT62F1KGsolkYKNMVfYDiS+5J9nZhgy4DESDhtDjtpT903PWWFG3d
         +QdWgXi6XFQXttBya/8ADf2nZ/RgZTGcIJs5Ea/V3Sq4grXf5es+51Yv9NehKtarexKi
         M1lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H45KpFDCK+g+SsvdHkrZW+WnPt+fiQcRq1w1UXAbFIw=;
        fh=cnjnofb4Qf5wbxUsGupFkAVH6tcAyLbS6kR8Av4s+/g=;
        b=m6x4BkZw91cIt0KTd8Ilg5WCWa7iDXk4qGMN3QWS/GYE0Z38cT43kjzPMiP8qjslWm
         ZUFa232CFqk/EnXLXvTjRFbukJ/VtQaRpFuQBZzz0Rpal+ZLhJWQITLRWQaVlFqITxBK
         oqz9pBqzCJU53jKdkFbx7PZDzlUbuyyfoMWHwG7tzAYbgXBMQ6tmEaGfwH0fDa7noZ6e
         NjYLl3KA4SbWyt38faRo4ohp+iFMxw6GxqRp4dqxTNfZatJmeoqmFKJ+Jp4LNQGKt92f
         oQXocJWQAujKiU7egkmntu/JWVdLmXKV5AXQVnqq1Ophclu/eAmVocmlXyKuCkuwASHK
         eOmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794407545; x=1795012345; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H45KpFDCK+g+SsvdHkrZW+WnPt+fiQcRq1w1UXAbFIw=;
        b=n0PUxDQWY8lbniMMcg5XyOrakIOSWBddI2DuUo0W4g62MtmIX22RcOG5yCdak4GdWs
         x1+Y0jocLf+FhuyN52434g01fV2yYXQAP+TLfH2nvLH9VhrCEUMI/eNEyhJP2vAgrB3P
         W9rIzW9N8BJjZPH0mbAsFEaL9GTzHRsOHQ7GfECxvTJ85oTAgr558B8f3UwpUjOR/gtS
         heCatj6cIc5LtFFD58I8nCm6vD79ZrDH9W20xSWA2xgSLNlx2zpbH4p2Ww34y65mAWGG
         JTxxhnFNck3isnlERBqM0C864OYETyV7rvrQNiKK2cxdX2/EXRQh4NpYxeSRL1R0vJ2z
         MI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794407545; x=1795012345;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H45KpFDCK+g+SsvdHkrZW+WnPt+fiQcRq1w1UXAbFIw=;
        b=mpWt9fMtfhFr9Mgt4EpzoLMarSU18N6fgQwDwemWuhMgtbe4zzC+iBkw3xf9NU66hO
         QGUKZ1rgUWAw8Mbs2CgD6rfe+wXnf9reovYHOIn8ML1FDDwBvgOLEfi3Nx42Le9UFE/B
         p0hucBrzTzyIZZ4LDIqPKfDr6wTH/nKQdxuU9/H/MCxBUYmO6yyXmaD+JUC0QGLgupnl
         hTDAm4EJzz3PEYTYVPTFm+oBMD/g1+4VE8zXNr4T8heIsN6QIET/ak/OG83M1NHP9rJL
         z+JFyoPazs1WYRmfYxEwoplzxn9MKY0z+irjqpcyNLhAGcRencmC1dY/tqsUxoS1vuts
         lz4Q==
X-Forwarded-Encrypted: i=1; AL+hErHmHPHcuk1GdUzVv023mhXbeBLoJv2BMjE1e7eySnq6TggrnNpts8jtNr5dzPsgB0KelnYjp9qbCjK+vEQt@vger.kernel.org
X-Gm-Message-State: APuU4Z/nQjzc6+SocV4Ihxk/r9QR90U/SJEvDxv1BlfY/5Xr3Ee9oRUS
	sdQEoz8u36022oY0c+nhKmnR9hlMFXQw6G6Pa6bFys8R950Y4mksjcy6IVHu62aE+HlZ/VvaxGM
	LIOCK5gzFvW6b2NUt/ElUVUfuET93zyWTkig6LNU=
X-Gm-Gg: AYBFou02XaWSTj98YzJR8iSYOq0bL7sDecan9qmol3lbYa2RQt1f7YMPvfJYaeQHh9S
	/svkcLlGOTmeJSwMfImB34EfeENJF2X1mDQkaW5a1e6hqS0obhR3fBrcYRZ/SNAft+yQqBxBZPR
	0Y+xJstMeqZT6nrAhCL+D4uQtJYCKRb0AYQsDForm3t+iuX4yHwNn9r8d9LAGy2ZDoAZy8H35l5
	+PGCZcWydGhgMmKFfp0UGZd8MhoQvBSEXQ90KQ8LtCAWQt4UGIkDS8+HB0e2qY07Md8V/gjmzUb
	kuwEDfRaCtYaRxfxHdyMVcozZG9MeRQ0P2IdD0JA2h5eWrQX3MtCj66v0pYzP0daIinQz5W9Fwf
	QGTUKr+Nd0qtQE1V2jl5aGHGCK8nez3LMS+OqOTY5iCK1S/6SwqmLeYP+p0ssMCD//ETFmw==
X-Received: by 2002:a05:6402:a646:b0:6b1:8818:1090 with SMTP id
 4fb4d7f45d1cf-6b7773f30d0mr1395590a12.22.1794407545129; Wed, 11 Nov 2026
 06:32:25 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111132836.3495981-1-giuseppe@scrivano.org>
In-Reply-To: <20261111132836.3495981-1-giuseppe@scrivano.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Nov 2026 15:32:13 +0100
X-Gm-Features: AclHuK9UKcZuc11R1NXdk1mepeTSsngwkQRdBY94mhO_-NcU2qH9JLMsLDVbZSo
Message-ID: <CAOQ4uxj7+yrUMu_bFMpDR6g32x6RjwgcaqBR98h2PBFjn=YD7g@mail.gmail.com>
Subject: Re: [PATCH fstests] overlay: accept EIO for metacopy files with
 missing lazy data
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 2:28=E2=80=AFPM Giuseppe Scrivano <giuseppe@scrivan=
o.org> wrote:
>
> Since "ovl: return EIO if the lowerdata is missing", open() fails with
> EIO instead of ENOENT.  Accept both in check_no_file_contents(), so the
> tests pass on old and new kernels.
>
> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks!
Amir.

> ---
>  tests/overlay/079 | 6 ++++--
>  tests/overlay/085 | 6 ++++--
>  tests/overlay/088 | 6 ++++--
>  3 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/tests/overlay/079 b/tests/overlay/079
> index cfcafcee..4ea4f609 100755
> --- a/tests/overlay/079
> +++ b/tests/overlay/079
> @@ -119,9 +119,11 @@ check_no_file_contents()
>
>         target_f=3D`echo $target | _filter_scratch`
>         out_f=3D`cat $target 2>&1 | _filter_scratch`
> -       msg=3D"cat: $target_f: No such file or directory"
>
> -       [ "$out_f" =3D=3D "$msg" ] && return
> +       # The data is missing: older kernels fail with ENOENT, newer ones
> +       # with EIO
> +       [ "$out_f" =3D=3D "cat: $target_f: Input/output error" ] && retur=
n
> +       [ "$out_f" =3D=3D "cat: $target_f: No such file or directory" ] &=
& return
>
>         echo "$target_f unexpectedly has content"
>  }
> diff --git a/tests/overlay/085 b/tests/overlay/085
> index 046d01d1..b644e7ef 100755
> --- a/tests/overlay/085
> +++ b/tests/overlay/085
> @@ -120,9 +120,11 @@ check_no_file_contents()
>
>         target_f=3D`echo $target | _filter_scratch`
>         out_f=3D`cat $target 2>&1 | _filter_scratch`
> -       msg=3D"cat: $target_f: No such file or directory"
>
> -       [ "$out_f" =3D=3D "$msg" ] && return
> +       # The data is missing: older kernels fail with ENOENT, newer ones
> +       # with EIO
> +       [ "$out_f" =3D=3D "cat: $target_f: Input/output error" ] && retur=
n
> +       [ "$out_f" =3D=3D "cat: $target_f: No such file or directory" ] &=
& return
>
>         echo "$target_f unexpectedly has content"
>  }
> diff --git a/tests/overlay/088 b/tests/overlay/088
> index 33215cbd..27011469 100755
> --- a/tests/overlay/088
> +++ b/tests/overlay/088
> @@ -95,9 +95,11 @@ check_no_file_contents()
>
>         target_f=3D`echo $target | _filter_scratch`
>         out_f=3D`cat $target 2>&1 | _filter_scratch`
> -       msg=3D"cat: $target_f: No such file or directory"
>
> -       [ "$out_f" =3D=3D "$msg" ] && return
> +       # The data is missing: older kernels fail with ENOENT, newer ones
> +       # with EIO
> +       [ "$out_f" =3D=3D "cat: $target_f: Input/output error" ] && retur=
n
> +       [ "$out_f" =3D=3D "cat: $target_f: No such file or directory" ] &=
& return
>
>         echo "$target_f unexpectedly has content"
>  }
> --
> 2.56.0
>
