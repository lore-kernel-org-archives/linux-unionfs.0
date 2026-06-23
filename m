Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E911862A
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 12:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782218881; cv=pass; b=HnTstGVRHKwtjVXmJi902H1TQ9TSCUEe0nPNR5H8zUOSySWrG0vJr5OIC1OA80tl69YltBCCYqrTXczkxwuekgtX9VBoGQNP/AIAAgmRk3cLASIE2mhr0lYRLLy0DzWaF1zApoBH339ZDEKffTnr4SeyhJeYjg6B6Vs+7igKrEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782218881; c=relaxed/simple;
	bh=E5C4Tqz6BodTtvs8+I/lqj16mu6VFRhoT96qsItWl2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xsky5sjdQ339Ou72C7JVvWWNI09o93FFEFDUpLF1Znk9vE6n0krTwLlLprEM6rLgV2XwdOrpb0/YIS1a+JaIzgSlp4V6+FjxyjdgPoD/bPZn/0HaF+jqBufb+PEpKdVTSrXkW/VdSXDdYPzHtZUpZve60ZTfbRv5FmxLWQ6i72w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o8DMlvPh; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o8DMlvPh"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66077e888b2so5646139d50.3
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 05:47:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782218879; cv=none;
        d=google.com; s=arc-20240605;
        b=E0JAljHQ5ukaLexFAo1EyPJmCr8nvnyGw7HSRWE+aH8V4j8rJ4K5vKsACDHo+7ZDZY
         tV8ob4u4O+l6ybG5dvCWdRG1AlRKllkuwkPeEIzgKH/K/FEBvglcCA8oNuOx76sQTxQ9
         +bLO+lHaBkR6dgy6wHYdOnRcGP7vkIprWwtDD8ZG6cR7yVrCg/zykMid2trSmQgYPqgs
         2TfbPEfB9tm1TkSxxlxOwQqyj8qTwP+us9LKcCWrBe712Vko+3IaUyKG4JTAW1L35VAm
         EgP5IHgJX5aksFZZagam868YgJ/TWMLRYSPI64TH/XJk7Xw5fRwjvZKRVwQbnz38HNg4
         Ushw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L+koYr+BZehse5DchH3sXg8FrlCAyXqKnCwBssCQUfc=;
        fh=Kr47kHVT970QLA7mfuhFuKpMupdk+TAZzBCJd+sTRBo=;
        b=SPsRi0/JW2ab2bI+6EoQJVQFjraD28JS8m0F975aS0hrcGVVV2nLS3HISLq0VTC2/y
         PxUfDs0Bzj+8EWPG9k2FusBtJfNv78kZ5aSsiv/7v19BaTzDGadiPh/MYyIynbvcTxzp
         HhzlFE8AOhl3AocICeJwvKKClBgRzct0NpC0LFMoLBUZE2y3Up0K5ciNSM28kU4Kp3wu
         8yy8dJtNAZMmwFCtKII/q5FK9bOlgoGWauC5eUsu82JXKVYiTjoPtsMHVhn+KZSr/rFT
         8d7XJBCw7IWw1BkMwZHrHpE+y2VZRmD/Gt1SGIzI5N9WDLdCeFGOF0lDmuWBHBv5nGNv
         0dUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782218879; x=1782823679; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+koYr+BZehse5DchH3sXg8FrlCAyXqKnCwBssCQUfc=;
        b=o8DMlvPh9KwGSfHc3LtoK4aMiQys9sdhdXkX8umuzcKp87vF5eqrIdRCUiJ+2awBTC
         zLAkW5ri5Fu7CCZ41ZRNyC17IJC3mBHe66zG80asthHGGbSInnRfffDPHfuDXWU9LNvl
         YE09csxN68vqdhpXbGsFe/ZlgFrcyl1ux5cykZRq9tk7sX2ETL6Zw/DzfOsoB+kma23/
         mJ/Rykm6sU2u7mmg0O0UhpmFjBjvQl/u3d+SNmhjPuHTexbQukC0zPhHG+HJZso8zGzf
         Z+7NaDJAuJlq0RG+Q2qsRIn2L/Pbbi9iuYpN5eYu6FhbKfgdYPjwDl3GT5FownBoPvO3
         jQwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782218879; x=1782823679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L+koYr+BZehse5DchH3sXg8FrlCAyXqKnCwBssCQUfc=;
        b=Z0FuzGA0+ZLSgzPD+iA5muO1C1dffpcyTuz0gKG6UJk71X0v20G2tWmEk9QcuQCWUE
         fCaB/uji5TJk6wV99s+r0BM/bh/mSahmQG+rwWdbHa3Fks+3OF97BpU+iJeZZm0tmLx+
         +SLKiDiNf1O49suzFUIUuktMH5mPyThf50PPyjq0GIPIBtLNPZpeW1g87E5zTYwHMCDH
         ElyEGq8Y+awkBkdxUfHL8sJUMTOunL0kPZ/FjfQ7w242qKueaeXIuc+vMSVyNNCTtYY6
         Ui7XQZvqZgRQaDi5jpYaf80H2tyI0zducEUsPpBkhZ1Gnbj9PsHY906qNcwspZQAMw4s
         OR8w==
