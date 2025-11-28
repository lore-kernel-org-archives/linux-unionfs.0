Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AC03074BB
	for <linux-unionfs@vger.kernel.org>; Fri, 28 Nov 2025 09:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764323669; cv=none; b=KCTeUA4CtFYo90psBpGmiqOA4/+CE/szGuprvELEWHqg/k3SeF7D/LdyiR7itD/e29N7vxUbSq2oquFXJ/g4sh0dbZy44jjb+MC9+a+IqzWxVnnS6b9qVPqpBk7lvZQB/Iy+K7cp002aGNeDSdnNC1R1VFHKuBeCi54r8hnDguI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764323669; c=relaxed/simple;
	bh=p6xDVMfR9gkE+eSbU52VNKLajdPqM6XNLluxYwkRXGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=STHdCElSJqFdExuRiUjk3/7ZtvUkXVad1tpFsU6Sk4CJJglb8qU0pdCpgjWRbkF1+fvDhnv2QuktgPxGBxYW3whsCm3MiODDEtBsimvSHJC9HmAvi+BJ6RQXmkcXm6ErvhvCp4IvH12NtxsbKZCOF6vs98AJOASLRH0VYMknJrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+S2qF0I; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+S2qF0I"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64162c04f90so3054462a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 28 Nov 2025 01:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764323666; x=1764928466; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVfM55XZctsuDlf5IL66Ry0szMohdC5D1xC0dGz1E+k=;
        b=a+S2qF0IIlXT6G9QzePxP/aZm3lItH9g+oQHnzHFZS7CBL9JVZ6lPDWKi5CFFe9GGF
         GHduVgU0/rItyWnbA+3JgJjEk7UtrHjQsH2xbBogKqQUAtOa8M9tzGZ9LacGUM4jKTwQ
         kgK/GjCmb8WnoaRwLJ9rKQGf+9iCq52KGYTQThxk45A6an5rgImhYYEQC6tuH6/sZQBe
         Q9Bhdb+KIiPfbVnF4gWQju7yGSYx6i07PstFL8H2+Gs2Bg0tVCJLD+42ZUKy2tTyYCr6
         Z6kr/4UIU2nQX0iTZvqLeq3AbV5kOsbz8b31R4eCYI2yepv6N3cfiEbWnz0aknXQfb3E
         bRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764323666; x=1764928466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zVfM55XZctsuDlf5IL66Ry0szMohdC5D1xC0dGz1E+k=;
        b=rDS7gj/kt2fzrouIaEbHmOrkTewxp0K8KbJAuV6+sqF8ixUeGMpRJB0aYBkfyhGGQI
         yi+b3DxSBb0RY9igFrKQ/ae3QHbWXmPjDUl/Dmy59+b7/bzeSTPKx0AbKy+uzugVh9v6
         IW+9BfjwffWGhVxHxG7Two8bqoZ9d5kfL0NobeZ4jHhciYWLwUdr1mmQRnDguqf8i/h5
         GhO1ZkVHsJNnWBnF07DfqlINVDmlhXNJ68S4uFP6+9cx5AR+PmJN9aLfmwJwmHy1H907
         M/pPxVTLSPzJn9x3LNPum4QY/d4CBT6RHXEgVAXWDekMq6qoj0dxXEh8xv+T6XQOSyBN
         81ow==
X-Forwarded-Encrypted: i=1; AJvYcCWeG8Dbe/4LkhwvT4hRrqZgeHiD4P8g1AJ/agCc1pvbeffcRgY9rBNDbey51jdAfLFT6QjgHEqe6NDJNYFx@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9woRJZcwJE4J/nqxjY0ucI/TRfUQ4Sz3oLqoLHqIhp8zh+pP3
	grif5x5rKxoo4fIM2izf/LDSowAbxWV15i6MXdTiF5vDHUCnlc04tCBEiZYcL5XfgjoUv3Rl8Q+
	bLR0sQDN2MwVUfqEoiDW5U7IVUIkvHgw=
X-Gm-Gg: ASbGnctlTScTAL+e3haVGyEvBHpYbNlAW13emPYFEy3KzqXM0hgNOvCad/ZixQ0whXo
	DS2uw18iGflV9ToumzBTKnIsh+QKY1dMNhmRFuD3Yvs0gOQ/An4vUAgRiqSdc948qyu88i3XE09
	6LrodcGfMtAmIbZKE7XPGXLb3hUuSf3OSGgVJPSUyqrpySsOXdIL7bKgmyrFjkADPcjrEaIROqY
	hpU21L1ErQgAuynhaVXqokSz4QE1pJZwV4alyOLTVmbPCHEjxYUl/PxwYwrW8WgCHi3gUkJloFf
	HNvqlcz/GoYFT8SKqeKtzFxUKOItKA==
X-Google-Smtp-Source: AGHT+IF5P3YRfwANyJHOmuLIBZMAq6H4+HrvavYuwv3NP0XJiw4KDaKijJxfhWW8MxX57x0t0KI6hXgkg2dnjhOLfJo=
X-Received: by 2002:a05:6402:534e:10b0:645:ccf0:379 with SMTP id
 4fb4d7f45d1cf-645ccf003f2mr12431894a12.21.1764323666084; Fri, 28 Nov 2025
 01:54:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6928b64f.a70a0220.d98e3.0115.GAE@google.com> <176429295510.634289.1552337113663461690@noble.neil.brown.name>
In-Reply-To: <176429295510.634289.1552337113663461690@noble.neil.brown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 28 Nov 2025 10:54:14 +0100
X-Gm-Features: AWmQ_bkftWXUsBYHw1wIf92KT52rHsS2rxfdZVGB8XMHZt8r8EGcHke-TyxMKZ0
Message-ID: <CAOQ4uxiO9GJVK9wtjSMoajUMRVOAdriiygDf4NqrKZna5f5zTA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fail ovl_lock_rename_workdir() if either target is unhashed
To: NeilBrown <neil@brown.name>
Cc: syzbot <syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com>, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 2:22=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
>
> From: NeilBrown <neil@brown.name>
>
> As well as checking that the parent hasn't changed after getting the
> lock we need to check that the dentry hasn't been unhashed.
> Otherwise we might try to rename something that has been removed.
>
> Reported-by: syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com
> Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")
> Signed-off-by: NeilBrown <neil@brown.name>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index f76672f2e686..82373dd1ce6e 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -1234,9 +1234,9 @@ int ovl_lock_rename_workdir(struct dentry *workdir,=
 struct dentry *work,
>                 goto err;
>         if (trap)
>                 goto err_unlock;
> -       if (work && work->d_parent !=3D workdir)
> +       if (work && (work->d_parent !=3D workdir || d_unhashed(work)))
>                 goto err_unlock;
> -       if (upper && upper->d_parent !=3D upperdir)
> +       if (upper && (upper->d_parent !=3D upperdir || d_unhashed(upper))=
)
>                 goto err_unlock;
>
>         return 0;
> --
> 2.50.0.107.gf914562f5916.dirty
>
