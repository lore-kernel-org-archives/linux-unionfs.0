Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D25047DF99
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 13:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784814837; cv=pass; b=puYoBaDLWw4ShRAKxUXo4S0OQWio72+8FfvysSb1wdyhzuj7vGqDr8p02W+qRjgkcqnMV1OMrK3xHqnIWaQCwbJSn/pgoEq1itePcBS23BcAcl4PBL4GaHVVKIMkZilJUQUM0e7igqI0Kw3UHu2c47juNq2YqgThKtx1T4QPQVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784814837; c=relaxed/simple;
	bh=+2YHD0LYLDY85VIis/zdXqssptfCZG80ADhJvUZVeOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V3r3yjVWqzh3+QgYGmr8xqI3JnQ2acqMxv75IgHEWc0u+t5PpXdRiJIYbLCasEpnkOvLGEISYObAGlEOcScm08teGX8MCZR07qY2OxQaJynhxaOKi1odpo8HAP3FwaDWTHp9N/u0AsCeXNUPSMkJIhTtBdluo04Ux6265PVlwhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=TCOs5iNH; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="TCOs5iNH"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-39c62764c7cso4252881fa.0
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 06:53:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784814830; cv=none;
        d=google.com; s=arc-20260327;
        b=i4sp85tiu1xR8aWxDIqhJRvJIW++Ak6tHDAldcwDzLS5zUan2BY2mmgxJV3E163Vgw
         ubHzg2+/lTlKw3dTShb72fUYVdJ6s/CSy78730gHlJXViF1ZrK1twvJPjAQtbm5qjbLF
         PDqNZwRgOJclIqxJO8fpzJ919ntYPoTRA+0HrFw+yyspWfwf3MSs58dbPsSjURlBGqIM
         Xa0gqKDmC3WwM6L/cBLLG9qtwAcs2oNXIR3F2yyf36zYeuIammgAaeEp9HqExZE2RbA4
         lPQMW5ksY5EjOQg3EtEcyzxw+KYVEGrUJrMIrIfkIKJxO+EzRop1RavfGA3rEpSfZbyX
         Jmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/Qvp7W6WcD3MjP5gFX1gpVdJqvDJJ2Ad7xiF0QUVglM=;
        fh=T06wrylOkwVs4lFBBk7fd9uduzXLndpVNXt/veyQt2g=;
        b=Gy4F7ROPEKsneZPlo9pI6SSbqFafNRKikfl19+yNVPhmuKDQn2jH4xzMUwUJAGYAQA
         UPjMavRawjZIpOd54NTVAjKh3ST/OaoHLVrRGhqf2K1um2qaFfERKlGl7sQ14sEhtMxe
         WHG1CnMmDZy4LRXok7Aywc919ApIs3pGEgxWiCnMwvR+fV199+Oq/J5jgnX1L7/3V2JX
         nG3yUstkCbMIES3rzruM9eVSNzY1yQU4ZkSr8Cz31hmheELNL4+gBL+qja4fWLyKBCoT
         r4L3zTGQ2OpCW9XQ4cG78tBnC9t+iPBfo7KtGA3SgF4eyam4HLZqXUp+PaCBGh2kEwTu
         52Jw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784814830; x=1785419630; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/Qvp7W6WcD3MjP5gFX1gpVdJqvDJJ2Ad7xiF0QUVglM=;
        b=TCOs5iNHvbsl5X6Hfo62GvD27H13zYc3QJBzwYLSTICTXOBhF+lI6AkcUI2dFVsJXD
         g0aLU8WncvBsbZ62FIBlKUXFEO7Tu+S95BeppRX0MknJBoAQZQ3EwjArRLoPNqeaDypP
         9UwvodURNnpiXFe+1QTHM4jgX+8zxNyuCl/XE7AFiX7+VFHORmwYBps6ke0M/SuvlTYs
         bx5yPZU2am6Xoh0JYP4JqTaQIWPTfQOXgVtq/1WpN443Y28g6w32TJxwhfQLNjx3K6YP
         UGjcIy0Om5nIufS5anzRnOLL0rLP39PjNDn/093CvY21UINr6LQYaq/3YLQeeXZ78o8V
         DEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784814830; x=1785419630;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Qvp7W6WcD3MjP5gFX1gpVdJqvDJJ2Ad7xiF0QUVglM=;
        b=A8nL7eh9JUufn6MXgaLuE3ls34U1QOenjgLHTqlLH9lKli0DFG/eyPS4xswkKK2SrH
         hh0TQdeIG+98TLUQo/gkgz/MRQkx18wdisarWd9bKqY9vdqGFuA3tQezy/OYyIMQYWdb
         465pnqluta+7g4oWncXGeHJ7l28VCChjsQ022/n2/HTabfPDOgxbAc0FZskJOb+7Evwl
         5tS5POO4Mz6nixOdOJ6nomA3H+w8zet/KeKGNXpqXK1/Wf1OQiRL9TWCXtiV+5HyiEJ/
         l+BmVxMTS91hyrRaFbl+0VOB1hCOpiyeFjylAYN+9a1KUlOexbw2/hLtnWetHniqQ1al
         T4gQ==
