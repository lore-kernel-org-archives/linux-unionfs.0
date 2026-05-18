Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F2F39659E
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 21:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779139398; cv=pass; b=D4hqBJwANv6OV72eFvCEpchJuO1/3oTfuacTBc042Hj07Rh2jw/EjyH/mSb6UVctyauD8xT0wqNb2DATdfjUYFE4PEALlnCRovY7ksXHjaUMZfKO9UL09/A2E/i0cmGHeMSLZ27mbiR69jfyMgxeqvgZ7SIQ3xAArTo5a+Z6Mk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779139398; c=relaxed/simple;
	bh=ehunx5QPTjonSJZ/DC/UmIaaqmqkD6UtPhN8uzXbdbw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YJOZY/u7dnUEqS/HuG71IjutMsMDcApEBnjgHa51cUK8j7X46IhQNU4L0JlzTl9GIo0jyFRBh1KOmfm63qh5ahEYzrwHFGYWGXcW7hPM2wjOGriACEMBneIpyYLTqY58u8S8xl/bXPkHY4P2NQGLfGoXqGE6VqNIicIJ+Anp0Uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0XAkH5R; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0XAkH5R"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4890d945eb4so20740005e9.0
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 14:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779139395; cv=none;
        d=google.com; s=arc-20240605;
        b=k1mm91M7DG2xkkWiYOglBbG9DlOhns3zGZZIwPtJNkG/5X7I8/8wnJ795f/LIYdT9E
         0feRxa4D0yR6EQYwyilDEGSDeFWDdKxVbXeYMEPMXSPttgfDJ7XNwKwUGEQqIQ+NON0k
         OOnUSnn2RCK37sllRfVUl1XzfNBSkDGJh5RJHuHfOXKs1Jhv7JO2ib+w0KRwmDR60Ova
         P+wdvJNfr0XrEgL5zC8kKCnGa1x2t0tJKB4egxFok1TqDNqqt8GjBFs99ZI/WIwP5f8k
         LZxxrLJ0ouZJovhcOJlDrbRI40kPU5RUqUfPwgA1oejZ83BzhbUZQOwRB31GZXmCyZNk
         0q/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aV1RPIE/Suy744QrgJcsEUXldeiHUsxUrC+JiXtfahg=;
        fh=fbYqWpYacbTQoqOlF9C5Pb3w7vyLfCOSwR5Nj6ZERs0=;
        b=i0RuYpyb+PVJyyO81fZPWI2iRhJzjy/Rnn2Kqfo7mk2EXzp1P33n4At3D8VPgNCiZZ
         i+MmyE9ZdIGeybDqr43AJpcQxUeyxfTiK382Exa/6YPZ5AMA+bQrOqrFNsn7VWNbEKd0
         kudqp1gjhE65r8wc5xalR927G3+XKe7qJ8Zrko0HqUOPmGCPqcUETLpbjSQdALqjdI7d
         xb8nZMsJvlygjkeX6YH/XBbV5BR5CsQ+zB/NG3RuFEXmO53c3dh4nCSqhud5sdYXBnUJ
         1iaV8MTiJM5/z0l78iWux5FbV4cEVTwQVQQc+SwKXd8aNCLnkRk6BO6klgyPvOkt9fUw
         rW3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779139395; x=1779744195; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aV1RPIE/Suy744QrgJcsEUXldeiHUsxUrC+JiXtfahg=;
        b=Y0XAkH5RiHrna2T0X3tAk6Rb4jzlDf0Ex0uM+7fPmIqKxPGQhBc3QPVvZBzG1f/NjF
         Dw+65EdxH/8wDdoGYX6JGHuVnrcXTHPeKJJ0L1xltbJpAeIXI/JmrNDw2G5oODMz9foJ
         cO0WPX4Zz1Zw9mZMqp8e6aicDTYV02F1vQp6YFhjrPAaO5pQjEUoJXq8d8JCc/IOOKUj
         Ga+jt4ixWU7HRSeSafIiR3Ogp2XrbWTfI3DtCwgReKIctOX27RKsOHi1fKk5AK0CZ+Te
         kjkZypztHP8QO5pj06NkpNTaJZ1E+YwEGrxO/4fXUyrwjiRxzjw5e7Ag8YHBpMvc7EgU
         DBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779139395; x=1779744195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aV1RPIE/Suy744QrgJcsEUXldeiHUsxUrC+JiXtfahg=;
        b=c8YDqy7FsfXd87mM9AOrT1hbLriyhKb9uOxsMCFFciBmFhpwdFRpWxUDnVv3vBqLih
         b1sYM3gKbWX+gFHhd0bPZUwYJvVlF+Of3VsxaLHU17DEvpNQTFp8g0vgh3rDUmOey9su
         NCjYl7GOluWZaBpJwS5zL7KrA4yfy0P2KuX/s4lWm8cGPLfxyEy/j6eZEhF9N4s21J0y
         6YXjLPWhqrpCmV2XUEhmYlrpLtfuLHG/1cmTq3vVqlEENm3j/Q8mzB56yHgCxWXE1aBl
         iKlmsXZzKD13EfViyAiJP3Cf+VSjG/4xw4oc92WgvdtddKK6uKs/PiTUg/cv1veR63t9
         +uCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ajgRcGCiv6dtjZkCpZ+1YYrId6U3rD4eUHe1+XjROOWcEIsB8SukFNWYeqoDxPiGbqvPC4ZzG77lTT7eM@vger.kernel.org
