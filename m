Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329241A3154
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778956489; cv=pass; b=I9VX3aFQByvLVk/2ocFEByXw+s6Knb5LtmzPkUzAeK6NNPQ4Tn3C3OoBlk/OHSZCY44uJJKq41Jkq5/e+PhXbmCDBqqeg4ZWMrTpxHD7q1jngTh1w/nMpuuLX47iy+k3WRFeaFT0zlUUsWWfzB8/OScd53gPWaqeOLqjU7SnxUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778956489; c=relaxed/simple;
	bh=LclkXbULnV74eXU6/1IVNHt1FQ4l7ePqSXWsDF3P2S4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CLRsNhf+UUrzhco+t889gSm38Uav6pfm/eW4IkVSMBIaGwaL0PbJqq524XlOyoys9aM07kV87HIOlsAxNVIRRSxn+QZzkh5otso/8gvU0/LvZWKrHJGgQzrzhAMJ50OnslOxOSVTOLTMDCRRiG3xGg33ewrClauxY6HRQDbK94k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CihTG4IX; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CihTG4IX"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-676a89de629so1715983a12.1
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 11:34:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778956485; cv=none;
        d=google.com; s=arc-20240605;
        b=LSmTKgiRUA8dowslANn8cohLjG19PjCxJ0ArRHM2moCixHSiaR2BNU/kn+bi2N0o3M
         WhbeXtYONBiagBobGzUdZFoxAeZbHHKTdDQN5W/JeSWm8dThRjzYQybe58IeG08TYDI8
         A45yL4Y7Ps8ZUzdP/eJA+nSOckyM8U/4LpZ1k51ZCUHacgE8BfQsrO6Nyl079+XYSyvE
         +MCmxZobqCgg+/5WYjhA6F2zRU1mnL0pFuPMKjUaNBaJdysrd7/dfkO4UlWEENV0diSA
         Zp1PAaY+b2rXmAjvW/jJiJrOxBuo2CdRarb3fXCLz2ZusAKD7JHday9X5vianeDRkOZO
         rHqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jst4J0K6rFdPUswjR8DsK/X1gYtqk0feBIACyM4lJJM=;
        fh=RCFBBpeOHGMllQKd7ddIh3t6UtCr5XgVgEyXxvCQPEk=;
        b=S1YJ+NUzQHUJHFU1kewDMKHmqCw+4WCMJFzW/r3OeuKOhsst5DpINGZd8Px/Ns37kR
         NqpFpxSRB7H/pjTN0/R5h1czlPXLN3pbQAgUFmJ+EYyNbNakA1RF09ciw8DVn4xnmWh6
         aCytZ0dAz5+lJttwGKlHVAqHA/6Ad0a3WTOiLbSkJBlJH5WmAvb7bNhfeNvFdD91S2Eu
         HMNU/0P19l6gYiJM8iesuh8bNFdPM4Hid2pMeg73KgclMAicWq8tcGIp0lYs7vW8M7Au
         RJGYUklnWozFCq5MVlPdOPOSRZcqtryh1d1qXKuwpy1euqDa5ZYya2Ihd3/dHFtJzmyt
         WQPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778956485; x=1779561285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jst4J0K6rFdPUswjR8DsK/X1gYtqk0feBIACyM4lJJM=;
        b=CihTG4IXO8r69r2j5qcL3RXsj6fNUp2D4Fm83p/PYtZIor1JLqNNDtE0/wM4tVjxUk
         9nPYLQhJH4oRrfDm/nZln5d9/VNuVUf4yuvN7w41M26JGsD0xxg3cSoWD2aEAvJAk5nB
         Bq89Itd/AHIo8PipGWK/ll0BMFZ7/uAfYJ3mgknfYsa1WxqTD9KeKFiq4RGi/nLNT5rO
         7DDiOXj5jBpRAVIhe2MIwcenFolBWHNeeSJVsTbqFcOCOQE/XexE3fG3FZ9x2ycGJe/5
         UFG8AreP1H3aGguIiRRIKRsARFreh3rq86IHQX09rmlbAUSQStxzGEBvhqHpe5okE3/i
         ur7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778956485; x=1779561285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jst4J0K6rFdPUswjR8DsK/X1gYtqk0feBIACyM4lJJM=;
        b=ClxSOybRVf1MvFL6BcbA3EE6GESjhJHy0mKm6s7QJb45OTMc3EICaanMu5KP6RHD+H
         TIzaJOZb87BieucJDwOY9AmdN3BwAlU6qUBYjfjlobjbJGELk6J6ORY+htA34EjXwZu/
         2YIzmlfDIEHY1xR4/CieDTQ7bPrUy+UqcVAbNswW3T2u1uCx7dBg/ZvcNpS5C0pJX3Q8
         FXsJUbXUi2x+QnFAg4swPxzMsU9sNCPkNZacic0SUjFOB8hav6aX8a+ve5+6Do2JY/8K
         rxvDpP9UWk9DiCxFuGgtqxQhoSSnbY+/s9bUFYbZNqUvV6mphlb8AEGABfhd6ys2fN+t
         3H5Q==
