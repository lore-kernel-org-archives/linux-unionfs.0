Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8285E3ABD82
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 20:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783541936; cv=none; b=V8XACulfaT7oNaGYnBu61oXYiVy8Pgd1aeqrgbEZJ1+sbJBQSLcL8tMbU+rEwD/Abxz1J46QlwDNWQdhHI+4Fu0i3u1r4c6qmhqLQUTRIwHqqU6xJUIGzT+8z6ARaO1vjNZMHgY5uq6GYq3DG92Wi2Xc7r6EPqtPhrDUjzysCLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783541936; c=relaxed/simple;
	bh=imaqD10kp086IahNkIE0+Zx2+NFNLapVYleBB9qYepg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WoX3309G+pg66Y4RLdKEvIu6dUP4VQMpP+IJlI4eJRHzu59FJDCzd+eyrumFEdlmQYSpUGPoFwiiJE5e5E/WCfM4Bbzt4Y9tnIXmu7aZUwTmBleRvmGMGNHwdH87UkgUz+1aedUZ7B6hdSiz3lURUQapg8fLKuks5Uq8AeM5E/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iZSR1pcW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iZSR1pcW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783541931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jZ09L4XFG2W0w/5tRu5xszKIXUcHnXGcWlng1+U3UOc=;
	b=iZSR1pcWmo43+c3gszDFUlfcRqTlcyPNcQ1ahZ42kzPvCQKmGbUgsUaifRj5tRzvkoBQq3
	aIIeM6xuTEzl9wxGzqxqqFWPCLmD6N8cFTjvrZyj9H8HpMkWMtPLuQhgWyYFA3sqsjj5D4
	U1C7RdLhf//ndyTUm3IkqQKH0T8yxgc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299-PDZBUIGbPQCbZd3K1nH1Ag-1; Wed,
 08 Jul 2026 16:18:50 -0400
X-MC-Unique: PDZBUIGbPQCbZd3K1nH1Ag-1
X-Mimecast-MFC-AGG-ID: PDZBUIGbPQCbZd3K1nH1Ag_1783541929
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61D4E1800350;
	Wed,  8 Jul 2026 20:18:48 +0000 (UTC)
Received: from localhost (unknown [10.44.33.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 48D6F195604C;
	Wed,  8 Jul 2026 20:18:47 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,  linux-unionfs@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  linux-api@vger.kernel.org,  Al Viro
 <viro@zeniv.linux.org.uk>,  Christian Brauner <brauner@kernel.org>,  Gao
 Xiang <hsiangkao@linux.alibaba.com>,  linux-erofs mailing list
 <linux-erofs@lists.ozlabs.org>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
In-Reply-To: <CAOQ4uxgbNhdzKN7tvRmFDpt-8CZWh9pVcMLv25HxJzA0_0WfSg@mail.gmail.com>
	(Amir Goldstein's message of "Wed, 8 Jul 2026 21:01:53 +0200")
References: <20260708095831.3381978-1-gscrivan@redhat.com>
	<CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
	<878q7l8y4y.fsf@redhat.com>
	<CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
	<87wlv57dt1.fsf@redhat.com>
	<CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
	<87o6gh79yi.fsf@redhat.com>
	<CAOQ4uxgbNhdzKN7tvRmFDpt-8CZWh9pVcMLv25HxJzA0_0WfSg@mail.gmail.com>
Date: Wed, 08 Jul 2026 22:18:44 +0200
Message-ID: <87jyr56xqz.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Amir Goldstein <amir73il@gmail.com> writes:

> On Wed, Jul 8, 2026 at 5:55=E2=80=AFPM Giuseppe Scrivano <gscrivan@redhat=
.com> wrote:
>>
>> Miklos Szeredi <miklos@szeredi.hu> writes:
>>
>> > On Wed, 8 Jul 2026 at 16:32, Giuseppe Scrivano <gscrivan@redhat.com> w=
rote:
>> >
>> >> Amir suggested to add that functionality when I've asked for some
>> >> feedback before sending the patch here.  I am fine to drop it if this=
 is
>> >> the consensus although I see its utility from user space.
>
> I was thinking that getting the number of layers or info would be
> a good idea to complement getting a layer fd.
>
> I agree that the same information is probably available via statmount
> by parsing the upperdir/lowerdir/datadir mount options.
>
>> >
>> > How about a completely different interface:
>> >
>> > int get_fd_opt(const char *name, unsigned int index, unsigned int flag=
s);
>> >
>> > Enumerating layers would be as easy as passing an index stating from
>> > zero and stopping when -ERANGE is received.
>> >
>> > It would work for all filesystems that use files as options.  No more
>> > fs specific ioctls.
>>
>> Is a new syscall really justified for such a narrow use case?
>>
>
> I feel the same way.
>
> Giuseppe,
>
> Could you add some high level context in this thread on why you need
> this functionality.
> I think it's this composefs-rs work. right?
> https://github.com/giuseppe/composefs-rs/commits/reuse-mounts-and-prevent=
-gc-overlay/
>
> I must say this seems a bit upside down to me.
>
> If you want to keep a pool of mounted erofs images, you could do that
> in userspace -
> create a service that indexes mounted erofs images by unique mount point =
paths.
> Then you can introspect the overlayfs mount options referring to those
> mount points.

A first issue is that the mount options won't have this information
anymore, as we use /proc/self/fd/$i paths as lower dirs so we are sure
the fd points exactly to the file we have measured its fs-verity digest
before using it.

I know this can be achieved with a system daemon, but do we really need
one if this information is already known to the kernel?

Combined with listmount/statmount for discovery and fs-verity for
validation, the entire mechanism is stateless from userspace.

More in general we need a way to introspect overlay mounts to know where
they are pointing to since paths can be hidden using /proc/*/fd
symlinks, or files get replaced.

Another similar request:
https://github.com/systemd/systemd/issues/35017#issuecomment-2457333218

> Going through the kernel to get an fd and reuse that fd for a new
> overlayfs mount
> sounds like a strange way of accomplishing this.
>
> If the overlayfs mounter is unprivileged, it would have to go through
> systemd-mountfsd
> to request a mount of erofs trusted image, right?

off-topic but for now we are considering FUSE to deal with mounting
EROFS as it would serve only the metadata anyway in a composefs setup.

Regards,
Giuseppe

> Can't the same service provide the "is_image_mounted" query which provides
> the mount path?
>
> I am not against introspection of overlayfs, but I'd like to understand
> the use cases before finalizing the uapi.
>
> Thanks,
> Amir.

