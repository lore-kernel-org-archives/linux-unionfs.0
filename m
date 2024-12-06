Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D35207DF8
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Dec 2024 13:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733493546; cv=none; b=tXLNi2SpFU2OuGpjmDBAEpkby23UNN35/VUnU0LM0JCbV6QsiCqy9nIF1QzCSNWyXlTf/oxgzP464D0ERTHA/Bu+BdvY0ZDCfPCi0DGlmpbix2V4Ymv/tasaA7X7+/EZ4HicB4EfC3qHPn7VrTDFNZoyTJeAzU7i1IWHSeNJGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733493546; c=relaxed/simple;
	bh=fEV1qrPuxeaaWld+XvDq8t00lVJU5cUnvJ2hbLL/ekA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V0MoFxLZSaXC2htC9DAWw1GpOdSFWtzSv9Q2Sic+480xPLHoM5NR1lf6nl+pI2QKGHTYyRA36JxkpFblIprUNKtjVRruLJhK+jUfwbfGSLaQA3iFW807pPxcopfZDyMihL932uWF0gC5TWiGtZ96z2SDkYuUkzxTlc+v0e2l2+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KqIzMdti; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KqIzMdti"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fEV1qrPuxeaaWld+XvDq8t00lVJU5cUnvJ2hbLL/ekA=; b=KqIzMdtiIiT6Iqjcepn9tDOep8
	lCi8Uv+YhpFHmLPXkTI14yWv5/mCz5caypn/7ojjpnD60WNpgqYNaMqx72pUt/foTC5BTRFUUdY9t
	2mrUQprCj0dang8jD0w3L4AKdqIN3ALK7avZb3hEAwPlEEvatPVBWBK6e2rEVX5ZbgFKhyDJZPkXh
	Xai2dDy7V48K0EFaXcq71SiemR5r2M4YcnYCjjEhtgYnvXEzFQW7G59Pr/dOBYSo6mnIctfeVF83l
	DuasYo0tHHvN3tvonZtAdKWLaSPt9yudiNGVcGXiKniTto29fCVyT6JdnV5HwpGfpYeR5L638cOn9
	+YeE8sCA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJYrC-0000000EQOS-2zHo;
	Fri, 06 Dec 2024 13:58:58 +0000
Date: Fri, 6 Dec 2024 13:58:58 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com,
	linux-mm@kvack.org, linux-unionfs@vger.kernel.org,
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
	yi.zhang@huawei.com, tujinjiang@huawe.com
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <Z1MDIqKiyIdXTqji@casper.infradead.org>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205143038.3260233-1-tujinjiang@huawei.com>

On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
> During our tests in containers, there is a read-only file (i.e., shared

Show your test.
