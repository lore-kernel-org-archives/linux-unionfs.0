Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F54818E372;
	Thu, 29 Aug 2024 10:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724927397; cv=none; b=bUp/lfYUPBrarid0AOKgTxyRzmsBnzwG99H0VlRAms8+BGmLGBKcDDeAVZCsSgR9iE3fcRMpSL+52borLxdkXTt3x7P7pk/j8UzCB+mYkDrcqwEe4PhSpqwnCsKCI/OPwjV7+WSHJzr54y5WXyc0z6oEoTwGd9lwNidWGvfIDFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724927397; c=relaxed/simple;
	bh=kR8Ap2dEgc9SIGX+U5MHWd8dlkRGCIwiPqnUCBBpPss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c9q3QtthprXueogp7HUAA1ZgrVRCDdc1nJKrtna2Q06JAoJsjD0pvGEyVfogoZ96h5oDfu1VgfU2U2XsF0BTSKGLjynr7UgQkGZGOQuU96o90usXZk4Q1h4gNSQnUDb0qk2btjjrV/bKs/HI8nBoZYLZGpxzdqcVk0pWAwUWAfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WxHgP9JK; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WxHgP9JK"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7a7f8b0b7d0so16690085a.2;
        Thu, 29 Aug 2024 03:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724927395; x=1725532195; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+Q7s5PxV3KAi3K3eVR19t9nHuuGAXw/J+XPGFRVh5U=;
        b=WxHgP9JKlOCnDRM/2C/QLNFtdJWDSp/azBsjls5QXLc6mSau00mIqoXSarel3dZS5G
         /Brx06Pq2WhgE6QuXm7u3yhTzpDj9wEOt70ZposlCZ1ptlzWFKRxqhCvysZLUEjYJK8p
         W08uxkdGc3n1Gmbsh6a2sG1Tq4FOuNBu+Tq6NccuVAe+TuKLR7ZfT7AQpD57sbOFTIQ7
         G7nzaUFS0Ygi3/J5M0vmDx2CImWzGTZnV7eaUFe0y3LQATyLC3Sz9HbvsyjWoDnlxWm6
         UGYYcmRH9WACfxMg34G1QGdApJ3IBFTfR05NR175RkCQ/1hcuBxth166XrFherp/u26D
         OgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724927395; x=1725532195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+Q7s5PxV3KAi3K3eVR19t9nHuuGAXw/J+XPGFRVh5U=;
        b=gRcQ4dKrNQF5dXX99qtX9LB8hFdiN6q2NjyZa8ROQadLyAmYWIbw7j6Yk7KzE9F0M5
         VUoUf5sPIhBLKV/KhG5bzal+99mhC0F+6yU9VIUFI4EYXm/Ob3AhYAM/wlXhivpN2n3C
         RSLwzqBCNBHPXLbD8cYfgGnewJ4bkxerDl6582U1cBncb6cZ9jQA4/YHW7Anw3zmRx1n
         NcaUsVEuBGrWsfB2Lr466iJDeNY/Dyl30yNiAptfkbqFhnigaUA+PCTsxc5eiVWMFD8l
         bik/joNOlljRhsB9/d5QNxFbfr/ZVfIeWoEsRi/PvE1rlyZVhbvAjewPgHGaec63RGy1
         36Kw==
X-Forwarded-Encrypted: i=1; AJvYcCUj9YhGK64U64jpthXz/vw7U/QzLkBjVOed69SgxwGon0QNs8vQqOjMlurzfPBXYS1Tb1+KAcHSWtStltk=@vger.kernel.org, AJvYcCVSbFMuhDS6UQL9Yzv5IQVGKmIMIVhtwkByVfdbVOGTKMLIMyQwiRoRqrb4ZBTrH35xAwir0FRj+/n2aKyIbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/HNh2ecokLwDamz8o8AoYGZTbmdLY/Mo5KodONZIssGIq/Mn0
	e7NWLsTzNvi+deB31kAK6A8UCOfm6Qy/xIigvHDQPSuS5HaQfoBsrxJjV/7615oJhagn7CL9RE+
	fa7yJX2xJl2cSG9K7ODDmFu8rVafwhmOMwWM=
