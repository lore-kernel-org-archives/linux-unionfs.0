Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B102F6188
	for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2026 17:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776792020; cv=pass; b=TYy9Oj7dfzlN+9nXXYK3qT0fI2f/ezC7k+URePlpiymPdFavmQUTF3bnC3cwXNX5zNbYCf0NsFT7IpWTRVXEYyv3hGgLVW6nrxlxUiUdtWY5VEaj6ONaSRMTKvZNmSRHWU4P6prZZ7qVja34KpLKR0tSomvfwVylcBELlMNhLUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776792020; c=relaxed/simple;
	bh=Vxeh3HrJSuiP4oJvDrptNJN1vnuRJPPVEP7iiGSRHi4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=seT7A2DbjMy1v7bxwQQp16sjFPjLbD3Ow+oP/96Dij2peyKzJTH0OfocKVBfLO+r97y4oc0rScpGsxElP6MwrHdEtj2idjSZ5Efl+/+B212f80L7vF0an1LPwvl79AjGCFu/XdCwH8YEYgwHg5i2N7cQ8jhl41RiknbkGU/Ar34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eOv5casS; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eOv5casS"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50d836552daso2348161cf.0
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2026 10:20:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776792017; cv=none;
        d=google.com; s=arc-20240605;
        b=Gq4rVPk9dvypeXr0NxXadE5XkaGvrqPW1UAASyeKjhXDzQGY1SwbRTOMQkVJMzP46Z
         7k4KI6lsau8wu7f/TST2vptVXda9+DczyjHFqHREoQ0OlDNw1uspW7Px/4T35iE0xQI/
         3ETa9hZAYNJZKVj9o4rVWEPTCKNxdYbby5oKC/VKA5/qB+8OBUtn5K+yj1Tb0ZBKoQNJ
         1Frhy/5h839sVysshRR3bNs7OABvNrwnMy6bsHFnRl9s+kySoI43wktqUtwgM3P5WtLu
         jpRteLna/NNQQxgcorclOvzc1V4IUlp4uv5iLh+PduMEcbqCROtOzEh5JEXhkzGat+yW
         x7WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ha9b3BYC/DPqvosH7Lf4u9Isf4lxfWOStmLn8gp6G1A=;
        fh=GLRTj76RBsdYcCnylkUkmkXsO/1jijjZJlLi8APnwfc=;
        b=AzTM6E1Qgm4Z72R7dKrMkI8N0SJ1qsEqCKqXgzy9XIOfz5O+05O2PFaNXvAETgX3hp
         a+f+x2WkbksXaF8fHy9OzHj2uQces55zLa6lszmsEV1oBM/jsDChOMAHEPFkB5z+bCbY
         9BaMb/enAZgNat/mFurOIFS13RMTFjTKbY5UbQEnodK4+RONhLifNsYab6HrBCU40OQz
         +RhJ1xHYgOu1QYFRAOiuegeTNZiqWZNsrkqXvAi0GAZSlWGAxYG+ffXAJs4ui/QTvNSB
         b8Ql6py2YwIdsCA2mG8jN5jm4UCmaOMWZv/cKMCOiz9UTWnWX8OYe6jrpuUQS0CMWDZ+
         jxCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776792017; x=1777396817; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ha9b3BYC/DPqvosH7Lf4u9Isf4lxfWOStmLn8gp6G1A=;
        b=eOv5casSBww4kZRMsL4ioPLPsN5wwgraVByVXAcUvATWEpNXh9QstLWtcBGlzioA9q
         eN27LS0YCsR4uUYFdrKG9dd+d9BMqgaI0Tr10b2PmZBIibqwyvE3lNG/tIOj1Qgg04+5
         n1RjTMilcXx663FR0V5fNz50x3rVhiOdH+bQ23vCIwTnnv0VH0GYiteDNTLkSaIDtDL8
         KCvcoGi/pXOYD2pgbxuIfpTbenqGZfDSepgUf+1Pn0z+g6TRHmjyQVjiVb/+1bCfLUp4
         kl215eOmhEKk48vdQKz4hRrHaC60gBhC17kC1E3SFdbGY1noCO83yukZ2owmxV5Y7Fig
         ZvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776792017; x=1777396817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ha9b3BYC/DPqvosH7Lf4u9Isf4lxfWOStmLn8gp6G1A=;
        b=fsLJavIxmiYoERol8Zw1x6FRts+7Xkty3sFsIEg7ICtbFSmlDLogSGtaGTrvK0z+H/
         RcqclzUdgNCMc+uxEOUJ1vqNYU6U7Ry6EnBuYRv8DWnG7aa8P1VGhiTeTRwexfHfjfrb
         gbx9lpC6RrZrWx5SZY34UmXH++KDlPgUvlWbvGNFBYZ+a5AI6axf7h/z83urxprvGbtF
         mfaHQp02vz6HjEOP255NG0i8kE0qY+hhtqaSIgdMwYZpmRmNdaGpHPd0cHLODzfWyx27
         ZW2c6kkilMC/jh5/iHAq9HS8xZFuoYUVmr+K+IKOEKZoYlU/aMhA3uIKtLs70jQIm2yc
         I2hg==
