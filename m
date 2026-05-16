Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA7D405C53
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778950658; cv=pass; b=BK7IS7TU5kIRpeey+H6v8Ndf/n6v5827qG/qq7w3kXl0nlP0d/Or23KOTeJ40R9S8SZzFt4B8M0VBRfR+aqnRookAKfQ5cgr/3nnclNh7CzaSjpORqVQQLcLQ9q/zXJq7Dt1Oy+k5nqSe+nWnKpZnrNQ6Fy0IFCwv4/y4O67Aq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778950658; c=relaxed/simple;
	bh=+7ZscICOnsMg+Y/x07Y7dz+QrxTCTQGbuuqMet8Uk5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oo73aTgUtFILWBhT0uvrJn/UhiMICwo5clmgLJQckuoPF+W/TcBSN7iRIPJiPueuBnRQ4ggbtGnU2lQ5GaVBWJN0+8yHizH4HmVn1XtnbGhmxQxYMjxiSk1HSJ043pbL/UUWW2O6BqKgfFIrugHQJm1gmRn4IGWbUXLNfhMooIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d5BBmdWL; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5BBmdWL"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bcceb394417so111647466b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 09:57:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778950655; cv=none;
        d=google.com; s=arc-20240605;
        b=Nql/BqvSi8fgSugpjCqiHhN0mVGRH4xf8+bRpgSKnm3IwONmZE3IFOi48ozonkNRrt
         QbHjUmh8cF7CjyxwP1ojWiXy7+dzdYlNq7+0PtNc/rQQWBo4Lxz4d/sFVsNuWmgGPKhZ
         R+uHoeEsePhD3D4oaRxtqiHGFPVxy1DxMZ0+ov3ouxqnQK+VbRDRusOJ9D884kTf55HC
         /ZFdL8k7ZvLmQn6/nqmoDeKgl9lAuSmWkpZ/20KbpoduA6ylxCjtV24eumzOJ8MeELSZ
         t9xAOrtPZzflMDZamqlHcvkVfth+4lMhhw5uNS1wb5ukMsvvwivl+Jk2tXh3ajSUhJRl
         kQfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PfYU55dN3cL0mcrAM/l2zUvNj113szEXNq9Oi0BW8EQ=;
        fh=7aqEGnoBdqlYa9fyiovk3gc+EEZsxUyKAL6frZAPOHw=;
        b=PIXJSTHnT0BsXVF9hIpEXaHVuUmUP4DzRm9xRdS82au4CB9xe9os8bHKGPjtsbxdBb
         hq3FDuZbkipienxFbxocnsPRa9OcbORouQPnRE2ocWz85hM2gLRgUQ+HFhpVk/KXsOvq
         XEO4ZVHe5qBjOBDEO6jPyIlNPZ1fS18++jzyDLW9e5i6GNnBs6nWIgMS7fJuwmp5jFE3
         CrLEg8PWZ7nodOmqD52kIUcdcRNTcVcqXMKViVOJdTxwBVBxSCcDVEOrb7K8KcM8Z/TG
         GiUg28rwZ46ZtO2SxdWyoWDzWGdSfftbpzjqNxq7E8yGIPMeQJBLO+XoQ3pGK/wMDRkn
         2XRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778950655; x=1779555455; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfYU55dN3cL0mcrAM/l2zUvNj113szEXNq9Oi0BW8EQ=;
        b=d5BBmdWL6d5OtijzJvg4oDfUPvbW5+TsrMX/u/ELR/+bB0M9tl5Bbx3GSr/fOpQ4ZG
         8vt6RqQiRSeqbaiJPJ41JaiAPk1sszX7lIKU1XbARO7kPMU/JkiJkQw/IKXl+WHF5x1c
         qhRH1y3fDhOFZDHKaE1GkCrHoIIRrGGLVAKWxkdlEAnIL4jIR+elklmusV7tvSHAvijs
         dj2yovc5jfhTqDD5EkH+lmKS5r/+8UwinnMOwBlLr4tb51Iwjltw8xx/TrgX40pybQ07
         l3wlxsOD7U4WUHPXDDpp60f6EUkdXr76er4/EtviA9aNJRLlek6IE+ax+hXCPd59Tyei
         WVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778950655; x=1779555455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PfYU55dN3cL0mcrAM/l2zUvNj113szEXNq9Oi0BW8EQ=;
        b=nPHPq/hLIuqRhQPRK3BWkvK3xrUDqvhJWMHYzOlgtE3pXzr4VSd6//ViwifSFjHQMA
         9tUo5h8QvnE8tmfBUOokvpwgLNgdW/Tg12ys42VVYCQXOegczn1AwlrJZtzElJ+2dUY+
         QZcdDl4qi63SqXvs/w1s9l6326HAF3jW9w8dxX+JjCxSNeLIuFG9RacXyiqA4lQ2RkDf
         d4A33Yt9L1Qur8/LbTKTGVec+jscn/k6RHtS/f07G+ZYkhwLIeX9l2REEWAp7qMHLVXq
         ++j6HuMXbXe0qhEwscUabJfGwdnVwBveXrfxd14ujSC+rRYK+Xl0C/Jb+voKJhfg8sPm
         Gapw==
