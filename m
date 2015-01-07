From: hujianyang <hujianyang@huawei.com>
Subject: Re: Multiple lower layers - presedence?
Date: Wed, 7 Jan 2015 10:22:35 +0800
Message-ID: <54AC986B.6030100@huawei.com>
References: <1997646.dsfVWM3xr5@debian-desktop-mine> <13541642.4YrjBhCzAu@debian-desktop-mine> <85r3v799yw.fsf@boum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:14752 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbbAGCXM (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 6 Jan 2015 21:23:12 -0500
In-Reply-To: <85r3v799yw.fsf@boum.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: intrigeri <intrigeri@boum.org>, fabian.sturm@aduu.de
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

On 2015/1/6 23:59, intrigeri wrote:
> Hi,
> 
> Fabian Sturm wrote (05 Jan 2015 01:29:04 GMT) :
>> Consider the case /lower1/A and /lower2/A exist.
>> What is part of the api - that it is undefined or that one takes presedence 
>> over the other?
>> It would be nice to have this clarified in the documentation.
> 
> IMO this should be specified. I would intuitively believe that
> a right-hand lowerdir should take precedence over any left-hand one,
> but my intuition definitely is tainted by cultural background that not
> everyone shares, so it's probably worth looking at how it's done in
> aufs, to make migration easier for aufs users.

Hi,

It seems different in overlayfs. A left-hand lowerdir take precedence
over any right-hand one in the option line.

For example, we have two file with same name in two lower directories.

/mnt/ext4/lower1 # echo lower1 > file
/mnt/ext4/lower2 # echo lower2 > file

and mount them in different order.

/mnt # mount -t overlay overlay -o lowerdir=./ext4/lower1/:./ext4/lower2/ ./overlay
/mnt # cat ./overlay/file
lower1

/mnt # mount -t overlay overlay -o lowerdir=./ext4/lower2/:./ext4/lower1/ ./overlay
/mnt # cat ./overlay/file
lower2

It is because lowerdirs are store in a buffer which is scanned by mount
function of overlayfs from left to right. The left most one is treat as
the top most lowerdir and the right most lowerdir is treat as the lowest
lowerdir.

I think a definition about this is needed in the documentation.

Thanks,
Hu

