Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ABC1BD9D2
	for <linux-unionfs@vger.kernel.org>; Tue, 11 Feb 2025 12:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739276085; cv=none; b=k4HUgEuJ5VHzdfDBOhKruAZvMwxHNt9XFnh3AP+br4WpMCZaFgukv8IEbURLJn3O8vf0bseRVw+O+3cnQh+TWUmGdFx9Z5bMzL5KCZ7EmvsVfnEzSRJzaab9sE4ljUcKdVLe2qW3oU69AdCyv1KsIQ4Ky62pp9w8e+tuzOvLVnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739276085; c=relaxed/simple;
	bh=P+115TeWGvefTCOAOdhDLh56cNX/bAd9/f2jYPAwgkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nnl2Pi5hGOi+FcNr+p542YuaNnlWP7psD1sHj2wwLpL+z+PQwX3o7WqfZu6BYfNv2apXr4YUn49C/eAOcvmpgSIem7+Wzy246ZNGTEeNAZH/cZKNGTooPxsZNa2ZqgAE31JLLf7cVOGIBt2kBIpjDPoBbZrptrSzzrfnSzRZ5CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Xz6clA1X; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Xz6clA1X"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-471899f228cso19769981cf.3
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Feb 2025 04:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1739276081; x=1739880881; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUJokO2qwxWVfabSA/BYVONxZz6dHWxK6xx5SuVb1G4=;
        b=Xz6clA1XwKBsJZ6va1q0vXtWGO5WmdLImaCfeOjZu1/pt9ppYC5kZzP6S1frTVRC4Z
         2ese96vc3dSM0X3wwjYGo8evCwZf9g0fMkoxw6MttMSTcozOVujpwMg3vtX/3PK/KYCQ
         eOk01/VY49ccKqYlvBhF5mP6oOOKJWF5xmvzE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739276081; x=1739880881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rUJokO2qwxWVfabSA/BYVONxZz6dHWxK6xx5SuVb1G4=;
        b=pao0JtANVU+YEOXzooLv2R5zlDKiT5Kal0uJiPRmb5APJoB5KZ98v4+h7+yh4bwiMU
         fb7RShj1FxnXs+v4Typ454+rrX3/Z53TVisr7itfIBi++PAay3kNH37WbcZN6dnR3a5j
         bZzizSFFQqBygSl3MpoPaxAgC+BuG4zkGqDUP7G3l8ge0t1UXXKUK/QcjzmB3iz+ii63
         T7i3K5ljQPIumkB9uB7tvh6A9nl3sTg3ik5cE2FALpPvhe/xzEreUirOCFSNpnaQImvR
         s69IouiZn5NYWVrJxMT82uvdGkzFOu1AofZz+YDZpM+S4dzEQhIiNkdbFGwKDhvfYY5h
         TsiA==
X-Forwarded-Encrypted: i=1; AJvYcCUPQWKt5MQnKzZEZ5/+G1P/l+XqtX4r24cXFhF39vri4MNSXbKPIf37Fhf3ORTU/9UjO2hMEsgk2R8/3Chv@vger.kernel.org
X-Gm-Message-State: AOJu0YyrT//ZJgCurD3CXGnNhas1qOxWVF2AeH5WpmiNw9LFc/Rhc2zz
	ieyMetCgE7uSIexX/fQxn2bYNUbcBa/TxXq5MWNHa/LYa6Tm072MWt/6xxwHYneletxpJ8glb4Q
	dermkmOzfE/QjcFEwp7/y1z6YnnsSVAm3GcNjog==
X-Gm-Gg: ASbGnct+5IfJNFqmxch+0WFj0fmI+0Ho4i6hUEZh1qJ1bOrAnmWGFkv2jg38VqRY3sz
	X8lpTPyS6Et9JbDonVfE3OBeQoyvB/9hE7bKVld6hP3SCpe6Asm9Gzc/IrtIstPLB569wUQ==
X-Google-Smtp-Source: AGHT+IEOzfq3v/9xFDeXDWSg3OQME7Gzg8NYIJD8geqDjZtHJH7+1HqsC06JZZ8s9GXuWle0PojQ6JDnxCO+S7ptWt8=
X-Received: by 2002:a05:622a:1209:b0:471:a31b:2ed4 with SMTP id
 d75a77b69052e-471a31b2f2bmr36265661cf.52.1739276081464; Tue, 11 Feb 2025
 04:14:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250210194512.417339-1-mszeredi@redhat.com> <20250210194512.417339-5-mszeredi@redhat.com>
 <CAOQ4uxgOwu1pnS9BoMYDua6D4aJ+UUOwbsSyUakP2dMd5wQaBg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgOwu1pnS9BoMYDua6D4aJ+UUOwbsSyUakP2dMd5wQaBg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Feb 2025 13:14:30 +0100
X-Gm-Features: AWEUYZnQIjEJy7kAKG3hdMqZ7Bm1391gn3VLr5QlnJ8MPRWHJftivMyXJt4WAVg
Message-ID: <CAJfpegtPj6FW59xpVBSxL8UwhC8qPv6gCQov=2QQUty0YW-6rg@mail.gmail.com>
Subject: Re: [PATCH 5/5] ovl: don't require "metacopy=on" for "verity"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Feb 2025 at 11:50, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Feb 10, 2025 at 8:45=E2=80=AFPM Miklos Szeredi <mszeredi@redhat.c=
om> wrote:
> >
> > Allow the "verity" mount option to be used with "userxattr" data-only
> > layer(s).
>
> This standalone sentence sounds like a security risk,
> because unpriv users could change the verity digest.
> I suggest explaining it better.

Same condition as in previous patch applies: if xattr is on a
read-only layer or modification is prevented in any other way, then
it's safe. Otherwise no.

> > @@ -986,10 +981,6 @@ int ovl_fs_params_verify(const struct ovl_fs_conte=
xt *ctx,
> >                         pr_err("metacopy requires permission to access =
trusted xattrs\n");
> >                         return -EPERM;
> >                 }
> > -               if (config->verity_mode) {
> > -                       pr_err("verity requires permission to access tr=
usted xattrs\n");
> > -                       return -EPERM;
> > -               }
>
> This looks wrong.
> I don't think you meant to change the case of
> (!config->userxattr && !capable(CAP_SYS_ADMIN))

Yep, good catch.

Thanks,
Miklos
