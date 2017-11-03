From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Bug? or normal behavior? if bug, then where? overlay, vfs, xfs,
 or ????
Date: Fri, 3 Nov 2017 08:45:23 +0200
Message-ID: <CAOQ4uxiQzPDGNBhYtiYW8qcbG8=0e_Mwkjb_Vuj-Kh=Jds42bQ@mail.gmail.com>
References: <59FA4499.2030502@tlinx.org> <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com>
 <59FB94DC.3000501@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:48700 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbdKCGpY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Nov 2017 02:45:24 -0400
Received: by mail-yw0-f170.google.com with SMTP id q1so1623367ywh.5
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Nov 2017 23:45:24 -0700 (PDT)
In-Reply-To: <59FB94DC.3000501@tlinx.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: L A Walsh <lkml@tlinx.org>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Nov 2, 2017 at 11:57 PM, L A Walsh <lkml@tlinx.org> wrote:
> Amir Goldstein wrote:
>>
>>
>> Whiteout certainly shouldn't appear that way.
>>
>
> (thank goodness!)
>
>> The reason it does is that your upper fs does not support
>> "d_type" (see below).
>> It's a "known" issue, but don't know where/if it is documented.
>>
>> I expect if you look in dmesg, you will see this warning:
>>   "overlayfs: upper fs needs to support d_type."
>>
>
> ----
>    Yup...found that.
>>
>> We also do not check for lower fs d_type support.
>> That can also expose old whiteouts in certain setups.
>>
>
> ----     *ouch*.   I wonder if d_type can be set for existing file systems.
> I easily have some file systems that date back more than a few years.
>

Don't think you need to worry about that.
The corner case where d_type matters on lower fs are probably not relevant
for your use case.
It only matters if you are using a directory that was once an upper layer
as a lower layer (i.e. stacking of layers) and that layer already has whiteouts
in it.

...

>>
>>>
>>> BTW -- is the setup in that bug report even "valid"? I.e. using
>>> the same single-underlying file system for all 4 directories?
>>>
>>>
>>
>>
>> Yes. Actually your setup uses 2 different file system instances
>> for lower and upper, which is fine, but it is perfectly valid, quite
>> common and even has some advantages to use upper/lower
>> on the same underlying filesystem instance.
>>
>
> ----
>    I was referring to the RH bug report where they had created
> everything on 1 FS.

Doesn't matter to the issue at hand.
Bug happens when upper fs has no d_type support regardless
of lower fs is the same or not.

> I wondered about upper+lower overlap problems
> on the same fs.  I'd think that could get a bit tangled
>

Not sure what exactly you are referring to, but if you are
thinking about using lower/upper directories that overlap -
don't!
Overlayfs will not prevent you from shooting your own foot.

Amir.
