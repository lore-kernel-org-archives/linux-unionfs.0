Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E1C32ED3A;
	Wed, 25 Mar 2026 05:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774418154; cv=none; b=s3FXV1Qo3yrMbAmhFVy18hteVfDYJrEP3krnlW8ohj1y5w97Heut45kj+o5v5Wohxo/uUb1U2p1PuNG1A2x4AMMABPTbSMztpR2nZRUWespsEOis0ySN22PB8eodrauyyvQeR8+o6Qe9k3iINcpGdcI+fhGK8etM9rP4dLaCedc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774418154; c=relaxed/simple;
	bh=fIGFiEWgMmNXVUi8aOgjpb+f3bP39l5cBzKSc4Xnb58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrsCVSJmqTaXdFvIH4dLsFAkybI/KmZuSYiqeGjBRfAm73VVuINJr8oQbNeTNXMJ0G70iYkfUQ84Vv+QcSTgLb04zjQ4P3OfGXo+cDUlbvEgFuxwtrq3pQxd06JYVPes5ZNAmHZ5L6q6Zhf+WKMBz4R701Ct33qI+jEv/qW0MLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BZJ0LKza; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BZJ0LKza"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dZrUJR1ahy0DKo77/KEfpYoCvA0R3SyEhfcrP+ZVHI8=; b=BZJ0LKzaKiWjcrbZS0dWLPEp2E
	S9Zh9k56HnHcsSlGX2qZkNejtWpFIGXHSw1zvOPs131Rj9a4lQxgvXLi9QyIF4G66boYeyaRSEOiM
	nMHj3uCHJRUF3dXxIYshwF267FGn5eCvuJ5bK59XY0orhBWf0LErbcE3cgdi+sGw5w2rQPioxSkWi
	KL8/JoeAuLIpRzrOyAc2/LIE4wSC8q6tTemJeVrD18qdd2NnMW6ly6WSCY8ywNeaX8IwuSVTnIIo7
	xK1512820QsHNwo5trrZMAWEgLBPkzn9zylFIJBGtwO5b0VHCvxUHuBQoQxe+yKh5jJpS21gooaMm
	s+HBx13A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5HDb-00000002kvC-1zMm;
	Wed, 25 Mar 2026 05:55:51 +0000
Date: Tue, 24 Mar 2026 22:55:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	Fei Lv <feilv@asrmicro.com>,
	Chenglong Tang <chenglongtang@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] ovl: make fsync after metadata copy-up opt-in mount
 option
Message-ID: <acN457svKhT5TcKI@infradead.org>
References: <20260324145750.90719-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324145750.90719-1-amir73il@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 24, 2026 at 03:57:50PM +0100, Amir Goldstein wrote:
> From: Fei Lv <feilv@asrmicro.com>
> 
> Commit 7d6899fb69d25 ("ovl: fsync after metadata copy-up") was done to
> fix durability of overlayfs copy up on an upper filesystem which does
> not enforce ordering on storing of metadata changes (e.g. ubifs).

I'm trying to understand this previous commit more than this one,
but what 'enforce ordering on storing of metadata changes' does
overlayfs encode right now?  There is no real ordering requirements
anywhere in the Linux file system API, so it does sounds like ovl
is making some assumptions by default?  Are those documented somewhere?

