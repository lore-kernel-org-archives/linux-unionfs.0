Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E23C3D75AF
	for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 18:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778869826; cv=none; b=YdE1lSu2EofTrb0U9vwOcZJqTvoYsPC2dQ2nvXb7DVQv8KDz8DakbuBlpSwdy1QH/pugJ9XyUtItjFZRfr68Q8qiMev48B20uSFuyUI03bf4reABX/DqjxXGf04yNGBY1nO0cDPbw6iDSXj00e4/u7+ALlE5+qnTqm7BOCyIThE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778869826; c=relaxed/simple;
	bh=FJ1CmlQ6zsQ+MAOInKPXJ7AX6bhdHoCN86zCtwhXZnk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rPIv64FuXaZkrsKcUo8Tv0BJMbCkm7OFKm26DkqsaF8p/xzWiKbLaDx9oEmwHoO+6iFgvytQRNIptiZhU6BJH2Oh1tYp/T6OFBoQDmzpSNEeJwe2+IYq6jVq6qzZmVrZCP/p7n4O4NO0Wva6p1cBiKA7alD+/XjuLv+HvzW4xOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eF8KJQqi; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eF8KJQqi"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48fe26a177cso945195e9.1
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 11:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778869815; x=1779474615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bGg9AfFIHCQMhNpGBqKuAPyLtBd2s31DOya6UeJpRsE=;
        b=eF8KJQqibjj74DPejC5OBynfnjR13KWslNh0CwKYoHa99ltu7nt6/f4QFm/W7bms4D
         925Z381ODL1h1aCG3XxuEcprQ5hpfVGneAzV2tEWPsbcsYgL3oEyUnDOVPWrc0hBoAOD
         yUcTbd0+MEoVwU5ANvicxAl9V3/USqIq+3XjjuLr1hDx3gak7ny2y7P7cpVMojVz1z/9
         3bZkb3e8dMiCsB8KkD+q2f0pU41bnPMQHoyCADztJzYfS8AAgtnfJSUCQhLMZo040Apk
         RqlICK5NXkmB7MGbkgcLvTcl/XHghtverAuj/aByUmGrYUn5Hv51il0Smapio6Cgel0O
         qiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778869815; x=1779474615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bGg9AfFIHCQMhNpGBqKuAPyLtBd2s31DOya6UeJpRsE=;
        b=tRrgRU5j4PNjT7g9tlMurH9uNQpZ3LzoTyimauQBMSXLeUGXrWeq7gnZjR2V5JgJR0
         bebtDJq5XL1WeXHKPFI1yEvjpdfJgnb/FMfjmQxjhefhict8Ar1OhjFFlu0tiwAIkiCe
         FPa6ULVr+PCX3HRPH9SxgI6Goa/CvMIgLbdlhzIgP//c3nKhxlzjkdmwS/BgYmS3FtQm
         s8EvmhdOATOjs1Sy2PJotzNCSi+HX+pPmzyMRK6qa5GC0l0QF7bKFrDkTnt3Z1FOSJIs
         2FgcueV2U7YfkMWo3s7llfxKjcLYcLJ+e1jOjV0UmmN8zO7aoYIxhNL4QRO20+Cq7IJs
         XlZw==
X-Forwarded-Encrypted: i=1; AFNElJ+Tm7sBQA0sShNTfJm5LF/F7+ytjH6RcxjW5vXC8F7igmFweAtpf6wfHGS2tjpp89D91Yc7T9jzo1O5N2/P@vger.kernel.org
X-Gm-Message-State: AOJu0YxfsGoHqACMvHBojnzDIMbxOTzN6ZdqspH7o5QWQCRorvTKzVSe
	E4q/kwWO/l26g7A0u7BiZRBXUVahdAbZfAvVSNuF7iKvDbIIVW9rxWlT
X-Gm-Gg: Acq92OFo9+Hd9wQ06zTOQDgmR/FZHdcm+EOtzDLzmHnCrQIqRk8OuFHazCnuqJVf420
	nvzzS5KnXfBkQN6jv/nGg0cWXSwpmf6TGrStLAoi7tKDab/36QPpws18/a1D49nnwGFd5WJEEib
	0rPvszBu/MUFMWzY51rDMtSco+8nvq3rUz/9ueDgMy3qpM3UyHd8Gcv6mIv8JAepzVAkG6LDKr7
	XpWzCmH//Od6VPEiizeyELmhw3I8363nHfL5V4qIFoZhSqdoVEHulzsHOG9HDU+1Np2P+dhBQlV
	FmZ30joVfiSa2V936vDbaopsat2Hktm8b6+Q23sHoFSLcwTE2ltIB0zl3IgLYGKlJ6bQ4SXmNTV
	1RtLRTpfmFV7ygFcqYLECjL+8ZmjhyhK4obz258qn0mdKE76g1yP6AHRAGT+4AdG47PWkFq76Le
	A+PtGoLdG9geYeELCinNqt1zruEPPeqXgahaDEyTtIuAq3vpuPjDA8Uaw+4gMW
