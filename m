From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [RFC] ovl: System-wide unique st_dev
Date: Mon, 12 Jun 2017 10:40:24 +0530
Message-ID: <4039038.Y7aay4matP@localhost.localdomain>
References: <20170611134430.4360-1-chandan@linux.vnet.ibm.com> <CAOQ4uxgRVFoVZDLgpFP2yfTjRHcsK+22ksNNqpEKd0rLXaHdXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33621 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752002AbdFLFKM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jun 2017 01:10:12 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5C58ZsQ136780
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2017 01:10:11 -0400
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b19pu499y-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2017 01:10:11 -0400
Received: from localhost
        by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 12 Jun 2017 15:10:08 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v5C5A5O67864826
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2017 15:10:05 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
        by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v5C59uGQ018458
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2017 15:09:56 +1000
In-Reply-To: <CAOQ4uxgRVFoVZDLgpFP2yfTjRHcsK+22ksNNqpEKd0rLXaHdXQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Sunday, June 11, 2017 9:03:54 PM IST Amir Goldstein wrote:
> On Sun, Jun 11, 2017 at 4:44 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > The following sequence of commands causes a lowerdir file and an
> > overlay file to have the same values for st_ino/st_dev,
> 
> You meant different st_dev values...
> 
> All in all, looks very good to me. Nice work!
> See some nits and suggestions below.
> 
> Did you get any progress with tests yet?

Thanks for the review comments.

I spent some time to read and figure out the workings of 
unionmount-testsuite framework. I should be able to post the
the new test along with the non-RFC version of this patch.

> 
> >
> > $ xfs_io -f -c "pwrite 0 4k" /mnt/lowerdir/testfile -c sync
> > $ xfs_io -a -c "pwrite 4k 4k" /mnt/ovl/testfile # Copy-up occurs here
> 
> Honestly, I think you could find a simpler example and also one that
> demonstrates
> the bug, something like:
> 
> $ echo 123 > /mnt/lowerdir/testfile
> $ echo 456 > /mnt/ovl/testfile
> $ cat /mnt/lowerdir/testfile /mnt/ovl/testfile
> 123
> 456
> $ diff /mnt/lowerdir/testfile /mnt/ovl/testfile && echo "123  == 456 ???"
> 
> But that diff example will only demonstrate a bug on top of my branch,
> and I don't think that is the right order for this patch. it should
> come *before*
> the relax samefs patch, so maybe just drop the example?

Ok. Understood. I will do that.

> 
> >
> > This commit solves the bug by reporting pseudo device numbers for files
> > on lowerdir.
> >
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> >  fs/overlayfs/inode.c     | 23 ++++++++++++++++++++---
> >  fs/overlayfs/ovl_entry.h |  8 +++++++-
> >  fs/overlayfs/super.c     | 33 +++++++++++++++++++++++++--------
> >  3 files changed, 52 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index 5f285c1..154c87892 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -13,6 +13,19 @@
> >  #include <linux/xattr.h>
> >  #include <linux/posix_acl.h>
> >  #include "overlayfs.h"
> > +#include "ovl_entry.h"
> > +
> > +static dev_t get_lowerdir_pseudo_dev(struct ovl_fs *ufs, dev_t dev)
> 
> I suggest to call this ovl_get_pseudo_dev (see below why) and
> I suggest to check if dev == upper real dev and return the overlay dev.

Ok. I agree.
> 
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < ufs->numlower; i++) {
> > +               if (ufs->lower_mnt[i].real_dev == dev)
> > +                       return ufs->lower_mnt[i].pseudo_dev;
> > +       }
> > +
> > +       BUG();
> 
> No need to BUG() here WARN() and return dev will not cause any
> catastrophic bug. overlay will just behave as it does today..

I agree.
> 
> > +}
> >
> >  int ovl_setattr(struct dentry *dentry, struct iattr *attr)
> >  {
> > @@ -61,6 +74,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
> >                 u32 request_mask, unsigned int flags)
> >  {
> >         struct dentry *dentry = path->dentry;
> > +       struct ovl_fs *ufs;
> 
> I prefer ofs. The use of ufs is mostly when the info is not yet attached to sb.
> Not sure if this was intentional, but its convenient.

I will fix this.
> 
> >         enum ovl_path_type type;
> >         struct path realpath;
> >         const struct cred *old_cred;
> > @@ -103,10 +117,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
> >                         if (is_dir || lowerstat.nlink == 1)
> >                                 stat->ino = lowerstat.ino;
> >
> > -                       if (samefs)
> > +                       if (samefs) {
> >                                 WARN_ON_ONCE(stat->dev != lowerstat.dev);
> > -                       else
> > -                               stat->dev = lowerstat.dev;
> > +                       } else {
> > +                               ufs = dentry->d_sb->s_fs_info;
> > +                               stat->dev = get_lowerdir_pseudo_dev(ufs,
> > +                                                               lowerstat.dev);
> 
> if (!is_dir && !samefs) { stat->dev = ovl_get_pseudo_dev ... }
> should be outside the OVL_TYPE_ORIGIN condition, because
> it also applies to pure lower and pure upper inodes (not copied up).
> 
> For pure upper it is just nicer and du -xs will work better on
> pure upper dirs.
> For lower, it is a must, because overlay inode needs to preserve
> st_dev across copy up, so it needs to have the pseudo lower st_dev
> before that lower becomes the origin of a copy up.

I will fix this.
> 
> 
> > +                       }
> >                 }
> >                 if (samefs)
> >                         stat->dev = dentry->d_sb->s_dev;
> 
> 


-- 
chandan
