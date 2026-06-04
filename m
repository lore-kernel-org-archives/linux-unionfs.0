Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4CC3F4DD1
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Jun 2026 09:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780563879; cv=none; b=odnnVNWH9RoF7D3Zn002Ktb9zhHbRdqRCXMmqyimJT/kMY8m65u7LMahSC9YkZi7Q7K9Zw6Vn9/WNIdCs4vHm1luThkABdIlbyQ3VjQGFfHCIsW27YSUmQqdb4lwuAp29vUnFA4Ur9TXDgaRKtOVgft1KMHalwKg6bJKqjkYrg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780563879; c=relaxed/simple;
	bh=PDUUSU7kmVZUxeHMY1MJ5BVFtGwJ68ein9IpwK/HpUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dTMBQ7XzNA0Urf5wYGGW/rc+5I6ZRZLHKH3FFn2t3yISz9ny7DnFv2l8hoYETPuz7RTHTiW4c54RD+iRckV/rXv/MD17pw8e87hlrwDCYBSQWbLzPnZU68wtCNj6YTZdn494RfPQv+0CzlnBDc8VvtLA6vZYG5p2ZVF/9tlCg0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OX0cU1VZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qz9GLDgt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OX0cU1VZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qz9GLDgt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780563876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lQs9dI0tAeFPaJ8i1YwQIsal8XYYdyr4lp1F85T2xk=;
	b=OX0cU1VZzlzQXUJiY0B5ejGyseFhdkB4n7aBW/tHtF3vXB6jvkQJ58nYLfVWzAJrHwxSGv
	jl5i5uSfsa7NYGN30V658NXVInBl/ALnwYReJ81SZZigU7zNkTW5sqVsskKpYoT5GQfrkO
	HSm0xNw3D8LRQjrm+UVrrRfE93bd1Vc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-ibSmn8xiNpCJSerw9ouygA-1; Thu, 04 Jun 2026 05:04:35 -0400
X-MC-Unique: ibSmn8xiNpCJSerw9ouygA-1
X-Mimecast-MFC-AGG-ID: ibSmn8xiNpCJSerw9ouygA_1780563874
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45eec2badc4so237587f8f.2
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jun 2026 02:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1780563874; x=1781168674; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2lQs9dI0tAeFPaJ8i1YwQIsal8XYYdyr4lp1F85T2xk=;
        b=Qz9GLDgtLtISnCfgP/4urs6jsoO4Q4b9/whS91RL5tIMBYkAqf30YvWT9E3QDi7l/Q
         QyOi0ycgRCwywfL8W0BkAKo/dRS1HhC1SUbF8j7uUT7ipAZ+YMKJQtM/k9XumtfIVxbn
         bxGcCjGX2kN205Qmc/HEe7kkdoKweYVdypewv2jJmfeDpLw2vUTFWuAssI9DANnBTZoB
         9jCC4k2pMXQQH+10xJJAGqE27mj931J4fLsC+ZQ91eA+IXFkn6/C8SqemPhFjMHTt2aI
         OaQF5GfZSAqUCgpASg0uiyqRbM19a60sRZ+xKIK266mpRsZcsjBbbpk3liP9wbTyy7hg
         v45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780563874; x=1781168674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lQs9dI0tAeFPaJ8i1YwQIsal8XYYdyr4lp1F85T2xk=;
        b=qRjzyaji9KpQYGJUtJzj6IS+Jn8XJTYFqB3WvQy0G15cfOfJrugXx6r2ReTkOiDFDF
         qrqVGAdznZ0bqi7B08iAObIx6jDIsHQcLxWwbap2q7W2PXbkChMhnMA9+Wh+Eyvn6g31
         vZzijgbNSKihEQfZgWrAKX8DqEXxKQJqt/yjhTjXyNY7/XAg3Qh/A1kg4oAqiWh1ltUr
         Gbr2r7PB2ln95iR3TRYsf1VCriJZH+UCyaic3j0bM/7UeSLkmr4n01bufYdnAkAZLjw2
         lWGQRYn6wp13WQLCUsmwIobYzcKtMnifMhT1qOzcKmXvjNBQ5IRYz//LtVYGzCNtnFsm
         oadg==
X-Forwarded-Encrypted: i=1; AFNElJ+otnzQGIEary4mxpmxlxhVWzz6TLzLK3OitFKv33+5A4YjJjB8U8VizPy6wkGMN2fwd1UXjdnWhPShdtbg@vger.kernel.org
X-Gm-Message-State: AOJu0YxCLBbIFI1RxEWvLdfdTih6dCGZmE7YNHvCGWXhiC8aqF0y6Bqf
	gienxd3H8nymbSfYvAkJ0XFQn48HjQnAPCbJjHxjCp26L5ALuDlcJC3rEA0WBfqay42B/72Glxq
	SQkeHrGpEVtcIMkels6MB/Z3u3eJFShgL51v9OEBH6JgjxBqCT1IR5UtxAMMj5Ezsqw==
