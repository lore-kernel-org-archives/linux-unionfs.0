From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 09/35] ovl: stack file ops
Date: Thu, 26 Apr 2018 10:56:41 -0400
Message-ID: <20180426145641.GB4308@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
 <20180412150826.20988-10-mszeredi@redhat.com>
 <20180426141337.GA4308@redhat.com>
 <CAJfpegv9by9L_b-STRMy4U8Uqv03UrOYDuAa3HdF-9zKxZQRcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegv9by9L_b-STRMy4U8Uqv03UrOYDuAa3HdF-9zKxZQRcA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Apr 26, 2018 at 04:43:53PM +0200, Miklos Szeredi wrote:
> On Thu, Apr 26, 2018 at 4:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Apr 12, 2018 at 05:08:00PM +0200, Miklos Szeredi wrote:
> >
> > [..]
> >> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> >> new file mode 100644
> >> index 000000000000..a0b606885c41
> >> --- /dev/null
> >> +++ b/fs/overlayfs/file.c
> >> @@ -0,0 +1,76 @@
> >> +/*
> >> + * Copyright (C) 2017 Red Hat, Inc.
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify it
> >> + * under the terms of the GNU General Public License version 2 as published by
> >> + * the Free Software Foundation.
> >> + */
> >> +
> >> +#include <linux/cred.h>
> >> +#include <linux/file.h>
> >> +#include <linux/xattr.h>
> >> +#include "overlayfs.h"
> >> +
> >> +static struct file *ovl_open_realfile(const struct file *file)
> >> +{
> >> +     struct inode *inode = file_inode(file);
> >> +     struct inode *upperinode = ovl_inode_upper(inode);
> >> +     struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
> >> +     struct file *realfile;
> >> +     const struct cred *old_cred;
> >> +
> >> +     old_cred = ovl_override_creds(inode->i_sb);
> >> +     realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
> >> +                          realinode, current_cred(), false);
> >> +     revert_creds(old_cred);
> >> +
> >> +     pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
> >> +              file, file, upperinode ? 'u' : 'l', file->f_flags,
> >> +              realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
> >> +
> >> +     return realfile;
> >> +}
> >> +
> >> +static int ovl_open(struct inode *inode, struct file *file)
> >> +{
> >> +     struct dentry *dentry = file_dentry(file);
> >
> > Hi Miklos,
> >
> > There is one thing I can't wrap my head around, so I better ask.
> >
> > file_dentry() will call ovl_d_real() and try to find dentry based on
> > inode installed in f->f_inode. If ovl_d_real() can't find inode dentry
> > matching the passed in inode, it warns.
> >
> > Assume, I have a stacked overlay configuration. Let me call top level
> > overlay layer ovl1 and lower level overlay layer ovl2. Say I open a
> > file foo.txt. Now ovl_open() in ovl1 decides that realinode is a lower
> > inode and installs that inode f->f_inode of realfile. (This should be
> > ovl2 layer inode, let me call it ovl2_inode). Now ovl_open() of ovl2 layer
> > will be called and it will call file_dentry() and will look for dentry
> > corresponding to ovl2_inode. I am wondering what if a copy up of foo.txt
> > was triggered in ovl1 and by the time we called ovl_d_real(dentry,
> > ovl2_inode), it will start comparing with inode of ovl1_upper and never
> > find ovl2_inode.
> 
> Okay, so we've modified ovl_d_real() to allow returning the overlay
> dentry itself.  This is important: when we fail to match ovl1_upper
> with ovl2_inode, well go on to get ovl2_dentry and call d_real()
> recursively.  That recursive call should match the inode, return it to
> outer ovl_d_real(), which again will match the inode and return
> without warning.

So current code does following.

ovl_d_real() {
	...
	...

        real = ovl_dentry_real(dentry);
        if (inode == d_inode(real))
                return real;

        /* Handle recursion */
        if (unlikely(real->d_flags & DCACHE_OP_REAL))
                return real->d_op->d_real(real, inode);
}

If file got copied up in ovl1, then "real" will be ovl1_upper dentry. And
upper is regular fs (only ovl1 lower is overlay), then it should not have
DCACHE_OP_REAL set and that means we will not recurse further and not
find ovl2 dentry matching ovl2_inode and print warning and return
ovl1 dentry.

What am I missing.

Vivek

> 
> > IOW, I am not able to figure out how do we protect agains copy up races
> > when ovl_open() calls file_dentry().
> 
> Racing with a copy up cannot matter, since we'll continue looking for
> the inode in the layers and stacks below, regardless of whether we
> checked the upper dentry or not.
> 
> Does that make it clearer?
> 
> Thanks,
> Miklos
