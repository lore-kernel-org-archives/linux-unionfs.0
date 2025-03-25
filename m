Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4452E3364
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742911470; cv=none; b=axxj0cWSNIZBTIjkgTGKcXJAUk0qAIqvGjndhRoWZ4PkvRlztTR3nWkTadBm/J8zohPttlMp8gjIs/Zem8PF7u7X/ypTd5moomA8S7rAiKUVU30m5VBs2LmAkJR8kkf8b5ZaI1wJ29gfqd/OJTLS4kQ8mFTyflfjWhORqRHy3rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742911470; c=relaxed/simple;
	bh=R+r1CguaOOz35iJ/DY6/umHEvBsP/o8mOXzzoR+V+0s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=idaDMSJ12rD9e7ZhArGtSB97/fot1vkArqOsC0/iZTTKRBx7A7A/4imZzRxsXGqlv0g15Ky+2udzBVUaALt5dag0zC6EXD8iXDV81maWtyk0wUHc+9+sQnQlBAup4BGps/situRlSzwZVXru5rOmqgou7azEAlOsvBYnHvJDV/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fnioxMG2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fnioxMG2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742911465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ZgU7DrYK2qYRBNgm/CP2xQb06HcVoXyGjUHERMlZwk=;
	b=fnioxMG2jxeNI3Q4KrQmpofoGc5ZxQCkIbnIsfJM2nQP8Qa67ALPy3Ctqtzt6CZ00pqFhc
	IeFwdGTxPBAdrI56ikESD9QS8ImNLlvlEHEiMKcc25Vi8urJu0tcwWpc/7AEkYheloU1RJ
	ssvg4yltZeOLLPyfJ8RiYBgdt/M+Sq8=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-88dE1jnGOJym0YiMHy-odw-1; Tue, 25 Mar 2025 10:04:23 -0400
X-MC-Unique: 88dE1jnGOJym0YiMHy-odw-1
X-Mimecast-MFC-AGG-ID: 88dE1jnGOJym0YiMHy-odw_1742911462
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5499d32e5e2so2462870e87.1
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 07:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742911462; x=1743516262;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ZgU7DrYK2qYRBNgm/CP2xQb06HcVoXyGjUHERMlZwk=;
        b=URVoGpyuaNTAgdovlZvhtWEfpkt5xZYzCKXYPf2HHkQm1bIAlW/LS+iqZJsbOoXrci
         YYIBNG/SZxFkR0ZRDF4KgZsZmd6edyjUsZTK7idgEdXlqXUvl4uQTNMQGO8N1sL/oVi/
         uQO0bPT2mfBMSzb9knG/7b9ISCkwmGVSHjQS+2fWoCjJ4rhuCMcIz0vfXKOucpoXVK4Q
         YrvyWyZsGd39qDlNife0KEOO9u0wMgqfGjLwqPVWbjtshjd5nnj9f698JKLaQKVZkH8Z
         ZFYyx1iHLCi7m3VrHaWrygYkNM2Iu79+QNPVSvQiO7nbGlLpCqvekc+8IMJgI02tMtGy
         VwWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHFclrk/1bRGghjX6l4/2xwzJEm07ynx5IFX4J9h46EVB9AyZBV6WR+mujdGQILARLAYmPWHtdkz8p6pL6@vger.kernel.org
X-Gm-Message-State: AOJu0YyLDloAjbyo4tuk7BztJSTXbWi/0nhBcY/FJdtn9ywsCSL0zCu9
	fZN2xZxmkkjXh5KAxw13ZtaLdnYpjcbeXRBaArkq8U3o14lnxM8Ytb2FEZEpfg0cdvwxM7dDwhc
	uXAE1p+DcDDGRqNhEE/E/vmUSm+seNQtpWmORrAut3eOH+JygZPPHxExjG+DdUELdtfAWrI0=
X-Gm-Gg: ASbGncsiWRFPyIKDYQ6ElpyjhZXudwUtAN3sYIf+cGUHT97ThBV+gg/ALVxVLtT6R9G
	cl2zddt4V+Uh+6DGc6zxoX8xaG06ZKMMA+GZHnDRLqhl9DJesPeWZvvFuOEyDVq9uclhtFcpv1v
	MV26Umxt5j1Duj1DKf3QPcdRoGjEXwzabF5qoQVZkAkmnrbjvo7gTuesmhApgC4j7PMSEITDT3h
	TTATMtEDC5C4t3O8y4n5wphEQ87nnKBU65uRKhfJrPvUHfe2JXWRPm81kakZFrkE3enURciT3oV
	G3EcGFGldlXCSHmqm3WxWnlC+eO9q/XNNEAdyQHepkyqLk8aQeVz92c=
