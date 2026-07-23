Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25AD3F0ABE
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 08:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784793629; cv=pass; b=P2N50RwXOiz9mxlHM+eq13kXbOG6e+/N7jOCJ1w9zMxxL0rL6rIIkVcw8AWZO55ITIdwdWlBahRbe0pzBwpqzcDvfebc9IEgP9t+F45XQhSV7hqj1Bab8czcoZUCPTPCT0SjtxH2l8PWaqwHcQSxOHZsDaVQT39e6DvyDc8YHa8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784793629; c=relaxed/simple;
	bh=01lHwYFuZnQbN8PHIAgwHtlEdJ/vNcJ+QxlGxzJvbrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oCxgOYtdFWuUlcptzE53nIBhTzhNb2NhOnOBIfrCmkuWxJZNrkRgi2n1TXMeuim+XdKAEjKs6FbI/d5vwiZgwbjiISvx1/4IL4ceUYRE2ifVe7YZtzwAmD3RbJWjxxoEyIOHs5y/wYWAdfeIo90IHaaTHrdRHZZUMgpjlA4hqpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=fyKFttsW; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="fyKFttsW"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5276d598b96so2732941cf.3
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 01:00:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784793627; cv=none;
        d=google.com; s=arc-20260327;
        b=ZBAFk4f46sd+CczCt7YtOYtpO4QzPfRUrDLE3YQd5j/CMjwxlTGJzvzNqHTQKgXlFL
         Wqx2trLVbBhZLikY4QQXgrX8jimi4hYpmlKDSIPBWHxx3+l0xMmVRiC9PV+IakYjZtcL
         Ew1QzCWCJCxHVKnMs/CLgpT3XQl20cYGxpTQ5aOiUMvWR3UvBh5+FKR9lC5p8aB9fBwc
         6AoBg7Scs+JyF8YS5IhCLJQZYv/F912JK2fLLdJwE1XsTTy093O0FuJmTyGOxL2Jac9V
         +V8R/pWpO6rLKdhZriCuv2y8W7Z368Oy/F9C4RbzUeJB9MZHPY7GCSnkyCtafjwQHgyx
         y8wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=aJJyvzLCovMudd4JAugLONkO2PNspQZPslZQeXuUmI0=;
        fh=QzEtLlB7+AkchvEiOMNToKg0RrKqWXCR6LdRjRaJdrk=;
        b=c5zd88kZVDkq2zE/Qdn5YBcQteMbXuf6lK7v366pA4L8qgufJfZjt7afwYj8jZCzNa
         p4WdaH9NuIRkXl9NtGMMNlW20B48+kqClgFqtoyuJkQa1367JHEOH/p026A/Ybe1miSy
         ucru68YKy6Q9/M5cQ1R/27wn7oMVPJiD6U0yI7+0yDCO5z83993YtaWp2kLil6xqrr24
         rA9aSCByna8irdnAnKlfcQJfCiBr720q31ZePoD0oOiQ/C00N3ZfMwwmkdMeQM4eOgg9
         n+tjQ+L/5F4SYaXpZFyxNaOQfa7iAbInJmMC68yXpEH2qfgn3eyiEyJ+IuUH6dcjxgKX
         OeCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784793627; x=1785398427; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aJJyvzLCovMudd4JAugLONkO2PNspQZPslZQeXuUmI0=;
        b=fyKFttsWz2DOyLtPnYauQQPYmkm2e/OIaFutCA19BKBPecaxcRba025AoAZzkU/f7E
         6/vfvMqYq6V5IXujJaouvPuU/8eQoL0+HIIlp+uJ7/S33XYv9XS13w5FLMGpcJgHiEIn
         ccX0LqfKPXnNSpHD9q/Mm+8q9hdsD9NDhRAiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793627; x=1785398427;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aJJyvzLCovMudd4JAugLONkO2PNspQZPslZQeXuUmI0=;
        b=GI8y+cB78+KYaq1FvV39h9FCq9RbNKo9Cs4m3Hb1RB2Sw3cAkEg9wo3AA0sMld/fDF
         KAW3rRjYw/Lo4stJkp/cORmmMLTgQzyCrtXXOf7/Y6whqE9ZoYc55B4IEL/q9mALkW+J
         G3OKBIEEse2Uc/XyBoTcOCiA1kxK/wyTgmCrgxvGPzVNUtvrNCG/Hr3989/FkUoeSWyg
         CpCkt674AlPyE98U60/09o5oiKR7gTV5rUhrq800fjiI1USr++7Bo0v0cL3VApLX7YZq
         9Eu/E0R8QSk2sgTeSpfGQbKAHSkq1pZV8p9tfWdq90/yq2762HYtJQYLpCs7blqFHw5R
         vvLQ==
X-Forwarded-Encrypted: i=1; AHgh+RqdT1gYXqlg1VpudbY4UfKJYh22x2OSwxcWQJ6c0/7WGf5446XMmAHzAXdh5aosYz5t/MHkkk0q5q/4pY//@vger.kernel.org
X-Gm-Message-State: AOJu0YxWzBCsoqdbsJZpEilyC56qTJAG15CNYLxnEPWgcNhOAIgCHCDE
	ujMhhuhPTx87S+4vVc5G1cfVZ3XOQFGh61LBn5uShR7g/axcLL07xCFVGff/xCigI75/bNOFtG0
	F/VTPPyFDASuAeH2hcGwYkSY+jWlWHftOROWPsMr+Sw==
