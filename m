Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE0B40587A
	for <linux-unionfs@vger.kernel.org>; Mon, 21 Sep 2026 08:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789977846; cv=pass; b=l0TVpuDwDjkoxld1jXh2YiCWGx67aXhi7TfnB++yPwtR4JjroopLHanEldrhaXLK0mVt60G2yXvepJcOh4dlsxQKl+J8OgOG94D8IoKChvWYUE8qVdnkPIvxbcomLwDpppkJmyDm1kJksHRxtPBZc/1EdZPHAZj2ukNZh7rU8u8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789977846; c=relaxed/simple;
	bh=BHHvVxXhYf7butuU7G97wcIknchQm2zDSthXzdW2JCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T/CKGgAer9XFKymk+iOXz89zMtmdLYtoNMHre88qtE3kTNrZdEPqF3QTeYtAwxeaVYb4TuZx4f8CPy2lpyMEq47HohOLG+lN7bitVEDN+M6/0cfKKHZXR1Co9BcsZ9jzkE+nQI1Mf5bFYg+fSj9YhulOuGhQyneO0pXp0bHlyhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vt5TA66T; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vt5TA66T"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2940ff2313so158275166b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Sep 2026 01:04:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789977843; cv=none;
        d=google.com; s=arc-20260327;
        b=RMHjCI3N7IXrGS4/Hfo1ySsbONfr8y/QdF87j6P+C/glmQdo8Cmu/N1qVlyi4m1J8a
         jCiqPoM6JXt4o6tT8+WnJmgZ8NwDjlA67SuI/U4PYwyzY2ZqhSYkFRrFydPDKr5BY8DS
         3rPtqRUG6pE7phtQ7oILDaSpcdDxbBTYdis50bMejXKBrZe9b3ARaeOaoeXZeUpvwNV2
         i+LUHOZp9tPdJdtj8XeR8ZzV4xVA4CugJSFn3nCefdWEGV1lsUY7tWMsji9vpFi78ts+
         fS4/t5R40+pp0vixgb+Q8U+rFbBvasJNsoZzk3gI5qhDePuKpVrqRPeA5c+ggHamTzQy
         l6EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3CPPlAz7rOVaKGzBH75ziRlUSLV2fWYbKF5sY/yYeVg=;
        fh=EcpPuAQwq2Eox6Pco0kGFb8uW1g8YyWT3KDAOHeivIU=;
        b=An+wzRKonG5vAj6wEE1QqMyxCxONYDuDpLjS0LW22LhELHzn/WESaa/vFnmgAz6aaw
         xwnPt/CXlyKviuqPfnlNYrdIbNxSgAMkda1pT9SbeFGKxGPd9cfdY8YV/6eUITRKYNzs
         eeCk5YYiE20e/qnm+csi7oOa9jJfjR/Mt+caoHXpFVli6Rxuk0Hgy1i7ZCGuh62WXrJs
         U1p4OQETPDU9QhAie3j99tNhlkf3S45Vrlf9o9zfnVjCH64tix9gtJ/B2PafIr2srmtC
         yek5yfrZ/hTu5oj1+wjYDHOFDqHB+Lfh8l5PW8QSZhe0AqXR5G9lxdeUsHSqoPFrO3oA
         PmxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789977843; x=1790582643; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3CPPlAz7rOVaKGzBH75ziRlUSLV2fWYbKF5sY/yYeVg=;
        b=Vt5TA66Td35vOXhN+ngAezqAQ0ypMQj+19anC6Aarm8jkKAuak/WziCHPlRL/N+CSf
         GGPFY4IJ4wv5ScwbL5q+t52UJigbDsVqtVke2Z3u0v42+A6bpaJdBGefLqxolCbn03oh
         flOD7D5jUJmBfQfYr8NrzQ1AGit/BScAXfq2Xo/4O+E2b7lzcwDGDPjRXUS6uSRDOCr9
         qfiyrECa65CVMEfnYWgl24NCnZNKuhQGw7PFb1GyuX1ijqSmCfWvbxTQcbXz2CVM0kKZ
         dQOOHxpzdZcCUKLczfzH5C8WhThXdCyfrMRmSR1Xn0JIE5TstrN7qiYQXG8fakF32oeU
         DmZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789977843; x=1790582643;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3CPPlAz7rOVaKGzBH75ziRlUSLV2fWYbKF5sY/yYeVg=;
        b=u5C3b7wiwYdhGQYRKwZCc3KmRlzlyuIkNjPRrrE/wsMCatEQGhQd/T8sMcqCPTrHce
         BJTWNBV1gwcPOKIsFoWJjmVnmvFEcFf6bhmI2ouBAeoItP+Z6SqglPgSR7PHOlVuUy0q
         nXxQgFszbptvJBeRRf7svLt7nnPvpVEINtyhoRWm7Fa7/I4eTTFA3ARlVkLyJPNNFzt2
         NdjTFiNdGB48qPfedhOjnVlLzLitvYAIBITol6YTHqT9KGcFhoYqC25tg6Qte5Lffpqs
         XmSRWf97fhjj7icrGK6PhPVqA7V1X0hYFySqhct2/7JYeM6qc/6qC4xLvkoTb4Afum4T
         OMxg==
