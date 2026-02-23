Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A495331A4B
	for <linux-unionfs@vger.kernel.org>; Mon, 23 Feb 2026 17:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771867918; cv=pass; b=B48o5LpvQgyiZQKha34tXL3DTLcMbiFEg3sCJJ/6zsxq7EiFGI6gkY5+N8jHf30q+lEhhsfEMHmY7BgDJs3ogQRT06bRXGorKbZ66hdqRiQa5Po/PxNv9w89hIQ+NwfYKZDgbIeU4XK0/erEuzsBmG7AGef6wB5XDXHf6DwYkxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771867918; c=relaxed/simple;
	bh=hK/0jeoKCkucbRZSvX1AYVctVojQdWNjxRFJpKPT85c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=grjlGxhE+g1KnfZY499G6l+kmFyHsHlCjW10e/t38CshGHoyh5bk7jlCXeH/CrLHU3ECXOfKWsVRBszIBzNIwjSZS/kLB4j9OarSJU4xmpjXVw9dc/kSem3qdbDjdAtrmt8ek+SOvfzzYuWsqBumCNo1lUxCCcKPPShzwhVmlB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=F+M8ReRS; arc=pass smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="F+M8ReRS"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-354a7b089bbso2628271a91.2
        for <linux-unionfs@vger.kernel.org>; Mon, 23 Feb 2026 09:31:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771867915; cv=none;
        d=google.com; s=arc-20240605;
        b=MkTO6L+ZwmnM5qxzUlLlkdKT/6+X9HljlI6PP/pDhWn1+izLIf9L2inu0uVJyG9n79
         pe9jwmWSttsKQhD14E/XY522aeK6zsUUF39Dw1YmuUEtvqwgOpX1qTeiFVQ+STSZQLar
         k9O02sGOAvuvQjO58pzKx2ppc7auw5+fUiCBiUHWYC/xi5kmKF0KKMN/wCXxyz8WmwD0
         Mtl9iy9RKlvXn5W1Vc4EfR/CyLPCafLQARAlShq/fFj5exUEtpk8d2KdtTvmbBryFoTN
         NiKNNFKwRFOLv3bapthmbcOMrijQpDh2cy5roXqv645kWDP3Sk85YDCDJCWveAk4cmg5
         EngA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6UKo5s8UZQoKFDeeGaREA8NHzO9NWVOgEQkt9hAvBaw=;
        fh=YSS1dKN5v1zKprRZr7dsHkyOWi3CBMJr9sPAK51T2gc=;
        b=QquKCH0AS0hj4lmlkTAm5KBembSgIjCVZowSrsbP0AfMvz2iJ1sHOP2vEAhPLWBws+
         xh1d3JhW6wYPvCi0FKjRXMybm2Mcqspvc5BPDRkqpvq6kcG5xyLiwiSmZtWXSAkIpqlQ
         QtWQrWQ1qdxIWslc1sfESq8imLcu+KtM+XGR0528oZGBIBNl265LQj8pCWUepwWmwKXv
         MzKZv/GsLiorYi7L9b1ZX4n9qYccb6apzLeQwYBBhwAA5CQrwQ27nzllkjAx3sHbQK1V
         nHnlLvaKylQH7irxigT9KoY4NbH10K8CQQLTLFLAVLkfNdhkjeuDHitDe0g6dQLlFqoT
         EBgw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1771867915; x=1772472715; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UKo5s8UZQoKFDeeGaREA8NHzO9NWVOgEQkt9hAvBaw=;
        b=F+M8ReRSjHBcODwL6YMsB62k5KM9tS8sOWzeJ5+cgWNwRgCriw3XQa/eD8Yx/Hni30
         IdB+LiB/ApJjquQB5KcxVEI5HLkLWuZ1vTpKyL0E0HUfvIQZRWdXowU9+z67g7Gwx52C
         +oyHQZzV3WLMrQboFAG7U9dC2B2apXVJrFgLqbBoeCt8vO8eZLDHjMm8iii0dsQnf5WW
         Z+IHssdjgGYFzkGRQY1XVAsJ4gq0CVWEFyPOg2QbuYKPHrO7FhEUN0jl57qhGgMjZ2bq
         zTkZ+QXwpKHtOYw10dJFzE57zltv532RD2Y3Hk+vJDyanvg3sI0G/4PpvFt2TNvnCaPd
         NKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771867915; x=1772472715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6UKo5s8UZQoKFDeeGaREA8NHzO9NWVOgEQkt9hAvBaw=;
        b=aPu7/Mpjok1Do+Kucjxfdrzfp9jzkmYjMavVW7fx605xn0Y8uPa5oSDDRSS8bFpIXm
         Al9if1txfleXmMIN8TZKypdvGE9kzlx2hJwUwKno5Aesf81FgpAvwNQaXci59m5o1Lkl
         4p1q/5tN0duMY6KhkQRclNiuxWLepyDkzv+HxihY+QQ002bip3mkXRIul83Qz3BniomI
         mg8uoVHazT/XErnk/9wklYuLIHy0q86o2bZp+OpJWrNrxHLPZq1SVsgKnTaqIkmvSSI6
         brD5JvrIYH/55GD4u1pT/qi2bN9Ad+JvTMjo+6qSP+d++7N5dbk2s/gqKWycyV4jzcFM
         SRFg==
