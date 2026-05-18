Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426E444B683
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 12:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108740; cv=pass; b=CuGg16L7NdeVBf2Zo95RgluBQP/p+RukEW0fzkcskcAZl9lG3NAHaUpypRJloODfhwxuhu+dBK0Y2eflmXtxJy2Ow3eE1iYA8Nr8VTfFoxpTrG5/Zt6Ooxuve925T6DXmhaDAusX2Es4RBmbiRsB6fE+K25Ccr8fUVOJSVx+fI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108740; c=relaxed/simple;
	bh=QqsnQODjb1vVOQmMAFQqT/jpb6GsqIMTyoCosB3DobQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yq552Cil6tDWZ4TrT0tZPIfML43yRfyedPAya9fEAO/G8q5aXg4w4Y8jZjx+8og6mlubJUVt9oZffW1umAUW5CgpohK/oXbUhUXB1vezdvivO1ltD/us0ogv0VGXisFn1nbA0mwnGwqHVKM17wnAYevC3e63JIHYn5zjnzOQAVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UPG97xMT; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPG97xMT"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bd4f81505ccso361867466b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 05:52:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779108738; cv=none;
        d=google.com; s=arc-20240605;
        b=asMr6V2wYqlFCb35NtOvtW2ngUXO0QKoQhhOy9OhylIQpVtgYx22EsZbRqyH4eoR01
         NyNBPWk0f/hqlo3JXLqPKyq989V3C6fALO2XaXK48fpTv7Sw30ffcOujPQ+bv1go8WEV
         ySq2dVcb9Vm/s1h0C97H1UuSAjTGslFVugKzzTo2J5EdilKestVrYDjxVujZenzwFWdB
         zICxHaKyl4Bs6UQ02XyBg5yj/2wPQ9CxZoOERcw3diJSsTJVuubH/yrl5+RYFGxlvaG8
         ypHQ0f5/4VTp1o94j8lAmOW1QPQR5RBniOAzHMgVe+L1p4SS6F5c+22UhSIllc56plIw
         ROfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uk0jN7fHjAJcSWGQmqxwe93wJ3rBUwrzkL1tnsgo/iY=;
        fh=S3fCByddG8S87rHAYFcCLERXVMKOcEHKTXRiBs3f9LY=;
        b=iIeI3mFg+eIvCvrkVTnqSeg1OWGDXC5pS/6mQU5W8DAXyTcA/fEyh02Mr+4TUccqzZ
         qCm0O++YvRn9JUiKhsJAhNDxTSL6mPDSNKJoIMZPM6DG7qQG7HTluWR722ENy6/iCnp7
         310UqO054PWkJ8LRejTXV3yZl2/jmO64TKnYbXe2F7QPrJIl/bw9kt7iekZ2Yvc58HwX
         VVmSL4DPOFIQzJoDTqHoZp5EnNxOLyZt2WY7vHyz1Jg8KTpuxsrIlyliNxhX1aBnSwm2
         wQEFk2VvWjhOZ02JmgJOH5WawzYtSzX+2A6VHPyIzyr44OMICbvOdzYo4GmDEOyDwD3X
         nw+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779108738; x=1779713538; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uk0jN7fHjAJcSWGQmqxwe93wJ3rBUwrzkL1tnsgo/iY=;
        b=UPG97xMTPq9UQO0AsWZxb4L/3xvgBii13vovLD2cXcvO9ib1P/h+eeWNxb3jHzm5vH
         zEx4w8+yfR/MYJqZ+oVsxPaHemKLhViMYV/7T5S8Rw3zqASmgNW63ULo+Fd2ZxPW6erI
         FCCuYVCZkwfV0otduUhzLi42ApGJwwE7FeIezDJ9HpqeMDFyi1T4MoEQjnd1zBMhGFY9
         UMaL76Z+Dz4Hf54iVrtD4PQZjgEgC50l8usc5EVOlBWWMOn3dTEcWsVwfKC3DrOoOVhw
         vIbMn66Mn5zP0FNPXg/yd2ESiLrlZlMZ19MgZgmwlyg08ZzbSNgTqQ502CFdE+tCQRKh
         stLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779108738; x=1779713538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uk0jN7fHjAJcSWGQmqxwe93wJ3rBUwrzkL1tnsgo/iY=;
        b=cxVMb5dkssbbhiWZjk84BZrMSp/RJNKdJWYOCuEDKVkEW4gbGA50eKWL14zE/Y2n2E
         jNqrCXVzcFihNfMTYiVHJDhUMthBfTRpJRiYf6tp8O5YUdrC3eZjXJ93TLrcL6bjztbv
         wTf2HwCfsHwwdJ/BIs66fGIxLgSVZvzG9Uh3jmfbPl2qeoB2cxvdqfya6uWS55z0XLN0
         U9Qda8o4B9wfVu5+fELoaE9jRNuISQQlkU5QowgWK3ioh4XMfIF6CbHpBf20uR/ou1+q
         Asextejme9a3Dbim3huHTA+m/gejh6xXt69H6/s3Xs57b88QfUVXRge5UzmgEDhPIyos
         PXmg==