X-Forwarded-Encrypted: i=1; AFNElJ8u85ktinZH3MyfD5RPz+2pRPqYUEsLwBd9wksyVFyWZgDHPIECmYace8MD4YoXEAFyS8OE5Eg50NT3ar6J@vger.kernel.org
X-Gm-Message-State: AOJu0YzKNL+vJ29nBchftdeRr3SpEO6Gm2pV+hY6lnZt1UonJabF3aFl
	jG5HbmEInu1LwtoskZt9RUa4d3JzCl7cQMgKkr9CPxqHR3M7eDn1KZNM9TljLOo1j0v+Kl9dGr3
	hNvq19ZgxkHV1z2l5MMAB8LyijVvUKHfOulaY/v5P
X-Gm-Gg: AeBDietXemMtVOAUyNxLECe5+OIjPO6//6c8i/xE5T0O5SU0n+nKKYm0MxzA7uNPimB
	FvvlsF3xLMrnNce34sNvYyTTb4f/PwevyCq7k03hdNiYwKo+c8drwz9KRjkjympvYAIm5KCG2b7
	PAoU+BlLIApdCAmwrrnmlzEAz79hZp7uKCoj2RknW7NkeptRyBqi6XxtLrWzR+WnAojxFwoqsHW
	HmDwfXDv1KJ9jt1wtQViBGWcfiDlSPP6Dcjk5WH4jVTP+A8xvk5dhbxZ8YaRRXT0AinVIsu7bsV
	iQcdrRCtU/menSXWG8WRqRxKsod0
X-Received: by 2002:a05:622a:5a87:b0:508:fd42:fd05 with SMTP id
 d75a77b69052e-50e4420283bmr53961561cf.15.1776792014053; Tue, 21 Apr 2026
 10:20:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHWLEDHfXZScF5jNDzgOxGXf-MBDcVNtqW0DbNz8Ra8rtcuL+w@mail.gmail.com>
 <CAOdxtTbwipkyAfDakLAB6aVp6YkPWtKpDdVDUTz88WDB-18HXQ@mail.gmail.com>
 <CAOQ4uxhUn6oCBuVJqZu+FcMx8XeAQHZbXFAGon4Xeg2SPLJW_A@mail.gmail.com>
 <CAOdxtTaWWu_7eJWu68zf28zHQP3Y--vXTfbGFsceO47BpN3qxA@mail.gmail.com> <CAOQ4uxhCNhGinePrnkSfT9Mtf4o5FmBX7mTA2m4miCMOt3mJqA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhCNhGinePrnkSfT9Mtf4o5FmBX7mTA2m4miCMOt3mJqA@mail.gmail.com>
