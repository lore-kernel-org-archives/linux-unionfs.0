From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Optional switching off cow in overlayfs
Date: Mon, 22 Jun 2015 13:32:09 +0200
Message-ID: <CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com>
References: <5582C6C1.8080602@samsung.com>
	<13405.1434634748@warthog.procyon.org.uk>
	<5582D8F7.1060700@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:33440 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258AbbFVLcK (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 22 Jun 2015 07:32:10 -0400
Received: by qged89 with SMTP id d89so51433409qge.0
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jun 2015 04:32:10 -0700 (PDT)
In-Reply-To: <5582D8F7.1060700@samsung.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Olszak <j.olszak@samsung.com>
Cc: David Howells <dhowells@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jun 18, 2015 at 4:43 PM, Jan Olszak <j.olszak@samsung.com> wrote:
>
>
> On 06/18/2015 03:39 PM, David Howells wrote:
>>
>> Jan Olszak <j.olszak@samsung.com> wrote:
>>
>>> I was wondering about a small improvement to overlayfs - optional, per
>>> file
>>> copy of write.
>>>
>>> 1. By default overlayfs would work as usual.
>>> 2. If a file in 'lower' filesystem has an xattr set
>>> (e.g. trusted.overlay.cow=n) the file would not be copied.
>>>
>>> What do you think?
>>
>> Ummm.  What's the use case?  How do you handle the file being part of
>> multiple
>> overlays?
>>
>> David
>>
>
> I wan't to achieve 'files' granularity in overlayfs instead of 'directory'
> granularity.
> It would be useful in Linux containers configuration. Sometimes you don't
> have the
> power to change the images that are run inside containers and in one folder
> you have both:
> - files that have to be copied
> - files that don't really need to be copied
>
>
> trusted.overlay.cow==n indicates switching off copying the file to the upper
> layer.
> So with multiple overlays you would always have only one file from the
> lower-most dir.

What type filesystem is the lowest layer?   Can you set immutable on
it (chattr +i)?  That would be the logical way to say "nobody can
modify this file, not even root".

Thanks,
Miklos
