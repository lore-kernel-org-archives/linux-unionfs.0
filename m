Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EC63A640B
	for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2026 23:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776815667; cv=pass; b=gBcCbKjgcCkOOc+We9Uq9+QkMu8+kGsISs5hF30KMqafpO7u63CWnsYa18P3ykMvnad42HUauM4stRvWrf9dyOflwLweA8R/MMLAPQO36GffH44bh9XxWOeUxaNPrTROvlmBwG6TSjBBbK0P5wAHfVZ15d53JfyTEzVMYEck1Eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776815667; c=relaxed/simple;
	bh=H1tHV2AxqvpQzt0bU5Pihn0mRHk/4Zw8qlVOIr0xMMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FM8YUwUlVeAj7nSMuRipgjGZbkaXYn/IfvF9U/9FJKJ786WrXN7kM4E6+ag4ACt93pOG04r+0XkNaHQZaqToLVd794tCAkllvpmpjMwtmZUYyUMo7jZXbC9QxUodszkj0SwPVQmr5o1cQMC+T+ToUfIVuh0x3LYz0cSHwD2e6bU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EXHosAoc; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EXHosAoc"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50e5dbd8e0eso25182091cf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2026 16:54:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776815665; cv=none;
        d=google.com; s=arc-20240605;
        b=Y27ubodPuNsgLHdlFwUMALQoI+XHQSH/IrBOowQNwEe4Z9M2ywQTqvtwm+HxbPhKHB
         M2gAGkrSuTgQB0JrzoSs8pwJgfMgZL+EkaUqLf/7FPLgQaU+4407921hogZeSphB9tA6
         NsmTS1MEUvkqF2rx7QwvSglPwWzHwOfbU+oLGFEKRr1D7yVPq0G3RpCR51kwEZArbVyb
         Y3hBDrCPvZDigl5HdkTVs151JxaNrlPNMEvH0RYd+DRav1QiQ8BBRQLpTY0vIeHMCpkP
         y8cJ6YC3hdOT1Xu22fTA+Tzm7Q+Ap8f0hlXMQ/OQhia5He5Dy1OTRpdNqJ5RXuK+1ALo
         wjIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aKcIgoAajVypMfQvXdPWBcTg4avBTwmW4grlivILcXA=;
        fh=PR6VtcLYLs5XO7QV1p3VcNY1CgmLomC5Sw0fVAELaT0=;
        b=csnxhRlRyFpCQq3iIx6ATQ61QkgExDtoeN9Kn+Bvc8efX9Fu9wdbqDtzgnZv1KwIK7
         /pZ6PNPZThDd9fUURXRcEhx1bMjP5f8o7W83x2kh0AZfI1psewsQUAKo1yU6vVvMFM/y
         ylvDcMVrtieHZI5kbUxU6vVH4oNMxpgRnqwCcreqczZdtChSK8lowf2UxYHTUBlqSGK0
         qayS4UvssbT0rLacliDVwjZkcIYBuMuw2J2hIJl9qN6arAztk4uD8fgOIf7i+apUYfod
         pTphwcRsGPSnXHnveaLKFsweBAMj+/+33e9WliPqqHmLMxXqmQDP3q4LH+sRVTAIP4oD
         CwJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776815665; x=1777420465; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKcIgoAajVypMfQvXdPWBcTg4avBTwmW4grlivILcXA=;
        b=EXHosAocc2Bsm+S+TbvXYc058xM+ckplBxlZ+YHzKEeLEj+IhfHUQpqJUIzPTe/W0b
         Cfw/OxO2M0YSIEPllZcTtgNW54+ZjuGJ9RbMLhI7DJerBkGNrHwTbgflKP9Hjk7jliGK
         RDJ/KhMa8UOxq54jhr1JgeXDLdj8nU/QchOHL2fKZ/2Maou0cqfc23c9d4Y3UVTq2giZ
         UTlJOGafiGLSfmgOlBG0WpLERNA+cxdvfAGX4JLfHqsrhaDcb8xhC/1oTtu5s5kl7Tfb
         Cl7vx1xmKKtVXEz9b/0AhgFwplnQPW+nZ3VYxO+Wl0zebFV5WfJGig/JwbGphZDiJunH
         oX6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776815665; x=1777420465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aKcIgoAajVypMfQvXdPWBcTg4avBTwmW4grlivILcXA=;
        b=S7xVXr1dP4CT8YVyk3X/1Qo7vJxGFfRQmsmWvCfDtKuEknkC8GNKoF67yX6vNcNx/I
         1ROgt9Czc+mLHwoOTZwt851x2YgRUybr6/9beP5py+zuYTjNFw0/P2cD6XpiOEZinwuX
         g6jYld4yJkQbRR5ZfzWUIQDKyL+T89XeEhkCs1j4mp/Etsf7gxe7X/lh1ZoMYXwEruSj
         M3qvP9M7h4qUfiaPpl5rFZRIPqqhvpbErkGM/c3iMrLrP5K2PnsJCYXbsO3wsBj12RE2
         4oxSR0p+lZygBJaH1Y4xSGu7y4cI54jl4kxP7DyAYShZkECAvbLdmLSTHfmM+xjvIrQ6
         QwOg==