X-Gm-Gg: Acq92OEVtinYac5JcUIVb1LtI3N8CuviGEjfHFy64+mM5Hz2zzbY9TBDfbRfm7m9hm4
	tCm7/Lx/0EOoZG+AT6DgZiAPTIA35nN3dJRosVJKmjBAmwuVGJHtr/jSAvuFHIa1jq32OQPuFzY
	0utxEj90K7TIo8R521XXiaVLsBmgYdGlrT/sMLBJZhzXS50GT1w1SYbQEXvajHcVjJC/cDj71Kx
	XAdDcqMQfcbK6DXptFg6PbaNVZQeuB6kr6Lrx52nh/muOLI6wBAUA4AnVW2L0picZMshQf+Jh9q
	mR9sp3pllaRTeVIlHKOtDiqsUel1N6l8YAqdnOk0n0UxoUJkb7TAQhEtK6R0nBqx0Q7//OIh+Y0
	E7vHJPgQ6gc0+V4My0sctVlUvKGEeO8lGy1bZE+ddiKBcdJjozOJCWMNW89yuFxGIxao=
X-Received: by 2002:a05:6000:43d4:20b0:460:f36:79b0 with SMTP id ffacd0b85a97d-4602182b90dmr8717130f8f.19.1780563873998;
        Thu, 04 Jun 2026 02:04:33 -0700 (PDT)
X-Received: by 2002:a05:6000:43d4:20b0:460:f36:79b0 with SMTP id ffacd0b85a97d-4602182b90dmr8717074f8f.19.1780563873372;
        Thu, 04 Jun 2026 02:04:33 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcde3sm16539954f8f.1.2026.06.04.02.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 02:04:32 -0700 (PDT)
Date: Thu, 4 Jun 2026 11:04:32 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <aiE_YQc6SGSdWlcE@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
 <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
 <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
 <20260522-unbehagen-baumethode-erlesen-811a4065eeac@brauner>
 <20260522120757.GA21041@lst.de>
 <ahVzkf8JoKP-kSC2@nidhogg.toxiclabs.cc>
 <20260528-offiziell-luftleer-misswirtschaft-3503bda2ad70@brauner>
 <fjdfwhwi4aogyiaoijwvw6w4npuu5mbt6ua6fkhwcp5ajlm543@ume2fkxg36cb>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fjdfwhwi4aogyiaoijwvw6w4npuu5mbt6ua6fkhwcp5ajlm543@ume2fkxg36cb>

On 2026-05-28 16:50:45, Andrey Albershteyn wrote:
> On 2026-05-28 14:20:08, Christian Brauner wrote:
> > On Tue, May 26, 2026 at 12:19:43PM +0200, Carlos Maiolino wrote:
> > > On Fri, May 22, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> > > > On Fri, May 22, 2026 at 12:03:20PM +0200, Christian Brauner wrote:
> > > > > > I was expecting this to come through xfs tree too if Eric and Christian
> > > > > > agree.
> > > > > 
> > > > > You may take it through the xfs tree if there are no conflicts with
> > > > > vfs-7.2.iomap. If there are I want to add the iomap changes into
> > > > > vfs-7.2.iomap that you can pull in.
> > > > 
> > > > Merging the iomap bits through the iomap branch might make sense, given
> > > > that iomap usually tends to see quite a bit of activity.
> > > > 
> > > 
> > > That sounds good to me. If you want to go ahead and pull in the iomap
> > > bits, do so, and give me a heads up when you do it so I'll pull your
> > > branch locally.
> > 
> > Great, can the series please be resent based on current vfs-7.2.iomap
> > then please? Because the iomap changes in this series don't apply
> > cleanly on vfs-7.2.iomap so we already have merge conflicts...
> > 
> 
> hmm do you mean this branch?
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-7.2.iomap
> 
> patches 07..09 seems to apply cleanly. The only conflict I see is in
> the overlayfs patch 03. This is because [1] (is in -rc5) is missing
> in vfs-7.2.iomap.
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/overlayfs/util.c?h=v7.1-rc5&id=0c8c88b8eb82a2a41bec5f17c076d6312dc40316

Christian, ping

Would be nice to have iomap in vfs, so Carlos can pull and test the
rest

-- 
- Andrey

