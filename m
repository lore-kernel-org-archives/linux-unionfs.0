From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v5 2/4] ovl: allocate anonymous devs for lowerdirs
Date: Thu, 2 Nov 2017 08:27:30 -0400
Message-ID: <20171102122730.GA16677@redhat.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
 <1509395247-15180-3-git-send-email-amir73il@gmail.com>
 <20171101144249.GA8259@redhat.com>
 <CAOQ4uxiReuzqQ09b8f0YxxTzT-Lt0pSPxsTsxz9feuFPrmTGWg@mail.gmail.com>
 <20171101154700.GA3125@redhat.com>
 <CAOQ4uxhpq_mEyyUj0M5AELPYGuHwyCpxz9+HE4K0qaY1+-XQGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55048 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751324AbdKBM1b (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 08:27:31 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhpq_mEyyUj0M5AELPYGuHwyCpxz9+HE4K0qaY1+-XQGw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Nov 01, 2017 at 06:41:51PM +0200, Amir Goldstein wrote:

[..]
> >> I can't remember if there was a reason for not allocating anonymous bdev
> >> for upper
> >
> > That's a good point.
> >
> >> or if it just because we did not need it to guaranty uniqueness
> >> of st_dev/st_ino *among* overlay inodes
> >
> > Even for lower, st_dev will be unique for different lower on non same-fs,
> > right. IOW, when it come to uniqueness of st_dev/st_ino pair, among
> > overlay inodes, lower and upper should have same requirements.
> >
> >> while guarantying constant
> >> st_dev/st_ino across copy up.
> >
> > Hmm..., I did not get this point. Over copy up, atleast st_ino will change
> > for non-samefs case.
> >
> > I will spend more time on patch.
> >
> 
> Urgh! It took me a while to remember the reason why system wide uniqueness
> is important for lower but less for upper.
> An upper object has the same content as the "real" object and they have the
> same st_ino/st_dev so its ok that diff will skip comparing them.
> A copy-up object does not have the same content as the lower "real" object,
> so if it has the same st_ino/st_dev as real object, diff will skip compare and
> we have a problem.

I am not sure I understand this.  So you are doing a diff between a file
on overlayfs and same file accessed outside overlayfs?

If a file is on lower, then it has not been modified and diff skipping
it makes perfect sense?

Vivek
