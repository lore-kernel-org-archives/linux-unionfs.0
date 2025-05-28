Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792A0276024
	for <linux-unionfs@vger.kernel.org>; Wed, 28 May 2025 10:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748429708; cv=none; b=YpCTX9bbmL3sGkQ8SHDEoTri1p2j8EOb9yKdthB5KiZsCEFiTwBt3olrJoeZfVemhsWXDlzKCR5AAAu7SPmRQ1H/hX1B+Yh0H++KXa32aSjCx1+wjb57zvIRoS8rHxTVsDwMv6hvnS4jGvzzJ+PdhovQ/Jq0zQLL+MqIMPMvgBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748429708; c=relaxed/simple;
	bh=95brraPCmu7C9TIa66D+eI8a5knDe4lu+5Cn1bTFrU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KFj1kHT3HjgwGuBcww+Csg7PVnMi5Awf2Um9W7374Uii8XYLgJHlFjfxIgiUDB31oYtN7O56npMH4OaBhUfGuAeH1QkTKtaBJ/jD4q8LTdWP90RrZvJAEHe0KLQaX1iGh6FHAORMmQHQeXcrvJFC0B8bQL8Yys+tLQnG+klu0AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CdpwekHA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CdpwekHA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748429705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9X7324etCP++i94lb4y7e0JmIZJOIR4ppGtUzPMDxYE=;
	b=CdpwekHAODbbPuuCHGESK6Vlz43kzK3pwJZKXR3/iWCsBrhMZWduhWXiDet7cWLLZt7Xkp
	PQQsLZQJG+u7PYac44cps4BUq53GCAeGEArvKGARIMInXzWy72Trht1OvYMSWws494VHUy
	wQZ6h4JmKQVoTSjqf3AXJQcGrIEsApg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-MCqjVRWtOCi68_6GrybXVw-1; Wed,
 28 May 2025 06:55:02 -0400
X-MC-Unique: MCqjVRWtOCi68_6GrybXVw-1
X-Mimecast-MFC-AGG-ID: MCqjVRWtOCi68_6GrybXVw_1748429701
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 413B81955D88;
	Wed, 28 May 2025 10:55:00 +0000 (UTC)
Received: from ws.net.home (unknown [10.45.225.54])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29CB830001B0;
	Wed, 28 May 2025 10:54:57 +0000 (UTC)
Date: Wed, 28 May 2025 12:54:54 +0200
From: Karel Zak <kzak@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Zorro Lang <zlang@redhat.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, 
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH 1/4] overlay: workaround libmount failure to remount,ro
Message-ID: <urxghfhdccjg6v47h63btu77kyxnsxbrmxdbhb7kx3oiqz23og@plyznhi36omp>
References: <20250526143500.1520660-1-amir73il@gmail.com>
 <20250526143500.1520660-2-amir73il@gmail.com>
 <CAJfpegtYTpJXYOiyckcfQA=YTVXcLQZRGV4=sjueLenJpTp7Lw@mail.gmail.com>
 <CAOQ4uxjh9u3DE_HKExa=kK08efzDsxVuCVuA0tUMjwSeLX=jnQ@mail.gmail.com>
 <rjqagpvze4mwnil6tck6jnyqfbcgqszy5bjgu4fqzdtq7e3idq@uizmifogsqyf>
 <CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, May 28, 2025 at 11:56:48AM +0200, Miklos Szeredi wrote:
> On Wed, 28 May 2025 at 10:47, Karel Zak <kzak@redhat.com> wrote:
> 
> > Anyway, I agree that this semantics sucks, and from my point of view,
> > the best approach would be to introduce a new mount(8) command line
> > semantics to reflect the new kernel API, something like:
> >
> >    mount modify [--clear noexec] [--set nodev,ro] [--make-private] [--recursive] /mnt
> >    mount reconfigure data=journal,errors=continue,foo,bar /mnt
> >
> > and do not include options from fstab in this by default.
> 
> But there's no fstab entry in the testcase.  The no-fstab case likely

Well, in this case it uses mountinfo

> gets way more use in real life then remounting something in fstab.
> And this should not need to get the current options from the kernel,
> since the kernel is the source of the current options.

This is how mount(8) works for decades, and I do not like it, but ...

The problem is something else. 

Do you see the paradox? The suggested LIBMOUNT_FORCE_MOUNT2 workaround
just switches to mount(2), but everything else remains the same; it
sends all the mount options to the kernel.

Why is it fine for mount(2) but wrong for fsconfig()? This is the
question. There is an incompatibility between the APIs.

> With the KISS principle in mind the non-fstab "mount -oremount,ro
> /mnt/foo" should just be translated into:
>
> fd = fspick(AT_FDCWD, "/mnt/foo", 0);
> fsconfig(fd, FSCONFIG_SET_FLAG, "ro", NULL, 0);
> fsconfig(fd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);

The classic MS_REMOUNT has been interpreted for decades as "replace"
mount option, not just "replace only specified". This is why mount(8)
sends all options on remount.

However, "remount,ro" is such a common and specific use case that
perhaps we can make an exception and focus only on "ro".

> and the kernel should take care of the rest.  I assume this doesn't
> generally work, which is a pity, but I'd still think about salvaging
> the concept.
> 
> > So, you do not need LIBMOUNT_FORCE_MOUNT2= workaround, use
> > "--options-mode ignore" or source and target ;-)
> 
> Yeah, that's definitely a better workaround.
> 
> I wouldn't call it a fix, since "mount -oremount,ro /overlay" still
> doesn't work the way it is supposed to, and the thought of adding code
> to the kernel to work around the current libmount behavior makes me go
> bleah.

I sent straces; fsconfig() doesn't accept the options, but
mount(MS_REMOUNT) does. Why blame libmount?

We can change how libmount works with fstab on remount, but it will
just hide, not resolve, the problem with fsconfig().

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

