Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625C1248F62
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 23:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779148052; cv=pass; b=S/1Sef9cD57lqJi8AydSQl41+tThQlequMYi8aWZ1cL0ETTPPBjgAb9Nl1iWFXQ0V+uUnMvuHtGIa295bLfOlzyOOTsuxX8JWeGa4Wo5/i8xetB2QO3FXb6GBDHKQx7McVwiGL2anvM1UCsh5pF1+TByahCQaqw5FQqx2dxeCGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779148052; c=relaxed/simple;
	bh=7JRt76FeYfU75XMfqsMxTCMGeOaC7FKxmLHQrRwmOPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YvBqDihq0quHY0rq2R/Qfvr/voTf0+gXa+osJHPZVOddCEhIGXupAnWnrglXwxqmPznkh4LKYXowDYTicrqTBUPoc8UEs6To6N5zhW+RmNrDIVK20Kh8dVrJEddMoloaqa7sd0ppxlBNf7eSkcMqhxYZq8EmdpSYVQHCPxGYTYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cPr4BO4B; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cPr4BO4B"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43d7e23defbso1594681f8f.0
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 16:47:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779148049; cv=none;
        d=google.com; s=arc-20240605;
        b=lu6syPPRqPG4Xn8QivAkd2hOO6VjQpxaL045s5rotHaHHxT3Kdbjgb/nRtJtAMvrod
         yMHv1+8b9vFid8wgg9RG4yc54tXy3kHaUK0ZVzxJFqBSeskh8ozyuMRvURE5j0e6TknU
         9Lg+DH5XDepkptl1OubQBMVJtSmId0Qjpek0GREYGBnDNDGLs5KIF5ZsAUP28hC8rIPb
         cezxn3jZ6nj+nfnQz4Dt34vEfyPqrrvQofjiOgXUcXKBk9RkxH3Y1dacgMCZCZxeBum4
         JzoFoiniM1CQQtuQ5elHFYJ+O7ofNvG2Ap7sIKRGCqJtTRqTRImgcf+QT5du6cVm+Htf
         y8ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0VSSyTI2tug1r63sRPGJdbXMez/ik64fwDp9DACoM0A=;
        fh=RoIa1vGhHNEBBbsBrsueawKhwVF8jOouMHMHTnsfDxM=;
        b=Px5dSMC2jac6l53wNH7CXzzKWW8bR+cySS7yp6nLIB2aC5Z1kOB63uwtdsAAQElJ8S
         s7VdFwx8nZbTQy3baGOnBiHW3s2oHsHKcgtzy2Gm9zFz+FtoFREX85pGNsjnh8kysmUk
         D7pRDXc35H2XT5ymvFRb2+Go65wvYfVz0H8P2zwABk/lhQR+yhMi536MspfmmihyxdVW
         NJMt6gomNoR0IGnvR4yo5Yu0u8m0DjRweBdkJbwr6UIPPSkX/NSB8PADPrDGXh0AbEG7
         CU6VGNtS7CTREGPmivYmo+ZTCN8TFB6vGgK7Ax0yMeu30TaDi8Mp9KZBzzjBsZDBkhba
         XKyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779148049; x=1779752849; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VSSyTI2tug1r63sRPGJdbXMez/ik64fwDp9DACoM0A=;
        b=cPr4BO4B3/Us40u9oNG8cjZKVIKUSCYSaIB1g3I1lck4hER3zMeoWqYeVc6V0XR2mm
         nIIFG6n0WYc+jXVt0g2UCNjx+od4P9UDL0K8a1nOQ5IRxlz6zgVENMPUyE0I00bj8/kd
         hBWnA7NEMzRC+ZM2cf1YY8ZrRTzmU3pvPxMoYK8V/tpRwCEapGV5K1DABci4S648v4X5
         8PKK1NvgMi9Uri3VODELnV5On6pCJuqkt1UuZgN4ahCaIpOkmI+S3xaOKRCgP3284ihI
         AyFgkqeQPdBL+8yvDEjJNnFkIhna879aU0mrqUHRpPUl7j7VskK9s0vMoBaDLatXbXwN
         py6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779148049; x=1779752849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0VSSyTI2tug1r63sRPGJdbXMez/ik64fwDp9DACoM0A=;
        b=pKG1Oan+YqdNlkrElWraCfhCHJVyo3I/PSwrheoWtYyELGBdlPfgp2FOZJiC4mekUe
         lM4XASQ/0fca8CD15ROvlMZ46q9qCyWdzfLIPm2NdMifmX8NmRC2bdiMkO7/o8/TcBTg
         rZ8JRWcsBk90Dza7N9NqtdYteGseV9MLy9A5oOBf0QQc33JqRgNi3r34Q67T4kydnmRI
         2P8fGdbvYHURwPGkBDPbGy5qnZE+hBO9imbpkH5YXmbk1KFYubRr65lFZlA866iG2KxZ
         rhKaA3hxW/eV5NzMx3hf/LWiInalIfLTYGmlb3/pDmGiBrZj2iN33kkjUQbKYxnNqVoj
         sPKw==
X-Forwarded-Encrypted: i=1; AFNElJ+IF1s2E677MR+9gu0WW2PKlhmQLFpL2arpr6kvaZsYV0JKHe010Z/xPM5wvlQV8zAu8aEnG6Iq/43oIg9l@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ851EjL0ctcM9sxpYHQ2sPLWVCTbncqKnWC8GGWj6p0u+Yc2m
	wQN0iYi+EpVZdThF/p8ztavaGB7EMWw7XYxBKIqlwvScUP8Xou+16+sKtvyAXjfMamHjHTQJ4Qk
	TSpG9Tr7Kopv6G7YH3/XFyv8AtUWwzNL8NS1x2ag=
