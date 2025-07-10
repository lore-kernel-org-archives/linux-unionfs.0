Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCA82980A6;
	Thu, 10 Jul 2025 09:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752139734; cv=none; b=TdvFrrzAQkA5G+xO1QErYXLITi7amIr8nkuE2vzC7Cp5RlxSEyJ2VTJuJ3gPPS4Gdqw/CqW/Vj1gqbOhdhmFjQHsozuRFb1/3PGsZmB0p8VvImbJTOAALwmJpkjwrPgKg4mVk0I3wsZcdErMBQ8N+gL0WfPLWUk0/I86DW3rohk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752139734; c=relaxed/simple;
	bh=g8FHaOAWisTNuIgaWejSWAO/Ou4HKo28ZtZbLrjWtg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mr0Pzj0k/cl5bMbHQRQNZvrUyPm7PhJfTGkTdg0WmF+X0ay9FlpZ6afdlNPcu7matYHtM3vDuo5fNx7szHFReT99ICoHLkiz8aOQF+TkwKRRKthPXaO0OE/Z8xeuTWAxe7hKqcTcEs0n5tk2DgppTvVurPvJziimrjP8/RgM30E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ykv6Bpqz; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ykv6Bpqz"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60700a745e5so1410725a12.3;
        Thu, 10 Jul 2025 02:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752139731; x=1752744531; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BiYkSn+vY9L3z87omArmGIEE0SZdtFmrm7AJojWfvmI=;
        b=Ykv6BpqzjzzfjANucVYKzgKpOtJLTkVLlaEFTXRj0O3akSQ5AuDCgOTQeZ3SHnJhKG
         KiOCKCVTRQGOUjU8ItOukL+VSA39oNMTHo8Kc7zBBvPzVPyGFCBvwFWHUNk213Lzza2e
         MRN99xyeA0dcQKP0ouTufRpzVqGLtYY6q43BkZFgFsKzAXTn252nQKFZhjnZd/glbj+w
         dkroUzNjdVjNCSxbtLS96/kaFNStKgoocRzYax3HDLRMb6bQ25NwVYZl/i4DRayQ4EK8
         Y9sIxNHgHAsFuskVw3DaaLQB4KjKaSZVlnyZGioWE3vyHvSGz3gjKdyq236SvC0x22wj
         97UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752139731; x=1752744531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BiYkSn+vY9L3z87omArmGIEE0SZdtFmrm7AJojWfvmI=;
        b=jiKxKPYxxzvoy1rjFKolQquZRSDVA1zHVyyNeTnl7KPTUHgxBWZDeLEH6/tKM29opO
         tf6TtrEp8o1ll7V1/TnpqJNCmqsoppI337e980QoniUtgShRMXXq+qkVoBcY9/SkLeXi
         JcMB8nfqJKrXEo2xxE0zxxg4/UR4E8glzFKCQFQfIQcX36cahyGrxPe8F4EEtGpl6B6E
         LE/xwbiOl3A9RpUgpeq5DapRlx0Pd9NfNh2SfC9dgM4jPuIoo9zjFoCeDW+iNwdquCik
         I+1tccjKwymRVRmbfMuitXGhsF9NulYaB9j+eJ9E/4xxHngjMBfr+Nulp6V5zPF3Y8q3
         IbZg==
X-Forwarded-Encrypted: i=1; AJvYcCUZB0YDZ7a9coulHxvMYCzAJHGMlJ+Hup8TFD0heAAeonwreZZcqdxuclBL8RedRy9hysakPmk9r1c=@vger.kernel.org, AJvYcCVVq3GL7pHexP7JmoAOFWeftT+EKskk/4lDE0/JLYdItVTXDFpIhFl1AotFroGj+JQIHdzczsWSC4V/O5SRHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNSou6Ail64fZFEKFIjB1mwl6wuqWh3URuAnjwL203GnU5G7XZ
	YIzbLbr9H0N0woA6/y+IA3YZ2kaOBK30RA+IVbL377o9Wn6SEhch7TuyrAUyoza5vLeKN5pUKYA
	LWiYCtN4AX+tgyttkEPJ0AEorVDZN00E=
X-Gm-Gg: ASbGnctcg2sghYHHoveCIOEtlYtPrAbgzNP8SjEacHVv8iQ2E1leDyUGGeiYQtoqJH+
	P/yUsvwR3HS5cprvu/3KWZ4j97wdGPsirOKQsqvbRC/AxME1pG1XG4Tn4noz3IKB6ExkRFEMQBY
	a9reci1bxBEwLTIbIN5NHLTIsGEg6F9fyHpofYihm3ZL8=
X-Google-Smtp-Source: AGHT+IGVjPcztPdZlC6fa0irt9LUdxKj2BaoE2kC5A93RR1GebqTaZi5uj3oWG7ZxTbETAzs+9t+pEVjp/omVNvyfyQ=
X-Received: by 2002:a17:907:2d89:b0:ae0:ded9:7f54 with SMTP id
 a640c23a62f3a-ae6e703387cmr243207666b.28.1752139730403; Thu, 10 Jul 2025
 02:28:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710050607.2891-1-frank.mt125@gmail.com>
