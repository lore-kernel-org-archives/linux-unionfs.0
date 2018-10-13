Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181011143814.14296-1-amir73il@gmail.com> <20181013041026.GN32577@ZenIV.linux.org.uk>
In-Reply-To: <20181013041026.GN32577@ZenIV.linux.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 13 Oct 2018 10:33:54 +0300
Message-ID: <CAOQ4uxi3qXSZdKsz3r=_V2JWHoAjCpETcgo-RYS-1cA1TBNg=g@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: fix FIGETBSZ ioctl on an overlayfs file
Content-Type: text/plain; charset="UTF-8"
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 13, 2018 at 7:10 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Thu, Oct 11, 2018 at 05:38:14PM +0300, Amir Goldstein wrote:
> > Some anon_bdev filesystems (e.g. overlayfs, ceph) don't have s_blocksize
> > set. Returning zero from FIGETBSZ ioctl results in a Floating point
> > exception from the e2fsprogs utility filefrag, which divides the size of
> > the file with the value returned by FIGETBSZ.
> >
> > Fix the interface by returning -EINVAL for these filesystems.
> >
> > Fixes: d1d04ef8572b ("ovl: stack file ops")
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/ioctl.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 2005529af560..0400297c8d72 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -669,6 +669,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
> >               return ioctl_fiemap(filp, arg);
> >
> >       case FIGETBSZ:
> > +             /* anon_bdev filesystems may not have a block size */
> > +             if (!inode->i_sb->s_blocksize)
> > +                     return -EINVAL;
> >               return put_user(inode->i_sb->s_blocksize, argp);
>
> Probably makes sense...  Out of curiosity - what does the same utility do
> when faced with -EINVAL here?

filefrag was actually converted from FIBMAP/FIGETBSZ to FIEMAP/statfs(2)
but apparently that didn't work well for some fs, so FIGETBSZ was
brought back from retirement to override b_size.
When ioctl(FIGETBSZ) fails filefrag continues with f_bsize without any
complains.

FYI, another utility in e2fsprogs that uses FIGETBSZ, copy_sparse, will
simply exit when ioctl(FIGETBSZ) fails. But copy_sparse only has
FIBMAP implementation so it is going to fail on overlay file anyway.

Cheers,
Amir.

commit 01824c9bbcd2c1037085213f6cd7d591f78db9c5
Author: Rakesh Pandit <rakesh@tuxera.com>
Date:   Sun Jul 27 20:04:48 2014 -0400

    filefrag: fix block size value

    ioctl(FIGETBSZ) was used to get block size earlier but 2508eaa7
    (filefrag: improvements to filefrag FIEMAP handling) moved to fstatfs
    f_bsize which doesn't work well for many files systems.

    Block size returned using fstatfs isn't block size but "optimal
    transfer block size" as per man page.  Even stat st_blksize is
    "preferred I/O block size" and in may file systems it may even vary
    from file to file (POSIX).  This patch changes filefrag to use
    FIGETBSZ preferentially over f_bsize.

    [ Modified by tytso to add the fallback to f_bsize if FIGETBSZ fails
      for some reason ]

    Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
