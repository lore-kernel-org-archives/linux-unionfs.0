Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214AB1FF7C7
	for <linux-unionfs@vger.kernel.org>; Tue,  7 Apr 2026 20:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775593315; cv=pass; b=WbhInOG6kF5u3nPTFnf46FoYysrtYyD4fgD9rNHU7tTQoNvk3EIMtDTCPp4pifar+7c+vOzQvSvLOM5i7xg3VIIODE7X/mFTlHBZJ36LG955Vh6QMD4vys4khLFQRduyBqcdPj3MrQAUQ+PBbNI2UgmJoevWc8IbA7Gyu5edpnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775593315; c=relaxed/simple;
	bh=s8r+Vr1ig1OhurHXWjJkYiIRQ8nvrWmPw/5iPQbFVX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RClwzeu5Dj+J/zkrh6UQtbs4y9X5lKFMEyCXqsXvXk4BAPIVM11n9vhxzszAOT7yPj/Z9zJhDFwYOC4Kp0RJBTTLE3kEjqCXVhKoScL6wQGt+7w2O/VAGEHdAQpCrPBpEwvBcQ0rZ/YdqVsI9H/YA6A2yuhR1JukkiXjMXCvk1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=IC2Mf/76; arc=pass smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="IC2Mf/76"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82cf976ecacso2204408b3a.1
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Apr 2026 13:21:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775593312; cv=none;
        d=google.com; s=arc-20240605;
        b=LkmoTegbHHAy0DCUHyOKd503BlybupW3lOZXd1yfJH+qjDEpMZMtogsNJuE7Pj0JUV
         TTdT0vzO8/vns+m24ExH+RmNmFUM/ZO47T11OY7H2gMX8+WTPLa1UvQgJDEVqxjEwwZb
         eFgNibAntcqDa6mKsiKzrqE1+UKRprLIIg66LTowJeFWgI9nSXRsDhBllKlUAGoFvu0p
         ohg14ZZxJKmivc4rnos+ydK2D2+bb8W6nsxhRoZ3B+WNXpfeiUA4D7XQ8KITMNMew7BC
         ayiKpv2qtCTLnSaTIaGCnIb0m/Ct85Q1AyVKI8nJfKQ4EYLSNRh0roQtZcFalRGZatV9
         mZxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/8nRFvW3dvzP0f1HI4A52To34cw9HB6EK5c+K6burZQ=;
        fh=TDOHnfqqrMMOQYkrDu588x+w3rMst0bgZ2JE9yG7mcY=;
        b=W6Q6GAKulBV6KXt6UO/AV/2Is+TUNBcWWAvniMcBcl5qeqoUv3kRixKtFxpAHBAw3/
         CvZCvsSG0AhvcFifKGujj/6uySS7074lmwydtYCqMInUrcn9h/+6daFPqIfzCnU/6iLV
         qXTisqEolT6eTBD5tj+qjNZJGKpfMB06PD7AVkTyx74vieESuvbwhyEI64ILHhBmnZTv
         UHuLj0MrHVt0MRP4nQ/tl+GzsB2zlsXCS7pSENdw9EPRZCd0gd/gyoGjYGaL0+mnUF7q
         T2x94BBL4gNT4e6/3dcbbGdK3COP03H+fYQcdK+edtakVwv7GFeO+WW4F+7qTo2Q0f0W
         IPlQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1775593312; x=1776198112; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8nRFvW3dvzP0f1HI4A52To34cw9HB6EK5c+K6burZQ=;
        b=IC2Mf/76v9d/4+Vh6KzdO1wOwI2ty3/6KLd9aw31Jtecua/uQWbW5+nbP4siULJXMu
         6WeZ1BfHZ68bJ22X9VtLypqRXjl5TwOS05KNkt2SbxiZchp30K2/GorVjvcNyKmbIPU9
         nnnIuWJeqVhuZJmechP9u8OQX238BxxuBGR8k+bJosBBkwvg1eOOAIWdz02ujgKD2EnO
         QXSsuX0SyQ2T+plZugFMZaXTvgf8v3+ULApDpbgmCr/IcrTr3eslMgmePJRq0n+iZO0c
         pqfSpiQEmQlmb0/EhCC8SEAUleZLDhRSmcB0Exsg60oNRTQyjVLuIEgm4TsxM8845Nuf
         ccvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775593312; x=1776198112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/8nRFvW3dvzP0f1HI4A52To34cw9HB6EK5c+K6burZQ=;
        b=G3BYHcxLEzaXwqajmP2jLYjxK4l4QpN55EIps7dVqBhTLUPZFBsCSjRkhdJEqpQ534
         4y4LvjEbWnojYlNICLxkyHLRiRawDy3UsOQAuAp22AD/IdIz9E5haAdso8UTlR2IxW8d
         POXLv5fwoK6Fks2aV9qUMhHIlFRHeLgr6q7jGkfztpgXjkA1Zq/9DN/UosSnBz2ZwgN/
         4h72XTrY2xXqx1Tv2likvMnGHdETg25k4bgMJiqbr+fQnggZIzKuyI5mAcxrr9JNW1+Q
         bYK6uihbuaQ0sEjAuwZdnym4gkYmvDg7/mqIJ/cFin23gYBlMT9EXOMlz19dkW9G/XVp
         b00A==
