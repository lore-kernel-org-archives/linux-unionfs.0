Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD911B395C
	for <linux-unionfs@vger.kernel.org>; Tue, 15 Oct 2024 15:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729007352; cv=none; b=uKxWrzz0Cufabg+2z+xXVVkoFphsSfIw/qOGnB/e36V8vHaucBwEBnpl1rIAnCcdPsuRO4qtdjDUW8mH76P6V3jMHMy6UdXW/HdH/DXtTeIGsRNhEr+dqypU88cMpQzOAXWEKUNEDR4NpuvJxXloLxXxEHLecGBEep2yUSCn/ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729007352; c=relaxed/simple;
	bh=vjIKgujpXbBa9QQ7m8TnV/6nVaoEwKzrvtrjOjtx2nk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gpMMnxEw4igw/v3HBheBk3bla4a4OLaqtu5pkxYbtgYqoF66GM0GcXs4hV9e+0JZh9sKCmcRdCGdowDHrFK69adsqCMsMtUHtSBw8HJtEh/1DaI9SG9aqQc73NqT+npmCXd9ncS1FagOuMqs80l40kQ2rk0EicRbcgsm7lmC95Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=PWHQCX2k; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="PWHQCX2k"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a99ffeea60bso405427466b.3
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Oct 2024 08:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1729007349; x=1729612149; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VfLpOflYUU0cID2q/Pi+2EpROMt/OwW8gIz7YpL5vm0=;
        b=PWHQCX2kK5fzBWQ4NxYQ6WfUvvqj7O7EO9yk+79DJgbp0XtYyYr1BqWnq58qApSjxI
         lbodiZPItlXV1XZJC/XM86RHFcfIZB1hmZcGtHTR5CPUH9BB4AmcRw0pYtxhrRELhcHn
         2sHYqINIRs3WFe5QyVe2Ti/SktszEmATQUBgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729007349; x=1729612149;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VfLpOflYUU0cID2q/Pi+2EpROMt/OwW8gIz7YpL5vm0=;
        b=FI4GIklPma3LG8Td1XxI2yp+dCs/zZE8/qakBbXY+wjWIJHh8jDz1Q69jgEBDoagST
         LGtIWR9Ivlast6KnexmEiddHLXUHiNIQv4C7K314KLm4o3mqhtEgB1EsEuggz2fMU1Nj
         pA+UW/25IslWOCcYXA4E3El1qSD/u36UHYa7jxMa+1xkEHEgWgSgVAE4fXCu/sgYJNdP
         6dUPyQKkQ9ZnCJGup5+9OXr9KuGLvISSZvYQAcZAGyO9veVtXLXij4oedTLVPxr2jAez
         WMxGz+itZZ1ECFKNW2KSbQ1+TwMaLhWVr8kfOUuCtApQtrRx/qz1AM5Zn6YNKfqlazU8
         DrOg==
X-Forwarded-Encrypted: i=1; AJvYcCVSrhgbbgNs3s7hLUVz4ykekyC19C1l12cyxaHCwAkcHlva7J/tQP2xclewRjC4voPdWwhQMWG7eOzEpolT@vger.kernel.org
X-Gm-Message-State: AOJu0YxMfU96XdHuSSoxFl5ebP+CotJzU7HRDHVYVXRZ9Jx0ITV686ld
	nzrclmriMQK8/n082irsSKSvfDZjj9KtP8gY23xcFDbP/qp6iKwINeh25FT9yUCdibBkvLUFtir
	rI7XHFxmlgNv6PzTpkDDdHRsUczasGd5ZXpMKWQ==
X-Google-Smtp-Source: AGHT+IF7DZsF4rqM6xRoOsL6CDYnt6P40hl9YreSpee8N9DM5R6+gfoZhGsEOsaFuIOQazEBYSepu+fwiDITTkbFoGo=
X-Received: by 2002:a17:907:94d0:b0:a9a:e2b:170e with SMTP id
 a640c23a62f3a-a9a0e2b1ab5mr740431866b.10.1729007349341; Tue, 15 Oct 2024
 08:49:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241015133141.70632-1-mszeredi@redhat.com> <CAOQ4uxh-3H4QkTEihujFgz53ajeArWH9u_yj4kaWByVJAGmgrw@mail.gmail.com>
In-Reply-To: <CAOQ4uxh-3H4QkTEihujFgz53ajeArWH9u_yj4kaWByVJAGmgrw@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Oct 2024 17:48:56 +0200
Message-ID: <CAJfpegsfMf_On1qAmv1Qeud2MkFJcL1Q0Kk_i58h7YcOoVbpgw@mail.gmail.com>
Subject: Re: [RFC PATCH] backing-file: clean up the API
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Oct 2024 at 17:32, Amir Goldstein <amir73il@gmail.com> wrote:

> If this cleanup is acceptable then perhaps squash it with the above commit?

I didn't want to do that, because for the backport your version is the
simplest and easiest to review.

> This seems wrong to me, that the callback gets an iocb
> that was not initialized by the caller of backing_file_*().

That's only true for backing_file_splice_write().   Would oassing an
iocb into that function fix your concern?

> It seems better if the callback would get the backing_file_ctx.
> We could copy the pos to this ctx if you think this is better.
>
> OTOH, ->user_file pretty much belongs to backing_file_ctx,
> even if only used in the io callbacks.

I don't like having user_file in there, because it's redundant.
->user_file and iocb->ki_filp *must* be the same, and I don't see how
passing it as an opaque thing back to ->end_write() would make it any
better.

Thanks,
Miklos
