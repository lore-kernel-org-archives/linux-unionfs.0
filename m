Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9763E959A
	for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 15:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935714; cv=pass; b=cWqfDj2fRb5qxiWpEc8j30MP5O82t0NZptwQCg7j6vj3QKqZ/5NMSttsnl6925KVtknXtskRfaPLpiHJgsRoYHG+ak/L0OI5frDdfA7Dyut+UxuZKk6+KINCW7gChIXRw9Efp+N/9Ei04dejPZaOWGuCfZrdxXcV87QRuRPpjoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935714; c=relaxed/simple;
	bh=x5i4G6OtbOoqMZckC8IG6y1IC1mTcG4nPuYjxaeMyYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lxWeEZ4XQwPEhWHyk4wUHB3k1Hnyqx2smDgmMOpTOJ4Kivok3krLA21whuJSxG96c9IZEdp++O/VlxmUB4289i67L0xUkjcUxlQxt/e6cTVZN1kNavi5gauaVF/wm7Rc59kZS3dCobZUyLukLSqEfHhoWsAgFaTGUHawZ7FeSic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=XfiVnkpG; arc=pass smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="XfiVnkpG"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35b95a7444bso777849a91.1
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 08:55:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773935711; cv=none;
        d=google.com; s=arc-20240605;
        b=KtimxktLzONpH3JtIwxNZhpzhaKH2h+VzEEZSBk1gUNyEg01e5j4h5+xYD6JktxKhC
         vC7GV2hc9FoI73F/BE2Z/v+0v2+fAuSwTVsSej3rEq8uUV3OXRyt9bBpmA4hQgUxsts0
         r2ZGeZrJLTD60fpmtxg6LBKqkR3xnsaIMsjcO84g7+1KOw9dhIaDiM0iQNzuZPhuzK8E
         yUYNx5JjBozAh/VWoomUriFLe3mi66ZnlXc8rAn3fPRLDUFuweicWYPz1PvY4ZSrKqrn
         wbbOfovLAXHV/loEE11mMwkoIp0wM18ORphXemNnSEorTNbhniud75LNjZoyWC7OfcEz
         KZLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5dUObDXy8tyO/dqZjJVHNnud7OeR2yjgyzlwu5eskHg=;
        fh=+i3PDOkQ2w0CSosW5iprgvTH6rzx3OfxS8m1dnH7ggU=;
        b=RMFS4avEgZUtc1lpOzilSsfMITaGEL45+Rq+O8ydI1hDhPj3b6Cfq73uYTvObFDnP4
         3ozzNz1+KNU4zxJblc35mey1zEOcjzaeNx21B3NP/aRWyH5qy1o+U5SQC3vAmpyyYVr/
         /EQYzY3YEgPZ4T/p3LKxZCGo6P2bEX99UE2nEBNTrMgF5uUTyiFA+MeBS7f3xP2KZTpd
         Ytp+DRVP6DMiMLwmHIpj1EKyRJeUc08wRd5Ue3Qwb1u4sXJQpl8YNxxPHl/DuvWU6Ffz
         h5wnfOHguufJ3vuf6Pcz1LE1Jg6euFOH88ur+8ChpdGMaLEH8gxt3f2PMW9+h+4vPXfb
         xxZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1773935711; x=1774540511; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dUObDXy8tyO/dqZjJVHNnud7OeR2yjgyzlwu5eskHg=;
        b=XfiVnkpGB0S7KTHXXVWMJAMAqTm8a3K0t7y95yso7tdAXPhSLG6fVdljC3xxC077p5
         UcID72OJ44Zzx2swySirmq1XxTT3m2MyaV+9eR+GoJrEFfMiksX6cX/eAyCOJgkwniWa
         Tb8NW+8fWggkKB3qiH5B2amCgUPVFcHvt6Ha2ONwmKncHHTCUCzJ/NrRS4d3syxUwj7C
         8JZdDqRDjXn8S1kYz375bqy5ieYoUuU/K9v5jN3lSfVMyEMh41lqpB2pGlgnfAduDn8q
         Zk4IcbG8raL7pUuvdTDBOS7Pn9lKK0V94u5JXpKWzXOa3hva+BJSDvJ3HGJMHm64wpv0
         klag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773935711; x=1774540511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5dUObDXy8tyO/dqZjJVHNnud7OeR2yjgyzlwu5eskHg=;
        b=fn5WQub+NyWHhzckelnOJt2bTivfU80PecvWbaih71v1fuoBPahuCfSNS0ktVkmtiV
         u9XCtA7NsclRuVyO3Bg72tz8IGDg84PZivJFqoYfKaDRLajqkAh3vHW/Sa6xvVOutB5+
         lUVOVDpjzPpdga6/sKGZgJAJJ8pGINTouA16GWGxMFj4mOUD+Y3BKRGaLyMlIXzsTYIu
         XlgSWMpWhl3pjW/LMxG3enBYi5hatWnoElZNRhJgMwRzCKad/JvIH7YCUUtlqKhhKkVI
         tL75QZJTrHOCWzXij4MEies0DB++NijPa8ZcA56taTNFISVuJnvLF44cVTExhQ6eDFkL
         0r+w==
