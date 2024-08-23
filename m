Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACC514C584;
	Fri, 23 Aug 2024 11:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724413372; cv=none; b=Dhcnj3LcPL2jhsNzsDInfiacOU/yOKC05x6Jkg3dOrWQV6JTagKRUWXxN14uCtPPUvm9q8xTuwVfLc0tqKuCBCJibHKEbmtnOZmYHx+zJUdF+ejRsY2+rfTaC3N09RwZfYABoW2w1FXpL1XQ3QMv9ELinkqGdtgJFn/wx+77B90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724413372; c=relaxed/simple;
	bh=poVf+f0hDEStPJ9i61TomV70OFxKjEx6f2R1KFYaFlE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kipQdDnZymfShtfl6rCaNI56tsBI0NPF33VFENQuSSKxbi2tX1iqf0CWgFT/sODftAXu61qDdaH3CXU4xCk9Gtrpl9pBTRvMNIt7mlkMdF/a0UNGFC1VMvt6iJDwRvubf8Hi/Fk/tu1wEwRlWchXd+SLT2FvRx6ti6f9PI/wlnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cfqRyWOo; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cfqRyWOo"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7a1e0ff6871so116766485a.2;
        Fri, 23 Aug 2024 04:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724413369; x=1725018169; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U+uO1KrOFly+n91uILNS5FWm28YEDDZ6TnmOmna396I=;
        b=cfqRyWOoB56dlNb64d9GIjkaGG2IlKGu+QTerqpj857q8tH4e4LvEg4clly16uSamW
         FYFZlq4bxDsf+t2R/45R/9d0ntkqg4Hv+cguY8TUM3uDrvZCX+WmuGY/t4uc1816wi+J
         YsVlXmN5XL9QJwGfScewylXQoD52Wb/PZpJLVMq8XXJfTHiULQfFa52fR1x/fQ7/VDoC
         WVz75oABxnOz46rpo2ImeUVt+d3DBmHk3y1BAoS1uXMAAZ2iHN09hO2G4etfCjAGjwAS
         i1LlWWotTi7RA9WJzfU7nUcCS0u+WZcQBJPorZGhz1xueOmSiiAXSY6vaLY096fJpz10
         JyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724413369; x=1725018169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U+uO1KrOFly+n91uILNS5FWm28YEDDZ6TnmOmna396I=;
        b=bqCeRFdNFEfMo13lk4Zu4d7Fk6duMfuIFAQZFIYCxdRgVbBWqpOb8uxlNbp26RV3ae
         anD1GyfhO8NmG/iW42j76/Rt2TlCGdWPBhj1JPWSTufbLpCQ0CSK/5ANWi6BZYS6qX/Z
         1VB25kLsG+E6Er565saj7W0JapMreR0koKPNLVUT6a1ihv0X/OaCBncexvOLMXK4AMdF
         Gyqm4HBGKVyVuFEvwrfteZ+szgIPPLFE+DN05rx7PvCQmqx/MCWd/xtR+fyuu84eTyvp
         rzy78qSi3HNsTvxrFrw0B90Xxg8MD4ZvvTME1Przdf22v+l8VNMVzBeuGTCCWV9tFkv4
         1Tqw==
X-Forwarded-Encrypted: i=1; AJvYcCUSqn+owIJMxBDsnrhaFx7alAUzxYU1V7Nysyp3afQ7tyPdCmVF5xORKnJyEhLUrOFP7sIeuQF2kNPwcXLYWw==@vger.kernel.org, AJvYcCVy6CWGotXtlsV1w+mbpCWu4dOt+Rl4OZVUgLuI5nTBLGUM/75epeNh0kgYo5VeWO+xVB3X3YwnNZ12CcA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwouO0ZPdtsJjDCXVGgrPrX4OvP37mDFVVq/7RRLo1aSm/inOWI
	9FEwhC4gs2mC1xRyA/Wa5wsQlrvYfv0+pDBsf+OXQYHZNw/cM1QzSXU1R2R2YdM/2UO9s/0Z7Lf
	KRdjcyLctJjOwhBEVt+ImYiFek1PQO2Stw9c=
