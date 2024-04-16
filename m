Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D1B84DE6
	for <linux-unionfs@vger.kernel.org>; Tue, 16 Apr 2024 08:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713254769; cv=none; b=l9s5l941tl/fbgGpkxQlCzYHXgiCxExZLBsoXPrlB2pDVWyV08Xq3r/XCldnjxp2cG15cgrDLU67apY4aLWwHIJ3l/n9x9uKFD/v5/LyxZYeoe++K7lleYcrsTHllRMHktw4oAe9I7CJUqqaZbn9MR3GRWzXguAzSmM6yexV2is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713254769; c=relaxed/simple;
	bh=fg5enCRClFzMv6bdvt1Y6X9xAUZhUI7GAdZthN4hE2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ftcq9587qXI7aG78UKRg7w3PtBtv9C1atBUkDDd+lAQn/JhX0Ycs0EmS9C9vjMoN0gKCB+MKZFk9WkwPRa+Gn/sEUmgl7SrYSgIuelF+7PiFgI6X7flTTJpMP0qhIn3QylAOd1k0e6+2EFUxgObrPUO194fUAySFWZxgo1D761A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=lW+z02Fm; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="lW+z02Fm"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-56e1f3462caso4955783a12.3
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Apr 2024 01:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1713254765; x=1713859565; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FoqNTXSVJxVnoomAkAmOc0tpYIUt/Fr7OUpds6qVicI=;
        b=lW+z02FmKq2sZrwkzqdQlSM1VKdoHe5jjC9Gz/OwrTy6u4O/FMmR9coVMiyFXICn8Y
         amwCmXQ/ug01YvFqjKGk4bLfeSP6+Xuhua4GLocF3DCxrHEWiApPHn9hqUvGc5DbetzL
         5ZyvE49GLf6EsCAsbFuzohmUu2zf0VLHGnjX4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713254765; x=1713859565;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FoqNTXSVJxVnoomAkAmOc0tpYIUt/Fr7OUpds6qVicI=;
        b=v560F3+Dz5D4eGbXY/d0rOdbRnslbTm657Se90hlQxtQwnYD/lqymUBjex7IV1l4Ru
         jveKgkXlhVqBFK+A37MdHSOkpcubb/Qd3aUm4jEUXMVKnOhMcoleVx2h8QcJCyooqyF7
         NcM0iWZVGYitSRSAXewEK+skiKn6bw4Hcs1q6NFuRK5+BbtSIhc8j89KH9zIHGpD/heH
         DN0gm8BXUGksY0mxKcCPqMlkMJCZPrm6DdWWMM6PJiIMoNPS+6QQ4ZxpxZ8sekBompW7
         tlsxONYsGzQYPnyc8dvJ78aYZ6wLCP5T0qKVywQpvyvK6I/fqmP4ksAQ3OG2sWBeTuYH
         G4ZA==
X-Forwarded-Encrypted: i=1; AJvYcCVXCmjd85/wNOhUS9r9AmV7/XtMxzNZ0sBLOOl1iAv9zhEZ+dlIWGEdD0hWTU4f1Eivf6unqpgL/qOCq8inZQHBiKbKQNxu/wG+boTEDQ==
X-Gm-Message-State: AOJu0YxQm00yRohHimXNG3RYm4nCcjJo7XQHYFvog0S89yikMdSIL+Ql
	PZG0e/UaziD0qFes+HiaFmBCDRkBhk8lyIBTcWooYvr1jQXfMb6eKyBU30oo++CiK2g8GanuBcx
	Gw4LG19ZrM7OKyNKGHV1nGQ3t2B5qYEYgIBRApIkUo5TPPH6b
X-Google-Smtp-Source: AGHT+IFUt+TdRo5/lwa0iU7eIPcfQR2RMazKfVpGy4W16qNguCkLvu3MteqG74P0Dv9xqS7zJrT0nlKrob2NRz5PBhk=
X-Received: by 2002:a17:907:6d18:b0:a51:e2a9:97c with SMTP id
 sa24-20020a1709076d1800b00a51e2a9097cmr12053296ejc.6.1713254765520; Tue, 16
 Apr 2024 01:06:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412140122.2607743-1-stefanb@linux.ibm.com>
 <20240412140122.2607743-3-stefanb@linux.ibm.com> <CAOQ4uxjDQO91cjA0sgyPStkwc_7+NxAOhyve94qUvXSM3ytk1g@mail.gmail.com>
 <89b4fb29-5906-4b21-8b5b-6b340701ffe4@linux.ibm.com> <CAJfpeguctirEYECoigcAsJwpGPCX2NyfMZ8H8GHGW-0UyKfjgg@mail.gmail.com>
 <b74a9a3edc52d96a7a34d6ba327fdb2a5a79a80d.camel@linux.ibm.com>
 <CAJfpegvPwpS5_S4qrrVbeC1RovP8jeNuDCYLbdcZ_XDFgfgftQ@mail.gmail.com> <52645fb25b424e10e68f0bde3b80906bbf8b9a37.camel@linux.ibm.com>
In-Reply-To: <52645fb25b424e10e68f0bde3b80906bbf8b9a37.camel@linux.ibm.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 16 Apr 2024 10:05:54 +0200
Message-ID: <CAJfpegsHJ1JsM3SxNk5gnUM+aucqOqNm3RTrsYgePkcQYR4EEw@mail.gmail.com>
Subject: Re: [RFC 2/2] ima: Fix detection of read/write violations on stacked filesystems
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Stefan Berger <stefanb@linux.ibm.com>, Amir Goldstein <amir73il@gmail.com>, 
	linux-integrity@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, roberto.sassu@huawei.com, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Apr 2024 at 20:35, Mimi Zohar <zohar@linux.ibm.com> wrote:

> Although "Changes to the underlying filesystems while part of a mounted overlay
> filesystem are not allowed.", from an integrity perspective these changes might
> affect overlay files.  So they need to be detected and possibly re-measured, re-
> appraised, and/or re-audited [1, 2].

How are changes of non-overlay files detected?

Thanks,
Miklos
