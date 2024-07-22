Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24231396
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jul 2024 03:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721617371; cv=none; b=O6RRWJ/i3PQT1Gu+of6RoKVAcrM4C1L7MLrKgajsQ1ND2DJIXNcdqNz6xubmgcEkDYypJZ96Y6veUvbnP9TK9wNjCEvRmNnFIMVimRDpkusn+tRA/xYoVQPFBQGcMaHgz2Q+9BG+hLg5yznyTbsYXvU8wpc4OR8WdaPCtgII3HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721617371; c=relaxed/simple;
	bh=uXCneuZL54EmeP0m/2Tgj+anP0IQ+W+Ue/pVKJODCFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tC1C5oaJ2wT7UXBEdESfswz9pu8lFlMJDtOou+XDzDyrX4XC2ch0CBJ8gcQ+8JREU579nG1qVRrUsdNopzBhuW/vL5t4V4b/SM88pmrWuAlbUOpY3jH9Z3//G2mR7tdWlXyOO54dtUgcD5bCFZWRPc55P4jLSMCDcKvkQGRT2lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=ZNTBSOTq; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="ZNTBSOTq"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6b7aed340daso21665136d6.3
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jul 2024 20:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1721617368; x=1722222168; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m03/pmKORjTryqN1QZU3mSWSwvRwjHxuHLEyoGU89u8=;
        b=ZNTBSOTqq0zotouZ23CKWLJdn13jmjorrszc4g00M/c2ZoVrWHyVGjNOA+q5mpzytz
         plAGR4NtBo7Sh4DAUsZaYTqbVEWoDsle7ca/42IHyEQZbjgnXliZv1qV/QzjG/39JbnD
         us5gI24sSYgK9zVLNxTriAyQLcIwKdL9rVNkT5RkxxLmawnhxDAk5sSe3QV4oXJQJojR
         ORxh7oVkxmS6ZEbMM8ls603t/kXOIsAbwwEotup+MXd8RqWSde3dZM0XBqqSRo8orMtn
         +Fo2sbnC4OiS7RASFAxuzHg3cMN5nsSNzDPysQwQCe8ZEBjedlsAjQf5TkgXywGD6CPS
         bgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721617368; x=1722222168;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m03/pmKORjTryqN1QZU3mSWSwvRwjHxuHLEyoGU89u8=;
        b=w55EbJi0Hwu2py3Nt40eZ2YhT5BKJRJ4UXIWsQjkb3NWcHRC3ARUlxdaz+Q1lHFktp
         cLBTt6hDexZhEhXiRf6MpX/fjnMHijLB7zDsRYSEN2mSc1yATB456G8MmT2uDY1/AjrC
         eg+GwOHK+vgVhQSWEMjpz1jSLZKD2O6h20yLW6a6gsThCLFKQe8Qu7lbO1LvP6pCyl//
         FijQrn7LYhDvq72jxeQ5VEatO8pauc3jKeuNrpXJ9dMHIU4UiqFdos7D7V/UuRASF9dp
         T/e/t2dqHUszl9nqYgKfvivpz2R+MUeK2YiancYI24+LMilCzQwsXehB1cEoYo7BRKba
         IuFw==
X-Forwarded-Encrypted: i=1; AJvYcCWbXieLz6dWPK4TmKhJHAD+aE6LE/adMj0VIO2GErx6n7wzKdHMqOWVjXKQ5Wn5nEeERuHlo0WkTPh+YP8OrI5TfDnT/wovLrzmI+K2VA==
X-Gm-Message-State: AOJu0Yx47ngYZXlsjeqKlg++5M7ymKtdcTSg08F3CIzmQOS+kWSQFHJd
	9j00LtEG2/GMXYzFVr1QgEqr5RCqun9CTzPCNXvin8PjlQfkNyozLrDfD8ruUec=
X-Google-Smtp-Source: AGHT+IHy3/SFLHVWhhOGNZYNzm/boPvhrmGUX+o8H/s5PtT32aBtMg4P07fEVXamm3IAckpXFghiGw==
X-Received: by 2002:a05:6214:daf:b0:6b9:5bbb:108d with SMTP id 6a1803df08f44-6b96106df01mr84281896d6.5.1721617368529;
        Sun, 21 Jul 2024 20:02:48 -0700 (PDT)
