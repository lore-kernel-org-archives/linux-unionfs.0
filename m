Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86DB38B12D
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 22:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778970217; cv=pass; b=j2Z1UZl7/H8SIwl9TQSZ6MNryd/+9jOpXcBJ91iy2gdahjRCHXFVufojyapz2H0Gy00+ANFTSif6VZYXdZEADJnlKIMq1A4o50ItCLN/GsHctyV0II0fTpUz9m1L4huRfWEhRFq4e/OCvwlxb6l4i99Ni8mj4nqnzLBZy6IsyFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778970217; c=relaxed/simple;
	bh=jnomCoubi0Kg5hraE0uJr+hIdRRLn/6AvriitA7UOCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MqcL4pqRLMzjadk+iRRUsWmm0O8mG7Uk8SWkIi7RSQpOXFGNVSSetFi5Fqbn8V0WACwaI+5/50/odLgnkPAoFnmbuHWGXAft/LYj/gAvAZvgPrig2cc+RbFm4XtlPdWsZ3UEmz8NnmFiTbNgnGKJ6Qq58jiOFXavvYZIFxywVWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cDPqhqYH; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cDPqhqYH"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bd21ffaca79so248598366b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 15:23:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778970213; cv=none;
        d=google.com; s=arc-20240605;
        b=EGkYX2/xnWb10gG6f9vFODJtnabdscOKobbOjvokDGWnBh+6aNAt+BDN8YdjpHAo/x
         VBNPmEj83h6IyXPJaFCZk43E05fqz/z2XSZfmVNTuf1pdvIMs20ffhVnmmFM60+CKos2
         iG1gmMGRwxsgZ8iFzOhKBnmL5P7MOxUnWIYUGuHMocYr2NEe5g8KZ0MV0ItKnueDV37o
         Vel9/wANMknGM4bKhVcN5FDh+GC6l2PQg+E8StRweJA3toCi11h4DJRY4MBf8InBBSuL
         ASOydfZcBPduPZ/OyugY0rNRrrhqK4jBRXds0tPbgSCi8coGjIwUbnSUhqtu9Kurk/4z
         VIIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yLM8Z0Tidc2198vLO+2avncDjSechT8gAlsN2JpVXKg=;
        fh=fcyuOehT92c2XMvH00tBHIG8uuhHnW04NhlsPsdUkD8=;
        b=ewfXrnlghA4N1h08QDHGrNySvK18UxX9HTdsYgttkrYX9pfixjisKbjlpc7LygbPDO
         typSQaNilUCVy4yTpoD4XxR7c4p9b8DaGjZAGg42p6NXrXVphIJX5fj4IeAEl0qPmUD6
         Tetb2ApeYS4wVNrfUDj+Lg3grlMrpaz4m7LCXY7CTsfXQ8BchIog1eIACH7UnI2KFVYd
         vs8fDsxIUgAgkQVJwv27MI0TI6BCyZT/s5pBaa/8Gbv+uvN1IHcwXlC1teTr/mXicftt
         Qfdk8Kxrb58fLF61sKCBoEB3b24T4Ewa/zYvjjfuW2rU7DFvv5F2TyDMdGsPOXBYroM0
         nn0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778970213; x=1779575013; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLM8Z0Tidc2198vLO+2avncDjSechT8gAlsN2JpVXKg=;
        b=cDPqhqYH4sKESTeDI9J8ryDlDBnhO3c517e1VIRo0gGjVbeGX3VZkouOBIhN1TGY6B
         y5LzjUifaLOyENzIWqayykkyW1tu7Lox2w6+DRUiU8JecAfwgZrbU5cB92YLwK9sjNUg
         30ozVrJMCm6eyKW13oScPiKob3zEtyQE6+0p2DdBzOGkc+JK+xq4FOpWezGRE0iPZNL0
         3xSA4rMz2kgUcyxMTanfw8OeQasDlOfjz88ce/C19SS0wODOY1RFs1I9BYlarYZpTPhh
         40dDkJjYpmW9/rYfaFCiklo3iYMNcOY4mcao7mNCLepZt4Mv5GLWhCCdCnsI6lQEnigs
         T+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970213; x=1779575013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yLM8Z0Tidc2198vLO+2avncDjSechT8gAlsN2JpVXKg=;
        b=jKT4St8/a0nvMjex7GXKpOws7ZY8bwP7NoJP2U2jYR78TehRiSisfeHNaly+WlfPC9
         vys3O34v7AhZ7rb5fyacaCt0zoth+13erqlH3wsp1nvotdcxxQqbceZ8ziAacbQpSDdt
         QYNwRTxA0suCaz/j5+8vCj7YHBzhhrRiW0hqgUnvCnc6sGrzpCGSto90ioa26CuP/QUB
         Sf9P2nAoC6jGGs5BOToRJvUVUwP39BqpNAP+TjY50r2uCxA8rfZbbTig/tDrC2aqhRlf
         gd5syv2inxZVPtTzbnEdd83oasa85YeQ6wGShPLhKv/XTUH0Srlepsohlx2Pun6gLwGb
         9FMA==
