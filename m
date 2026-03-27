Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5992440DFCD;
	Fri, 27 Mar 2026 05:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774590342; cv=none; b=eBExMNtSleDwR1nfQDppoTADv5Bge75cQfqWKM3/GcAUaSft9A8WOco5PgCFS7qVfMoxJZGvQQQsymPZCyF6rCWSQS603bO2Qnxlbjmetx+L4oQImjXwRK4iXWNePqNRCw3bgC7civumMT6EXXlbwiFEDMxNGr0Wlugfff1ZIvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774590342; c=relaxed/simple;
	bh=f0cQxxZfEEzEmOTwIGbf7QxHnhQAOe/10G9wXnnIJAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmhXvIFki/2nK3FL7rbUekOHZMBV8mOAfrcwl1Ju7KhaHKIQz1Tj85pnz8HgsvKryJEgkt6UPnoTRqhl6TYB0eBL8I0ZvKdFndWBvyubhz6Q48QMXUgeBge0cVmySAGkBvXwu9epE+c66YnCTflPUGDjsR5WeuS6nyP8GMt2SGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XOJeQ4Rm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XOJeQ4Rm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oD2hbHuEvJ0Rs4gWYxap6QJQG6BMO9tLtx5+NGYsEkw=; b=XOJeQ4Rm+E7HOgiQhT80ZOb96t
	/lNkvpYOpLSY3hDq8DCsD1n3X+KPrqVBUIezzRA0zTPgkor5WEfcr3hwqUlbjwx0Gv2tFP3veDW9y
	pMENUngrUyBn0AJh5mrd+w9hMZVdK+9TNOxjJ1XS5Wi+2Y6MzvnAfHCqSvcTaVJr69F8Ehf33SbYN
	QYQK+irbxe1Y0bOuyy3Ki/k3M4WVrJE6gQ6G4ewoRTLkQWARtHn5PKFvlEW7ktE4U2YWxrBSJ0Tkz
	QHhAJPaH48GGRkLIyHlmNH988IM8vDm0cVaoqrDffv1yp4ljFeMwmXswZENbXGpH2lW5j3lcj6vxo
	rkb+uz4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w600o-00000006icq-1r4N;
	Fri, 27 Mar 2026 05:45:38 +0000
Date: Thu, 26 Mar 2026 22:45:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	Fei Lv <feilv@asrmicro.com>,
	Chenglong Tang <chenglongtang@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] ovl: make fsync after metadata copy-up opt-in mount
 option
Message-ID: <acYZglh4iyauvDZj@infradead.org>
References: <20260324145750.90719-1-amir73il@gmail.com>
 <acN457svKhT5TcKI@infradead.org>
 <CAOQ4uxh5NFvXGop6ne-zfRbH5p6BPT2kCt7dUkP__-TtpeJjJQ@mail.gmail.com>
 <CAOQ4uxge9QDMwnLr1+W0xF2GocnFWVrbhRdriaf5Qe+4KkrG4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxge9QDMwnLr1+W0xF2GocnFWVrbhRdriaf5Qe+4KkrG4Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 25, 2026 at 02:11:31PM +0100, Amir Goldstein wrote:
> When an overlayfs file is modified for the first time, copy up will
> create a copy of the lower file and its parent directories in the upper
> layer.  Since the Linux filesystem API does not enforce any particular
> ordering on storing changes without explicit fsync(2) calls, in case
> of a system crash, the upper file could end up with no data at all
> (i.e. zeros), which would be an unusual outcome.  To avoid this
> experience, overlayfs calls fsync(2) on the upper file before completing
> data copy up with rename(2) to make the copy up "atomic".

Sounds good so far.

> By default, overlayfs does not call fsync(2) on copied up directories,
> so after a crash, a copied up directory could be observed in the upper
> layer without some of its attributes.

This does sound a bit scary.  How does a directory copy up work?
mkdir + adding the copies up entries, probably with some chmod or
chown thrown in?

> - "ordered": (default)
>     Call fsync(2) on upper file before completion of data copy up.
>     No fsync(2) is called on directory or metadata-only copy up.

"ordered" sounds like an odd name here.  It's more like lazy or
"nodirfsync".  And it might help to explain what this implies, which
is that the fsync on the files in the directory also sync the
directories out, because they are usually modified in the same
transaction, and a traditional simple log model implies that.  That
traditional single log model also implies that you get the metadata
file fsync for free in that case.  I.e. if you did:

	for each file:
		sync_file_range(file, .., SYNC_FILE_RANGE_WRITE |
				    SYNC_FILE_RANGE_WAIT_AFTER);

	fsync(dir)
	for each file:
		fsync(file)

at least for xfs (and probably the others) you should get the
performance of your ordered mode with the durability guarantees
of the strict version.