Received: from ?IPV6:2601:444:600:440:7db7:a1c1:739d:e814? ([2601:444:600:440:7db7:a1c1:739d:e814])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b7ac7bd43bsm31346936d6.4.2024.07.21.20.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jul 2024 20:02:47 -0700 (PDT)
Message-ID: <9237a062-4f91-4d32-be19-b7bdd7d71bfe@mbaynton.com>
Date: Sun, 21 Jul 2024 22:02:46 -0500
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>
Cc: Daire Byrne <daire@dneg.com>, linux-unionfs@vger.kernel.org
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
 <f1ed1b60-273d-4ee6-bbcb-ae3d78486b70@mbaynton.com>
 <CAOQ4uxiSm0Le4dYx_R2WPmF9Ut8z6eZinN-qvDrG+Y2GnX11fg@mail.gmail.com>
Content-Language: en-US
From: Mike Baynton <mike@mbaynton.com>
In-Reply-To: <CAOQ4uxiSm0Le4dYx_R2WPmF9Ut8z6eZinN-qvDrG+Y2GnX11fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/12/24 04:09, Amir Goldstein wrote:
> On Fri, Jul 12, 2024 at 6:24 AM Mike Baynton <mike@mbaynton.com> wrote:
>>
>> On 7/11/24 18:30, Amir Goldstein wrote:
>>> On Thu, Jul 11, 2024 at 6:59 PM Daire Byrne <daire@dneg.com> wrote:
>>>> Basically I have a read-only NFS filesystem with software releases
>>>> that are versioned such that no files are ever overwritten or changed.
>>>> New uniquely named directory trees and files are added from time to
>>>> time and older ones are cleaned up.
>>>>
>>>
>>> Sounds like a common use case that many people are interested in.
>>
>> I can vouch that that's accurate, I'm doing nearly the same thing. The
>> properties of the NFS filesystem in terms of what is and is not expected
>> to change is identical for me, though my approach to incorporating
>> overlayfs has been a little different.
>>
>> My confidence in the reliability of what I'm doing is still far from
>> absolute, so I will be interested in efforts to validate/officially
>> sanction/support/document related techniques.
>>
>> The way I am doing it is with NFS as a data-only layer. Basically my use
>> case calls for presenting different views of NFS-backed data (it's
>> software libraries) to different applications. No application wants or
>> needs to have the entire NFS tree exposed to it, but each application
>> wants to use some data available on NFS and wants it to be presented in
>> some particular local place. So I actually wanted a method where I
>> author a metadata-only layer external to overlayfs, built to spec.
>>
>> Essentially it's making overlayfs redirects be my symlinks so that code
>> which doesn't follow symlinks or is otherwise influenced by them is none
>> the wiser.
>>
> 
> Nice.
> I've always wished that data-only would not be an "offline-only" feature,
> but getting the official API for that scheme right might be a challenge.
> 
>>>> My first question is how bad can the "undefined behaviour" be in this
>>>> kind of setup?
>>>
>>> The behavior is "undefined" because nobody tried to define it,
>>> document it and test it.
>>> I don't think it would be that "bad", but it will be unpredictable
>>> and is not very nice for a software product.
>>>
>>> One of the current problems is that overlayfs uses readdir cache
>>> the readdir cache is not auto invalidated when lower dir changes
>>> so whether or not new subdirs are observed in overlay depends
>>> on whether the merged overlay directory is kept in cache or not.
>>>
>>
>> My approach doesn't support adding new files from the data-only NFS
>> layer after the overlayfs is created, of course, since the metadata-only
>> layer is itself the first lower layer and so would presumably get into
>> undefined-land if added to. But this arrangement does probably
>> mitigate this problem. Creating metadata inodes of a fixed set of
>> libraries for a specific application is cheap enough (and considerably
>> faster than copying it all locally) that the immutablity limitation
>> works for me.
>>
> 
> Assuming that this "effectively-data-only" NFS layer is never iterated via
> overlayfs then adding new unreferenced objects to this layer should not
> be a problem either.
> 
>>>> Any files that get copied up to the upper layer are
>>>> guaranteed to never change in the lower NFS filesystem (by it's
>>>> design), but new directories and files that have not yet been copied
>>>> up, can randomly appear over time. Deletions are not so important
>>>> because if it has been deleted in the lower level, then the upper
>>>> level copy failing has similar results (but we should cleanup the
>>>> upper layer too).
>>>>
>>>> If it's possible to get over this first difficult hurdle, then I have
>>>> another extra bit of complexity to throw on top - now manually make an
>>>> entire directory tree (of metdata) that we have recursively copied up
>>>> "opaque" in the upper layer (currently needs to be done outside of
>>>> overlayfs). Over time or dropping of caches, I have found that this
>>>> (seamlessly?) takes effect for new lookups.
>>>>
>>>> I also noticed that in the current implementation, this "opaque"
>>>> transition actual breaks access to the file because the metadata
>>>> copy-up sets "trusted.overlay.metacopy" but does not currently add an
>>>> explicit "trusted.overlay.redirect" to the correspnding lower layer
>>>> file. But if it did (or we do it manually with setfattr), then it is
>>>> possible to have an upper level directory that is opaque, contains
>>>> file metadata only and redirects to the data to the real files on the
>>>> lower NFS filesystem.
>>
>> So once you use opaque dirs and redirects on an upper layer, it's
>> sounding very similar to redirects into a data-only layer. In either
>> case you're responsible for producing metadata inodes for each NFS file
>> you want presented to the application/user.
>>
> 
> Yes, it is almost the same as data-only layer.
> The only difference is that real data-only layer can never be accessed
> directly from overlay, while the effectively-data-only layer must have
> some path (e.g /blobs) accessible directly from overlay in order to do
> online rename of blobs into the upper opaque layer.
> 
>> This way seems interesting and more promising for adding NFS-backed
>> files "online" though.
>>
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
> 
> Yes, what overlay did not observe, overlay cannot know about.
> But the devil is in the details, such as what is an "accessed
> filesystem object".
> 
> In our case study, we refer to the newly added directory entries
> and new inodes "never accessed by overlayfs", so it sounds
> safe to add them while overlayfs is mounted, but their parent directory,
> even if never iterated via overlayfs was indeed accessed by overlayfs
> (when looking up for existing siblings), so overlayfs did access
> the lower parent directory and it does reference the lower parent
> directory dentry/inode, so it is still not "intuitively" safe to change it.
> 
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
>>
>> How much proving/testing would you want to see before documenting this
>> and supporting someone in future who finds a way to prove the claim
>> wrong?
>>
> 
> *very* good question :)
> 
> For testing, an xfstest will do - you can fork one of the existing
> data-only tests as a template.

