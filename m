Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B4C257AFD
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742912219; cv=none; b=ubGCy2xVxXTFl6EU5+e+YnNceLXX9YF5FstdquNWNX0JlmhecnjtPFuDdWeYp6aNI9PVfJRWLFX3L/cfbc/Wtyjfyw214kRTb3iGINaqDA/kPb1mdTxMnm/Lo3zvYmQdcI0ict0jy3AuywV4CODir19+N1o0slJhLWd/FoyOmjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742912219; c=relaxed/simple;
	bh=Y5eE1rIMEADnDQWK0y2r97UiN/bXBQSPKYsKFOz3XfA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ANWff2WBsYlmOVYEYs01QOCUEdPuwgXUOURLuasfVLPsXWFcWV5ZRQmstfHx6MV0GjJcU7k00vzAtAwzrr79wnqxkyZkU2EKjlU/KiO3iKvm2CLY6CrH4kcl5B/msK3AkR4yX7Zj2k8cVSTCutmAt+mRjAUM1dCxpMrnZr7/OII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WR+5bgVO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WR+5bgVO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742912217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=45/I6IxC6x0pnYJDPbVx9XCfEi+sVbejqMmT9HH/Vi0=;
	b=WR+5bgVOHyVbPZOEDd4ix4SWO9UMH0StTepLqxRqycVaYeWLJgLzdojERRLIu1UxF2Qud8
	d8qIASVkYie+d8+77EeB8OAKiFbT7RAD9wphSDVQuPasSF38eBJaBrDJ8ORTpK625pucQd
	OC+hQuaeJi8euydksyXFEqqHEgREc1k=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-Kkm8LUGYMI6iSVBa0Laozw-1; Tue, 25 Mar 2025 10:16:54 -0400
X-MC-Unique: Kkm8LUGYMI6iSVBa0Laozw-1
X-Mimecast-MFC-AGG-ID: Kkm8LUGYMI6iSVBa0Laozw_1742912213
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-54996475915so2450903e87.0
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 07:16:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742912213; x=1743517013;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=45/I6IxC6x0pnYJDPbVx9XCfEi+sVbejqMmT9HH/Vi0=;
        b=baT9Y7NmYVeL7BDash3g1QqV23/TZyp+hyf/2VhiL6xGsm7hn3FYEa0Q8DczdDzTfH
         rlupYE87cm6k+ma3zp/W3bbsQ0Zcwd9PIgvwF880tnwJz/vA8QGLh8LuFGc7zdzzv3l5
         2lTrHq+Mq53gQ8h5TIIFCx+72+UoDUb/K9CHEZ10o2rI8R5wrI+QbhpO6Km8/wQ0FhQs
         W2Tw8XA9tHnVXSRoLy8bddASExh9mqaeK0o+5r0nnVqc+UTPf4+hiVs6TUELnNRLSolM
         upP7IAOKA2smyIw63Hj6y51VeZM1oyDqA0zilrJQ1d62EaIU/Q95eorDZSlxNFoJzIeu
         z48Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzY3FV02qHdMDaQo/ZfRRjhh0bLRVOKUsw907JzNk/lrrdqJ0Qh1sx5du6CFbRO/N2cxAJDQFY5Grv1UE3@vger.kernel.org
X-Gm-Message-State: AOJu0YzXDQ05HG9PyFkDEB89u122xD4nCefCTSnhe0svIAq4ZCerO/KU
	mpOhNOI9qi/4lpGSU3qXyoqM2wB6mPHvGz3BYinlU1DKlZPWAzIEweaK52AzeI/4LMrRIQlIa6/
	rGiLoOjWlYB0BtqTXBxcCmSAGFykEULiSHINomqqh7Y5TJBcVHx5STEx/bkJlFt4=
X-Gm-Gg: ASbGncsDhkuym6AWoTgxN7Wc7zaCfiozUOeX89qnNXrqhQCb1sOcfVwUyOYRKhGUe/w
	f6UZzv7Oj5KY/LbJCXH5kdizP7iq7wdpfOY6C25jczDQPsyGFTLLbsszOvMbw9iyDJdeghElXP0
	JvLJGthoYg7yN8Le7S8y5VslQwoFmrApk8Ng9qw+xCa56MfTU8pzWG2RjacAnRenXrz+J5/dhP/
	DJjegcbambmOwKI5ZcfGsRCXBPUauGS4yPVjr3ePuQjK/ltFY1CzI5RIVXPLAGPAvzwBIODOOBt
	REuNKLtbH9rO89qrIsYcYzT3dMUc/vnca7Vxu0cCou+qR8INP6L9XlE=
X-Received: by 2002:a05:6512:1255:b0:549:4ab7:7221 with SMTP id 2adb3069b0e04-54ad650bab5mr6157725e87.50.1742912212876;
        Tue, 25 Mar 2025 07:16:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbd1oJg5Hf2XSgCFH72HX2QAdZGMVBPBMNE5aNqWKSeQBEeP18y+tSN1jDYNb2/KVvmKgi4g==
X-Received: by 2002:a05:6512:1255:b0:549:4ab7:7221 with SMTP id 2adb3069b0e04-54ad650bab5mr6157699e87.50.1742912212309;
        Tue, 25 Mar 2025 07:16:52 -0700 (PDT)
