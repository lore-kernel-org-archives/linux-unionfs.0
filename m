Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1CE3909A2
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 21:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140832; cv=pass; b=eCOMp5Z5pLIpCK3ckzLDJQvfHBJ6nH9VtFuRYv0Nq98/P2fTyyYolvGwT00xCifI2Ep3bjvPCf4aQS1F/62Kj6HWbWQsrCvbcPL780xsB3qkv0ZhLKSicGvVC5J9FBC8Ah3/Z5pkhzM/m8HNi2ZH80IWD2B5Pn05TpQ/+Hq/JqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140832; c=relaxed/simple;
	bh=OY1LGZuAne/ttZOqVsgdrPWOG6mpd8nKzYGZi6Su5Qk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=chiuxmVQrVWMdMydvk1/VvVuOUz9D+0zr7WOuVZfAh9kKJGpzdcYQJ93ma6rIwRGid4eU7CN0kyYUAC/s4N8VZCdLRvxHBHFfZXEo3eE1j8kFNjEIntMeFIk9l3gm65eqShZGN4gtDeBOkO14Ts61vQG8D6ZRb0PA6CXtHglU98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJ05gX5l; arc=pass smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJ05gX5l"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48fe26a177cso20060675e9.1
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 14:47:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779140829; cv=none;
        d=google.com; s=arc-20240605;
        b=gnLlll87UvjymrczG1Pkb1XnuwLbWLYQ33a/cMyR55cSKXAg8fT2V8IfjRtqRYzMPI
         MDBTqzuaBYpjRzuXlfMYLelwLLcSh9d+pg9JVOeBzFzohcYkXG5AFThDPiFBtgrIa8m2
         eap6s3HrHsQz9i0HMwShQ6ClQAhoNjTPg1eYCqkn+L325tcLb6BHre+1f84/kq7ymlbv
         gy9ryTdEqOMe8Q0QFi0GzBVWIg5wfGeRiGWDWa7d1fi6HjrsSZrO8Pr1gU4bRxLO1IFV
         RnjdArdVwtaJrtqwtydeOxb8NPWjcorVFJ9D9+dI8bbZ4FI7L+SBCc+y7UVVnF04NLo9
         9Vnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Tb4jwIrvXEfmivbrAt8FUhUrHOIoIXB0SrNmJuX9+vc=;
        fh=UR33J7LPAHVV2L2vCehrcAzt5NRM5ZSfrheIeEnv1jE=;
        b=aCoG3vkjTtOwaatObl+GRY7p1ykaJ3voCJuYTbHNLIgH+lFsTMX0agmmk/K4WkKEHo
         hXXgKe75efLQCnuuXNEig6Ng9Z25NYo0jlms6+PnWsji34SYZVSIzj95IdqVQDtJN4qb
         NEsMTzn4dbveUPDyCBb6mxiCdfhjMwNQo2yi1mRZ729+p6XreoH/30J7MKVLCdDs4zOc
         6bqKEoCkklNOAN1a6j0deeBr33PVIXwK0kMOiM/jMazOfeso7i/A4/xIns8Mx2VybDTL
         VkMQuFHQojuTwLPC3xf0kpHd9FqKExtyQT0i9NGeSrXzi7qqxzoSQi4qsM2XQj+jXyrC
         AJ+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779140829; x=1779745629; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tb4jwIrvXEfmivbrAt8FUhUrHOIoIXB0SrNmJuX9+vc=;
        b=FJ05gX5lPob3RMFW9KMM/+vTrmj3abutfiaNveRCr9xx8Y/YX8tA5LDt+390DHWlwb
         iESYanFpwxoIsH6nRYa+YYBYOSQ8s4qBZnMOgDKHU3yaG6z7iKd5UjuhF/W5VWDnCsCh
         g8fx3v3PiYIfYqSbJmmBkaeLUoZ+b/cNC+pWwOZWWeH+n2efUX/kKfe5IXUz7awBPJ8Q
         eqUwVsZnbDM0rxYNWR+oUjU+VNqMKBmz+NJ0z0+ZNPutqOo9hgtu9YYS/8WOx+tNYF9r
         xDbSREM8qMrJmitr+Bvpr7I8ptGDaeNCv4S3bSdn1jzbi/uemnx3MBovWB0xOuJoHcWf
         qGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779140829; x=1779745629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Tb4jwIrvXEfmivbrAt8FUhUrHOIoIXB0SrNmJuX9+vc=;
        b=V98XvDQIcaGOJIbVbvceBKakhI3Kz5WSJmpAeYxOvPZTpDsK2rBRDQsAQAVl5lN3yx
         F0JJCx0LL+gnWSCU1eprqY1Pw41Z7fYo82GrLGgFrqaQKagldvXOLQ57tZVQ4gxRp8ZR
         x4+r9Nhd23C3IXVt8uPu/4D7FisssB6N0rsdkzbXNocZ9MbaLHQV1lagKY6d/sRZUcrO
         +AVgw7zIgy7QpP+r98vV/aTrLL6v209yGollDeoz7WNDO/NgWQd58WZEVsuQChBtuMrr
         vqAT93h2SPYu5BjJcoBq2UjtrRl2RBA4U04LYoN1OQkP7Hjn6ct+IftzQXXD26heagTh
         MIrA==