X-Forwarded-Encrypted: i=1; AFNElJ8IakmIC1oOIJazKZMdG9qBCFYhuOR/kfWvcV+wHKiqiKni5lHhW1TqZa4L7GuA9jumH/xvbtFwOcoEb/5a@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9OPt958JfEP0ZXdFUCfHT06tZD1c7cYkzdkK90RI6rIsfkyyp
	RaobSMpJn93sOKK8cIw2ltqbVQxZFZIOPTJaj5UIiGbNgd52B5LX7FBYxVo/kyUWkLE8SbpRZJu
	oAcjfraU0vu86U4n6H6VzQGMet5pYq7Sm6OLKR6y7
X-Gm-Gg: AeBDievkK4xKx6SDQ4F8ha9DuuryOyLTFFrmO81LZneLa5XtRZ/ig7XouF8QxGNMCwE
	kJGBq4to3O1kzVs1BW2SGoqEbMRHXIR1JLNhna0Qh4ywnNQ5L3gwZ1GW1os82ce6XHBpEy8jJoe
	hauu3POZ++xNztN6v2jPz7PbK/o9O19NtTrJZ0EJnUGw7FK/g1R7TqIcR2pOCi4QPXcPFp+MbxS
	hZAd96fNlUcsJTtuYlXQRDwU6uG35Zy8moAELcvuzn5lP7ea/COHYMhu3EO6DHGaZiYlIuukstN
	sO4rS+Ts1opZEU5A4MeXAYkD/Nk=
X-Received: by 2002:a05:622a:4d93:b0:50d:a5e8:39e9 with SMTP id
 d75a77b69052e-50e36b495e9mr297879961cf.20.1776815664530; Tue, 21 Apr 2026
 16:54:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHWLEDHfXZScF5jNDzgOxGXf-MBDcVNtqW0DbNz8Ra8rtcuL+w@mail.gmail.com>
 <CAOdxtTbwipkyAfDakLAB6aVp6YkPWtKpDdVDUTz88WDB-18HXQ@mail.gmail.com>
 <CAOQ4uxhUn6oCBuVJqZu+FcMx8XeAQHZbXFAGon4Xeg2SPLJW_A@mail.gmail.com>
 <CAOdxtTaWWu_7eJWu68zf28zHQP3Y--vXTfbGFsceO47BpN3qxA@mail.gmail.com>
 <CAOQ4uxhCNhGinePrnkSfT9Mtf4o5FmBX7mTA2m4miCMOt3mJqA@mail.gmail.com> <CAOdxtTZGFxaayJpqsiFQrWBqXvDn7oyxSL3_9TWP919k0FhWTg@mail.gmail.com>
In-Reply-To: <CAOdxtTZGFxaayJpqsiFQrWBqXvDn7oyxSL3_9TWP919k0FhWTg@mail.gmail.com>
From: Samuel Karp <samuelkarp@google.com>
Date: Tue, 21 Apr 2026 16:54:06 -0700
X-Gm-Features: AQROBzAkSzvOaq9x23mj12eG21nTUWOF2akExiQWk4MV82XnI5dSal-M0xoxtz0
Message-ID: <CAE6nXrPes8T9Cn4ihTt43qmtgCCZvmMwYXo-yG_HJgNO7y+vVg@mail.gmail.com>
Subject: Re: [REGRESSION] Return change in 6.12.80+ with volatile mounting
To: Chenglong Tang <chenglongtang@google.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Derek Taylor <ddtaylor@google.com>, stable@vger.kernel.org, 
	regressions@lists.linux.dev, Kevin Berry <kpberry@google.com>, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We can fix the test case for the "volatile" option and expect either
