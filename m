Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EBC207DF3
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Dec 2024 13:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733493153; cv=none; b=g8H/DMLMsmX4eX9FXisH+Y5T1Z+X/ldRBf3P6GVgqI0WLESJHr2o9uNzA1Xnq73703Xjh8WxIjIhW/vFcZ20hsNVINqkWn7rBLJEF2q8t5wvxYWlCCbh5wcTkNzG/eHBEPOvgU/rcVSDU/1fEg2AgAvTDiRek4uqtAbSDeht440=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733493153; c=relaxed/simple;
	bh=wOGdT+URUqNjiuYuv2UJmI25FYvoyXzeNOVfq5qwzzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gt9l4rouS/FINI/8PrV9D2R3BIBWHoU+MEmJLNnbTJdA/S1smfO3qipxicoL7bIBKXv4xEy3FnGkdHilBqXL/ULM4km9dCiQAdrEr7hqtWDizHcqx4hAmZR57UhBVC0OGM0c/L/Eg3RHPhMaviMqqBrryAtaUdm73Ghq+e0OhW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vzSF+fvr; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vzSF+fvr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=KiZqfGl/9/7V8SNBQYShVy9qHnnocvwfpHp6ym/9a8E=; b=vzSF+fvrjrk0i0AcXEIEE3zlzJ
	6equkAirOOO7tzT5ILefDDzVqoIWr2l05QlYtTaVuHZkyOs29lKOHh+z4nTFye4TfubDVCYuRINwl
	WK8vWP0yABbAWSQVLB8WcFjaKzfr0ClVgXfu/LWLuTFbgTJ2puzvIhKxQf6vy8IHG6nZoikFRE5fE
	uvxpODQVP3xRKACoF5TR7lQ382LunevXVuIEbgzeEGVud5Sdb3frftrOsl4P+/Yre+6Fz9sMxDABd
	UerJd5K8G1dsLvpUkQadp6Tk+UPsJvfuZvCmE5hkV9ir2asnTP0cHku8L2ADuhquoGjk8YZz++p+j
	h7VuCz4Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJYkj-0000000EQ3S-0yQa;
	Fri, 06 Dec 2024 13:52:17 +0000
Date: Fri, 6 Dec 2024 13:52:16 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>, miklos@szeredi.hu,
	akpm@linux-foundation.org, vbabka@suse.cz, jannh@google.com,
	linux-mm@kvack.org, linux-unionfs@vger.kernel.org,
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
	yi.zhang@huawei.com, Liam Howlett <liam.howlett@oracle.com>
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <Z1MBkH_PeZto3qkC@casper.infradead.org>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <CAOQ4uxjLZJXDm+7aiFsEtiUhvux5U=dftw7eNBpk55J6wW9XBw@mail.gmail.com>
 <f773da0d-38df-43ad-86a9-6cba785d53a8@lucifer.local>
 <518c881b-8ba0-df0e-16bf-00694c59f5a7@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <518c881b-8ba0-df0e-16bf-00694c59f5a7@huawei.com>

On Fri, Dec 06, 2024 at 11:35:20AM +0800, Jinjiang Tu wrote:
> When usespace calls mmap syscall, the call trace is as follows:
> 
> do_mmap
>   __get_unmapped_area
>   mmap_region
>     mmap_file
>       ovl_mmap
> 
> __get_unmapped_area() gets the address to mmap at, the file here is an overlayfs file.
> Since ovl_file_operations doesn't defines get_unmapped_area callback, __get_unmapped_area()
> fallbacks to mm_get_unmapped_area_vmflags(), and it doesn't return an address aligned to
> large folio size.

It doesn't need to.  large folios can be mapped at any alignment.
The get_unmapped_area overrides are just for efficiency (ie be
able to use PMD mappings when we happen to get a PMD-sized folio).
