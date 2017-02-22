From: Ian Kent <raven@themaw.net>
Subject: Re: overlayfs: allowing for changes to lowerdir
Date: Wed, 22 Feb 2017 17:00:44 +0800
Message-ID: <1487754044.2528.10.camel@themaw.net>
References: <CA+ZH+jFBAaRi6VPmf3PBdDZQQMOaT6WUByATqaw1QL5M9+-dxg@mail.gmail.com>
         <CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=8H1f7+3v3zysW9qA@mail.gmail.com>
         <CA+ZH+jH9yoB5_wxyff088Fsm2-g5=oO1ECimHVo7u2SKVK4AAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35494 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753600AbdBVJAx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Feb 2017 04:00:53 -0500
In-Reply-To: <CA+ZH+jH9yoB5_wxyff088Fsm2-g5=oO1ECimHVo7u2SKVK4AAw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Josh England <jjengla@gmail.com>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>

On Tue, 2017-02-21 at 15:08 -0800, Josh England wrote:
> Amir,
> 
> After playing with it some, this patch seems to provide precisely the
> behavior I need for my use case.  Do you think it makes sense to turn
> this behavior into a module parameter (eg: allow_revalidate)?

This has been a hot topic for me recently, and not only for the overlayfs use
case.

Any case where the inode of a mount point changes (file or directory) is a
problem with current kernels.

The problem is that, if the invalidated mount point belongs to a file system
that has been propagated to other namespaces (which is mostly always the case)
the invalid dentry will be exposed in the other namespaces where it is not a
mountpoint.

I'm not sure how this can be exploited but apparently it can be by using user
namespaces.

To implement this without exposing these dentrys when they shouldn't be the VFS
would need to retain the invalidated dentrys and allow valid dentrys to be
created (leading to multiple dentrys of the same name within directories), hide
them from external VFS lookups, but be able to find them itself when it needs
them and check if they are a mount point in the current namespace, avoid further
revalidation, etc, etc, and the implications go on.

Not only would retaining these dentrys probably lead to some fairly ugly code,
locating and checking these dentrys would need to be done on very hot execution
paths in the VFS which is a challenge in itself (the current kernel mount data
structures don't lend themselves to this at all).

So yes, on the face of it, it's straight forward to get something fairly simple
that will "appear to work" but would not be anywhere near good enough for
inclusion in the mainline kernel.

> 
> -JE
> 
> 
> On Tue, Feb 14, 2017 at 6:01 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Mon, Feb 13, 2017 at 11:41 PM, Josh England <jjengla@gmail.com> wrote:
> > > So here's the use case:  lowerdir is an NFS mounted root filesystem
> > > (shared by a bunch of nodes).  upperdir is a tmpfs RAM disk to allow
> > > for writes to happen.  This works great with the caveat being I cannot
> > > make 'live' changes to the root filesystem, which poses the problem.
> > > Any access to a changed file causes a 'Stale file handle' error.
> > > 
> > > With some experimenting, I've discovered that remounting the overlay
> > > filesystem (mount -o remount / /)  registers any changes that have
> > > been made to the lower NFS filesystem.  In addition, dumping cache
> > > (via /proc/sys/vm/drop_caches) also makes the stale file handle errors
> > > go away and reads pass through to the lower dir and correctly show
> > > changes.
> > > 
> > > I'd like to make this use case feasible by allowing changes to the NFS
> > > lowerdir to work more or less transparently.  It seems like if the
> > > overlay did not do any caching at all, all reads would fall through to
> > > either the upperdir ram disk or the NFS lower, which is precisely what
> > > I want.
> > > 
> > > So, let me pose this somewhat naive question:  Would it be possible to
> > > simply disable any cacheing performed by the overlay to force all
> > > reads to go to either the tmpfs upper or the (VFS-cached) NFS lower?
> > > Would this be enough to accomplish my goal of being able to change the
> > > lowerdir of an active overlayfs?
> > > 
> > 
> > There is no need to disable caching. There is already a mechanism
> > in place in VFS to revalidate inode cache entries.
> > NFS implements d_revalidate() and overlayfs implements d_revalidate()
> > by calling into the lower fs d_revalidate().
> > 
> > However overlayfs intentionally errors when lower entry has been modified.
> > (see: 7c03b5d ovl: allow distributed fs as lower layer)
> > 
> > You can try this (untested) patch to revert this behavior, just to see if it
> > works for your use case, but it won't change this fact
> > from Documentation/filesystems/overlayfs.txt:
> > " Changes to the underlying filesystems while part of a mounted overlay
> > filesystem are not allowed.  If the underlying filesystem is changed,
> > the behavior of the overlay is undefined, though it will not result in
> > a crash or deadlock."
> > 
> > Specifically, renaming directories and files in lower that were already
> > copied up is going to have a weird outcome.
> > 
> > Also, the situation with changing files in lower remote fs could be worse
> > than changing files on lower local fs, simply because right now, this
> > use case is not tested (i.e. it results in ESTALE).
> > 
> > I believe that fixing this use case, if at all possible, would require quite
> > a bit of work, a lot of documentation (about expected behavior) and
> > even more testing.
> > 
> > Amir.
> > 
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index e8ef9d1..6806ef3 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -106,16 +106,11 @@ static int ovl_dentry_revalidate(struct dentry
> > *dentry, unsigned int flags)
> > 
> >                 if (d->d_flags & DCACHE_OP_REVALIDATE) {
> >                         ret = d->d_op->d_revalidate(d, flags);
> > -                       if (ret < 0)
> > +                       if (ret =< 0)
> >                                 return ret;
> > -                       if (!ret) {
> > -                               if (!(flags & LOOKUP_RCU))
> > -                                       d_invalidate(d);
> > -                               return -ESTALE;
> > -                       }
> >                 }
> >         }
> > -       return 1;
> > +       return ret;
> >  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
