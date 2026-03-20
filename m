Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F09317A586
	for <linux-unionfs@vger.kernel.org>; Fri, 20 Mar 2026 12:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774008929; cv=pass; b=SN/XiiFMxbWSOoHbcVDl1s4zIpQTVISES2lwbAtV6BQwzckPw0BKOCYwsrd+7hbHxn47kdK2RsaILgnEtJznrNX/GFsIe+D5oLsjUUFqYAPY9hoyFkdSuDo+283tU4zbRsxCH+Ovz/yE8joA7tqybKNg/51SpwfWYER5QStSQ5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774008929; c=relaxed/simple;
	bh=izlGddYzHIX3u/F5VuyEk/1zjiht7pRMDL5Lijk+cYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GSn5w/RbULu7xnsw9/L6iCNjLpjpRE8a1/QpjMOww7ghMnjziZstdtfcHSHO4tdAcA/fSo9b0W7GUwJLURiKTJ2bt63v0sfj7UILUw6elrGHkSPKGbG+OCDJ/Rj9SzBhO/3y3PlaYB8eu2jRBK/ib6ody/61mfm38Njb58RP8GQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ESlHZn9/; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESlHZn9/"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b98069e41b0so356069166b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Mar 2026 05:15:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774008927; cv=none;
        d=google.com; s=arc-20240605;
        b=QZc3ykja/Tr4MzmMBD4Ye4JUsCScZZYHOupjITQjfPtil/+GS9cWeT3yOmm7K84Tou
         dn7PgiTJRhb3BcM8su2ZCz+wfrJ/slQnESUcvSi2NeydP/tMCP0c2bJJWnVlJ3SeIbFy
         cb/Fg+7PRsUmKicRU9JlkToJLVGTqcfnVI0gAdpa1eqzKCOQkAjmSEoaYMBQ5T+QOp1I
         4dzY4PLvNWYE7KgiwckoSutlgpHQsr6k1TjOuRPcThtQBBCkeGtciv+vVUkUZUnoJlQs
         GKrepm2/ch/wC8EpBv5qHtWUBxjNi6j/q7w3O838b9zuvzbWUTHqwyA1YcDWPW65FGIQ
         f+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WBpgvBLWMC/0BhjOb7jBuNoEBM9BBGEAVw/zBHqxLZw=;
        fh=jHVbkVZ4CEgU3YNPfkaCU/W3GzBP5fPlG9/0KTT3Tdw=;
        b=bhelWIZ6K3KHZgrwFOUcgHe0bIq7/yMiUQAOd1RvivlGBToGmhbp+OlQAkPGwWkwVu
         ncjYRTs+CqW6dyQhdGW8U2SSDPyhlMoVmWIku9YcEg5BtFHJAo1ebJLtcKOM99Q5OrnD
         lqc2jZ3yRIFBAphBL1FPh8SWpFIRKapl0ZJAPIyDIfQl7Zvz3213bE1T34we/J2dxauh
         hCLAZhS2tSN/Ds35d0qRUQ1fz0iokNFbmPsE2Umh1A7M01x59TEv5385EYMXjzZzzuLo
         gvLi+An3biBVX6KWvjO7sEbJX0W0TsdqFbUkBDn+RcQKvC4XF7PNjiPTZPcuCEM4oCap
         n8ow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774008927; x=1774613727; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBpgvBLWMC/0BhjOb7jBuNoEBM9BBGEAVw/zBHqxLZw=;
        b=ESlHZn9/ydl4opGMk8RGdey2V4X91ombcGW8WPRXud/oEEiKm5L3BLjElFcCwgm6Dm
         8WtHa2JdU+WkM5acYtOi7/q/vPq8YwS9aGNZZLY3pEctwjhG8N5+oApX71uhqmDPWkgm
         9GdoLDBnPJNLtfM/nlaPcAq/Zs3A2rcMFdz07rFajTn/HvCTgE8stMVdjWV7Sdl5cnHA
         ROM89i9fYxxbFMdsfhjDUS1hEgu3t/IHlkDWQgtQdub4bQzvdwMDoLZB6HyrvMSWBobt
         qSbtcTaLd+Ic/A6cPtsUwNmt5EE2g5cOOTVsZ9CIxrbUUeyABYjh9bKjAz29/RN8Q1L8
         F0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774008927; x=1774613727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WBpgvBLWMC/0BhjOb7jBuNoEBM9BBGEAVw/zBHqxLZw=;
        b=m4L1lYMD+hruXqzgSdVqEV3A54tXU6u6QHXBIBVMu9ByANLkiFJmZYZ6rEGbGqlU72
         FPRddL4qWqp5ByyAlrtl4dXk/CpFccMgN7WS0DhSq/QKXmnoeP6RkapRUHvouyEuz03k
         lKHcxOrXMQTmEZLBpiJ7Ajpoe4n3FNU6J6yrvi36hCd7qBr+oUqru/0uk8eUQUNvjSkR
         BiRGuFt0Kp07HBpb29hlrkjKzKwJKB6fH7c+y0sACSpmq5WzFRBWrVq2KB9UKxG1/hUG
         EyCLEnjH8bGkXaF4kc0QnbIWXQLKWRvZZtKruknKdG4gVpBXjiJFlgV2MvHoMj3s30X/
         EfKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYtVV4IznhRupqEqUAYyHKaUHEQ/lD7J93GJI+JKHen6exAvmZJhHpOHUYtPK3X5ohNeDpVeN628l5sPzw@vger.kernel.org
