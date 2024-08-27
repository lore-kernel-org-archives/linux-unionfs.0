Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5FF176FD3;
	Tue, 27 Aug 2024 08:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724748422; cv=none; b=ik2hWi1LaVmESOLNdc27hr4fmqriBf8JqpkWqouFYg2MRaBnn0pOmEYjTzd7Wb6kBnCL6m1tV0x0k4cB1ko+HY7IJCfw9G7irR+dytvasCJPK0s2mf7MXtuBAVLUwhFGbdWXlsagszeCQJ0gC/hbS8q6LxoAHXQLhSs0HxrPiBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724748422; c=relaxed/simple;
	bh=NoaCQBu8nufCCZrkhu3Og44vYtGsHr8i9cHgC9V2Tmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TD9Se+KBUs2HhJcinS5WLDGY488AhBOXHka/5ZfdWmp+6bvqH4Xp7XjQzDpa8EKkQTk3nXPtC1EMzyyhxBZxeujvu6vY9aDXk9BTYLABWJqlC3A+1SLBGDagwZ+LkSmU3L5FjcJKf1i8b1bYbFZ8D1Sf6lAKdVatfWuWIqX/SOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dyYBthEd; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dyYBthEd"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7a1d6f4714bso523915785a.1;
        Tue, 27 Aug 2024 01:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724748419; x=1725353219; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFSIf+Z9JMualKg/KAoH5HvbY8LNu1GRislhgYXlBko=;
        b=dyYBthEdyoqGjpejfqd+OTrzA8YdbPi8FUYx126EJ3j80uEwvZqvsED8jDwjIB+udg
         RD1r9V0q2ZwddsqOM/SsGsCAos94EPdP/S8M0n5Pmc3E3iE1raYjf03E/zad9nn0J4v2
         /XEvP00TQOjl5lgaUHA/8GGAtgVviT3vbeDX9ojdD7TL/hl4gaCZRQPEarlFScRWhCpE
         U6bFQbmbhSBGRkpSoKRbVfj+KWwvTR0Qs6H8P8PtE5WaGvtUV8Co1WG6BLcRnYDRE/tW
         n12/Tf9kf2dizI5aB8hhd6JNcm7cceElIOT0SioJanbUwxEPBLU8EEXLcPX2cEJU5T43
         q4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724748419; x=1725353219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFSIf+Z9JMualKg/KAoH5HvbY8LNu1GRislhgYXlBko=;
        b=SR3rm5ueadbAv0UZkHoWGpFxNUIkYzPhdzwfRlEctSJsHa7CifEo9Yke8fIjlS/2uE
         12oTX1Gf4mW8+Oi4/IQed4K6DKuuw61A82HaROqhTBhswQoJETKF6drotZbbay8ZfpPm
         f7Bs4bM5eTqRp+LXAhJXbobce18K2H+rnyrC0dxqZDkNnSoH7A19rfHLhcENX/zazhT3
         /7geH8wDK+sMdWu2/vCHkt4lcaJiqN/TSc9oKmlGE2Xkw+s+gRNaKwMdNAwek4cltpcb
         MpJyrosSej6bxNzlOO0+0NLgWLvZPBsYZV+Du4AkJ1M1ZBwJBmH7ndV5xBX/g8qwvJjU
         EC+g==
X-Forwarded-Encrypted: i=1; AJvYcCV7tWEj88DITyLGGJIiDjzgXICOhFgx4JKySRSmSMG0ScasE/k7NVf5Zaqjr+FIZNpEtzdN2DwFCaLoskB4DQ==@vger.kernel.org, AJvYcCWT4zauyaLqXiq1/iwBzAtuzRlvOWPpN9p3xfNpIiz/e/BJ6pTmeWOB/JO55x1h5YJzx2t6m0kuIpZm1zk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLUwLDY12Be6LPG2HD+Wxv9Uld/jL5YCSSmy9ZBotA+F03ZMzf
	OzoGGAwLOrV+K6bBIIsfurDiTXZtbFrFHAtHWfwhC1z6X2IAUqG6cOK6PMGo6npSn99uGELcUG7
	zGg/GKQNzzFOUhOr+ES7+aV/xc4mDi0v8
X-Google-Smtp-Source: AGHT+IFqWBwmZFUFDSoIG52LlfPgR2Lpyh0XsgvG+p8GDoLM5hMqSk1vtAD6Vf5eaRSWj88KlgUrlyexWBoBKVg5XZo=
X-Received: by 2002:a05:620a:2982:b0:79f:4c8:d873 with SMTP id
 af79cd13be357-7a7e4cab8camr343583085a.28.1724748418988; Tue, 27 Aug 2024
 01:46:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240722101443.10768-1-feilv@asrmicro.com> <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
 <CAJfpegtPOgowkK5EHxNZnuHDo9AZTbF2-zxMc99rvWL44rdMXQ@mail.gmail.com>
In-Reply-To: <CAJfpegtPOgowkK5EHxNZnuHDo9AZTbF2-zxMc99rvWL44rdMXQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 27 Aug 2024 10:46:47 +0200
Message-ID: <CAOQ4uxiYGsKzMZ73=WLZqseU=ibboFtPfqpeGtmFWYY3uxjMvw@mail.gmail.com>
Subject: Re: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Fei Lv <feilv@asrmicro.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lianghuxu@asrmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 26, 2024 at 5:59=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Mon, 22 Jul 2024 at 15:56, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Jul 22, 2024 at 1:14=E2=80=AFPM Fei Lv <feilv@asrmicro.com> wro=
te:
> > >
> > > For upper filesystem which does not enforce ordering on storing of
> > > metadata changes(e.g. ubifs), when overlayfs file is modified for
> > > the first time, copy up will create a copy of the lower file and
> > > its parent directories in the upper layer. Permission lost of the
> > > new upper parent directory was observed during power-cut stress test.
> > >
> > > Fix by adding new mount opion "fsync=3Dstrict", make sure data/metada=
ta of
> > > copied up directory written to disk before renaming from tmp to final
> > > destination.
> > >
> > > Signed-off-by: Fei Lv <feilv@asrmicro.com>
> >
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >
> > but I'd also like to wait for an ACK from Miklos on this feature.
>
> I'm okay with this.  I'm a little confused about sync=3Dstrict mode,
> since most copy ups will have vfs_fsync() called twice.  Is this what
> we want, or could this be consolidated into a single fsync?
>

Maybe it could, but remember that ubifs strict mode is the odd case
if we have an extra fsync for the odd case, I think code simplicity is
a more important factor.

> Also is it worth optimizing away the fsync on the directory in cases
> the filesystem is well behaved?  Maybe we should just move the
> vfs_fsync() call into ovl_copy_up_metadata() and omit the complexity
> related to the additional mount option?
>

Hmm. Maybe you are confused by the commit message that only mentions
fsync of the parent directory (same as the reported reproducer), but
the strict mode fsync also affects metacopy, not only parent dir copy up.

> To me it feels that it shouldn't matter in terms of performance, but
> if reports of performance regressions come in, we can still make this
> optional.
>

I think that the case of chown -R with metacopy is going to be terribly cri=
ppled
if every metacopy gets and fsync.

Thanks,
Amir.
