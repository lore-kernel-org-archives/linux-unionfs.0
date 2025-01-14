Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A38157A55
	for <linux-unionfs@vger.kernel.org>; Tue, 14 Jan 2025 15:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736870203; cv=none; b=oZAEeQWgUCrUDUta7twxvk9oWXWHadcELBGlxx+ROG/bpMtLl5FtazEIu6WHgg6c7M+909rnDcVh5JEFwyjugsalfpZBg7B2DPY7+SfyUtF4/CRjPlz+bOVf3Uro1rcs6XZAHvhzEnC+ZcjTXflMrorTUxtagodhwmUxMWnd4qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736870203; c=relaxed/simple;
	bh=1MMH+aeR6O3en9YJJjX3R3gQ4ji2hKrVbwboXjL7z/s=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Ie4Ox9li14h5mKy4YjjAqgch1GBG23PsD5MPyTE/P/twoOWUXYWzGsdsu5lXdnUs3/4gjpQcXOgr4HvjwRxFt2W5vd4dp2maaOkHW8KMmoOnUfrJqlKmJNtvxz1fh8Td/KbcYon/JK+h/UpdhIykdkXg38RhLSoWmX+45m2JssI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TiOx96/E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TiOx96/E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736870201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YuFEatKDU5bNsUDUILwBr/XEvI4ugNRgiHgqlILwaZ8=;
	b=TiOx96/EcpZRtdAmZfexReKEJJAGfe8rQHChE7c9QwDZmsVG0vQ0EOdQwjkse1bxgg7IsU
	htij1AgKkQxG/zdbcrX2ewfNB5FMQmg87JfNcz9psbSJ2WYMF25WMWHUDnl9HvwFIJQ+wP
	kEoHdZliikuJJqy62R0pzF/H5qEJNhY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-nB68BRIjM-GYwOMnikk_Nw-1; Tue,
 14 Jan 2025 10:56:37 -0500
X-MC-Unique: nB68BRIjM-GYwOMnikk_Nw-1
X-Mimecast-MFC-AGG-ID: nB68BRIjM-GYwOMnikk_Nw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0756195607C;
	Tue, 14 Jan 2025 15:56:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.32])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E63E530001BE;
	Tue, 14 Jan 2025 15:56:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAJfpegsUbvMB_tFbV283_JmK+wzFAECaLZgYAbmcBbBxWX=Ctw@mail.gmail.com>
References: <CAJfpegsUbvMB_tFbV283_JmK+wzFAECaLZgYAbmcBbBxWX=Ctw@mail.gmail.com> <111000.1736867714@warthog.procyon.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, mszeredi@redhat.com,
    linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to support directory opacity in a filesystem for overlayfs to use?
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <112183.1736870193.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jan 2025 15:56:33 +0000
Message-ID: <112184.1736870193@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Tue, 14 Jan 2025 at 16:15, David Howells <dhowells@redhat.com> wrote:
> =

> > What's the best way for a network filesystem to make a native
> > directory-is-opaque flag available to the system?  Is it best to catch
> > setxattr/getxattr/removexattr("overlay.opaque") and translate these in=
to the
> > RPCs to wrangle the flag?
> =

> I don't know.  Out of curiosity, which filesystem is it?

One of the varieties of AFS.  Unfortunately, xattrs aren't a thing and can=
't
easily be added because of the volume transfer and backup protocols and
formats.

> There's "trusted.overlay.opaque" and "user.overlay.opaque" and are
> used in different scenarios.   There was also talk of making the
> "trusted." namespace nest inside user namespaces, but apparently it's
> not so important.
> =

> Which one would you like to emulate?

Um - I don't know the difference to answer that question.

David