X-Forwarded-Encrypted: i=1; AFNElJ8dfYnbEVtCEnvjieKxQCo3Jb3X1D3uOyjTsBJvrh6I/DlmrfuUKernjfLkymmI2fSzpR2Au1PsMy2q9Vp3@vger.kernel.org
X-Gm-Message-State: AOJu0YwUu9OftqVlsVVDb5QvlOKivtjGxxHASBwso/6lu9LxtYy0WE2A
	ngVKQ366ffqMNx9krDwHdLy9No+YWo/OGm+2gdvfYKbqcVS/4fSb6v5PTCuYW1oSKlsdhDMQxBq
	KNsL0XHLlPPaRLXyry1U0tjpohMX71Ck=
X-Gm-Gg: Acq92OHD3btUSIbeJDw6gpLnvGAuYhfZ7zmP61UWAKiPXp5oD09RYp01J4sgQf2xvW/
	3sHS8xJcIWmYw4aOFdcAmwn1nWry0ESLLrCno+0FXaS5zLyDtQoawIsN7YEW7hdkMfL97e8IzNc
	mA7b6+Gy0fEh5s3CB21Z6McZSNMZzhtbTsYxYJE37dbEvfZI+3Lrpmsmvw98Dhbrt21RKooPT45
	VDX1L31nAWZA8FfCNK2mTPxgcRYBEtUISCq576KqZGQuSAtZQH5ArrfDtVVWhzplOgBy7tDa8XQ
	gQ1Qdw==
X-Received: by 2002:a05:600c:1f8c:b0:489:1f08:91b with SMTP id
 5b1f17b1804b1-48fe6323821mr238437935e9.16.1779140829247; Mon, 18 May 2026
 14:47:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-10-joannelkoong@gmail.com> <CAOQ4uxiWhWcNbKDo49vWR7HrN4p84JdvjgYyhptDqKxJ7dwoFQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiWhWcNbKDo49vWR7HrN4p84JdvjgYyhptDqKxJ7dwoFQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 May 2026 14:46:56 -0700
X-Gm-Features: AVHnY4LQKjP58QgTZkfeo4R1Nu0RNE760N945uS4a9WMgKahADc-ARjjyoCiboM
Message-ID: <CAJnrk1YuibfSkYqR7h15K1S_D1ZY=P3rwTix01ujMSDfFFpNQQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/21] fuse: handle partial io passthrough for
 read/write, splice, and mmap
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 9:57=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
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

I really like all your suggestions, Amir. I agree that this looks much
nicer. I'll incorporate this into v3.

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

Nice! This looks a lot cleaner.

Thanks,
Joanne
>
> Thanks,
> Amir.
