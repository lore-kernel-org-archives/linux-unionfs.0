Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69601194A64
	for <linux-unionfs@vger.kernel.org>; Mon, 26 Aug 2024 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724687967; cv=none; b=ca7hCSPvEtl63I7r/jUmJwub+2Wgbc8whFtgO/RgyIh3VfCcobjM0Npx06Vi3MHqRgMJuaL3+3UgTYB231DWV9LAcyExg75kfCjXvL3gLJTNwwxrXr4uQVNvBjTs42VbHambm3FumFTtZ3ESKTuaZYQ0qZf6SiNctgDDLtpnOfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724687967; c=relaxed/simple;
	bh=qY9heMDGehPfNX3k14ciptmMDUnARQZuzI0AJR4IPTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KDIRYgU5eR5ksXYFCy5wdL+rzXv/Zn9oUqS7Tg3kqme78mZ241atz1xe1iaijiQVOQ8k6UpajmXaJei41PR0SpHeIgvj8mSo0Z1pLxH8+ODkxIomyyiC/vLLWzYCkHc26OqHhJW2/S3iK9xt3gE6jfzXbZ9nTJhTBeI3Vx+szGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=L5ipoKjn; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="L5ipoKjn"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e13cda45037so4744273276.3
        for <linux-unionfs@vger.kernel.org>; Mon, 26 Aug 2024 08:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1724687963; x=1725292763; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZFAHSIlyg8F4S4S4k7aYiqj8SkSv6YUioWraLbkEhw=;
        b=L5ipoKjnOPIqEguN/ZYiLc1Ae7zSJ051YlnZlgq0ORK4l0sW4cerTUmt5Yn2o4G9fT
         EPDA8feHNBt8eWNLdW6mW5vPihT9ARWhOcy5yAexiJ953x3MXYU5BjN5PgJR3+COt2/n
         BqZ7QqjL79HqEEQs3udQANGnB2BhEzLXNgljA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724687963; x=1725292763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yZFAHSIlyg8F4S4S4k7aYiqj8SkSv6YUioWraLbkEhw=;
        b=NNHOJydXSR1SYFVNKCeRQZMcBlARh4QRZbuNXVtLJsm2bf/Ou44RgUzBiRIjiXJM2q
         5q4dSzeRefSBZ7j3dXeE0/PzkNqhoZsM5kbGnzTZrwag4yWrrsPpmjVPZGiF4TXtYcp3
         uPYxO5zxJrWTbS66nx7Ae+YNiJ1cfr18iGLmTeMVyHmfM0sfpNaBHqR7D478dvEHEnyw
         cVF94bqG3PCBAKiv2ZPT7CcdMcPw52f8FGvl+DwrEllsleRnFdnyhv9d3RI+6+9I3MZ4
         FqcRBmmBik4oNiZmr4FcwnEhT2Hh4PoX+ymH6oncV5+9K49tlVEL2nJcb6YOAgzylOTB
         pBcA==
X-Forwarded-Encrypted: i=1; AJvYcCUNbqu4p6B+p+zXOBHrO8FUSm1x0CEUv2z8yCrIb0+AOdyBXOZrmIILTSCAENViwXTS3KA8sYCInLyHVmUg@vger.kernel.org
X-Gm-Message-State: AOJu0YwKF83/BSNtoZktgP8qtndDHbBaQ0Y/NIOYupekCpk8Rep/ZKWQ
	xGX1/5P6735B7n9um9idHQsnu+L6oZKXlT46V5rxa9SKapN1CI4QGPfLUMPTVH5tM/KWchGD6de
	d9FJXcGJqgZDaQuG8WZXapZO0iVnuTHWJggDpXQ==
X-Google-Smtp-Source: AGHT+IHsSuPdqP9FiVH+9II/uBOhPXT+6+GarwXIQkTUesIn15cg/W3dSvKyA6YG2bPAM30jpn/lhCOm2enB6Mf0YFk=
X-Received: by 2002:a05:6902:1b89:b0:e11:54e9:879b with SMTP id
 3f1490d57ef6-e17a85d02b0mr11434177276.24.1724687963392; Mon, 26 Aug 2024
 08:59:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240722101443.10768-1-feilv@asrmicro.com> <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
In-Reply-To: <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Aug 2024 17:59:10 +0200
Message-ID: <CAJfpegtPOgowkK5EHxNZnuHDo9AZTbF2-zxMc99rvWL44rdMXQ@mail.gmail.com>
Subject: Re: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Fei Lv <feilv@asrmicro.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lianghuxu@asrmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Jul 2024 at 15:56, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jul 22, 2024 at 1:14=E2=80=AFPM Fei Lv <feilv@asrmicro.com> wrote=
:
> >
> > For upper filesystem which does not enforce ordering on storing of
> > metadata changes(e.g. ubifs), when overlayfs file is modified for
> > the first time, copy up will create a copy of the lower file and
> > its parent directories in the upper layer. Permission lost of the
> > new upper parent directory was observed during power-cut stress test.
> >
> > Fix by adding new mount opion "fsync=3Dstrict", make sure data/metadata=
 of
> > copied up directory written to disk before renaming from tmp to final
> > destination.
> >
> > Signed-off-by: Fei Lv <feilv@asrmicro.com>
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> but I'd also like to wait for an ACK from Miklos on this feature.

I'm okay with this.  I'm a little confused about sync=3Dstrict mode,
since most copy ups will have vfs_fsync() called twice.  Is this what
we want, or could this be consolidated into a single fsync?

Also is it worth optimizing away the fsync on the directory in cases
the filesystem is well behaved?  Maybe we should just move the
vfs_fsync() call into ovl_copy_up_metadata() and omit the complexity
related to the additional mount option?

To me it feels that it shouldn't matter in terms of performance, but
if reports of performance regressions come in, we can still make this
optional.

Thanks,
Miklos