X-Gm-Message-State: AOJu0Yzlpx1aWHk8TjSokuuZYIf36lgvy3T2uXKfazFUWHi4C0cNunmP
	c/WTI+4Zo5LHFrZyaAvExkE46i+NXb/ULxOJipivN1ZgzClHd7bf6b6ZcE3DEz+QI9vpJORDHRe
	TneEQ30pfaWnvuO+/VfOl0T03r3XL/N8=
X-Gm-Gg: ATEYQzyWeeWDQqvjAFG6fEZj+Xa54HtJ4SRYEbR4FRBRY1ivBQD799vcwkZMCqdpuud
	dyhd8S/kGDX6S3wphwfxSvX76zz9oMn2ENanY1l0uY+yPJvan9FvaMKfwL9ch84Q2M7M8BZ5yNK
	1ScNSqSNHT8Hpcq/HK4a81vpI7MEz4+hAcXY45gdWfZnrClWkEZgiQjRXC4+aGYF1gskvew8YJ4
	3bWIxuRS/C4WJrmS6hnb2V8id0aEBor3VEFxQgHf7iU6m/sG/M11/APc5cSV4C2TEBBKARalv6s
	82NZatnC3vrYvl+3V9Ncfk4dHuj6aWMvBeErVe3g5g==
X-Received: by 2002:a17:906:37cb:b0:b97:f2cc:8c3e with SMTP id
 a640c23a62f3a-b982f39b197mr137796766b.10.1774008926368; Fri, 20 Mar 2026
 05:15:26 -0700 (PDT)
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
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Mar 2026 13:15:13 +0100
X-Gm-Features: AaiRm52styHcNjJqwA19Qyu0kuu9684XRXZIH06BjgsInXNVqvN-rIFPkHHA9M4
Message-ID: <CAOQ4uxjQzsFy2cS2Q9pL+NPBryHzoQdrjs4QdUNBpM_7GzukPA@mail.gmail.com>
Subject: Re: [PATCH] fs: allow vfs code to open an O_PATH file with negative dentry
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, 
	Gao Xiang <xiang@kernel.org>, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com, 
	Paul Moore <paul@paul-moore.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2026 at 7:30=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, Mar 19, 2026 at 4:55=E2=80=AFPM Paul Moore <paul@paul-moore.com> =
wrote:
> >
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
> >
>
> OK, will give it another try.
>

Christian,

I pushed another version of the syzbot ovl O_TMPFILE crash fix to:

https://github.com/amir73il/linux/commits/user_path_file/

In a nutshell, created a helper kernel_path_file_open()
instead of modifying do_dentry_open(), with a bit more magic in
ovl_tmpfile().

It's not super pretty, but at least it does not touch any non-backing_file
code paths, so maybe you will be ok with it.

Thanks,
Amir.
