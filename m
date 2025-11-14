Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D732D2490
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 08:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763110120; cv=none; b=mf1Ag4r+Aj/WDHquGXMSiFQLIsgGltQl/1wcWtd5nTU2uLQCT45vG7IE9lA8cVgHeVAhTJjdwGeQhQ8H7BaH1UNGHVhhnBi50CSTFyALqEdIulZsFq5HHs/GvZcIr8uu3DsGygryp4ST2lvextp+Nq0wGzkqXFfMf523GzSKce8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763110120; c=relaxed/simple;
	bh=aPkFt5pgZ5e0EivvBJmHgxFQ2zdgmAcuwvRaR8seaiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ALlPy6qxQ4Xe1Je75Lm6AyEyXSnzL9WpOToOI/azP1A5KVoW8jO8Fju4lY/PPKR3e18lzCo1XX20qFYRpXBr7VKwXS9RF/6ctuWxTcbtY2o885/ceJ3mNh409ybdyF51iPHquoL7fwu1Ev8gjZdZlBniGP5qNLxBBodyF63pieA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=evaOi5GU; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="evaOi5GU"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4eddceccb89so18308261cf.0
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 00:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1763110118; x=1763714918; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DNNmyBuwpR3UfaPYjzFL1B4VRUgsIofvorzn1qzbQ4Q=;
        b=evaOi5GUkwJ5+SKkXi43DhXSrdLbxsHs5pW4SXsEQPCp5eD7WVaQSyqY7uFUG/pPjF
         v+3Q0FXNEcFkvdHc6Lt4Na9nYJAK3WDQoLwUsLmdV3NdZlZxJ+FllCHb/YJGi0qnICbQ
         4uVBZRcELZU1eBGHAxTQBTr+ZrmNUirwzgUE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763110118; x=1763714918;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DNNmyBuwpR3UfaPYjzFL1B4VRUgsIofvorzn1qzbQ4Q=;
        b=r9B80iBFkzc+3nEWAsi8PErtxjVTVk0Plba2rScSa64UodyjOMZS5R/OntMBodM1J6
         EKPx8ADsKd4yBYPXSIRrW8jXNomEyMH6+bXZJfpbDLEYoj+hFTrNajRPNue1/IfmV0b0
         Zvs1Onfydr624+Y+YuHE9ErNznXLoe7P1/3VbRDPKWugB07bvnVMcJYo6qT1TEuqzAHE
         CrI4+vb9qRbuBzpSE7kc9fBbUTKAkYTjZ1hKL/VY5lLGLraK9LnXOII1WkfFqKEq1Eaf
         oq8iwe9IxKybqvQhPMRZppVB9qJ6FY5CH805s3145GgMwMB3ybaEOd4SFuLcf8JPjP3e
         C+ww==
X-Forwarded-Encrypted: i=1; AJvYcCWPfSIISlFWo0fLRiwcYzF+C0RYQCcy2+ZkLilZtXzrL+LZcDv6orrqosZE9E9Eo4uBRVzsbdQ6oXTPo82T@vger.kernel.org
X-Gm-Message-State: AOJu0YyUl4QhH6iaIx38gVf6QxYmGWKpQor7tEQcQa6lBIDy7gRz9aOY
	ZPTyGEJL05cabc5iuRu99fLOFSippddIp2iyDAJsMdXmzZ66YJs7Lb3hbF+rRN1axM8VHA4Ueq+
	grPjvBYsGd5NXxRjZHnF3DNa1YF0jJRfFzEYoaGetAA==
X-Gm-Gg: ASbGnctKBi6uln83DzKxdR9jvOjL2/R+wCzLxfdNnPg9YT6coTtC2Jd8G14NpRpJ2dw
	f/vttOK166NqjFstvr2VRhu3YSF9S0xh3hQS1hlPZrVDbTyQhtAbdyoDlHq1FzxiqQrKWfeu51g
	xekg/wCaBpesQQ7wD0qHlR5Q3moqbHs5YF1bOShDZPpgYjQScetJMI8ZsIPpj1BwEea4sKR6iO7
	dAdecRXNhH66rFWe7aERAUUOdE5MyZOOon2TQ4EBkUMZqpgYDAw6+NfgbOz4VRo7AhxHt3gTEzp
	/hX5R2ZsKMuDckrVJtFqtFJ9O0Yy
X-Google-Smtp-Source: AGHT+IEE39nKjr/XyPqkK8Q+37qKockFwzuopgUhjpbberx1E+mXJUbV7QojPQo3HTo3dh4nWkiPC8nVcLf/TKdgrdM=
X-Received: by 2002:a05:622a:1886:b0:4ed:b4ae:f5bb with SMTP id
 d75a77b69052e-4edf2140a18mr36064611cf.65.1763110117710; Fri, 14 Nov 2025
 00:48:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org>
 <20251113-work-ovl-cred-guard-v3-6-b35ec983efc1@kernel.org>
 <CAJfpegv=yshvPv432F6ytAcuBLWQnx5MvRQjKenmzg-WafZ_VA@mail.gmail.com> <CAOQ4uxjejHF5mp_vRdQG1W6HHdW87CphLH3tJ+Sucigo3hJfxw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjejHF5mp_vRdQG1W6HHdW87CphLH3tJ+Sucigo3hJfxw@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Nov 2025 09:48:26 +0100
X-Gm-Features: AWmQ_bku1I4TVqhZQKw8rUvP1nadHWU033oHKABNOdGLlKLHPWqkHQ_N_TyP3qA
Message-ID: <CAJfpegsAkYX0x01tNZXTQwTEnNvEMqnq2cGYeu24rFESdqkz=Q@mail.gmail.com>
Subject: Re: [PATCH v3 06/42] ovl: port ovl_create_tmpfile() to cred guard
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Nov 2025 at 09:30, Amir Goldstein <amir73il@gmail.com> wrote:

> For the record, where I stand is
> I don't like to see code with mixed 80 and 100 lines
> unless debug msg or something,
> so I wouldn't make it into one long line,
> but otoh I also don't keep to strict 80 anymore,
> so I won't break lines like this just for old times sake

Here the advantage of not adding more splits (and not removing them
either) would be less churn -> easier review.  But it's not a big
deal.

> and while at it, why are we using current_cred() and not new_cred
> for clarity?
>
> realfile = backing_tmpfile_open(&file->f_path, flags, &realparentpath,
>                                                    mode, new_cred);

I think both are okay.

Thanks,
Miklos