X-Google-Smtp-Source: AGHT+IE0zNGEhEcBv6/yDczCimzxHfhiG5M7fVHKl6jTxOWLwlYzwOP8zmxfXyO+tfvkGjuzRldRfZlOqHLYscGp9cc=
X-Received: by 2002:a05:620a:280c:b0:79f:a6c:f422 with SMTP id
 af79cd13be357-7a8041af2d9mr188453185a.24.1724927394860; Thu, 29 Aug 2024
 03:29:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240722101443.10768-1-feilv@asrmicro.com> <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
 <CAJfpegtPOgowkK5EHxNZnuHDo9AZTbF2-zxMc99rvWL44rdMXQ@mail.gmail.com> <CAOQ4uxiYGsKzMZ73=WLZqseU=ibboFtPfqpeGtmFWYY3uxjMvw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiYGsKzMZ73=WLZqseU=ibboFtPfqpeGtmFWYY3uxjMvw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Aug 2024 12:29:43 +0200
Message-ID: <CAOQ4uxi-BuKU-AbyydVB2c8z0DiPP-Ednu+bN3JB2Cqf7rZamA@mail.gmail.com>
Subject: Re: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Fei Lv <feilv@asrmicro.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lianghuxu@asrmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 10:46=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Mon, Aug 26, 2024 at 5:59=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Mon, 22 Jul 2024 at 15:56, Amir Goldstein <amir73il@gmail.com> wrote=
:
> > >
> > > On Mon, Jul 22, 2024 at 1:14=E2=80=AFPM Fei Lv <feilv@asrmicro.com> w=
rote:
> > > >
> > > > For upper filesystem which does not enforce ordering on storing of
> > > > metadata changes(e.g. ubifs), when overlayfs file is modified for
> > > > the first time, copy up will create a copy of the lower file and
> > > > its parent directories in the upper layer. Permission lost of the
> > > > new upper parent directory was observed during power-cut stress tes=
t.
> > > >
> > > > Fix by adding new mount opion "fsync=3Dstrict", make sure data/meta=
data of
> > > > copied up directory written to disk before renaming from tmp to fin=
al
> > > > destination.
> > > >
> > > > Signed-off-by: Fei Lv <feilv@asrmicro.com>
> > >
> > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > >
> > > but I'd also like to wait for an ACK from Miklos on this feature.
> >
> > I'm okay with this.  I'm a little confused about sync=3Dstrict mode,
> > since most copy ups will have vfs_fsync() called twice.  Is this what
> > we want, or could this be consolidated into a single fsync?
> >
>
> Maybe it could, but remember that ubifs strict mode is the odd case
> if we have an extra fsync for the odd case, I think code simplicity is
> a more important factor.
>
> > Also is it worth optimizing away the fsync on the directory in cases
> > the filesystem is well behaved?  Maybe we should just move the
> > vfs_fsync() call into ovl_copy_up_metadata() and omit the complexity
> > related to the additional mount option?
> >

Maybe, but note that in ovl_copy_up_meta_inode_data(),
copy up of data still requires fsync and there is no call to
ovl_copy_up_metadata() in that code path, so trying to optimize
double fsync in all the code paths in going to be a PITA IMA
and not worth the trouble.

>
> Hmm. Maybe you are confused by the commit message that only mentions
> fsync of the parent directory (same as the reported reproducer), but
> the strict mode fsync also affects metacopy, not only parent dir copy up.
>
> > To me it feels that it shouldn't matter in terms of performance, but
> > if reports of performance regressions come in, we can still make this
> > optional.
> >
>
> I think that the case of chown -R with metacopy is going to be terribly c=
rippled
> if every metacopy gets and fsync.
>

But maybe we can ignore crash safety of metacopy on ubifs, because
1. the ubifs users may not be using this feature
2. ubifs may be nice and takes care of ordering O_TMPFILE
    metadata updates before exposing the link

Then we can do the following:
IF (metacopy_enabled)
    fsync only in ovl_copy_up_file()
ELSE
    fsync only in ovl_copy_up_metadata()

Let me know what you think.

Thanks,
Amir.
