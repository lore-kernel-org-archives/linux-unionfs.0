From: Jan Olszak <j.olszak@samsung.com>
Subject: Re: Optional switching off cow in overlayfs
Date: Mon, 22 Jun 2015 16:26:50 +0200
Message-ID: <55881B2A.7090106@samsung.com>
References: <5582C6C1.8080602@samsung.com>
 <13405.1434634748@warthog.procyon.org.uk> <5582D8F7.1060700@samsung.com>
 <CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com>
 <5588116E.20509@samsung.com>
 <CAJfpegsVqzVhq8BjCwqA+6dEZey0aNb4amnnOT_JVDfzki9v1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42211 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbbFVO0y (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 22 Jun 2015 10:26:54 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQC00HFXO4RN990@mailout2.w1.samsung.com> for
 linux-unionfs@vger.kernel.org; Mon, 22 Jun 2015 15:26:51 +0100 (BST)
In-reply-to: <CAJfpegsVqzVhq8BjCwqA+6dEZey0aNb4amnnOT_JVDfzki9v1g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On 06/22/2015 03:53 PM, Miklos Szeredi wrote:
> On Mon, Jun 22, 2015 at 3:45 PM, Jan Olszak <j.olszak@samsung.com> wrote:
>
>> The lower fs is most likely ext4.
>> Unfortunately making a file immutable won't solve the problem. There's
>> nothing wrong in modifying the file and it should stay possible.
>>
>> I just want to switch off copy on write for some files. Can you see another
>> way?
> Ah, you want to allow modification of file on the lower layer?
Exactly
> You can bind mount individual files from the lower layer to the
> overlay.  That fixes the "allow modification" part.
Well bind mounting every file that should have COW is unmaintainable - 
if new files appear admin has to mount each one.
Plus all the unnecessary mounts. It's much easier to do it the opposite 
way - by default have COW and only for some files switch it off.

>   But what should happen on rename or unlink?
Both would operate on the original inode.


Setting "trusted.overlay.cow" is a privileged operation so it's admin's 
decision to allow this.

Each layer could potentially make the a file COW again by 
setting/removing "trusted.overlay.cow" attr.


Thanks,
Jan
