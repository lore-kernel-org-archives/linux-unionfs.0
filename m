Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1587D1E49F
	for <linux-unionfs@vger.kernel.org>; Wed, 22 May 2024 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716386612; cv=none; b=fCbP6p2ATjJWx/YsPfzVrZse20s5f/NkGts5cvypwYkCjAcu/Z3MwLFnTC3lnWW9Y+MKKJ/edEBaf3eiUEPJ/o3s4ePPS4x0EpyKRCAGT6/DU60zrd6B5LEpTALZMqLeRAclWE1j6k2Tm08IhNLACjtUwrbRVAHl/ZrIYJT94eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716386612; c=relaxed/simple;
	bh=5T0PwILk0iXgSPGGKL/goCZVgD3+jw9xpQ2mSHa/nOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O5qpSgrgzhfFIFVnOaiynz5BUNCSUZvLCKGHG3a4JExFQXR4tPXW1ZYK+SkXEckaXYTkxcVh7VCvib0fnKNRfQakzEen+zuduUJBsoSu76fYI7dIx7+lpw8mOKcyW34b8Nt6FCyoI6UiIrptq9peiJ/L/tYH4j7XvkLwjDhAUS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fs+f0Zw/; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fs+f0Zw/"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-792ce7a1fa8so439023985a.1
        for <linux-unionfs@vger.kernel.org>; Wed, 22 May 2024 07:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716386610; x=1716991410; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ej1KqYc9wqYmR3j00+KR7vj95HO7AmoK53rfSO7A7vU=;
        b=fs+f0Zw/Lh+MrAFt9WqYKxwbueNHTew0iSk6Ijr7R3s9aQu6q8gz+33zHXYctUFGlD
         8Otp6NpJ0eI8IH3SxSfDyM/jp/iuBETfCNaTlMp6Omj2vFpDdy8S1uCnenUgpKHdFOUk
         f54uZJ9qoT04aHI3P01KOITFn+dwUYf8vvgX6YVQLhPqu+i1KuhNzFuJDBjQBvUpJacr
         XXoMMrKiFIPZnSjDunEIXXn2BQHl+CaN2zLSHYeHDK6ytDOHazPAde+CAObriudIMrv+
         Qo/Qb3kEg272Gx+0izfGC5PXXnLxCezt1FG/55yg6QTG3CCBcU/+qfscpk6JXvjx8eim
         6M9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716386610; x=1716991410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ej1KqYc9wqYmR3j00+KR7vj95HO7AmoK53rfSO7A7vU=;
        b=TcAZ7C/hR6nmVDo7VRK4KkRkCANe47A3ELEgzdCPIXn+1jycr+uIEse+1q/PB2lbko
         7ikzN6a/ONYJBhPwAfgRh7fvegrH4CVxt4AWdmq6GUrmu45oRBAENEOzJRL/PBzXBaK5
         8kNV7rryv7EUDJWOd8FkabXhgSkvo+H8X2+wcNew3Zc//U1zriNKr8GIC0AJtm9yk50c
         Rm5JYb5o0jsWAtUC1lKgKaZsz4t+0oVNaLbdPfHLyJLbe10Sqdy5n5m1Wd+WD3Astk0t
         CA++/0YsY2meqDmSKQgT/fKGR3ZrPWNOHsoxXvik3YHomdIMwnvbEbvPJ1HxwXYTJtnO
         Os6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU6vmnSjtCpcE2JZ5Pdl/bDTc2wxA4SoZJ71c43g+lUa06ft4hW/fgqZJoC1BVACAR3+DDImWw6JIRoP6HEyMN3dnwbI5bICkLYaAazJQ==
X-Gm-Message-State: AOJu0YwsAN75QtvSnrFL16pbn+x8Qs5Jv3/Kaarqs7v7yijw3WmcaKV9
	/7NEr/6CyCdORjbi2fDr4k1InqHxa4+0CwOLU/i5q9r1gww4gkZM7ZDLtp8rcGlUreqHy3SfnGR
	5lKE109uZOSdcjI+jNOjhk0Iyqv4=
X-Google-Smtp-Source: AGHT+IGrmwUj2TWMwdQp9ohB9sZtTwC7SLwgj0N/YGfdY42xzqw03C3HqUu8Gc+C/IxkRdvAeXRzKqQ4BwtOZNdX7NU=
X-Received: by 2002:a05:6214:33c1:b0:6a1:69ae:4d34 with SMTP id
 6a1803df08f44-6ab7f3663ccmr20967966d6.20.1716386609857; Wed, 22 May 2024
 07:03:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a89eab01-6856-49dd-ba5a-942d58d8ebe5@e-gaulue.com>
