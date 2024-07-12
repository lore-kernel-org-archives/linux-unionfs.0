Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA6611CAF
	for <linux-unionfs@vger.kernel.org>; Fri, 12 Jul 2024 03:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720754699; cv=none; b=ZLVjMtLGnqAwnDzJCEJyEbPCw+GLcnlV2hqiikoRYrFaXz6MdiFe4NRv6fWIGt6P1dI8OL+F97d4lLov2TAsoCVoiFxRgqX5Ro6z5nKcwTn38pYdZpQ6+8RdgvjN2N3ALuh2x/oSJ+4w57VwKn0ow3KFd5zBODZEO51tlcOmj+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720754699; c=relaxed/simple;
	bh=wQsSufy/V6DZRZBnx4wXK66gEzNfMtE5ezWqJgNMuYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LWGCmmjdeZLjgokxikFw6mdYT8hxdQwhCuUwO9yKqfo04adCjnBcU2WlHkN6Q4F2Z9YPep+SgT5EOdnurWTFBXPUtdKDE4l8rxXijI9kGphm86LUt2lusOMDKnAMrCzlj37cPIjeIVOb9rOvj5vedbuKANH+nE+BqYEhHMLnZUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=wUXHTYmv; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="wUXHTYmv"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8076fb141f1so42179039f.3
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Jul 2024 20:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1720754697; x=1721359497; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ublWKd2iG4KvQvGov5BwmB6QqXIkyhO4C61mkj4h/n8=;
        b=wUXHTYmvwXX14MmnIFWFFK1iMPdbpIQDpH7CWE6UV4dLhZJPcM6NmGH/gZdyUw53T5
         rJPOb8jzHKKqXZx5L8IxzhVd7CYc81dFywu8u4cS79S3B5VhzXGdAuGHOXwyohkiyKiX
         AtiADn50TeVi8j4gzREfv9SAAL3mlIlp08MDNO40TY5kPbyV9ToRA1GaFrWROLxJy+96
         U+M6++BhH2oeCfBa9bfu+yunDzkK/eyF7XnMjX9ryywKtsnTqGfQ+qBvIbERbGvmaWSC
         L2Zw4l8RUPtJ3o3rkIfYfTpheZPeRT4hb1Vq7dqVYJp8ewljvmcG8FIQ5azAqLv7RWlP
         NFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720754697; x=1721359497;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ublWKd2iG4KvQvGov5BwmB6QqXIkyhO4C61mkj4h/n8=;
        b=GOxq2X0H64dZ3Jg7/BhZgXILRJRAP8T6kY8BHfFd1JnPJCPbCdR8zEv0WVXHKOoeoZ
         /S9GLLqm0yHMZtRDaw2WmNy6nIaI3uplGyQfDXUGvVbSAfloL93a2JmLZgpJZ+C2Pe1w
         7JzfBJ5HeFE50YoosHHmBlpR7grDt/BjyMcNBilv9dZNhDEskYSB6mcdEav2JmGNXI9b
         ongxcc/Nog7ez/pZOuJnf9CJdz1apIdzWa8HFG1jaGFprpWNrs+rQI6vkQcZar0XvAtC
         rCF9WbYFXvpo22MqDFW+sMs/lw2HHlyfVAdTRsWYrmkNuy0Ur0BxUUSpA7O9JTfWLgT/
         fZZw==
X-Gm-Message-State: AOJu0YwtV98ratsLg4HBh0cbDx+F8DqpCQj2so70q7TNNZ3P1eCLZFA8
	s/L5Z7peRJvE1xBTXSk/Fi4JJbRA3ofqPBJ2fCi5HIpd7P02fyRwPK3eCTc4xYgbpzQgOhzAGcj
	6HQw=
X-Google-Smtp-Source: AGHT+IH3QiIcOdNqIN36m9pd4qgvCQlK4SNhqXTTH9Gs7HVHJNx4BTmDLH84n7bsht/7mYTwZOmdzw==
X-Received: by 2002:a6b:f102:0:b0:7ff:cec0:2985 with SMTP id ca18e2360f4ac-8000330aa5bmr1204012839f.13.1720754696697;
        Thu, 11 Jul 2024 20:24:56 -0700 (PDT)
Received: from ?IPV6:2601:444:600:440:2f0f:eed6:6985:5e0e? ([2601:444:600:440:2f0f:eed6:6985:5e0e])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7ffe9accc19sm223321239f.20.2024.07.11.20.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jul 2024 20:24:56 -0700 (PDT)
Message-ID: <f1ed1b60-273d-4ee6-bbcb-ae3d78486b70@mbaynton.com>
Date: Thu, 11 Jul 2024 22:24:54 -0500
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>, Daire Byrne <daire@dneg.com>
Cc: linux-unionfs@vger.kernel.org
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
Content-Language: en-US
From: Mike Baynton <mike@mbaynton.com>
In-Reply-To: <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/11/24 18:30, Amir Goldstein wrote:
> On Thu, Jul 11, 2024 at 6:59 PM Daire Byrne <daire@dneg.com> wrote:
>> Basically I have a read-only NFS filesystem with software releases
>> that are versioned such that no files are ever overwritten or changed.
>> New uniquely named directory trees and files are added from time to
>> time and older ones are cleaned up.
>>
> 
> Sounds like a common use case that many people are interested in.