X-Forwarded-Encrypted: i=1; AKwUvBwhjxRJXny8X48XFHi043KFDqPObwb8OcH5d+WwCJIUONraW0w+fhMnObt4nzHCkiPKQmps6nNrpm2Y6n4d@vger.kernel.org
X-Gm-Message-State: AFuF++mt72VhWP6vBIWAvF07NNJXRjDfxf5ui+nsTQV02k7cMC8EyvIc
	xH80ywQpUV+UZZ6JqYB8SQsuhAvCmFm4lfmZKBoAZS10H2nZzSq8ipkEAlm26FN4gC7IYLGcINm
	CExPNfooEyzoH6rM8J7qNSEa6IZgJQ9Q=
X-Gm-Gg: AYBFou0sNq7O+VrBU8J4jZp7iy9KJuu4h6jpuQFKMmdIMeb5DLlD0CQ9O1bDJwuTZ12
	6iiUQBHcK1kD7aAZ8tPu5y9BHz4PttcfUg2/6XjqUBLf/BT4HsM4ZHNVnPsJA/QS6ylZgtcj9mI
	2MfB/us2EXp2DvN6G5V8u8uvNBOHK3al5ErfH4OQb4RNE84+BnsnGdPuMAOiX1LBtLsB5ZoKEEP
	0o19roiWsHOq0i8+ziCcnna63KGuK9pRiSFsugri+VsTYO0KJkfOWuJ/moKI7SuDtWBgaOkr/mD
	Otwglp0TqXxzo4E3j4BU/nFwVqGB2tfOeAuoJdbOM3bJr7zhEgV2yF71Bw==
X-Received: by 2002:a17:907:1c94:b0:c25:f7db:4be9 with SMTP id
 a640c23a62f3a-c2a16555e01mr963430766b.15.1789977843025; Mon, 21 Sep 2026
 01:04:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 21 Sep 2026 10:03:52 +0200
X-Gm-Features: AcwNN1VudlXF5OHLlFt9yKN5UFF-jnenTZ3p01flmg9bU-PwfkvO2WJR11Q6HV4
Message-ID: <CAOQ4uxjgZ8e=M2yEhqO3mq7WeAUxX3fCNmVwaLStE_Ucqu2EDA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ovl: disable nfs_export for mixed-idmap same-sb
 lower layers
To: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>, 
	brauner@kernel.org
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2026 at 10:33=E2=80=AFPM J=C3=A9r=C3=A9my Jean
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>
> Amir, this v2 addresses your comments on v1.
>
> I have split the v2 into 3 commits:
>
> * 1/3 is the actual fix, where only nfs_export is disabled. It caches the
>   first lower idmap in each ovl_sb to avoid rescanning all lower layers
>   for every repeated superblock.
>
> * 2/3 checks that the targeted layout indeed forces nfs_export=3Doff
>   and that decodable handle requests fail with EOPNOTSUPP.
>
> * 3/3 keeps index=3Don,nfs_export=3Doff and verifies copy up still preser=
ves
>   hardlinks and mapped ownership.
>
> I have made this split so that you may decide to include 1 or 2 selftests=
.
>
> I have reproduced the bug through nfsd with the help of AI. The reproduce=
r
> exports an overlay containing a mode 0600 uid 0 file, obtains a real NFSv=
3
> handle, drops a client to uid/gid 1000, then replays the saved handle aft=
er
> unmount, reclaim, and remount. On an unpatched kernel, the replay
> initializes the overlay inode with uid 1000 and the client can read and
> overwrite the file. TBH, I don't know whether this layout may actually
> happen in production, but it looks like a weird feature.

I do not know either.

I would like to get feedback from Christian on that, because if this
setup is not expected I'd rather fail the mount.

Thanks,
Amir.

>
> Changes since v1:
> - disable only nfs_export (keep index enabled),
> - cache the first lower idmap in struct ovl_sb instead of rescanning,
> - add separate selftests for handle rejection and index copy up.
>
> v1: https://lore.kernel.org/all/20260911194201.1334086-2-Jeremy.Jean@oss.=
cyber.gouv.fr/
>
> J=C3=A9r=C3=A9my Jean (3):
>   ovl: disable nfs_export for same-sb lower layers with different idmaps
>   selftests: overlayfs: reject handles for mixed lower idmaps
>   selftests: overlayfs: keep index copy up with mixed lower idmaps
>
>  fs/overlayfs/ovl_entry.h                      |   2 +
>  fs/overlayfs/super.c                          |  28 ++-
>  .../filesystems/overlayfs/idmapped_mounts.c   | 201 +++++++++++++++++-
>  3 files changed, 226 insertions(+), 5 deletions(-)
>
> --
> 2.47.3
