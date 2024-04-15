Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2B41BF2A
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Apr 2024 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713187635; cv=none; b=u+H278XHJQT6tosLoI+eJBpDWyA7ImYk6r7ZHi5k5/Hnm00P8MIQ/7fGcbxDfJRTDaQxHg2EGc0miYvIG9+pneJcNE+x9i7v64AGKjVH4SwXc8q+s9pQMVSQMfOIrJ401Nuh/XzUqkUF3Z35UDtq+8XA2+3o64xxeZJR03w+ZJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713187635; c=relaxed/simple;
	bh=el8wy5nOyvTp9tnPRWIgPmTh9fEykKTto2nCg59IwGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=joJSXrE69okULVlWrbTptoPW+j8eHvPBe4F6oZBTusZUtxQSJYg6W5UvRVuX/SyahDO0RrYa5gvQw9ghd1Cvd+8eB12tHbgLLAuPeo8Z4Y1w0C/jI73QylGEnsRMOUMv8K5z8pVCkQmyCIHO+48WIU7MA4UhAOhdWrwiYzP0HuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eYTgUYJW; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eYTgUYJW"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-69629b4ae2bso29034196d6.3
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Apr 2024 06:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713187633; x=1713792433; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=el8wy5nOyvTp9tnPRWIgPmTh9fEykKTto2nCg59IwGc=;
        b=eYTgUYJW2HHZeJFQMXnDvclxG4jl/+dHlMlC8fQoR/zd7a1By8zt4s19qKU2Bo2hpP
         oDTJ59+mY9o4S3t3DahWNttWC9DhGF5XR8YgXvZv/5cjKztvFyOEa1eSwcLvgQ8d1Ok5
         ad135AioJ3ktzlfP8eeLyNgZmUHkifR387EAW/Jh0+AiUt70eN2iOcFgn0s/IdxAjKwG
         WiVtVKv/r2BSogQLYfExoOrr5jlJ7OkV/4hHpw0vVHjsu6TzVUXOCWiBjGS7cG+qhGQH
         Ys0B2RyfE6DxI2NqYjrwW2zOTtnOusVZ59LhbxQWzoab8Tjm4asV3m5iEqgIP7PnLSSh
         IPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713187633; x=1713792433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=el8wy5nOyvTp9tnPRWIgPmTh9fEykKTto2nCg59IwGc=;
        b=B3hk/eWyFqht2G6G7HgaU1oTpowQEJaaC/eW2mPNEKF7jnTAV/yjHNAmYxRgPIGPEF
         GuPcIchEYUxmEvRc7DgdvMuwEXkvf7DzS5bO10yKP/D/QR5sY+qlsMPE+9ZrFoNv2275
         SVkuytgD8NKDCwLF6uKUOcpXoNWrw7zBIQ4QGDzyOTCStYtzGaBNrpPok+L6xPHy599x
         U5uojZDq4gkva34ycD+Mt7+pmlsQojZk/RRMPdeLUekUoR51CQI/W0SaJJeakqkcM4XN
         UQjPjwcGnFBiufFrSMB/x7gB3EbzPJQcNbgDZd8ZOABpe1bsK4/NfBRL5j5lTZMgpD29
         0SEA==
X-Gm-Message-State: AOJu0YyRIu+XwNc7UMdf7SCpMhw3pkoI+D+JZl8S8aXM6UJRpl1S2zUM
	IlGlgqA9H5A52JhaOoUmVStXPUBLl1VUrBx7Z7fNJ44yvNkKnkG8rpfptv/1WPuYQfiFqQNQM12
	h82a9i+DTfPEGDo49ofupZeQZcLYnYchj
X-Google-Smtp-Source: AGHT+IHCN1Qm54wufIbmMzv3ohuoobwbaOt8BcI2Cr1B55V5ABstGzddeBS2wT/cTxheKmfE+0K0hR5LitARn4wnkqA=
X-Received: by 2002:a05:6214:e4a:b0:69b:d200:eb8d with SMTP id
 o10-20020a0562140e4a00b0069bd200eb8dmr1093064qvc.15.1713187632936; Mon, 15
 Apr 2024 06:27:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <29C3102E-08CC-43D6-BCC0-2CA588A3C5B1@gmail.com>
In-Reply-To: <29C3102E-08CC-43D6-BCC0-2CA588A3C5B1@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 15 Apr 2024 16:27:00 +0300
Message-ID: <CAOQ4uxgYHD2NpEvf=+YgnLmcB4dYEPYJfOym5kb=s6nqmPQGPQ@mail.gmail.com>
Subject: Re: Question regarding internals of metacopy=on feature
To: Yuriy Belikov <yuriybelikov1@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 4:16=E2=80=AFPM Yuriy Belikov <yuriybelikov1@gmail.=
com> wrote:
>
> Dear UnionFS team,
>
> My name is Yuriy, and I am currently an intern at CERN, working on the Ce=
rnVM Filesystem (CVMFS) project. Our objective is to enhance the performanc=
e of the cvmfs_server utility, which is crucial for publishing file updates=
. Given that CVMFS fundamentally relies on union filesystems, we are explor=
ing various features of OverlayFS to achieve this, specifically considering=
 the metacopy=3Don option.
>
> I have encountered a scenario that is not explicitly covered in the Overl=
ayFS documentation: If metadata (e.g., permissions set by chmod) are modifi=
ed for a file that exists only in the lower-layer (and thus appears in the =
union directory but not in the upper-layer), what is the type of the filesy=
stem object in the upper layer under these conditions?
> From preliminary tests with metacopy=3Don, it appears that such files are=
 visible in the terminal using the ls command. However, as there were no mo=
difications to the file content, a copy-up was not triggered. This leads to=
 my question about the type of filesystem object represented in the upper-l=
ayer directory when only metadata is modified.
>
>
> I would greatly appreciate any clarification or additional documentation =
you could provide regarding this matter.
>

Hi Yuri,

It is a regular file that contains no data (a.k.a sparse file) with an
xattr =E2=80=9Ctrusted.overlay.metacopy=E2=80=9D that is used
as an indication that this upper file contains no data and that data
copy-up should still be performed
before the overlayfs file is opened for write.

Patches to clarify the documentation are welcome:
https://docs.kernel.org/filesystems/overlayfs.html#metadata-only-copy-up

Thanks,
Amir.