X-Forwarded-Encrypted: i=1; AJvYcCWku51nz57VnbVbvtVF3mOCBV8cSDqODNh1zWFWouQmCUQaQv/hE3MGpjMHxjD26JoQ6ixhHHNC9qCHnimV@vger.kernel.org
X-Gm-Message-State: AOJu0YyKSEBq8Q0DjrC6CBDZhytykikr2A9g0LJoWcNqbo8mevOTR0Q/
	Bthcggmxg+1dx5oMk/IWonR6MtvKhdkvwsL89J4tPcKfyBGQ2chBLlwdgPF6N/wFrR8CMfM21f+
	q/7WNG88UFOjBktNdC+4g9zYVfl90iKnc4KBrekWi
X-Gm-Gg: AeBDieuNB26eOwR5H8AlI3fa0VypH3soQ/TZU4aG5dR7cHjys7md0gqbxlyROp7GVAS
	3cqdDn5MIQa73SBAtwAahyRPyym+PKMR4JS7FYEKYOm8zrfAr2blnrWHH//n1s4kAahrYfMPiWe
	4wubaaUc7OUlyOHacVIMc2D77PAeWRnnPClcwmHBSedcIQZwO//ojXiowB8XWyx+MznOWs+86UJ
	QrWmCCKGa1NbNph6hiMaxc/wpkvSg3Sfahakp1ysCf4eMqSM5l/r9D1KcqZ2zbOseZQaTx9VvJe
	93H9zwxqrbNIpPxtCg==
X-Received: by 2002:a05:6a00:1a89:b0:81f:4a36:1c7c with SMTP id
 d2e1a72fcca58-82d0da74ce9mr18411507b3a.23.1775593312517; Tue, 07 Apr 2026
 13:21:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403030848.731867-5-paul@paul-moore.com> <20260403030848.731867-8-paul@paul-moore.com>
 <CAEjxPJ4nqeuPhve3Fe-tFuNW9R5grnWwfYJv7q2cRu+UPQ5c4A@mail.gmail.com>
 <CAHC9VhQnA38-9wDeVmOMxAFPHnd9y6x5LXtD3cSquGiL_MDDpA@mail.gmail.com> <CAEjxPJ62=0v9QYJ6s0DrwRp4WZna8f9wnuM_DUUNrcz2dd_kog@mail.gmail.com>
In-Reply-To: <CAEjxPJ62=0v9QYJ6s0DrwRp4WZna8f9wnuM_DUUNrcz2dd_kog@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 7 Apr 2026 16:21:40 -0400
X-Gm-Features: AQROBzC_mkg1V6Olu64dm2ucorBxgS86oz5XW-KOWVbdzobSFYHPihrj_73P3oU
Message-ID: <CAHC9VhQ5PH99EQBuYq4c7Jf82UXiDfC7qzM2kvnZuyH6yFPL_Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] selinux: fix overlayfs mmap() and mprotect()
 access checks
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <xiang@kernel.org>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 3:20=E2=80=AFPM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
> On Tue, Apr 7, 2026 at 10:35=E2=80=AFAM Paul Moore <paul@paul-moore.com> =
wrote:
> > On Tue, Apr 7, 2026 at 8:14=E2=80=AFAM Stephen Smalley
> > <stephen.smalley.work@gmail.com> wrote:
> > > On Thu, Apr 2, 2026 at 11:09=E2=80=AFPM Paul Moore <paul@paul-moore.c=
om> wrote:
> > > >
> > > > The existing SELinux security model for overlayfs is to allow acces=
s if
> > > > the current task is able to access the top level file (the "user" f=
ile)
> > > > and the mounter's credentials are sufficient to access the lower
> > > > level file (the "backing" file).  Unfortunately, the current code d=
oes
> > > > not properly enforce these access controls for both mmap() and mpro=
tect()
> > > > operations on overlayfs filesystems.
> > > >
> > > > This patch makes use of the newly created security_mmap_backing_fil=
e()
> > > > LSM hook to provide the missing backing file enforcement for mmap()
> > > > operations, and leverages the backing file API and new LSM blob to
> > > > provide the necessary information to properly enforce the mprotect(=
)
> > > > access controls.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > >
> > > Do you have tests for these changes showing the before and after (i.e=
.
> > > failing without your patches, passing with them)? I tried running an
> > > earlier set from Ondrej but they failed.
> >
> > A few months ago I sent you and Ondrej some feedback on those early
> > tests from Ondrej, but yes, I also had problems with Ondrej's tests.
> > I've been using a hacked up combination of the existing tests, some of
> > Ondrej's additions, and an additional debug/test patch to ensure the
> > labeling is correct.  It's far from ideal, but I didn't invest time in
> > test development as I assumed Ondrej would continue his efforts there
> > (unfortunately it doesn't appear that he has?), and I wanted to focus
> > on getting a solution as soon as possible for obvious reasons.
>
> Ok, I'm happy to look at even unpolished tests - just want something I
> can use to exercise the before and after states.

Hopefully Ondrej can provide an updated patch.

--=20
paul-moore.com
