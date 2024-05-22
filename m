Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ABD7E777
	for <linux-unionfs@vger.kernel.org>; Wed, 22 May 2024 20:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716410095; cv=none; b=TG6mAATjCECJuH3DU0KPM+PWYpUSRJpnKxJkmVLDLbGbGfKBOvYzxYsVbq6Y+yvUQKo4lb+IdQ3joiYQjZb8j9aMwuAfyf5nWYmG/XLv76o4YBBLae9AMEYC2xZ5+gbHAUGPuq5M9oxyYGWXKEfOi4WrEURRc+zppxX38X8Zdf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716410095; c=relaxed/simple;
	bh=CrYQhOBYWXqbmbcLtKaFIz5hiR9F2hpmuYZf4yBHHuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D3ECh/NqO3In4/HGR8vMCGNmrJK9+RtADiLcv7js13gGoPntoA6NjP+FLweOF48Xh7J+svpjbe+tWHaHc+eoIpnoQz9zH9s6FVfdqPIbvNxcJGeKYpFy/XbUJbOlBfS4zrrCyHbqUpsNSV6kRZ/gxIfUTNwb0y4zUvrSg/xyrZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A9CSais5; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9CSais5"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6a919a4bb83so20361106d6.1
        for <linux-unionfs@vger.kernel.org>; Wed, 22 May 2024 13:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716410093; x=1717014893; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CrYQhOBYWXqbmbcLtKaFIz5hiR9F2hpmuYZf4yBHHuU=;
        b=A9CSais5eVYSZyk+11yS1jRy4BHahOB60clHOI8/NpiO66meohKOvIWxVcHeXWOO/d
         DAv8dMmdp/qXzRSiZzbYsQvF5TKOMXJ7GPK66CvZeN+P25lmOx17At9s6TcdEQnZZEWQ
         qpt4t8u49KSQ9+tmXQNk7QhUx4BksVAoUrd+fyPIM9bs4aDLOEW9Niv1H8Rw8Lz9smru
         bkLMk9KvVQxnvQjFmuT5z626neWudk6EOb6oo4yT9T6kxhQ7cN1wLI2palMj6iP8e8hl
         e7eiJpFk5u7RHgtg5M2y91nM2Dlu1zw3UzEQib/lCDToF0/TkerZTkWIEUxGYHj1G0b6
         dJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716410093; x=1717014893;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CrYQhOBYWXqbmbcLtKaFIz5hiR9F2hpmuYZf4yBHHuU=;
        b=qimkryLh69kBg25B7lyvIu8u2O0na+SvZ++8/LpBTWYdXGv69/ElL8sPvfMOv9oynW
         1FnVsjCtaUAK22l0acwOyq1Uz/KRFijtfa+FbgNmNLV5iNIcrK+gl/w/WzkWQQVfjijC
         XF/mu0OZvN3obc8qZZ3Jn55N5nLQsW6a0qZxg19gFSnJP33bg8Min2huZmEX+YOzb/lO
         qI2Omf3s/29B4KK7QwJLzRxTbByRkIRzPRSri6lKvzB4Jz9Vsk8a9WYz7ZOGNZ2OygIN
         D9IcqGHV7UEcQk+dLVQMBEqivdS0pOXPV3yIF/XG9uCM0uLAZy5HIXeNV8d5sSNOKGZm
         dHow==
X-Forwarded-Encrypted: i=1; AJvYcCWyV/kwA68KWbc0RlAOroGN9aeeiUC0fGZ6lKsJiJln7cInI8Dn+DtoYgv8ARQvHK/xk3Y4Umul2NkN7CJdP4AEXLo5kI/cA3Pib1tq8g==
X-Gm-Message-State: AOJu0YyWhIkuvUr4hD3UWP1IVEcsDHi/pN+0Dl7ZxyG7lYXgjMzomLtj
	KlB3Edc0GaotWfFqlyqbjLOIB+IjDIAVYgoSF8v28mZT/CHyIa3/SAsbeY9OUUL/GHyPkWxrKla
	MTz3XH432LH64b4/VXEG7JaUYrPk=
X-Google-Smtp-Source: AGHT+IFjdJxhnGlERooT//eMjlFWrX9ZjcbPwlCIgVZOwBEFmIIzrE9oiYTnOaEsYJzkBia9Xh9J5ACizLvnsD+44BM=
X-Received: by 2002:a05:6214:5814:b0:6ab:82d6:f01c with SMTP id
 6a1803df08f44-6ab82d6f1b9mr29130806d6.39.1716410092815; Wed, 22 May 2024
 13:34:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a89eab01-6856-49dd-ba5a-942d58d8ebe5@e-gaulue.com>
 <CAOQ4uxjmfSksa7W88B2xq719RdZGGEqvY5OQzZuOMPCmRyG8Ag@mail.gmail.com> <9c0ea3be-9022-4b3c-b2ad-8e6e34486092@e-gaulue.com>
