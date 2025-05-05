Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB1D22578C
	for <linux-unionfs@vger.kernel.org>; Mon,  5 May 2025 12:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746446861; cv=none; b=P7qDa0KdYkQkTSmDgCQWZ/O2Yng8esJTfXpkUEwZQDLzvakmKMd0IFk8CZVuOIhF/sIjI4JoYEdC/JdjYOPQJJZ2lufHz5YJNMLRrcmyKonzlRnAwrm+OxvM6CUzrPRr9Nq4cEvPofRXb5sEWZMjIZ3A1GAcAXdEpwZhJ4Z9uPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746446861; c=relaxed/simple;
	bh=OhieS/K1pVWys8cRyyoz+lJJA4aObar6rgBHhZH/SrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rmwFYcEDoEU/ze1D6WLGoqQdXpLOg4vSOjYZ/JrzswEV3ahtmrQUxZ3xSmxclar1Kx0Z0GpS7ZESNrhHuQuVcpVlINz1uBcOHYow+QP5yWqOgvH6ZF+/+sQq7Tv0VUnNvsrwBREOs+PdhmR9DIJ0CbWl43fYa+wBS5ZOu9tJ4og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=kd+W/Ux0; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="kd+W/Ux0"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-47692b9d059so72409121cf.3
        for <linux-unionfs@vger.kernel.org>; Mon, 05 May 2025 05:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1746446857; x=1747051657; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P4QkUflIXod3XNly4g7gKrBpyN8k4MZSMEMI36uvsmU=;
        b=kd+W/Ux0e8vqfsG/e7s0OdsEKUl6QQeMdtdXyCBb1OKTedh1zg+7O+b5CmZbEO/JKB
         URs+JJUNIIV4373CVQGUsxcDU5xVFu3lyKF6DB67M/JWFMw65Biyt+3BhEAAL9Ihva4V
         Dgid6OoRUPkBAMfE8dN6uUuQ6s7ekejgHhUzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746446857; x=1747051657;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P4QkUflIXod3XNly4g7gKrBpyN8k4MZSMEMI36uvsmU=;
        b=NKPaFwcLWvjLHCZErOKN51CFyC09QQuTkzVlddskHJIT/ZpgOoDg1HDXlWbEw6oE6O
         M6RG+fBsW7ihNYwTNz1QRF1GgSQkiRAifkfB62rsWFaXpO5ocnwRgFskVO1NpOLp47VU
         hRViGla5LyVgjYgtFfqnwghXflYTxToTdtMS9JJZHqAQ8Z96dRckqwFi8ms0h2/amObA
         VQ1X3LWcWbV8lk1w5QMoY3D6chVkAJbcNgrR6uPB55mqbAO40v86Q6eoIpKlbjz7oFdU
         oBCi90azAGcBVG8oVUD3jmZoD8u8+f/lWQvR6mMrgdgTUqU/2OMN8QcVabRNWCQSXuvX
         2wow==
X-Forwarded-Encrypted: i=1; AJvYcCVQ587t8CN7YkK+nRAWNnGmgWXE8BTldX+OSuKF2dVKv7yylJnA1hL6KqR1bHUrO4TBnu12f2FYO8322ylF@vger.kernel.org
X-Gm-Message-State: AOJu0YynknRClT9BZvrJI6fLlkKTpfcZtCGNZRITozsM6RAfF4EDCwn9
	Zee+TSQyNkuQ8yKCtJNlWy/2ac6srVjaDi/j7wIQ/iTxY58qn7lcp7K8LcLrwmZ3bdMe51LQy5k
	Ce/lFHAqK9nyMLQfVFgsYbeYw8Rnnb1yNr/VODg==
X-Gm-Gg: ASbGncvBsO1J4MEx8hoyZoTAj9AaresDKjDemV8O5w3w24rp/NsA+zLLz2osySVN242
	uq6wjxrj3VQXACB4Lu3dzB7Tzc7TE2Z6BuIrrFOHQ3y0i0oqOavyE/UAW0T3Pej5mlGf2PgmjKl
	LQNavdiCwpr8oCHLewHxxfotY=
X-Google-Smtp-Source: AGHT+IGg7MSzyNGZDAm8PN+Rk01IZI0MP6Tn6fdmZrsz3EqNNhB4ics7sazeHz8PLtXzlDpCkQVPcu/JZzZPUSthRRs=
X-Received: by 2002:ac8:5fcc:0:b0:477:d00:b43e with SMTP id
 d75a77b69052e-48e00f625e3mr118569981cf.38.1746446857634; Mon, 05 May 2025
 05:07:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250421231515.work.676-kees@kernel.org>
In-Reply-To: <20250421231515.work.676-kees@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 5 May 2025 14:07:19 +0200
X-Gm-Features: ATxdqUGNGjWmkQIWUhSlojufuLzXVS_0fzlfJibo3GuJDcGDMsQUmpKRLSDEaqc
Message-ID: <CAJfpegukbiMZzpdP3vLryh9k3o5Uq+mtdjGdhTrtLp2ydQ0a0A@mail.gmail.com>
Subject: Re: [PATCH] ovl: Check for NULL d_inode() in ovl_dentry_upper()
To: Kees Cook <kees@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Apr 2025 at 01:15, Kees Cook <kees@kernel.org> wrote:
>
> In ovl_path_type() and ovl_is_metacopy_dentry() GCC notices that it is
> possible for OVL_E() to return NULL (which implies that d_inode(dentry)
> may be NULL). This would result in out of bounds reads via container_of(),
> seen with GCC 15's -Warray-bounds -fdiagnostics-details. For example:
>
> In file included from arch/x86/include/generated/asm/rwonce.h:1,
>                  from include/linux/compiler.h:339,
>                  from include/linux/export.h:5,
>                  from include/linux/linkage.h:7,
>                  from include/linux/fs.h:5,
>                  from fs/overlayfs/util.c:7:
> In function 'ovl_upperdentry_dereference',
>     inlined from 'ovl_dentry_upper' at ../fs/overlayfs/util.c:305:9,
>     inlined from 'ovl_path_type' at ../fs/overlayfs/util.c:216:6:
> include/asm-generic/rwonce.h:44:26: error: array subscript 0 is outside array bounds of 'struct inode[7486503276667837]' [-Werror=array-bounds=]
>    44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
>       |                         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/asm-generic/rwonce.h:50:9: note: in expansion of macro '__READ_ONCE'
>    50 |         __READ_ONCE(x);                                                 \
>       |         ^~~~~~~~~~~
> fs/overlayfs/ovl_entry.h:195:16: note: in expansion of macro 'READ_ONCE'
>   195 |         return READ_ONCE(oi->__upperdentry);
>       |                ^~~~~~~~~
>   'ovl_path_type': event 1
>   185 |         return inode ? OVL_I(inode)->oe : NULL;
>   'ovl_path_type': event 2
>
> Avoid this by allowing ovl_dentry_upper() to return NULL if d_inode() is
> NULL, as that means the problematic dereferencing can never be reached.
> Note that this fixes the over-eager compiler warning in an effort to
> being able to enable -Warray-bounds globally. There is no known
> behavioral bug here.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Kees Cook <kees@kernel.org>

Applied, thanks.

Miklos
