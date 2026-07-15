Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D6C4A2E03
	for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2026 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784137374; cv=pass; b=jiAisrcy/7RRV2QM70nz7xpgaThl+8OguNi5RRlNEfzF8SNi7+ZtC6l4YKPHSQufcZI971+ycTY9T0hnyMrThH+Xoi8YTpuEhs0xaMRHaO4pwnCmi/FRU7ND2sgFiDDAY3KO9Cks4T76r73KNYuud6MmsfKl7sDL4fRHDdHULx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784137374; c=relaxed/simple;
	bh=lqPWPLsd1mdm14PaCsJU17LDyYujbuXuFrVYwqaG7X0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pvsjB4ukVF6NZFDKzdR4PQBSQVBpvPlsdeNGFhRkCRNGLHakuLLi7KFfH/QMSbbV+DimuD/G41nRisHy//he6XlNI0fCFzH045ly4tzWLORZ+hpQ8U72JmKPcUX4FfLvLOcESvUeJiB/I0IdXnmBwrzag7Rj+0rzajjhzACtqp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sb0UMLQZ; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sb0UMLQZ"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c1600d040e4so362284566b.1
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2026 10:42:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784137371; cv=none;
        d=google.com; s=arc-20260327;
        b=ixVDHSyPApKZX5kAdKiZImEfSf/u71VgJtFG1cgof3kjjx1vC74W71dsWoiUs7MISs
         +BSe5EIE4M1L/vB/5m+DKVHHh42cbjYH7F6X31HPk6Aa8RsZ0XEnoC1fCOwi6rPgdgiQ
         0CFqbBp8xgDTkWUVv3c58ic0fhFFtrBsq64TA8TcN9jxxWFVMxrhEsONmAV/TpK8Py3i
         VO3zl8Hm53N1PWALue1HfY52mAGsKUpnzc1K7lx/6fpDcQ4m9J7SK5zUpaDSJ4PBYd0z
         cBBbeQnAXCSOwtTiR6ydeDNbQ25Id/S9TIsitRyyH1IX+ti2u91q9jpORCsXQKfxsxhA
         Q33w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9LFKN/kjx68uZioMl5T89OykCMholjMJrJP61G9DYd8=;
        fh=UXwUXJoIa6eaunA+rhXatnaRxX9LXgKuvj0Wr9lQykc=;
        b=p9ENUT5HVGreaUtnZzgk6Gv4IymXNr2LdqDZiy5xDCKHdSpH1f6EB14iB1eHV33F1P
         +OzAamptA6EGsp3opOC1V9x8Yxd55CQNjT8tvpG5MRQ8a5Eq7KNJMlSGMn/LW0ZZaR3K
         fXcsR3Ip5ZRAigcE/WKbyll4TigAPyzRZrA3ThpnXKnuOH75rjdYMJqDoptZIb7Ju3ea
         rpxhyr9QkJK/SpnQ/sDvEq9vlaEZAqSTntkszkkAr9zAZpdoTgamGuKjONcfQDR8ZQ0y
         We5YEEsO512M4KVCM6W/ZxB4N9T5pEWUFHRmdI9MDUdF/SMAUTU1FpoZhtmQ2NNhBAn1
         4HTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784137371; x=1784742171; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9LFKN/kjx68uZioMl5T89OykCMholjMJrJP61G9DYd8=;
        b=Sb0UMLQZ21ZN/zSDGB1k5d2Z1oL22TFywLNHX6GQVCOSR4ZUtE2Cx5IpcLMkedKonL
         XvJjWZ39AZsh4k0dw5u6jH1gmRIuwzV6lwjTqtJpuJcP23ukevjRtJ2/h/dvIM4r3zfC
         6TxwfunfWuylytNpE0cB/li8a0f5s7vNaHf8jcZxdjBoO+MhUIQL8jjxRviZt1Zyi9hL
         FLd5kLYAScTO376ac+WK6xu8Wo3X+QkgdH5VWCEvJrdEyb3Ir3R6U1Ga7oCcKWK0x/gE
         QN+AqzyGMcO9OxvKIlW9s86/jZxjQcKO0NvZ5AAd4eOq3JJqMSh+8o7Lfswt/H2a2LcJ
         qnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784137371; x=1784742171;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9LFKN/kjx68uZioMl5T89OykCMholjMJrJP61G9DYd8=;
        b=qUBEutVWCL5+EFTAq7w6Bxo3/CvHOAJmqYGtCuEMFWivv+328jHdC4H74ctxyzAXA/
         5brquIiUSNAAtKFe/L1wt25Jo79IZ13h8OU3Z+Os6Jul/cB76Bu0QNzVL0XutVQw1ARQ
         Iw3M9uzQuRT+K50JKSXkcStSKhN0C52HDz8mnJ0cZ+5GqKfuoIsHfICh6PPze0VGTDcV
         TQSR0Fgl2CHDt53NHVYx7l5ZPjejROCrBTy99g5WIfMFWDkMa+drXDHvGctnQZN1iPlL
         r0tJLtePtyOmjorXqtBMOqOt/W2j5kK5233nLEzTIdElk7nViaDDZc4HqFCZ93lIR7qi
         yzmA==
