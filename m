Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9C22BEC55;
	Fri, 10 Jul 2026 05:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661628; cv=none; b=rgLpYuiVcJOCr02MlA0YKpF7QCrw3yMVQvhAeE1eO1XIRixYDekNL9gCs5wmYtcWdfpTio7kHX21XugAl3IEcDZkIGVjIqUEZEkPVYD/FcfJdDX+1ODkK8UmN5N5soM9QfTaTa/Ha+XAC+Pu+vSaMxlEUWTcDG2F6KQSOn5wCI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661628; c=relaxed/simple;
	bh=IkGfSitehTt5SFneEe85H4Jai5rxge7n2Hw+T/R0O6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ki0kCAErUl5HMU+wzeT/vW0hZwAvdTVWfR9O9XStZKFGyOxWjuhceptj2+P2ucGmi0QGPweykDQ5oTzYK3HtCpmbANoik6r4u53oBEgV3AN93p7lsyWwW48T2JttAvnYLkZy/Im25VOzaGP8xR2AKyb2usV7b17ZfzLTYv+XAg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uMhogCSW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uMhogCSW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=A2/LmHMHUA2QWY77RJoyl7YWWyYYQTdF1jqYFIjB3yY=; b=uMhogCSWd0BDIethlEHqxxWxgZ
	bWQYEkvpb/hxx1pFUPvYocxxhHtvyraFy5YAS5l/g5U2PHdYB77WZxvp614WZdZKbGXIk+sVqgPuc
	h/uzaK2COKu3S5sa63hkaqapCP7Ga+k/IQkDngOZLxdXcctLaI9DACSg+UlCzRlHRmNTRFi6sW91q
	ZVTfz+ly+/Dw6GLbHEIBDsUZ6JKiR7KUHa/WHpo6RRw0lDoZPBr9Vq2X739CosNI+0liOd8+ab0uo
	tbCd/cLzuS9oPcEOkTh8U2PJ0JhlALBpefRsfq0uMWH1kTKRlG6HO/SVaFnk23sZlrtNyDujcR2oA
	YTrHdgog==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi3ru-00000004CiE-0UlD;
	Fri, 10 Jul 2026 05:33:46 +0000
Date: Thu, 9 Jul 2026 22:33:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Zorro Lang <zlang@kernel.org>, linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 0/2] Support overlayfs in the idmapped mount tests
Message-ID: <alCEOvHNDOfRHySm@infradead.org>
References: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 15, 2026 at 05:33:28PM +0200, Christian Brauner wrote:
> This change is required to make the series in [1] which makes idmapped
> overlayfs mounts work compatible with the idmapped mount test suite.
> 
> The vfstest idmapped mount tests behind generic/633, generic/696 and
> generic/697 fail on overlayfs for two reasons that are specific to
> overlayfs and unrelated to idmapped mount semantics:

They also fail on just testing XFS for me now that the commit has
landed, so this description is a little confusing.  As is the patch
series title.

