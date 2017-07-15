From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] ovl: Allocate anonymous devs for lowerdirs
Date: Sat, 15 Jul 2017 19:57:07 +0530
Message-ID: <2330087.0RvEmnbld2@localhost.localdomain>
References: <20170623110118.19975-1-chandan@linux.vnet.ibm.com> <CAJfpegs9W=qQRXBeF7h4t4bxnXvbGnTbUi+iGaZhft79Mvxgtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44265 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750985AbdGOO1d (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 15 Jul 2017 10:27:33 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6FEO3kS059522
        for <linux-unionfs@vger.kernel.org>; Sat, 15 Jul 2017 10:27:32 -0400
Received: from e23smtp05.au.ibm.com (e23smtp05.au.ibm.com [202.81.31.147])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bqc04p64v-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Sat, 15 Jul 2017 10:27:32 -0400
Received: from localhost
        by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 16 Jul 2017 00:27:29 +1000
Received: from d23av05.au.ibm.com (d23av05.au.ibm.com [9.190.234.119])
        by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6FERIrL20578496
        for <linux-unionfs@vger.kernel.org>; Sun, 16 Jul 2017 00:27:26 +1000
Received: from d23av05.au.ibm.com (localhost [127.0.0.1])
        by d23av05.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v6FEQrqN011908
        for <linux-unionfs@vger.kernel.org>; Sun, 16 Jul 2017 00:26:53 +1000
In-Reply-To: <CAJfpegs9W=qQRXBeF7h4t4bxnXvbGnTbUi+iGaZhft79Mvxgtw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>

On Friday, July 14, 2017 3:08:31 PM IST Miklos Szeredi wrote:
> On Fri, Jun 23, 2017 at 1:01 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
> > provides unique values for st_dev. The unique values are obtained by
> > allocating anonymous bdevs for each of the lowerdirs in the overlayfs
> > instance.
> >
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > Changelog:
> > v1->v2: Drop code that provided unique st_dev across copy up.
> >
> >  fs/overlayfs/inode.c     | 20 ++++++++++++++++++++
> >  fs/overlayfs/ovl_entry.h |  8 +++++++-
> >  fs/overlayfs/super.c     | 33 +++++++++++++++++++++++++--------
> >  3 files changed, 52 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index d613e2c..e30bdca 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -8,11 +8,29 @@
> >   */
> >
> >  #include <linux/fs.h>
> > +#include <linux/mount.h>
> >  #include <linux/slab.h>
> >  #include <linux/cred.h>
> >  #include <linux/xattr.h>
> >  #include <linux/posix_acl.h>
> >  #include "overlayfs.h"
> > +#include "ovl_entry.h"
> > +
> > +static dev_t ovl_get_pseudo_dev(struct dentry *dentry, dev_t dev)
> > +{
> > +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> > +       int i;
> > +
> > +       if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb->s_dev == dev)
> > +               return dev;
> > +
> > +       for (i = 0; i < ofs->numlower; i++) {
> > +               if (ofs->lower_mnt[i].real_dev == dev)
> > +                       return ofs->lower_mnt[i].pseudo_dev;
> > +       }
> > +
> > +       return dev;
> > +}
> 
> This is a good way to test out the functionality.  But there's a
> trivial way to optimize away the O(num of layers) from this function:
> instead of using struct path for lower stack, use
> 
> struct ovl_lower {
>         struct ovl_lower_mnt *layer;
>         struct dentry *dentry;
> };
> 
> That means one more dereference to get the vfsmount, but I don't think
> we need to care about that.
> 

Hi Miklos,

IIUC, 'struct ovl_entry' would then be,

/* private information held for every overlayfs dentry */
struct ovl_entry {
        union {
                struct {
                        unsigned long has_upper;
                        bool opaque;
                };
                struct rcu_head rcu;
        };
        unsigned numlower;
        struct ovl_lower lowerstack[];
};


... ovl_path_lower() would then be having a "struct ovl_lower *" as its
second argument.

With the above listed changes, ovl_get_pseudo_dev() can then be fed a "struct
ovl_path_lower *" and hence, as you had indicated the 'for' loop can be
replaced with a statement returning the value of ovl_lower->layer->pseudo_dev.

> >
> >  int ovl_setattr(struct dentry *dentry, struct iattr *attr)
> >  {
> > @@ -116,6 +134,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
> >                  */
> >                 stat->dev = dentry->d_sb->s_dev;
> >                 stat->ino = dentry->d_inode->i_ino;
> > +       } else {
> > +               stat->dev = ovl_get_pseudo_dev(dentry, stat->dev);
> >         }
> >
> >         /*
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index 34bc4a9..92aebe9 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -16,11 +16,17 @@ struct ovl_config {
> >         bool redirect_dir;
> >  };
> >
> > +struct ovl_lower_mnt {
> > +       struct vfsmount *mnt;
> > +       dev_t real_dev;
> 
> Why store the real_dev?  It's stored in mnt->mnt_sb->s_dev, right?

You are right. I will fix it up in the next version of this patch.

Thanks for your review comments.
> 
> > +       dev_t pseudo_dev;
> > +};
> > +


-- 
chandan
