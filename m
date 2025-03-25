Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD5E1DC9A2
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742910176; cv=none; b=CTZXAXnmTG73LusivNi5ub8hpsvBNh1Kvzh1sz0EVnYg7syobDUKtt6eOsfXddM+7fqjrTvGy4T/hCH68VeK4EyZaQMxIRuBWh1FcfM3mugUej9NQxfsRyK0ssK3LEwp9iSn4wwk1Rem6aX9LekgTJ2z53potLFHEXfbQSmAq70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742910176; c=relaxed/simple;
	bh=TmhFQT6VJUJqZ51skEu9Jhpxp5sAQY124LRVZ2gBF4A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qW83MfLgvYyl36G92FAF+06JShqFEp8vVNjGoEKaInReabHLk6JGlMPcytiKw0zGC4+mHuVXK/43ZgSQsEEeSkbUE08pV/C1TI+b20xCu0Y2Qi4OrI3Mr7Iayxx+nFClnK35NvH8oJ71ijmPvV71dR33YJ/Sxsv8qruc2OPC5aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hIUPCCaI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hIUPCCaI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742910173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AeeNT6X9gAD0O2uvRcV8bqL1Oo9tE1JDreYsjTsZvR8=;
	b=hIUPCCaIfl5XEFKX1z5YI6Demj+6NKeWKz0Uw12qkuX+nujIIPRZvVTkTHo4mUs32HbQeq
	QhjlKF7gEIKdd/F8xxF2u3iqO3PfU4smAdPd0b0Ag6rNvYHRGW58ewznWXk98bEOn7Bmki
	4vz8g7dWVD+nojksbAB4oG1qWbdUZnk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-iGC0eGEpP1mpFntrgoeQBQ-1; Tue, 25 Mar 2025 09:42:52 -0400
X-MC-Unique: iGC0eGEpP1mpFntrgoeQBQ-1
X-Mimecast-MFC-AGG-ID: iGC0eGEpP1mpFntrgoeQBQ_1742910171
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-30c4cbc324bso30074261fa.1
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 06:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742910171; x=1743514971;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AeeNT6X9gAD0O2uvRcV8bqL1Oo9tE1JDreYsjTsZvR8=;
        b=qy1lJTUF4SwRstXbG0e2lnoSmqoUc78Q/608/Vk0e+PGMrBIjLbcV58GvC/Ej9niE2
         lm+gEJg1c38jYk3J6CqsAJ6hamHFiEMDDa4jy2KaihjS2Ur1280oRsRzG88tNxxisijo
         hAXR9E48GlpfW7RBDmCji6ZnZpGTnRglGVO8S5mZNMkeZmjIQy6np/BhWiogUM3jVBv2
         42EIrlwfl0hp0sQ01h6AiISH078LVbWhHp3QLRcNLYoIHBraaYL5x9Ks07Fi5Li/WFH+
         b6/US1IH1dy50wIJBSwhWNKFMBrqJku0ABYDHZPThyYfW9V74FaU7Vfm9aaM0dY8aUE7
         irJg==
X-Gm-Message-State: AOJu0YwOHbXTt27MRxrvlg3w3vJp0WFFdZh20I67msC74vgtAB/hJjvC
	dBP+KAgYm5c9razSDKBNdm7S0okTsUNdoIaak/HqaG8MNaFfc4zCGKUNHtzee5GlJcZAnIQT56A
	HqfDNIyRfvv5FCNTpmLowNc9B+nOj7itTycflwv4rPgmMdfhAIoX3E6nkPuOG76k=
X-Gm-Gg: ASbGnct9+VialgE1QRjQuFE3Xi6KYfP23VBjtR+FVPAG9ApabdptdSc8H50Wz8onE5N
	gPNwLS6ZSwJ/i5Kr+L0YgxxxEWnIPt/V0EuD9ASZRlrKcwlR9UXFq7tlruZ0f8B3eBbgh53gy1q
	ZoOTGrHdyLS/NwVMhQkZY5ebUhL2fzyPPteIP5TjdlFFc6V3tV9XAYhGbgXMAol60tbKnNI4583
	RpRkVacOkhlaCOhUx2SKXA5oDiBkmqOfNHgD38UPhyO157t/hQIIWOb4PanpNOauIg2lHYC7jop
	QVaOT+iDdtMQLIydx9/4uSXnTKvDUYhmkxSeOwNo41SmQyvsd0t6q/w=
X-Received: by 2002:a05:651c:d1:b0:30c:7a7:e841 with SMTP id 38308e7fff4ca-30d7e2bacb6mr68350421fa.34.1742910170589;
        Tue, 25 Mar 2025 06:42:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4Z9GM7jvLC8YuLUgX4+qn45UtJz50Pgn8mNqnBvFPDw++TTxPfdlOQaB1QYhvFNjzyebA+w==
