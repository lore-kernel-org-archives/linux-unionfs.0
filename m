Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DA33D410C;
	Wed, 24 Jun 2026 20:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782334208; cv=none; b=APUXbpMRee41ThlAhJfVNJ7EFc9xVUDm+PhtkFroIV0vodrxnof5CR+athbWRNGnOEXC9UBnITVIwdkhufyDZ/aiu5AI3taF+WnGlkstz3eFGborT3QMwUqRcH2d3cZarCreDtiEibzCELX4JdIxZgUM//ZlLl6KG2jG5h8NSgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782334208; c=relaxed/simple;
	bh=DN+O8QKZHtW1TGbXSYAD+zYb6UfpHFHFzZPbSwO0Vgc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=NCSPDPHHesKYq0cdcRG6KiicsHf4DpEWNT3757ZlKMU0cQSG3dk4ilDH0VLJA+N4IsayRUCLXTw239N0E37ThNUBsRV1KhErH7scDBR01mFkW2RtcsCX20JZ55LYcsJkMUesTgPd1mMq1+oYpFOa03RikFEhq1gDKADVLHyLYag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j66JsQBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j66JsQBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7001F000E9;
	Wed, 24 Jun 2026 20:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782334203;
	bh=mt+5vsX/ekVrYMgwH57dH0T4RbSG+uoxTYLUskkE9Z8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=j66JsQBMFPs41v9dNwhtsaZf3xJtm/qweu7T3hqT3ZyF41juOU4ndrACbcRVqcjZL
	 dSN0uceGGNpUbqclvZD/XfLshUX76h/TegbdmR/p82Ockzg25IzACznehVpcXk86pp
	 lHITeEX+0UC7kjKAAQRbgOjH20YNg9VNUFQJPMXM=
Date: Wed, 24 Jun 2026 13:50:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>,
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 0/3] ovl: make cachestat() work
Message-Id: <20260624135002.09ab1f9387eb4708b0707175@linux-foundation.org>
In-Reply-To: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Jun 2026 13:14:47 +0200 Pavel Tikhomirov <ptikhomirov@virtuozzo.com> wrote:

> We were using cachestat() for our internal Virtuozzo cache related tests
> and I saw that test behaves wrong on overlayfs, syscall returns all
> zeroes instead of any meaningful cache statistics there. Let's fix it
> similar to what was done for fadvise().

Thanks.  Sashiko seems to have a found a couple of issues:
	https://sashiko.dev/#/patchset/20260623111533.2285005-1-ptikhomirov@virtuozzo.com
