Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79293370D6D
	for <linux-unionfs@vger.kernel.org>; Mon,  7 Sep 2026 11:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788779329; cv=pass; b=Jw1cc1+a1Kj+PfovD9eIguY6Ugnc6kWaJUWUZbJoyEwpD8d1zrDkTXcCPDANmhnfoLHKdbTVZHc0ZaiOYty+ZPtTgpPZYGwlx8oCSwaX06Jwhfb8kzmKtkG+JAOUylGlLZWtHBlGshILj4QiuZjMryzfLpojsnz1jIqvUPbT6y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788779329; c=relaxed/simple;
	bh=BR+eUj/ALV0eoXQmo7i7n34XaH7aoKJnU1bS8FGvxoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ux3olhgzX3F+aMcWyVV+RcbOTIytXNLpoW3DJLFKDSQPvbbE0yb2u2haVTqSIIqwVtGdu92vIMdURE2eoJJHOO5rhUIMiIo4kUlezniOm3uo3SA3rpKnrXsGc2zN9FzZZKGrpM4EUUkS6Q4yA54FCzcQmun1S91b8KmDTM8iLHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ns6QrfWI; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ns6QrfWI"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a7ea0046deso4245378a12.3
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Sep 2026 04:08:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788779326; cv=none;
        d=google.com; s=arc-20260327;
        b=fu4C2qeGUOsm8g4ndW+FtIo5v/P2Bc/HcanBYs8AzMAEmgSXFynaZbTZg8N4V6l6wA
         Dzai4IFf+FPnMav3fqR1p94bUugDvmBjn7TxPsx+c55sKBiBrLoh7qhGiiq2FGOAp93G
         QMwwyckMoT5AfjrW9m5kMrj0gUvNJeEFGORMUEH3W+ORKwj4lGJwb0+IFbFPRn5/+dUU
         V5G7a9PZx5ELsVns/tHk8B/kXHscoIGK2KhlblLL2llcoAvzhQcW85t3+EZHufWxINPN
         YxUsTvHZIM7XGovwXQjp8xVCND8BBNc4Gt4idnIv5gvz2Q0qQ2FjxZYb3Nt/QRBVSJca
         k7ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0/lzFsFhEaINkh+OA6BnMxyXwomqvTDkY7AyQ5pswls=;
        fh=QdQbnXktnT9MI1f3SHKcTOOqW/BbZoSvtya/kMdKVzU=;
        b=DSOmp8V6ueHtccFugaoMFVA1shE4JOSJnsoWQEWQHcUMFdmmnQpBJnoM/HLv6+rVgl
         CtFKwa89T0dwRgD5rAX91qNCKoGwZXTkq92GIrtsZEqtmc5FxRory+KfA1Po5DdI+nro
         n5n/7xbkfBpweECtmVljEYhsiCWP7H8Y/URC2fLZCYEpRVgBoNNqwLxypreXXVRxuqd0
         ualo+U3tKm7+yHj91QiVJHNH6My2APgnVqTsIXuu5RWMLIr7CgSjsfbxk8STjPFdreD3
         TYIZzpNIODIDdxYhKIlq/dc9vF/ltyh2J4HkNkl0LSghXmmExWlEA0NuNdo1Dxu4XaF1
         V/6A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788779326; x=1789384126; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0/lzFsFhEaINkh+OA6BnMxyXwomqvTDkY7AyQ5pswls=;
        b=ns6QrfWIKW9xEXdIi6P1CN3CT+NNAsSJ9onkLx8xKYjt19n13DMRg8Di+9fwQ3B7MH
         lqPFgECZcK3Aul2YUiG9mGBeil25UMpdZMDgAxxIaHq1QpJVw5OwAn1+y4pmzyyV7VsU
         NsTQsDJtsFaASff63T/a6ZiAqJt1KsUuINB6JWHgpV0OH6qKtj+p+k31AZrCitQ++Xu2
         u3KRZ6E4/x9FkRsACCvr408ynx35VySyrMOhOZ4gQvk4G/W55W+NZORr3swGG6vgniT7
         kdAxoQF814mg8uY8z9d7ojoNSNCe7DHu3C75BmL84C9mb82+xC7SzSd89hSAOmPQyQfT
         E//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788779326; x=1789384126;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0/lzFsFhEaINkh+OA6BnMxyXwomqvTDkY7AyQ5pswls=;
        b=c0ZTHLDUVzk7qrP3BxQhlBF+3EeX+ZOisXK9xxlaTNBoUEXJJhYb4/4fZuzaN7Fz4b
         5zKGS9N9/WvXGlFLchtrbnJ6o/Ej1k77xzFh9WwBjv3F2KG1WVfX0DuGBs/LsSJJLfnB
         HKw51gkVxQd5yQwXvfsAJef2qaLtMcMPqvEdwuxBkQDy0lIYaqfVH+X2rnPeuFTRmG1I
         ZZGoSwj45MKZZWUyrLdq4kbQWRFv46TM3UceYxvGSNefr8VnKVrylNreSa6Z84jT6RsE
         sGHgpzogrwvsou8prxDiJ2nDG2r/u1NqIsZYtT49CEK+HGGWvrFmw8a7M9Og16GJvnVV
         hojQ==
X-Gm-Message-State: AFuF++l8yyCQsDr7XR13jQf/B9wH70gtLv6CZoGy7CtRZ32WRaTn3Qs9
	gXc1if1cXuLJ2/yFszktBqQRwGcyAws/9fYtZ+GxDvsc9jXnAo42RCEv0pdMFPHQ9PEcVbP/4Mw
	aWSIDhAdCX6pXG/js49fcXLPm3IwqDbc=
