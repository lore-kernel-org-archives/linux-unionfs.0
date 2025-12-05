Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1056C302149
	for <linux-unionfs@vger.kernel.org>; Fri,  5 Dec 2025 16:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764953399; cv=none; b=TtdJH89Uos51fQs98B2Lde3+FxgHnLlT35xBbbSD6ipCA78fFZI5ycOIVCNB6j3oW9trudFvNDow6W9dqGaNWXTEJYYFmwBeUFdhVLRVzKQiwgHXVxrZiXJAkqXFat+NvIlGhysKtAckE9Xnfeh+aqs644zPQUSzjY0fL/cCZkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764953399; c=relaxed/simple;
	bh=S44aWYDgH/L//m5SJH8feoTD7x5AMZ2hYNyqwCckyWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bd/EDm+HRSaaIr9R1bYi4zpbJPOO+JEjZYIty1WZZpxmFx+OQTyoB+Oe9LdO7+ewLqdpmHDgfruAjLtg58WXqCr8NRruYs0zGubP34TkEFh2fcCLNlsTyBZfOu+rUEPtwbd+AA1vMOgTCoSJ8P64RamKWjTbVoaeFSYL885vMf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=AE7wy9OA; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="AE7wy9OA"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29586626fbeso29025755ad.0
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Dec 2025 08:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1764953389; x=1765558189; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFta1eTe061x4aiEFe5juzgftswqmH5K8rJIx5K4PRg=;
        b=AE7wy9OAbs4QrmVIBK++VC2379+yCH7XzbBJu9O6jInGQlBTsI6LBCRFAh8GzUC7t/
         RBO1r0lIx6g1eT7wJbf+8pylREjgHGDLIavvuuAb7Q8MI4d3RDa04eXi/pIWD9T4Ul46
         QUiryhP4HoXJHgvLtjxlYxSqAa4TrkWSPuSoPCFC36x3IeHybuGUgo0GY2AfX2fxKQRg
         NCgHygCuxhCnEyZodLfQM6QqYWxNJTlhNIST8daII+RhBGJHZEJKLBtX40VxSpwMCiRz
         SQp3n014Is2TP1CLA3xEQKF009ZPH8IXCIfgACu/eDWLyu0McIxvrE8I1JyxQLx1fB3d
         7BpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764953389; x=1765558189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mFta1eTe061x4aiEFe5juzgftswqmH5K8rJIx5K4PRg=;
        b=UJHl60Hr4cy9z+OsZ7leqX2OTYg9pJnH2rzXL/bpVU2a/moj2y5sO8gs/sm4Icvzun
         MoxM0WOFLr2RDwDOeuoAg/992/UP3WAstDdF+DY/e1If2SZ5SPrUdF6DVUgM5jnxipmv
         7GePyAeUO/+l2bl04LTlDzc4MO+t++z2sXCcmCwMHVg6Bx8gHJ8tVb9sEhDhliIpUUMQ
         SK0iOxiRDZU2fPbAUmRrrWMa6EzBSQ7RPATjc9sxSigxpwWAlshLP3ylCIdgzCnCcSQF
         PPpcul+1/YFgrhUJOgWM5gI+Dkh4lEYfpQrjl6riVtlt8WegfDsYi6mRnpa0w84oWHbJ
         5Ehw==
X-Forwarded-Encrypted: i=1; AJvYcCUOBMu9QIdyZrFajoj7hdBuvOX3DNkxTNQ/elKBPa948LOQmMESwj61HqLJSaFKyd58dRYaBkzP0JwzI5t/@vger.kernel.org
X-Gm-Message-State: AOJu0YyvZunmCpnjRmkBQSRPby/O0c27wOKsc28Blwe67QfuwQDeQFA7
	GINZxEhmnsbU2zZAYU4h6/6B55Ry0WCrnmce/9JLAnphlh4lGb749JrNGljyfdmR26+ZzMR/mRb
	HHPpyJ1Sp7M60fyzcQ0kGKrn6hvZWQM9+xvnvihVZ
X-Gm-Gg: ASbGncuLmyqwynPueHoU3o7iKDmvxCnPkNryNr+WVWb0pSOOYEBJPy2FlOfnL7gDTZI
	jixOwUdWzweXbGoLeVlN3n4FaDypSNx1v/B+7LOamHDrHbK/n20gqBnfh7FR6D9JVwMMT3stuqK
	BqYdU+wPx+XYb/rBC3DoScgDPxgzo/0eWisx6rgxiaxpaWROABHsm/tpi+JORxuYBb3mm426xY/
	Vus2pdXMZxY02qhj/2H8vozFKYupzE5+NyQtBvpZOAPDy4W4eX6IAdnRCSOsB7bf1OoT0U=
X-Google-Smtp-Source: AGHT+IFlgcm08Zi3P6+2oJVUXwfdUw7sv3b82zhNSHjaEBOQwXrzMMtqEuxbJwYy1uEuAcGXQwXxrAFNrkMjorAMSZ4=
X-Received: by 2002:a17:90b:6c5:b0:349:1597:5938 with SMTP id
 98e67ed59e1d1-349159759cbmr9821798a91.23.1764953389394; Fri, 05 Dec 2025
 08:49:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205-tortur-amtieren-1273b2eef469@brauner> <CAFqZXNvMxoTk1MQq96r=QQGjLqWwLrbdUVJ+nkSD3dzB2yTEYA@mail.gmail.com>
In-Reply-To: <CAFqZXNvMxoTk1MQq96r=QQGjLqWwLrbdUVJ+nkSD3dzB2yTEYA@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 5 Dec 2025 11:49:37 -0500
X-Gm-Features: AWmQ_bnDRXn8-Q-vXQyXQXeKQ75yPkmrhCwaLV1ifzTgMIqsDQEG5-wcwGbDB3s
Message-ID: <CAHC9VhTh9mmSFf0m7Hd7A59Q8cXN5j_rfTGP7_A_ic=1M283Dw@mail.gmail.com>
Subject: Re: [PATCH] ovl: pass original credentials, not mounter credentials
 during create
To: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 8:57=E2=80=AFAM Ondrej Mosnacek <omosnace@redhat.com=
> wrote:
> On Fri, Dec 5, 2025 at 1:11=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
> >
> > When creating new files the security layer expects the original
> > credentials to be passed. When cleaning up the code this was accidently
> > changed to pass the mounter's credentials by relying on current->cred
> > which is already overriden at this point. Pass the original credentials
> > directly.
> >
> > Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
> > Reported-by: Paul Moore <paul@paul-moore.com>
> > Fixes: e566bff96322 ("ovl: port ovl_create_or_link() to new ovl_overrid=
e_creator_creds")
> > Link: https://lore.kernel.org/CAFqZXNvL1ciLXMhHrnoyBmQu1PAApH41LkSWEhrc=
vzAAbFij8Q@mail.gmail.com
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
>
> Fixes the issue according to my testing.
>
> Tested-by: Ondrej Mosnacek <omosnace@redhat.com>

Thanks everyone.  For the SELinux crowd, I've added this patch to the
kernel-secnext builds/packages, but as the Rawhide kernel broke
yesterday (unpackaged files) it may be a day or so before you see a
new kernel package.

--=20
paul-moore.com
