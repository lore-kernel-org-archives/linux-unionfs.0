Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795281568;
	b=zXjshWSzup9+ZmRUXLvGnysAAeHV5tInCZzQDLQjJDT34pjzXbh8iC/ZQag9uIqUUXpT
	 TX/Rl8qWga9VmSCnqaqwqYjvE63tx34wdNH7/WH4kkBbCOO/eqMCjbqA1WTDcaAi/ol1c
	 H8iG1Gxwk4fXdJELpOYq6ZySffRmeD6rYIF70NFTq1YonALR6yWuKyg+GQI9UgxK/XIrB
	 m72AqBGMXUIM5GYHUT2sEqB18Z59T0DbkGtboj7fmA9cy0M/D3ZLiz3H4bsFpcQ+PZLMl
	 8Xc6lvSxC8bnwka3ESg5PATVJBf9HT9RqZKFv41vRJCuhwjr+A7jp4XRxrqE/FCvPPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281568;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Ssw+DqUMswGGFnd0hmK6VkHcR14rpbon5k46W9ZVRX8=;
	b=iuUgXE1I4gz6DGEwPIDrrp+QP7m1ZFJJNkzWhkBR/vR+f7Rty8jL9/sOEx2U4YjY+kVc
	 tUpVDoslOb8g4amTRoZbuRodBdm2XtbECbZO6kGBIMH53WTgSbfu4fb+XqUpBu1UOUUUw
	 NnozjzYRMCO3Tv8lqKsDEXHtgFjtQZ0IVDzOjLpfDTMEyT9DYCF5MLFAEcOIJCwL9q3Pp
	 Jq5B1z38ZVVCXXdw84nOfwnrpjZnRGNmShQv8IhQ+C+HNTfqfOEMffhF574BsZDVUP2ON
	 YEb4VKgVdss5tU+QX9I4P3Xl5wORlBFlwKfjPgg0XrTk8LYtMl1LZKE6E4b4NPQyVlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HfzP3hTi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED1B606A320;
	Sat, 21 Nov 2026 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HfzP3hTi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA481F000C4;
	Sat, 21 Nov 2026 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795281568;
	bh=Ssw+DqUMswGGFnd0hmK6VkHcR14rpbon5k46W9ZVRX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HfzP3hTiDS0/XOinjFibodrC0Gpu8Um+4wbMsE6D3ruc1YRy4MXRp3qzOUFYQuO8Y
	 FeVVfgEgHcApezuswStlAxdHfOCOlUH7njKIqpj0RKmlfIx8AF00OhXzNFNGZdIgMy
	 ZuXbqheCccA9uWWYMcRR7VeJvRfYhWfFvfbo0eNlItt4DfRgTeJwYrccAg0ZKjLezo
	 xZXr/GbEBCIm2X+w61+yFSLySb43NotB5pthjZomrfjGVRI6w3wbFL68EuVadr7uJI
	 0rQNyDA1ecCp9LTXt+TAamgzvp1cZz4p8cWr23GS8gBpJFE1sW99xqE4N9i9ezq79T
	 BNGEsLbYd1I1g==
Date: Sun, 22 Nov 2026 01:19:19 +0800
From: Zorro Lang <zlang@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org, Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Subject: Re: [PATCH] common/overlay: fix _check_overlay_feature for
 default-on param-less options
Message-ID: <awHSXIxDUNu2kacw@zlang-mailbox>
Mail-Followup-To: Amir Goldstein <amir73il@gmail.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, 
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>
References: <20261106155832.3867017-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106155832.3867017-1-amir73il@gmail.com>

On Fri, Nov 06, 2026 at 04:58:31PM +0100, Amir Goldstein wrote:
> Overlayfs only displays a mount option if it differs from the default.
> Commit 73a018cb treated a feature without a module parameter of the same
> name (e.g. xino) as default off and required "${feature}=on" in the mount
> options.  On a samefs xfs setup xino is on by default and is not displayed,
> so tests requiring xino (e.g. overlay/041, 043, 044, 067, 070, 071) were
> wrongly skipped.
> 
> For features without a boolean module parameter, assume the feature may
> be on by default and only verify that the mount options do not show it
> with a value other than "on", same as for features that default to Y.
> 
> Fixes: 73a018cbf57b ("common/overlay: let _check_overlay_feature handle param-less options")
> Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Looks good to me!

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/overlay | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/common/overlay b/common/overlay
> index 132b2bf7..0cf6db2d 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -172,24 +172,20 @@ _check_overlay_feature()
>  	# parameter (the system default) and per mount by mount
>  	# option ${feature}=[on|off].
>  	local default=`_get_fs_module_param ${feature}`
> -	if [ "$default" != Y ] && [ "$default" != N ]; then
> -		# Some mount options (e.g. uuid, xino, verity) have no
> -		# on/off module parameter of the same name.  For those,
> -		# a missing (or non-boolean) parameter means that the
> -		# feature defaults to off rather than that it is
> -		# unsupported.  Unsupported options are rejected by the
> -		# probe mount in _require_scratch_overlay_features.
> -		default=N
> -	fi
> +	local value=`_fs_options $dev | tr ',' '\n' | grep "^${feature}=" | cut -d= -f2`
>
>  	# Check options to be sure. For example, Overlayfs will fallback to
>  	# index=off if underlying fs does not support file handles.
>  	# Overlayfs only displays mount option if it differs from the default.
> +	# Without a module param of the same name (e.g. xino), the feature
> +	# may be on by default, so only require it is not shown as non-on.
>  	# Overlayfs may enable the feature, but fallback to read-only mount.
> -	((( [ "$default" = N ] && _fs_options $dev | grep -q "${feature}=on" ) || \
> -	  ( [ "$default" = Y ] && ! _fs_options $dev | grep -q "${feature}=off" )) && \
> -	    touch $mnt/foo 2>/dev/null ) || \
> -	        _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${dev}"
> +	if [ "$default" = N ]; then
> +		[ "$value" = on ]
> +	else
> +		[ -z "$value" -o "$value" = on ]
> +	fi && touch $mnt/foo 2>/dev/null || \
> +		_notrun "${FSTYP} feature '${feature}' cannot be enabled on ${dev}"
>  }
>  
>  # Require a set of overlayfs features
> -- 
> 2.55.0
> 