X-Forwarded-Encrypted: i=1; AFNElJ/UsWZwHSNDFZzLruz6R/R0JnKkY4xea5MrroTgNqKM4bq6sDxDGSFXQAQTAXeB7VIc7JnbkeGpuPXsrrce@vger.kernel.org
X-Gm-Message-State: AOJu0YxUS1F3j2fsTX4lvmneGYjdtXiuarK3svB+gTymz3007cIchDMY
	fRJ//lfQs4TbEeH6atBTGuf2mVoJ/QQpJdU5DNBdOXQGF1FYK1YsYkckuLAtcpgvUwJybBw3nYe
	utPIUw5d9/wgoSTUUpKEzIreL9LPYU1Bb1cvdc3U=
X-Gm-Gg: Acq92OEvaw/km+ArsR84RBZb9OXZ1PKX1dCvBaazDX3UAcqPjgTuCtxtFFCTOmsX3m0
	1MLfhYkPeeguS5qFPda/HxTz/uLat/1tZNjP4k+DgjlogkGbxkUvtFDzekwUL5OofZp3ovLCd6Z
	rpzUvDnIXnW1vY6rQwfeZW90oX3aQ0Mn1DwDlB88lIpYWlmMHjipiHqsheVmVWBqW0iFVp+7y8/
	9cuQamGaTpixsHqYA33SFVTt2Pl+H4nrtf+4A9/xynzDUaI0HUN6ljogOxm3o/qYvtWedD0FmPO
	hz8HtXBe1ksp5IrFYScmxcJM010ErgSQEQf0Ux6BKabXOEjqK03b
X-Received: by 2002:a17:907:d30e:b0:bd5:5834:1d36 with SMTP id
 a640c23a62f3a-bd558341eb3mr240215066b.21.1778950655055; Sat, 16 May 2026
 09:57:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-10-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-10-joannelkoong@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 18:57:24 +0200
