From: Jan Olszak <j.olszak@samsung.com>
Subject: Re: Optional switching off cow in overlayfs
Date: Tue, 23 Jun 2015 18:07:59 +0200
Message-ID: <5589845F.5080206@samsung.com>
References: <55893699.6090109@samsung.com> <55882AA5.10908@samsung.com>
 <5582C6C1.8080602@samsung.com> <13405.1434634748@warthog.procyon.org.uk>
 <5582D8F7.1060700@samsung.com>
 <CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com>
 <5588116E.20509@samsung.com>
 <CAJfpegsVqzVhq8BjCwqA+6dEZey0aNb4amnnOT_JVDfzki9v1g@mail.gmail.com>
 <55881B2A.7090106@samsung.com>
 <CAJfpegtcUt6jR7t_2Ca1osu6+-BKGtnTVVTVXEcWrqBtY0fCzA@mail.gmail.com>
 <29219.1435051659@warthog.procyon.org.uk>
 <32715.1435065828@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34493 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039AbbFWQID (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 23 Jun 2015 12:08:03 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQE00MGUNHC4X80@mailout1.w1.samsung.com> for
 linux-unionfs@vger.kernel.org; Tue, 23 Jun 2015 17:08:00 +0100 (BST)
In-reply-to: <32715.1435065828@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>


On 06/23/2015 03:23 PM, David Howells wrote:
> Jan Olszak <j.olszak@samsung.com> wrote:
>
>> Why not just say: "rename causes copy" and leave everything as it is now.
> That's another option - but your whole proposal was that we specifically don't
> copy up these files IIRC.
>

Yes, so let's modify the proposal:

Overlayfs checks xattr "trusted.overlay.cow" to switch COW off whenever 
it's possible.

1. This would be an optimization/convenience option, not a security option
2. By default overlayfs uses COW like it does now
3. trusted.overlay.cow=="n" means:
- Unlink, open, setattr etc. use the original inode from lowerdir
- Unmodifying operations also use inode from lowerdir
- Other operations (rename) may copy the file if it's required by the 
implementation of overlayfs

Thanks,
Jan
