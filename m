Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.134
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793526787;
	b=FSk7HILqyruhlTDgQA8L1+RfPMDRllBc0Tvm2L6MFPERJkHujsaKk90wFtsA7z4SyPEV
	 lmJjIdUQSvOuW/qAqKQ/7zjGY2tk9SyEPkoOW2ciqF7bwtVnogfSAjPYB1orsxNzg1vXw
	 norTUUuPcMJ5rz4eROInD16wPxxQ7XhG9jGvR8LZmhSZ3p+VcNdmljHPd2DnIxTd0RiUG
	 Geh9BPnCbaKwfb0QjLC/bjbVn4uLZ/2sdQfmUKNs0Jtm4CxFgYC7nqz1pRzp5sx/A+KOj
	 sU8Lb6SSuSZlx9S4CsQ/VAiqvGiejiH/wztC2RZfsmXIXaocAoH9kpDYk58v61CLSpw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793526787;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=6+Z1HcyucRArSh6XcF3VCepTj+eagFW1p74LS1mjYl0=;
	b=JJiHX6msKsWoaJaKkEDmIwQp3OmeDPOVY00iGepD/ueulzqVC9PdSGpik7XeLtOt4hQc
	 5890gBScZNmWmEv/Jj/8DvgRjUOTIKFk6YZG38OODPAsOjD6xDp9SlkEtKO/N9qIB1DGX
	 o80C+grYt0oIsizqglRXNNSwXvpFzC9va0+cl20PXtZBTTacGkynyblcsjZ9nsqPNTq+p
	 /oawQYB3GLPt4UGyUqSZ+cMTjGnSMP0LcbsqlPpUVPnwfmVLmub6EBMbM+DpuqpzQI/kf
	 vux1imA3do9qOuK01oI+ooFWtuwZ3pN7luDUUE4C3OOeM35AQl6J4GVzDGj/aKFpJrw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OvMYEV6i;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.134
Received: from mail-oo2-f6.google.com (mail-oo2-f6.google.com [74.125.231.134])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33129606A324
	for <linux-unionfs@vger.kernel.org>; Sun,  1 Nov 2026 09:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33129606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OvMYEV6i
Received: by mail-oo2-f6.google.com with SMTP id 46e09a7af769-8216bf5eb5eso962666a34.1
        for <linux-unionfs@vger.kernel.org>; Sun, 01 Nov 2026 01:53:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793526786; cv=none;
        d=google.com; s=arc-20260327;
        b=JEl1v9WdB0YV6R/FnCY9C0yPnh1rPVeFCSepQyodRNzXiE6eXo9SG41Lud7kQfJAuu
         UT69yTTbH09uhgNWw4wxL2+9c4tmlRFyxAEHTzDxtbYFyuiTK9SmG9FyyzZN3Ebopw43
         281l3GcBRBgFhyDo7W2Rf9RqMafmFPqVEdWrja2zkYVf+316dTNn6nkZSoh2FB7p+B0Z
         OKh7iC8TnT1Zj9ICeaWDOavs9fDBFWlMwnN2zWDqmM0/yD/AqbQnlBV3SeTT3jGAW/Ty
         so/eEG3A/Z5gw2ppXSVN9J1VbfikDhpOa5pRs/fdIF0Dq8NDtelMIv43sM7/W3B3LV+k
         1pTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=6+Z1HcyucRArSh6XcF3VCepTj+eagFW1p74LS1mjYl0=;
        fh=1eLIIsUavjhAXaBiNzb6tCJhWmkt8k664rxwOAEL2UQ=;
        b=slwuBaZS4fC1FnTLkrIXkDXhuXQWC8ERDUjmhfnm3I7F6Pyno1QX8hm3r3lH23wAiS
         M9WlDl4QuvUmjtnR62Z/UdKkohqT5R6gB4lORZbn9pFTtGCBsmvU5cVMSqVKDcppCPX1
         3iKyyb8JqwHEqmRNvdv6vq159T91VQrigiO78aJ5zu+6yQ4+V2S3zXg+x7K4r1oP3nwt
         cyuITHGkc6PUmQY79JonA2Ako8mbzbn8Mpjyssvcubs1/ju+rGWvzMF5yO9kD8Rbf/c9
         gTN6ch1jv3saRAotZJEb5ieKoobs+0HU45c68cz49gp0DnVaCpgXkoH8CxE4QOqu90ge
         s5fg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793526786; x=1794131586; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6+Z1HcyucRArSh6XcF3VCepTj+eagFW1p74LS1mjYl0=;
        b=OvMYEV6i2iauu2LTuQBYnjshutwyWPDNKqvesrdch0d0Wczq+hIKcFuNKqC3e8USi8
         8bz5o4YrqpNN77MZfcqMBciXeztqO3McW7kcNIWLl4PCLd66HD4Ml1aEYU56n2ZLJYau
         orY5Vw8GJkESrMqGTn2qE6mMaLQXtl2kR77UV4AiJm5hdWgWct8s6kfXPe5EjIzKVNXV
         RMaObVaG9OCDYGCZ15qemtA0IuCAsc3D7HdpICnJdHsvohuHcPa8CYRfxHzHpTQq6Ht4
         T5YB+UpWnVqHHvS2x/0pt75CaokI6Q2UszPBh7ovjiHpSmquII0BwLAVFiUnHDbNwkqL
         t8DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793526786; x=1794131586;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6+Z1HcyucRArSh6XcF3VCepTj+eagFW1p74LS1mjYl0=;
        b=afUrdnGq5uLNvxNZDF3jloaTzdXCfK8reJ+4ckGuYMmvt+mNnjqbsNjl+KhZ3NMLDm
         A1BTwIR1Pm1CqTLuE9Fny1XUASTvjXZiVXZHuPcngojWiLX4LQ00rzqts9D2p2x7zBpv
         BVoKVWPRMEdAK40RH7woa3r2lGchSpyAJOaLgcNu1mldSLQzJpv2lKIsC+eGLOjOrB47
         zRO+6Vw0RlGy0ueVdN5Uz4UMJX1NnQtHtUIQmgZQSI307uzQsf7Xtkfj1g/vBZ1jmJgT
         pAdis7MzU3UoCnTsjMU2sVjLvvsoGWjEKL6CzS20Nj2ejPNxN90V2zyJrW0zp55oyVKR
         ELHA==
