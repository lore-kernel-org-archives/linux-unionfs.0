Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6578378D72
	for <linux-unionfs@vger.kernel.org>; Fri, 30 Jan 2026 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769771170; cv=pass; b=Sj7+kW8P6hl4NZwan+PLUZ/phYsmW+kyk8TiO4ywJmbv90W/JOEAkVSolEBmdibgawRUmAHC7+3PRL55NZqD2gW69OGJ/oC8UohieUl5zOQovvzgbsTovud3lqFts5LN4f/BfqxXO05C3HGdK8LNebgDyAYVx9ufAJWuHY9ohe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769771170; c=relaxed/simple;
	bh=9/zpKffe7y3uB+Qn0SF95hcsB79LbAi7GedReWEKmVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O+rdpkHkiFVNpEKN/ujO9N3wPchN74quRSZ02X4GOvs07+Pd/c/1YkBMzOxant4mdzfavN8K3+SaQLjvxVHXyiqf/9uo3T2ELpBYhthkw4QOhLPBc+kIFMGazQYYQAmzomIoxnimXrKdt+k3+0tVayxfJuX75BhewX2tBuwcq20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hIPqm4+U; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hIPqm4+U"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-65819e75691so3426405a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Jan 2026 03:06:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769771167; cv=none;
        d=google.com; s=arc-20240605;
        b=S0T1fRMXTjySEfLKv4O7YhytwUOW/NIr6NM3Uyr/VXy0tBrLxhSDnea83PwSXUlIUy
         8R9Lrz12bguLEr+7PsRW7LLgx8k6BMk7PdLL1KwHy7IVr1/qWfL2nmZrBWn1I+3vPIJY
         SnP7aYerjRMvGPnEzXmrh0qiXUUczFBNB/5hk6L5gfAJhJU3rkKrfSSntdy6SC3M+XJd
         cMTL2g3fQRzsc672tylbZ5t0ArLx85DdaiQUo3qQdEF/nDZqh9sH/BIk15/W7eD9zXue
         GQGAlFCtwRiYohMTt2cQLspWPYX2bgEbEE27qZNBi6ATt3X4n1CgW2nWc92YmldVWwwr
         Xm4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KJi4aV/ZmRDHm0hyQsYhdJh23rHtSjaZzhOLa52dkXo=;
        fh=4E2FGeqe6C7dCTmmyd43WBXAhMuc6OEbg1qt5+RiSzU=;
        b=VKJMPNV/11JBq6jnyudbuxsRSdWvd24iYCVE3eURLjo76OiY/uOShpVERhPVmXgmtZ
         iTxYvxD46spZBqPx/nD6xZu+8hmy0K1E3MMz79izg44a/TlrXXaUjXHmwGxzK4mA/bW/
         UX+x+BJXAxG7XfajKNvVfu0TNJtqJJ6+uawXUCIuzDTfDXA3ezZ4LlaGBiAMofeKa15z
         RGaXi2V+Ll8HDrX5YhGZB3IZ3ykg9fx/YeghLgUtFEroAYDx8jnneA7IPp1alJilLzcW
         8k4r0mIUEya+52c2wzB1k8OKCYQLM2/4jaCoO4xqcuvNfRZp9nCWPKBJyUrINikWMFOL
         iF3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769771167; x=1770375967; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJi4aV/ZmRDHm0hyQsYhdJh23rHtSjaZzhOLa52dkXo=;
        b=hIPqm4+U7OpUx4koc8RxObDAUkvZy6VqulOYO9UF7VmAqvuywLjIBne/1s2y5L2HSl
         3NOn4JBHg4TW8CgfTcWdRF4fTU7Dzgj3zjxxux8m0FaIw4XhxHpKTw88+Se3e16dF3pe
         i3KvNaXRk8wHAZ04vVaKk6BjxrpDuTvVVPqzba6D3tXrZIGMA+oQZgSwYKNRmeKdiNPR
         LRo23su5YjT6ie/CZEpITLV2onC0bu5b6UFf7AUTV7s1dtxI7/6H/ED9C+97NiFlJVak
         TAEIah49ALrBIzvxVT5Yk6E17Sqp5tSb8rsC2bIlt94bwfu82BR8LzjfR8eOJPzeMpqO
         HA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769771167; x=1770375967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KJi4aV/ZmRDHm0hyQsYhdJh23rHtSjaZzhOLa52dkXo=;
        b=w3Pq4fQl29G/zs1P1S5SqlEcgIoaIGjBU4YsVx9d53f0vLCSXG2ao80X+7SCAcEEYD
         d4oxkmnsyF21QPkExecQkd+g/knS5M6WhRQzB4k9lEVxSmGOkpferWt+6daFiJsZg58V
         Tb0MBa3FERU7rjjY3YmYpqQRkaAZ1/wIuCze1SYNeTAMbq4eVlWANJA0XTqkt8r3a+Rw
         rEbydH9/KU/1zhwDW9KqGxhCrRl0iaDHJjNTytbsjXXvigDE2W7xhdyW4f5YDmSfqO+v
         snj9zbtwNbjZLmY6bJToGB+Kl71xLs1CpxutIVfTo+UqzJ7CX0AAc41hXlXe9a+a6Bu9
         hBSA==
