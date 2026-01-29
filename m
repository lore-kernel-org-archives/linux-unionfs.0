Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E747377562;
	Thu, 29 Jan 2026 08:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769675888; cv=none; b=IFYPR9Za9W0e/ljwAF7VOP/lAbBYsNOvi/VR+Y51QM3iilMTU9EEPyIVdvV8su4K6Z/XHsMHpVr2+FaSIXsp+Uuse1Fv8xrbhW4qkrZsn5dYR0dk6rzE8wplSaeHJZEHbuZ7rA7MvTm16TZTUBUM97djrZ8TiGFYzQZ4o9AVHlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769675888; c=relaxed/simple;
	bh=psYjG1UusZhW3q4FunD3OFstJ/UcRbNIN0k/NkFAGKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZyAWSWwxnIBsYkmwZoRG6+wLcggTzxm3+VWrrvx6bn3YRW2OgjyH/7JMME8OJQ5NClK6P1/nTQE1GuTyGk/Luhi/nK8Ea79SAPrdwviaPOKEiD9TcM17gKfBz1SY66jfR6/JnxpXxDrJbELz+7CbyZn8eUFDUfd4rldz+Vu3Jug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIpJ7esg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIpJ7esg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532DFC4CEF7;
	Thu, 29 Jan 2026 08:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769675886;
	bh=psYjG1UusZhW3q4FunD3OFstJ/UcRbNIN0k/NkFAGKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lIpJ7esgAYw0PrvReZuKFG9x6VjuiEvXkptdGII1dAdZIHYA8o1I6teJ0nFrVUrDI
	 gVwCPyHceiDRL/kCdRWY8UnQP8odUc9nTuZXdeOt3SOsZl6XRtARwj75kYttUr23Ub
	 hHixwdZYglsNJJLcHtZv9/reAta1WMpBwPj5GucsP/12gbpvsx+13wxBumJ7XINoA5
	 ewxQpxmV65FhH9fIpAWYOhoAp5u9DXiCbVsnoH093DvMA+/+8pyPAjGpVkQQ/L6C7j
	 ZGGEBd6DjB1U0h8LfE6NAA528W+3vbUW9Lt7ctNCt+mjJZjpyxgDGwZcFp+oPp27UT
	 9PrDeog+CEP5A==
Date: Thu, 29 Jan 2026 09:38:01 +0100
From: Christian Brauner <brauner@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Qing Wang <wangqing7171@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 3/3] ovl: use name_is_dot* helpers in readdir code
Message-ID: <20260129-lagebericht-ziehen-605070b5467a@brauner>
References: <20260128132406.23768-1-amir73il@gmail.com>
 <20260128132406.23768-4-amir73il@gmail.com>
 <20260129001443.GE2024@quark>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260129001443.GE2024@quark>

On Wed, Jan 28, 2026 at 04:14:43PM -0800, Eric Biggers wrote:
> On Wed, Jan 28, 2026 at 02:24:06PM +0100, Amir Goldstein wrote:
> > +		if (name_is_dot_dotdot(p->name, p->len)) {
> > +			goto del_entry;
> >  		}
> [...]
> > +		if (name_is_dot_dotdot(p->name, p->len)) {
> > +			continue;
> >  		}
> 
> Should drop the braces in the above two places, as noted by checkpatch.

I'll do that when I apply.
