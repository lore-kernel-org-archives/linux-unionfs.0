Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393E682C60
	for <linux-unionfs@vger.kernel.org>; Sun, 15 Jun 2025 19:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750015242; cv=none; b=qB9sA6OWgtjNLxb8emD4CDjglX7B7rrLlbiEJ1vI9vRLZBZymjN8JyATx2eM/IcQv/a3ZyvK2a0KxzHZmhiWQ0OiTibz45WhtvM1q8YzJex6z0n96VjSOa7o8DXUmP9oAkmf3WZLj1/nvaX8OYLfmSqaqh8PPlPoSfW4VPgNL0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750015242; c=relaxed/simple;
	bh=Hy7UGrEYV8dvlu3TyM7TIqB0QE7xVRRnwK0LdghV0yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lJmlxDQUEQYBsX6t4CsD1kWI9BfU7IPYXNEF+FSKeEIidIYtpWa4KCT8vCUA4z40WqfdMzP/GcZVZQ7IKhWIlCz9LzUJ0nvHwoKP49T8YgTnxkPCM3+1fpgGl1xWdpUiUUnyB1Gw5HOFYJqCX9d97O2vKlq0fQ6YxNqfqOPHqAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Miip8bYM; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Miip8bYM"
Date: Sun, 15 Jun 2025 15:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750015236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MKDp9IiF/iWKE7Om3zUoXR+MosPHV4Kwr2V25hWDfpY=;
	b=Miip8bYMUZbnTd5ND4RcI3mOLulD57OF4hCfngX8VnOMHqG1GT++ZLdjWKSX3nlXPjcJ13
	SY28vMi+7hrUZWl+9/d1aPuyCyzMr+n0uDNnV8rrLrn96csgVXZmuc64cEPazEXD7qTacC
	a4dVvipFi0vBbSvGyY7M3LPsnszA2YY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v3] ovl: support layers on case-folding capable
 filesystems
Message-ID: <oxmvu3v6a3r4ca26b4dhsx45vuulltbke742zna3rrinxc7qxb@kinu65dlrv3f>
References: <20250602171702.1941891-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602171702.1941891-1-amir73il@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 02, 2025 at 07:17:02PM +0200, Amir Goldstein wrote:
> Case folding is often applied to subtrees and not on an entire
> filesystem.
> 
> Disallowing layers from filesystems that support case folding is over
> limiting.
> 
> Replace the rule that case-folding capable are not allowed as layers
> with a rule that case folded directories are not allowed in a merged
> directory stack.
> 
> Should case folding be enabled on an underlying directory while
> overlayfs is mounted the outcome is generally undefined.
> 
> Specifically in ovl_lookup(), we check the base underlying directory
> and fail with -ESTALE and write a warning to kmsg if an underlying
> directory case folding is enabled.
> 
> Suggested-by: Kent Overstreet <kent.overstreet@linux.dev>
> Link: https://lore.kernel.org/linux-fsdevel/20250520051600.1903319-1-kent.overstreet@linux.dev/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Miklos,
> 
> This is my solution to Kent's request to allow overlayfs mount on
> bcachefs subtrees that do not have casefolding enabled, while other
> subtrees do have casefolding enabled.
> 
> I have written a test to cover the change of behavior [1].
> This test does not run on old kernel's where the mount always fails
> with casefold capable layers.
> 
> Let me know what you think.
> 
> Kent,
> 
> I have tested this on ext4.
> Please test on bcachefs.

Where are we at with getting this in? I've got users who keep asking, so
hoping we can get it backported to 6.15
