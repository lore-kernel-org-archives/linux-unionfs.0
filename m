Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CFA34FF47
	for <linux-unionfs@vger.kernel.org>; Sun, 22 Feb 2026 14:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771769984; cv=pass; b=j8pJy9vjn54CXL45dlhLKmTM6QjzaUlgBXPclNCGJDzRI4FZ0qnQwwLMc2Iibh2ChimmA1im+VpHBARbl8oOiZWtDsWYBjobV7COVQf2r3GBj7mHbxCObFwKNfST48ymbr6//xb4n4r8tFTDsWS37MY9Di/EAilaoUnH4yRMmQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771769984; c=relaxed/simple;
	bh=ln+l2+kKkFDBmSOGuUA2y37XlX40B6GZOr01SweZv58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IXEBE8Kau6im+3nMUDaQHDgjRwagJFWa35f/u2WnNI/ThjcQ5/RWpUT4Z6jkqixeBWGSNEXYmGWKkSnogov4Tv9arXCeYCapOq+143TuTc+ROkOYvVXxPtM1u1FCp+VQTbE8fNbgoJ28rO9PD7V3HVe2ub6PuwKrb9Vv/jKi4PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Nx8KjheQ; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Nx8KjheQ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8230f8f27cfso1820208b3a.0
        for <linux-unionfs@vger.kernel.org>; Sun, 22 Feb 2026 06:19:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771769982; cv=none;
        d=google.com; s=arc-20240605;
        b=JgZ2QMiIw40uyERnowDfrt44LsgR7CXK7VMVlo3Ac5+jGEques8OQQmMfDuvgYrhbY
         u6Qubach2Nby3jSqwSWd9lZgVWoHSGK82wZ2VM1AFgT2URkF9ebrBt+XZQy6bSG4xc4k
         HwE8arNfi9pK6HJASchhcOA4wYCKEz/TJxMApOOxBgks9urxvqNI8I2Jw8AdTvu2maUi
         WR7TSVAX/p8RN2niMOYO5L3Pv166xKjO6p3JWOmv5BM7EKw6m6JhgMVzBsWYds24IjX4
         Np7IKGBBF7CW0JrF7l6pNWivNY//LAEWq6m0FYTnsGtSGzNOx3mOpVau3Ywv3bsdWCzY
         dO/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X8lBMrpe1LcWoNp46tVs1SnCv/oupmsi0daofTsKyx8=;
        fh=K2nngTRc4DMru60ocSGN/GqZrBZlHCaktNhhLZjUfPk=;
        b=bVQxNU/ibe67JbjgiFIu6WRHU1b3YcHffXgIHLv1FKjpGhZLpwH18N1B7gyBTGMqPx
         dyPZAXTjmJNF6HiFbRP4fHjC+4m2a8ptrVx6OE9PDfdTKdRjxrHX3h0rOvmw7QXiKDJS
         bgAoMB9+w7P9c59EZOm+ghwye3R4F4KGKvYSOfQE01FM/v69mj4MAK2tgOySbGORUa6c
         JKxzaCQYbVSf41I6QoS4NhWh9e3hMdTpC71E2IY0nCC+QkopsdZ9nYzteKT//gMNfqNA
         wuY+QWfepx2LNPXOPRb0O5sqCuLFcTMPE96DlZCfZGh2hkhhnIUPQMN++m232kDseZJj
         gzHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1771769982; x=1772374782; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8lBMrpe1LcWoNp46tVs1SnCv/oupmsi0daofTsKyx8=;
        b=Nx8KjheQqYFoKeSsWjSjDkljl7DeLxDbijMH0TCbUekr4yIocKBCavivrkgn95uFed
         XuSYjq8Pcd+5CapXKZGXMujHyPS8CM2XMsK1VFq/NEU9BlgNRr0AX30vP4yE32dv7A5Y
         Hbv2Gia3NHVN7Dbg7SLniPYX1r0AX1nZqO/QynXl0UmultKmwbPnGnBn1UVWQBCgarfe
         8XAXggaIceD/wiAeYgSlFc6fVQeagqwn9JRq9mELPGKgvBWXjAAEHwqVz4J9E4ZYYqaN
         3M/u7GK2xgYQYx/5yhpHJ3oZznFZe7PrOTMXiMph7pHCPiT63E99Qjf7j/+JE40HxrtR
         KZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771769982; x=1772374782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X8lBMrpe1LcWoNp46tVs1SnCv/oupmsi0daofTsKyx8=;
        b=CauiqS3iPRomh6zSUyx/rYJIL7vDWzpx8hT6Jq0Yju4tVfu3hgSRTKgXT9Q5lPvYBI
         P0w6T5wo9Nd46lWptc6dap0/7JL5EEzOP/kam+Mmw/cZBaA8bNBqRT/mITFgm2xugeYw
         4yP+pMPOLkKi0xyKOPHQ+jJsBcRiXf+ga54i4MLe8VouOpWbll089QhSNahUNMIieyGx
         AjhGGhlbfNdz7zRPud/hhSnhuKjWtWVVBciUtEhTQRMSzMvJ02O3UXQPmKAwICTURX5z
         FVDzorbAF8H99BL0xNhXeu/oorVoO+I0/ZD1tUOOYwe3StUTkXhvsSj3gDDUhsH4A7Jp
         0G/w==