In-Reply-To: <9c0ea3be-9022-4b3c-b2ad-8e6e34486092@e-gaulue.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 22 May 2024 23:34:41 +0300
Message-ID: <CAOQ4uxgXiFnvNV7av5dMoF8YS+JPrUM2L91pRXtdZ5gVA5=HFg@mail.gmail.com>
Subject: Re: Overlay Filesystem Documentation page
To: =?UTF-8?Q?Edouard_Gaulu=C3=A9?= <edouard@e-gaulue.com>
Cc: neilb@suse.de, miklos@szeredi.hu, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 7:27=E2=80=AFPM Edouard Gaulu=C3=A9 <edouard@e-gaul=
ue.com> wrote:
>
> I tried to provide a proposal, but I worry there are too much thing I don=
't fully understand.
>
> Could you look at this "use case" and associated questions (I tried to an=
swer some)? With those answers, I should be able to propose something for t=
he first 2 paragraghs.
>
> /dir1 : production website
> /dir2 : website source code (git repo)
> /dir3 : transitional
> /dir4 : workdir
> /dir5 : dev website
>
> Mount command: sudo mount -t overlay overlay -o lowerdir=3D/dir2:/dir1,up=
perdir=3D/dir3,workdir=3D/dir4 /dir5
>
> According to me, undefined behaviour is coming from xattrs created in /di=
r3. So, everytime a file is changed in /dir2: /dir3 is emptied and /dir5 is=
 remounted.
>
>
> Q1: If =E2=80=9Cmetacopy=E2=80=9D, =E2=80=9Cindex=E2=80=9D, =E2=80=9Cxino=
=E2=80=9D or =E2=80=9Credirect_dir=E2=80=9D is not used, do we really need =
to empty /dir3 ? Should be 'no' due to the fact we won't have those specifi=
cs xattrs.

hard to answer what you *should* do.
only thing I can say is that the results would be quite predictable -
dir5/ will be the merge of dir1+dir2+dir3 as one could expect.

Note that there are some other xattr in dir3 files - "origin", "impure"
Specifically, "origin" is always set on copy up and there is no way to
opt out from it. if does have some impact in this scenario related to which
inode numbers files in dir5/ will have after this maneuver
I have no desire to document the expected behavior in this regard.

>
> Q2: If =E2=80=9Cmetacopy=E2=80=9D, =E2=80=9Cindex=E2=80=9D, =E2=80=9Cxino=
=E2=80=9D or =E2=80=9Credirect_dir=E2=80=9D is used. Does emptying /dir3 be=
fore remount remove all possible undefined behaviours ? Should be 'yes', we=
 are restarting from scratch.
>

dir3 itself also has xattrs, so it needs to be recreated.
dir4 (the workdir) as well.

> Q3: Knowing that the website will never modify any files in /dir2 (neithe=
r production nor dev), do we really need to remount the overlay everytime a=
 file is changed in /dir2 ?
> Files in /dir3 will never overlap with those in /dir2. There shouldn't be=
 any xattrs inconsistency. Is there other risks?
>

Yes.
Overlay has many caches. Changing lower layers while overlay is
mounted will have unpredicted outcome.

> Q4: If production website generate cache files in /dir1 and dev website g=
enerate cache files in /dir3 that may opverlap. What are the risks? For /di=
r1: I suppose none. For /dir3 ? And /dir5 ? In ohter words, what do we mean=
 by "the behavior of the overlay is undefined"? Could we say : "we don't kn=
ow which layer file will be served"? Or is it worse?
>

For changes while overlay is mounted could be much worse.
Let's just say that the statement "...though it will not result in a
crash or deadlock."
is not really a promise - it is only a statement of intentions.

For changes while overlay is offline you wont know which file will be serve=
d
and it is quite possible the -EIO will be served in many cases.

> Q5: Would mount -t overlay overlay -o lowerdir=3D/dir2:/dir1 /dir5 get to=
 an undefined behavior, if changes to /dir1 or /dir2 are made? According to=
 me, as /dir5 is RO, it should work, always respecting /dir2 priority above=
 /dir1.

For changes while overlay is mounted, same answer as above.
For changes while overlay is offline, same answer as for Q1.
results should be quite predictable - dir5 will be the merge of dir1+dir2.

Please refrain from proposing detailed documentation on what "undefined"
behavior means to kernel documentation, because I do not want to commit
to any specific "undefined" behavior in the future.

Thanks,
Amir.