X-Gm-Message-State: AOJu0YzSuOzfx7rgneR/0PksbjNUoTfGFrb4SgV8zV4hoS+0+Fjsv9ib
	ZToHVcsmJLsGeIPTUgUJCG1rZeQXnbsHNW9wvpUo1cvtkJmLx3YcO9WQ4IORrpEpjBHSa85DQcS
	FRHd38BokbBUFFg6I6vpD4zXMAfIZEAc=
X-Gm-Gg: Acq92OEthJjWmQpjecwVev0dnLeiHfn/7z+95K93Q0+iwXJmrquUV3FwsQXxssEdfWq
	8kCYYEldPEONsjBzslw5kV9wGnN0kXr1FQ7+qTyOBQzcLwC+IozFo/PWwzAAuNirFnZWQBsblqN
	iFPom58mSlHKdbaWLVDzd1h6feEoOtc0RGH292LI3gWUbSG34dzmJr6yn0l2t1VHvZfTtG7JBNG
	ieSL+f9Ugl/VvQnINzJeygdV4leNxfv6L2lMyW5FI+32qPqDap5gGAt/69GvgK2x3i3RrlQZ8Xa
	NChQ5g==
X-Received: by 2002:a05:600c:1595:b0:489:1c0d:c9cb with SMTP id
 5b1f17b1804b1-48fd633273emr201774585e9.5.1779139394735; Mon, 18 May 2026
 14:23:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-22-joannelkoong@gmail.com> <CAOQ4uxjg4ULPKC7K9PabXPOOT7J5i2EOnzsv5ABNP3R5Y9jdYQ@mail.gmail.com>
 <CAOQ4uxg4+6s094=ka7xG+Rjz2A6amyrSOr6C0QpYQ_iyrR4f+Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxg4+6s094=ka7xG+Rjz2A6amyrSOr6C0QpYQ_iyrR4f+Q@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 May 2026 14:23:02 -0700
X-Gm-Features: AVHnY4LAEpfAtKN8TeM5qcqSPbVu1r9rOdXldlZv_3lP4D0JY0hEO0Iv0LsBVk0
Message-ID: <CAJnrk1ZD8hQX1jrnRzQ3aDTsihvDC5g9fV-NDG1V53gE7TL_ig@mail.gmail.com>
Subject: Re: [PATCH v2 21/21] docs: fuse: document extended passthrough (FUSE_PASSTHROUGH_INO)
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 1:59=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Sat, May 16, 2026 at 8:23=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Sat, May 16, 2026 at 2:53=E2=80=AFAM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > Add section about extended passthrough (FUSE_PASSTHROUGH_INO) mode.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  .../filesystems/fuse/fuse-passthrough.rst     | 126 ++++++++++++++++=
++
> > >  1 file changed, 126 insertions(+)
> > >
> > > diff --git a/Documentation/filesystems/fuse/fuse-passthrough.rst b/Do=
cumentation/filesystems/fuse/fuse-passthrough.rst
> > > index 2b0e7c2da54a..751d27c6fc5c 100644
> > > --- a/Documentation/filesystems/fuse/fuse-passthrough.rst
> > > +++ b/Documentation/filesystems/fuse/fuse-passthrough.rst
> > > @@ -25,6 +25,11 @@ operations.
> > >
> > > +Extended Passthrough (FUSE_PASSTHROUGH_INO)
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +``FUSE_PASSTHROUGH_INO`` is a stricter variant of ``FUSE_PASSTHROUGH=
`` in
> > > +which the backing file inode number must match the fuse inode number=
, enforcing
> > > +a one-to-one mapping. The kernel offers this flag during ``FUSE_INIT=
`` if
> > > +``CONFIG_FUSE_PASSTHROUGH`` is enabled and the architecture has 64-b=
it
> > > +``ino_t``. The daemon accepts by returning it back in the init reply=
.
> >
> > IIUC, ino_t is now always 64-bit.

