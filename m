Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E0C1078B
	for <linux-unionfs@vger.kernel.org>; Tue, 16 Jul 2024 03:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721101534; cv=none; b=JK68IzAEJoOXMjzmJn9akKApLkgPfzHwxJmV86A2xZrRCjaTtBN1TxCqB8xO9at6f0OQ4bMaviCgkHxFK5zNEgLuinPTlfRyXbe0O4l7ekI1Yp4CZ3UAIYUXJfGMYms+TJwllM4DM4Uda1nKdTarRFeWJQ9ylMXaIMmf5gz46pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721101534; c=relaxed/simple;
	bh=8ZVpQXrFASBWs1ao210DNDtZ8yjFeay/Izc/fWwlLqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLe9gDIeT8pwbiJC55Pqecb5LtUsF71LQSbfw/SyOQalAveaxQl4WkOmR2bkYohSNToPm4VdIa2R8LG0A/o8bOrivdmZJCC32x2GsMkt/Lepl9azKAsSvmfCYoT8deCROsEz6qi/B8G/Y9rgsCYG+n7frailyspNTuTMUHp+N98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=pC/3J56B; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="pC/3J56B"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7fd3dbc01deso233195539f.0
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 20:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1721101531; x=1721706331; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LLTuD+w8q0VDswAckjmjo0WR0Un5jOnFNhs/hZR1V/Y=;
        b=pC/3J56BbDObXbKu6D+GJjsHONJFX0HZsLFQYmEGczVtZh7+NP8YM+gZDZyd7Lq7Ke
         Xe0ggJHNpK7lno+UuiWfeV+HDObzXW2GNkOirdEX7gVRhfSjbxiAn/PWpj8+2ea2CZZV
         tmckvLxngPI+SfI3KAdb25bEuKIx3JaiSVKk25w5TwUncZBKMo0sSYR5rRkHrt+iNd7z
         WUmZQbNytKeo8nWQlv9SRO/IegBPwvjzz132EwA7/xRrF0GY9Z43BdpYCVDzfv1akidK
         fi0QqRUwP5SF7eQ1IuAcNzNmC53Hkg92T70JEt6D4wj/kZUA2+jiX8mOD0qHXrBIbtEz
         t4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721101531; x=1721706331;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LLTuD+w8q0VDswAckjmjo0WR0Un5jOnFNhs/hZR1V/Y=;
        b=azfcv1qdVUPfdbmJbojzMVH4DnFpXnEzgf6uyZkepYL9zXiXiZNwDUGbZRp2P/yuqt
         0fGhMdw9b5iNtGJxkUQsJzD/xqiJTvBIPnKCaeL9EaWFoKx5Z16kcHW4M8Yk78T0L/qx
         jtzSY/cQ2p9nFeIsELh9AAktY0fVcDwElcvx36CA8Qf7yC79e4OsLl/LOa7X4sG1HPH0
         p0hi9lY+hNDd2x2i/5eQw/YHoHmNrRWdspIpxFFllWnhDkMpaTHm/JdphghL1S64wXH6
         ii71tt54Y0fCwptzKDU2O3NeGDDkxTbfW7wTrvnHo1K200S5RRtUod/mHyEX4sLFxk7N
         COTg==
X-Forwarded-Encrypted: i=1; AJvYcCU48rIVLDhVm9om1dQ53hvIGheFMY5VQkAZEyzfcRk7JjiS4vJ8LR3mZELxS0G8IP8a2nGbMDSk/Th8WeHDnB0LL0bxPuzfai/U5oijIA==
X-Gm-Message-State: AOJu0YxhDYS/riOd3aOSuFoZ6kzzy3tVkOE3KuyBRa+Z1E3JQnN3qaBu
	dwXNepVLgSK6XHSgDdMstS7fqQiPLzlkUO07a+9ewhacgQy1nhj6hqDnPXjjFU4=
X-Google-Smtp-Source: AGHT+IFgOV22H6cHH9+GY7JLe8qqyYvJ8JXdmHLXxo8JLeRmuYNHIS5UtNk/JnwSueNa1rHycGv20g==
X-Received: by 2002:a05:6602:2b0a:b0:804:f2be:ee3a with SMTP id ca18e2360f4ac-81574540ea2mr174219739f.1.1721101531434;
        Mon, 15 Jul 2024 20:45:31 -0700 (PDT)
