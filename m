Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4EA244681;
	Wed, 27 Aug 2025 18:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756319052; cv=none; b=RYU+UAnfJmO3si/Jlw/LcZj3mW7xn6GgF3WBnPMaStNZXcfwuVCJ2+tC6F2DAieGfzat6EuSb1qJBCVBzJ1dVPfsVMBJc7d3ftJOlAfYZJiD2323JKfXs0elVHNupa1C0ygTy7hGHOwSYwVM9fyk246IhU7qbil7nHCEfIlXBGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756319052; c=relaxed/simple;
	bh=7gy0gNA+mzj7wfMZrPpyDg3I/GMiruLuyNhcAKH4xwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LQlQ4RSGkx8r0N2ApSil50RWczAcjNPxdOflzVjzwkenZk976JVvLG04t00I/dICTPanoIs7ISBiNnMOqosieLbuc7JVv/sjzqxJo7SA+8fe4qCh3ApnTNxMQav/KtNB8uRrhFIEEkyEwl4XGGjyqVHnp4h0Fs6lhrj09TxV1Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fNEtiTWp; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fNEtiTWp"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6188b6f501cso124973a12.2;
        Wed, 27 Aug 2025 11:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756319049; x=1756923849; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a3hRzazaA/3IwpGGafXhW6Ceja+ayCWMQc3/NmPm1MY=;
        b=fNEtiTWptlWQbNHgUOtGxLUP5SmuS2uXyNesDEyYZtFuNZzNZ3F7tBQ0bI4yF2AXlE
         pq0/0m7Dwvd8PtF3kcsz1+YGMnhfm5UdxhH8qqNYh96qslgX/Jz1ZcM7VIF6eTALPVP3
         llNzo0M8SS2rQf1gozcL4ww1t2GvYYFTNufrdmM7lvD4Fw91M8BdJipBQInABt/L3mum
         4+dIprOujRRlvM69eROCIF2lDBM1o+WyowvQV/Oo8DTkXn54qOqeisLsKYrTXXqeqr6R
         GrDIR+eDCk+iqVhdOUOKHGLY+MpyMVn4+pDEF4ZXdmbOCZ1FSFNLSkTf57PUQSC2VHqb
         vj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756319049; x=1756923849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a3hRzazaA/3IwpGGafXhW6Ceja+ayCWMQc3/NmPm1MY=;
        b=rR08bpm4zwThlvqA5ajwOEef4IqxXv/ZxeijdunP+UGUaT6K1V5hkqRendcOxAlqIy
         cKUFKdqxjAN9htFHFxaozi8C3RqApht+O26VSzekeVbkwMl2lVsWAqmt+LFZ/n85En3H
         2LEdz6zl+TDm6idflkpTo44/4pLy+O5GP2R/qxt3zDbyfOuAWuwTA7bf6DRsAvOENCMM
         rDz8uHkKuurFiQixfq3sJ9Mgb7OV5gz4VTLtS9N3PsdS3IuX8Z4LOhlCzjjTVZJ8Y+Vv
         nLEvLkFQgSi/jUV9C8peiLUtM/9RUSSci06MA1GKzoNEunJU4FUlO0NkEZw/7LRrluV3
         XZQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUFBNYjjeiWDj1bC/vwWU6ILcM32Mc6w/x0u6v0nVGVy/XO4he6cshbVS5D4m/Qttcevex+LzUhbMICx5KQA==@vger.kernel.org, AJvYcCWgx2+7nBhFZuQix7Hh/ia2IxUYj9TXxNuUxkCI6FMapNnC/LWxfiAdzPvexYWtg3B0nDXsu2cyAGDTj+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqSi2Y1X5gkFcH9J30VDjR1nAA8Vz6ygbsaPuDY6NOXhnAjSTO
	BEeKaNz/GOdB5cCJarAQzuVrPJHxowJv6GGbZR5evfENS5JqjhH+mH1ibakRpSQoV6NNzdD2ZJV
	txg5DF362FJO16eej+NLmLKKNTpyzrww=
X-Gm-Gg: ASbGncsfroXQuvs2PqCobM5deS6qH2N0J/fqICshjtXHznmvCXpobNzpYskaN5HSv0h
	AKzMoGO+qaJOVkLPE0AOLez7n277yZ054sHxv6pP8K0nTCsDy1jnX2KKD5Htx92FllqdNxD4ECC
	2aeSbn7iRw6KNZ7b5EZd3f+0aSFY9VaSltbR41rJiqN9wweXg99IoBr9MbFKJf/JpqOYIU6VVbS
	Ga+Ouc=