X-Gm-Features: AVHnY4K3xOPnY5KV7Cu7pzd-w0DD74SL0JwhfZbdHZi86GE-hR3VwAaWcwTfaws
Message-ID: <CAOQ4uxiWhWcNbKDo49vWR7HrN4p84JdvjgYyhptDqKxJ7dwoFQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/21] fuse: handle partial io passthrough for
 read/write, splice, and mmap
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:52=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Servers can now pass through only reads or writes instead of being
> required to pass through both. When the read or write operation is not
> passed through, fall back to direct io for handling it. This avoids
> cache coherency issues from mixing the backing file's page cache with
> the fuse inode's page cache.
>
> Reject mmap when passthrough is partial or not set for read/writes since
> mmap requires both read and write access to the backing page cache.
>
> The FOPEN_DIRECT_IO check in the read/write fallback is not strictly
> needed as the caller already handles it, but including it here makes
> the fallback logic self-contained.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/file.c        |  7 ++++---
>  fs/fuse/fuse_i.h      |  3 +++
>  fs/fuse/passthrough.c | 18 ++++++++++++++++++
>  3 files changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 1173811b2ea7..5b70d8272700 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1781,7 +1781,7 @@ static ssize_t __fuse_direct_read(struct fuse_io_pr=
iv *io,
>
>  static ssize_t fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)=
;
>
> -static ssize_t fuse_direct_read_iter(struct kiocb *iocb, struct iov_iter=
 *to)
> +ssize_t fuse_direct_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  {
>         ssize_t res;
>
> @@ -1796,7 +1796,7 @@ static ssize_t fuse_direct_read_iter(struct kiocb *=
iocb, struct iov_iter *to)
>         return res;
>  }
>
> -static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_ite=
r *from)
> +ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from=
)
>  {
>         struct inode *inode =3D file_inode(iocb->ki_filp);
>         ssize_t res;
> @@ -1884,7 +1884,8 @@ static ssize_t fuse_splice_write(struct pipe_inode_=
info *pipe, struct file *out,
>         struct fuse_file *ff =3D out->private_data;
>
>         /* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
> -       if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_=
IO))
> +       if (fuse_passthrough_op(file_inode(out), FUSE_WRITE) &&

Removing fuse_file_passthrough(ff) makes me uncomfortable.
It's true that if server sets PASSTHROUGH_OP_WRITE on lookup
the file has to be opened with FOPEN_PASSTHROUGH, but this
not easily understood by passing by reviewers.

It's be nicer if we keep this logic contained in a helper where it can be
properly documented, something like this (following the changes to
FUSE_PASSTHROUGH_OP() discussed earlier):

static inline u64 fuse_passthrough_op(struct inode *inode, u64 op_mask)
{
        struct fuse_inode *fi =3D get_fuse_inode(inode);
        struct fuse_backing *fb =3D fuse_inode_passthrough(fi);

        return !fb ? 0 : fb->ops_mask & op_mask;
}

static inline struct file *fuse_file_passthrough_op(struct file *file,
                                                    u64 op_mask)
{
        struct fuse_file *ff =3D file->private_data;

        /*
         * FOPEN_DIRECT_IO can be used to opt-out of passthrough per file a=
nd
         * ops_mask can be used to opt-out of passthrough per operation typ=
e.
         */
        return fuse_file_passthrough(ff) &&
                !(ff->open_flags & FOPEN_DIRECT_IO) &&
                fuse_passthrough_op(file_inode(file), op_mask) =3D=3D op_ma=
sk;
}

...

static ssize_t fuse_splice_write(struct pipe_inode_info *pipe, struct file =
*out,
                                 loff_t *ppos, size_t len, unsigned int fla=
gs)
{
        if (fuse_file_passthrough_op(out, FUSE_PASSTHROUGH_OP_WRITE))
                return fuse_passthrough_splice_write(pipe, out, ppos,
len, flags);
        else
                return iter_file_splice_write(pipe, out, ppos, len, flags);
}


> +           !(ff->open_flags & FOPEN_DIRECT_IO))
>                 return fuse_passthrough_splice_write(pipe, out, ppos, len=
, flags);
>         else
>                 return iter_file_splice_write(pipe, out, ppos, len, flags=
);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 9e5142a94a09..a1034533ce60 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -1261,6 +1261,9 @@ struct fuse_file *fuse_file_open(struct fuse_mount =
*fm, u64 nodeid,
>  void fuse_file_release(struct inode *inode, struct fuse_file *ff,
>                        unsigned int open_flags, fl_owner_t id, bool isdir=
);
>
> +ssize_t fuse_direct_read_iter(struct kiocb *iocb, struct iov_iter *to);
> +ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from=
);
> +
>  /* passthrough.c */
>
>  /* READ/WRITE are implied by FOPEN_PASSTHROUGH, but defined for complete=
ness */
> diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
> index f2025772c9c1..d62a1c751157 100644
> --- a/fs/fuse/passthrough.c
> +++ b/fs/fuse/passthrough.c
> @@ -44,6 +44,10 @@ ssize_t fuse_passthrough_read_iter(struct kiocb *iocb,=
 struct iov_iter *iter)
