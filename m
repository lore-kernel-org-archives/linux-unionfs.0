From: Jan Olszak <j.olszak@samsung.com>
Subject: Re: Optional switching off cow in overlayfs
Date: Tue, 23 Jun 2015 12:36:09 +0200
Message-ID: <55893699.6090109@samsung.com>
References: <55882AA5.10908@samsung.com> <5582C6C1.8080602@samsung.com>
 <13405.1434634748@warthog.procyon.org.uk> <5582D8F7.1060700@samsung.com>
 <CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com>
 <5588116E.20509@samsung.com>
 <CAJfpegsVqzVhq8BjCwqA+6dEZey0aNb4amnnOT_JVDfzki9v1g@mail.gmail.com>
 <55881B2A.7090106@samsung.com>
 <CAJfpegtcUt6jR7t_2Ca1osu6+-BKGtnTVVTVXEcWrqBtY0fCzA@mail.gmail.com>
 <29219.1435051659@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16019 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbbFWKgQ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 23 Jun 2015 06:36:16 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQE00MXX84D4X00@mailout1.w1.samsung.com> for
 linux-unionfs@vger.kernel.org; Tue, 23 Jun 2015 11:36:13 +0100 (BST)
In-reply-to: <29219.1435051659@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On 06/23/2015 11:27 AM, David Howells wrote:
> Jan Olszak <j.olszak@samsung.com> wrote:
>
>>>>>     But what should happen on rename or unlink?
>>>> Both would operate on the original inode.
>>> And that would make this hugely complex.
>> Are you sure?
> Unlink would be the same as now - you just whiteout over the lower layer.
>
> Rename, though, would be complex - unless you go for the trivial option and
> just error out.
>
> The problem is that the only connection between the upper layer and lower
> layer is coincidence governed by filename.  If you move the upper layer
> object, the lower layer object is no longer coincident and is effectively
> lost.  You cannot move the lower layer object because the lower layer may be
> shared between multiple overlays.
>
> At the moment, rename deals
>
> You could, I suppose, store a "fall through" inode in the upper layer that has
> the NFS fh of the lower layer object attached in some fashion (eg. xattr), but
> it's messy.
>
> Hard linking would be even more complex - you'd have to hard link the "fall
> through" inodes on the upper layer.
>
> David
"Fall through" inodes seem a messy solution, agreed.

Why not just say: "rename causes copy" and leave everything as it is now.
Renaming a file shared by many mounts seems to be a corner case and I 
guess overlayfs handles this well right now.

Thanks,
Jan
