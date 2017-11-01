From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v5 2/4] ovl: allocate anonymous devs for lowerdirs
Date: Wed, 1 Nov 2017 11:47:00 -0400
Message-ID: <20171101154700.GA3125@redhat.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
 <1509395247-15180-3-git-send-email-amir73il@gmail.com>
 <20171101144249.GA8259@redhat.com>
 <CAOQ4uxiReuzqQ09b8f0YxxTzT-Lt0pSPxsTsxz9feuFPrmTGWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56067 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbdKAPrB (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 11:47:01 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiReuzqQ09b8f0YxxTzT-Lt0pSPxsTsxz9feuFPrmTGWg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Nov 01, 2017 at 05:02:55PM +0200, Amir Goldstein wrote:
> On Wed, Nov 1, 2017 at 4:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, Oct 30, 2017 at 10:27:25PM +0200, Amir Goldstein wrote:
> >> From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> >>
> >> For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
> >> provides unique values for st_dev. The unique values are obtained by
> >> allocating anonymous bdevs for each of the lowerdirs in the overlayfs
> >> instance.
> >
> > Hi Amir, Chandan,
> >
> > In the commit message, can we also mention what's the current behavior
> > and why this new behavior beneficial/desirable.
> >
> 
> This is the blurb from the uptodate patch on my branch:
> 
>      For non-samefs setup, to make sure that st_dev/st_ino pair
>     is unique across the system, we return a unique anonymous
>     st_dev for stat(2) of lower layer inode.
> 
> A bit fatter, but not fat enough...
> 
> Actually, it is not accurate, because st_dev/st_ino pair of pure
> upper is still same values as underlying inode for non-samefs so the
> values are not unique among all inodes in the system.

Hi Amir,

So as of now for non-samefs non-dir case we return st_dev/st_ino of
lower inode. And with this change we will return st_dev of overlayfs
while inode of lower, right?

What does unique mean in this context. IIUC, st_dev/st_inode of lower
will be unique in the system, isn't it. Which other inode can have
same st_dev/st_ino pair.

Or is it the case that if same inode is accessed through overlayfs, we
want to report a different st_dev.

> 
> I can't remember if there was a reason for not allocating anonymous bdev
> for upper

That's a good point.

> or if it just because we did not need it to guaranty uniqueness
> of st_dev/st_ino *among* overlay inodes

Even for lower, st_dev will be unique for different lower on non same-fs,
right. IOW, when it come to uniqueness of st_dev/st_ino pair, among
overlay inodes, lower and upper should have same requirements.

> while guarantying constant
> st_dev/st_ino across copy up.

Hmm..., I did not get this point. Over copy up, atleast st_ino will change
for non-samefs case. 

I will spend more time on patch.

Vivek

> 
> I will update commit message.
> 
> Thanks,
> Amir.