X-Gm-Gg: AYBFou2LOvoppm+Z0FTYtA/nUXBM91gTlu1tvzpez/Fd7NaVZdRGZCLquWYXJf0qk1L
	Cyq3O5PJOxNx80iANIJOC2QwBx3Ewza2stJYqL4wMsxV6w/q1JPXtI4BxSXuXJTLSv1CA8T/zDh
	gy6JDCKBlbDrymEcUYn0pCClusTJQ3Xvp7RMlsLTrM8P5i5sQq96JnxNPn2+GnVrkCKLfxuOzOi
	057p/g/x+7DOT64/SyZ/sCw89E5UmvwGAJoBYEA3X53pyd94sO5gT7IPIhL7TN04p4+0zeHtfUC
	cWEGiq2cNj3MXk4GRNrA86m9ymTd8WPFixAlzqoy9NpfN+lzm2kN/yjQ
X-Received: by 2002:a05:6402:44c4:b0:6a5:f814:2278 with SMTP id
 4fb4d7f45d1cf-6a7e8d25c02mr5757746a12.2.1788779325248; Mon, 07 Sep 2026
 04:08:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907045517.1347518-1-cui.tao@linux.dev> <73236c69-bd81-45e1-8195-59775a34475a@linux.dev>
In-Reply-To: <73236c69-bd81-45e1-8195-59775a34475a@linux.dev>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 7 Sep 2026 13:08:33 +0200
X-Gm-Features: AcwNN1WRkYAEFvO02MfgvO2cIVdjx8ikA3HzbSdaJ9Rlgd-Ol6Vhuk6uNLapsKs
Message-ID: <CAOQ4uxj5thxY2sMkJUO__qWxVX5AdKeb+e1zoHcYfQBPyfqvhg@mail.gmail.com>
Subject: Re: [PATCH] ovl: clean up dir on casefold mismatch
To: Tao Cui <cui.tao@linux.dev>
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, andrealmeid@igalia.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Cui <cuitao@kylinos.cn>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 7:38=E2=80=AFAM Tao Cui <cui.tao@linux.dev> wrote:
>
>
>
> =E5=9C=A8 2026/9/7 12:55, Tao Cui =E5=86=99=E9=81=93:
> > From: Tao Cui <cuitao@kylinos.cn>
> >
> > In ovl_create_real(), the S_IFDIR case checks after a successful
> > ovl_do_mkdir() that the new directory inherited the expected casefold
> > flag.  On mismatch, err is set to -EINVAL but the directory that was
> > just created in the workdir or in the upper layer is left behind.
> >
> > The mismatch is reachable: ofs->casefold is fixed at mount time, but
> > the casefold flag of the index dir can diverge.

Hi Tao,

This is a case of:

Changes to the underlying filesystems while part of a mounted overlay
filesystem are not allowed.  If the underlying filesystem is changed,
the behavior of the overlay is undefined, though it will not result in
a crash or deadlock.

I am not sympathetic to adding code to gracefully cleanup after
this error.

Assuming that you are utilizing LLM to help you with writing overlayfs
patches please refer LLM to this commandment.

Thanks,
Amir.

> > With index=3Don, a
> > pre-existing "index" directory with +F is accepted at mount, and every
> > temp mkdir for an index entry inside it fails the check and leaks one
> > directory.  Measured on an ext4 casefold upper: 100 directory renames
> > left 100 "#nnnn" entries in the index dir, one per failed mkdir,
> > growing without bound.
> >
> > Clean up the created directory with ovl_cleanup_locked() before
> > returning the error.  All callers of ovl_create_real() arrive with the
> > parent inode locked (via start_creating()), so the locked variant must
> > be used; ovl_cleanup() would deadlock on inode_lock().
> >
> > Fixes: dfc7da402ccc9 ("ovl: Check for casefold consistency when creatin=
g new dentries")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> > ---
> >  fs/overlayfs/dir.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index 7beb0af26498..4e451bbd8f97 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -188,6 +188,7 @@ struct dentry *ovl_create_real(struct ovl_fs *ofs, =
struct dentry *parent,
> >                       if (!err && ofs->casefold !=3D ovl_dentry_casefol=
ded(newdentry)) {
> >                               pr_warn_ratelimited("wrong inherited case=
fold (%pd2)\n",
> >                                                   newdentry);
> > +                             ovl_cleanup_locked(ofs, dir, newdentry);
> >                               err =3D -EINVAL;
> >                       }
> >                       break;
>
> Sashiko pointed out that the casefold check can crash on a negative
> dentry (https://sashiko.dev/#/patchset/20260907045517.1347518-1-cui.tao%4=
0linux.dev):
>
> ovl_dentry_casefolded() evaluates IS_CASEFOLDED(d_inode()), which is a
> plain dereference, so a negative dentry would crash before we even get
> to the WARN_ON(!newdentry->d_inode) check below.  And if it somehow
> survived that, ovl_cleanup_locked() would rmdir a negative dentry.
>
> The NULL deref itself is pre-existing (dfc7da402ccc9), but the cleanup
> call makes it worse, so I'll fix the ordering in v2:
>
> +                       if (!err && d_is_positive(newdentry) &&
> +                           ofs->casefold !=3D ovl_dentry_casefolded(newd=
entry)) {
>
> Negative dentries stay on the existing WARN_ON path.
>
>
>