In-Reply-To: <20250710050607.2891-1-frank.mt125@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 10 Jul 2025 11:28:38 +0200
X-Gm-Features: Ac12FXxBKaD_YJhNw5Xx7TFCELs1AQpQz9GtDpfwNqH5R4SdBWGrYx4C_J09FE0
Message-ID: <CAOQ4uxhvBMJLWrDtuK3kOKDv0enMtAgpgV3WeR9Z9ZEDpOeu+A@mail.gmail.com>
Subject: Re: [PATCH] overlayfs.rst: fix typos
To: Matthias Frank <frank.mt125@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2025 at 7:06=E2=80=AFAM Matthias Frank <frank.mt125@gmail.c=
om> wrote:
>
> Grammatical fixes
>
> Signed-off-by: Matthias Frank <frank.mt125@gmail.com>
> Acked-by: Amir Goldstein <amir73il@gmail.com>

Hi Matthias,

Thanks for making overlayfs.rst better!

Since my ACK was given off-list, I reaffirm it publicly.

Jon,

Can you please pick up this patch?

Thanks,
Amir.

> ---
>  Documentation/filesystems/overlayfs.rst | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 4133a336486d..6e0c572d33dc 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -9,7 +9,7 @@ Overlay Filesystem
>  This document describes a prototype for a new approach to providing
>  overlay-filesystem functionality in Linux (sometimes referred to as
>  union-filesystems).  An overlay-filesystem tries to present a
> -filesystem which is the result over overlaying one filesystem on top
> +filesystem which is the result of overlaying one filesystem on top
>  of the other.
>
>
> @@ -425,7 +425,7 @@ of information from up to three different layers:
>  The "lower data" file can be on any lower layer, except from the top mos=
t
>  lower layer.
>
> -Below the top most lower layer, any number of lower most layers may be d=
efined
> +Below the topmost lower layer, any number of lowermost layers may be def=
ined
>  as "data-only" lower layers, using double colon ("::") separators.
>  A normal lower layer is not allowed to be below a data-only layer, so si=
ngle
>  colon separators are not allowed to the right of double colon ("::") sep=
arators.
> @@ -445,8 +445,8 @@ to the absolute path of the "lower data" file in the =
"data-only" lower layer.
>
>  Instead of explicitly enabling "metacopy=3Don" it is sufficient to speci=
fy at
>  least one data-only layer to enable redirection of data to a data-only l=
ayer.
> -In this case other forms of metacopy are rejected.  Note: this way data-=
only
> -layers may be used toghether with "userxattr", in which case careful att=
ention
> +In this case other forms of metacopy are rejected.  Note: this way, data=
-only
> +layers may be used together with "userxattr", in which case careful atte=
ntion
>  must be given to privileges needed to change the "user.overlay.redirect"=
 xattr
>  to prevent misuse.
>
> @@ -515,7 +515,7 @@ supports these values:
>      The metacopy digest is never generated or used. This is the
>      default if verity option is not specified.
>  - "on":
> -    Whenever a metacopy files specifies an expected digest, the
> +    Whenever a metacopy file specifies an expected digest, the
>      corresponding data file must match the specified digest. When
>      generating a metacopy file the verity digest will be set in it
>      based on the source file (if it has one).
> @@ -537,7 +537,7 @@ Using an upper layer path and/or a workdir path that =
are already used by
>  another overlay mount is not allowed and may fail with EBUSY.  Using
>  partially overlapping paths is not allowed and may fail with EBUSY.
>  If files are accessed from two overlayfs mounts which share or overlap t=
he
> -upper layer and/or workdir path the behavior of the overlay is undefined=
,
> +upper layer and/or workdir path, the behavior of the overlay is undefine=
d,
>  though it will not result in a crash or deadlock.
>
>  Mounting an overlay using an upper layer path, where the upper layer pat=
h
> @@ -778,7 +778,7 @@ controlled by the "uuid" mount option, which supports=
 these values:
>  - "auto": (default)
>      UUID is taken from xattr "trusted.overlay.uuid" if it exists.
>      Upgrade to "uuid=3Don" on first time mount of new overlay filesystem=
 that
> -    meets the prerequites.
> +    meets the prerequisites.
>      Downgrade to "uuid=3Dnull" for existing overlay filesystems that wer=
e never
>      mounted with "uuid=3Don".
>
> @@ -794,20 +794,20 @@ without significant effort.
>  The advantage of mounting with the "volatile" option is that all forms o=
f
>  sync calls to the upper filesystem are omitted.
>
> -In order to avoid a giving a false sense of safety, the syncfs (and fsyn=
c)
> +In order to avoid giving a false sense of safety, the syncfs (and fsync)
>  semantics of volatile mounts are slightly different than that of the res=
t of
>  VFS.  If any writeback error occurs on the upperdir's filesystem after a
>  volatile mount takes place, all sync functions will return an error.  On=
ce this
>  condition is reached, the filesystem will not recover, and every subsequ=
ent sync
> -call will return an error, even if the upperdir has not experience a new=
 error
> +call will return an error, even if the upperdir has not experienced a ne=
w error
>  since the last sync call.
>
>  When overlay is mounted with "volatile" option, the directory
>  "$workdir/work/incompat/volatile" is created.  During next mount, overla=
y
>  checks for this directory and refuses to mount if present. This is a str=
ong
> -indicator that user should throw away upper and work directories and cre=
ate
> -fresh one. In very limited cases where the user knows that the system ha=
s
> -not crashed and contents of upperdir are intact, The "volatile" director=
y
> +indicator that the user should discard upper and work directories and cr=
eate
> +fresh ones. In very limited cases where the user knows that the system h=
as
> +not crashed and contents of upperdir are intact, the "volatile" director=
y
>  can be removed.
>
>
> --
> 2.39.5 (Apple Git-154)
>
