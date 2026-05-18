Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB05A413D98;
	Mon, 18 May 2026 12:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107969; cv=none; b=gGNUpe2OtYlF4MqqqiBq34jwlXWl2ks3e4V/C6DOl+3+/dqg546o6CV1jLlE9N1KliXQ84feKOd5mLIIBQAaTlU3ZDgbZj4UGEJ9u6s+5I+9B0mxNKGMqO2CuCFOqS7Nw694UOHOAgNdZlxdfnYMgb6htvrH+QgqxwysI40DGGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107969; c=relaxed/simple;
	bh=x1GZct0kHpiebRpuC7zyhG1VkHQuaURL5GL16ev4ciw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMPop8Mb0FhASWX+rNniYP7rAhnQjV4HS9+eeZlNdrKMGRRhGGIz67Jq9JALr+aUWaHfqeMtMX4O8k3T6QkHRAqAwc7FgNLJH94FafyUb/8EuKm7taYEErJ0zcJCFo6eGgAnB08LaL9zrOUQ+e6hBbR7gTihHKkgqUM8M/+urYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Br2U2CNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Br2U2CNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832C1C2BCB8;
	Mon, 18 May 2026 12:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779107969;
	bh=x1GZct0kHpiebRpuC7zyhG1VkHQuaURL5GL16ev4ciw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Br2U2CNstNnfO3cl3lrEaWk6grj6YCisQmO+xWgic+/70+V3X8rrqeOnTR4Mr4z48
	 IkuEeoRra69JNzcil03R+8+Ws6GsaGtGXIGID68k96vDUaMStCBeXpID2XdeZ7CFh3
	 xM8WKhsbtrgre2Nd+tDBHUyRiiG0I5GL5Bi8n0rVeYY64F/mk1PubOQT1J7pJxLsLs
	 ZP7HZU9VZ0+j8nCm6n0uoW5n8ltDGl6AqzpuUxEVgNGnJRYTZvhBZPs7ZaUzdMcg3N
	 7E/eCiCBiCZlpurl3IvU0Hxxb8EGKuKjfqdVjHHuKpa3GQK6POicvLxERuvX8KB4Ng
	 WNTcAlR1aWVgQ==
Date: Mon, 18 May 2026 14:39:25 +0200
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
Message-ID: <20260518-rundschau-rohkost-e591e2d0deb9@brauner>
References: <20260514200129.94862-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260514200129.94862-1-amir73il@gmail.com>

On Thu, May 14, 2026 at 10:01:29PM +0200, Amir Goldstein wrote:
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

I think this is backwards. You can of course do whatever you want in
overlayfs but I think as a first-class concept in err.h it's not that
great. Then we have to separate macros/inlines and almost no one will
use ERR_PTR_SAFE().

I think the correct thing would be to add an assert into ERR_PTR() and a
debug-only one very likely at that and combine this with the static
analyzer thing mentioned in the thread below.

diff --git a/include/linux/err.h b/include/linux/err.h
index 8c37be0620ab..6bf768adf157 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -38,6 +38,9 @@
  */
 static inline void * __must_check ERR_PTR(long error)
 {
+#ifdef CONFIG_DEBUG_INFO
+       WARN_ON_ONCE(!IS_ERR_VALUE(error));
+#endif
        return (void *) error;
 }

I'm not convinced yet about ERR_PTR_SAFE().
