Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF02843933E
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 19:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783537328; cv=pass; b=Byp5cNjDj8Ud36AryIBT1WlxdA+GtqeFMu6xUjjTm6rtMs/SOlcfhnz9jRDTX2hQoHIcJATEeZlH5NuQHWl1x0LXlixS2LerbCV33tKH2t556fUpphOhGOg+jRHDOdZVmnjlv7lVYuEqTCNEeez3oQVBuyWWxslJ9o+mNRAQWYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783537328; c=relaxed/simple;
	bh=RrokN5hI2xrJP0hSZASJxB0o58XKatfrhNPDXueAhYg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TBqyXD1CxAEQNNDvBWs/w8jlaGda4b4Ah1tyqs9EbBrhKCoDJa69Zciz8YOr0M6Wzc9zur6m11ubp/6NVh863W5MyyqmfmpPf9kTUzXd/TAJ8evN503gg6lXyt8DZ7aZ+ZxgUpDw/+TqAIOc7greDu/XCXs5xs6dQrwWACQtxTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Glm/llwh; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Glm/llwh"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-698a9f11776so1743527a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2026 12:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783537325; cv=none;
        d=google.com; s=arc-20260327;
        b=etUPk8eZmBzLD5vV5RPc/1muXMghihYoJctagGHxsjO85JQfxrzfK8B7+Kt2RqCzM6
         d974Ckq1HYcq5Np63GMITQz4WoezHkVhnqc5Trm8ImE9DuMBTNaYA1MWjPfRUmM9Uz8P
         dHBmxKt+K0nXWnFueAQt+DDf7/RTRa8MOdwQ+gPRjeCf+XpyMFWFmlNgpaP8a3RETi/m
         gtWYBr0cW32eDEcrwIKh0BmXMYFBrCAgtCh05IdQoXi0y0yLN0bUYE6D+zUsLlXslrwO
         azLy5yOPwrnApsytZTrpyacv19HovC3DkMSY3oByuMUjx82pjcVOIdzyfhTR7T6fNiqa
         GKrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h6p7iFMPL0RnoW5Oom2GXslSbFev5CUALqnSA0TrUcg=;
        fh=8lwIsTsqsIpfPEUjYGWylNv44w0Yd5Qf9PpEpCAOqA0=;
        b=RcVk73EoyWqOL0ZOqoQTxT9y8I2JIkaAu21NsvsgjcFa/3u13HUzJ9Asl22imc3m2F
         yxgLhTye7ZbJYHj5Kqjd5rqDilHa5F/VTSYY5tHbey1qY+R/JrOataBg4z8a42x3YMyE
         yoMAaVnbuF21jFJOgqP7/dtsm8Qf2gVSlixKjLrnp4GXhLyRg8gXXmAa7jNqsOX43CP+
         znOnVxHk2tfppPNdsa3CumjozdvFLGB1dwLNtvivaVNh5QhwO2A5E5yyiUrqTJegB/yb
         5osY9mXNfYDumJreiShThIYtFNtgggy93gX7su3RZAnTIGNTmk0q1FU/PLhqVezy6ORr
         G5ow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783537325; x=1784142125; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h6p7iFMPL0RnoW5Oom2GXslSbFev5CUALqnSA0TrUcg=;
        b=Glm/llwhmN/OqN4srBrldQ2ar8nOoVYOXQIzgUAQusWDAUbWpUwfXvP7QQfe4hkzoC
         6T/1wWq6ZNv49ZgET+xVVQSy2BN8YuxH2ZQBTCI9FVUMS3kwODjqebtAoJxFSmhKKNLM
         26/dxR/PyXTA4pftE5BznuI2QJ9J8kd/1iis8BTs4fXPRzTV2okI6hfdEdafzGZS0Try
         t/7iH6EVPIQDdvm8s2MIflJ78xi2Ceh3zPPB6y9EXOcq/3MwuQnb6nH7H3JoowV58uRo
         c2Ct1hRUgr8w6j7fAa/f8XIFy1Bwj5Q+kIo1xLn5oKxdJnEK00J1cLUkxzco0vC5m49z
         kJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783537325; x=1784142125;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h6p7iFMPL0RnoW5Oom2GXslSbFev5CUALqnSA0TrUcg=;
        b=UUTa8jSrYVGiP+bsu8mT7v0T2Qw5mVIq8pqR09xooioa1J2SbPVBvSj7PnbfQIHtyv
         eSGrHavho2TQufAM4PyymCCz+Efy2HMXOxZnTpsJyOkQHqoxGv1U7gfChJZCXLN0023M
         J13R/hpMw8OqKOaURZFAH1vkIcYME06+8+FUIKumS8hRSWAFWlaeC0LJL1PbRCLaovVG
         zpY44EMNvCcqJdC+lOlcZMusnIbVzgYgoG+kFSj0yXQLay11xExe2ffjTSVvtVSTzpsI
         Pkt+QajJwhjf5nOirLMUP4ajuo/I19p7VWf9gaJIQ7p6wgCa2/XksUKXTqoRahG7BCnI
         8PlQ==
