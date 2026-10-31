Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.201
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793488475;
	b=Blm2rJf9y1CPP6y1qQyAXpKpVclo+eCEfjxYAMLY7taDt22Lj5bOzU8nXZYthjkk/U5I
	 7VsNw7P+/hD4m9WSOt2Bwmvqw/EMgafyMjBQfeig2RtSP96gZ7QCh9j/NH5cr8ki2a9m7
	 Mhab0IgUqQbmrO20rpGCgO3k9h5ojOAJvv174sW+Iql72Ygj7ePbz8yqTR2hHAbfcmJIT
	 vMBdUYlocWfVUk52pSZR3nT4IJXfRn6zK/nteUJr+D+wIoiB783Yu6HgU1m+5NjX+Fng5
	 0QIn91xvjNlSooghXzapKJYXYbKzB8/eDDcuuepYIkX5T0aw/pykPUG+H3N7nxpGfFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793488475;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=b5ulenXHumJtq8LULulVlEQpUa3RXUxrO4E8u+hYZGQ=;
	b=VUB7KO0mTxU7pCiEdgmpoj2Opv4IMJnDo/nfDadQ3B5RyKNFurh6Fra3pF3Q2aS+s0LW
	 G8NgSkwjViF8lUZ/1UskffRrQlPmEYZl4m3S13ERpSvovchaoCXIlIpfYPpeKhVsL+V8/
	 /QvOk7xnVVTUcQmF45wZA3ySnG75wJfGJSv/NDbqLJDmtb5ct1JoQ2CUwteuSiZa2lFsg
	 nWpx/wL3I7wp7+d0rwaW+G/jTpfhIWRGNFFVlIVqq3ombWT+MstzbqfH4DbmowTgDyohR
	 ck/P8/GHmEVtTFmmQX9Gj8+R2y8Ya2q2fXfWK2CgrkfWVRYrKlTbRLB4tsIjNax5jPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Je9fUjsB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.201
Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A296D606A31C
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 23:14:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A296D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Je9fUjsB
Received: by mail-oi2-f9.google.com with SMTP id 5614622812f47-4f61e12e8e0so293167b6e.0
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 16:14:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793488473; cv=none;
        d=google.com; s=arc-20260327;
        b=A4V+8NMk7oB8J7waNu8KbMMsojzPRpQwIkYXc9Ix8hpVCYCyallansgs6BNCNzw1B+
         D2GstbmthMOPktMlgBgFSuPOqrRvrIYh0OaAMXlBUHsUfaGb8vMYIzwuqUSnBlaktDC4
         6t8xsqfRaov6DE3pScycEcF0sY2A0xjH2qUmpETYXrvj6EXPMliaLhTy5qh1IFjlKsbD
         +DXxdo47+lSxpmYPDYW0qCdKV+rqiKQmKcrVwsXWXxsrOh9dK6AL/QlXMbgxbdqI0Fsp
         MsXS6AnLJZzK8IuSaZ8fWI5ODW/v9WhhvOG1MgSsTy7KDmUpNJRjHdJBwySP89EbV6kO
         QdGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=b5ulenXHumJtq8LULulVlEQpUa3RXUxrO4E8u+hYZGQ=;
        fh=uLXi0AoMzhh2y6Nw9Lt253mnXoyR/pTOgGol1Ib8GFE=;
        b=aAL1UvRphqM5Z5cm077h/C9CDRSeJALPv+A92AW/SLcue7Ujk/kxZ60mhZyLqrsJsi
         cHDbjfmC8Wpdd+xZyKIwkZVm0YzhPt8Yu6wwe8UuY4H9YMuNjQA10a97yDKeEAstZ4Nc
         U/OtTdfJYomxVfZOiEU7ofbVe61WngurHDiUWWGxkU+npSHqeAIC32oVkZz4ifzvm+VW
         O97/0yRqRt6jBCeJ7ehd7hzZBkw+hOlUjlHn5I10rkcGoUyvLrKlu406kHGH+jnhH61g
         YlvNqI98TyUVroaJ0COJyAsBOjO8DeNXvYsy7bZ5J0LC+miHTRZyNHTdOmftQIWsYSPW
         vTuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793488473; x=1794093273; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b5ulenXHumJtq8LULulVlEQpUa3RXUxrO4E8u+hYZGQ=;
        b=Je9fUjsBtQJ92yil2+q8Uc8UoBtnI/Q8bDR+y4NYLIbyD+He3PVDmjunJJdsSBgRbI
         u10vmRGrWlrmHGniaTSoimt1PVEuRa6JiVMwGuAwrJabT3wncqvPy1NcEq7qz6Y4REDA
         oanffB5sk0SpnYQlUTV2ebqkX/HBe0WSWqYIj6YTJe1Og3WwwvUoEQNX3Nv1FbyzE2YW
         IN0Jiet/1lx5YHPrN15v7BSH3TOWC+1xTJaqgRGm1zb5Hr83uS36piXrrIR48jaoRLoU
         7N3eIEcC6RqJeT4UbeojsOFHCmfW8VnOU/FNf8xGDWsRn9y4kGHdOBRZTTcwDSsA8soE
         dl6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793488473; x=1794093273;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=b5ulenXHumJtq8LULulVlEQpUa3RXUxrO4E8u+hYZGQ=;
        b=11PaV9NivXcglL6zfjRbl1tnkChODGkHIXgCDlJJYtL/LkVXLvnn/45VVQNBW56Egc
         vJayalVbAUDAwDhJq2IWCl1C9/zPKqBlb2gbYBZWqhqk4nLhpWkK4nmzueVUo6RKNHgh
         NKu9nkXF1KQNNvTV5KSFcIza8PY/qr0uk9illDQxnm+W4gMGjpQdFLudlU5hwyEyc6sZ
         AK+YYWd3qgtsaXRmU0qc2A75ejlS+ZQt2sfMHJPZUDFqq4cZd8SSCjx/MGpX8RqWzFjZ
         djxPaCDUNaV7lDjyTGqENbMBgw210ptCCadVHwsSNuWnLQUF9kkKA3WYXBjQjJumeayw
         pVGw==