>         if (!count)
>                 return 0;
>
> +       if ((ff->open_flags & FOPEN_DIRECT_IO) ||
> +           !fuse_passthrough_op(file_inode(file), FUSE_READ))
> +               return fuse_direct_read_iter(iocb, iter);
> +
>         ret =3D backing_file_read_iter(backing_file, iter, iocb, iocb->ki=
_flags,
>                                      &ctx);
>
> @@ -70,6 +74,10 @@ ssize_t fuse_passthrough_write_iter(struct kiocb *iocb=
,
>         if (!count)
>                 return 0;
>
> +       if ((ff->open_flags & FOPEN_DIRECT_IO) ||
> +           !fuse_passthrough_op(inode, FUSE_WRITE))
> +               return fuse_direct_write_iter(iocb, iter);
> +
>         inode_lock(inode);
>         ret =3D backing_file_write_iter(backing_file, iter, iocb, iocb->k=
i_flags,
>                                       &ctx);
> @@ -91,6 +99,9 @@ ssize_t fuse_passthrough_splice_read(struct file *in, l=
off_t *ppos,
>         struct kiocb iocb;
>         ssize_t ret;
>
> +       if (!fuse_passthrough_op(file_inode(in), FUSE_READ))
> +               return copy_splice_read(in, ppos, pipe, len, flags);
> +
>         pr_debug("%s: backing_file=3D0x%p, pos=3D%lld, len=3D%zu, flags=
=3D0x%x\n", __func__,
>                  backing_file, *ppos, len, flags);
>

I understand why you brought this "jump back to direct" into the passthroug=
h
helpers to reduce complexity in the call sites, but I think that if you use
the fuse_file_passthrough_op() helper in the call sites code will look
better and will not need to "jump back to direct io" in passthrough.c.

> @@ -133,6 +144,9 @@ ssize_t fuse_passthrough_mmap(struct file *file, stru=
ct vm_area_struct *vma)
>  {
>         struct fuse_file *ff =3D file->private_data;
>         struct file *backing_file =3D fuse_file_passthrough(ff);
> +       struct inode *inode =3D file_inode(file);
> +       struct fuse_inode *fi =3D get_fuse_inode(inode);
> +       struct fuse_backing *fb =3D fuse_inode_backing(fi);
>         struct backing_file_ctx ctx =3D {
>                 .cred =3D ff->cred,
>                 .accessed =3D fuse_file_accessed,
> @@ -141,6 +155,10 @@ ssize_t fuse_passthrough_mmap(struct file *file, str=
uct vm_area_struct *vma)
>         pr_debug("%s: backing_file=3D0x%p, start=3D%lu, end=3D%lu\n", __f=
unc__,
>                  backing_file, vma->vm_start, vma->vm_end);
>
> +       /* mmap requires both read and write passthrough */
> +       if ((fb->ops_mask & FUSE_PASSTHROUGH_RW_OPS) !=3D FUSE_PASSTHROUG=
H_RW_OPS)
> +               return -ENODEV;
> +

Changing the helper in call site in nicer and already hits the
existing ENODEV case:

        if (fuse_file_passthrough_op(file, FUSE_PASSTHROUGH_RW_OPS))
                return fuse_passthrough_mmap(file, vma);
        else if (fuse_inode_backing(get_fuse_inode(inode)))
                return -ENODEV;

Thanks,
Amir.
