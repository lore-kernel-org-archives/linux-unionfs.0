Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B45838DD8
	for <linux-unionfs@vger.kernel.org>; Fri, 13 Dec 2024 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098441; cv=none; b=BxnbTOpyIA35EBkdpKzLAWZjZpxFeD58g9cerZ8dtv9YfKWkfmeI5zChMyV4cX3tTZrum/JovnRuiME3xuKZIg0jCIUe9bWKs21Hfdo+M34GvionwemJDWUuUCsoy/zwCzM91gdYRpYdtTVWCivbMbeFEJwBm+0ev7fniYyXSPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098441; c=relaxed/simple;
	bh=j951+gvizBV1ZhwWfMixs+T8T1u/RSw22gm/5EZKFQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AOmGz9zc61zRnMzFFp0+mfiH9+Fa65Wpq1jTOhXPdUIBLM2HNI5w7NZPwMJgHVH5rCMiF71cVcn1aPkG/u6rC0QGGsfIozZSFU5mg/kUTUNV8rrTA0cdRHVekDiaFXqbbkUPyQyXVNrm4YHgvmr9+7Ql+1YuNWvYft92SWgo+VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N/unFoiP; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N/unFoiP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b/zRpTKnrIJp0faKm/LlsijhU32ffBRRjkg4+JwIMG0=; b=N/unFoiPoMcBVEWrdz/bseksnU
	HWyNFmcLTMrnu6Zyr+SGyur+eniNVij+jh/zDoP++OgLVnsJ3WqL2tQU+v9pBDb95AJANvRSm3Bpo
	j/RpiivvX8i9N45u1b/4rLrAzI5qaE+nOzvYsfTmvjSvFG+51Y4uRAzMWxqTuISPD5fNX9wxy4cHn
	Yx/8IbBRjX8ym9ZLPpVUH2dLKMf2yuMb7cJpjEoBgnEeiSm56VQfwQeobrYvzIhD4Fq+t3WGwozBw
	rDsH/dn31ywKWga99p0GWS6pIUjvJVk52C4O6uYZa+UFWmI15IVusWol4lGeoKtu0E57WNAarclIp
	3kmRnbEg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM6DX-0000000DNGx-1Myu;
	Fri, 13 Dec 2024 14:00:31 +0000
Date: Fri, 13 Dec 2024 14:00:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Amir Goldstein <amir73il@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jinjiang Tu <tujinjiang@huawei.com>, miklos@szeredi.hu,
	akpm@linux-foundation.org, vbabka@suse.cz, jannh@google.com,
	linux-mm@kvack.org, linux-unionfs@vger.kernel.org,
	sunnanyong@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH -next] ovl: respect underlying filesystem's
 get_unmapped_area()
Message-ID: <Z1w9_xGpHr04QtEw@casper.infradead.org>
References: <20241205143038.3260233-1-tujinjiang@huawei.com>
 <69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local>
 <041dcc1a-0630-27b9-661b-8c64a3775426@huawei.com>
 <a39ef271-dc1b-4f61-ba01-dde5b127bef2@lucifer.local>
 <f2668332-78ac-4dc1-abcc-440e38964ccc@huawei.com>
 <CAOQ4uxh5azF6As6TvV2eCKpnbct0-vNwJLTAwSiKc6QjK5TUBw@mail.gmail.com>
 <568698a0-c2f2-45d8-9d8b-e22e942fa422@huawei.com>
 <CAOQ4uxjBB7EUOnHB2n9BUGJ_TrHqvqJLksVyxcnpOUCR+7Tfyg@mail.gmail.com>
 <Z1u3S90PJL46-79U@casper.infradead.org>
 <3207edaf-826b-4545-9c9d-906bfb4d312e@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3207edaf-826b-4545-9c9d-906bfb4d312e@huawei.com>

On Fri, Dec 13, 2024 at 03:49:53PM +0800, Kefeng Wang wrote:
> 
> 
> On 2024/12/13 12:25, Matthew Wilcox wrote:
> > On Wed, Dec 11, 2024 at 10:43:46AM +0100, Amir Goldstein wrote:
> > > I think this patch is fine as is.
> > 
> > This patch is complete crap.  The test-case is broken.  NAK to all of
> > this.
> > 
> Hi Matthew, regardless of the test case, the original issue is the
> ovl don't respect underlying fs' get_unmapped_area(), the lower fs may
> have own rules for vma alignment(own get_unmapped_area callback),
> thp_get_unmapped_area() is one case, what's your option/suggestion about

No, filesystems don't "have their own rules" for get_unmapped_area.
get_unmapped_area is for device drivers.