X-Forwarded-Encrypted: i=1; AHgh+Rp8FDgsi2e+xzr5QtvWH9VWkcbOPCAA7KdolfW+JE8JIRHOHMCPHgxTvKlWksrZTT5OStYuHa8i2fS+zO6x@vger.kernel.org
X-Gm-Message-State: AOJu0YweqJB6Pp7rYdyIaEVswmaPEtswMR4EiILSD6ipaiwWPjp6VrGi
	dRk56OE5xSEAAfvBr8bvJtiAtcXeycAuyC0/w0zb7rE4P8ta+x6LnjYxGe6XHw3EMZ3v+DhLCu8
	EJbtllptrynw3hOcMmbRK/1BjvQWbStQ=
X-Gm-Gg: AfdE7cnchvjX03mJjOPgtU8J99Y4vPgtuOBIq/cKpVLo1YHb3GoZxcQDoiciLx+iEV4
	scyGdloPYCe0GQmhweGd9PU+6/Bh8pVE/ccBHbitdGV5fo2khO8zBY4+FCPB/WmzXpQIWdo60hK
	/rrNQVLZTsicRuRkpuf3a+DmlPa8oWEtXzh2U8hhrp59rXWPD2g6HJaSxa7B8CnoRvvn6WotkUq
	4li9M4XIMFzRzM44Rv+jZvvb35fyUHKSwGv7ujB/vm2sz/kKfig6T/h3LIwLezpWF8DJdrrXg==
X-Received: by 2002:a17:906:fe09:b0:c15:ee17:47a with SMTP id
 a640c23a62f3a-c168bbd4eb8mr30571266b.15.1784137371242; Wed, 15 Jul 2026
 10:42:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715-overlayfs-rst-update-v1-1-70625a67880e@teledyne.com>
In-Reply-To: <20260715-overlayfs-rst-update-v1-1-70625a67880e@teledyne.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 15 Jul 2026 19:42:39 +0200
X-Gm-Features: AUfX_myzE1qF4pubFIocl1cyp7nOMYj37ZTPuHMSySiwLYiGApfpQ44mJvgMhMg
Message-ID: <CAOQ4uxjkPev8ZE-KVPczMysvy18PUYSQ9yM_K2K=iygmioYA1A@mail.gmail.com>
Subject: Re: [PATCH] overlayfs.rst: remove mention of workdir needing to be empty
To: jesse.vangavere@teledyne.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-unionfs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 3:52=E2=80=AFPM Jesse Van Gavere via B4 Relay
<devnull+jesse.vangavere.teledyne.com@kernel.org> wrote:
>
> From: Jesse Van Gavere <jesse.vangavere@teledyne.com>
>
> This requirement has not been true since v4.8 when automatic cleanup was
> added in commit eea2fb4851e9 ("ovl: proper cleanup of workdir")
>
> Signed-off-by: Jesse Van Gavere <jesse.vangavere@teledyne.com>
> ---
>  Documentation/filesystems/overlayfs.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index eb846518e6ac..7e28bfb4a99e 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -123,8 +123,8 @@ At mount time, the two directories given as mount opt=
ions "lowerdir" and
>    mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,\
>    workdir=3D/work /merged
>
> -The "workdir" needs to be an empty directory on the same filesystem
> -as upperdir.
> +The "workdir" will be cleaned up at mount time and needs to be on the sa=
me
> +filesystem as upperdir.

That's not accurate.
workdir/work is removed
workdir/index is not

but I don't want to get into those nuances here.

Better just drop the wrong "needs t be empty" part


Thanks,
Amir.

>
>  Then whenever a lookup is requested in such a merged directory, the
>  lookup is performed in each actual directory and the combined result
>
> ---
> base-commit: 58717b2a1365d06c8c64b72aa948541b53fe31eb
> change-id: 20260715-overlayfs-rst-update-750d58792f79
>
> Best regards,
> --
> Jesse Van Gavere <jesse.vangavere@teledyne.com>
>
>
