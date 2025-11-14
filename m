Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7E7306B0D
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 12:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763122060; cv=none; b=etLobRZyTRz6dl38liMTohS8N2NTCKOTiUKttudI3ERMtA0iaQ/68EOeyGMDv+9vRwvwI0O+tZGpkYPJ96ys6lk8cbKKqKSOI3J3SrCBxkB/aQRIJW6R/Gh2rVd2huInBcXREpzWiuUK3h090FoVTneBUTtvn8xepl2XTwBkYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763122060; c=relaxed/simple;
	bh=nS8fwHEQj4VeU7JYF+1Vur6CmNLUaf0gsfVJCcbwq0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fOPK1r0lVjZzDe1V4TqcSvYBqxDSKam6KYSwli+615M6doW0CCamq3NtC8BHJZDo7GCC3ueDWbXPmacm1VGIRtVJVXyUYWsUeN/Gk8tvFegKHE3J9JVWijpHOSLDAgQ/TKqr1Y2LY8GTGfx2cLpFr3gJTNuaehx+cYGairsKzCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eBh9ztrX; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eBh9ztrX"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-641677916b5so3474278a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 04:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763122057; x=1763726857; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7c2Or+t9SJ4JcJ4QHM6wwh2YCSGgVhmzcFUnOogJw4=;
        b=eBh9ztrXrgyTOFo/9pfsoB5YEPHa0/IOKwy8HLFxx3/VfX7gpfrtM9Bv0J2Ar0MmUf
         UUlt8YHdDBZnn0r2qGER3sqOqsQeZSQbyS/vNO1JVz0rTjcaamqDeFz6AS1BphYqOOOb
         XF5stBFl3mQDpeKeu5hQYZjM+lOkCJo49/Vh6a6hLb7MJb5pT0U+z47sUx5Ssv0/oSV4
         IymUPgGGq+f5QfDSXOzaGQkklBrMY7KHpqzJQ2hJISE6DjwP4D1pljeirKlkqjT311N6
         KGa0y0+HfsvhDG8FnTzR5fMcbSHltEE2cf6RFOyBkNqC+ABwGSpMb1gO+pbXdUY4FGXY
         UM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763122057; x=1763726857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f7c2Or+t9SJ4JcJ4QHM6wwh2YCSGgVhmzcFUnOogJw4=;
        b=ApNRIuHOvaVynjHeENzjJy/tL1z2deXCil13vwb1MELahH1qXX4HtBF8prNICak3q9
         6HiebZ0z9kpPbE2FDq3hwxzBTRkT1jT4dwUShOkPRiPIyOU6crlEJLzZRWs3lWF0M4ta
         1t2qxac1YvrKijcZ1ka8OvMiTar/Nc+ffYqt0nMfMlwDT5I8VdxCcMO1SFddAzQ62gvK
         RTbW4/perIcbZhZUqqA+vG2szj7iRSzMD6ksdMiRfK3L0UcoF9QNifzrwWibMTayM6w3
         lop1qeRusplvFhGUzqTQokG5vD9197ntX9kdrp11Hvlb46xrhKYIiYp6W2/TM7sxVwlc
         LG6w==
X-Forwarded-Encrypted: i=1; AJvYcCVlay7QLfpjL0xpQCMhCrdG+yQtzCKpYisMNoBNouOY7bBVp/5wFxjWQtNIXqwPPoie8AL/4EdwL5dafcRM@vger.kernel.org
X-Gm-Message-State: AOJu0YzW3KB29y0tjyn+1Bx/oAxNzi3Xmw+INhHK/fgOzvv3ZKccKC6H
	NMp7SQXz67/4JkhW94lSX7Sbesv5miqgbLtyU8PuitnJ+IG/1D6V0U0mfkWcNlCehNBtZUvuw4x
	32sZpznf7p3wfMEj+2i31pfSxb/HvUiM=
X-Gm-Gg: ASbGnctMBjvPmvsbntfPdyjW9BIt6wJBkaYkvCl/+eFRMSYdjf56JCucHVCllaZpPUN
	oKRyM3uph3OWLLaSz774OoOsjlOaUFzv5zfa8vBNeb4O6bj58Vz/P83VKTjvUXeuEpAQyDajx5L
	/hsB3wBX2IrEjgaQL8TXafroQuDsiBORy2hp2I7+CY4nkCjVdX3Q+ynGtDcH5hDDCOrY3fGX8Vx
	rgGxkE/LmCWsqUIKdJgOL3x32l1X0YwNY7vbK0zuLrg3h8nAldIOpWyHqkhvnVaEDi9h2bC2gFp
	8chxcPvI/z44LS77dqc=