X-Forwarded-Encrypted: i=1; AHgh+RruPctTaTP58aLw0QdzdLdBSNxVF14yc9T9UIIqp+AUV3KjCdS03N1jX8N8NZ0k/AS27oIgiGl8JwU8U9sP@vger.kernel.org
X-Gm-Message-State: AOJu0YwPwK8ZXjBkyJkl6TDD3Ahv5F96EhPNaaRaPsl2UaYBwpSNGni6
	xA7UrURn701qrqYTwlRJMHxp9Q8gBKNdugr7oWXnl+kD8QGbM57rx2nr71ft6XLbRSfpnN4kwUq
	WzQJXuEklYEaYPFYidOQymUF4273qJoN14cwmV+i4
X-Gm-Gg: AR+sD12Mz0AVGQNiQsqMPCK5nC2anElw91sWRVG+amRPvdPXgk5a3fQUrp6ni/Qx4ks
	LABOlHrID/L4xEowqdHHUn81NbIIzbvOMsAGNs4/bChQXljdG0+fCwmiCrvGZ7caTS11K1Rg6g2
	WqCqUjltb5XrJVFDnHRkoVlDcGv8/GNhuuWNt42udjmwz+U1O4zZK1VScO3cRGyeI9e1E9JvD4J
	+FxgywfNY3oV3Ym+5gMI6XIfjb39HxdODbBee03jajBNzV8r1GQNegL3SDxGA==
X-Received: by 2002:a05:6512:ba9:b0:5ae:a9ed:35a6 with SMTP id
 2adb3069b0e04-5b2b33cde5emr603977e87.31.1784814830282; Thu, 23 Jul 2026
 06:53:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
 <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net> <CAJfpegteZbnPkiTSAPWXDqZbf5eALK0E_npBLtLTmJyZaHXdyg@mail.gmail.com>
In-Reply-To: <CAJfpegteZbnPkiTSAPWXDqZbf5eALK0E_npBLtLTmJyZaHXdyg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 23 Jul 2026 06:53:38 -0700
X-Gm-Features: AUfX_mwpGfNjVX76f8of_9AJftpdKTQtdZGp4l8jZIXndq3Duzeb778fccyzEFg
Message-ID: <CALCETrWCf67TTiRSikTjgBZ+jKc_HPptEp9BvO2G=1-C5D2F_w@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Xiang Gao <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 2:19=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 23 Jul 2026 at 11:01, Andy Lutomirski <luto@amacapital.net> wrote=
:
>
> > - O_XYZ flags to open() are all kinds of awful, for historical reasons =
that are not fundamental to the concept.
>
> I'm fine with limiting this to openat2().
>
> > - symlinks. If we have a new API where opening /proc/something/magic/bl=
ah can access something that ought to be inaccessible when accessed intenti=
onally and with privilege, a symlink pointing at /proc/something/=E2=80=A6 =
can cause the API to be used inadvertently.  Admittedly we have this proble=
m with basically all symlinks, so this isn=E2=80=99t exactly unique.
> >
> > - our nasty fs permission model. We gave a sort of gnarly mix of a bit =
of fd-based permission and mostly mode/ACL-based permissions for path trave=
rsal and opening, and mapping this nicely only new APIs (as opposed to actu=
al files and directories) can have unpleasant results.
>
> Pseudo filesystems don't usually do mode/acl based permission checks.
>  I don't see any issue with that.
>
> > Of course, I=E2=80=99m busy arguing (slowly and without a concrete prop=
osal) that we should have proper capability-like fds, and maybe that=E2=80=
=99s kind of an answer to this:
> >
> > What if we had an API to get an fd to the =E2=80=9Ccontrol filesystem=
=E2=80=9D for a superblock, like your O_ALT but as a real syscall or maybe =
only accessible via one of the newer and less janky open variants?  And wha=
t if the resulting fd and the filesystem tree it represented had a few prop=
erties that made it very different from normal directory fds:
> >
> > - You cannot mount anything on it or its subdirectories, nor can you op=
en_tree or otherwise mount it anywhere.  But you can open_tree the very spe=
cific things in it that point outside of the special API (e.g. the overlayf=
s layers).
>
> This patch provides exeactly those properties.
>
> > - Privilege is fully captured by the original call that gets you the fd=
.  current->cred is not checked when *using* it except to the extent that y=
ou might need privileges over your own namespaces to do operations that mig=
ht affect them.
>
> This is trivial to add to metafs: just store a ref to current->cred
> besides the path.

We have f_cred that might be good enough, although I'm not sure it
propagates through path lookup.

>
> Not sure how this security model would work, though.

If I have CAP_SYS_ADMIN and I open the metafs and then drop privilege,
then I would still be able to do all the metafs operations as if I had
CAP_SYS_ADMIN so long as I use the fd I opened to do those operations.

>
> >
> > - You can=E2=80=99t fchdir or (hypothetically) fchroot into it.  (Not s=
ure how important this is.)
>
> Not sure if there are internal mounts that have directories?  If not,
> we can just add a check to fchdir/chroot against mnt_ns being NULL.
>
> > - Maybe you can=E2=80=99t follow /proc/pid/fd/N links into it either?  =
Or maybe that would break CRIU too badly.
> >
> > The basic idea here is to try to treat it like an API that happens to u=
se the open machinery but not as part of the filesystem hierarchy.
>
> I'm not opposed to limiting this in various ways, though I don't
> really see the advantage.

I'll sleep on it.  Maybe it's all fine.