When Jeff's changes for u64 inode->i_ino land in the fuse tree, I'll
get rid of this and update the 1st patch accordingly.

> >
> > > +
> > > +IO Mode State Machine
> > > +---------------------
> > > +
> > > +The ``iocachectr`` field in ``struct fuse_inode`` prevents conflicti=
ng access
> > > +modes on the same inode (page-cache I/O and passthrough I/O cannot c=
oexist)::
> > > +
> > > +    iocachectr > 0    Cached mode
> > > +    iocachectr =3D=3D 0   Idle. No files open, no passthrough
> >
> > More accurately, no open files in caching or passthough.
> > files open with FOPEN_DIRECT_IO may exist and they
> > do not deny entering either caching or passthrough iomode.

Good point, I'll update this to be more precise.

> >
> > > +    iocachectr < 0    Uncached/passthrough mode
> > > +
> > > +Each open file in passthrough mode holds one reference (``iocachectr=
--``).
> > > +The inode-level passthrough setup holds one additional long-lived re=
ference
> > > +if the backing has inode ops (getattr/setattr). This long-lived refe=
rence is
> > > +released on inode eviction.
> > > +
> > > +Cached mode and passthrough mode are mutually exclusive. Attempting =
either
> > > +while the other is active returns ``-ETXTBSY``.
> > > +
> > > +For directories, the same mechanism arbitrates between cached readdi=
r
> > > +(``FOPEN_CACHE_DIR``) and passthrough readdir. A directory opened wi=
thout
> > > +``FOPEN_CACHE_DIR`` and without ``FOPEN_PASSTHROUGH`` is treated as =
direct I/O
> > > +and does not affect io mode.
> > > +
> > > +Things to note
> > > +--------------
> > > +
> > > +- ``FUSE_PASSTHROUGH_INO`` requires 64-bit ``ino_t``.
> >
> > Not relevant I think.
> >
> > > +- Readdirplus does not set up inode passthrough. Inodes created via =
readdirplus
> > > +  use normal FUSE operations until a fresh lookup occurs.
> > > +- An inode's backing association is set once and cannot be changed.
> > > +- Passthrough and cached I/O cannot coexist on the same inode.
> > > +- If any inode operations are passed through, this means all opened =
files need
> > > +  to set the ``FOPEN_PASSTHROUGH`` flag in the open response, even i=
f reads
> > > +  and writes are not passed through. If reads and writes are not pas=
sed
> > > +  through, they will go directly to the daemon.
> >
> > I had not considered this.
> > Setting OP_GETATTR/SETATTR in LOOKUP without any OP_RW bits
> > and then requiring that the server open files with FOPEN_PASSTHROUGH
> > with the backing_id sounds strange -
> > I understand why it was done this way, but for users this could be perp=
lexing.
> >
> > The thing is that if the server is only doing GETATTR passthrough there=
 is not
> > really a reason to deny open file in caching mode (I think?).
> >
> > The limitation that requires FOPEN_PASSTHROUGH is encoded in
> > fuse_file_cached_io_open()
> >     fuse_is_io_cache_wait()
> >         !fuse_inode_backing()
> >
> > We have two options.
> >
> > Either we decide that server passing through GETATTR and opening
> > files in caching mode is not interesting to support (for now) and then =
just
> > maybe we need to better document the reason that server needs to
> > use FOPEN_PASSTHROUGH despite not doing io passthrough.
> >
> > Or we relax the limitation w.r.t cached io mode, something like this
> > (completely untested most likely broken based or earlier review
> > suggestion regarding fuse_passthrough_op):
> >
> > Thanks,
> > Amir.
> >
> > diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
> > index c5f3e2201c6ab..7c33e7a974f6c 100644
> > --- a/fs/fuse/iomode.c
> > +++ b/fs/fuse/iomode.c
> > @@ -20,7 +20,8 @@ static inline bool fuse_is_io_cache_wait(struct inode=
 *inode)
> >         struct fuse_inode *fi =3D get_fuse_inode(inode);
> >
> >         return S_ISREG(inode->i_mode) &&
> > -               READ_ONCE(fi->iocachectr) < 0 && !fuse_inode_backing(fi=
);
> > +               READ_ONCE(fi->iocachectr) < 0 &&
> > +               !fuse_passthrough_op(inode, FUSE_PASSTHROUGH_RW_OPS);
> >  }
>
> Obviously, this was naive and not close to enough, because
> fuse_inode_set_passthrough() still takes the negative iocachectr
> refcount.
>
> Please ignore this. Supporting caching iomode and GETATTR
> passthrough is left for a future exercise, if anyone is ever interested.

Sounds good, I will continue to leave this unsupported for now.

Thanks for reviewing these patches.
>
> Thanks,
> Amir.
