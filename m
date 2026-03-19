Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751B038910E
	for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773945884; cv=pass; b=uoaM5UwCI/wmI8cUXJUieb1baMzGuwg7Cckz1ybXLaU7b0XVAhAxna4OwiqPL+N8sbLqXMIPFXo7Ajn9sFgU1TrtABHYeSwe9ZXNcjFIsehoT4YErVgl5NOSSfHvbgHURlgusgUk/95+fTLuDW2fAkW9R631cSDDMSq+T/wAfow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773945884; c=relaxed/simple;
	bh=uiCScWR+3uywURMbmYz4JIe2t6y1lUqRrJAsT5gXGhE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WPt7d0kI9HJf8Hv92qtYp/Sfyk+vtf+BnwpgB+Xmhk2sUkz8GhIRXs4IPtOgMsR1EpKjynKEvH6NXlaluhYZU72dsPbYALJrRrYb6T4gf52cmnOUzbEuHM5XPtODQzDaD6ZrruTelzlWEkKtzJrDrcjKmLLVzRIt7UiuOwJHOz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=TjyUaHIz; arc=pass smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="TjyUaHIz"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3590042fa8eso951040a91.1
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 11:44:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773945882; cv=none;
        d=google.com; s=arc-20240605;
        b=bDDTkNSSSd+XiBx1ClCAY83JgLcgbr/MBDiNOwLoJwfcF7YwKR7iiLldoZosOM29PD
         QtSUg1n58tZBjhmqMInRwsAKa1HXemAx6/Kpiqwxsp97UOSRldjhS+symkBnXNWelc2m
         uEX9yDSkModAMxQvvE7x6qM9OFTZwUKivJo4VD8Y72ZP/9FSUFNvzx4iKa31eyHh6aW6
         XMoWSlyL/v3PDj9XJwwIFRifU38frw0vNXcVmKgm+xZQdD8wk4uVklzBjss3nLYYB67q
         JMJOYeCos/fW2Mhg5DSdyQZzsvgB1+PCKTNtjNJqDpsxiD70d5o76HAOjoZB9795IfLq
         rQrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3LpRx2Ah23pGDXkHY7jaWEi08gxAWhSArXDD9NIs44I=;
        fh=iLsExsHczCoVWgvepqvLxusNHvnCHvm+bCT6RapFk1M=;
        b=EPEQvQVd6Ec5VbEVWcgcni7RK6kQ1HPK02zUn2m4ex4KNTnP01sBmZgWbTLhs/mR46
         KaWFW/SsowsedibtrAFwxUoW2cfPuEDizVbpf+m0PYQoiBFx7oTBHfbQBxeW0O6zpxIS
         U0GHhxlAV6R7j7YnAvBax1VXyjEhpxm3QNRbKdlxwpLTd7UVL8y3kRxsajD8Lq00sS3e
         tP0hv9MWmxZ0lA7X8veKXKH683L4eduyzKMflq0BU7+A1aOm3rTwTKAVO66W/kDdCFl9
         9x0rxsQTMj7UzrV0KXXMAL4AbxBohNxIbLxYjQGAIftvdrLsMsKrYtdjfDr55HhyeK0o
         HtuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1773945882; x=1774550682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3LpRx2Ah23pGDXkHY7jaWEi08gxAWhSArXDD9NIs44I=;
        b=TjyUaHIzmYG68QqM5p5GbP6rkqxVgWOuQrOEEVjjStrbOJagQocfIPRjeVPrQbdjS7
         +mWKYqh4xTPF8reGAEST7QyQLIhKpN4kkk1fxVnaYDxAke8u2OcQgE0oQgj5KsKBlyc7
         IY6QmrnzhEXTxEZ2JlE14Wc0ZFdJ6C8+tq7VmHCcQTTVKKk/Z8pVKsMODNutlPGC+wke
         aXSnYr/5XJSb7Ewg1FkDDzJZknz2LlE3B06n5k7xCiY2plmZ2yE27HrU1pd2l+C64fI0
         pHyfUXaSivMCSQ+PiE4tP1wyQGxr22Hk5VEUZIhxcJLoDBO3U0E0hQ4lyVaZ291fdeYF
         HIAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773945882; x=1774550682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3LpRx2Ah23pGDXkHY7jaWEi08gxAWhSArXDD9NIs44I=;
        b=jJmEbmO66b8NDXwkE4tEzXyxczD3HZApwmW97ibZe0QkX0XeOx1SyoDJuT1QAZO/Pd
         rrfqf+Qa3o3vLsb/4albxAK2I2YaUtuZhqD43DHFL8AiT4MVK7e7ZxdsbQDT8pd03QOQ
         CQC5qQuVGz3J8ufNaUP7bVZHi8cYgc0LhXksMdCTmd+ADo6+AwDrr883h1cqdJ7c2hdV
         46h8ZdvMtaqdABKT35ueqNWShNgevSqeNqoUF1QU2lmY7tEHcNaSkLIJZmazfOYhNPuy
         v/t/bHBwRvQvwsxuXC6FxakVvUri3876nr+x1W0fIWF8zydPTG6cIUK6A/zdD3mYm8qE
         tbZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSzswmj7lAUL26qlUK+X/9LSI7ah3K1uil0xE8VwE4NS9cCdN9xbprr22LONSrX4SxU+99L8EQhb/MTYQT@vger.kernel.org
