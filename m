Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3949C19ABA3
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 10:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742900273; cv=none; b=RYiCpByiDemiSfcopbxUbCG2U1SdBI8NjkmNNRNYaYodteXjEjjgMfFl4JXn95G3kSwLbBk+9T6tE3HQ8Q/xsvk7W8rKACvd/zBIls9Z+x1JoeVhtiYCdIugy6vbhl1gKa6pVoFJuBXqgbpqyR/QZjZh1LVQ0fKUa17nzSNtW14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742900273; c=relaxed/simple;
	bh=XsEMWdvBi5iYepcfq5t8UKPpw3unNu+uylpT17aX/IU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p8rS2PytgbZxjn64rQe+jrDa18OwunNpYb7hgwFLPYQi0Uss9qqmIFM35VT3xGnGuh1xFlSrrtaMCIkjhjYc6XTcb9N3mleYrmUw5z4ZcNiXlC0mdUCqTKI2hIVHhbrA5LLQK8rPMIyZrbsdjLnExfdDNApPlXt5RwHiCTkSR2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=cxUh7kCl; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="cxUh7kCl"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-477282401b3so37092431cf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 03:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1742900269; x=1743505069; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vBkCikaTAoHizoDbryCJJ3jdoOZ97/scQy3/JjbbFL0=;
        b=cxUh7kCl8I6InZltCE3Mze3ggfthI/nHlpoNQlE9txD33CUJXnYWYtRnbLWsGSwUVc
         +kX0HNd/LTyrs4Hhd1CA+nVFi2OG1y2di3VsFMJyNCrm8fBISR0koylarjwR69Ddu2Zz
         zfrpdbwrD+zJ1e1UU1360K2VaaoabIKSzr4ws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742900269; x=1743505069;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vBkCikaTAoHizoDbryCJJ3jdoOZ97/scQy3/JjbbFL0=;
        b=jmbMZt/fEb69jbcx9qob3xSmZojkR1atp6ceKGEvDIhaIKbzZb3H+lSpolZEGO+SnU
         xBpBtOJ7s87gQKSw84PsXYWTO1ToSjivXQrzC4xcAn0LIgE4UMvO0Z9A85qZaITzr7rK
         sqwrPSIWvZl1tON+Ss7QYt9jvCgeUIMBWstiZogz+7rey0WdviCLd00IAaP+CWGliMN+
         kq5rNxVJtGt4my0UsdAbguefWOe2jxumi7iSBWSkhLCQ/NbcWX4ukIirh5vIQc3jkFCY
         9urnG4n2bfzu/KQrRyr3hTuqQmCI2xKgOa2ZRt9s9bfW8F5mrL1TFttjhP9Gybes4In2
         /oLg==
X-Forwarded-Encrypted: i=1; AJvYcCU0j132q9AitcubDxLyqxqug9yMFtuEVpurJwBBAlWs6Rv0Wt8/MWMIFW6Qqk5CN3jYxJ/uJAXiOi3gMbCJ@vger.kernel.org
X-Gm-Message-State: AOJu0YypuEIiIcuR66dOTuW6DGW81c1iFzal8r2SAxpIkurX+XcaSOtT
	K2SVxcBFa7/5NmJXBFwCtvrPbj2gn1PopUA2Aw3CnRmhXTVkY2fUJ22hY9S8TgYy9D5uSGyVavm
	ezcXEsQh15Azk8Rck/TuYTp2ZESzNoZBE7oqQqg==
X-Gm-Gg: ASbGncvupsOEE6v3jUTInAADB6/WIMkLXXq/+naAHzSB9CRwn6imGWnuaB0xFaJ2TG1
	4q4f9jp8MSF70QSMl6ntR1aF7ZFZ/ccHQMOcQO1kT8dA5C5aflbihD0yRObq+VzyqsbY0OYY6rO
	voaBa8SFEskaIh7M7BHW3QRvDv
X-Google-Smtp-Source: AGHT+IG+KLvfcAl79m45TxzmZPY9Trdpca/2dQEEBE+Xb5C+dQlIvgNSU5J10Zl3B4H6RzI3Mc6ZMY0zQ5DIimVjAsE=
X-Received: by 2002:a05:622a:4c8c:b0:476:b783:c94d with SMTP id
 d75a77b69052e-4771de1585emr250434821cf.35.1742900269488; Tue, 25 Mar 2025
 03:57:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250210194512.417339-1-mszeredi@redhat.com> <20250210194512.417339-3-mszeredi@redhat.com>
 <CAOQ4uxiqis6kawuv4pa6jxHYgpQPc18izFP8e0TORfA_mVu_-w@mail.gmail.com>
 <CAJfpegt=PWs8ZDF11p3nOCWHbWescE5nwVtUt82f=B6B+S0Miw@mail.gmail.com> <CAOQ4uxiQQV_O1MJgTksKycBjJ6Bneqc=CQbUoghvXc=8KEEsMg@mail.gmail.com>
In-Reply-To: <CAOQ4uxiQQV_O1MJgTksKycBjJ6Bneqc=CQbUoghvXc=8KEEsMg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 25 Mar 2025 11:57:38 +0100
X-Gm-Features: AQ5f1Jr4s098ta3jIrpq5kQdXM6kspgGjK8HSqHg4idBTvhTOKRucehRWdwRJr4
Message-ID: <CAJfpegs1hKDGne7c3q4zs+O5Z4p=X3PK8yFXhyCY2iAjs4orig@mail.gmail.com>
Subject: Re: [PATCH 3/5] ovl: make redirect/metacopy rejection consistent
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Alexander Larsson <alexl@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, Colin Walters <walters@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Feb 2025 at 13:01, Amir Goldstein <amir73il@gmail.com> wrote:
> Looking closer at ovl_maybe_validate_verity(), it's actually
> worse - if you create an upper without metacopy above
> a lower with metacopy, ovl_validate_verity() will only check
> the metacopy xattr on metapath, which is the uppermost
> and find no md5digest, so create an upper above a metacopy
> lower is a way to avert verity check.
>
> So I think lookup code needs to disallow finding metacopy
> in middle layer and need to enforce that also when upper is found
> via index.

So I think the next patch does this: only allow following a metacopy
redirect from lower to data.

It's confusing to call this metacopy, as no copy is performed.  We
could call it data-redirect.  Mixing data-redirect with real meta-copy
is of dubious value, and we might be better to disable it even in the
privileged scenario.

Giuseppe, Alexander, AFAICS the composefs use case employs
data-redirect only and not metacopy, right?

Thanks,
Miklos