X-Forwarded-Encrypted: i=1; AHgh+RqnSy6R24SAPv6aB6TGAN/lV4G8VTfxG0u3+Ttr1ersSZaSjwYhBBJxgrb9OW4dd/u/S15Sg2c7vFFSJNbi@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9wqU6gMrvZYq9/Bh3oVKd6ChpcRj+IBnZwvMRYvY1NBupH43B
	iNFXYqY8kWDygs8BticQD2ov6tai72VYjZJTZ24atXyuQopNg986DF/gl9CF1gsSgdiITbUlWZO
	DYqPYr3uea6UhJrgYbkoM2A8QyykiPgU=
X-Gm-Gg: AfdE7cmBJXAgBPczQ+HMlE/fIJnSOBLwX/JblihRZLCogkjHkZ7A6r6/nyEuvyzK18K
	bXYQxlfAV4kA1M0ATV4PIobt5y5DBRatC44I1XIlddj4Xfn32OlUaMaE6tmiVu6cqZHAs352AiM
	5PLlYGWT49d1wjhMP3h6CV8xl3mAWt5/bmjgCqaFRachQrOOYyommbBrItWO+l/EDBCCB3OYR8f
	L0pQIi+M91pywB9k2bybC2617Z74jarhhjRpylCya/kT7E7RGfZ8Z+a4WJAS4HV6UleDXOPXg==
X-Received: by 2002:a05:6402:1f89:b0:69a:9355:ec35 with SMTP id
 4fb4d7f45d1cf-69ab44b5e42mr1817377a12.41.1783537325129; Wed, 08 Jul 2026
 12:02:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com> <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
 <878q7l8y4y.fsf@redhat.com> <CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
 <87wlv57dt1.fsf@redhat.com> <CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
 <87o6gh79yi.fsf@redhat.com>
In-Reply-To: <87o6gh79yi.fsf@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 8 Jul 2026 21:01:53 +0200
X-Gm-Features: AVVi8CcH_8D2AVPgSdZmur5rdOwKhUpVaCHJD-tULtZMblV_EPw4hJoYlLj59_k
Message-ID: <CAOQ4uxgbNhdzKN7tvRmFDpt-8CZWh9pVcMLv25HxJzA0_0WfSg@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, 
	linux-erofs mailing list <linux-erofs@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 5:55=E2=80=AFPM Giuseppe Scrivano <gscrivan@redhat.c=
om> wrote:
>
> Miklos Szeredi <miklos@szeredi.hu> writes:
>
> > On Wed, 8 Jul 2026 at 16:32, Giuseppe Scrivano <gscrivan@redhat.com> wr=
ote:
> >
> >> Amir suggested to add that functionality when I've asked for some
> >> feedback before sending the patch here.  I am fine to drop it if this =
is
> >> the consensus although I see its utility from user space.

I was thinking that getting the number of layers or info would be
a good idea to complement getting a layer fd.

I agree that the same information is probably available via statmount
by parsing the upperdir/lowerdir/datadir mount options.

> >
> > How about a completely different interface:
> >
> > int get_fd_opt(const char *name, unsigned int index, unsigned int flags=
);
> >
> > Enumerating layers would be as easy as passing an index stating from
> > zero and stopping when -ERANGE is received.
> >
> > It would work for all filesystems that use files as options.  No more
> > fs specific ioctls.
>
> Is a new syscall really justified for such a narrow use case?
>

I feel the same way.

Giuseppe,

Could you add some high level context in this thread on why you need
this functionality.
I think it's this composefs-rs work. right?
https://github.com/giuseppe/composefs-rs/commits/reuse-mounts-and-prevent-g=
c-overlay/

I must say this seems a bit upside down to me.

If you want to keep a pool of mounted erofs images, you could do that
in userspace -
create a service that indexes mounted erofs images by unique mount point pa=
ths.
Then you can introspect the overlayfs mount options referring to those
mount points.

Going through the kernel to get an fd and reuse that fd for a new
overlayfs mount
sounds like a strange way of accomplishing this.

If the overlayfs mounter is unprivileged, it would have to go through
systemd-mountfsd
to request a mount of erofs trusted image, right?

Can't the same service provide the "is_image_mounted" query which provides
the mount path?

I am not against introspection of overlayfs, but I'd like to understand
the use cases before finalizing the uapi.

Thanks,
Amir.