Received: from ?IPV6:2601:444:600:440:ee0c:55dd:b404:79d5? ([2601:444:600:440:ee0c:55dd:b404:79d5])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c1e1b0c444sm1574716173.11.2024.07.15.20.45.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jul 2024 20:45:30 -0700 (PDT)
Message-ID: <f74fb2e6-a457-4bc5-b5b9-97aa93cae565@mbaynton.com>
Date: Mon, 15 Jul 2024 22:45:29 -0500
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Daire Byrne <daire@dneg.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
 <f1ed1b60-273d-4ee6-bbcb-ae3d78486b70@mbaynton.com>
 <CAPt2mGNO_koGozPx68GwowuxDd+CkZWT3Xa7DE-4XCwd9K_RJw@mail.gmail.com>
 <cdbda6fe-ee9c-4437-bbd8-c9104dd2043a@mbaynton.com>
 <CAPt2mGOv3MtRHF5N_tDMXcDN4M4vr=C-YEkE=gd9kEhd6iwtLQ@mail.gmail.com>
Content-Language: en-US
From: Mike Baynton <mike@mbaynton.com>
In-Reply-To: <CAPt2mGOv3MtRHF5N_tDMXcDN4M4vr=C-YEkE=gd9kEhd6iwtLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/24 05:50, Daire Byrne wrote:
> On Sun, 14 Jul 2024 at 05:12, Mike Baynton <mike@mbaynton.com> wrote:
>>
>> On 7/12/24 07:04, Daire Byrne wrote:
>>> Yea, so I have also toyed with the "composefs" idea
>>
>> Yeah, I'm doing what they're doing but making the EROFS in-house and
>> hoping the kinda-writable NFS twist isn't an issue. I only need to
>> satisfy dependencies for a container's worth of software at a time and I
>> can determine all the dependencies I need by virtue of tooling in the
>> software ecosystems I need to support.
> 
> Yea, I need to check out EROFS at some point. But many of our desktop
> kernels are just too old atm.
> 
> Overall the idea of hand crafting metadata-only overlays is compelling
> because you can avoid the complexity (and confusion) of using symlinks
> and it's extremely lightweight (maybe even more so with EROFS).
> 
>>> I guess the difference is that I'm not trying to replicate the
>>> entirety of the metadata, I just want to tweak bits of it and still
>>> avail of the overlay merged directories to fall through to the
>>> directory tree and data underneath for everything else.
>>
>> Yeah I understand your objective now. I'm mildly curious why NFS +
>> fscache doesn't solve the negative lookups case for you given that you
>> want a dynamically generated local cache. Is fscache just unable to
>> cache negative lookups, and you want it to persist for weeks?
> 
> Well, fscache is for caching the data contained in (existing) files
> only right? It makes no attempt to deal with the metadata (e.g.
> directories)?
> 
> Or at least I don't know how effective a disk based cache of metadata
> could be compared to the vfs page cache when you still need to
> revalidate fairly often. I mean it needs to revalidate the file often
> (actimeo?) before it can serve the cached copy so it needs the remote
> metadata lookups?

Yeah never mind my question, I'm not sure if NFS uses fscache to cache
negative lookups, but with long PATHs like you have I think you'd have a
combinatorial explosion of files * paths over long periods and it would
get out of hand.

I've been setting super long actimeo since I know my NFS files "by
design" aren't changing. (We even write them out to locations where the
clients aren't traversing and then rename them.)

