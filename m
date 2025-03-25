Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23882E337C
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 11:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742901523; cv=none; b=ppvYuKdxxddt2d6nmtFHYbfV0E5tWIeIJZJHLnaCvQ4VpD7+ggvCZMeiuym+WKuU6VJ0lN6wJy8kqE2KYfQrM3XkJYxyqFMbndpjEarrZjq2Zs/ilZO8VnrCp24rAtz7MLXvqQ39Z+jP9bxBCCxql0ckTsQQeD14pF+SZcyhYBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742901523; c=relaxed/simple;
	bh=4jpQ9O+Mm2ay45C7PHlPJfLQut0Dpac7zKp+/HTmrqI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MrmKYHpfwHn1jIXp07G0PYHiFDfY5RpOcKPzp7TgowBiA4tEC8F2QafR2r4WRD+TKixXuNfJohMfwBf/4GRm0ZywP0qZZZLY8K/TgMrwe6ngze2JUd2XmfHhWuk8no0LKaA1v/zMHsmdVYqLCk0A8sa8MoFy6ebrW2/yLfAamKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MAwT5IJ+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MAwT5IJ+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742901520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=azyksyM59CObgIbjB5KdlQwEi6gUMHF1D6Q1zjjdoDI=;
	b=MAwT5IJ+V8QTIpAcRauHkVq9Ev8K3L6d2QM1nwc8HQnpt3HT/QZuERp3WjklJN9v6cDMQG
	/wtTaZ09QalHeh1pwadP0Atu5XxmPyK/FnvJLoGprRQJ04WIjGPRpRYhZ8mf7/ZebpXO6L
	TvNvOKLZMk2jZiitaZfDEJEBc4OElXg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-eEKp0QT7MGuZRTA4kljslw-1; Tue, 25 Mar 2025 07:18:37 -0400
X-MC-Unique: eEKp0QT7MGuZRTA4kljslw-1
X-Mimecast-MFC-AGG-ID: eEKp0QT7MGuZRTA4kljslw_1742901516
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-30db3c4140fso2343671fa.2
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 04:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742901515; x=1743506315;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=azyksyM59CObgIbjB5KdlQwEi6gUMHF1D6Q1zjjdoDI=;
        b=rRb/tL6uHngnWkboBcdrxYkT6dAzAwciJTSvfEbnd8vo7vIDLDnPxXKQRNNky+qmxD
         iOb9FO62I7LfNcvd5OvauLpvstvfxR87PJUSUrErnyPf7i9CRCzgJb+dMp5xpr/sxE9s
         IAuqBsAi88d+SOAA7F4vMZjaI10ktfowFKdxa9CDgEM/b2vsnAFDCeLT1qYzrmOFqCo0
         Qn9xyxGUTn3T+GbR/w2a3ak09ZkW0e9bOmbpOb2uT9WBSYpIlE16s/UvLd4Ho684V9SB
         ZNpFn+hBZFd3EECw+ZIUbOFhLxfWtIZe9PrVSPEpBe8ggXgFKJ3BbwQh34WuBoeVykS5
         USQw==
X-Forwarded-Encrypted: i=1; AJvYcCW83MYd+d4XA6/r1zZW0lxtX1bvpS/gJYmF4FrO4cRHnLPjGfrme8xY9jULgW0AZP6pRfuCQCfmq/PcPw5l@vger.kernel.org
X-Gm-Message-State: AOJu0YyPlcRVKCnwyQuCZ+3VqJBvOOOCYio33Vsx15epVCO9JGiYwd7Q
	YDsDOc/K8p92J6cfE2MGyUri407xRfWsptdpD0vGVBH0nIqk0i2pDpXPNBBlpyGRWLMt2I7BoQx
	qqmgIesCAc/MYW/+zB07c+wQSHMBC1z5oBuGrPiZddWZKQmCKCKfN7m8ppmPu5vQ=
