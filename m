Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58582 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750965AbeECWLp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 May 2018 18:11:45 -0400
Date: Fri, 4 May 2018 08:11:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
Message-ID: <20180503221142.GC10363@dastard>
References: <20180503152635.14974-1-rgoldwyn@suse.de>
 <20180503152635.14974-4-rgoldwyn@suse.de>
 <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 03, 2018 at 10:57:09PM +0300, Amir Goldstein wrote:
> On Thu, May 3, 2018 at 6:26 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > ---
> >  fs/overlayfs/copy_up.c |  2 +-
> >  fs/read_write.c        | 10 ++++++----
> >  include/linux/fs.h     |  2 ++
> >  3 files changed, 9 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 8bede0742619..6634a85255ae 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -175,7 +175,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
> >                         break;
> >                 }
> >
> > -               bytes = do_splice_direct(old_file, &old_pos,
> > +               bytes = splice_with_holes(old_file, &old_pos,
> >                                          new_file, &new_pos,
> >                                          this_len, SPLICE_F_MOVE);
> 
> 
> Add.. you can remove this comment above :)
>         /* FIXME: copy up sparse files efficiently */
> 
> For the record, when I added vfs_clone_file_range() above,
> Dave Chinner has suggested to replace the entire block with
> vfs_copy_file_range(), which would do all the fallbacks.
> Since then, vfs_copy_file_range() gained "try to clone first".

Yup, we want the copy offload infrastructure to be used if at all
possible, so we get consistent behaviour for everyone trying to
optimise copy behaviour.  In this case, I think that it is relevant
that we heard at LSFMM that userspace utils don't want to use
copy_file_range() because it doesn't "optimise for sparse files".

>From that perspective, perhaps this needs "hole preserving copy"
behaviour needs to be moved inside copy-file_range() (and therefore
do_splice_direct()) and triggered by a new flag for
copy_file_range(). e.g. COPY_FILE_SPARSE. That way callers can tell
the kernel they want a sparse copy, and the kernel can attempt that
rather a copy that converts holes to zeros.

In most cases, filesystems that implement efficient offloads already
preserve sparseness, but the do_splice_direct() fallback does not.
If we fix that, then we're a big step closer to getting utilities
like cp and rsync to use copy_file_range() instead of bit shuffling
through userspace to copy data.....

> I am not asking that you do this as part of your work, simply
> pointing out an opportunity.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