X-Google-Smtp-Source: AGHT+IGL/KUNvurGpal/NSnKN/f/vf83N3fay/eMjT4LreU+o0SwzF6pgDy/AFPi4ftPWCotqb1aijPZ8mt+suWEP4Y=
X-Received: by 2002:a05:620a:1a9e:b0:7a6:66da:fe98 with SMTP id
 af79cd13be357-7a6896e8adcmr182035585a.2.1724413369201; Fri, 23 Aug 2024
 04:42:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240722101443.10768-1-feilv@asrmicro.com> <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
 <CAOQ4uxgbbadOC_LCYRk-muFKYH3QNVnD+ZEH+si-V1i3En66Bw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgbbadOC_LCYRk-muFKYH3QNVnD+ZEH+si-V1i3En66Bw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 23 Aug 2024 13:42:37 +0200
Message-ID: <CAOQ4uxiDokEQ0ZET+adP_CpvvTCRRLTcVb9d5mYAmM1q7y2PnQ@mail.gmail.com>
Subject: Re: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
To: Fei Lv <feilv@asrmicro.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lianghuxu@asrmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024 at 11:51=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Mon, Jul 22, 2024 at 3:56=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Mon, Jul 22, 2024 at 1:14=E2=80=AFPM Fei Lv <feilv@asrmicro.com> wro=
te:
> > >
> > > For upper filesystem which does not enforce ordering on storing of
> > > metadata changes(e.g. ubifs), when overlayfs file is modified for
> > > the first time, copy up will create a copy of the lower file and
> > > its parent directories in the upper layer. Permission lost of the
> > > new upper parent directory was observed during power-cut stress test.
> > >
> > > Fix by adding new mount opion "fsync=3Dstrict", make sure data/metada=
ta of
> > > copied up directory written to disk before renaming from tmp to final
> > > destination.
> > >
> > > Signed-off-by: Fei Lv <feilv@asrmicro.com>
> >
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >
> > but I'd also like to wait for an ACK from Miklos on this feature.
> >
> > As for timing, we are in the middle of the merge window for 6.11-rc1,
> > so we have some time before this can be considered for 6.12.
> > I will be on vacation for most of this development cycle, so either
> > Miklos will be able to queue it for 6.12 or I may be able to do
> > near the end of the 6.11 cycle.
> >
>
> Miklos,
>
> Please let me know what you think of this approach to handle ubifs upper.
> If you like it, I can queue this up for v6.12.
>
> Thanks,
> Amir.
>
> >
> > > ---
> > > V1 -> V2:
> > >  1. change open flags from "O_LARGEFILE | O_WRONLY" to "O_RDONLY".
> > >  2. change mount option to "fsync=3Dordered/strict/volatile".
> > >  3. ovl_should_sync_strict() implies ovl_should_sync().
> > >  4. remove redundant ovl_should_sync_strict from ovl_copy_up_meta_ino=
de_data.
> > >  5. update commit log.
> > >  6. update documentation overlayfs.rst.
> > >

Hi Fei,

I started to test this patch and it occured to me that we have no test
coverage for
the "volatile" feature.

Filesystem durability tests are not easy to write and I know that you
tested your
own use case, so I will not ask you to write a regression test as a
condition for merge,
but if you are willing to help, it would be very nice to add this test cove=
rage.

There is already one overlayfs test in fstests (overlay/078) which
tests behavior
of overlayfs copy up during power cut (a.k.a shutdown).

One thing that I do request is that you confirm that you tested that the le=
gacy
"volatile" mount option still works as before.
I saw that you took care of preserving the legacy mount option in display,
which is good practice.

Thanks,
Amir.
