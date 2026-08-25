Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63004322FA;
	Tue, 25 Aug 2026 12:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787662421; cv=none; b=d2o17kggl85av4rBUm78QyfGRtZHP4CXk/6khYqYq+6oi0YFBn3e+yZzzlKyh9taZndzacQBHo5xuz3XaJwHugjirVF1eMwTMwZMYjOtfMtWrMbUFEzxr7q1w+musk3FGFnU1KfhLW1+4sOolJA+91n2E7VVekg7Q1CGctA8owM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787662421; c=relaxed/simple;
	bh=Of19rIAK27GoN4N5jCqBLABBmU+V1b4MUKeDj1a5I7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5TWvMrkqy8b7sOSbqo99oP+9ffX4+lGpXsymWRjbreSGcn2WXfVKgYoFSnilspRyp4V0NEc1qY165qXJ0RKsE2yjMgSQU5mh6gUxtiorNwM9pdJKunqRSl1jXnj7Cx9mCeq57v+7/e5tUqEeJ+JIIx1RmvZR3o1CzejhHas8Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMgPGuE4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMgPGuE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08231F000E9;
	Tue, 25 Aug 2026 12:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787662419;
	bh=cFqy0iZQM8tBm4oUMpoq1Y2sfynDkv1QLYRiCrkswLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WMgPGuE4HqraYVZGzhXNVOSIgDO27+l8s/aPGUiNZT7UtGArJEBzBt5UmUmrn1Idb
	 0K5L304bw1C63sT/dJSsF0cxthKDnjDYybwwjzycNEsdHTbWw2nsbS/b4byRYN3ff8
	 aRskB3LruXllKqarOjnhf0f9e30uW1iBL7+ldqlrBswwLd5gCOQAebG3vnqFUjffQT
	 lDlDh97OrbS/guxsqzeCCDv2IxUTChh3+TA8GsydTD94ZuVY2DYa9+8KLVHFHb+zID
	 wObzsX+sqlT8iqky78FYjLsbrgVJxEQcXouLZREpgCR6O87MEMDjmo0wWf2Apya0Yb
	 pVMDPFjhTcjjA==
Date: Tue, 25 Aug 2026 14:53:34 +0200
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Laurent Vivier <laurent@vivier.eu>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ovl: don't warn when the mount is completed from
 another user namespace
Message-ID: <20260825-ganoven-waldweg-lappalie-3252be210162@brauner>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
 <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
 <CAJfpegtXbdpFZmV2dYSbp6eL0DBGmZin98TFr42nxJCfuryfrw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegtXbdpFZmV2dYSbp6eL0DBGmZin98TFr42nxJCfuryfrw@mail.gmail.com>

> Just one comment on this (I know it's been merged, will do a fixup
> patch):  EIO should be turned into EINVAL.
> 
> The EIO was used to signal an internal error (commit 9efb069de4ba
> ("ovl: add warning on user_ns mismatch")) , which is no longer the
> case.

Sounds good, thanks!