X-Forwarded-Encrypted: i=1; AKwUvByMUptC1jEfH4tr/lCG93BzypFgj0kS/UXCWwiunFqcOCrUIFS9wgI2+XLfhLQG06Wx4pxjUnIBh7lh04J2@vger.kernel.org
X-Gm-Message-State: AFq9FYKlqJnPbHg1kHAvOf/75IahApcJqFNiHy2S+NpXlv3tAUTxkn9R
	HJQPlW4r0PEHuZzbpTTCX6iKSKErqAPsp/VewQKntgMxgmx80nbaNx3k5O6nh/YAXbuc/08LMgs
	9UM32pA4hbv+JKGnu1YbltOTeSGLEEG0=
X-Gm-Gg: AYBFou1POgNhlYb/wFKSdR20R6ROj2YheENi40JeBDS/kzBOkQIjy+U5Xi0BindQlw7
	8PJFjGzaedBFTFrOzBigIRDQX7F80/6WZ6qC50AN5QTfsc83VioolnTaxG/5s3DEFjL5wHdldvd
	ZHEvAWCeCl7KPfi0Uwfqn/HsOYW3j4g0HsN9dhSUW0/+5czJgEFrVD2v5wCNhXkFD1rsIr+p1PQ
	UC74Y9uRwKpNEKs7VHAtaS3meTxTHg/IJeacx7cw5fUtEsQBZKMxuuw92710rQifvMtOkI/ocsN
	mf3t0TZbszd1oin1gR1Bgxeg5nVVioIuo8HdiKsqEddtTjMvSFQyCy3AD50f6Qvdq531T4rZwm0
	lHJaZ6pO0cGDEm+oXRtF/xY0lU8upAE0Jf6tfMBIXBcq4pimfvE+2FabqW7IIEii/xGOTYc0=
X-Received: by 2002:a05:6808:1a0e:b0:4e8:5ba:8809 with SMTP id
 5614622812f47-5640dd797c1mr4730009b6e.26.1793488473503; Sat, 31 Oct 2026
 16:14:33 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030113201.2921633-1-amir73il@gmail.com> <CAGEkeHekpqv5ncd8tFP2v-OAy-ujTf9_RBbed3dgmTTAQrsPzA@mail.gmail.com>
 <CAGEkeHeBcz2Atc7zz6u-Evd40+AOBtx9Ke+REthvTppxw-vpRQ@mail.gmail.com>
In-Reply-To: <CAGEkeHeBcz2Atc7zz6u-Evd40+AOBtx9Ke+REthvTppxw-vpRQ@mail.gmail.com>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Sat, 31 Oct 2026 16:14:22 -0700
X-Gm-Features: AclHuK8GCKp7TD0QAjA53u4ItOwUZP_Cmf9jolPUWqgYVOzvnXAg3-X3BtQ5-hk
Message-ID: <CAGEkeHfrqbdHW801cjJLu0-to31SkH0Fc2K+OnnjFcsbjVDAkw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Overlayfs casefold fixes
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> On arm64/QEMU with ext4 and tmpfs, both tests fail on ovl-fixes
> (1d27da7de3f7) and pass with the series applied.

Based on the two fstests and the fsconfig reproducer reported above:

Tested-by: Hungyu Lin <dennylin0707@gmail.com>

Thanks,
Hungyu
