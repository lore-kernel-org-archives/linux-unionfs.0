Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6940418411C
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 10:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721040660; cv=none; b=lsxCXtEaHAR7IzRRCocXoTJ5j5uHfm2/sjy0o286Rgsglwks0nGPKapAHn8USRYbM05TJruUSuB5+rq+4aQ+uURCLVot6mI/Ah+Xdget5EYdjPByZpuul5XumEhIPoW6Mkss5xYY7tna4YRRLrVEHxQ8J6iuLB7A0Gwl4RigzY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721040660; c=relaxed/simple;
	bh=1RgVYHiaz2pBdDr+Cxy+f//XJSTmDwfTyjIveaZUvw0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yq3GbNpMLrcm7NGr652NizkNJ7rNGE6hxgwo4XaHVh/uZbkw5tpLmRX3sqJqKO9lQBpwnNV0M78V4atKF54txWBMy/9Q9ApvE2qaVdVabqmdQ7TJY5KhYLqCV/jjz/aO9l5hP92sPmGrYPmkvWkcB5lVW5l2udP44bAnORIRunM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com; spf=pass smtp.mailfrom=dneg.com; dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b=rF9jwEzn; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dneg.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b="rF9jwEzn"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-59589a9be92so5594603a12.2
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 03:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1721040657; x=1721645457; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1RgVYHiaz2pBdDr+Cxy+f//XJSTmDwfTyjIveaZUvw0=;
        b=rF9jwEznW86aHSaoFr+30rFI0uZjGRUIig0skrKT7T1aKQXbU/bb6Zbg6V7M1ViBhp
         xrML0Uoy7e1Jh6T/+EuPYoWnizOAsQ5ZV4HXnCdZDdjApokuduA/2HoHMfZ6dHQoyuuR
         nVGWv8SM0GgMoFeEcDMUSzkETu2OWJhZRlkuzeP/oltVlo8ZxF2W9tf72u35u31L9ZeF
         VsPlMTYC83MYlNiLDKFkwuNtI5a5Hf7XNiDpeIXXSaiyItOPnFTx0MAByg/9JMgCpqS0
         yIPXOogRPAOpsuPu4FAoYAM2UFufBesvZr5/Osel1FyrzErWS3TO1UExP5Td1cBqt7GP
         qU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721040657; x=1721645457;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1RgVYHiaz2pBdDr+Cxy+f//XJSTmDwfTyjIveaZUvw0=;
        b=LIdJ2BTaUiQWxuSQjf6gCHK2NhS72RI2Md+UzZQ79J0W9H2R2boqg0+Z/xQKQbWnYy
         ZhIJkF8crCeUdt6GtY+VnX85K01G3py26LT8x7ZY+p2ZxsRVwoBttEVFyW4pWjVMxCBg
         mgOUW7uS1U+0R4ejH9u/anCSqSteqgyRBRtwlYGjAvwRk4P4gY0BSuJPQRyW/mbcSzu1
         0TsvnarGT5HHjbHcTnTki0Gaglqh8dvDlAfcU+gHy6nk+CLWySDbB9lPmyZBQKSF5oic
         qFCpN03xqt2K7DX6eqQGePVrtM99BdBnIPhm+5MSbb999m+iUW2x9rM4LVrZ50ishgmm
         jf8A==
X-Forwarded-Encrypted: i=1; AJvYcCWZDfr3gzTM6Dq0d8qxi5ykCvGW085S5iwPFyR7bG8rp5XFxjvRiJ0WFiq5UMzPfD1/VEH8qLA37u1A1R9PXf3OQ4/5/1pqn53UYc2b7Q==
X-Gm-Message-State: AOJu0YyiHOWqlOGGSaug2zsGAmDJBO1XZAwAphULMe08gbUz2bERBYB9
	B/JAW8HMvwA8X0F7WDnLnaGQfe1D3IuDeLtnrq/kBCRGgUmShrr0+K/BX+aAMEQ7tBDNIKTLNmM
	blUD4xaysAbOH8MWQCF/Qb1a0BrgYnAmjXw1H8A==
X-Google-Smtp-Source: AGHT+IFIwpEF6rea5BLUKbsTGwgdOxQ7RjtqcxaOm4jsgGosLJNJIQ2ykJuI1AF84jqBcFz9AuuyKfgHMrlHZfwDa1Q=
X-Received: by 2002:a17:907:94cd:b0:a72:5470:1d6a with SMTP id
 a640c23a62f3a-a780b6fe30emr1626332266b.35.1721040656673; Mon, 15 Jul 2024
 03:50:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
 <f1ed1b60-273d-4ee6-bbcb-ae3d78486b70@mbaynton.com> <CAPt2mGNO_koGozPx68GwowuxDd+CkZWT3Xa7DE-4XCwd9K_RJw@mail.gmail.com>
 <cdbda6fe-ee9c-4437-bbd8-c9104dd2043a@mbaynton.com>
In-Reply-To: <cdbda6fe-ee9c-4437-bbd8-c9104dd2043a@mbaynton.com>
From: Daire Byrne <daire@dneg.com>
Date: Mon, 15 Jul 2024 11:50:20 +0100
Message-ID: <CAPt2mGOv3MtRHF5N_tDMXcDN4M4vr=C-YEkE=gd9kEhd6iwtLQ@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Mike Baynton <mike@mbaynton.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 14 Jul 2024 at 05:12, Mike Baynton <mike@mbaynton.com> wrote:
>
> On 7/12/24 07:04, Daire Byrne wrote:
> > Yea, so I have also toyed with the "composefs" idea
>
> Yeah, I'm doing what they're doing but making the EROFS in-house and
> hoping the kinda-writable NFS twist isn't an issue. I only need to
> satisfy dependencies for a container's worth of software at a time and I
> can determine all the dependencies I need by virtue of tooling in the
> software ecosystems I need to support.

