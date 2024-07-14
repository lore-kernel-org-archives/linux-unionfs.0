Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8F4DF4D
	for <linux-unionfs@vger.kernel.org>; Sun, 14 Jul 2024 04:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720930378; cv=none; b=IWDCkL1uuthZdSq5QGivec3HQH8aWPdbIE+52sU3j2L2vXoWJw2fugJstePcOdqd+QbLhpXvVVO5y2F+aOpQiMVvd5mGCSaU5ypazy6w2ZNsJXs5O02XXI9gYRbwBoF3eztw73+PMvOE3krK4HkLK7Sb3EFadpsdbhCMPFjzYGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720930378; c=relaxed/simple;
	bh=+gYfwTcoriA1XEpriagJ3gzW+i8crH7nHY+yHPID1Z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pnkDUiSxlm8sSm1n25YZ8dYdKLuMBZIqXTxWNYtT+8+usX4ExtQaHZMmvpJV5Yff3jiLSpsyGp+u/pI7adz2kw+kaGA3Bvkgz+Yb12sKS9Yn3xgTBm1a+ZvNLIzmqW1uzAOql6sf+txYaJrrDsEgiAMrbxZzt5Stxbn/Dm4vXfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=EL5BV7Kn; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="EL5BV7Kn"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7f6e9662880so148886239f.2
        for <linux-unionfs@vger.kernel.org>; Sat, 13 Jul 2024 21:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1720930376; x=1721535176; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dhPtFt3IkvlciF17uP81WyX6Ja0Upg9M2X89NPkGTb4=;
        b=EL5BV7KnTyqQ94+d8SS+vNZQ64/CbiZrybwPJmxG+jLLmKFFEHr0DphOCinekeiQ2C
         1MFBtLhjTWnkcIXXl3+5Xu/sRHZZG1wY1tNHdf5LzNWGGSZeA/MQV2RYA8VKn92CtHIM
         15oZQO8hHnnWtNKmGp4rZVJNKg0YPGuDuQ+8WWe6+8NU0uYm3t/rjyHPjRF8d/pzhaKg
         KSkRfLIvhWBfTTW0xxAqzM++tK7flyWPLMUzWUZFDoXTwKYY3GRdkyHfWDiTLCeZI4d2
         EPHaIQfToi9q9634ErGH1CNUWn+rwOIPE6KeJXTEXmM5DLUO0e+8/mbaijwTBI9eb4nA
         TAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720930376; x=1721535176;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dhPtFt3IkvlciF17uP81WyX6Ja0Upg9M2X89NPkGTb4=;
        b=dNfemZrL5McNnF6oYsPuPtnFhOZUD7YHxwUkSL2QU9KQzR6jazcERflOdMHU+8qVjz
         MpgGFrA68/i3Ka3noGwOcIXgYI7fyXsivaDTIMfQShHHQ4x6eY1k0X5BW1s9QQ5vA25C
         yokwppwb9H2yG397G34jxlmqq5JLNx+c+h5V+f7SfFcjEuBZp3zUFS4ulafSN2KKmQEA
         VSR5kTBB3mFKEJDeNqx2wW++FOli/kx5+vwv3Bam/FAvLIN7qBV6cDhh8YQOvvzrc/Ef
         ZieLpmfPqAY8Nddrv2HB5FlsH9OddISdT3Aps1JNxyKZn0VgZ1odL7JQptk7gp22Uw6i
         5j/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5d5OzX+5XvPnRoWOWIzeX7uu/vuEfDKNoXIHjfyPQkz8g8FvEtfRJNRJ3QnoE7D1AaDoZNtjSSmyNpX5ZrDIOaFF+Km354d7ab05GVg==
X-Gm-Message-State: AOJu0YwVEWmrCgAmrGz1swWU0KxHEqM5vHdgehm+UBADd71exVdlYuEy
	v9Wo44hhtQz6Gnx/ZoNGq8ieoIgso5ipMiWFUotIGGRRrfDIcDrAF+ThAtb7ZH0=
X-Google-Smtp-Source: AGHT+IHnSSd60WeTgHdgpTLqQERoFsBhglqWxIz2NLTiZjKiY/MN7t+ytsmQiWb811OoyAXbV3xmCQ==
X-Received: by 2002:a6b:5c07:0:b0:7fc:a65:c734 with SMTP id ca18e2360f4ac-80004173bcamr1603504339f.19.1720930375670;
        Sat, 13 Jul 2024 21:12:55 -0700 (PDT)