I can vouch that that's accurate, I'm doing nearly the same thing. The
properties of the NFS filesystem in terms of what is and is not expected
to change is identical for me, though my approach to incorporating
overlayfs has been a little different.

My confidence in the reliability of what I'm doing is still far from
absolute, so I will be interested in efforts to validate/officially
sanction/support/document related techniques.

The way I am doing it is with NFS as a data-only layer. Basically my use
case calls for presenting different views of NFS-backed data (it's
software libraries) to different applications. No application wants or
needs to have the entire NFS tree exposed to it, but each application
wants to use some data available on NFS and wants it to be presented in
some particular local place. So I actually wanted a method where I
author a metadata-only layer external to overlayfs, built to spec.

Essentially it's making overlayfs redirects be my symlinks so that code
which doesn't follow symlinks or is otherwise influenced by them is none
the wiser.

>> My first question is how bad can the "undefined behaviour" be in this
>> kind of setup?
> 
> The behavior is "undefined" because nobody tried to define it,
> document it and test it.
> I don't think it would be that "bad", but it will be unpredictable
> and is not very nice for a software product.
> 
> One of the current problems is that overlayfs uses readdir cache
> the readdir cache is not auto invalidated when lower dir changes
> so whether or not new subdirs are observed in overlay depends
> on whether the merged overlay directory is kept in cache or not.
>

My approach doesn't support adding new files from the data-only NFS
layer after the overlayfs is created, of course, since the metadata-only
layer is itself the first lower layer and so would presumably get into
undefined-land if added to. But this arrangement does probably
mitigate this problem. Creating metadata inodes of a fixed set of
libraries for a specific application is cheap enough (and considerably
faster than copying it all locally) that the immutablity limitation
works for me.

>> Any files that get copied up to the upper layer are
>> guaranteed to never change in the lower NFS filesystem (by it's
>> design), but new directories and files that have not yet been copied
>> up, can randomly appear over time. Deletions are not so important
>> because if it has been deleted in the lower level, then the upper
>> level copy failing has similar results (but we should cleanup the
>> upper layer too).
>>
>> If it's possible to get over this first difficult hurdle, then I have
>> another extra bit of complexity to throw on top - now manually make an
>> entire directory tree (of metdata) that we have recursively copied up
>> "opaque" in the upper layer (currently needs to be done outside of
>> overlayfs). Over time or dropping of caches, I have found that this
>> (seamlessly?) takes effect for new lookups.
>>
>> I also noticed that in the current implementation, this "opaque"
>> transition actual breaks access to the file because the metadata
>> copy-up sets "trusted.overlay.metacopy" but does not currently add an
>> explicit "trusted.overlay.redirect" to the correspnding lower layer
>> file. But if it did (or we do it manually with setfattr), then it is
>> possible to have an upper level directory that is opaque, contains
>> file metadata only and redirects to the data to the real files on the
>> lower NFS filesystem.

So once you use opaque dirs and redirects on an upper layer, it's
sounding very similar to redirects into a data-only layer. In either
case you're responsible for producing metadata inodes for each NFS file
you want presented to the application/user.

This way seems interesting and more promising for adding NFS-backed
files "online" though.

> how can we document it to make the behavior "defined"?
> 
> My thinking is:
> 
> "Changes to the underlying filesystems while part of a mounted overlay
> filesystem are not allowed.  If the underlying filesystem is changed,
> the behavior of the overlay is undefined, though it will not result in
> a crash or deadlock.
> 
> One exception to this rule is changes to underlying filesystem objects
> that were not accessed by a overlayfs prior to the change.
> In other words, once accessed from a mounted overlay filesystem,
> changes to the underlying filesystem objects are not allowed."
> 
> But this claim needs to be proved and tested (write tests),
> before the documentation defines this behavior.
> I am not even sure if the claim is correct.

I've been blissfully and naively assuming that it is based on intuition
:).

I think Daire and I are basically only adding new files to the NFS
filesystem, and both the all-opaque approach and the data-only approach
could prevent accidental access to things on the NFS filesystem through
the overlayfs (or at least portion of it meant for end-user consumption)
while they are still being birthed and might be experiencing changes.
At some point in the NFS tree, directories must be modified, but since
both approaches have overlayfs sourcing all directory entries from local
metadata-only layers, it seems plausible that the directories that
change aren't really "accessed by a overlayfs prior to the change."

How much proving/testing would you want to see before documenting this
and supporting someone in future who finds a way to prove the claim
wrong?

> 
> One more thing that could help said service is if overlayfs
> supported a hybrid mode of redirect_dir=follow,metacopy=on,
> where redirect is enabled for regular files for metacopy, but NOT
> enabled for directories (which was redirect_dir original use case).
> 
> This way, the service could run the command line:
> $ mv /ovl/blah/thing /ovl/local
> then "mv" will get EXDEV for moving directories and will create
> opaque directories in their place and it will recursively move all
> the files to the opaque directories.

Clever.

Thanks,
Mike
