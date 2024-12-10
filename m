Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD9D86329
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Dec 2024 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733853536; cv=none; b=i72yljF3Uh+JKwqQHjs+R+TaMd4T0glWJAe/+juxLmbZBGSATBjvXtH+kB5BaK+oT2imYRWnpNZEwF0//JIzP0yPiMx7YPdLnJxljKAOs1Dr2HpspIlvsV17ImSHVlbTVYUXPkVDOZf6EGztx1NiDNsBTxU4x1iaKU9llCG3JNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733853536; c=relaxed/simple;
	bh=/paLqaV6IMiEWxVQSNydtllhFrsHpbcWOJhVhMoJY4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAZQjyVmaTpbITwfCoMoeMWFfixDVvpIy7YbTbLd/BTx0buvITa+FDCzEyWUq1NvNr5qleH8+r7CMY9+W/BJpSYdV4xL74H5NdJ0Lo+BnsZPJnCAYhkG+D/rv7IVdVBe+kAyLyoNi037DXZPAuoXWlEMm+bF+jApv9pJa6Tay/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=prBJgX7+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="prBJgX7+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=pTwLqEcqBCVPH/liXfDHU04jc/aBi0Mf9YCkUjkX3oo=; b=prBJgX7+Exm0iqJMJybMmpTNSu
	E2GyfI5GwTvlj0paE+GBC4L1YgaWgBgD1LuIYa1yVVgmQj48HPcuAAH+ZsExbSNd0/lDor47eCLwj
	yx5P1iqkfFV9ptKGhN6d7e6S69mk1QsKAkTw5WGoQeblgGQrvA9h9RLkA8IdDMtc5IqlR+xOZA0Gp
	u6ws7KG2hTdq0+KhpvjHf3Nsk4g2itn1gYjqD1NyMwq7gnISI0LR6aGgNLxCkmPJ6qkfML7AQpNQT
	tUNB7PSl4uR8JwDpXBmJKx4fUHVv4ze9O1hfoGb0alvfCr65WnFi5l7UKl3jvh27VC0jZQSiahq0F
	XoF9g2LA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tL4VU-0000000AkAR-00ZY;
	Tue, 10 Dec 2024 17:58:48 +0000
Date: Tue, 10 Dec 2024 17:58:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com,
	linux-mm@kvack.org, linux-unionfs@vger.kernel.org,
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
	yi.zhang@huawei.com
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <Z1iBV9lLKKYwgL7q@casper.infradead.org>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <Z1MDIqKiyIdXTqji@casper.infradead.org>
 <4a8e2901-12b3-b700-383c-3193adc0ed60@huawei.com>
 <Z1bxqKIHreKySaGx@casper.infradead.org>
 <30caaca6-df23-c1cc-1980-88b83600807f@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30caaca6-df23-c1cc-1980-88b83600807f@huawei.com>

On Tue, Dec 10, 2024 at 03:13:21PM +0800, Jinjiang Tu wrote:
> 在 2024/12/9 21:33, Matthew Wilcox 写道:
> > On Mon, Dec 09, 2024 at 02:43:08PM +0800, Jinjiang Tu wrote:
> > > 在 2024/12/6 21:58, Matthew Wilcox 写道:
> > > > On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
> > > > > During our tests in containers, there is a read-only file (i.e., shared
> > > > Show your test.
> > > I mmap an overlayfs file with PROT_READ, and call madvise(MADV_COLLAPSE), the code
> > > is as follows:
> > > 
> > > 	fd = open(path, O_RDONLY);
> > > 	addr = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
> > > 	ret = madvise(addr, size, MADV_COLLAPSE);
> > > 
> > > The addr isn't THP-aligned and ret is -1, errno is EINVAL.
> > Then your test is buggy.
> > 
> >           * Check alignment for file vma and size for both file and anon vma by
> >           * filtering out the unsuitable orders.
> > 
> > You didn't align your mmap, so it's expected to fail.
> 
> When mmap an ext4 file, since ext4_file_operations defines ".get_unmapped_area = thp_get_unmapped_area", it calls thp_get_unmapped_area() in __get_unmapped_area to
> mmap at a THP-aligned address.
> 
> For overlayfs file, it's underlying filesystem may be ext4, which supports large folio. For this situation, should we mmap at a THP-aligned address too, to map
> THP?

Actually, ext4 doesn't support large folios.  thp_get_unmapped_area()
was added for DAX in 2016 (dbe6ec815641).