X-Forwarded-Encrypted: i=1; AJvYcCWzbDMV0b+jgPLlkZwOLbYL3gOHGX4hqcZ5ex2h2FUbsMZYMCqFcASE6HbcLtgZKiHsu6Nl5yzAkKus3hSZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzFQktuhLPEax4l5vkRz1JESKeEepWL+EVzIfoh9x4vFT5JDQig
	l0hGjtaJTAjyfWz4+GUWIeW5KPKOAdVsso05N1EVB4vJpx8sac33N8tzEu7sF3PyzvuhiZin2ia
	xwYev06quMqI+wA8iO2kHriR2hseqOt4=
X-Gm-Gg: AZuq6aIZkgO6CWw3ixi2o6/jsQw6lbjnpxo35kjl4Fo43mnIQeDv7ckpg9Xs9cE8ZRs
	huKiGjxj+9Zlf5ROG7JgPydELvdGz4EU0ddyZdstOyAY8txHGs4noP1yuBySCtO3CesYtWDlRRF
	xSzIZTSphmp7QrpHJRzmO+OyRsVUfERPYad2IoBmDXtyoTyg+y0apxSjm8rlcsDtqnKtaKx4Rrs
	RoV1Y2ylaXFPmyMzO18yzTfLFfNGdsbliZBc5huAygWkus4Gf2zohko1KGt3Ml77jtWdi+tWVOj
	ZWPtqt9tmw8bHwkj0zxSZX2ThMrKRg==
X-Received: by 2002:a05:6402:144f:b0:64b:588b:4375 with SMTP id
 4fb4d7f45d1cf-658de543897mr1599144a12.2.1769771166763; Fri, 30 Jan 2026
 03:06:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130001418.18414-1-wufan@kernel.org>
In-Reply-To: <20260130001418.18414-1-wufan@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Jan 2026 12:05:55 +0100
X-Gm-Features: AZwV_QgghBBStBrPYhn9xu--KNUWAryBYerGvsUjHEDtz6N4ByrCAVmC06166_U
Message-ID: <CAOQ4uxhf6EQKcoN055xzmi-RW2GPxRzz_ExsQawGQBSmoX2WYg@mail.gmail.com>
Subject: Re: [PATCH] ipe: document AT_EXECVE_CHECK TOCTOU issue on OverlayFS
To: wufan@kernel.org
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, mic@digikod.net, 
	miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2026 at 1:14=E2=80=AFAM <wufan@kernel.org> wrote:
>
> From: Fan Wu <wufan@kernel.org>
>
> Document a known TOCTOU (time-of-check to time-of-use) issue when using
> AT_EXECVE_CHECK with read() on OverlayFS.

Hi Fan Wu,