X-Forwarded-Encrypted: i=1; AHgh+RrADaYNQH8QSGptGOqNT9lVMdCrimjtyJ9RD7em8KQMOt+olDdLAiTiJ/s1/IBa5FgqMILf+R1CI+T3ZZBr@vger.kernel.org
X-Gm-Message-State: AOJu0YwDAKGPkXLhMmu0dBrEWWAemNgdXAGEYYsszEdw569A2yaHBlMO
	UbhuLPIotRcbM1JTFDDN9DPsT7w1YXw5f2uzNsKvr6/wBmG0LW5VJYJLO+YYNbD+RoRzPA3TbbU
	ZUhkelKSEvdu5RUJO+wyVTFYqkJYZCGA=
X-Gm-Gg: AfdE7ckyArXD5lKaT4ntNL0ip1dYX8ml7XAm5So3vnxqTNel0D7h8C2mPE67bbQWZrI
	M2XX/Il2HJNJGwxGLdYo7i5Hj1+k7YTj7zvOGsULkh3nGCg8IZf4M6uAItluCvUtbJbMm14MwYM
	Vvwu2QfYZKXkG7+IWSzt51mcp423yfbYIHR02dwwgfFqE9ZivuNCEo4H9wQiASssDo9X1Mxez91
	x+uWmnUJyMnwRqs6xWurxVN8moq6kMASRsKu1zSNeS1bFEuyzXq79FZxORGa3ReM1/iaJftzdvh
	92JXVqHXoVx/yy5xFSSXZrKNBhCCnQ==
X-Received: by 2002:a05:690c:4807:b0:7fd:9dbe:4d87 with SMTP id
 00721157ae682-806c49ecbc0mr22992477b3.52.1782218878885; Tue, 23 Jun 2026
 05:47:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623084337.54344-1-laoar.shao@gmail.com> <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
 <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
 <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com> <CALOAHbAKVF7bLcT_RA8xP8djkSFBXfQiw8h=jCs_-jknnqHioQ@mail.gmail.com>
 <7f9e379c-186d-41de-926d-bfc020e6c87c@linux.alibaba.com> <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com> <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
 <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com> <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
 <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com>
In-Reply-To: <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 23 Jun 2026 20:47:22 +0800
X-Gm-Features: AVVi8CcnGK5iGz5WXE67CzCn2vO8gcMXnxF3tJ56593uHz6DCT4TNd14_F2qHpE
Message-ID: <CALOAHbCkbSBVqUStUbWB=4vUUOEyB63yMsXvS_cZUZOwr-nmew@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org, 
	fuweid89@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 7:59=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
>
>
> On 2026/6/23 19:38, Yafang Shao wrote:
> > On Tue, Jun 23, 2026 at 6:25=E2=80=AFPM Gao Xiang <hsiangkao@linux.alib=
aba.com> wrote:
> >>
> >>
> >>
> >> On 2026/6/23 18:18, Yafang Shao wrote:
> >>> On Tue, Jun 23, 2026 at 6:12=E2=80=AFPM Gao Xiang <hsiangkao@linux.al=
ibaba.com> wrote:
> >>>>
> >>
> >> ...
> >>
> >>>>
> >>>> Again, I don't want such customized messy breaks userspace
> >>>> again; with that patch, container runtime needs to consider
> >>>> if `volatile` is the default which just breaks the existing
> >>>> containerd versions.
> >>>
> >>> I'll leave this debate to the overlayfs maintainers ;)
> >>
> >> On my own perspective and be responsible for common users
> >> (and as a containerd maintainer [1]),
> >
> > No wonder containerd is getting harder and harder to use ;)
>
> What do you mean, can you explain exactly?
>
> You're just adding a new way to break the existing
> applications, no? You just breaks previous shipped
> containerd.

It's your responsibility to handle the cases where "strict" is
explicitly required. Please do your homework. It is not the kernel's
fault.

>
> Add a way to change the default behavior is fine, but
> the new default behavior should be worked with the
> same functionality and compatible, but switching to
> `volatile` feature is non-compatible and what is why
> containerd dropped volatile.

It only adds a dynamically changeable config. Why do you insist it
breaks everything? Users can always change it whenever they need.

>
> I've explained the technical reasons, can you also
> show your technical argument why you cannot patch
> docker with a very little change (if you can
> livepatch the kernel) and just restart the docker
> daemon, is that hard?  -- Also, is that requirement
> common?

You'll need to restart the running services. When we applied
"volatile" with a livepatch across our large fleet of production
servers, everything worked fine without any breakage =E2=80=94 we've done o=
ur
homework.

>
> How pre-existing container runtime versions know
> their default option is not "auto", how do they add
> mount option "fsync=3Dauto"? and how do they know there
> is a new sysfs knob to work around incompatible
> behavior?  there are so many container runtime
> "docker", "containerd", "crio", how to make sure
> all these container runtime aware of the new
> default may not be "auto"?

That's why it's a dynamically changeable config.
Again, pls do your homework.

--=20
Regards
Yafang