X-Google-Smtp-Source: AGHT+IHgxAhdbgMpAOpIU/vg0eaXb2xu5A3f/rcYvzKrOMUJkbv7i4ilBYyFXDvbZh3aSGwZg+9SiGNuMyf5t8+4Zi8=
X-Received: by 2002:a05:6402:4504:b0:643:5884:b4a6 with SMTP id
 4fb4d7f45d1cf-6435884b979mr1313605a12.31.1763122057402; Fri, 14 Nov 2025
 04:07:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114-work-ovl-cred-guard-prepare-v1-0-4fc1208afa3d@kernel.org>
 <20251114-work-ovl-cred-guard-prepare-v1-3-4fc1208afa3d@kernel.org>
 <CAOQ4uxhB2am_xAGugZvAiuEx7ud+8QGPJBwcA+M+LmRvWC-nsA@mail.gmail.com> <20251114-gasleitung-muffel-2a5478a34a6b@brauner>
In-Reply-To: <20251114-gasleitung-muffel-2a5478a34a6b@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 14 Nov 2025 13:07:25 +0100
X-Gm-Features: AWmQ_bnsXv9Z9oRwqDJ96sy0kp-0qOvb1j0w_1F3esqg2JheMpC50V3b9oI_8i8
Message-ID: <CAOQ4uxie_CSG7kPBCZaKEfiQmLH7EAcMqrHXvy78ciLqX4QuKA@mail.gmail.com>
Subject: Re: [PATCH 3/6] ovl: reflow ovl_create_or_link()
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 1:00=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Fri, Nov 14, 2025 at 12:52:58PM +0100, Amir Goldstein wrote:
> > On Fri, Nov 14, 2025 at 11:15=E2=80=AFAM Christian Brauner <brauner@ker=
nel.org> wrote:
> > >
> > > Reflow the creation routine in preparation of porting it to a guard.
> > >
> > > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > > ---
> > >  fs/overlayfs/dir.c | 23 +++++++++++++++--------
> > >  1 file changed, 15 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > > index a276eafb5e78..ff30a91e07f8 100644
> > > --- a/fs/overlayfs/dir.c
> > > +++ b/fs/overlayfs/dir.c
> > > @@ -644,14 +644,23 @@ static const struct cred *ovl_setup_cred_for_cr=
eate(struct dentry *dentry,
> > >         return override_cred;
> > >  }
> > >
> > > +static int do_ovl_create_or_link(struct dentry *dentry, struct inode=
 *inode,
> > > +                                struct ovl_cattr *attr)
> >
> > Trying to avert the bikesheding over do_ovl_ helper name...
> >
> > > +{
> > > +       if (!ovl_dentry_is_whiteout(dentry))
> > > +               return ovl_create_upper(dentry, inode, attr);
> > > +
> > > +       return ovl_create_over_whiteout(dentry, inode, attr);
> > > +}
> > > +
> > >  static int ovl_create_or_link(struct dentry *dentry, struct inode *i=
node,
> > >                               struct ovl_cattr *attr, bool origin)
> > >  {
> > >         int err;
> > > -       const struct cred *new_cred __free(put_cred) =3D NULL;
> > >         struct dentry *parent =3D dentry->d_parent;
> > >
> > >         scoped_class(override_creds_ovl, old_cred, dentry->d_sb) {
> > > +               const struct cred *new_cred __free(put_cred) =3D NULL=
;
> > >                 /*
> > >                  * When linking a file with copy up origin into a new=
 parent, mark the
> > >                  * new parent dir "impure".
> > > @@ -662,7 +671,6 @@ static int ovl_create_or_link(struct dentry *dent=
ry, struct inode *inode,
> > >                                 return err;
> > >                 }
> > >
> > > -               if (!attr->hardlink) {
> > >                 /*
> > >                  * In the creation cases(create, mkdir, mknod, symlin=
k),
> > >                  * ovl should transfer current's fs{u,g}id to underly=
ing
> > > @@ -676,16 +684,15 @@ static int ovl_create_or_link(struct dentry *de=
ntry, struct inode *inode,
> > >                  * create a new inode, so just use the ovl mounter's
> > >                  * fs{u,g}id.
> > >                  */
> > > +
> > > +               if (attr->hardlink)
> > > +                       return do_ovl_create_or_link(dentry, inode, a=
ttr);
> > > +
> >
> > ^^^ This looks like an optimization (don't setup cred for hardlink).
> > Is it really an important optimization that is worth complicating the c=
ode flow?
>
> It elides a bunch of allocations and an rcu cycle from put_cred().
> So yes, I think it's worth it.

I have no doubt that ovl_setup_cred_for_create() has a price.
The question is whether hardlinking over ovl is an interesting use case
to optimize for.

Miklos? WDYT?

> You can always remove the special-case later yourself.

Sure. Just as we touch and improve the code, it's worth asking those
questions.

Thanks,
Amir.
