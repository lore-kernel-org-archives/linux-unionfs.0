Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049312868BA
	for <linux-unionfs@vger.kernel.org>; Wed, 28 May 2025 13:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748438012; cv=none; b=Nt9n5H2AI3TxdrCQI1MCaX3lEF485HfksPH9YTI7HNg4XEJQ0WZ+Ry1afNVlJ2mQpT7v/OzW1p4N3fHAxxMPk58w3HnmkayqHvSEYvrNuMqHOWZI9E0CTkbEIRRTMFn3i/pMz80LET9CU7b9mufQbdtYu1vWhHw+1z1Tok7st1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748438012; c=relaxed/simple;
	bh=OHDm+BZLVGDxerXVngTYwRrLJRHqZOWH97NiVEZD5CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m956WE6rIpDgSKlzIt6iGijTn1i7/XIeEEZORzcFmNNqfzgursn2Cs9Vu9GC0U9Zv4m18x9inVHqjf0tGJFALUoLJl228FCm0o/12pNeAFwiJmJQwRDTE1MALe1ubNfjtG9w3MWpoLWNgvJUwWMTolC/q22d9K+InkbXatEfVXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I5sUtacm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5sUtacm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748438009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g9O/bnxtzeHjXuwYHhDVDwwVycr/Ty9A6s076ZqDm5A=;
	b=I5sUtacmUbC8vw0CfzSFHJilhWRjsOuLR5RKfQK/ecinyIrmCrM9kDkqFmN0MQmBQGP6qK
	w7maz6UqfLV3U7UN4gtfgTYYXe2ShBH8Qe9faF+/NwXd+lMqi2Ovc8XwsC6DLFLPxKfKr6
	5kISPonYX5h0BzV9Frh8sHIrRA7I0EE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-RnfcvIsCOY-z1mjNmEGIzw-1; Wed,
 28 May 2025 09:13:26 -0400
X-MC-Unique: RnfcvIsCOY-z1mjNmEGIzw-1
X-Mimecast-MFC-AGG-ID: RnfcvIsCOY-z1mjNmEGIzw_1748438005
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0586B19560B1;
	Wed, 28 May 2025 13:13:24 +0000 (UTC)
Received: from ws.net.home (unknown [10.45.225.54])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF85930001B1;
	Wed, 28 May 2025 13:13:21 +0000 (UTC)
Date: Wed, 28 May 2025 15:13:18 +0200
From: Karel Zak <kzak@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Zorro Lang <zlang@redhat.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, 
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH 1/4] overlay: workaround libmount failure to remount,ro
Message-ID: <u6gsk65mznw3gisnr4btpxvooa7czbhiei4exbsgc5swdbgtf7@c5hx27plyu6e>
References: <20250526143500.1520660-1-amir73il@gmail.com>
 <20250526143500.1520660-2-amir73il@gmail.com>
 <CAJfpegtYTpJXYOiyckcfQA=YTVXcLQZRGV4=sjueLenJpTp7Lw@mail.gmail.com>
 <CAOQ4uxjh9u3DE_HKExa=kK08efzDsxVuCVuA0tUMjwSeLX=jnQ@mail.gmail.com>
 <rjqagpvze4mwnil6tck6jnyqfbcgqszy5bjgu4fqzdtq7e3idq@uizmifogsqyf>
 <CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com>
 <urxghfhdccjg6v47h63btu77kyxnsxbrmxdbhb7kx3oiqz23og@plyznhi36omp>
 <CAJfpegv9Evti_MmWR72Gg13s9XYsxJHQ3WSJRwLrBy5O8aVHaQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv9Evti_MmWR72Gg13s9XYsxJHQ3WSJRwLrBy5O8aVHaQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, May 28, 2025 at 01:47:37PM +0200, Miklos Szeredi wrote:
> On Wed, 28 May 2025 at 12:55, Karel Zak <kzak@redhat.com> wrote:
> 
> > Why is it fine for mount(2) but wrong for fsconfig()? This is the
> > question. There is an incompatibility between the APIs.
> 
> Where is it documented that the fsconfig(2) shall have the same
> replace semantics as mount(2)?

Okay, fair enough, but you understand that userspace needs to adapt to
the new API, and ideally, changes should not be introduced to
end-users.

Frankly, I already have a private TODO file for libmount2 because I
feel we need to move forward, simplify things, move away from the
mount(2) syscall, and fully adapt to the new kernel API, which
provides features we do not yet support on the command line. The
current mount(8) command line and semantics are based on the mount(2)
era. The remount with all the obscure options (like MS_REMOUNT|MS_BIND)
is the worst legacy.

> I think this is just a bad accident, and I'm wondering if this could
> still be fixed in a way that doesn't introduce more hackery.

Why can't filesystems silently ignore fsconfig() requests that do not
introduce a change? For example, if the current setting is foo=123 and
fsconfig() is used to change it to foo=123, why is it reported as an
error? It's stupid, but just no op.

> One idea is to introduce a flag (e.g. FSPICK_REPLACE_ONLY) that makes
> the filesystem initialize the fs_context with the current options.
> That would work, no?

I'm not sure I understand how it will affect userspace. Do you mean
that with the flag, the kernel will assume a completely new set of
options from userspace, and the filesystem will adapt (if possible) to
the new settings?

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