Received: from [192.168.68.107] (c-85-226-167-233.bbcust.telenor.se. [85.226.167.233])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30d7d7e062dsm18980611fa.30.2025.03.25.07.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 07:16:51 -0700 (PDT)
Message-ID: <74c0a4e4c19b4d86f6533a9f5e2ad3992254a0c3.camel@redhat.com>
Subject: Re: [PATCH 3/5] ovl: make redirect/metacopy rejection consistent
From: Alexander Larsson <alexl@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Giuseppe Scrivano
 <gscrivan@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi
 <mszeredi@redhat.com>, 	linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Colin Walters	 <walters@redhat.com>
Date: Tue, 25 Mar 2025 15:16:51 +0100
In-Reply-To: <CAJfpegtvPW6tTfGbOUtW3GMe8UxX2Laqjopb1oSoUNgBWNUe9g@mail.gmail.com>
References: <20250210194512.417339-1-mszeredi@redhat.com>
	 <20250210194512.417339-3-mszeredi@redhat.com>
	 <CAOQ4uxiqis6kawuv4pa6jxHYgpQPc18izFP8e0TORfA_mVu_-w@mail.gmail.com>
	 <CAJfpegt=PWs8ZDF11p3nOCWHbWescE5nwVtUt82f=B6B+S0Miw@mail.gmail.com>
	 <CAOQ4uxiQQV_O1MJgTksKycBjJ6Bneqc=CQbUoghvXc=8KEEsMg@mail.gmail.com>
	 <CAJfpegs1hKDGne7c3q4zs+O5Z4p=X3PK8yFXhyCY2iAjs4orig@mail.gmail.com>
	 <1b196080679851d7731c0f4662d07640d483be4e.camel@redhat.com>
	 <87frj1fd3b.fsf@redhat.com>
	 <CAJfpegtvPW6tTfGbOUtW3GMe8UxX2Laqjopb1oSoUNgBWNUe9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-03-25 at 14:42 +0100, Miklos Szeredi wrote:
> On Tue, 25 Mar 2025 at 14:34, Giuseppe Scrivano <gscrivan@redhat.com>
> wrote:
> >=20
> > Alexander Larsson <alexl@redhat.com> writes:
> >=20
> > > On Tue, 2025-03-25 at 11:57 +0100, Miklos Szeredi wrote:
> > > > On Tue, 11 Feb 2025 at 13:01, Amir Goldstein
> > > > <amir73il@gmail.com>
> > > > wrote:
> > > > > Looking closer at ovl_maybe_validate_verity(), it's actually
> > > > > worse - if you create an upper without metacopy above
> > > > > a lower with metacopy, ovl_validate_verity() will only check
> > > > > the metacopy xattr on metapath, which is the uppermost
> > > > > and find no md5digest, so create an upper above a metacopy
> > > > > lower is a way to avert verity check.
> > > > >=20
> > > > > So I think lookup code needs to disallow finding metacopy
> > > > > in middle layer and need to enforce that also when upper is
> > > > > found
> > > > > via index.
> > > >=20
> > > > So I think the next patch does this: only allow following a
> > > > metacopy
> > > > redirect from lower to data.
> > > >=20
> > > > It's confusing to call this metacopy, as no copy is performed.=C2=
=A0
> > > > We
> > > > could call it data-redirect.=C2=A0 Mixing data-redirect with real
> > > > meta-
> > > > copy
> > > > is of dubious value, and we might be better to disable it even
> > > > in the
> > > > privileged scenario.
> > > >=20
> > > > Giuseppe, Alexander, AFAICS the composefs use case employs
> > > > data-redirect only and not metacopy, right?
> > >=20
> > > The most common usecase is to get a read-only image, say for
> > > /usr. However, sometimes (for example with containers) we have a
> > > writable upper layer too. I'm not sure how important metacopy is
> > > for
> > > that though, it is more commonly used to avoid duplicating things
> > > between e.g. the container image layers. Giuseppe?
> >=20
> > for the composefs use case we don't need metacopy, but if it is
> > possible
> > it would be nice to have metacopy since idmapped mounts do not work
> > yet
> > in a user namespace.=C2=A0 So each time we run a container in a
> > different
> > mapping we need a fully copy of the image which would be faster
> > with
> > metacopy.
>=20
> Okay, so there is a usecase for compose + metacopy.
>=20
> Problem seems to be that this negatively affects the security of the
> setup, because the digest is now stored on the unverified upper
> layer.
> Am I misunderstanding this?

Can you explain the exact security model here. The end user should not
be able to arbitrary change the redirect xattr to bypass permission
checks in the lower via the overlayfs mount directly. So, is the worry
that the upper dir is stored somewhere accessible to the end-user for
direct modification? Is there also a worry that you can write directly
to the lower layers?

Anyway, In the example above couldn't podman just create the metacopyup
layer manually and then pass it as a regular lower dir, then we don't
need metacopy in the upper?

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's a shy ninja sorceror on the hunt for the last specimen of a great=20
and near-mythical creature. She's a plucky cat-loving magician's=20
assistant operating on the wrong side of the law. They fight crime!=20

