Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA87434CDD;
	Fri, 28 Aug 2026 12:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787920938; cv=none; b=Ea2sdkrevjTLTVEZZ0Kix9dsznpSsn5zByV9sURWs58IYqyuI1v4CxeGFmVge+mRGbZrIOxla05TTyh8qQvR18VNAU56j3Y2UP4CrcVr0EEpae6LWnzjDlnI0td6XHXxMRd4/fCndU2lIrvKgEImfcrOnl4vJSLlXR/zFhthO+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787920938; c=relaxed/simple;
	bh=QOZNKbCCTZqHpO0E0ofFeEPDPf76iR29U1dNaIaNI1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGVZSrIzCsEMSKSG2+fnx2scHMXwvW8z6n4vPFqP8HgSv2Kopc3E2bcHsrr+RxtZMfHxy2PJw+A3tdeyrPWe/Xlwjbs72lAklBORfmR1vbST3D0Bh07R3l0DBnrmAMLfyq3eSXfzZAHukd48JnCjNPNlzb37wikv55o02O+O3Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pi3v2UDn; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pi3v2UDn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fOOErk9kx1LUUsIH+ihqTAkp4s+n4NYBXTagYvHGXok=; b=Pi3v2UDn5tSqmbtKPiAIqYtln1
	e3ippwoYEwrMHwU8+8U7n6fMm7hPZvXt5XcS8l96v5TPNPp8qAnJEnyFzd4RsAf99V/EL+YVDmfrR
	lRoL5MfJqEWmyn2MRf5W18/93DaKy1xmUjxD15xTREg/ddJ78a/gUK/JDkDuCeCSLVqpe5iSBrf0f
	MsNSN3RlBRU7cYYNaq5RM47oT5s317cFo9TZak9nPBi5n4M47+Hj9Kn8w9y6uiyKvbCpqoM/ejXTN
	ZLFKqB0EpP7NvgCQ1zIxmMbltUfyIHS5uuzkrJCmAT0vjeV7f9FBGxIHZOls9oco2hSrnuvooSyTj
	hbZACARg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzvu2-0000000Ehny-3KzH;
	Fri, 28 Aug 2026 12:41:50 +0000
Date: Fri, 28 Aug 2026 13:41:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Yuan-Hao Hsu <aa9736195201@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>, Linux MM <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	"zhangyi (F)" <yi.zhang@huawei.com>, tujinjiang@huawe.com
Subject: Re: [PATCH] ovl: implement ->get_unmapped_area()
Message-ID: <apGCDtf-gE1osJqE@casper.infradead.org>
References: <20260827170718.497-1-aa9736195201@gmail.com>
 <CAOQ4uxjxDV0U9yrDA_StN968P_6cpjRAN2mBCx1c_RYd7BF4Og@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjxDV0U9yrDA_StN968P_6cpjRAN2mBCx1c_RYd7BF4Og@mail.gmail.com>

On Fri, Aug 28, 2026 at 02:23:11PM +0200, Amir Goldstein wrote:
> Since mmap is going through backing_file_mmap() probably a good idea to
> pass this method through a backing_file helper as well.
> 
> But more importantly, adding MM people to this patch review, mainly the ones
> that participated in the discussion over patch to fix similar issues
> in 2024 [1].
> Most of the concerns in that patch seem to have been addressed (?)
> 
> [1] https://lore.kernel.org/linux-unionfs/20241205143038.3260233-1-tujinjiang@huawei.com/

No, not at all.  All this patch needs to be is:

+++ b/fs/overlayfs/file.c
@@ -657,6 +657,7 @@ const struct file_operations ovl_file_operations = {
        .fallocate      = ovl_fallocate,
        .fadvise        = ovl_fadvise,
        .flush          = ovl_flush,
+       .get_unmapped_area = thp_get_unmapped_area,
        .splice_read    = ovl_splice_read,
        .splice_write   = ovl_splice_write,


All this "oh we have to call the underlying filesystem's
get_unmapepd_area" betrays a lack of understanding of the problem.

And Lorenzo suggested this in the linked thread:

https://lore.kernel.org/linux-unionfs/69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local/