X-Forwarded-Encrypted: i=1; AFNElJ+MmojtFzUGnXTYRszeTPOpoJohewZjHSvmLFxyX0IfJbnJkYsyw2z6/f560qmq8g+7+VKq5gpkqoYCYA2m@vger.kernel.org
X-Gm-Message-State: AOJu0YwE67QjIxs+okMF7/SvxEkdCYkNSOEQinKMgw9eBE+Mcqi93JZG
	zXF68YnGVoJidqO/msHsOzywygfXzZ1TdKJT4wPqPL41RDoXxWcOSbZYDm6C8hQEQrksbkDd/o/
	v4rHVaj8bj9obU/VFkd2inRktWgtJeQWSmCdr9C0=
X-Gm-Gg: Acq92OFb+bmB40kx9XeYjbGk+yX6KyGPlA8tQ5G4WGz+ldOIuI/j3+eT41DtlnpPtbu
	8gzaO5jwF8fPJ7xCoaXF5KfPVGyiaM+kvoMj7EQ8v1DRhULyU0yd9BNupwZXu+gPkXyKAKJYkbk
	CyC4LkIEXt0OqRMh0I4sLE9MtQ/nTF2mtNQxdjrqYVwLPu+veO2/4Fkgobsv/uXfrLcL4zmofCE
	zJYoj9BjU46KeSO1fJA724TtiAIHlvFg6KXavBIofe/5a4I7jbCr0AI/oEQuS1gBsx8L1tmfoij
	WM1MMacoHFe/IOwucEgJnlY8nhusKomLP01ATif3UQ==
X-Received: by 2002:a17:907:e15c:10b0:bd3:417e:b85d with SMTP id
 a640c23a62f3a-bd5177ea873mr616199766b.13.1779108737330; Mon, 18 May 2026
 05:52:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514200129.94862-1-amir73il@gmail.com> <20260518-rundschau-rohkost-e591e2d0deb9@brauner>
In-Reply-To: <20260518-rundschau-rohkost-e591e2d0deb9@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 18 May 2026 14:52:05 +0200
X-Gm-Features: AVHnY4Lboiy6hcXUvu8bN75d27E9a-5HGF8fzd5TFKP_HqGPUJsSaCs9Ihp7UhM
Message-ID: <CAOQ4uxgy5Vut5KYC4vj_wgXiyghT2B9nd1YAV-a+hdkz5j1gqQ@mail.gmail.com>
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nirmoy Das <nirmoyd@nvidia.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Laight <david.laight.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 2:39=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, May 14, 2026 at 10:01:29PM +0200, Amir Goldstein wrote:
> > Code using ERR_PTR() is almost certainly intending to produce a value
> > which qualified as IS_ERR_OR_NULL(), but this is not the case when
> > code calls ERR_PTR(err) with positive or large negative err.
> >
> > Introduce a fortified variant of ERR_PTR() whose return value is
> > guaranteed to qualify as IS_ERR_OR_NULL().
> >
> > We add this in a new header file err_ptr.h which includes bug.h
> > for the build/run time assertions.
> >
> > Subsystems may opt-in for fortified ERR_PTR() for specific call sites
> > or by #define ERR_PTR(err) ERR_PTR_SAFE(err).
> >
> > Link: https://lore.kernel.org/r/CAOQ4uxg=3DgONUh5QEW5KJcyXLDF15HbLnc9Ea=
7RKPcgtyfPasTA@mail.gmail.com/
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
>
> I think this is backwards. You can of course do whatever you want in
> overlayfs but I think as a first-class concept in err.h it's not that
> great. Then we have to separate macros/inlines and almost no one will
> use ERR_PTR_SAFE().
>
> I think the correct thing would be to add an assert into ERR_PTR() and a
> debug-only one very likely at that and combine this with the static
> analyzer thing mentioned in the thread below.
>
> diff --git a/include/linux/err.h b/include/linux/err.h
> index 8c37be0620ab..6bf768adf157 100644
> --- a/include/linux/err.h
> +++ b/include/linux/err.h
> @@ -38,6 +38,9 @@
>   */
>  static inline void * __must_check ERR_PTR(long error)
>  {
> +#ifdef CONFIG_DEBUG_INFO
> +       WARN_ON_ONCE(!IS_ERR_VALUE(error));
> +#endif
>         return (void *) error;
>  }
>
> I'm not convinced yet about ERR_PTR_SAFE().

Maybe, but
1. err.h does not include bug.h, hence err_ptr.h
2. I think CONFIG_DEBUG_INFO is pretty common in distro kernels
and it means its ok to bloat the kernel object sizes
but it does not mean distro is willing to pay performance penalty
but David may be able to share more insight about the performance
cost of your suggested variant.

Thanks,
Amir.
