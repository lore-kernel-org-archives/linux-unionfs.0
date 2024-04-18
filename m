Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7FC156862;
	Thu, 18 Apr 2024 09:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713431874; cv=none; b=QYBObiDBnYBMoe3Zrl5fw4s480YDVV2cTheft/W2oYR7g0hpLjO7+ivIQu1xNqxNSMUscDegqqzk1OwHDYXFKL271SntWOeN9i6flqiYQ9wSfqTqaDHMOfWyyO1F/zDMCNEg+OmIa5BTFQJKonOPy6YCY3SweU0OLH0B4ZpfvIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713431874; c=relaxed/simple;
	bh=pGUqXIOByDJOHwLjKEiP4YqawP7FgA22/lCz6RZA1CU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHSQ2ljsJ4ePcz39bzgcBlBGgAj+tl7HRS9c5YD1xtbbOV8BOGDM3iBj7T8apfG9KkfFPjj1XxoZ/wFXX3l03phxvI/tLdOqvC+h1mOmFeke+OxogHJ7R1a5kQQJ87corKQk7JiDbkGwifAdZT0i0g6/+kdVaaRhzmXJzqi1Q6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U0Tvvtke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U0Tvvtke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B156C113CC;
	Thu, 18 Apr 2024 09:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713431873;
	bh=pGUqXIOByDJOHwLjKEiP4YqawP7FgA22/lCz6RZA1CU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U0Tvvtke391yvUO1Cme5AvyMdhygxpV5Kc6sA173Z9bzlEBYrppsVNbTVIsdbwZk3
	 lpiqI8ak3JZOXURWWeS+aqcpIefJEhAnblDrwZJ6nZ4IZiFrujQm/JqquEEDcUsenm
	 LdBwkBkPiFnLj5S5OSFMASWT//Km/zUKLKuAsb/61334PnhIucvKDF8oHt8UwLoAgc
	 2jBvH0V+3CYQSSTSOzdE+as6ku3+TDtbJwEb8mlwLGZab2XpOMnaDzD3x8FajIza0O
	 9sMm1Ivrkd1Q76HcqTK5nhIjLFd34x0Tx33goy9eeZ8Zq0cwzc7C6tk7WBFhASTU4i
	 FPB2hrMjX9Jqw==
Date: Thu, 18 Apr 2024 17:17:49 +0800
From: Zorro Lang <zlang@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] generic/732: don't run it on overlayfs
Message-ID: <20240418091749.nwyzmjwvdtkugzu3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240417130102.679713-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417130102.679713-1-amir73il@gmail.com>

On Wed, Apr 17, 2024 at 04:01:02PM +0300, Amir Goldstein wrote:
> The test tries to mount with same mount options on two different
> mount points.
> 
> Overlayfs does not support doing that.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Thanks for confirming that.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/732 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/732 b/tests/generic/732
> index 5b5087d5..7a40f49b 100755
> --- a/tests/generic/732
> +++ b/tests/generic/732
> @@ -22,7 +22,7 @@ _cleanup()
>  }
>  
>  # real QA test starts here
> -_supported_fs ^nfs
> +_supported_fs ^nfs ^overlay
>  
>  _require_test
>  _require_scratch
> -- 
> 2.34.1
> 
