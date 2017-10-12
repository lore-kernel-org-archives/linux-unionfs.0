From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH V4] overlay: Test consistent d_ino feature for non-samefs
 setup
Date: Fri, 13 Oct 2017 00:11:43 +0800
Message-ID: <20171012161143.GI10593@eguan.usersys.redhat.com>
References: <20171012133432.20645-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxgrW2t7as8PvZh=8n2L4K8aJm9o4cSs0pwUqNd6nCgeQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbdJLQLp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2017 12:11:45 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgrW2t7as8PvZh=8n2L4K8aJm9o4cSs0pwUqNd6nCgeQQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, fstests <fstests@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Oct 12, 2017 at 04:44:53PM +0300, Amir Goldstein wrote:
> On Thu, Oct 12, 2017 at 4:34 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > This commit adds a test to verify consistent d_ino feature when
> > the overlayfs instance is composed of two different underlying
> > filesystem instances.
> >
> > For example,
> > $ mount -t xfs /dev/loop0 /mnt/test
> > $ mount -t xfs /dev/loop1 /mnt/scratch
> > $ mkdir /mnt/scratch/upper
> > $ mkdir /mnt/scratch/work
> > $ mount -t overlay overlay -o lowerdir=/mnt/test \
> >         -o upperdir=/mnt/scratch/upper \
> >         -o workdir=/mnt/scratch/work /mnt/merge
> >
> > The goal of this test is to verify that the inode numbers returned by
> > readdir(3) (i.e. dirent->d_ino) are consistent with inode numbers
> > returned by stat(2) (i.e. stat->st_ino) in all the below listed cases,
> > - Parent's (i.e. "..") d_ino must always be calculated because a
> >   pure dir can be residing inside a merged dir.
> > - d_ino for "." must always be calculated because the present
> >   directory can have a copy-up origin.
> > - Verify d_ino of '.' and '..' before and after dir becomes impure.
> >   While at it also verify if trusted.overlay.impure xattr is
> >   set/reset appropriately and invalidation of readdir cache.
> > - Verify copied up file's (inside a impure dir) d_ino.
> > - Verify invalidation of readdir cache.
> > - Verify d_ino values corresponding to "." and ".." entries of a
> >   pure lower dir.
> > - Verify d_ino of ".." entry of a merged dir.
> > - Verify pure lower residing in dir which has another lower layer
> >
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > Eryu,
> > This test requires the following "yet to be upstreamed" overlayfs kernel
> > patches to be merged,
> 
> Clarification. The test *requires* those patches to pass, but IMO
> there is nothing to prevent merging the test now.
> As several functional tests before it, the test fails on upstream kernel
> because overlayfs doesn't behave as it should.
> 
> > https://marc.info/?l=linux-unionfs&m=150728247029074&w=2
> > https://marc.info/?l=linux-unionfs&m=150728190228896&w=2
> > https://marc.info/?l=linux-unionfs&m=150728190428897&w=2

Thanks all for updated test and review, and the upstream context!

Eryu
