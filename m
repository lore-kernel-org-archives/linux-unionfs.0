Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161E81E51EB;
	Fri, 15 Aug 2025 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755271025; cv=none; b=fySK1pw8AVEBb9cIw3IGaWSRQoa1NSzxDidefMsioIOx7+xKH8ucdkpKOHRCLJh6qxXG7ztzpMv40qeVnXFt4KJKclHa5Rf8bdtXdpW2v+iBxcF6KH1Af5/ZxeHF7ru/CInxD85VIlFkSyOcCwMI6Vgjhukgn7i8s18yFEZS3DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755271025; c=relaxed/simple;
	bh=3o3GdUTMaK3xbbCh633OrxQH0Ao8W2ck7XbV5OPO/eA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y+aOchdNDf/IhfEc5YzLX3/9WcYoDjJ1exkoRgVYNbvmjtgqJf+JGuFelWA2+zXymTptlGOSVp8FARP7fc2L6dttBh+s7BOBvM60EHAyPQwNmSL4A79SrBDAkD4WNOUXxRBkKPm6WO+pu/ncDYebPM/gZMyDzFH2rQk5uHZisHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jcZ7A8UG; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcZ7A8UG"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6188b657bddso3942374a12.1;
        Fri, 15 Aug 2025 08:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755271022; x=1755875822; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uo0bCS9kHMiI6CstzXCrMme0KNAygcJAePSrWWaQOBk=;
        b=jcZ7A8UGRXeWj6zpn/M0JAhnS3m75efm2Xb0wlo/81hKGLxkRoSRfeQAljUn6S0VRv
         zTbgkTZ9+KHcFljwb9EhvJhY3UX2savZv9beMk0BmoZC54bDNlopKh7qTNYhT+FLqFbx
         49RS0WJhCImXWUTmjSjo5MVBTVu3MOYRtVgmz6ui71y3A19Zk2ldaadw/Hxmh4Rqb/9J
         tgEt8I0LRngGONduR0WU1uXrrMpOgT+1eg0jxrRzKFi+ITRD7ZtOGi9vm3aaOqq7+T4s
         hdWADTeLHC0FogpH3iPMSFU+EKsEkDc8bA/PDIfu2IHeUpRmTmsjezVko1sOkqVQaNEQ
         BvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755271022; x=1755875822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uo0bCS9kHMiI6CstzXCrMme0KNAygcJAePSrWWaQOBk=;
        b=M8tth1MVje6v6ph9N+buKOyh0++/UDu+MboHtnWDIVw5tnB18V9R/HEZ1BU08NvhdS
         YIlxY5LGuyAdWhiTBO5YxoEfr5dRdEnEzGMDtlQQf21pRy2R2wvMMiANedneht1NmN7+
         jhkd/Et78jt+ajb5ROngKCQyFuwETj2cCY89LilhYicpYwFXT/H0OmRyJCQP+zk2UbiD
         0qwAP7qbpYmqg/mwcRKBE3erRANREkKhuj3ANaoKGmbqgVzG8S3/na+KTKASCUonGi9X
         qSf//zd8q2lzfehwuYpM4NP27wVpEc8LE+bJn1KVeU6NmE63AZq1CKBLA/0KOmg5bwS1
         E8XA==
X-Forwarded-Encrypted: i=1; AJvYcCWjaW2hNhDM/j2luYXrwJaUi6kXrP57fnNhD8DGiylikVTMOGlcLzzScOalRhWvDDabawCPXAILLpHJIhnK@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu04zJccNr6HzqLY86ZsJiFKGS0HqmgQsMKglb8Hivvd+dDCD0
	x0goLmlioX0Bm/F2b1q6i6tP3K733XCZzwUhKZ1zNY33qRVpoG5joGsX3qeO8hRNlFOAIBh444y
	V6igHENZWCIUblVdY+6hDy8YyvTycX1jW0gifxBo=
X-Gm-Gg: ASbGnctY4lGgJx+lGh+CD9fLoeh7A2EHZtRwt5C/TguZ4lnASoGpdcfMw7ssweDRk4z
	xc2SBnaFrWuGh0K/QWBxsQjInICQJDQLaS39Ks9I6PA11UBhlyGEyPCMAIIEcE83xqWri+nUf/1
	linMAA8yLlHbXkil52IPTf4jRVTpOksUofgs3BMLdbjmejq7XqbYQ62+W1xhUQKcA4H77BEr0j0
	u9LpBw=
X-Google-Smtp-Source: AGHT+IHVScoDPLn9gBHHCfVZfqEI4sFwJ2XDZDyoCfMemOZVgC4idVYmz1SEKA4Hv8RwBHrWPqmL/rkaF66C7zKz9eg=
X-Received: by 2002:a05:6402:348e:b0:618:6afb:8cb2 with SMTP id
 4fb4d7f45d1cf-618b05041f5mr1836139a12.5.1755271022287; Fri, 15 Aug 2025
 08:17:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250815144555.110780-1-zlang@kernel.org>
In-Reply-To: <20250815144555.110780-1-zlang@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Aug 2025 17:16:51 +0200
X-Gm-Features: Ac12FXzuFXg6O4o_dlhkwrLyQy5hzUfTglNalpWxEkBLpg2nMLy-hoadlqsYj9U
Message-ID: <CAOQ4uxjVpVPVfiJPokpmu6pLDmjtYbeDr+j5jNHi8k9bK_2feg@mail.gmail.com>
Subject: Re: [PATCH] overlay/005: only run for xfs underlying fs
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, pdaly@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 4:47=E2=80=AFPM Zorro Lang <zlang@kernel.org> wrote=
:
>
> When we runs overlay/005 on a system without xfs module, it always
> fails as "unknown filesystem type xfs", due to this case require xfs
> to be the underlying fs explicitly:
>
>   $MKFS_XFS_PROG -f -n ftype=3D1 $upper_loop_dev >>$seqres.full 2>&1
>
> So notrun this case if the underlying fs isn't 'xfs'.

It would have been better if instead of mkfs.xfs, we would have
used a helper to format $upper_loop_dev as $OVL_BASE_FSTYP

But this is easier, so unless anybody wants to take on the better fix

Acked-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

>
> Reported-by: Philip Daly <pdaly@redhat.com>
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>  tests/overlay/005 | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tests/overlay/005 b/tests/overlay/005
> index 4c11d5e1b..d396b5cb2 100755
> --- a/tests/overlay/005
> +++ b/tests/overlay/005
> @@ -31,6 +31,7 @@ _cleanup()
>  # them explicity after test.
>  _require_scratch_nocheck
>  _require_loop
> +[ "$OVL_BASE_FSTYP" =3D "xfs" ] || _notrun "The underlying fs should be =
xfs"
>
>  # Remove all files from previous tests
>  _scratch_mkfs
> --
> 2.49.0
>
>