X-Gm-Message-State: AOJu0YzJL9BHr9iiHpJGm6QKt+P9+4hDExKFaP2SEEOgKorohs/0d+pp
	aevZEEvnJPSgmoUuRyqrGrJS+FnNdMymkv9re5ocxN1nRyZOl9f641Ibo7UkT7EUCtH91EHFqOi
	HB8LKvZIX3QINMJARt4/TsFluP2zl/0vXTnEJ42ZQ
X-Gm-Gg: ATEYQzwPODJRYdqpmuxR0Fl92H/bAK0dXZgi6h44CTPnjxr7kFaDQtOCGawZXkYcxXA
	GPePsqjgJhIEZbFu8D0PELtljec6JxSzhGTqPDjWc7VZAqm30JRRHiC7Z3o90HvvaU5wZDJJG3T
	txYDWh0FgW/Pyezrz0vMel7uDDP0+NYaYXfpd0dZli4Klctwbl+PclFbT7QEsSB/HwvDaO+JhaT
	XydM+8rntcZ2ptmb+4NVFVWHwEKf3+tPLAm5OJWgJwzNpkKYVA70rSXqyuSQuHyT9dT5ajUp0v+
	q42A2z9jvuvtGoeQcQ==
X-Received: by 2002:a17:90b:3d85:b0:35b:91e1:e110 with SMTP id
 98e67ed59e1d1-35bd2cb726cmr153296a91.20.1773945881632; Thu, 19 Mar 2026
 11:44:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260319124616.1544415-1-amir73il@gmail.com> <20260319-unentbehrlich-reitturnier-f78d9fb01230@brauner>
 <CAOQ4uxiS1uM=mn4q6CQfganba1XcqyXYmXfQceWdfUVRFK_Pvg@mail.gmail.com>
 <CAHC9VhQDXHh_=X-OKD9oN8fapVXBwLakNp4rEHLUL0cQ1RSteA@mail.gmail.com> <CAOQ4uxinSLXKWjMgwyA2A_UU5e+6ZjbdsFUY-+f9DMfQcxH0qA@mail.gmail.com>
In-Reply-To: <CAOQ4uxinSLXKWjMgwyA2A_UU5e+6ZjbdsFUY-+f9DMfQcxH0qA@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 19 Mar 2026 14:44:30 -0400
X-Gm-Features: AaiRm50mWSepRO31-IrCKePpEwYDJfx_2t8PZ8Bwv853YChliBvO2jCDu0_F2bc
Message-ID: <CAHC9VhQbT1jPXN-nqmoNS4DGkYGWrVkO9-C1k-9zjYU9cRDi0A@mail.gmail.com>
Subject: Re: [PATCH] fs: allow vfs code to open an O_PATH file with negative dentry
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Miklos Szeredi <miklos@szeredi.hu>, Gao Xiang <xiang@kernel.org>, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, 
	syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2026 at 2:30=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
