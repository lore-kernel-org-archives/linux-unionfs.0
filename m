Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1C0214A8F
	for <linux-unionfs@vger.kernel.org>; Wed, 12 Feb 2025 16:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739379484; cv=none; b=IJlpO21om9AcuEDay/2pmDDES9pXHm/R9nCs+BbbGr/nKLdfte/m4wZ3gvSfG5spOdMTvS4sknKB7BBP6oQHOTpZA3rUzla5IudUGGZ7+7aJaUPVYsk16D6dDYpZXHtMhlIsBBNymYHF5zlpSwf3kC8Tn4uFoedr4ghU3aCKIM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739379484; c=relaxed/simple;
	bh=P9JdwHaUKaC7H9Ci7BUO8mnUxxFaDC584LXFAy56ze0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RAj/8tBdAveHhhMkJL5ghGt8MDF5MpkgfqBYUSVeZNfmOIzT53QfeV2U/H3WF9IcY8nXi1cChzTBok31ulrL1HJuM6OLxQxNIhO7UUmCduRk0LCTZELpQxEvzVhrVuNZHWpN1HGCf/bCjCd4LXK5O6BWJxzhgIYUsW2M6HPiB3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=rHwAiNrJ; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="rHwAiNrJ"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-46fa734a0b8so62050521cf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Feb 2025 08:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1739379481; x=1739984281; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vT+hMogTz46vryZ/YtUpB8CUx/hmD3efKVcLVJOFinc=;
        b=rHwAiNrJ0BgPN1fyXNjt5NNOPUdXPo2eCH7IIdezsP7jhXaSnfv/pMlRGBZiUA0Zvj
         Jk1d+tPpzdy6Vat8V85FNmqyHrJ51MljiBJvFdXsvIGsdr+nh5sSdeQBEIjr6hbXFA3f
         kaRWnbmo64Cb0VWnXSyleCJzaMdEiXER6IZMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739379481; x=1739984281;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vT+hMogTz46vryZ/YtUpB8CUx/hmD3efKVcLVJOFinc=;
        b=brVKXJ/H888J/pTu6PYAEi7b31ZRYiw6q9BHqrDlTOk56aUskYAWoxIV8InRwsEdO6
         CgSyaE4uvIb8i4OFUR5p3wk0ea3/iCihQStZUTkqajgYw6yKCweS5BTjTgpnHZwIVMoo
         bnAP4dPE4r1HA1Bd/pUtF5WoAikGGRe92m1vqI8gebygYwoOpyrMPurnZq+GJO57wEG0
         Ktc4RBnyVcRRhTF3arlLLzytHQ64/GDTHq0ROsbMIwKoyHGNEEQno5l8i3ZQZ9iSIdfF
         +KGIX+ZtcEGhsc83TvOlux7B+WdTSdaY4BIOAzKCLVxYjtdM73pnxrOR8QTD/wFoIDZS
         xGag==
X-Forwarded-Encrypted: i=1; AJvYcCW+lxMRkfrtjuGiiIoeshe43BFOnW17FM/RqMZpgAAfVq4L6PEBRchA8aUdyIAKK783gJlpNTLyesyRidRE@vger.kernel.org
X-Gm-Message-State: AOJu0YzLtm9ZSklPgIXgM74j5PmrP/OJ6V2H2rU+k8904AC/N7bzcfFU
	ZzkJKiQTmcaPYZox7abnhQhXV2TNUDkp0NHVMwWXOExjXvwSiDko/u3GGZ8wyKdXaFLoGqIFsU5
	tl9AKyRQ7qx/Z+dQkZhufu036S1fzA6VxKxP8V9tvhN5Oxjje
X-Gm-Gg: ASbGncuIxPt8DS1FsLf+WtWQizNUf1qxBzw6ujharYu+Z5cbPW6QyYXDR236B0t9FRc
	0wEHZqiq++DkCPoj9DBt0LZEAOsaWgNEFWjX+/ERoRDQ7SzvS0lH1EyQtmWLlgRNDImndEw==