X-Received: by 2002:a05:600c:470e:b0:489:201c:dc46 with SMTP id 5b1f17b1804b1-48fe60ea590mr70278195e9.12.1778869814718;
        Fri, 15 May 2026 11:30:14 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4862209sm78901635e9.0.2026.05.15.11.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 11:30:14 -0700 (PDT)
Date: Fri, 15 May 2026 19:30:10 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Al Viro
 <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>,
 Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
Message-ID: <20260515193010.056ef472@pumpkin>
In-Reply-To: <20260514200129.94862-1-amir73il@gmail.com>
References: <20260514200129.94862-1-amir73il@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 May 2026 22:01:29 +0200
Amir Goldstein <amir73il@gmail.com> wrote:

> Code using ERR_PTR() is almost certainly intending to produce a value
> which qualified as IS_ERR_OR_NULL(), but this is not the case when
> code calls ERR_PTR(err) with positive or large negative err.
> 
> Introduce a fortified variant of ERR_PTR() whose return value is
> guaranteed to qualify as IS_ERR_OR_NULL().
> 
> We add this in a new header file err_ptr.h which includes bug.h
> for the build/run time assertions.
> 
> Subsystems may opt-in for fortified ERR_PTR() for specific call sites
> or by #define ERR_PTR(err) ERR_PTR_SAFE(err).
> 
> Link: https://lore.kernel.org/r/CAOQ4uxg=gONUh5QEW5KJcyXLDF15HbLnc9Ea7RKPcgtyfPasTA@mail.gmail.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Guys,
> 
> Please follow the Link to see the sneaky bug that Nirmoy tracked down.
> syzbot has complained about this a while ago, but neither me nor my AI
> helpers were able to track it down from code analysis.
> 
> Honestly, with AI review, this class of bugs (return a stale err value)
> should not be happening anymore, but it annoyed me that ERR_PTR() can
> return a value which is not an IS_ERR(). It messes with code flow
> analysis.
> 
> What do you think about this macro?
> 
> I intend to #define ERR_PTR(err) ERR_PTR_SAFE(err) in overlayfs.h
> to fortify all of the ERR_PTR() in overlayfs code.
> 
> What do you think about this opt-in method?
> Any reason to make this more widespread by default?
> 
> Thanks,
> Amir.
> 
> 
>  include/linux/err_ptr.h | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 include/linux/err_ptr.h
> 
> diff --git a/include/linux/err_ptr.h b/include/linux/err_ptr.h
> new file mode 100644
> index 0000000000000..829ec5f771528
> --- /dev/null
> +++ b/include/linux/err_ptr.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_ERR_PTR_H
> +#define _LINUX_ERR_PTR_H
> +
> +#include <linux/err.h>
> +#include <linux/bug.h>
> +
> +/**
> + * ERR_PTR_SAFE - Create an error pointer, with validation.
> + * @error: An error code to encode as an error pointer.
> + *
> + * Like ERR_PTR(), but validates @error:
> + * - For constant @error: fails the build if the value is not a valid errno
> + *   (zero is allowed, producing NULL).
> + * - For variable @error: warns and clamps to -MAX_ERRNO if out of range.
> + *
> + * Subsystems may opt in for all ERR_PTR() call sites by adding after includes:
> + *   #undef ERR_PTR
> + *   #define ERR_PTR(err) ERR_PTR_SAFE(err)
> + */
> +#define ERR_PTR_SAFE(error) ({						\
> +	long __e = (error);						\
> +	if (__builtin_constant_p(__e))					\
> +		BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));		\
> +	__builtin_constant_p(__e) ? (void *)__e :			\
> +		(void *)(WARN_ON(__e && !IS_ERR_VALUE(__e)) ? -MAX_ERRNO : __e);\

The object code bloat would be noticeable if this were used everywhere.
But you could make it a bit simpler:
	if (__builtin_constant_p(__e))
		BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));
	else if WARN_ON(__e && !IS_ERR_VALUE(__e))
		__e = -MAX_ERRNO; // Or maybe -EINVAL to stop and other boundary errors
	(void *)__e;
 
The check for constants may be fairly pointless.
One of the static checkers may already detect the obvious fubar ERR_PTR(EINVAL).

-- David

> +})
> +
> +#endif /* _LINUX_ERR_PTR_H */