X-Forwarded-Encrypted: i=1; AJvYcCUXucLEh8/KEsGd0hRQi/E7SOds4HuLP+eIhxI/Kj7QI9m5ghvQ5F5hv8inInU1g15z1xXRWORBAAnFA1d8@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/qfhtgwJijRfFqTfjQBNd4rwZy2L6V4vF4E0hmSO58Z1MLRlP
	Szpyobo0OkAqgEdOQcD9nB8yggMfok52PLwTHF0znsjhYxqcau665odMEW+oWeC+sOXOhCVtomR
	WWQfHSupIr9jRZp31W7aHKuGNkjCzDBi9eux3EsiD
X-Gm-Gg: AZuq6aIoaFgH4vzJGINaTfjKHjEiuwN/CofBaMO64ySDkXyd8Sj83KNaKuDMXUfPSj7
	lfLXyZDG1cxp6Gx3IOHtyOTEqMdt87vX3J/TVWpjLK6OrQ0JW61D+9ZW8GCaWrRXtmjk+CpQ+RY
	lYOIP0Nn2g1VAIn+xYwYtHN95UabRqZ4yUSorg7AyQdDpClWqdoGt+N7BqWErFPZ4MFmhboze9e
	6Fsovw/2uIsQNrnkgOGAu43CXXk3Hm96MzwlR55xvlbWv1yCm/VFDe6HgHRRvY4YNvtJlnfqroK
	t8+Gk+Y=
X-Received: by 2002:a05:6a21:6003:b0:38d:ebc4:b552 with SMTP id
 adf61e73a8af0-39545ed5054mr4712151637.27.1771769982592; Sun, 22 Feb 2026
 06:19:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204050726.177283-1-neilb@ownmail.net> <20260204050726.177283-6-neilb@ownmail.net>
 <CAHC9VhThChVk1Dk+f-KANGj7Tu7zzHCiA==taeQ+=nQaH6a7sg@mail.gmail.com> <177171292163.8396.10671162503209732019@noble.neil.brown.name>
In-Reply-To: <177171292163.8396.10671162503209732019@noble.neil.brown.name>
From: Paul Moore <paul@paul-moore.com>
Date: Sun, 22 Feb 2026 09:19:30 -0500
X-Gm-Features: AaiRm50aSxTeiNBHciBrrBXQYNf54mJgxuioR2fz7pTB6PQcKrI6Gq_TY-UauFU
Message-ID: <CAHC9VhTv+K44q7+5d17jS8h9fJY_JfQVUw5NPNvPzjkHDpqp=g@mail.gmail.com>
Subject: Re: [PATCH 05/13] selinux: Use simple_start_creating() / simple_done_creating()
To: NeilBrown <neil@brown.name>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, John Johansen <john.johansen@canonical.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, linux-kernel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 21, 2026 at 5:28=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrote=
:
> On Sat, 21 Feb 2026, Paul Moore wrote:
> > On Wed, Feb 4, 2026 at 12:08=E2=80=AFAM NeilBrown <neilb@ownmail.net> w=
rote:
> > >
> > > From: NeilBrown <neil@brown.name>
> > >
> > > Instead of explicitly locking the parent and performing a lookup in
> > > selinux, use simple_start_creating(), and then use
> > > simple_done_creating() to unlock.
> > >
> > > This extends the region that the directory is locked for, and also
> > > performs a lookup.
> > > The lock extension is of no real consequence.
> > > The lookup uses simple_lookup() and so always succeeds.  Thus when
> > > d_make_persistent() is called the dentry will already be hashed.
> > > d_make_persistent() handles this case.
> > >
> > > Signed-off-by: NeilBrown <neil@brown.name>
> > > ---
> > >  security/selinux/selinuxfs.c | 15 +++++++--------
> > >  1 file changed, 7 insertions(+), 8 deletions(-)
> >
> > Unless I'm missing something, there is no reason why I couldn't take
> > just this patch into the SELinux tree once the merge window closes,
> > yes?
>
> Yes - but ...
>
> Once this series lands (hopefully soon - I will resend after -rc1 is
> out) I have another batch which depends on the new start_creating etc
> API being used everywhere ...

Okay, thanks for letting me know.  I was curious about something like
that based on the cover letter, but the timing wasn't clear.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