X-Forwarded-Encrypted: i=1; AFNElJ9jIJdbHyp61vDyfM1tRrmW57VSf2nFVssgJF3NsUOrd8k3Z98qAEmO/OOz1NHC975o6TpoipLq/oxuzLZO@vger.kernel.org
X-Gm-Message-State: AOJu0YyxoT7V4Kwx3kOGLA4i0oFORuUO0J7yVO+q65D4lJWMMtJHpa5N
	AydYtHoX+CbdrO5cKsR3Z0M58NrS8b519Tdf2jGJc6DfUjoCuBNua8HnAYykcvdcecuBehZfESr
	pPI7wG71l1cFZ2DqT6hoYgmpru4Dau2k=
X-Gm-Gg: Acq92OFyixi2NWe/iib0Fxul2c3jUmvVRmeMtZnGy5SNfzocx7JuQtKmBFU0vtcuXCk
	MxZ2YrM7e9TjC9hGUzUJeN9aDiFIuI5+0b3Tck7Y3jStzGBIMZhMYpkzWD0O1gRhJIZ0hpLfIiX
	TiDt9l99gKLvOVwUVXWG7JWBTzafSoo4EPQU9ytcPt8AqpnoBRFZ/hjIVu8xJOdGc3nIwTfSSSN
	cWjjXidTieEALKhy/iGh3KYpkk1gUpSasTVlvrVgue+CZwVpsqRfuZRqvKlMwFlvD7XsllH4VRK
	pO36bUYhB4kIbC/uLEFDtbgQfae4Sf77qTWliolZHA==
X-Received: by 2002:a17:906:5189:20b0:bba:3cf3:2ba6 with SMTP id
 a640c23a62f3a-bd51792d9a8mr345197866b.29.1778956485351; Sat, 16 May 2026
 11:34:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-10-joannelkoong@gmail.com> <CAOQ4uxiWhWcNbKDo49vWR7HrN4p84JdvjgYyhptDqKxJ7dwoFQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiWhWcNbKDo49vWR7HrN4p84JdvjgYyhptDqKxJ7dwoFQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 20:34:34 +0200