Due to the extended delay in a substantive response, I just wanted to
send a quick thank you for your reply and suggestions here. I am still
interested in pursuing this, but I have been busy and then recovering
from illness.

I'll need to study how xfstest directly exercises overlayfs and how it
is combined with unionmount-testsuite I think.

> 
> For documentation, I think it is too hard to commit to the general
> statement above.
> 
> Try to narrow the exception to the rule to the very specific use case
> of "append-only" instead of "immutable" lower directory and then
> state that the behavior is "defined" - the new entries are either visible
> by overlayfs or they are not visible, and the "undefined" element
> is *when* they become visible and via which API (*).
> 
> (*) New entries may be visible to lookup and invisible to readdir
>      due to overlayfs readdir cache, and entries could be visible to
>      readdir and invisible to lookup, due to vfs negative lookup cache.
> 
> Note that the behavior of POSIX readdir() for entries added while
> an open dir fd is being iterated is similar - the new entries will either
> be visible in the iteration of that fd or they won't be, but there is
> a clear "barrier" when the new entries will become visible
> (on seek to start or open of new fd)>
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
> 
> Feel free to post this patch if you find it useful.
> The commit message should say that the mount option
> check does not reflect the actual dependency in the code,
> and it should also explain very well why this mount option combination
> is desired and lore Link: to this conversation.
> 
> Thanks,
> Amir.