X-Forwarded-Encrypted: i=1; AJvYcCU/ICnaqDlmtZljkH6BSeUCbrJ687MQSckSvP6nimUPxyC49ymlzJeIhWfAoK0QKQm6YBtqZeRBUiwcVGOs@vger.kernel.org
X-Gm-Message-State: AOJu0Yza/m6mwmpj9T8MsqR8vwHWUNGF4JmR8yC98+t4tfre3rhPiZc0
	/liysLG23rrWaUPpBRuiRQz5LNa6+aWrJayfOHNfMogtKEMIG1i/wnTMv0HPImALScBWBBBN+lM
	4YXUqWcAsX8MxZbFpWexTTRR1XFlCT26WIjy6wZp76d6DzMGl+S8=
X-Gm-Gg: ATEYQzx/wrimLPb64xMh174xycSJ+H+QvN/nD7a8b8bEPRKkB7pvP9vZqAUaFmkWjA5
	lgW9wuNOTRC0erjEeOpOUd7XHBFLoAERHhZyeCualbCLFEpCVLQ3M7e59I4I023SWRxXJO3EfBu
	nXud5OPQL97Kx3og7de2u7NjNvwq36P+TAUiS/RjssxHiNOLOFmM+mgYLeafoSvwmmO4XBBi65c
	aru0OCnXZdz4hdOZYq7b3/NB3zv7veVA5WCygD+1dBzWr+1/BMMTiYLKf6NbyBfM99908ExpaOx
	tnHYJScKqqQyg1zCNw==
X-Received: by 2002:a17:90a:dfcb:b0:359:8e5e:43de with SMTP id
 98e67ed59e1d1-35bb9efae55mr5927149a91.22.1773935711512; Thu, 19 Mar 2026
 08:55:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260319124616.1544415-1-amir73il@gmail.com> <20260319-unentbehrlich-reitturnier-f78d9fb01230@brauner>
 <CAOQ4uxiS1uM=mn4q6CQfganba1XcqyXYmXfQceWdfUVRFK_Pvg@mail.gmail.com>
In-Reply-To: <CAOQ4uxiS1uM=mn4q6CQfganba1XcqyXYmXfQceWdfUVRFK_Pvg@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 19 Mar 2026 11:54:58 -0400
X-Gm-Features: AaiRm51qlPregfqoGDRQQu1uLckOXRqh7QNN-0XQFNPe0ZKCktL-8XDfXZ3JIYA
Message-ID: <CAHC9VhQDXHh_=X-OKD9oN8fapVXBwLakNp4rEHLUL0cQ1RSteA@mail.gmail.com>
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

