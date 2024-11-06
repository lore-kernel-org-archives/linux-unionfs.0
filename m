Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D1B2022F5
	for <linux-unionfs@vger.kernel.org>; Wed,  6 Nov 2024 14:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730904831; cv=none; b=FqKFh6dZkEGXPxxGw/CuXs9CNizY6ZxrHroq5Q7lbk6treqiMozq1GIYYEAnieIhrWmAEU3RkAl7b8mIlY7/Tb3yTesn6485t4b0CJRz5FAgi71i+ofVs+A0z38RyUuepXOQRk4X1dCHgJQ5eCj1Jc8YCY49CdbYfg2kVInbv7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730904831; c=relaxed/simple;
	bh=qd2oxWfj8ZkVoRk1/1WgltaqLpvNVj+hI5ourNOsBOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BsN3zMc/iHiTWSqtmixFSNe1KIenAwzdGE7/AwYSg2ZK/xmU7Cy8fdZjinudd5YQhvLjfMGO69h2B027a4KbGlxdWduLZUkEdkGl+gW7cOR9HqzROZhLclDbV/2RuwdfidAjqrqWWZR6bn6bvHRshlPuLAii/AmNromgcXoBXT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=iNc6fAvY; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="iNc6fAvY"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5ee3e12b191so255355eaf.0
        for <linux-unionfs@vger.kernel.org>; Wed, 06 Nov 2024 06:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1730904829; x=1731509629; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qd2oxWfj8ZkVoRk1/1WgltaqLpvNVj+hI5ourNOsBOA=;
        b=iNc6fAvYDeRtPQr95FUNmrazZefk5IUyWYVku8Nvjklvc0w/YVHDAK9739iYEshGF5
         DbtFXsGTDrxtltYCKGm4hQiTJKJh/+49XnAA+gp3Goa10UD6FziCyKvChmqcXhuY0f30
         opVdF3FZbrUa+ZDGmClDzO9LwDDvRx8eMyNrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730904829; x=1731509629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qd2oxWfj8ZkVoRk1/1WgltaqLpvNVj+hI5ourNOsBOA=;
        b=wDo3EW0oEOi/O9EvtdAG1Sao6SNC4VS1dZz9FlW98X8cEHA0FZL3TlvNV+7QKMyq+G
         PfxsScP341CX2XbEJQdnSMz7h6D7yCK3V3QF/HLfDREtCMULEKafEVfD3hDv1TbC2zj3
         0mZX/INO1rc82gnC8SgTn0SquYPv7ItoibI6vBH3eKzfiiODIllW6b0ik0qSJNfUxpzH
         NQzeFczjssx2z0qUzRMWCqRMgxrB4NJdUqKoG/l8NlqHErDma608oAWg09mr3s1pMBDt
         FT36rJgoXj1+izVlT0Cn8bNutVd7sNqTHGD8IoilLgNZ3s8YDCACuIPCJgtDuUGLm4ih
         GlJA==
X-Forwarded-Encrypted: i=1; AJvYcCU6dcKJ1bamrnZKFINgtltvb/06gmKvrAjHy2Cw1Alc2usOmWZxihSoiOTd3fs1mvutYbA5KgwTHArk0DbS@vger.kernel.org
X-Gm-Message-State: AOJu0YwPx6uXQjZJaYp1ZYiZB06WV0M9QhYOlM/KkAtsSEPkUlDBmXhq
	AG5LJttCxFrfLcmVQyVHTlXx80wyxnaOfNgqsNss95nQpfg1Sfoxnv1CZnV9Px2tuhYPzXxxshY
	nzW+ViHZ2IgswyKrs1pHI2cWi3IhVVpLmA1BBEg==
X-Google-Smtp-Source: AGHT+IFa9JnN+t6Lfxkdc0ulgnBmj1ApwylswzSBXd0agEog+CiLEpOj+2CvAIt5HGuebycCh4ZaLZNNY+Op5Y+TgtI=
X-Received: by 2002:a05:6358:729c:b0:1bc:2d00:84ad with SMTP id
 e5c5f4694b2df-1c5f98c78acmr1025710455d.3.1730904828818; Wed, 06 Nov 2024
 06:53:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106-overlayfs-fsopen-log-v1-1-9d883be7e56e@cyphar.com>
 <20241106-mehrzahl-bezaubern-109237c971e3@brauner> <CAOQ4uxirsNEK24=u3K-X5A-EX80ofEx5ycjoqU4gocBoPVxbYw@mail.gmail.com>
 <CAOQ4uxj+gAtM6cY_aEmM7TAqLor7498f0FO3eTek_NpUXUKNaw@mail.gmail.com>
In-Reply-To: <CAOQ4uxj+gAtM6cY_aEmM7TAqLor7498f0FO3eTek_NpUXUKNaw@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 6 Nov 2024 15:53:38 +0100
Message-ID: <CAJfpeguvAB-VMyV1Tin=ZDzPHE=P+ac4REQrsn4C5u8uh3+TmA@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: port all superblock creation logging to fsopen logs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, Jan Kara <jack@suse.cz>, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Karel Zak <kzak@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Wed, Nov 6, 2024 at 12:00=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:

> > I am not sure about the level of risk in this format change.
> > Miklos, WDYT?

I don't think the format change will cause problems, but it does fall
under the "no regressions" rule, so if something breaks then it needs
to be reverted.

> > I am not really sure if the discussion about suppressing the kmsg error=
s was
> > resolved or dismissed or maybe it only happened in my head??

All I found is this:

https://lore.kernel.org/all/CAOQ4uxhgWhe0NTS9p0=3DB+tqEjOgYKsxCFJd=3DiJb46M=
0MF04Gvw@mail.gmail.com/

I agree that this needs more thought.

Thanks,
Miklos
