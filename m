Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997016;
	b=a8F40US/TRWTG09lcZgU3enct4FccYXdDyeCqAzd7rJszUdS5FTsvYyy+Xa9xwwGLAOI
	 sdSRKVatroEqmMoHlB/rublCDM4vxijx403gHpiZHOj9Mh9xAJ7Nc327RC5q3NCuOiqSa
	 A/dY9LauEtabzkKvTZWU8TDKMGAXz5Rf9btQfakA6ixUSRhhE7ksAPQ0XT0Pl4cqldFsH
	 xwd/g+PwT3odPzd0gg2AiliF8s6awe9siJvFo+dXrHgSwJ0ri4IteEoQIApX9Y73OcFBU
	 ixFiRIt0fI/qkrEkHkTzuDybbI/ltpCwylSgiWEbzesj28EOPjpCq7SPoqgxcee6b0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997016;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=i3MZY/4BFEMm/Nd4VIbiiL2msebmVVY1wgnCPJ7wgJY=;
	b=21+YkqBcL1+/vKBtj3cE1I4MO67AVH/ElLyz0Shc1z8+intOGTtyLJ9krGheFBe3zZ5+
	 O0++2/dZs0MHicNVUU6zv35NvpdoSVR6UjitXGvt1UgeKWad+t1Vju/3/6Nj5An9t4Bji
	 scZftt3Y8UaxPiTSMELa+qX6ncaIan6U+xbAS81ATXoDJ9xiWrk9nxJA8ofG2aLWbojtq
	 rVjJpx3Yg1oR8tuhy9unn2afAuAsZWH7JXI986tajWu1Qd4ziynPztXSYS5iLrgVM1ZI5
	 HO6PyJ3euJ4JxYpf9oNOC5dGU9CO7Co0T5y6V37l8H76Zi6Vpfe4DwmtPoFcZIlg3WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L+dYBGG3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E5A606A31C;
	Wed, 18 Nov 2026 10:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L+dYBGG3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D4E1F000C4;
	Wed, 18 Nov 2026 10:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997016;
	bh=i3MZY/4BFEMm/Nd4VIbiiL2msebmVVY1wgnCPJ7wgJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L+dYBGG3HLecD4w6POvir9I5FNvgAMMuBAcCmUH00eWXZWxqnVCetZAxpGgAybtrN
	 7GrRT1p8vQmphHTdk9iyWCQoGb/GEPWKZyN/FoLx6ZWN/adFOzDJsSLqC8vMlSRSo6
	 4Ns3kxNY6LetlwjUKmFjCgwEvg3PXsDWaoXyOBHs7/EmLikfuUsTqq7j499XAJwiyN
	 XFbOJYSK9ag79uLdR2AiCkEJuo9e+GdRa+3hC1/a3LZD2T4wjTeqzLBXHCC4rZ1Lx8
	 6ttsUizEAF0gMsNES/K7f/Kk+rCanUvjRVTJ7sNoRhk49QMPB6WgTyBNjVPVF/jx0d
	 Gg3soAvaQ5dEQ==
Date: Wed, 18 Nov 2026 11:16:51 +0100
From: Christian Brauner <brauner@kernel.org>
To: Ding Feng <dingf3ng@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: ovl: sync_file_range() does nothing on overlayfs files
Message-ID: <20261118-entdecken-landnahme-fratze-8581bee07c39@brauner>
References: <20261118040056.6543-1-dingf3ng@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261118040056.6543-1-dingf3ng@gmail.com>

On Wed, Nov 18, 2026 at 12:00:56PM +0800, Ding Feng wrote:
> cachestat() has the same cause, and Pavel's series in June [3] fixes it
> by forwarding to the real file, as ovl_fadvise() does. Christian
> suggested a helper in fs/backing-file.c for that instead of a new file
> operation. Could sync_file_range() use the same helper? I can send a
> patch along those lines if that direction is acceptable.

This is really an overlayfs call, I think. A helper in fs/backing-file.c
that gets the file whose mapping actually has the pages might be fine.
For overlayfs copy-up changes the file so the helper has to go ask
overlayfs, I think. But really, Amir is better equipped to decide
whether this makes sense.