X-Gm-Features: AVHnY4KM_UYWGkCV7hpeo2SVsVDZihlJ0eWCpAhlykTywHL2JEoqXL8puvwMmuM
Message-ID: <CAOQ4uxgOi=2Pk=-cJukZhoz4Jz9y9tvnoauTs-6teEfXU6i9Rw@mail.gmail.com>
Subject: Re: [PATCH v2 09/21] fuse: handle partial io passthrough for
 read/write, splice, and mmap
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 6:57=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Sat, May 16, 2026 at 2:52=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Servers can now pass through only reads or writes instead of being
> > required to pass through both. When the read or write operation is not
> > passed through, fall back to direct io for handling it. This avoids
> > cache coherency issues from mixing the backing file's page cache with
> > the fuse inode's page cache.
> >
> > Reject mmap when passthrough is partial or not set for read/writes sinc=
e
> > mmap requires both read and write access to the backing page cache.
> >
> > The FOPEN_DIRECT_IO check in the read/write fallback is not strictly
> > needed as the caller already handles it, but including it here makes
> > the fallback logic self-contained.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/file.c        |  7 ++++---
> >  fs/fuse/fuse_i.h      |  3 +++
> >  fs/fuse/passthrough.c | 18 ++++++++++++++++++
> >  3 files changed, 25 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 1173811b2ea7..5b70d8272700 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -1781,7 +1781,7 @@ static ssize_t __fuse_direct_read(struct fuse_io_=
priv *io,
> >
> >  static ssize_t fuse_direct_IO(struct kiocb *iocb, struct iov_iter *ite=
r);
> >
> > -static ssize_t fuse_direct_read_iter(struct kiocb *iocb, struct iov_it=
er *to)
> > +ssize_t fuse_direct_read_iter(struct kiocb *iocb, struct iov_iter *to)
> >  {
> >         ssize_t res;
> >
> > @@ -1796,7 +1796,7 @@ static ssize_t fuse_direct_read_iter(struct kiocb=
 *iocb, struct iov_iter *to)
> >         return res;
> >  }
> >
> > -static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_i=
ter *from)
> > +ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *fr=
om)
> >  {
> >         struct inode *inode =3D file_inode(iocb->ki_filp);
> >         ssize_t res;
> > @@ -1884,7 +1884,8 @@ static ssize_t fuse_splice_write(struct pipe_inod=
e_info *pipe, struct file *out,
> >         struct fuse_file *ff =3D out->private_data;
> >
> >         /* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> > -       if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIREC=
T_IO))
> > +       if (fuse_passthrough_op(file_inode(out), FUSE_WRITE) &&
>
> Removing fuse_file_passthrough(ff) makes me uncomfortable.
> It's true that if server sets PASSTHROUGH_OP_WRITE on lookup
> the file has to be opened with FOPEN_PASSTHROUGH, but this
> not easily understood by passing by reviewers.
>
> It's be nicer if we keep this logic contained in a helper where it can be
> properly documented, something like this (following the changes to
> FUSE_PASSTHROUGH_OP() discussed earlier):
>
> static inline u64 fuse_passthrough_op(struct inode *inode, u64 op_mask)
> {
>         struct fuse_inode *fi =3D get_fuse_inode(inode);
>         struct fuse_backing *fb =3D fuse_inode_passthrough(fi);

This needs to be:
         struct fuse_backing *fb =3D fuse_inode_backing(fi);

so the helper will work correctly whether the backing inode was set on
lookup (long lived) or on open.

>
>         return !fb ? 0 : fb->ops_mask & op_mask;
> }
>
> static inline struct file *fuse_file_passthrough_op(struct file *file,
>                                                     u64 op_mask)
> {
>         struct fuse_file *ff =3D file->private_data;
>
>         /*
>          * FOPEN_DIRECT_IO can be used to opt-out of passthrough per file=
 and
>          * ops_mask can be used to opt-out of passthrough per operation t=
ype.
>          */
>         return fuse_file_passthrough(ff) &&
>                 !(ff->open_flags & FOPEN_DIRECT_IO) &&
>                 fuse_passthrough_op(file_inode(file), op_mask) =3D=3D op_=
mask;
> }
>
> ...
>
> static ssize_t fuse_splice_write(struct pipe_inode_info *pipe, struct fil=
e *out,
>                                  loff_t *ppos, size_t len, unsigned int f=
lags)
> {
>         if (fuse_file_passthrough_op(out, FUSE_PASSTHROUGH_OP_WRITE))
>                 return fuse_passthrough_splice_write(pipe, out, ppos,
> len, flags);
>         else
>                 return iter_file_splice_write(pipe, out, ppos, len, flags=
);
> }
>
>
> > +           !(ff->open_flags & FOPEN_DIRECT_IO))
> >                 return fuse_passthrough_splice_write(pipe, out, ppos, l=
en, flags);
> >         else
> >                 return iter_file_splice_write(pipe, out, ppos, len, fla=
gs);
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 9e5142a94a09..a1034533ce60 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -1261,6 +1261,9 @@ struct fuse_file *fuse_file_open(struct fuse_moun=
t *fm, u64 nodeid,
> >  void fuse_file_release(struct inode *inode, struct fuse_file *ff,
> >                        unsigned int open_flags, fl_owner_t id, bool isd=
ir);
> >
> > +ssize_t fuse_direct_read_iter(struct kiocb *iocb, struct iov_iter *to)=
;
> > +ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *fr=
om);
> > +
> >  /* passthrough.c */
> >
> >  /* READ/WRITE are implied by FOPEN_PASSTHROUGH, but defined for comple=
teness */
> > diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> > index f2025772c9c1..d62a1c751157 100644
> > --- a/fs/fuse/passthrough.c
> > +++ b/fs/fuse/passthrough.c
> > @@ -44,6 +44,10 @@ ssize_t fuse_passthrough_read_iter(struct kiocb *ioc=
b, struct iov_iter *iter)
> >         if (!count)
> >                 return 0;
> >
> > +       if ((ff->open_flags & FOPEN_DIRECT_IO) ||
> > +           !fuse_passthrough_op(file_inode(file), FUSE_READ))
> > +               return fuse_direct_read_iter(iocb, iter);
> > +
> >         ret =3D backing_file_read_iter(backing_file, iter, iocb, iocb->=
ki_flags,
> >                                      &ctx);
> >
> > @@ -70,6 +74,10 @@ ssize_t fuse_passthrough_write_iter(struct kiocb *io=
cb,
> >         if (!count)
> >                 return 0;
> >
> > +       if ((ff->open_flags & FOPEN_DIRECT_IO) ||
> > +           !fuse_passthrough_op(inode, FUSE_WRITE))
> > +               return fuse_direct_write_iter(iocb, iter);
> > +
> >         inode_lock(inode);
> >         ret =3D backing_file_write_iter(backing_file, iter, iocb, iocb-=
>ki_flags,
> >                                       &ctx);
> > @@ -91,6 +99,9 @@ ssize_t fuse_passthrough_splice_read(struct file *in,=
 loff_t *ppos,
> >         struct kiocb iocb;
> >         ssize_t ret;
> >
> > +       if (!fuse_passthrough_op(file_inode(in), FUSE_READ))
> > +               return copy_splice_read(in, ppos, pipe, len, flags);
> > +
> >         pr_debug("%s: backing_file=3D0x%p, pos=3D%lld, len=3D%zu, flags=
=3D0x%x\n", __func__,
> >                  backing_file, *ppos, len, flags);
> >
>
> I understand why you brought this "jump back to direct" into the passthro=
ugh
> helpers to reduce complexity in the call sites, but I think that if you u=
se
> the fuse_file_passthrough_op() helper in the call sites code will look
> better and will not need to "jump back to direct io" in passthrough.c.
>
> > @@ -133,6 +144,9 @@ ssize_t fuse_passthrough_mmap(struct file *file, st=
ruct vm_area_struct *vma)
> >  {
> >         struct fuse_file *ff =3D file->private_data;
> >         struct file *backing_file =3D fuse_file_passthrough(ff);
> > +       struct inode *inode =3D file_inode(file);
> > +       struct fuse_inode *fi =3D get_fuse_inode(inode);
> > +       struct fuse_backing *fb =3D fuse_inode_backing(fi);
> >         struct backing_file_ctx ctx =3D {
> >                 .cred =3D ff->cred,
> >                 .accessed =3D fuse_file_accessed,
> > @@ -141,6 +155,10 @@ ssize_t fuse_passthrough_mmap(struct file *file, s=
truct vm_area_struct *vma)
> >         pr_debug("%s: backing_file=3D0x%p, start=3D%lu, end=3D%lu\n", _=
_func__,
> >                  backing_file, vma->vm_start, vma->vm_end);
> >
> > +       /* mmap requires both read and write passthrough */
> > +       if ((fb->ops_mask & FUSE_PASSTHROUGH_RW_OPS) !=3D FUSE_PASSTHRO=
UGH_RW_OPS)
> > +               return -ENODEV;
> > +
>
> Changing the helper in call site in nicer and already hits the
> existing ENODEV case:
>
>         if (fuse_file_passthrough_op(file, FUSE_PASSTHROUGH_RW_OPS))
>                 return fuse_passthrough_mmap(file, vma);
>         else if (fuse_inode_backing(get_fuse_inode(inode)))
>                 return -ENODEV;

This could technically be relaxed to:
          else if (fuse_passthrough_op(inode, FUSE_PASSTHROUGH_RW_OPS))
                 return -ENODEV;

However, I should note about this sketch patch that the condition for
fuse_passthrough_mmap()
is that both read/write are passthrough and the condition for ENODEV
is that either read/write are passthrough but looking at this code it is
not at all clear to the reader.

Because if there is no read/write passthrough, (only GETATTR passthrough)
there is not really a reason to prevent fuse page cache mmap.

See similar comment I made regarding fuse_file_cached_io_open() on the
documentation patch.

Thanks,
Amir.