Yea, I need to check out EROFS at some point. But many of our desktop
kernels are just too old atm.

Overall the idea of hand crafting metadata-only overlays is compelling
because you can avoid the complexity (and confusion) of using symlinks
and it's extremely lightweight (maybe even more so with EROFS).

> > I guess the difference is that I'm not trying to replicate the
> > entirety of the metadata, I just want to tweak bits of it and still
> > avail of the overlay merged directories to fall through to the
> > directory tree and data underneath for everything else.
>
> Yeah I understand your objective now. I'm mildly curious why NFS +
> fscache doesn't solve the negative lookups case for you given that you
> want a dynamically generated local cache. Is fscache just unable to
> cache negative lookups, and you want it to persist for weeks?

Well, fscache is for caching the data contained in (existing) files
only right? It makes no attempt to deal with the metadata (e.g.
directories)?

Or at least I don't know how effective a disk based cache of metadata
could be compared to the vfs page cache when you still need to
revalidate fairly often. I mean it needs to revalidate the file often
(actimeo?) before it can serve the cached copy so it needs the remote
metadata lookups?

I have seen some talk (David Howells) about giving network filesystems
like NFS the ability to have "disconnected" access via netfs/fscache
(ala AFS) but I don't know if that is still on the cards.

The issue we see is that not only do our batch systems cycle through
lots of different software versions per hour, but we have many
thousands of clients doing the same to a single (Netapp) software
volume. Even if each NFS client managed to cache 80% of the negative
lookups between runs, the 20% that hits the Netapp is still quite
significant from many clients.

And even forgiving the server load implications, a Netapp on the LAN
(0.2ms) can add delay when you deal with many "pointless" negative
lookups. I have seen some of our software do 100,000 negative lookups
across 250 lib dirs, which although on paper should only be 100000 *
0.2ms = 20 seconds, actually adds almost a minute to the startup time
of the software. Certainly when we use a local filesytem overlay the
time drops by a minute anyway (most likely because the actual file
opens benefit too). Now if the software only runs for 2 minutes, then
1/3 of its time is spent doing negative lookups/path walking at
startup.

Yes, I am aware that our software is not well optimised but our build
system and environment is what it is at this point.

I have seen many other novel solutions to this general problem - some examples:

https://guix.gnu.org/en/blog/2021/taming-the-stat-storm-with-a-loader-cache
https://computing.llnl.gov/projects/spindle

> Also (only semi-related) since you have a large NFS deployment similar
> to the one I'm putting together in terms of read-only to normal clients
> and most files/paths being immutable after they first appear, I'd be
> interested in any experiences you've had in practice with performance of
> fscache and NFS mount options that relax its cache coherence / atomicity
> semantics. I've found it impossible to avoid roundtrips to the server on
> each fopen for locally cached files (unless using NFS4 delegation which
> is overkill and not available in my environment.) These RPC roundtrips
> provide no real benefit to our use case but can add seconds of delay to
> initializing a process if it accesses thousands of little interpreted
> language files.

In my experience actimeo>3600 can help for these kinds of read-only
filesystems but you probably need "nocto" to really get it down to
almost no repeat network traffic at all (when cached). Setting
vm.vfs_cache_pressure=1 might also help keep the nfs inode data in
memory longer too?

But nocto will also cache the "ls -l" case whereby you won't see new
entries. However, if you know a new dir/file is there and access it,
it will do the new lookup and find it (dirent not in cache yet). That
might work for your case by the sounds of it?

I'm not too sure about how that effects opens specifically though. In
fact, using NFSv3 might be more "relaxed" in this regard than NFSv4?

In general, our entire pipeline deals with unique versioned files.
Apart from home directories, I can't think of many places where we
overwrite or append to existing files for production workloads or
reuse file paths in any way.

> Not an overlayfs concern in any way though so perhaps no need to pollute
> the mailing list further; if you are interested in responding to me on
> these things continuing off list would be fine with me too.
>
> >> I think Daire and I are basically only adding new files to the NFS
> >> filesystem, and both the all-opaque approach and the data-only approach
> >> could prevent accidental access to things on the NFS filesystem through
> >> the overlayfs (or at least portion of it meant for end-user consumption)
> >> while they are still being birthed and might be experiencing changes.
> >> At some point in the NFS tree, directories must be modified, but since
> >> both approaches have overlayfs sourcing all directory entries from local
> >> metadata-only layers, it seems plausible that the directories that
> >> change aren't really "accessed by a overlayfs prior to the change."
> >
> > Yes, I think your case has a good chance of being safe and becoming
> > well defined behaviour.
> >
> > But my idea was still very much relying on using the majority of the
> > lower layer as is. And for all the reasons given, I suspect my use
> > case is still a no-no.
>
> I dunno, your thing might end up working out fine, based on your latest
> testing of when clients see changes and Amir's observation that all fds
> need to be closed but then a readdir through an overlayfs will observe
> changes. Seems "unlikely" that clients would hold open fds to the first
> few levels of directories at all, never mind for long enough for someone
> to call you and ask where the new version is :)

Yea, I think it is probably fine. Maybe another clarification for the
docs that others might find useful too?

Daire
