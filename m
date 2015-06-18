From: Jan Olszak <j.olszak@samsung.com>
Subject: Re: Optional switching off cow in overlayfs
Date: Thu, 18 Jun 2015 16:43:03 +0200
Message-ID: <5582D8F7.1060700@samsung.com>
References: <5582C6C1.8080602@samsung.com>
 <13405.1434634748@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51400 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbFROnH (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 10:43:07 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQ5006SPA7TDY40@mailout1.w1.samsung.com> for
 linux-unionfs@vger.kernel.org; Thu, 18 Jun 2015 15:43:05 +0100 (BST)
In-reply-to: <13405.1434634748@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org



On 06/18/2015 03:39 PM, David Howells wrote:
> Jan Olszak <j.olszak@samsung.com> wrote:
>
>> I was wondering about a small improvement to overlayfs - optional, per file
>> copy of write.
>>
>> 1. By default overlayfs would work as usual.
>> 2. If a file in 'lower' filesystem has an xattr set
>> (e.g. trusted.overlay.cow=n) the file would not be copied.
>>
>> What do you think?
> Ummm.  What's the use case?  How do you handle the file being part of multiple
> overlays?
>
> David
>

I wan't to achieve 'files' granularity in overlayfs instead of 
'directory' granularity.
It would be useful in Linux containers configuration. Sometimes you 
don't have the
power to change the images that are run inside containers and in one 
folder you have both:
- files that have to be copied
- files that don't really need to be copied


trusted.overlay.cow==n indicates switching off copying the file to the 
upper layer.
So with multiple overlays you would always have only one file from the 
lower-most dir.

Jan