On Thu, Mar 19, 2026 at 10:50=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
> On Thu, Mar 19, 2026 at 2:13=E2=80=AFPM Christian Brauner <brauner@kernel=
.org> wrote:
> > On Thu, Mar 19, 2026 at 01:46:16PM +0100, Amir Goldstein wrote:
> > > The fields f_mapping, f_wb_err, f_sb_err are irrelevant for O_PATH fi=
le.
> > > Skip setting them for O_PATH file, so that the O_PATH file could be
> > > opened with a negative dentry.
> > >
> > > This is not something that a user should be able to do, but vfs code,
> > > such as ovl_tmpfile() can use this to open a backing O_PATH tmpfile
> > > before instantiating the dentry.
> > >
> > > Reported-by: syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Christian,
> > >
> > > This patch fixes the syzbot report [1] that the
> > > backing_file_user_path_file() patch [2] introduces.
> > >
> > > This is not the only possible fix, but it is the cleanest one IMO.
> > > There is a small risk in introducing a state of an O_PATH file with
> > > NULL f_inode, but I (and the bots that I asked) did not find any
> > > obvious risk in this state.
> > >
> > > Note that specifically, the user path inode is accessed via d_inode()
> > > and not via file_inode(), which makes this safe for file_user_inode()
> > > callers.
> > >
> > > BTW, I missed this regression with the original patch because I
> > > only ran the quick overlayfs sanity test.
> > >
> > > Now I ran a full quick fstest cycle and verified that the O_TMPFILE
> > > test case is covered and that the bug is detected.
> > >
> > > WDYT?
> > >
> > > Thanks,
> > > Amir.
> > >
> > > [1] https://syzkaller.appspot.com/bug?extid=3Df34aab278bf5d664e2be
> > > [2] https://lore.kernel.org/linux-fsdevel/20260318131258.1457101-1-am=
ir73il@gmail.com/
> > >
> > >  fs/open.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/open.c b/fs/open.c
> > > index 91f1139591abe..2004a8c0d9c97 100644
> > > --- a/fs/open.c
> > > +++ b/fs/open.c
> > > @@ -893,9 +893,6 @@ static int do_dentry_open(struct file *f,
> > >
> > >       path_get(&f->f_path);
> > >       f->f_inode =3D inode;
> > > -     f->f_mapping =3D inode->i_mapping;
> > > -     f->f_wb_err =3D filemap_sample_wb_err(f->f_mapping);
> > > -     f->f_sb_err =3D file_sample_sb_err(f);
> > >
> > >       if (unlikely(f->f_flags & O_PATH)) {
> > >               f->f_mode =3D FMODE_PATH | FMODE_OPENED;
> > > @@ -904,6 +901,10 @@ static int do_dentry_open(struct file *f,
> > >               return 0;
> > >       }
> > >
> > > +     f->f_mapping =3D inode->i_mapping;
> > > +     f->f_wb_err =3D filemap_sample_wb_err(f->f_mapping);
> > > +     f->f_sb_err =3D file_sample_sb_err(f);
> > > +
> > >       if ((f->f_mode & (FMODE_READ | FMODE_WRITE)) =3D=3D FMODE_READ)=
 {
> > >               i_readcount_inc(inode);
> > >       } else if (f->f_mode & FMODE_WRITE && !special_file(inode->i_mo=
de)) {
> >
> > I think this is really ugly and I'm really unhappy that we should adjus=
t
> > initialization of generic vfs code for this. My preference is to push
> > the pain into the backing file stuff. And my ultimate preference is for
> > this backing file stuff to be removed again for a simple struct path.
> > We're working around some more fundamental cleanup here imho.
>
> Fair enough, we can rip the entire thing from vfs if you don't like it.
> The user path file can be opened and stored internally by selinux
> without adding all the associated risks in vfs.
>
> Paul,
>
> Please see compile tested code at:
> https://github.com/amir73il/linux/commits/user_path_file/

No.  Definitely no.  Ignoring the fact that there is no reason we
should pushing this into the LSM, doing it in this way means it is
very likely that each LSM wanting to provide mmap/mprotect controls on
overlayfs will have to create a new O_PATH file.  No.

... and let me preemptively comment that this doesn't belong in the
LSM framework either.

As Christian already mentioned, this really needs to be addressed in
the backing file code, please do it there.

--=20
paul-moore.com