X-Gm-Message-State: AFq9FYL3afDMbN03oFIPX3pgmN6E24UqvKruOGucX++kFHp9RDIZqYzL
	A4ScCDWEDD1oLJQjYyQog10im3eaxt/+440rvtNiCPmOBCHKm9OIY+ZlYgaixFyMOP+7Un4hn9h
	2c4uz2HGZpPDE6UJRYlIcCshBsRj4698=
X-Gm-Gg: AYBFou3O4g3tioNEAJzdosCSCpNm+mry4WzFdiPSWCE0F6oTixOS6zR1fPkkRldt6zy
	Cl0A8bV6DpHcxiOybJ6ahf/MaGQZpW4LvEIGmxZzpTt52x2tvMHk2rJXWt6P+W2Gx2zX6oCHgy0
	VFYTcdhqAU/SUaTCx2fm6SZueQArqx+LY1ePtdsxlxjI5OJX5eqRJM1YnbrvGG+mmQih1vkYeqW
	iT5fA9JJPSEqaUXTZ9Klt2Go9AifAhCybdYrUHB2dI20BW0kmoddPUgKErZEa7JVySnPQLHFpui
	byUhYPKTU2ar4yn4uwWkxS+q8rvjfhPCv54tQc0c5GGG1f5V6NBAqrbScgscHWimSWVDJIVus/l
	fv3RilGUI1Ral2r8ZInICq9e10je+iV5nF3Y/55Oq4wqRgNGbYXW35cfg2jCELuxO4n59XpA=
X-Received: by 2002:a05:6808:13c7:b0:4fb:ac9b:b06c with SMTP id
 5614622812f47-5640d973571mr5026749b6e.1.1793526786130; Sun, 01 Nov 2026
 01:53:06 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Sun, 1 Nov 2026 01:52:54 -0800
X-Gm-Features: AclHuK9NsfrNbFBROmh4ZgKyencv594QLJI8SgBvoXw74aLz-zgoV3FFUaYfe3M
Message-ID: <CAGEkeHcg06kHshHQ=9U6Yrs_wm8W9H28o9bcC2Qh3fw3tANbWA@mail.gmail.com>
Subject: [BUG] overlayfs: inconsistent d_ino in overlay/077
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Amir, Miklos,

While testing the casefold series on arm64/QEMU with ext4 backing
filesystems, I hit the following overlay/077 failure:

  entry o100 has inconsistent d_ino (131490 != 131280)

This also reproduces on ovl-fixes at 1d27da7de3f7 without the
casefold series applied, so it is not introduced by that series.

The failure depends on directory ordering. I reproduced it with
the ext4 directory hash seed 00000000-0000-0000-0000-0000000088bf.
The upstream overlay/077 test and its helper were unchanged.

It appears that ext4 returns a buffered entry after the file has
been unlinked between getdents64() calls. The rebuilt impure cache
no longer contains the name, so overlayfs reports the physical
upper inode number instead of the lower-origin number.

The symptom looks similar to the merge dir case fixed by commit
9011c2791e63 ("ovl: skip stale entries in merge dir cache iteration"),
but this one is in the impure dir path.

I don't have time to pursue this further at the moment, but wanted
to report it here in case someone can take a look.

Thanks,
Hungyu