X-Google-Smtp-Source: AGHT+IGRxnnoTkR3Urh1MHCwEgVfEak54J9SrgMyGn3h1Lw9aldmPv4xZlOAb1AYws9YrP071P0ZCwed71+o0nSEX/U=
X-Received: by 2002:a05:6402:13d0:b0:61c:35c0:87ee with SMTP id
 4fb4d7f45d1cf-61c35c091b0mr13958688a12.7.1756319049362; Wed, 27 Aug 2025
 11:24:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxhEzxvgpJ=_a++xdGAptsywc4gLmnJXBA7ipFmM+qHR3g@mail.gmail.com>
 <175555294028.2234665.14790599995742040769@noble.neil.brown.name>
In-Reply-To: <175555294028.2234665.14790599995742040769@noble.neil.brown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 27 Aug 2025 20:23:58 +0200
X-Gm-Features: Ac12FXzAhFFnU9aUYuMSbe3wnN0PZmHZGCC9egvSY6RS5FmHjr8JPeJrGlNE0ug
Message-ID: <CAOQ4uxh_yrq76Rq9RoykGdANZNBWc16UgbSBRjDtXKeLdA7-3Q@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink
To: NeilBrown <neil@brown.name>, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: syzbot <syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com>, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 11:35=E2=80=AFPM NeilBrown <neil@brown.name> wrote:
>
> On Mon, 18 Aug 2025, Amir Goldstein wrote:
> > On Mon, Aug 18, 2025 at 2:34=E2=80=AFAM NeilBrown <neil@brown.name> wro=
te:
> > >
> > > On Mon, 18 Aug 2025, Amir Goldstein wrote:
> > > > Neil,
> > > >
> > > > I will have a look tomorrow.
> > > > If you have ideas I am open to hear them.
> > > > The repro is mounting overlayfs all over each other in concurrent t=
hreads
> > > > and one of the rmdir of "work" dir triggers this assertion
> > >
> > > My guess is that by dropping and retaking the lock, we open the
> > > possibility of a race so that by the time vfs_unlink() is called the
> > > dentry has already been unlinked.  In that case it would be unhashed.
> > > So after retaking the lock we need to check d_unhashed() as well as
> > > ->d_parent.
> > >
> > > So something like
> > > --- a/fs/overlayfs/util.c
> > > +++ b/fs/overlayfs/util.c
> > > @@ -1552,7 +1552,8 @@ void ovl_copyattr(struct inode *inode)
> > >  int ovl_parent_lock(struct dentry *parent, struct dentry *child)
> > >  {
> > >         inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
> > > -       if (!child || child->d_parent =3D=3D parent)
> > > +       if (!child ||
> > > +           (!d_unhashed(child) && child->d_parent =3D=3D parent))
> > >                 return 0;
> > >
> > >         inode_unlock(parent->d_inode);
> > >
> > >
> > > NeilBrown
> > >
> >
> > Nice!
> > I pushed this commit to ovl-fixes:
> >
> > commit c56976d86e11afcd6b23633395a7f2e6e920e42d (HEAD -> ovl-fixes)
> > Author: Amir Goldstein <amir73il@gmail.com>
> > Date:   Mon Aug 18 11:23:55 2025 +0200
> >
> >     ovl: fix possible double unlink
> >
> >     commit 9d23967b18c6 ("ovl: simplify an error path in
> >     ovl_copy_up_workdir()") introduced the helper ovl_cleanup_unlocked(=
),
> >     which is later used in several following patches to re-acquire the =
parent
> >     inode lock and unlink a dentry that was earlier found using lookup.
> >     This helper was eventually renamed to ovl_cleanup().
> >
> >     The helper ovl_parent_lock() is used to re-acquire the parent inode=
 lock.
> >     After acquiring the parent inode lock, the helper verifies that the
> >     dentry has not since been moved to another parent, but it failed to
> >     verify that the dentry wasn't unlinked from the parent.
> >
> >     This means that now every call to ovl_cleanup() could potentially
> >     race with another thread, unlinking the dentry to be cleaned up
> >     underneath overlayfs and trigger a vfs assertion.
> >
> >     Reported-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com
> >     Tested-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com
> >     Fixes: 9d23967b18c6 ("ovl: simplify an error path in ovl_copy_up_wo=
rkdir()")
> >     Suggested-by: NeilBrown <neil@brown.name>
> >     Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > Neil,
> >
> > Please review my commit message.
> > If you want me to assign you ownership please sign off on this commit m=
essage.
>
> Looks good to me.  No changes needed.

We are having some problems with this fix colliding with a new ovl feature =
[1].

Let's try to test this revised fix:

#syz test: https://github.com/amir73il/linux ovl_casefold

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/CAOQ4uxj551a7cvjpcYEyTLtsEXw9OxHt=
Tc-VSm170J5pWtwoUQ@mail.gmail.com/
