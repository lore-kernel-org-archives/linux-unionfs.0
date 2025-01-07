Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7404318A921;
	Tue,  7 Jan 2025 16:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736268533; cv=none; b=lIPATMCumv6ZasEtdxFf8rP/usbEhsflN/w5PdKxQgEILg9enir+8y9q6MVXTkaXeGzb7HhS9CDiRTOSahZzn+8yATNl+bGYlR4CFxD0MB8+OBD5Fv9TfguO5lzXEUyWe5tvOO515RuUbY+AY4JywS6AwB36iWLmuf9aYZCcOxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736268533; c=relaxed/simple;
	bh=ZhkH2CmTXTPJbo/ZyLlsuVhhGPV8NAOe7seFpwYCK7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=quPQoFy0AsnxpfxeCMIRJmtlzW9ttWdq0X+wLhDaYu5YDqHciHRCAZTE4i5a3mx+dZuototJYvBP72R2TQ9Sx1+weuk1NvVBeUQ6scuELtL+zSV6jc+66Ju75y3cEqAItG4r1IdygGPTHIJp0YeR2GO8L4Rp3hqN4HcU7o7qui8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ps2Wgyqj; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ps2Wgyqj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=p1zFuHZ5Sl2IM0M0xSHGDVLawN4vSXAk61nFmFpFr/E=; b=Ps2Wgyqj89+pmq5uvhAwnWT2NA
	WKBP9hT0b+fK4sUtN0WR9xDe22Xg7atOv5FnoH/LBxd8V4jL7VzrIOQ9zwYxXQ1YsiuRggf1VwbId
	PYArx+9JWXOOdaatcnHmo5Bn1EVLu0GeowKR9C2p/kGGCc/9WJwpcxOGWKcq5gFNxoQnUnM1YCt9z
	+ogp/R0TSLaFby3ze4qzV1FlSsDE+utPGrNNmFpUS/Xj4M0xc74A1TOgC0WAnxAqxAC6wb4LBOQlD
	l94k1CkXl5MZ9tBKzF4L8aUuKv2OXTLqpo4GO76EivhA8O0da9+uWugA0bDS/krDxLllmflLVvzat
	2x4qvCFQ==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tVCl0-00000008N73-3zac;
	Tue, 07 Jan 2025 16:48:43 +0000
Message-ID: <dd660b4c-fe71-4237-a9ea-e574785e152f@infradead.org>
Date: Tue, 7 Jan 2025 08:48:37 -0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] overlayfs.rst: Fix and improve grammar
To: Geert Uytterhoeven <geert+renesas@glider.be>,
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cf07f705d63f04ebf7ba4ecafdc9ab6f63960e3d.1736239148.git.geert+renesas@glider.be>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <cf07f705d63f04ebf7ba4ecafdc9ab6f63960e3d.1736239148.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/7/25 12:44 AM, Geert Uytterhoeven wrote:
>   - Correct "in a way the" to "in a way that",
>   - Add a comma to improve readability.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/filesystems/overlayfs.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index 4c8387e1c88068fa..a93dddeae199491a 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -266,7 +266,7 @@ Non-directories
>  Objects that are not directories (files, symlinks, device-special
>  files etc.) are presented either from the upper or lower filesystem as
>  appropriate.  When a file in the lower filesystem is accessed in a way
> -the requires write-access, such as opening for write access, changing
> +that requires write-access, such as opening for write access, changing
>  some metadata etc., the file is first copied from the lower filesystem
>  to the upper filesystem (copy_up).  Note that creating a hard-link
>  also requires copy_up, though of course creation of a symlink does
> @@ -549,8 +549,8 @@ Nesting overlayfs mounts
>  
>  It is possible to use a lower directory that is stored on an overlayfs
>  mount. For regular files this does not need any special care. However, files
> -that have overlayfs attributes, such as whiteouts or "overlay.*" xattrs will be
> -interpreted by the underlying overlayfs mount and stripped out. In order to
> +that have overlayfs attributes, such as whiteouts or "overlay.*" xattrs, will
> +be interpreted by the underlying overlayfs mount and stripped out. In order to
>  allow the second overlayfs mount to see the attributes they must be escaped.
>  
>  Overlayfs specific xattrs are escaped by using a special prefix of

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

-- 
~Randy