> On Thu, Mar 19, 2026 at 4:55=E2=80=AFPM Paul Moore <paul@paul-moore.com> =
wrote:
> > On Thu, Mar 19, 2026 at 10:50=E2=80=AFAM Amir Goldstein <amir73il@gmail=
.com> wrote:
> > > On Thu, Mar 19, 2026 at 2:13=E2=80=AFPM Christian Brauner <brauner@ke=
rnel.org> wrote:
> > > > On Thu, Mar 19, 2026 at 01:46:16PM +0100, Amir Goldstein wrote:
> > > > > The fields f_mapping, f_wb_err, f_sb_err are irrelevant for O_PAT=
H file.
> > > > > Skip setting them for O_PATH file, so that the O_PATH file could =
be
> > > > > opened with a negative dentry.
> > > > >
> > > > > This is not something that a user should be able to do, but vfs c=
ode,
> > > > > such as ovl_tmpfile() can use this to open a backing O_PATH tmpfi=
le
> > > > > before instantiating the dentry.
> > > > >
> > > > > Reported-by: syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.co=
m
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > > >
> > > > > Christian,
> > > > >
> > > > > This patch fixes the syzbot report [1] that the
> > > > > backing_file_user_path_file() patch [2] introduces.
> > > > >
> > > > > This is not the only possible fix, but it is the cleanest one IMO=
.
> > > > > There is a small risk in introducing a state of an O_PATH file wi=
th
> > > > > NULL f_inode, but I (and the bots that I asked) did not find any
> > > > > obvious risk in this state.
> > > > >
> > > > > Note that specifically, the user path inode is accessed via d_ino=
de()
> > > > > and not via file_inode(), which makes this safe for file_user_ino=
de()
> > > > > callers.
> > > > >
> > > > > BTW, I missed this regression with the original patch because I
> > > > > only ran the quick overlayfs sanity test.
> > > > >
> > > > > Now I ran a full quick fstest cycle and verified that the O_TMPFI=
LE
> > > > > test case is covered and that the bug is detected.
> > > > >
> > > > > WDYT?
> > > > >
> > > > > Thanks,
> > > > > Amir.
> > > > >
> > > > > [1] https://syzkaller.appspot.com/bug?extid=3Df34aab278bf5d664e2b=
e
> > > > > [2] https://lore.kernel.org/linux-fsdevel/20260318131258.1457101-=
1-amir73il@gmail.com/
> > > > >
> > > > >  fs/open.c | 7 ++++---
> > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/fs/open.c b/fs/open.c
> > > > > index 91f1139591abe..2004a8c0d9c97 100644
> > > > > --- a/fs/open.c
> > > > > +++ b/fs/open.c
> > > > > @@ -893,9 +893,6 @@ static int do_dentry_open(struct file *f,
> > > > >
> > > > >       path_get(&f->f_path);
> > > > >       f->f_inode =3D inode;
> > > > > -     f->f_mapping =3D inode->i_mapping;
> > > > > -     f->f_wb_err =3D filemap_sample_wb_err(f->f_mapping);
> > > > > -     f->f_sb_err =3D file_sample_sb_err(f);
> > > > >
> > > > >       if (unlikely(f->f_flags & O_PATH)) {
> > > > >               f->f_mode =3D FMODE_PATH | FMODE_OPENED;
> > > > > @@ -904,6 +901,10 @@ static int do_dentry_open(struct file *f,
> > > > >               return 0;
> > > > >       }
> > > > >
> > > > > +     f->f_mapping =3D inode->i_mapping;
> > > > > +     f->f_wb_err =3D filemap_sample_wb_err(f->f_mapping);
> > > > > +     f->f_sb_err =3D file_sample_sb_err(f);
> > > > > +
> > > > >       if ((f->f_mode & (FMODE_READ | FMODE_WRITE)) =3D=3D FMODE_R=
EAD) {
> > > > >               i_readcount_inc(inode);
> > > > >       } else if (f->f_mode & FMODE_WRITE && !special_file(inode->=
i_mode)) {
> > > >
> > > > I think this is really ugly and I'm really unhappy that we should a=
djust
> > > > initialization of generic vfs code for this. My preference is to pu=
sh
> > > > the pain into the backing file stuff. And my ultimate preference is=
 for
> > > > this backing file stuff to be removed again for a simple struct pat=
h.
> > > > We're working around some more fundamental cleanup here imho.
> > >
> > > Fair enough, we can rip the entire thing from vfs if you don't like i=
t.
> > > The user path file can be opened and stored internally by selinux
> > > without adding all the associated risks in vfs.
> > >
> > > Paul,
> > >
> > > Please see compile tested code at:
> > > https://github.com/amir73il/linux/commits/user_path_file/
> >
> > No.  Definitely no.  Ignoring the fact that there is no reason we
> > should pushing this into the LSM, doing it in this way means it is
> > very likely that each LSM wanting to provide mmap/mprotect controls on
> > overlayfs will have to create a new O_PATH file.  No.
> >
> > ... and let me preemptively comment that this doesn't belong in the
> > LSM framework either.
> >
> > As Christian already mentioned, this really needs to be addressed in
> > the backing file code, please do it there.
>
> OK, will give it another try.

Thanks, please let me know if there is anything I can do to help, e.g.
testing, etc.

--=20
paul-moore.com