Received: from ?IPV6:2601:444:600:440:644a:df89:617:427f? ([2601:444:600:440:644a:df89:617:427f])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c1e1b0b95fsm619646173.27.2024.07.13.21.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jul 2024 21:12:54 -0700 (PDT)
Message-ID: <cdbda6fe-ee9c-4437-bbd8-c9104dd2043a@mbaynton.com>
Date: Sat, 13 Jul 2024 23:12:52 -0500
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
Content-Language: en-US
From: Mike Baynton <mike@mbaynton.com>
In-Reply-To: <CAPt2mGNO_koGozPx68GwowuxDd+CkZWT3Xa7DE-4XCwd9K_RJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/12/24 07:04, Daire Byrne wrote:
> Yea, so I have also toyed with the "composefs" idea

Yeah, I'm doing what they're doing but making the EROFS in-house and
hoping the kinda-writable NFS twist isn't an issue. I only need to
satisfy dependencies for a container's worth of software at a time and I
can determine all the dependencies I need by virtue of tooling in the
software ecosystems I need to support.

> I guess the difference is that I'm not trying to replicate the
> entirety of the metadata, I just want to tweak bits of it and still
> avail of the overlay merged directories to fall through to the
> directory tree and data underneath for everything else.

Yeah I understand your objective now. I'm mildly curious why NFS +
fscache doesn't solve the negative lookups case for you given that you
want a dynamically generated local cache. Is fscache just unable to
cache negative lookups, and you want it to persist for weeks?

Also (only semi-related) since you have a large NFS deployment similar
to the one I'm putting together in terms of read-only to normal clients
and most files/paths being immutable after they first appear, I'd be
interested in any experiences you've had in practice with performance of
fscache and NFS mount options that relax its cache coherence / atomicity
semantics. I've found it impossible to avoid roundtrips to the server on
each fopen for locally cached files (unless using NFS4 delegation which
is overkill and not available in my environment.) These RPC roundtrips
provide no real benefit to our use case but can add seconds of delay to
initializing a process if it accesses thousands of little interpreted
language files.

Not an overlayfs concern in any way though so perhaps no need to pollute
the mailing list further; if you are interested in responding to me on
these things continuing off list would be fine with me too.

> 
>>> how can we document it to make the behavior "defined"?
>>>
>>> My thinking is:
>>>
>>> "Changes to the underlying filesystems while part of a mounted overlay
>>> filesystem are not allowed.  If the underlying filesystem is changed,
>>> the behavior of the overlay is undefined, though it will not result in
>>> a crash or deadlock.
>>>
>>> One exception to this rule is changes to underlying filesystem objects
>>> that were not accessed by a overlayfs prior to the change.
>>> In other words, once accessed from a mounted overlay filesystem,
>>> changes to the underlying filesystem objects are not allowed."
>>>
>>> But this claim needs to be proved and tested (write tests),
>>> before the documentation defines this behavior.
>>> I am not even sure if the claim is correct.
>>
>> I've been blissfully and naively assuming that it is based on intuition
>> :).
>>
>> I think Daire and I are basically only adding new files to the NFS
>> filesystem, and both the all-opaque approach and the data-only approach
>> could prevent accidental access to things on the NFS filesystem through
>> the overlayfs (or at least portion of it meant for end-user consumption)
>> while they are still being birthed and might be experiencing changes.
>> At some point in the NFS tree, directories must be modified, but since
>> both approaches have overlayfs sourcing all directory entries from local
>> metadata-only layers, it seems plausible that the directories that
>> change aren't really "accessed by a overlayfs prior to the change."
> 
> Yes, I think your case has a good chance of being safe and becoming
> well defined behaviour.
> 
> But my idea was still very much relying on using the majority of the
> lower layer as is. And for all the reasons given, I suspect my use
> case is still a no-no.

I dunno, your thing might end up working out fine, based on your latest
testing of when clients see changes and Amir's observation that all fds
need to be closed but then a readdir through an overlayfs will observe
changes. Seems "unlikely" that clients would hold open fds to the first
few levels of directories at all, never mind for long enough for someone
to call you and ask where the new version is :)

Mike

> 
>> How much proving/testing would you want to see before documenting this
>> and supporting someone in future who finds a way to prove the claim
>> wrong?
>>
>>>
>>> One more thing that could help said service is if overlayfs
>>> supported a hybrid mode of redirect_dir=follow,metacopy=on,
>>> where redirect is enabled for regular files for metacopy, but NOT
>>> enabled for directories (which was redirect_dir original use case).
>>>
>>> This way, the service could run the command line:
>>> $ mv /ovl/blah/thing /ovl/local
>>> then "mv" will get EXDEV for moving directories and will create
>>> opaque directories in their place and it will recursively move all
>>> the files to the opaque directories.
>>
>> Clever.
>>
>> Thanks,
>> Mike
> 
> Thanks for the support! Certainly creating metadata only layers with
> data layers is something I have considered. But for many of the same
> reasons that we cannot compress all our PATHs to a single directory
> full of symlinks, I'm not sure I will be able to construct a concise
> metadata only layer without a much deeper understanding of how our
> devs are building and deploying software. And I'm not sure I have the
> mental fortitude for that journey :)
> 
> Daire