> 
> I have seen some talk (David Howells) about giving network filesystems
> like NFS the ability to have "disconnected" access via netfs/fscache
> (ala AFS) but I don't know if that is still on the cards.
> 
> The issue we see is that not only do our batch systems cycle through
> lots of different software versions per hour, but we have many
> thousands of clients doing the same to a single (Netapp) software
> volume. Even if each NFS client managed to cache 80% of the negative
> lookups between runs, the 20% that hits the Netapp is still quite
> significant from many clients.
> 
> And even forgiving the server load implications, a Netapp on the LAN
> (0.2ms) can add delay when you deal with many "pointless" negative
> lookups. I have seen some of our software do 100,000 negative lookups
> across 250 lib dirs, which although on paper should only be 100000 *
> 0.2ms = 20 seconds, actually adds almost a minute to the startup time
> of the software. Certainly when we use a local filesytem overlay the
> time drops by a minute anyway (most likely because the actual file
> opens benefit too). Now if the software only runs for 2 minutes, then
> 1/3 of its time is spent doing negative lookups/path walking at
> startup.
> 
> Yes, I am aware that our software is not well optimised but our build
> system and environment is what it is at this point.
> 
> I have seen many other novel solutions to this general problem - some examples:
> 
> https://guix.gnu.org/en/blog/2021/taming-the-stat-storm-with-a-loader-cache
> https://computing.llnl.gov/projects/spindle
> 
>> Also (only semi-related) since you have a large NFS deployment similar
>> to the one I'm putting together in terms of read-only to normal clients
>> and most files/paths being immutable after they first appear, I'd be
>> interested in any experiences you've had in practice with performance of
>> fscache and NFS mount options that relax its cache coherence / atomicity
>> semantics. I've found it impossible to avoid roundtrips to the server on
>> each fopen for locally cached files (unless using NFS4 delegation which
>> is overkill and not available in my environment.) These RPC roundtrips
>> provide no real benefit to our use case but can add seconds of delay to
>> initializing a process if it accesses thousands of little interpreted
>> language files.
> 
> In my experience actimeo>3600 can help for these kinds of read-only
> filesystems but you probably need "nocto" to really get it down to
> almost no repeat network traffic at all (when cached). Setting
> vm.vfs_cache_pressure=1 might also help keep the nfs inode data in
> memory longer too?
> 
> But nocto will also cache the "ls -l" case whereby you won't see new
> entries. However, if you know a new dir/file is there and access it,
> it will do the new lookup and find it (dirent not in cache yet). That
> might work for your case by the sounds of it?

My issue has been that I can set all the options there are to relax
cache coherency, on a test machine with plenty of memory to cache,
including actimeo and nocto, and I still get some RPCs per open().
Our cloud provider also has worse latency than your 0.2ms.

> 
> I'm not too sure about how that effects opens specifically though. In
> fact, using NFSv3 might be more "relaxed" in this regard than NFSv4?

Brilliant! I had only tried 4.0 and 4.1. I just tried with NFSv3 and can
get down to zero packets over the network easily. Thanks! :)

I think 4.x versions really want you to use delegation, and if you do,
you can get to zero packets over the network for locally cached files,
but if you don't you get an OPEN and CLOSE RPC per file open()ed no
matter what. I don't really want to use delegation because it's an
excessively complex system for "treat this filesystem as read-only." I
fear it would give slow individual client machines too much authority to
 temporarily limit availability to delegated files, and it's not
available in my cloud provider's hosted NFS offering anyway.

> 
> In general, our entire pipeline deals with unique versioned files.
> Apart from home directories, I can't think of many places where we
> overwrite or append to existing files for production workloads or
> reuse file paths in any way.
> 
>> Not an overlayfs concern in any way though so perhaps no need to pollute
>> the mailing list further; if you are interested in responding to me on
>> these things continuing off list would be fine with me too.
>>
>>>> I think Daire and I are basically only adding new files to the NFS
>>>> filesystem, and both the all-opaque approach and the data-only approach
>>>> could prevent accidental access to things on the NFS filesystem through
>>>> the overlayfs (or at least portion of it meant for end-user consumption)
>>>> while they are still being birthed and might be experiencing changes.
>>>> At some point in the NFS tree, directories must be modified, but since
>>>> both approaches have overlayfs sourcing all directory entries from local
>>>> metadata-only layers, it seems plausible that the directories that
>>>> change aren't really "accessed by a overlayfs prior to the change."
>>>
>>> Yes, I think your case has a good chance of being safe and becoming
>>> well defined behaviour.
>>>
>>> But my idea was still very much relying on using the majority of the
>>> lower layer as is. And for all the reasons given, I suspect my use
>>> case is still a no-no.
>>
>> I dunno, your thing might end up working out fine, based on your latest
>> testing of when clients see changes and Amir's observation that all fds
>> need to be closed but then a readdir through an overlayfs will observe
>> changes. Seems "unlikely" that clients would hold open fds to the first
>> few levels of directories at all, never mind for long enough for someone
>> to call you and ask where the new version is :)
> 
> Yea, I think it is probably fine. Maybe another clarification for the
> docs that others might find useful too?
> 
> Daire

