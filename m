Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB20A37AA8A;
	Fri, 10 Jul 2026 05:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661656; cv=none; b=s553yDLNxPg/X3Vs2NCYFlBX6YpI4Ysu8v4DsmfAywm6qc97w9pp+ZyTZ2WkgSpK62wUiE0342mV8z0Ei7xqaRCW0DdYUsa/t6SH2r3vW4LwLuE6WbDR5+1RCBpQIwlehrSyoDKK/SuI5t1BZSbk6OFXl1OfsHebv3UGqjuVRaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661656; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IGPbnRqO2tu4xyq3EDqm+nYSIbGI53vUHmiBTVJifGvwyz7t4EK04ZaO78to07s9Ilqv2m/+jLBCIzkb1l9RPCGoKrN9fcrskRRTCTo8lFFj4QuSB4mkAm1KzxABfnO9Z9HtNJeul+HoS0sOa/94dsfS9GCZMnrJt1/7XizyL0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g5yX3fKr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g5yX3fKr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=g5yX3fKrQvbB+gbPPhZIIU5w6p
	O/U2iO3ysk/3jietX40wCD7y9Nqvi2TE/ngcSnFWYYMNAogOBDTMxhbzGb6NgMcN/RlvH2w6xilSn
	y2v8RPgXURGL8i23r3R/aB+lXo+kUzAA0EcQIvSv3RQTDfKrq2dxjPDEd70a/C02Bw0QINFmiOYCO
	nWGnkt/3AnS6ugtf1eoRuHQOfRvQdZ0KSD3m8cleQ04P4+KmnP42edjrm/TCVlRMu67XwL6Wn7h4P
	KHPHELfUbjvNIf3U4hxzyb89Pzu3UC6rrd/jQok1PcWyvkiMUfOyGI3VOLa51KsXnWcBKxqU20LU6
	TcRv4Gpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi3sN-00000004Cl1-0cxZ;
	Fri, 10 Jul 2026 05:34:15 +0000
Date: Thu, 9 Jul 2026 22:34:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Zorro Lang <zlang@kernel.org>, linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] src/vfs: probe O_TMPFILE support on the base mount
 in the idmapped tests
Message-ID: <alCEVz1XxROe-5qc@infradead.org>
References: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
 <20260615-overlay-idmapped-vfstest-v1-1-c6b3b2228092@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-overlay-idmapped-vfstest-v1-1-c6b3b2228092@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

