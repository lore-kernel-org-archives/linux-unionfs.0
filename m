Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6314E37C912;
	Fri, 10 Jul 2026 05:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661682; cv=none; b=uYVENOGxoVxoNWYKuYkcSakDIdeJEOndCzwbDl6HgSiE8Prk8pMxG/v8LYFPTy8jdHfyjfavhgIPSyUZn5jarrwhn7y0II5Giw1FCKmqIr7Nrx9SgKeZjXMecNBZGZcgpJM30BwXInIKeuql6jTk9+ghaNl31mlg3tdgaLKRVhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661682; c=relaxed/simple;
	bh=vCKqSO7FcPjO/fbcdFdGcfwyoGSC7wnRYM3eRRKXJbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ri9wm8Br58Bsb4Qm0NB6O3WwXxxjXV6Kb7u79pdhsAX9C0fxPIPHsK8UfKLeE6md041UN7co4mKaQstPf3ba8LYWYzIKQRtrKD2fS9dbRnOZc8S+VZ6dUc+wsHM0DISHsAteSpLqCs4tjTgsRIrO7We+y4DgRtYoTurNRjgC4L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nE6MzMsB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nE6MzMsB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=2qfaKsY0c7jqCLpRus99rlIbzzgsY1Pbki0/Md4m9/Q=; b=nE6MzMsB3q2jNhkuVWarAeuKC8
	RvRHuGY/0VKT0iXC13wSN78/YnBtLqEUIEEz1fCaq84+v7xn9bofN4dc6rrgAiyf1oRPvH1DJ3duF
	HF1iKztHy9ETtw6q8TWTPYfOQobXKKG7EGQtFrLlERqZc4XJvQLA6RkMLf2Nl0yW2Vghsu2a5Qn9F
	6iC9AnlnJdUFX6lXRxpm/5ez8XppMb4q0+KLQoZYwAAmbQdNxo2quP3l6JhT64RGsG87wPxzKZiFo
	gA27xUMUPnGoGhoapY3+ZK8ztFewInmM8xZ9zBFRiIagJXBhTH8PUAMX15iVq8aGUsm5lNgO5z5tv
	p+fW7Hfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi3sn-00000004Cmh-08aN;
	Fri, 10 Jul 2026 05:34:41 +0000
Date: Thu, 9 Jul 2026 22:34:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>, Zorro Lang <zlang@kernel.org>,
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] src/vfs: skip whiteout-device fixtures on overlayfs
Message-ID: <alCEcbQfLY4f6Fo3@infradead.org>
References: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
 <20260615-overlay-idmapped-vfstest-v1-2-c6b3b2228092@kernel.org>
 <CAOQ4uxjtTd0H=DjyyxaOm56be0JOy2y4ZYV8AbVRnsdGnv4hxA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjtTd0H=DjyyxaOm56be0JOy2y4ZYV8AbVRnsdGnv4hxA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 15, 2026 at 08:03:02PM +0200, Amir Goldstein wrote:
> On Mon, Jun 15, 2026 at 5:33 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > The idmapped mount tests create a whiteout device,
> > mknod(S_IFCHR, makedev(0, 0)), as a fixture: a whiteout device is the
> > only character device an unprivileged caller may create, since it is
> > exempt from the CAP_MKNOD check. overlayfs reserves a 0:0 character
> > device as its on-disk whiteout marker, so ovl_mknod() returns -EPERM
> > and the fixture cannot be created, failing generic/633, generic/696 and
> > generic/697 on overlayfs.
> >
> > Add an is_overlayfs() helper and skip the whiteout-device fixtures and
> > the checks that depend on them on overlayfs. The makedev(5, 1)
> > "creation must fail" probes are unaffected and keep running. No-op on
> > every other filesystem.
> 
> I have no strong objection to this patch but there was actually a request to
> support makedev(0, 0) in overlayfs for creating overlayfs on an overlayfs root,
> so perhaps it would be better to probe for makedev(0, 0) by fs owner instead
> of the is_overlayfs() check.

Where do we stand on this?