X-Received: by 2002:a05:6512:33d6:b0:54a:c835:cc58 with SMTP id 2adb3069b0e04-54ad650d593mr5612563e87.50.1742911461856;
        Tue, 25 Mar 2025 07:04:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHip8bhUQjYnv9bsqUqpdYcMzQDzIEXrVHTgN5VSGt0hGOS04oWCeFU0f4Ct8xM1JS4Aj/0nA==
X-Received: by 2002:a05:6512:33d6:b0:54a:c835:cc58 with SMTP id 2adb3069b0e04-54ad650d593mr5612491e87.50.1742911461047;
        Tue, 25 Mar 2025 07:04:21 -0700 (PDT)
Received: from [192.168.68.107] (c-85-226-167-233.bbcust.telenor.se. [85.226.167.233])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54ad647c69esm1554602e87.69.2025.03.25.07.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 07:04:19 -0700 (PDT)
Message-ID: <75253bff47313b895772b914e0a77bd4f19b546d.camel@redhat.com>
Subject: Re: [PATCH 3/5] ovl: make redirect/metacopy rejection consistent
From: Alexander Larsson <alexl@redhat.com>
To: Colin Walters <walters@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
  Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Giuseppe Scrivano <gscrivan@redhat.com>
Date: Tue, 25 Mar 2025 15:04:17 +0100
In-Reply-To: <CAGUVWovzT=7Gj2nj-RWC9g5_KWMzPPzAbFs9-xKWpFuh8iFTiw@mail.gmail.com>
References: <20250210194512.417339-1-mszeredi@redhat.com>
	 <20250210194512.417339-3-mszeredi@redhat.com>
	 <CAOQ4uxiqis6kawuv4pa6jxHYgpQPc18izFP8e0TORfA_mVu_-w@mail.gmail.com>
	 <CAJfpegt=PWs8ZDF11p3nOCWHbWescE5nwVtUt82f=B6B+S0Miw@mail.gmail.com>
	 <CAOQ4uxiQQV_O1MJgTksKycBjJ6Bneqc=CQbUoghvXc=8KEEsMg@mail.gmail.com>
	 <CAJfpegs1hKDGne7c3q4zs+O5Z4p=X3PK8yFXhyCY2iAjs4orig@mail.gmail.com>
	 <1b196080679851d7731c0f4662d07640d483be4e.camel@redhat.com>
	 <CAGUVWovzT=7Gj2nj-RWC9g5_KWMzPPzAbFs9-xKWpFuh8iFTiw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-03-25 at 08:51 -0400, Colin Walters wrote:
> On Tue, Mar 25, 2025 at 7:18=E2=80=AFAM Alexander Larsson <alexl@redhat.c=
om>
> wrote:
>=20
> > > So I think lookup code needs to disallow finding metacopy
> > > in middle layer and need to enforce that also when upper is found
> > > via index.
>=20
> That sounds right to me, yes. Especially when fsverity is required,
> hopefully we can keep the code paths involved as simple as possible.
>=20
> > The most common usecase is to get a read-only image
>=20
> Yes, especially for signed images that require fsverity - often the
> deployments of those will not want a writable upper because we want
> to be able to ultimately pair it with policies to enforce userspace
> execution from verity/composefs like IPE etc.
>=20
> > However, sometimes (for example with containers) we have a writable
> > upper
> > layer too. I'm not sure how important metacopy is for that though,
> > it is more commonly used to avoid duplicating things between
> > e.g. the container image layers. Giuseppe?
>=20
> Wait isn't that statement backwards? metacopy is just for optimizing
> the metadata-only copyup-from-lower case when having a writable upper
> (not technically part of the container image layers).
> I don't see what it has to do with the read-only stack for layers one
> might want to create especially for a composefs use case.
> Though on this topic personally I think it can often make sense to
> perform some "eager" flattening of images in userspace, but that's a
> metadata-only operation (in userspace) and has nothing to do with the
> in-kernel optimization of metacopy (which is about optimizing when
> userspace dynamically changes metadata on disk).

I think this misses the question. There are two things in play here
that are sort of handled by the same thing. The redirects from lower to
data-only, and the metadata-change-avoids-copy-up optimization.
However, they are currently enabled/disabled by the same option
(metacopy).=20

The problem here is that if metacopy is on in general, then a writable
upper can also use it for general rewrites, and this is considered
problematic:

* Following redirects can have security consequences: it's like
* a symlink into the lower layer without the permission checks.
* This is only a problem if the upper layer is untrusted (e.g
* comes from an USB drive).  This can allow a non-readable file
* or directory to become readable.
*
* Only following redirects when redirects are enabled disables
* this attack vector when not necessary.

So, I think the question is about whether to split these two options so
we can allow only the lower =3D> data-only redirect, without enabling all
the copy-up optimization, and whether there are cases even with
composefs where the copy-up optimization is useful. (And there are, but
they are not necessarily super important.)

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's an old-fashioned vegetarian master criminal moving from town to=20
town, helping folk in trouble. She's a bloodthirsty foul-mouthed snake=20
charmer with an incredible destiny. They fight crime!=20

