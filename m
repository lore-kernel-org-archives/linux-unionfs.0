Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA3F191461
	for <linux-unionfs@vger.kernel.org>; Wed, 26 Mar 2025 10:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742984660; cv=none; b=XF99hlOaUUSB9Th0fisHBN6bbrU95oakZzD+QWDX0XZWcMezsp/OgGgc8H3W/6tL43RB0AhCSKFm5hua1MDsKiOJdHxogWhV51YV7UZxivwt3rrs1MuFcLbMSPLF2KWxsZpOuB//65jolfiWfTUv6pF/1aJ/HC6sXEQ0D1pHtDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742984660; c=relaxed/simple;
	bh=lZPIEtWGSE0y5u6EupvD4OT9j5kgccDjdrK1LWEGiM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OpHHgsMANQtC/RfynCdF3JJbPE1qtdrqQdgB/8rdCzBhdbYZwFvxTHRwhrp3cqQc1jlOlL0cFxLLA5EEkiD7s1ClO1uGZkcZGLcbV+fg+1y1cPsJbja1W48HwbEHpoKTIxuR2mpq9FMkm/xpIBXxTNGxIo9biat4NGIrNJT278k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=eRzmj+Ik; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="eRzmj+Ik"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4767e969b94so60387341cf.2
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Mar 2025 03:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1742984656; x=1743589456; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rN9uHgr8U12WiQGTul08dzabhr16jXGifO29BZdVxVs=;
        b=eRzmj+IkF0YKPHSY42mZy1aH4OdhkTvaVmWO8FLoiCCaEAVBwx4uUxAYutCaoeMPRS
         fNZcSNqEcXt8UEjJ8Bt8sP+dVuwv2rHgaYGA8LQZVlPn8SMNVrJg4oh3t0UX4tEUQdhg
         zuRD5Pp1PSftzWwOwP18uIEzLEKXZ4nWH0js0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742984656; x=1743589456;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rN9uHgr8U12WiQGTul08dzabhr16jXGifO29BZdVxVs=;
        b=CVP3HGvwDG7T50jUJhME9ZKaGZbQ2rXwhhQMeeDA0hkHq2rosP2MayDLasyBpshucg
         pJx1PS8nNxjG/o0Hm+Mr2JSlRmJkyvZDLC6fjdWGSkYB3TmCuJQkSEqg73a0SxAdB8fL
         s8+TqyEOjZEOBjPABUhFRBL398jqEwgLIU0Ary60LBXNRQZPdW2pailIzgYFvihm/QWV
         tH+n6ydOOKyEnZsmbiuFUyL3uJje73AEd7cqblZXuLuyeDzTfNvi/TKbUNLiCKmk6PoP
         nHxfkF3G8nW831oeLbIFL6gfTQqos+Ow+pYhsEj3lE3tdjMra87XvRODwGv97Qxok5Y2
         jv0A==
X-Forwarded-Encrypted: i=1; AJvYcCWaTJylz6C4GBZT2GGeiFKOet2kU2JwPvuUip24P+s1KEPoTTliave57rFk4DmMUMTmzTYUzQGOvGHsyEJa@vger.kernel.org
X-Gm-Message-State: AOJu0Yyezu2oGCh2fKJZum6YHEctKPaXc9JyYjvpEtO41FlSKBBiTNCD
	pwY8v/HqbL0zdbt6Hw1ViMGCNU9NEl8uu3RdZ5ei301d8he+aCiLjftP+vGKGApPzwYXUT2QSc7
	FzaUJhvOXxqTw7lhBcbMa2rYH2Ka2qAQhyVSIfg==
X-Gm-Gg: ASbGncusE8Mbz6hbTXRXWN6R+tADQgKEwMQ2nzx+I6Ks7otjlWh1KE2y8JQbg1hoEyu
	T9sYNxWJ/1IsQrqkvb+887GMi63NTBmvs6PTWuRPWJ2Y3C2HLtJsAvcTLiisGe1GpZBVHHvd5hR
	2PkS3Eh1rxmXVKoJdrS3xWrQU3dPYzgYcqrkw=
X-Google-Smtp-Source: AGHT+IH0vLhqq3lg+yaWzhqlmKzVspPqQDKFlNiMEjqP6SKmduHR410XaWJXVXMEsHW7vnEmjWa8vn496rkqsY7iD4k=
X-Received: by 2002:a05:622a:5c16:b0:476:b489:8f9e with SMTP id
 d75a77b69052e-4771dd61582mr344077411cf.11.1742984655891; Wed, 26 Mar 2025
 03:24:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250325104634.162496-1-mszeredi@redhat.com> <20250325104634.162496-6-mszeredi@redhat.com>
 <CAOQ4uxgif5FZNqp7NtP+4EqRW1W0xp+zXPFj=DDG3ztxCswv_Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxgif5FZNqp7NtP+4EqRW1W0xp+zXPFj=DDG3ztxCswv_Q@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Mar 2025 11:24:05 +0100
X-Gm-Features: AQ5f1Jrs1ZlRc3qM97IRR2sB8E1k3KTYERXzDxx8JPpp_Wy0xPwgBuFeLw2pvJU
Message-ID: <CAJfpegvvRBgYHpuOUuunurwN0Nad+OUdjNOdLw6d1C0kEAg5PQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] ovl: don't require "metacopy=on" for "verity"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Giuseppe Scrivano <gscrivan@redhat.com>, 
	Alexander Larsson <alexl@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Mar 2025 at 12:35, Amir Goldstein <amir73il@gmail.com> wrote:

> > --- a/fs/overlayfs/params.c
> > +++ b/fs/overlayfs/params.c
> > @@ -846,8 +846,8 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
> >                 config->uuid = OVL_UUID_NULL;
> >         }
> >
> > -       /* Resolve verity -> metacopy dependency */
> > -       if (config->verity_mode && !config->metacopy) {
> > +       /* Resolve verity -> metacopy dependency (unless used with userxattr) */
> > +       if (config->verity_mode && !config->metacopy && !config->userxattr) {
>
> This is very un-intuitive to me.
>
> Why do we need to keep the dependency verity -> metacopy with trusted xattrs?

Yeah, now it's clear that metacopy has little to do with the data
redirect feature that verity was added for.

I don't really understand the copy-up logic around verity=require,
though.  Why does that not return EIO like open?

Thanks,
Miklos