From: Chenglong Tang <chenglongtang@google.com>
Date: Tue, 21 Apr 2026 10:20:03 -0700
X-Gm-Features: AQROBzDjNAxFnpR4sQRC9kzmG1vz5c9sq9OzKeP03GuQb7DjEPQ23ObObnZ8GC8
Message-ID: <CAOdxtTZGFxaayJpqsiFQrWBqXvDn7oyxSL3_9TWP919k0FhWTg@mail.gmail.com>
Subject: Re: [REGRESSION] Return change in 6.12.80+ with volatile mounting
To: Amir Goldstein <amir73il@gmail.com>
Cc: Derek Taylor <ddtaylor@google.com>, stable@vger.kernel.org, 
	regressions@lists.linux.dev, Kevin Berry <kpberry@google.com>, 
	overlayfs <linux-unionfs@vger.kernel.org>, Samuel Karp <samuelkarp@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

CC: Samnuel from containerd

On Mon, Apr 20, 2026 at 12:59=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Mon, Apr 20, 2026 at 8:31=E2=80=AFAM Chenglong Tang <chenglongtang@goo=
gle.com> wrote:
> >
> > Hi, Amir,
> >
> > Thanks for looking into this! To answer your questions:
> >
> > 1. Production vs. Test Suite Impact
> >
> > The immediate failure we encountered is in containerd's integration
> > test suite (TestImageVolumeCheckVolatileOption). The test explicitly
> > reads /proc/mounts and expects the exact string "volatile".
> >
> > In default production, containerd passes the legacy "volatile" string
> > to the mount syscall, which your patch correctly handles under the
> > hood. So the standard "happy path" is not broken in production.
> >
> > 2. The purpose of WithTempMount() / RemoveVolatileOption
> >
> > Containerd regularly makes temporary overlay mounts (e.g., for
> > unpacking layers). Because overlayfs rejects reusing upper/work dirs
> > from a volatile mount, containerd uses RemoveVolatileOption to strip
> > the volatile flag before these temporary mounts.
> >
> > Currently, containerd's RemoveVolatileOption does an exact string
> > match for "volatile". While it works for the default path, there is a
> > production edge case: if a user explicitly configures their container
> > runtime to use the new "fsync=3Dvolatile" option, older containerd
> > binaries will fail to strip it, and the temporary mounts will be
> > rejected by the kernel.
>
> I need to challenge this specific argument because I do not agree
> that this edge case could be considered a regression at all.
>
> An admin from the past could not have set an explicit
> "fsync=3Dvolatile" mount option.
>
> Though experiment - overlayfs adds a new mode fsync=3Doff
> which is more loose than "volatile" because "volatile" can actually
> return error on fsync in some cases.
>
> Overlayfs would also not allow to reuse workdir from such
> a mount.
>
> So would you then claim that adding the new mount option
> "fsync=3Doff" is a regression because of the edge case that an admin
> decided to explicitly add "fsync=3Doff" and RemoveVolatileOption()
> does not handle it.
>
> I don't buy it.
>
> There is a more correct way to handle this situation and it is
> documented in overlayfs.rst:
>
> "When overlay is mounted with "volatile" option, the directory
> "$workdir/work/incompat/volatile" is created.  During next mount, overlay
> checks for this directory and refuses to mount if present. This is a stro=
ng
> indicator that the user should discard upper and work directories and cre=
ate
> fresh ones. In very limited cases where the user knows that the system ha=
s
> not crashed and contents of upperdir are intact, the "volatile" directory
> can be removed."
>
> containerd unpacking layers falls under this very limited case.
> containerd can syncfs() workdir after unpack & unmount of temp
> overlayfs and remove the "incompat/volatile" directory and then
> the upperdir/workdir are are free to be remounted.
>
> >
> > Conclusion
> >
> > While containerd could theoretically patch their code to accept
> > strings.Contains() or fsync=3Dvolatile going forward, there are many
>
> Following the documentation advise would be better.
>
> > existing containerd binaries in the wild. Given that this patch breaks
> > containerd's CI tests and introduces an edge case for
> > RemoveVolatileOption, it might be safest to fix ovl_show_options in
> > the kernel to continue outputting the legacy "volatile" string to
> > strictly guarantee backwards compatibility with userspace.
> >
>
> Considering my comments above, I think we have not yet reached
> the point where the backward compat "volatile" string is called for,
> but with other reports from production workloads, we could get there.
>
> Thanks for the clear and honest explanations of the containerd situation!
> Amir.
