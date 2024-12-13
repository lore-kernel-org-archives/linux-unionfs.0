Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C39149E00
	for <linux-unionfs@vger.kernel.org>; Fri, 13 Dec 2024 04:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063962; cv=none; b=e5zwFxG25PVrFXr/yAUQAZ3t/KxPdGHe+4Je2jEP63E4H7+nQhWNrbZNh0PPCJZOaH01Q3moKyvP/h81JN1LEBJw88TteIjotepP2V0Qv9VJWwbMs19ZKNKcoFat7kvhLYXE0JOBpQ30HPEOv3Pc64yZ5tVjJB4ER6pJrzUhgjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063962; c=relaxed/simple;
	bh=778Rrt2rn9KnCGZ9iUqgSWCL3viZnBXGWjFGYOaQ3YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebZRQg1V/Q3e/fhEJ2HSGL2HV/wG2C0dqR13foDj+b3vs/j1MTo7iXEXw3hfefSLcjKL3g5Xcg6U3C4fv5gP0aCINkQm3A2oHjWwhkHLrTacyTecZTYxfseeLDeKXeqTERbS7DZqbRf3vBow3TZocRd1yu96S+nejfYCzXWK+Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HOoNQD3U; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HOoNQD3U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=My0SHQUpu62rcyOrwOonKkzsemVCfWxmo1o+OnfXBuI=; b=HOoNQD3Ulnks5Iog+Us28NwrdK
	117jQcS2A0ryRhLofl3vuAnmRny644itiBM//jeYZ0UbVgKWFrjYnXM7xq7Dt6xx8f55+5wT3WAJB
	Uhym5UAQlQZ1ZWWvWl0evuYuC0wYSOnWtW+sbnTZLQx82mhpES+Y/Be9SIBUQ5XVLmRASbt8T5Hx4
	N4P8u6d06oOOoYjQFMJL8Jx1lPY+87hXvo17FLYErF4kBOtZO5iYT+vXT8kJeiC8o2moUodlcY3Fe
	eyJ52TQ1xzO/8E2YisZ2/+ksAoop6Ob9UnfY8C9wWPwYHrj7mUYb92yLmoFn/S7x19wW8GZr8CLrZ
	e3/6Vcww==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLxFL-0000000AFEj-32OF;
	Fri, 13 Dec 2024 04:25:48 +0000
Date: Fri, 13 Dec 2024 04:25:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jinjiang Tu <tujinjiang@huawei.com>, miklos@szeredi.hu,
	akpm@linux-foundation.org, vbabka@suse.cz, jannh@google.com,
	linux-mm@kvack.org, linux-unionfs@vger.kernel.org,
	sunnanyong@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <Z1u3S90PJL46-79U@casper.infradead.org>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
 <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local>
 <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
 <CAOQ4uxh5azF6As6TvV2eCKpnbct0-vNwJLTAwSiKc6QjK5TUBw@mail.gmail.com>
 <568698a0-c2f2-45d8-9d8b-e22e942fa422@huawei.com>
 <CAOQ4uxjBB7EUOnHB2n9BUGJ_TrHqvqJLksVyxcnpOUCR+7Tfyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjBB7EUOnHB2n9BUGJ_TrHqvqJLksVyxcnpOUCR+7Tfyg@mail.gmail.com>

On Wed, Dec 11, 2024 at 10:43:46AM +0100, Amir Goldstein wrote:
> I think this patch is fine as is.

This patch is complete crap.  The test-case is broken.  NAK to all of
this.