"volatile" or "fsync=3Dvolatile". Existing use within containerd beyond
the test code involves us producing the "volatile" option and passing
it to the mount syscall (or _not_ passing it, depending on the
situation). This seems like it should still work if "fsync=3Dvolatile"
is an alias rather than a replacement.  However, containerd is not in
full control of the mount options; as part of snapshot (layer)
management external snapshotter implementations can provide mount
options to containerd which containerd then passes to the kernel.  The
protection in RemoveVolatileOption will break if a newer snapshotter
produces "fsync=3Dvolatile" and provides it to an unpatched version of
containerd.  I think the breakage scenario then becomes new kernel +
new snapshotter (producing the new option) + old containerd.

--=20
Samuel Karp

--=20
Samuel Karp


On Tue, Apr 21, 2026 at 10:20=E2=80=AFAM Chenglong Tang
<chenglongtang@google.com> wrote:
>
> CC: Samnuel from containerd
>
> On Mon, Apr 20, 2026 at 12:59=E2=80=AFAM Amir Goldstein <amir73il@gmail.c=
om> wrote:
> >
> > On Mon, Apr 20, 2026 at 8:31=E2=80=AFAM Chenglong Tang <chenglongtang@g=
oogle.com> wrote:
> > >
> > > Hi, Amir,
> > >
> > > Thanks for looking into this! To answer your questions:
> > >
> > > 1. Production vs. Test Suite Impact
> > >
> > > The immediate failure we encountered is in containerd's integration
> > > test suite (TestImageVolumeCheckVolatileOption). The test explicitly
> > > reads /proc/mounts and expects the exact string "volatile".
> > >
> > > In default production, containerd passes the legacy "volatile" string
> > > to the mount syscall, which your patch correctly handles under the
> > > hood. So the standard "happy path" is not broken in production.
> > >
> > > 2. The purpose of WithTempMount() / RemoveVolatileOption
> > >
> > > Containerd regularly makes temporary overlay mounts (e.g., for
> > > unpacking layers). Because overlayfs rejects reusing upper/work dirs
> > > from a volatile mount, containerd uses RemoveVolatileOption to strip
> > > the volatile flag before these temporary mounts.
> > >
> > > Currently, containerd's RemoveVolatileOption does an exact string
> > > match for "volatile". While it works for the default path, there is a
> > > production edge case: if a user explicitly configures their container
> > > runtime to use the new "fsync=3Dvolatile" option, older containerd
> > > binaries will fail to strip it, and the temporary mounts will be
> > > rejected by the kernel.
> >
> > I need to challenge this specific argument because I do not agree
> > that this edge case could be considered a regression at all.
> >
> > An admin from the past could not have set an explicit
> > "fsync=3Dvolatile" mount option.
> >
> > Though experiment - overlayfs adds a new mode fsync=3Doff
> > which is more loose than "volatile" because "volatile" can actually
> > return error on fsync in some cases.
> >
> > Overlayfs would also not allow to reuse workdir from such
> > a mount.
> >
> > So would you then claim that adding the new mount option
> > "fsync=3Doff" is a regression because of the edge case that an admin
> > decided to explicitly add "fsync=3Doff" and RemoveVolatileOption()
> > does not handle it.
> >
> > I don't buy it.
> >
> > There is a more correct way to handle this situation and it is
> > documented in overlayfs.rst:
> >
> > "When overlay is mounted with "volatile" option, the directory
> > "$workdir/work/incompat/volatile" is created.  During next mount, overl=
ay
> > checks for this directory and refuses to mount if present. This is a st=
rong
> > indicator that the user should discard upper and work directories and c=
reate
> > fresh ones. In very limited cases where the user knows that the system =
has
> > not crashed and contents of upperdir are intact, the "volatile" directo=
ry
> > can be removed."
> >
> > containerd unpacking layers falls under this very limited case.
> > containerd can syncfs() workdir after unpack & unmount of temp
> > overlayfs and remove the "incompat/volatile" directory and then
> > the upperdir/workdir are are free to be remounted.
> >
> > >
> > > Conclusion
> > >
> > > While containerd could theoretically patch their code to accept
> > > strings.Contains() or fsync=3Dvolatile going forward, there are many
> >
> > Following the documentation advise would be better.
> >
> > > existing containerd binaries in the wild. Given that this patch break=
s
> > > containerd's CI tests and introduces an edge case for
> > > RemoveVolatileOption, it might be safest to fix ovl_show_options in
> > > the kernel to continue outputting the legacy "volatile" string to
> > > strictly guarantee backwards compatibility with userspace.
> > >
> >
> > Considering my comments above, I think we have not yet reached
> > the point where the backward compat "volatile" string is called for,
> > but with other reports from production workloads, we could get there.
> >
> > Thanks for the clear and honest explanations of the containerd situatio=
n!
> > Amir.