TBH, I don't like the way that this problem is being framed.
IIUC, the problem is using IPE on a non-read-only fs.
Is that correct?

That fact that IPE metadata is usually coupled with read-only fs
is interesting for the understanding of the use case, but unless
IPE feature mandates read-only fs, this is a generic problem.

OverlayFS is just one private case, which happens to be common
in Android or containers? IDK, you did not mention this.

Please describe the problem as a generic problem and give
overlayfs as an example, preferable with references to the
real world use cases.

If I misunderstood, please explain why this problem is exclusive
to overlayfs.

Thanks,
Amir.

> The deny_write_access()
> protection is only held during the syscall, allowing a copy-up operation
> to be triggered afterward, causing subsequent read() calls to return
> content from the unprotected upper layer.
>
> This is generally not a concern for typical IPE deployments since
> dm-verity and fs-verity protected files are effectively read-only.
> However, OverlayFS with a writable upper layer presents a special case.
>
> Document mitigation strategies including mounting overlay as read-only
> and using mmap() instead of read(). Note that the mmap() mitigation
> relies on current OverlayFS implementation details and should not be
> considered a security guarantee.
>
> Signed-off-by: Fan Wu <wufan@kernel.org>
> ---
>  Documentation/admin-guide/LSM/ipe.rst | 32 +++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/Documentation/admin-guide/LSM/ipe.rst b/Documentation/admin-=
guide/LSM/ipe.rst
> index a756d8158531..b621a98fe5e2 100644
> --- a/Documentation/admin-guide/LSM/ipe.rst
> +++ b/Documentation/admin-guide/LSM/ipe.rst
> @@ -110,6 +110,34 @@ intercepts during the execution process, this mechan=
ism needs the interpreter
>  to take the initiative, and existing interpreters won't be automatically
>  supported unless the signal call is added.
>
> +.. WARNING::
> +
> +   There is a known TOCTOU (time-of-check to time-of-use) issue with
> +   ``AT_EXECVE_CHECK`` when interpreters use ``read()`` to obtain script
> +   contents after the check [#atacexecvecheck_toctou]_. The ``AT_EXECVE_=
CHECK``
> +   protection (via ``deny_write_access()``) is only held during the sysc=
all.
> +   After it returns, the file can be modified before the interpreter rea=
ds it.
> +
> +   In typical IPE deployments, this is not a concern because files prote=
cted
> +   by dm-verity or fs-verity are effectively read-only and cannot be mod=
ified.
> +   However, OverlayFS presents a special case: when the lower layer is
> +   dm-verity protected (read-only) but the upper layer is writable, an
> +   attacker with write access can trigger a copy-up operation after the
> +   ``AT_EXECVE_CHECK`` returns, causing subsequent ``read()`` calls to r=
eturn
> +   content from the unprotected upper layer instead of the verified lowe=
r layer.
> +
> +   To mitigate this issue on OverlayFS:
> +
> +   -  Mount the overlay as read-only, or restrict write access to the up=
per
> +      layer.
> +   -  Interpreters may use ``mmap()`` instead of ``read()`` to obtain sc=
ript
> +      contents. Currently, OverlayFS fixes the underlying real file refe=
rence
> +      at ``open()`` time for mmap operations, so mmap will continue to a=
ccess
> +      the original lower layer file even after a copy-up. However, this
> +      behavior is an implementation detail of OverlayFS and is not guara=
nteed
> +      to remain stable across kernel versions. Do not rely on this as a
> +      security guarantee.
> +
>  Threat Model
>  ------------
>
> @@ -833,3 +861,7 @@ A:
>                       kernel's fsverity support; IPE does not impose any
>                       restrictions on the digest algorithm itself;
>                       thus, this list may be out of date.
> +
> +.. [#atacexecvecheck_toctou] See the O_DENY_WRITE RFC discussion for det=
ails on
> +                             this TOCTOU issue:
> +                             https://lore.kernel.org/all/20250822170800.=
2116980-1-mic@digikod.net/
> --
> 2.52.0
>