X-Gm-Gg: AR+sD10k073Z+3ORhJqIgLrb4URAWLw3M8wDPzPbS7hXp+6RO8KTrYjGMRrdsdSCYDh
	JIx/JpeVOYfAl+1wE0RsBKq5WcJVWd61X5M/9EerpkhqvIQ9seU8LqNJYxe+FQ8KmE7ym/kYV4H
	y2WjdYzLc37Z1uvN/hMGta5pMzUpCi1i3W0QlMZ2hANSZ9yHemQdPcA8cYHJ9JY3hmA5yKdmHmw
	BMWXUoafLAQCvKF9RgMAI8i3z+x6UJaWq8qX0GSGawBINb7Z5oosmL33E4930XgUYhrVf2QOWbC
	igzrG9smD41NUUr9EQ==
X-Received: by 2002:a05:622a:a06:b0:528:3ae6:14b1 with SMTP id
 d75a77b69052e-5283ded5b58mr17799601cf.43.1784793626482; Thu, 23 Jul 2026
 01:00:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
In-Reply-To: <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 10:00:14 +0200
X-Gm-Features: AUfX_mxrAWDoGqE_Z2q7dsB9hEn4mw686sbiCfQ_kvnOWqvfJ8QAiTiMbX_EDHA
Message-ID: <CAJfpegs9Mzx2bPTmWWzGWv7D2jF5Nspns-U6jf=KeAufiFMXyA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 at 18:06, Christian Brauner <brauner@kernel.org> wrote:

> We've added a primary set of apis to retrieve mount options. I really
> dislike the idea of introducing a completely orthogonal layer to do the
> same thing (or more) and also make it filesystem based while at it.

Fair enough.

> The other proposal of moving it into procfs doesn't lower the creepiness
> factor. It just paints it a different color. My objection is to the
> shape of this not where the entry point lives.

Also fair point.  The reason I like the proc entry point is that it
makes this accessible in the global namespace.

> Like, I'm fine having an api where we can use open_tree() to see through
> into underlying layers and given the right permission pull a mount out
> of it. That seems something we can potentially do.

That's exactly what I was proposing.  The "retrieve all mount options"
was a bad idea.  Will drop it.

> There's a few issues on top of that. O_ALT is silently ignored unless
> you spell the open as openat(dirfd, relative, ...). path_init() only
> looks at LOOKUP_ALT in the dirfd branch. open("/abs", O_ALT) and
> openat(AT_FDCWD, "rel", O_ALT) fall straight through and open the real
> file.

Good point.   It should either reject the non fd case (including plain
open(2) or use cwd as the base.  I'm leaning towards the former.

> The layer symlinks are an unchecked jump into internal, out-of-namespace
> mounts. Following mount/options/upperdir/0 ends in nd_jump_link(). That
> doesn't do permission checks and no mnt_ns check.

It should do the permission check, will fix.

It's jumping into an anonymous mount, why should it check mnt_ns?

> The overlay upper/lower layers are internal mounts with no mountpoint in
> any namespace. So any unprivileged process that can open the overlay
> root gets an O_PATH handle to a layer root it has no search-permission
> path to and on a mount outside its namespace and can then use it as a
> dirfd.

It's just missing the permission check in metafs_path_get_link().

> Pulling the mount out is gated by CAP_SYS_ADMIN, but the handle and the
> traversal are not. That's exactly Andy's "whose creds" question, it's
> inherent to the design, and the procfs variant has it too.

Maybe I'm not getting something.   Why would the metafs based design
be more limited in how it checks permission and with which creds than
any other interface?

>
> get_options() forks ->show_options() permanently. It's added
> alongside the existing method and mnt_show_options() now tries one then
> the other.
>
> That leaves the tree split forever or commits us to a flag-day
> conversion of everything. The new thig is also heavie and loses the
> seq_file overflow-retry. All so the 99% of filesystems that will never
> expose a path option can carry a more complicated interface.

This is something that would be useful anyway.  Would prevent the back
and forth escaping for statmount.  I can do a full conversion patch
either with coccinelle or claude in a couple hours.   And nothing is
lost, the layer above seq_file is just an abstract class, could make
it call exactly the same seq_file ops as before.

> mnt_devname to s_devname move is a behavioral change. alloc_super()
> records fc->source only on the sb-create path in sget_fc(). Sharing an
> existing sb path never updates it. For filesystems that share a
> superblock across mounts every mount now reports the first mounter's
> source in /proc/self/mountinfo and statmount().

Well, drat.  Doesn't really matter, though.

> And the smaller details really show how inelegant this model is and why
> Al and I have opposed it multiple times before. Scalar options are
> modeled as symlinks and non-path options are dangling links whose
> readlink still returns the value while for path options readlink returns
> the option string but following the link jumps somewhere else entirely.

Hey, this is was a prototype to show that this can do what Giuseppe
needs.  Not with nicely polished interfaces.

Completely agree with you, that's a shitty interface that I've done in
there.  Not proud of it.

But that's completely besides the point.  The point is that it would
allow a lot of things to be done more elegantly, without adding
special interfaces all over the place.

> But a generic metadata interface layered on top of yet another magic
> filesystem whether it's mounted or hidden behind procfs I feel very
> strongly about. I also have great difficulty seeing Al supporting it.

Me too, as you have obviously noted.

I'm going offline for two weeks starting this weekend, so no lengthy
and heated discussions for a while.

But I'll be back!  HA HA HA ha

Thanks,
Miklos