X-Forwarded-Encrypted: i=1; AJvYcCVBLb1uU34XRbb6sgnay8gMBi/g7gIvLAoBHOENXQtNjHVWKER93wefFTIRUidBaufWeKFbGcRoMvK7F6wV@vger.kernel.org
X-Gm-Message-State: AOJu0YyvtMM6viSqGwozhab3jjhtPwZ8L3/+fDalmh8wKhEwFg0ZFZs+
	eeUOMnzhRwIeyRNnOQh51057IuDJt1vBqoP7CIswk2EySUkkDWCfDKEgGI/n0K5b4Ta+wolaXIu
	Tv3ystMpilSkmI7S1ZN5/fLiHVQJYXL4eVmWfp9CW
X-Gm-Gg: ATEYQzyBLopR48UdtW3SJMJ1EvE8B34G1uflZs5BfC43bejfepveCmrIHB5rZSuJHO7
	IEovg9V36NKM4Yq5ZIRw4khqeZCTYzs4eZMtPKrjOFsFaVSzX70P/pLQdU27e/3WaLJ1jPxWz77
	GLvT037szB57pzoUOcsIl0QnpILje5LH/pdGPcxmPQ9RzJVttEZUs2FxQJPNqyjxMavHjOEAswG
	XqbQedFm3NC94pI6mGVPAUj4TzZzG/ZxBV6aKAb0KXjNg1d4/8Rs5+p24uqyiwNK/zrkb+guYnO
	OZxQ53Y=
X-Received: by 2002:a17:90b:2543:b0:352:b674:2592 with SMTP id
 98e67ed59e1d1-358ae7c3605mr8357173a91.7.1771867914678; Mon, 23 Feb 2026
 09:31:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223011210.3853517-1-neilb@ownmail.net> <20260223011210.3853517-7-neilb@ownmail.net>
 <20260223132533.136328-1-clm@meta.com>
In-Reply-To: <20260223132533.136328-1-clm@meta.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 23 Feb 2026 12:31:40 -0500
X-Gm-Features: AaiRm52jwDH7iM8Njra-WDPg6xnZ2flvbCTBnLCHZ5MkdIrvbyo0z9crRKbktmQ
Message-ID: <CAHC9VhSVjLNeTdxHmwYsGX75Z4FOAP+26=PjVdFxpmEkTrPvxA@mail.gmail.com>
Subject: Re: [PATCH v2 06/15] selinux: Use simple_start_creating() / simple_done_creating()
To: Chris Mason <clm@meta.com>
Cc: NeilBrown <neil@brown.name>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	John Johansen <john.johansen@canonical.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 8:26=E2=80=AFAM Chris Mason <clm@meta.com> wrote:
> NeilBrown <neilb@ownmail.net> wrote:
> > From: NeilBrown <neil@brown.name>
> >
> > Instead of explicitly locking the parent and performing a lookup in
> > selinux, use simple_start_creating(), and then use
> > simple_done_creating() to unlock.
> >
>
> Hi everyone,
>
> Amir suggested I run these through, and this commit was flagged:
>
> commit bc981629767980bbaee2ca3c7348b5a648665a9d
> Author: NeilBrown <neil@brown.name>
>
> selinux: Use simple_start_creating() / simple_done_creating()
>
> Instead of explicitly locking the parent and performing a lookup in
> selinux, use simple_start_creating(), and then use
> simple_done_creating() to unlock.
>
> This extends the region that the directory is locked for, and also
> performs a lookup. The lock extension is of no real consequence.
> The lookup uses simple_lookup() and so always succeeds. Thus when
> d_make_persistent() is called the dentry will already be hashed.
> d_make_persistent() handles this case.
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Acked-by: Paul Moore <paul@paul-moore.com>
>
> > diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.=
c
> > index 3245cc531555b..7d4f90e5b12a0 100644
> > --- a/security/selinux/selinuxfs.c
> > +++ b/security/selinux/selinuxfs.c
> > @@ -1931,15 +1931,16 @@ static const struct inode_operations swapover_d=
ir_inode_operations =3D {
> >  static struct dentry *sel_make_swapover_dir(struct super_block *sb,
> >                                               unsigned long *ino)
> >  {
> > -     struct dentry *dentry =3D d_alloc_name(sb->s_root, ".swapover");
> > +     struct dentry *dentry;
> >       struct inode *inode;
> >
> > -     if (!dentry)
> > +     inode =3D sel_make_inode(sb, S_IFDIR);
> > +     if (!inode)
> >               return ERR_PTR(-ENOMEM);
> >
> > -     inode =3D sel_make_inode(sb, S_IFDIR);
> > -     if (!inode) {
> > -             dput(dentry);
> > +     dentry =3D simple_start_creating(sb->s_root, ".swapover");
> > +     if (!dentry) {
> > +             iput(inode);
> >               return ERR_PTR(-ENOMEM);
> >       }
>
> Can this cause a kernel crash when simple_start_creating() fails?
>
> The function simple_start_creating() returns ERR_PTR on failure, not
> NULL. The check `if (!dentry)` only catches NULL values. When
> simple_start_creating() fails and returns an ERR_PTR value like
> ERR_PTR(-ENOMEM), this value is non-NULL and the error check is bypassed.
>
> Execution would continue to d_make_persistent(dentry, inode), which
> attempts to lock dentry->d_lock, dereferencing the ERR_PTR value and
> causing a kernel crash.
>
> The old code used d_alloc_name() which returns NULL on error. The new
> code uses simple_start_creating() which returns ERR_PTR on error, but
> the error checking pattern wasn't updated to match.
>
> Should the check be `if (IS_ERR(dentry))` instead, and return dentry
> rather than ERR_PTR(-ENOMEM) to preserve the actual error code?

Good catch Chris, yes, please change this Neil and feel free to preserve my=
 ACK.

--=20
paul-moore.com
