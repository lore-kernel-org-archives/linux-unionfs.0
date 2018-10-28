Return-Path: <david@fromorbit.com>
Date: Sun, 28 Oct 2018 12:33:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/1] man-page: copy_file_range(2) allow for cross-device
 copies
Message-ID: <20181028013307.GM6311@dastard>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-3-olga.kornievskaia@gmail.com>
 <20181027091240.GK6311@dastard>
 <20181027132339.GZ25444@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181027132339.GZ25444@bombadil.infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Olga Kornievskaia <olga.kornievskaia@gmail.com>, trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 27, 2018 at 06:23:39AM -0700, Matthew Wilcox wrote:
> On Sat, Oct 27, 2018 at 08:12:40PM +1100, Dave Chinner wrote:
> > > @@ -131,7 +132,8 @@ There is not enough space on the target filesystem to complete the copy.
> > >  .B EXDEV
> > >  The files referred to by
> > >  .IR file_in " and " file_out
> > > -are not on the same mounted filesystem.
> > > +are not on the same mounted filesystem when the kernel does not support
> > > +cross device file copy.
> > 
> > Kernel can support cross device file copy, the filesystem may not.
> > 
> > EXDEV
> > 	One of the files specified by file_in and file_out are on a
> > 	filesystem that does not support cross device copies.
> 
> I mentioned this in my last review, and Olga pointed out that one of
> the changes in this patch means the kernel will do the copy using
> do_splice_direct if the filesystem doesn't support cross-device copying.
> We should keep this error documented for those on old kernels, but the
> kernel will never return -EXDEV any more.

Uh, wot? Where's the patch named "VFS: enable copy_file_range() for
all filesystems"? That shoul dnot be a detail hidden inside some
other patch that multiple people completely miss during review.

If we are completely changing the kernel's behaviour, the patch
should be explicitly named to call out the change of behaviour, and
the commit message should clearly explain the change being made and
why.
 
/me goes looking.

Yup, it is only mentione din passing as a side-effect of an
implementation change. That's back to front. Describe the behaviour
change, what users will see and the reasons for making the change,
leave the code to describe exactly what the change is. Then you can
describe the actions needed to make the new functionality work. e.g.
The first patch shoul dbe described as:

VFS: generic cross-device copy_file_range() support for all filesystems

From: ....

In preparation for enabling cross-device offloading of
copy_file_range() functionality, first enable generic cross-device
support by allowing copy_file_range() to fall back to a page cache
based physical data copy. This means the copy_file_range() syscall
will never fail with EXDEV, and so in future userspace will not need
to detect or provide a fallback for failed cross-device copies
anymore.

This requires pushing the cross device support checks down into the
filesystem ->copy_file_range methods and falling back to the page
cache copy if they return EXDEV.

Further, clone_file_range() is only supported within a filesystem,
so we must also check that the files belong to the same superblock
before calling ->clone_file_range(). If they are on different
superblocks, skip the attempt to clone the file and instead try to
copy the file.

S-o-B: .....


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
