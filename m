From: Jan Olszak <j.olszak@samsung.com>
Subject: Re: Optional switching off cow in overlayfs
Date: Mon, 22 Jun 2015 15:45:18 +0200
Message-ID: <5588116E.20509@samsung.com>
References: <5582C6C1.8080602@samsung.com>
 <13405.1434634748@warthog.procyon.org.uk> <5582D8F7.1060700@samsung.com>
 <CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39550 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933400AbbFVNpW (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 22 Jun 2015 09:45:22 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQC00EFVM7JBP80@mailout1.w1.samsung.com> for
 linux-unionfs@vger.kernel.org; Mon, 22 Jun 2015 14:45:19 +0100 (BST)
In-reply-to: <CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On 06/22/2015 01:32 PM, Miklos Szeredi wrote:
> On Thu, Jun 18, 2015 at 4:43 PM, Jan Olszak <j.olszak@samsung.com> wrote:
>>
>> On 06/18/2015 03:39 PM, David Howells wrote:
>>> Jan Olszak <j.olszak@samsung.com> wrote:
>>>
>>>> I was wondering about a small improvement to overlayfs - optional, per
>>>> file
>>>> copy of write.
>>>>
>>>> 1. By default overlayfs would work as usual.
>>>> 2. If a file in 'lower' filesystem has an xattr set
>>>> (e.g. trusted.overlay.cow=n) the file would not be copied.
>>>>
>>>> What do you think?
>>> Ummm.  What's the use case?  How do you handle the file being part of
>>> multiple
>>> overlays?
>>>
>>> David
>>>
>> I wan't to achieve 'files' granularity in overlayfs instead of 'directory'
>> granularity.
>> It would be useful in Linux containers configuration. Sometimes you don't
>> have the
>> power to change the images that are run inside containers and in one folder
>> you have both:
>> - files that have to be copied
>> - files that don't really need to be copied
>>
>>
>> trusted.overlay.cow==n indicates switching off copying the file to the upper
>> layer.
>> So with multiple overlays you would always have only one file from the
>> lower-most dir.
> What type filesystem is the lowest layer?   Can you set immutable on
> it (chattr +i)?  That would be the logical way to say "nobody can
> modify this file, not even root".
>
> Thanks,
> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
>

The lower fs is most likely ext4.
Unfortunately making a file immutable won't solve the problem. There's 
nothing wrong in modifying the file and it should stay possible.

I just want to switch off copy on write for some files. Can you see 
another way?

If you are OK with the optional xattr, then I'll prepare the patch.


Thanks,
Jan
