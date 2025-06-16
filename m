Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D82292B36
	for <linux-unionfs@vger.kernel.org>; Mon, 16 Jun 2025 12:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750078464; cv=none; b=KNCR6bgJmAXXcvkR0PE7D3EVlZoQ8ONbNAfLbmxK7gUo/M++r9LtVsqb8Gmys6HEgHbhoce9yuQsXAxfOoIhUpGebxpZWItu1iZx5trd52N1r/AgsZIWkAV0JqzRIDuB7EgfXEJXoUcJFjFJbsjzP6JzCaqctz0qtaf4cfGF5lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750078464; c=relaxed/simple;
	bh=O/6TMhXDWSUHo7SzSMvMkHv6d4f2sm76FR4pqVzoQ1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSZDY3/qfsHtWxsfk7hw8OuehvtXPx4MEusU+EMiecul/MphZr1kOwvOIVA7Uyvd2a6R41sDOCpd4QcYMII+uQJ8xMWL16cW3G45wAWSH5FWv5vi36OcgEfhpwOEz7OWV/0V5ZOsuIx0+QoZvHphOdiM1uL98y3IswhQMpdnN3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=us/r3dqH; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="us/r3dqH"
Date: Mon, 16 Jun 2025 08:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750078447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5UpNXr/G50E6+4pJZXdxLLMqXJDg861ljCgb7I6uV00=;
	b=us/r3dqHxXFgKWoCxfcel8OSy4WPRseTFauP1XyS8UmRxqhJI2pTmdvs+i/H7OUrOLYG5W
	mf2+p82e1yrg3Tw7Enp/lq0p8KtXDXTjRvWtf0UuKlrDh2CgSHzfQ1dxxi5fbmVqXGKIJF
	pwS5IvYpE7zo3BSZ7Wv21xm3m6I+1VU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v3] ovl: support layers on case-folding capable
 filesystems
Message-ID: <4lxkp7nfw3dvql7ouqnsfj7hbvzpp32wezamt5b4b56keatc2g@butdqkurvmif>
References: <20250602171702.1941891-1-amir73il@gmail.com>
 <oxmvu3v6a3r4ca26b4dhsx45vuulltbke742zna3rrinxc7qxb@kinu65dlrv3f>
 <CAOQ4uxicRiha+EV+Fv9iAbWqBJzqarZhCa3OjuTr93NpT+wW-Q@mail.gmail.com>
 <bc6tvlur6wdeseynuk3wqjlcuv6fwirr4xezofmjlcptk24fhp@w4lzoxf4embt>
 <CAOQ4uxiYU_a_rmS9DBOaMizSFVsbiDQBRcf4-f=8hmL-TGbwxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxiYU_a_rmS9DBOaMizSFVsbiDQBRcf4-f=8hmL-TGbwxQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 16, 2025 at 02:36:35PM +0200, Amir Goldstein wrote:
> On Mon, Jun 16, 2025 at 2:28 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Mon, Jun 16, 2025 at 10:06:32AM +0200, Amir Goldstein wrote:
> > > On Sun, Jun 15, 2025 at 9:20 PM Kent Overstreet
> > > <kent.overstreet@linux.dev> wrote:
> > > > Where are we at with getting this in? I've got users who keep asking, so
> > > > hoping we can get it backported to 6.15
> > >
> > > I'm planning to queue this for 6.17, but hoping to get an ACK from Miklos first.
> >
> > This is a regression for bcachefs users, why isn't it being considered for
> > 6.16?
> 
> This is an ovl behavior change on fs like ext4 regardless of bcachefs.
> This change of behavior, which is desired for your users, could expose other
> users to other regressions.

Regressions, like?

The behavioral change is only for casess that were an error before, so
we should only be concerned about regressions if we think there might be
a bug in your patch, and I think it's simple enough that we don't need
to be concerned about that.
