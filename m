Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2809170A01;
	Fri, 30 Aug 2024 09:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725010016; cv=none; b=JlD1qrafpmNoNF6ZBS5JCdKTwgvCugmeFG52xBnY7BAm5Kk9buc5yPy8RBbny79dLFuv9WgC2oKOdpTbSju/AgLmZnCq5guYvqRlY0dtt0+D8WDjwB6kSAmSOKxUswORJK08Fa39JW6K2pcHp+ux8szEIB+UoIijR3mghjfG2oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725010016; c=relaxed/simple;
	bh=66y2vDmD7kCDgPvH8bwyXjtkNSOLQgsLZ/+Kej/eLkU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uXkI0ws9Sc2glYznS4zieoifEszLfb3PYO/FsliCnL2yX6e+1WL37XmnxlOh36srbKwKi1De2qYK+o2o/jELB3v9WkxqTBVN9pozEpE9XtXKgI0Us7EBNesCQY1g/IXrYo8ujjRG2q6/2rl3OPIytcGPHo4OmKiZi0Sxi6R+YqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AcHL4VyE; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AcHL4VyE"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7a80fe481a9so43722785a.0;
        Fri, 30 Aug 2024 02:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725010014; x=1725614814; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RngU+AnscgGqUpHwM43E/2UFV355OkAfNYeW7qSTUnY=;
        b=AcHL4VyEFWQ/GFtAO+xzRbhsc6B0qEphWF98PM2M4bzE+TOW/MHogTku91S2o/v9C4
         yorRCbhhjTWQbnyOojpuk5mFL66TQerEn3M5Ar47M1ITd/gFnLuXEwGav5J8O8CHP4+7
         9moRPuLInaaQqYqzMtcRWINCxORE9S+Sjx6bh9qjR5vfhwCcsRzVvoutnWEm6BgcVKWy
         P6WyZmq6RhshOVOk5AagwS4vctm7UNhWQwS1m5ZJTAfJKTPR615lYU6ERU1rC56ku2zo
         HuN8eL+noGnTNbjABNra0NPpgPXKW5tAsYN3fuYjUfFq9X0KdYFQFb9d3Ot3bLyKpg7g
         mY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725010014; x=1725614814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RngU+AnscgGqUpHwM43E/2UFV355OkAfNYeW7qSTUnY=;
        b=IDzcb0Hm0RGe94dZaHMziQdUsvaeoI8bu/CCPODIf6we73XgX8uIu/cIRm0cphe7u6
         UB0eJNUjgVer3sKq0dcP8y44q0/FppuBLuNl+PxOjKIhwPsUNKSxb/GCOgRhFm+XqeGs
         rjN00fbBhJBgxfbyRMv9GnSmZWTaZGBr9twR0QEQ8KkLvZqUiX0dzPy6JEwmYnLYvfsg
         F8lgYTlrlTMaDD7kZjxkS8XDTR4kXn0etyk7b+miBfqL0dmWTVH5aGc6pXPjSg+7vtSH
         hsOE5yVjSnUhbgZ7W/S+WyabwNzaQVjjHJ6GnRUlCEpWKRjCungkmo6GjgOHkfLIUf6c
         jSTA==
X-Forwarded-Encrypted: i=1; AJvYcCV7MVPItMm4/jbz6iz2CtJ2qLiflROk+Ecic3lBW9ixUBVQaKjtRL1VaIicn7OJWKwfVReY1kv51mFmODs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5MlY4EZhUOadgbQH085nqAzoAyLE43XY4QApfHBFAxyXr1tV9
	bVKHX00adVpejPO9dI5V/RUUQIClYXu+s5TtLvavETRmzey98nnSTukVCpbfkaVO5olV9jknhOh
	oW2Ce5YD3WGilXRfbe6J2swT8lQHbw1sMWog=
X-Google-Smtp-Source: AGHT+IGydVe0OttAVaEEKkJEXcLJQmtOuyaPuXlH5pKvMS25AuZszVhg5AfPe80MuUoOc+kLdE43y5VdsxyUsG27738=
X-Received: by 2002:a05:620a:1984:b0:7a2:db1:573d with SMTP id
 af79cd13be357-7a8041d3543mr606104485a.36.1725010013497; Fri, 30 Aug 2024
 02:26:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240722101443.10768-1-feilv@asrmicro.com> <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
 <CAJfpegtPOgowkK5EHxNZnuHDo9AZTbF2-zxMc99rvWL44rdMXQ@mail.gmail.com>
 <CAOQ4uxiYGsKzMZ73=WLZqseU=ibboFtPfqpeGtmFWYY3uxjMvw@mail.gmail.com>
 <CAOQ4uxi-BuKU-AbyydVB2c8z0DiPP-Ednu+bN3JB2Cqf7rZamA@mail.gmail.com>
 <CAJfpegt=BLfdb5GRbsOHheStve8S57V9XRDN_cNKcxst2dKZzw@mail.gmail.com> <CAOQ4uxhtoAL43d5HcVEsAH2EtgiT8h6RkjymNhTcP5nnG1h09g@mail.gmail.com>
In-Reply-To: <CAOQ4uxhtoAL43d5HcVEsAH2EtgiT8h6RkjymNhTcP5nnG1h09g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Aug 2024 11:26:42 +0200
Message-ID: <CAOQ4uxjkVcY7z8JCshmsCfn1=JUcxDG8vyJQ+ssdeBmGrZ=eKg@mail.gmail.com>
Subject: Re: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
To: Miklos Szeredi <miklos@szeredi.hu>, Fei Lv <feilv@asrmicro.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lianghuxu@asrmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 6:23=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, Aug 29, 2024 at 2:51=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Thu, 29 Aug 2024 at 12:29, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> > > But maybe we can ignore crash safety of metacopy on ubifs, because
> > > 1. the ubifs users may not be using this feature
> > > 2. ubifs may be nice and takes care of ordering O_TMPFILE
> > >     metadata updates before exposing the link
> > >
> > > Then we can do the following:
> > > IF (metacopy_enabled)
> > >     fsync only in ovl_copy_up_file()
> > > ELSE
> > >     fsync only in ovl_copy_up_metadata()
> > >
> > > Let me know what you think.
> >
> > Sounds like a good compromise.
> >
>
> Fei,
>
> Could you please test the attached patch and confirm that your
> use case does not depend on metacopy enabled?
>
> In any case, I am holding on to your patch in case someone reports
> a performance regression with this unconditional fsync approach.
>

Well, it's a good thing that I took Miklois' advice to make the fsync
option implicit, because the original patch had 2 bugs detected by fstest:
1. missing O_LARGEFILE
2. trying to fsync special files

Please see uptodate patch at:
https://github.com/amir73il/linux/commits/ovl-fsync/

If there are no complaints, I will queue this up for v6.12.
Fei, please provide your Tested-by.

Thanks,
Amir.