In-Reply-To: <a89eab01-6856-49dd-ba5a-942d58d8ebe5@e-gaulue.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 22 May 2024 17:03:18 +0300
Message-ID: <CAOQ4uxjmfSksa7W88B2xq719RdZGGEqvY5OQzZuOMPCmRyG8Ag@mail.gmail.com>
Subject: Re: Overlay Filesystem Documentation page
To: =?UTF-8?Q?Edouard_Gaulu=C3=A9?= <edouard@e-gaulue.com>
Cc: neilb@suse.de, miklos@szeredi.hu, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 4:21=E2=80=AFPM Edouard Gaulu=C3=A9 <edouard@e-gaul=
ue.com> wrote:
>
> Hi Neil,
>
> Here are 2 remarks regarding: https://docs.kernel.org/filesystems/overlay=
fs.html
>
>  * 1rst
>
> We have at the begining:
>
> Written by: Neil Brown Please see MAINTAINERS file for where to send ques=
tions.
>
> I tried to figure out where that MAINTAINERS file was, looking in overlay=
fs source code but without luck. I tried to google "overlayfs MAINTAINERS" =
without success. Hopefully chatGPT leads me to the right place.
>

https://github.com/torvalds/linux/blob/master/MAINTAINERS#L16875

which also lists the mailing list (now CCed)

>  * 2nd
>
> The doc states in Changes to underlying filesystems:
>
> Changes to the underlying filesystems while part of a mounted overlay fil=
esystem are not allowed. If the underlying filesystem is changed, the behav=
ior of the overlay is undefined, though it will not result in a crash or de=
adlock.
>
> Offline changes, when the overlay is not mounted, are allowed to the uppe=
r tree. Offline changes to the lower tree are only allowed if the =E2=80=9C=
metacopy=E2=80=9D, =E2=80=9Cindex=E2=80=9D, =E2=80=9Cxino=E2=80=9D and =E2=
=80=9Credirect_dir=E2=80=9D features have not been used. If the lower tree =
is modified and any of these features has been used, the behavior of the ov=
erlay is undefined, though it will not result in a crash or deadlock.
>

From here below the NFS export story is my own blurb.
I admit is it hard to understand.
I do not consider myself a very good technical writer...

> When the overlay NFS export feature is enabled, overlay filesystems behav=
ior on offline changes of the underlying lower layer is different than the =
behavior when NFS export is disabled.
>
> On every copy_up, an NFS file handle of the lower inode, along with the U=
UID of the lower filesystem, are encoded and stored in an extended attribut=
e =E2=80=9Ctrusted.overlay.origin=E2=80=9D on the upper inode.
>
> When the NFS export feature is enabled, a lookup of a merged directory, t=
hat found a lower directory at the lookup path or at the path pointed to by=
 the =E2=80=9Ctrusted.overlay.redirect=E2=80=9D extended attribute, will ve=
rify that the found lower directory file handle and lower filesystem UUID m=
atch the origin file handle that was stored at copy_up time. If a found low=
er directory does not match the stored origin, that directory will not be m=
erged with the upper directory.
>
> "Offline changes" expression is not really clear or we lack context. I di=
d share it with colleagues and some understood it as:
>
> changes made while the overlay doesn't exists (is not mounted)
> changes made while the overlay is not NFS exported (as the rest of this p=
aragraph is concerned with NFS)

It is the first one, as written: "Offline changes, *when the overlay
is not mounted*,..."

>
> Most of the people who think the first is the right solution, don't under=
stand why a change in the lower tree could have an impact on the overlay if=
 it is not mount and so doesn't exist. It will need a new mount command any=
way.

The meaning is that making changes offline to the lower layers while
the overlay is not mounted, will cause undefined behavior after mounting
the overlay with those lower layers again.

>
> According to me, it's due to xattrs that remains in upper tree if =E2=80=
=9Cmetacopy=E2=80=9D, =E2=80=9Cindex=E2=80=9D, =E2=80=9Cxino=E2=80=9D or =
=E2=80=9Credirect_dir=E2=80=9D have been in use once.

Yes, those xattrs refer to the information observed in the lower layer
during copy up.
If you, for example, delete and recreate a file/dir of the same name in low=
er
layer while overlayfs was offline, then after overlayfs is online
again, you may not
be able to access the re-created lower file/dir.

> Would it be possible to clarify?
>

Feel free to suggest a different phrasing based on your understand.

Submitting a patch to Documentation/filesystems/overlayfs.rst is the
preferred format, but if you like to propose a text here that is fine too.

Thanks,
Amir.