X-Google-Smtp-Source: AGHT+IFnzDALt4z009doDSKRYtYByrEnwBJUsIaU5OvZsRiDtAZNjs0x/YiFPJyI6tUyZN53KmJkq9tUS68zIvw2b2s=
X-Received: by 2002:a05:622a:181a:b0:470:1fc6:f821 with SMTP id
 d75a77b69052e-471b06edc47mr46227211cf.35.1739379480995; Wed, 12 Feb 2025
 08:58:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250210194512.417339-1-mszeredi@redhat.com> <20250210194512.417339-3-mszeredi@redhat.com>
 <CAOQ4uxiqis6kawuv4pa6jxHYgpQPc18izFP8e0TORfA_mVu_-w@mail.gmail.com>
 <CAJfpegt=PWs8ZDF11p3nOCWHbWescE5nwVtUt82f=B6B+S0Miw@mail.gmail.com>
 <CAOQ4uxiQQV_O1MJgTksKycBjJ6Bneqc=CQbUoghvXc=8KEEsMg@mail.gmail.com>
 <CAJfpegsuN+C4YiA9PAuY3+-BJ959aSAaXTYBwKNCjEnhXVw0pg@mail.gmail.com> <CAOQ4uxjkBQP=x6+2YPYw4pCfaNy0=x48McLCMPJdEJYEb85f-A@mail.gmail.com>
In-Reply-To: <CAOQ4uxjkBQP=x6+2YPYw4pCfaNy0=x48McLCMPJdEJYEb85f-A@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 12 Feb 2025 17:57:50 +0100
X-Gm-Features: AWEUYZnDklP0Q04eQJbdif-V3Wr25nZfxbERwb43ZA_kG2OIKQLTbPE7mtefsDg
Message-ID: <CAJfpegvUdaCeBcPPc_Qe6vK4ELz7NXWCxuDcVHLpbzZJazXsqA@mail.gmail.com>
Subject: Re: [PATCH 3/5] ovl: make redirect/metacopy rejection consistent
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Giuseppe Scrivano <gscrivan@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Feb 2025 at 16:52, Amir Goldstein <amir73il@gmail.com> wrote:

> It sounds very complicated. Is that even possible?
> Do we always know the path of the upper alias?
> IIRC, the absolute redirect path in upper is not necessary
> the absolute path where the origin is found.
> e.g. if there are middle layer redirects of parents.

Okay, it was a stupid idea.

> > > Looking closer at ovl_maybe_validate_verity(), it's actually
> > > worse - if you create an upper without metacopy above
> > > a lower with metacopy, ovl_validate_verity() will only check
> > > the metacopy xattr on metapath, which is the uppermost
> > > and find no md5digest, so create an upper above a metacopy
> > > lower is a way to avert verity check.
> >
> > I need to dig into how verity is supposed to work as I'm not seeing it
> > clearly yet...
> >
>
> The short version - for lazy data lookup we store the lowerdata
> redirect absolute path in the ovl entry stack, but we do not store
> the verity digest, we just store OVL_HAS_DIGEST inode flag if there
> is a digest in metacopy xattr.
>
> If we store the digest from lookup time in ovl entry stack, your changes
> may be easier.

Sorry, I can't wrap my head around this issue.  Cc-ing Giuseppe.

> > > So I think lookup code needs to disallow finding metacopy
> > > in middle layer and need to enforce that also when upper is found
> > > via index.
> >
> > That's the hard link case.  I.e. with metacopy=on,index=on it's
> > possible that one link is metacopyied up, and the other one is then
> > found through the index.  Metacopy *should* work in this case, no?
> >
>
> Right. So I guess we only need to disallow uppermetacopy from
> index when metacoy=off.

Yes.

Thanks,
Miklos
