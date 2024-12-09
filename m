Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BC635943
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Dec 2024 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733751218; cv=none; b=hk3nnTS9886ntOVBcyRQfLV23seLAABe6fgDdMtWbU3k3rkEWZ8Xp7OlvBH4iuEXznMkUN2DgtL6uH0uHkdfeOdvljxXG2Q6gBiZdmizxtpPx8+aGyTpRxlj1QtrqC5jyexDdLYlO6n15FaVxL4K3VfX2jqhG+JSOTeaRMdM7nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733751218; c=relaxed/simple;
	bh=XroslrtTYVW+MNSAZw5kbiNKWIV7nmzBHh4slbsps3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OieLFahP1vAv1gSwIdTBaDrWckFftTC0eK6NTjSFAZiJYQ21Fvnz7zuBOwCxT0CuwrtRLmnQfwwElg48s7J/cV2H/RLURE1smxKUgF3Hxi0nzV69WU3Xqc7zJJs66SJLHnI4e7N1reibuyVNJ9FtS6gepEsQt1tmxgYmCMbJZj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KAFLDDT4; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KAFLDDT4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=JwRD+IiIqDzvQkDCWIfHd6pynPfXRcD4dvO863qu9CY=; b=KAFLDDT41w9/otyh71Nr3wkbBV
	1ZyJZr+l/NJ6ETcFfZDBXJbB0hAEjqbpp+jK6WS9Gr+pIS1/Bcv4ko6LkoDH1/gYceN/v5EMd217/
	bKA9jlyPycTtsauD3XDVRsJMQnZuDo5Snf6kw9sou0ApJpJn6wiW0hMZVxu0aIXexQCpQJi9xzWYn
	aGWWc20JjMvCocdSGgMS82ksXijmw6Zd5yAp48BDLGvB8z2yEuAu3kpxHBQ2WbYEx/7nwDNwqf8uh
	aK3inaF9agQgXbk8oEGSJo3SMSCqSetPpd4r9+ChzTyjGPvAKuLUxyEAdvQuJ3GH6IYJljsFzC6x0
	H0xoTtWQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKdtA-00000002KHw-2mym;
	Mon, 09 Dec 2024 13:33:28 +0000
Date: Mon, 9 Dec 2024 13:33:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com,
	linux-mm@kvack.org, linux-unionfs@vger.kernel.org,
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
	yi.zhang@huawei.com
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <Z1bxqKIHreKySaGx@casper.infradead.org>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <Z1MDIqKiyIdXTqji@casper.infradead.org>
 <4a8e2901-12b3-b700-383c-3193adc0ed60@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a8e2901-12b3-b700-383c-3193adc0ed60@huawei.com>

On Mon, Dec 09, 2024 at 02:43:08PM +0800, Jinjiang Tu wrote:
> 
> 在 2024/12/6 21:58, Matthew Wilcox 写道:
> > On Thu, Dec 05, 2024 at 10:30:38PM +0800, Jinjiang Tu wrote:
> > > During our tests in containers, there is a read-only file (i.e., shared
> > Show your test.
> 
> I mmap an overlayfs file with PROT_READ, and call madvise(MADV_COLLAPSE), the code
> is as follows:
> 
> 	fd = open(path, O_RDONLY);
> 	addr = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
> 	ret = madvise(addr, size, MADV_COLLAPSE);
> 
> The addr isn't THP-aligned and ret is -1, errno is EINVAL.

Then your test is buggy.

         * Check alignment for file vma and size for both file and anon vma by
         * filtering out the unsuitable orders.

You didn't align your mmap, so it's expected to fail.
