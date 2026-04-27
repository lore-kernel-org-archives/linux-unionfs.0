Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055833AEF57
	for <linux-unionfs@vger.kernel.org>; Mon, 27 Apr 2026 09:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280717; cv=pass; b=W0x+0nF1L3qre3/25jVH2Coov/nThSyXm4Prt1LwMZnSq8X0FD4tnht5/ZaAsX2aj0F/hzLJnV8IH9Lu+2iIaTaQemAWa9gyxrvieQ7vpkhoRc47EcC5mODdKF0n+fe71HNufYaLLUrOA8NPioVlpDiHN9LT5latsjNiRB3MSWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280717; c=relaxed/simple;
	bh=a5WlGur2x+nU1ZXEt1S7Pr3BhzTo07kXxugDtAVEEhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tCghcW+JZkorkpoo5elOxmpwwZ0gd6oNpwWdDF1adA+s+phTbmoNRPKmlFGgo+IHtPBXr0VhcEQT5URsWA9m3pw9+RC7MqU2KNazS+FUupTti8S6Vsrfcq9AQH6I04lZBjVEwbq0MAQPdj+07jUMtY6+gaXs+pFRHIWlUesyQwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FeVsCtH9; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FeVsCtH9"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ba699316b42so1226031266b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Apr 2026 02:05:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777280714; cv=none;
        d=google.com; s=arc-20240605;
        b=D+D+K7Sa04S8a7xv4zgIwSi3pSs0ohYkPxUR/tYCEW337Uw/gtSFGDVN36GuxhSi+d
         GkorWZ3OiY956rlDdI/vpn4JnlkGMIcMjaUMuVEGUj/U3CnDRao6reYLEy+iYLlH69Ty
         WZNuqwD4f58PKMtne3zOi2OUCPeF5uJS2yu2HvEHnhiEKLAUYXlqjLZomM+IhkCA8gVf
         3/KXRDwhyMR0kTRw3ELhVVYv/L9sPbIBZqSy4shZ5KDoDEPZMB4qQstVRXy6fOl+sdMA
         mnprnCH2Mn8JHPaVDiTiMgexwb2MuconibX1QHqXzWP8K8J4atN32RZpWF454PH6WHjQ
         q8tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BGupVN5az5s8pFT8H0NZ4pHuG9HKT10qjTmw5QNkxIM=;
        fh=/umFvj/OSgZq7MvC+FlqhKQjm0gjyrk/a5+JGO6bGQk=;
        b=JAUSnsz4suNG+A4zLQZ7yBhCvhOiZawq0zmOpITlPCn1fz6SppA/140E2gXCRED6J7
         fqPNd1UGtMD+r05LP01VEzARRdc71rcSEZOATQRgbtSPc2BaAXqMey4TWXNUC8mtbi+L
         iSI8gYJzU8NuHD35LwuZLviFTkLLIlsNsjeEBiwIWyo/E1tXzXPK5cqflMJOTZhQ+CrS
         4x+oNFbm12jhCvRV12ppyoMpvpwsCW5HWB1Hdo913C4+7MqEzoBxoDo1hBMyNjL3qmW1
         y3N6WsSJbcc10ol6KgPIG2NhqsB12EmUfV2o9iuQDU25NXkmectZO9bHAS4hAUal1xab
         naEA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777280714; x=1777885514; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGupVN5az5s8pFT8H0NZ4pHuG9HKT10qjTmw5QNkxIM=;
        b=FeVsCtH9PneHPhOEcOJCpacTtqhXnJHPtiJ4+PawigBG+gw6FpulourYIBqe7RbI2E
         QaBFIqQPJ+GtuyXwafgn8USJGEwOpU5XkKvFghsDHa5FV1PlkvFMesDHwbR4rGJzjVKM
         UVb/q2WRcAyFA4NShDXS9Qbcsgm4b8L90wheIVFcTIIt7quepxV5GvYIJUTgXM5s7lAf
         qkKxHJ9RU8YsMvPbFyDpfb6y6x9x6cIcgZ7KSB89hDAbe0ZYluKs/GrQEki46kHwhhNo
         +/oqHS2wFahQO5WlgIaBujyRMgbEaxxanXNdLDWiPfDqVJewL5TxJgE4hdtw5t8ulwQ2
         M04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777280714; x=1777885514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BGupVN5az5s8pFT8H0NZ4pHuG9HKT10qjTmw5QNkxIM=;
        b=a7lUEdKTiHnBnHUKx6Ilwf8d+Wx4afVDTWckas9RoheIEMy2vDIC+0wVo5Ni818jJp
         XwKsEVkodtovLLyiuzdf5VJEm/xJTBZQZS8Mz4dZ/h+7VzAe4XSWKdCD9Jv1A2osvbcu
         xcgho+cM3cc5np1eCPpGghqcJdlbZXVp/KMbDEyQp96W9PjN7oaar1bqp+wzAd9nYACe
         mG/v4fussjFrCz31H/k9H1DUqOv2Y76tp/Ka5m04u0VRlxqy24Jq4joaBkX1kkmjjegS
         xKEzkO9RZuDdlf7BOKDP9RvRT8QDn0n6vGFdJ8//obXiq5vNWpW+fRdgXw+gOuQbD/tG
         GqJA==