X-Received: by 2002:a05:651c:d1:b0:30c:7a7:e841 with SMTP id 38308e7fff4ca-30d7e2bacb6mr68350301fa.34.1742910170123;
        Tue, 25 Mar 2025 06:42:50 -0700 (PDT)
Received: from [192.168.68.107] (c-85-226-167-233.bbcust.telenor.se. [85.226.167.233])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30d7d910f75sm18065991fa.107.2025.03.25.06.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 06:42:49 -0700 (PDT)
Message-ID: <baa1759f95062baaecb474a0a6e447fbba6a4b0e.camel@redhat.com>
Subject: Re: [PATCH v2 5/5] ovl: don't require "metacopy=on" for "verity"
From: Alexander Larsson <alexl@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Giuseppe
 Scrivano <gscrivan@redhat.com>
Date: Tue, 25 Mar 2025 14:42:48 +0100
In-Reply-To: <CAOQ4uxjZOtdMcGpXBYLO4Cxe04_w-GS1Zwy2GY2Yr+jyO+iS-w@mail.gmail.com>
References: <20250325104634.162496-1-mszeredi@redhat.com>
	 <20250325104634.162496-6-mszeredi@redhat.com>
	 <CAOQ4uxgif5FZNqp7NtP+4EqRW1W0xp+zXPFj=DDG3ztxCswv_Q@mail.gmail.com>
	 <CAOQ4uxjZOtdMcGpXBYLO4Cxe04_w-GS1Zwy2GY2Yr+jyO+iS-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-03-25 at 12:47 +0100, Amir Goldstein wrote:
> On Tue, Mar 25, 2025 at 12:33=E2=80=AFPM Amir Goldstein <amir73il@gmail.c=
om>
> wrote:
> >=20
> > On Tue, Mar 25, 2025 at 11:46=E2=80=AFAM Miklos Szeredi
> > <mszeredi@redhat.com> wrote:
> > >=20
> > > Allow the "verity" mount option to be used with "userxattr" data-
> > > only
> > > layer(s).
> > >=20
> > > Previous patches made sure that with "userxattr" metacopy only
> > > works in the
> > > lower -> data scenario.
> > >=20
> > > In this scenario the lower (metadata) layer must be secured
> > > against
> > > tampering, in which case the verity checksums contained in this
> > > layer can
> > > ensure integrity of data even in the case of an untrusted data
> > > layer.
> > >=20
> > > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > > ---
> > > =C2=A0fs/overlayfs/params.c | 11 +++--------
> > > =C2=A01 file changed, 3 insertions(+), 8 deletions(-)
> > >=20
> > > diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> > > index 54468b2b0fba..8ac0997dca13 100644
> > > --- a/fs/overlayfs/params.c
> > > +++ b/fs/overlayfs/params.c
> > > @@ -846,8 +846,8 @@ int ovl_fs_params_verify(const struct
> > > ovl_fs_context *ctx,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 config->uuid =3D OVL_UUID_NULL;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > >=20
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Resolve verity -> metacopy d=
ependency */
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (config->verity_mode && !con=
fig->metacopy) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Resolve verity -> metacopy d=
ependency (unless used
> > > with userxattr) */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (config->verity_mode && !con=
fig->metacopy && !config-
> > > >userxattr) {
> >=20
> > This is very un-intuitive to me.
> >=20
> > Why do we need to keep the dependency verity -> metacopy with
> > trusted xattrs?
> >=20
> > Anyway, I'd like an ACK from composefs guys on this change.
>=20
> What do you guys think about disallowing the relaxed
> OVL_VERITY_ON mode in case of !metacopy or in case of userxattr?
>=20
> I am not sure if it makes any sense wrt security, but if user is
> putting their
> trust on the lower layer's immutable content, it feels like this
> content
> should include the verity digests???

In the case of composefs, we will always either pass metacopy or
userxattrs, so this is moot and the patches as-is look good for
composefs.=C2=A0

However, I agree that it is a bit weird. The new behavior is that as
soon as numdatalayer > 0 we following redirects into a data-layer even
if metacopy=3D0. This is a change from the old behavior which would
previously have thrown an error here. I think this change is safe, but
once we have decided to allow it I don't see any increased risk in also
allowing verity=3Don in this case.

So, the case you're talking about is: data-only used, verity=3Don,
metacopy & userxattrs not set.=C2=A0

In this case with the new patch it would (due to numdatalayer check)
allow following redirects into a data layer. This sounds ok to me, but
it does change behavior in other ways than just the verity check (i.e.
it used to error on a redirect). Once we allow this behavior change I
don't see any reason to not also allow verifying the destination digest
(verity=3Don). This can only result in possible errors on read, and never
grant more rights.

The verity=3Drequire case is less clear.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's a benighted devious farmboy possessed of the uncanny powers of an=20
insect. She's a strong-willed blonde stripper fleeing from a Satanic=20
cult. They fight crime!=20