X-Forwarded-Encrypted: i=1; AFNElJ8w2rejEBIuo1R3/fbSS0GzE2Kpl2zlRLp2ZEoaO+JFyarzPoG2pqlhcSWPdbgVBBbEqPk2TBqzH9KUNyLr@vger.kernel.org
X-Gm-Message-State: AOJu0YwVotNJQzPUO+1cJOCpZXfQCnLw/rT6IwhmhdwcaZaI2TaQZzJK
	KCGdB7r1kz5S9hMdcoMne7nJPBjXQHS4FDXoPjTTz+yEUjZp5v1Us2/chBW45HUjRSrZ8Cs5vpE
	s8/wF+T89LuZXnDTHqtwb4tI8ObR7sBaeYRke
X-Gm-Gg: Acq92OEAlFNJWs4hfDoEOdB8AMKiHf8v3/804Us7ybqUspmxcRbGjFHr35GLAOrmU3X
	47W+L9Pu8I52dXs34l94QuuI6jPQ4E2/5tWDiB2RC2j79opFaRDGlSAuvT6NYCY3a909kbrrpxZ
	osqxojMHjku228by5W+knkFa/gOGsleznCRuFoMN7CLk91UKM4dX/B0SSwlJvBXEbeqx9vpqALK
	kFK2DJtr0E2XJXUP7R0/hfqtMkj6yi5I1oNcIwhGFwlR+3unna5LUvG2LIE9SLiWPwW+Yn/5GJs
	uyZvgtoNcYQQluRvWW3cbjIK8B7OPJabhSTxyNX3fSgTTb3G3xNO
X-Received: by 2002:a17:907:9627:b0:bd3:7514:14f3 with SMTP id
 a640c23a62f3a-bd4f333f84bmr729822766b.11.1778970213014; Sat, 16 May 2026
 15:23:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-21-joannelkoong@gmail.com> <CAJnrk1a9_MLyMebfsDe_=Rcd2+TaiD87pW4fd4ve8ZBQPCfGcQ@mail.gmail.com>
In-Reply-To: <CAJnrk1a9_MLyMebfsDe_=Rcd2+TaiD87pW4fd4ve8ZBQPCfGcQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 17 May 2026 00:23:20 +0200
X-Gm-Features: AVHnY4L4P_lpJBwi_JU31I3Z_tvNOTSVMYHRFfiIYHCC91B98n4JVW7_as_g4zg
Message-ID: <CAOQ4uxiJaLtcuGNrYej6WCzTfu=fFfy4VLj7pUmfM+hHT0Z3Pw@mail.gmail.com>
Subject: Re: [PATCH v2 20/21] fuse: use passthrough getattr in setattr
 suid/sgid handling
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 3:20=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Fri, May 15, 2026 at 5:53=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > When refreshing i_mode for suid/sgid kill during setattr, use
> > passthrough getattr if the inode has that enabled.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/dir.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index b67b3b334e69..fd1b3fd86968 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -2524,7 +2524,11 @@ static int fuse_setattr(struct mnt_idmap *idmap,=
 struct dentry *entry,
> >                          * ia_mode calculation may have used stale i_mo=
de.
> >                          * Refresh and recalculate.
> >                          */
> > -                       ret =3D fuse_do_getattr(idmap, inode, NULL, fil=
e);
> > +                       if (fuse_passthrough_op(inode, FUSE_GETATTR))
> > +                               ret =3D fuse_passthrough_getattr(inode,=
 NULL,
> > +                                                              STATX_MO=
DE, 0);
> > +                       else
> > +                               ret =3D fuse_do_getattr(idmap, inode, N=
ULL, file);
>
> I left this part untouched from v1 but there was a discussion [1]
> about whether to enforce that setattr must be passed through if
> getattr is passed through [1]. I think there might be some use cases
> though where having only getattr passed through and not setattr is
> useful (eg server wants fast stat() but needs to intercept attribute
> changes for access control or policy enforcement).

Of course there is. I think I was misunderstood.

What I meant was that *specifically* for the getattr for this purpose
of killpriv, it may make sense to ask the server's mode for
calculating the setattr mode for the server.

But this is just a hunch.
I could be wrong and I have no strong feelings either way.

> I'm not sure if you
> still feel it's better to keep it simple with enforcing that
> getattr+setattr rmust always be passed through together, Amir, but if
> so I'm happy to add that in.

No need.

Thanks,
Amir.