X-Forwarded-Encrypted: i=1; AFNElJ8rKvYF7xdUFxL2PjzIeUEirDX1CPB3oKPm8mKLcKdzCeSMVU6GsSvtmpw/EwvlKSCDJt3lNNiZ6GxQJfX0@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/A4VTQXofC8vepB4QZfBcWMITC0L9bVLJixlOKouhTmo3GNfN
	8t/9qtTglTPwTulnUBe73Zpb8zbwEjkwfbjHRcDOQWOeDggFOOsEfMD6m8P6uBexTkXkYYnFWnm
	DHAfbnTDLLw8r4s68oQ3tXYLZD0E6mP0=
X-Gm-Gg: AeBDievcNlQ23JMTL8Hb5WuGJxQIrd2DR0nXbwRcYl1MG/uDVOajV0oeliA8CfIBBGj
	aDVHYR8L8vXxMPboDm1la9hWsjs3JA7/HClKDWpF/5PVuYl6MeymeY/is59Ey0xPllDNQyiFYpX
	3BCw/pZrE7dT7KZQxkwvygMPFMiE+MwmVDjb8llTMBr6iRyEmFhPgKU5UjJKWrC1zMLbiMfZtjU
	/wzk/lMLqj3aGwY8zI26wsJsbqCqSq0XqsQugdKPZd4ZnQzXi0fYy7ymqZQrhzNPH/GmWRkkAYA
	0pHVpzsYD7ZEM7KkHVzCGkgVehFza0EjVkq1KGBeHgIcwrmGtoe0/iipo9d+DUg=
X-Received: by 2002:a17:907:97cc:b0:bac:75ae:ef3d with SMTP id
 a640c23a62f3a-bac75aefeedmr894007366b.0.1777280713694; Mon, 27 Apr 2026
 02:05:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-8-neilb@ownmail.net>
 <CAOQ4uxi8rqkbhK4=8N1ncfU1m6bjdHLbinSf=j3k0oVEaSa-wA@mail.gmail.com> <177727962988.1474915.2841674553452335690@noble.neil.brown.name>
In-Reply-To: <177727962988.1474915.2841674553452335690@noble.neil.brown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 11:05:02 +0200
X-Gm-Features: AVHnY4KY3DGiJbeLpxnNIOueb0cG8ugd69Mb3NfCiVfs_OCISzp2jPWuCU1oOMA
Message-ID: <CAOQ4uxiMUKHuGwpSkD=M4Z_QLxHn7Os9vaaWqAWd36HdfDRYuQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/19] VFS: Add LOOKUP_SHARED flag.
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 10:47=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrot=
e:
>
> On Mon, 27 Apr 2026, Amir Goldstein wrote:
> > On Mon, Apr 27, 2026 at 6:06=E2=80=AFAM NeilBrown <neilb@ownmail.net> w=
rote:
> > >
> > > From: NeilBrown <neil@brown.name>
> > >
> > > Some ->lookup handlers will need to drop and retake the parent lock, =
so
> > > they can safely use d_alloc_parallel().
> > >
> > > ->lookup can be called with the parent lock either exclusive or share=
d.
> > >
> > > A new flag, LOOKUP_SHARED, tells ->lookup how the parent is locked.
> > >
> > > This is rather ugly, but will be gone soon after we move
> > > d_alloc_parallel() out of the directory lock as ->lookup() will *alwa=
ys*
> > > called with a shared lock on the parent.
> >
> > Neil,
> >
> > Forgive me for being skeptical about the *always* part.
>
> Scepticism should always be encouraged.
>
> >
> > How long ago did we add ->iterate_shared()?
> >
> > It's true that Linus eventually got rid of ->iterate(), but we did not
> > get rid of the assumption that iterate_shared() might be upgraded
> > to exclusive lock.
> >
> > The obvious reason is that *someone* needs to do this work for
> > old filesystems, which are also hard to test and nobody wants to
> > touch them.
> >
> > I have nothing against this patch, but I think it is more realistic
> > to state that LOOKUP_SHARED is here to stay, so if you think it
> > is too ugly, maybe there is something to be done about it.
> > Personally, I do not see the ugliness though.
> >
> > Am I misjudging the situation of shared lookup wrt old filesystems?
>
> Yes.
> All filesystems must support ->lookup with a shared lock because it is
> already the case that with a simple lookup only a shared lock is provided=
.
> A filesystem *could* examine the lookup_flags and deduce if the lock is
> actually exclusive (e.g.  if LOOKUP_CREATE is set) and misbehave
> accordingly, but a vanishing small number of filesystems  (NFS and ....
> I can't think of any others) ever look at the lookup_flags and I'm
> certain none do anything so ... creative.
>
> So I'm certain that it is safe from the filesystem's perspective to alway=
s
> call with only a shared lock.  All that is needed is to change the VFS
> to only ever do that.  That means separating the lock for lookup from
> the lock for create/remove/move in directory ops, and one way to view
> the current patch set (the complete one, not just this initial set) is
> that it does exactly that.
>

I see.
I will remain skeptical, because there is always *something* with some
special filesystems - think fuse servers (not under your control) which
have grown to rely on the kernel to serialize atomic_open() on the director=
y -
but the level of skepticism is lower now ;)

I mean it would suck pretty badly if locking order would be fs_type dependa=
pt,
but honestly, I do not think we will be able to avoid that, so we need to
make sure that humans and lockdep are able to understand the different
scopes of vfs locking at least per filesystem type.

Thanks,
Amir.