X-Gm-Gg: Acq92OFN+L/vFg/wFC+LVivOaKPVkzoTf2vijTa9AP5J1Ln5CIUNu0Tf1ep03xn2dTZ
	qeCx46k+hmgG2VfemPbfJa6ihC6xvRRqTuLNhoR99ERtRB2yMiAsa15KzCaTXjbk+6CTwTGO4py
	NydzHWtYvYu+TsIiq0VkfPLJeK8qsoYZ1jS6ECW4tGUM2XdgcJ99dSmSa01OgSsUIkD2cR0aUL5
	ioQ+q4EfzZilv76jEgES+1o4wl+DaNbhxfpamHhpr3K0a1E7Tlmm7TS1dZUSPNpT+AphOr3Q1IT
	XGumsw==
X-Received: by 2002:a5d:5d82:0:b0:439:c299:4d8f with SMTP id
 ffacd0b85a97d-45e5c5cbe4bmr26543378f8f.17.1779148048602; Mon, 18 May 2026
 16:47:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-20-joannelkoong@gmail.com> <CAJnrk1bm=QOmY9MNZf5rbi-aTLaYetJ2Ziu7A5q9m4MMy5-Y7A@mail.gmail.com>
 <CAOQ4uxgfEwhy+YRbZ2H6=Rj4b7d=R-DhZVd+_28MA-9VAd-C5g@mail.gmail.com>
In-Reply-To: <CAOQ4uxgfEwhy+YRbZ2H6=Rj4b7d=R-DhZVd+_28MA-9VAd-C5g@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 May 2026 16:47:16 -0700
X-Gm-Features: AVHnY4KcV6afCDxl4fkWuJFDwIiz__bxO9eLHea2g--HiDIodYXuy5AM5fR5xQ4
Message-ID: <CAJnrk1bF9jFmqBtY_PgkA3x3muossApur4LpDo=6KFsA6vY4YQ@mail.gmail.com>
Subject: Re: [PATCH v2 19/21] fuse: add passthrough setattr
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 4:03=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Sat, May 16, 2026 at 3:04=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Fri, May 15, 2026 at 5:53=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > Add passthrough setattr which sets attributes directly on the backing
> > > inode through backing_inode_setattr() instead of sending FUSE_SETATTR=
 to
> > > the server.
> > >
> > > Passthrough setattr is checked before the
> > > handle_killpriv/handle_killpriv_v2 suid/sgid stripping because the
> > > stripping is handled natively by notify_change() on the backing inode=
.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  fs/fuse/dir.c             |  3 +++
> > >  fs/fuse/fuse_i.h          |  3 ++-
> > >  fs/fuse/passthrough.c     | 28 ++++++++++++++++++++++++++++
> > >  include/uapi/linux/fuse.h |  1 +
> > >  4 files changed, 34 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > > index 4c7e3e1604af..b67b3b334e69 100644
> > > --- a/fs/fuse/dir.c
> > > +++ b/fs/fuse/dir.c
> > > @@ -2506,6 +2506,9 @@ static int fuse_setattr(struct mnt_idmap *idmap=
, struct dentry *entry,
> > >         if (!fuse_allow_current_process(get_fuse_conn(inode)))
> > >                 return -EACCES;
> > >
> > > +       if (fuse_passthrough_op(inode, FUSE_SETATTR))
> > > +               return fuse_passthrough_setattr(entry, attr);
> >
> > In the v1 discussion [1], there was a suggestion about gating
> > FUSE_PASSTHROUGH_INO on FUSE_HANDLE_KILLPRIV_V2 to avoid the
> > non-atomic killpriv path, but I think we were only encountering the
> > non-atomic killpriv path because I was calling
> > fuse_passthrough_setattr() in the wrong place. I think we can avoid
> > this altogether by just having the backing filesystem handle all of
> > the suid/sgid stripping atomically through its own notify_change()
> > path, which will let us skip all the fuse killpriv handling logic in
> > this function.
>
> I think it still matters, but to the only-passthrough-GETATTR case
> and I am still in favor of making this change.
> My point was why have the discussion whether getattr
> for the purpose of killpriv should be passthrough or not (next patch)?
> Why not drop the next patch instead because it will become moot.
>
> If FUSE_PASSTHROUGH_INO requires FUSE_HANDLE_KILLPRIV_V2
> it means that FUSE kernel is never trying to play games removing privs
> itself, not with passthrough and not without passthrough.
>
> Quoting your comment on next patch
> "I think there might be some use cases
> though where having only getattr passed through and not setattr is
> useful (eg server wants fast stat() but needs to intercept attribute
> changes for access control or policy enforcement)."
>
> Valid use case, but in this valid use case, said server may reject/allow
> attribute changes, but eventually if it allows them it will likely apply
> them to the very file which was set as backing inode, so essentially
> FUSE_HANDLE_KILLPRIV_V2 is the natural choice for a
> FUSE_PASSTHROUGH_INO server, even when it wants to introspect
> setattr.
>
> I think the same is true for ATOMIC_O_TRUNC.
> Either backing fs deals with O_TRUNC or server deals with O_TRUNC.
>
> But this is my opinion - I am open to hearing other opinions.

I was thinking from the user perspective, it'd be nicer to not couple
things unless it was absolutely necessary, especially since
passthrough is a per-inode/per-file attribute whereas KILLPRIV_V2 is a
global server configuration (eg server might want passthrough on just
a few files without taking on killpriv responsibility for the whole
filesystem).

But I think everything you wrote makes sense and I don't think
handling the stripping stuff is too burdensome to ask of the server.

For v3, I'll make the change to require FUSE_KILLPRIV_V2 for
FUSE_PASSTHROUGH_INO.

Thanks,
Joanne

>
> Thanks,
> Amir.
