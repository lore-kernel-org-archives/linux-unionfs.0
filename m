From: L A Walsh <lkml@tlinx.org>
Subject: Re: Bug? or normal behavior? if bug, then where? overlay, vfs, xfs,
 or ????
Date: Thu, 02 Nov 2017 14:57:48 -0700
Message-ID: <59FB94DC.3000501@tlinx.org>
References: <59FA4499.2030502@tlinx.org> <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:41400 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934407AbdKBV5w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 17:57:52 -0400
In-Reply-To: <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

Amir Goldstein wrote:
>
> Whiteout certainly shouldn't appear that way.
>   
(thank goodness!)

> The reason it does is that your upper fs does not support
> "d_type" (see below).
> It's a "known" issue, but don't know where/if it is documented.
>
> I expect if you look in dmesg, you will see this warning:
>   "overlayfs: upper fs needs to support d_type."
>   
----
    Yup...found that.
> We also do not check for lower fs d_type support.
> That can also expose old whiteouts in certain setups.
>   
----  
    *ouch*.   I wonder if d_type can be set for existing file systems.
I easily have some file systems that date back more than a few years.


>> I then created a new xfs file system and mounted it on '/edge';
>>
>>    Ishtar:/edge> xfs_info ....
>>    naming   =version 2          bsize=4096   ascii-ci=0
>>     
>
> Your problem is that you do not have "ftype" feature in directory
> name format, like this:
>
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>   
---
    My mkfs.xfs is a few (3) years old.
> Perhaps you have an old version of mkfs.xfs, not sure when
> ftype=1 became the default format, but you can try to
>   mkfs.xfs -n ftype=1
> and follow the breadcrumbs from there.
>
> ...
>   
>> BTW -- is the setup in that bug report even "valid"? I.e. using
>> the same single-underlying file system for all 4 directories?
>>
>>     
>
> Yes. Actually your setup uses 2 different file system instances
> for lower and upper, which is fine, but it is perfectly valid, quite
> common and even has some advantages to use upper/lower
> on the same underlying filesystem instance.
>   
----
    I was referring to the RH bug report where they had created
everything on 1 FS.  I wondered about upper+lower overlap problems
on the same fs.  I'd think that could get a bit tangled

Thanks... will look for a newer mkfs.xfs.
