Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6903E44E9;
	Thu, 25 Jun 2026 12:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392004; cv=none; b=DM60vC6cCti+U1mN7XH+VO+TO2mR00U24g9NZmlRtbIiqXROucVgfilSVw6E993AJoCeNAcxG1j1MD8PyTaBCy5iWeWY/5gvUSRpJUWFF6DY0rtHP2Zy3Bd3E8kZVYxxEB7PM1UOucsqbmkr7iBwm3LUUxW1dS9+ssf3sE6I+Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392004; c=relaxed/simple;
	bh=FJ/2sqPH3xnO/qDjRRGvaOhRiNhaCAXXfpe38vDvhMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYWOsP9ifzpH6L7wnSA+749PMKTYehhIsIC+fMI0oFAMHAtnXp9nMo0c5qe3IkOLE+DMp03g4PuIc7iS6P4thT/WeGKqJAS7XaDgiK2S+WLv7gbWL3rGwhilA5sv3JbVTOskwebW6YmjmCV+el8LRQyMR4LQDEy0g5/d8e0a9F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BfTacltp; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BfTacltp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZZDw2s9zWCThga9eYDfaH2QZEXuAsHn0UQSlAmnIq8U=; b=BfTacltpBMagNVXRF/YTZVepiI
	EavhoY9X0cCWU1/Ern/Te8gkPdpP+fPcwzA4UWpCp0kGH3Vkvpg6sfAOwMU6wVF68ZP3IeFbwVdq6
	T/yvy+eYqEvt+t5bGGHuvREHF3FdEWV0fgxFHruRvO1tcb8uRJv6JM+luAG5l61/JrVSZjVocjsTc
	XXVkjOKCmNWlCxEU9aEfJLTJi0qcwqMBMDooDovRcR6A00yO4qn3aH4+gk8Epa+DIpd8kQ5X6lbro
	KZJgcp3JxrEx/nNvlyzGth65EEQVG0yk7aIpeSqwGO/S4Qu0DqUshLPfCg2pw97blOUZA3bnyse0o
	SXs1WN6Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcjZz-00000009uyF-1S8Y;
	Thu, 25 Jun 2026 12:53:15 +0000
Date: Thu, 25 Jun 2026 13:53:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>,
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
Message-ID: <aj0ku26XNT7Xc8x9@casper.infradead.org>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-3-ptikhomirov@virtuozzo.com>
 <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
 <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com>
 <CAOQ4uxhPROaeEyYceKNsL5QVwVPkTjGtbRr1P_TYXTA0fHvRoA@mail.gmail.com>
 <CAKEwX=MedyK8aDM=oe=Hbzo77mJOEp0Pmo0u8N4HhvikosVbSw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=MedyK8aDM=oe=Hbzo77mJOEp0Pmo0u8N4HhvikosVbSw@mail.gmail.com>

On Wed, Jun 24, 2026 at 12:06:54PM -0700, Nhat Pham wrote:
> I'm more concerned with undocumented/unexpected behavior (error type
> in this case). -EIO was an example that I saw in ovl_real_file()
> itself, but I'm not familiar enough with overlayfs to know if that's
> the extent of it.
> 
> But I'm OK with just updating the documentation with a simple note
> that other error maybe propagated from the underlying fs, if no one
> else thinks it's a problem :)

That's ALWAYS true.  POSIX even says so explicitly in section 2.3:

  Implementations may support additional errors not included in this list,
  may generate errors included in this list under circumstances other
  than those described here, or may contain extensions or limitations
  that prevent some errors from occurring.

We don't generally bother to document that pretty much every syscall may
return -ENOMEM if it can't allocate memory.  That's just ... expected.
open(2) documents the possibility, but read(2) doesn't.  I think it's
the same for EIO.  Any operation which accesses storage can return -EIO.
