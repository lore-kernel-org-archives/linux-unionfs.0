Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6433E5A12
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 20:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783542947; cv=none; b=nSXnRJIenh4oFxwcdORioQODT2CYzjEsciRStPi4Uy2tJB0vWNhWbEzg3nSff3Ml+Y+/VVjQHlrRFCVkej5NQ6aBHJ+J0gFtEMrugCXZX1suk2ttdhMuu8EtE0koTxDnmH8BsRhb3VsemgsVO9pP1Zx0XqQm7suhzEDn2RJF3Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783542947; c=relaxed/simple;
	bh=dNCH3GBqXQ8BeQwtL9quBRN8WK05Wh+x5HVAqi882XU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tUpw2x/HD6xWup6mVo5mhV2lfcJh0LcN13MxJcL6HN0iAutpeLjYgyRi88pRjgWHPqPkMW7OWZpB4sii5tzWoO4t/8ejhZZm3I8LTwXZyKd8PE36k8JKllEfbqiI8CloLORMQxpiwumkgAv8jREgg9I3ZZOq6vWnC74oMpAiFXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQjb+NBK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQjb+NBK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783542945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/GdmhhnDmpRS1ZdiDos4jfG6fHjForej54rE9mVQS0Q=;
	b=BQjb+NBK5IFDBmEWx3wZoU6Bb6WTU0hBIFrOAkNBQGEPBCESkCgyS20g3E8yN6+XQze5K/
	He9nu2qbduDHr9YLiw9QYDKyp6xQWmVfMCe75tfnu3ZcL2u4SnWM29toQO8d/5YefgazYf
	glnXR9erQ9JjCzas+ZB1ti5UvOhMJc8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-396-KBF1YK9DMuaxt0-_1DuQlw-1; Wed,
 08 Jul 2026 16:35:42 -0400
X-MC-Unique: KBF1YK9DMuaxt0-_1DuQlw-1
X-Mimecast-MFC-AGG-ID: KBF1YK9DMuaxt0-_1DuQlw_1783542940
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 673951955DCF;
	Wed,  8 Jul 2026 20:35:40 +0000 (UTC)
Received: from localhost (unknown [10.44.33.4])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 724961774;
	Wed,  8 Jul 2026 20:35:39 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-api@vger.kernel.org,  Amir Goldstein <amir73il@gmail.com>,  Al Viro
 <viro@zeniv.linux.org.uk>,  Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
In-Reply-To: <CAJfpegvUEEbFnCa1N9k3gMXpw46YFpWuta=G6brON1=xU36bgw@mail.gmail.com>
	(Miklos Szeredi's message of "Wed, 8 Jul 2026 21:45:01 +0200")
References: <20260708095831.3381978-1-gscrivan@redhat.com>
	<CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
	<878q7l8y4y.fsf@redhat.com>
	<CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
	<87wlv57dt1.fsf@redhat.com>
	<CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
	<87o6gh79yi.fsf@redhat.com>
	<CAJfpegvUEEbFnCa1N9k3gMXpw46YFpWuta=G6brON1=xU36bgw@mail.gmail.com>
Date: Wed, 08 Jul 2026 22:35:38 +0200
Message-ID: <87fr1t6wyt.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Wed, 8 Jul 2026 at 17:55, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>>
>> Miklos Szeredi <miklos@szeredi.hu> writes:
>>
>> > On Wed, 8 Jul 2026 at 16:32, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>> >
>> >> Amir suggested to add that functionality when I've asked for some
>> >> feedback before sending the patch here.  I am fine to drop it if this is
>> >> the consensus although I see its utility from user space.
>> >
>> > How about a completely different interface:
>> >
>> > int get_fd_opt(const char *name, unsigned int index, unsigned int flags);
>> >
>> > Enumerating layers would be as easy as passing an index stating from
>> > zero and stopping when -ERANGE is received.
>> >
>> > It would work for all filesystems that use files as options.  No more
>> > fs specific ioctls.
>>
>> Is a new syscall really justified for such a narrow use case?
>
> That's the reason I advocate pseudo fs based solutions.  Let's see, we
> had a proposal to use openat(), something. like:
>
> openat(base_fd, "mount/options/lowerdir+/0", O_ALT | O_PATH);
>
> Meaning that O_ALT switches to an alternative/meta namespace that is
> based on the given fd and in that meta namespace the tree under mount/
> represents the attributes of the mount that base_fd is on.
>
> See this post from Linus as well:
>
>   https://lore.kernel.org/all/CAHk-=wjzLmMRf=QG-n+1HnxWCx4KTQn9+OhVvUSJ=ZCQd6Y1WA@mail.gmail.com/
>
> The statmount api took a different route, but for getting an O_PATH
> file this would be a very natural interface without added syscalls.

I don't argue against such an API, I only argue that I am probably not
the best person to drive such a significant change :-)

Would you be OK with the ioctl as a solution that works today, and
duplicate it when an alternative API materializes?

Thanks,
Giuseppe