X-Gm-Gg: ASbGncu1Ef+1pUoJoQz7wzgurTI2cd/tN/Ud+uoecOnRBvVMpy9tMqYVKM0cOSbTVHA
	wZ/CEVZ/eumexiihMGrwmakiiLtVDV7Aoqm15W0lqIgJq87yPpn7L/5CCbCootGK54UL+EgpgDi
	jzbPxtJqmGEa7YhEXb17YPseaAhhY3jya5yey9EtXw5qX2Y8yxwSeL5DFqDggo5bIO+nsTMDox5
	UuMOYB35+9bZ+y7PXMtfua46Wa7yKde2mmvQsWlUdwshaedPg0Xd5+nVmjuu3uXnyoZKsuMSyZ0
	z68NGuP0eiJzhTnnRIpDbwKNocwhienKs+F+kXfQ71QusXt/KkrwFZg=
X-Received: by 2002:a05:6512:b94:b0:549:38d5:8853 with SMTP id 2adb3069b0e04-54ad64806c4mr6070397e87.17.1742901515458;
        Tue, 25 Mar 2025 04:18:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjtqbIwHYGNHuo5x5tBm7yBI388Ux/gW6yDNSQ2502EOTzLexuBiPH1BhQoZiGL60kI8j0fw==
X-Received: by 2002:a05:6512:b94:b0:549:38d5:8853 with SMTP id 2adb3069b0e04-54ad64806c4mr6070378e87.17.1742901514964;
        Tue, 25 Mar 2025 04:18:34 -0700 (PDT)
Received: from [192.168.68.107] (c-85-226-167-233.bbcust.telenor.se. [85.226.167.233])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54af7116e55sm144919e87.159.2025.03.25.04.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 04:18:33 -0700 (PDT)
Message-ID: <1b196080679851d7731c0f4662d07640d483be4e.camel@redhat.com>
Subject: Re: [PATCH 3/5] ovl: make redirect/metacopy rejection consistent
From: Alexander Larsson <alexl@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Giuseppe Scrivano <gscrivan@redhat.com>,
 Colin Walters <walters@redhat.com>
Date: Tue, 25 Mar 2025 12:18:32 +0100
In-Reply-To: <CAJfpegs1hKDGne7c3q4zs+O5Z4p=X3PK8yFXhyCY2iAjs4orig@mail.gmail.com>
References: <20250210194512.417339-1-mszeredi@redhat.com>
	 <20250210194512.417339-3-mszeredi@redhat.com>
	 <CAOQ4uxiqis6kawuv4pa6jxHYgpQPc18izFP8e0TORfA_mVu_-w@mail.gmail.com>
	 <CAJfpegt=PWs8ZDF11p3nOCWHbWescE5nwVtUt82f=B6B+S0Miw@mail.gmail.com>
	 <CAOQ4uxiQQV_O1MJgTksKycBjJ6Bneqc=CQbUoghvXc=8KEEsMg@mail.gmail.com>
	 <CAJfpegs1hKDGne7c3q4zs+O5Z4p=X3PK8yFXhyCY2iAjs4orig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-03-25 at 11:57 +0100, Miklos Szeredi wrote:
> On Tue, 11 Feb 2025 at 13:01, Amir Goldstein <amir73il@gmail.com>
> wrote:
> > Looking closer at ovl_maybe_validate_verity(), it's actually
> > worse - if you create an upper without metacopy above
> > a lower with metacopy, ovl_validate_verity() will only check
> > the metacopy xattr on metapath, which is the uppermost
> > and find no md5digest, so create an upper above a metacopy
> > lower is a way to avert verity check.
> >=20
> > So I think lookup code needs to disallow finding metacopy
> > in middle layer and need to enforce that also when upper is found
> > via index.
>=20
> So I think the next patch does this: only allow following a metacopy
> redirect from lower to data.
>=20
> It's confusing to call this metacopy, as no copy is performed.=C2=A0 We
> could call it data-redirect.=C2=A0 Mixing data-redirect with real meta-
> copy
> is of dubious value, and we might be better to disable it even in the
> privileged scenario.
>=20
> Giuseppe, Alexander, AFAICS the composefs use case employs
> data-redirect only and not metacopy, right?

The most common usecase is to get a read-only image, say for
/usr.=C2=A0However, sometimes (for example with containers) we have a
writable upper layer too. I'm not sure how important metacopy is for
that though, it is more commonly used to avoid duplicating things
between e.g. the container image layers. Giuseppe?

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's an impetuous guerilla werewolf fleeing from a secret government=20
programme. She's an elegant insomniac socialite with a flame-thrower.=20
They fight crime!=20

