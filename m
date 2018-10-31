Return-Path: <david@fromorbit.com>
Date: Wed, 31 Oct 2018 11:14:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 02/11] VFS: copy_file_range check validity of input
 source offset
Message-ID: <20181031001437.GQ6311@dastard>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-4-olga.kornievskaia@gmail.com>
 <20181027092750.GL6311@dastard>
 <CAN-5tyEeMrRVUyP61Vv-dwFUvm7q55Q3=NVJkeZN+XoCcAOCDQ@mail.gmail.com>
 <20181030090344.GN6311@dastard>
 <CAN-5tyHhTQ8bZk+DUrU0o1ZK3k9uhipiLPeOA3dYuXUG542mNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN-5tyHhTQ8bZk+DUrU0o1ZK3k9uhipiLPeOA3dYuXUG542mNw@mail.gmail.com>
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Oct 30, 2018 at 05:10:58PM -0400, Olga Kornievskaia wrote:
> On Tue, Oct 30, 2018 at 5:03 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, Oct 29, 2018 at 10:41:22AM -0400, Olga Kornievskaia wrote:
> > > On Sat, Oct 27, 2018 at 5:27 AM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Fri, Oct 26, 2018 at 04:10:48PM -0400, Olga Kornievskaia wrote:
> > > > > From: Olga Kornievskaia <kolga@netapp.com>
> > > > >
> > > > > Input source offset can't be beyond the end of the file.
> > > > >
> > > > > Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> > > > > ---
> > > > >  fs/read_write.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/fs/read_write.c b/fs/read_write.c
> > > > > index fb4ffca..b3b304e 100644
> > > > > --- a/fs/read_write.c
> > > > > +++ b/fs/read_write.c
> > > > > @@ -1594,6 +1594,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
> > > > >               }
> > > > >       }
> > > > >
> > > > > +     if (pos_in >= i_size_read(inode_in))
> > > > > +             return -EINVAL;
> > > > > +
> > > >
> > > > vfs_copy_file_range seems ot be missing a wide range of checks.
> > > > rlimit, s_maxbytes, LFS file sizes, etc. This is a write, so all the
> > > > checks in generic_write_checks() apply, right? And the same security
> > > > issues like stripping setuid bits, etc? And we need to touch
> > > > atime on the source file, too?
> > >
> > > Yes sound like needed checks.
> > >
> > > > We've just merged 5 or so patches in 4.19-rc8 and we're ready to
> > > > merge another ~30 patch series to fix all the stuff missing from the
> > > > clone/dedupe file range operations that make them safe and robust.
> > > > It seems like copy_file_range is all the checks it needs, too?
> > >
> > > Are you proposing to not do this check now in favor of the proper work
> > > that will do all of those checks you listed above?
> >
> > No, I'm saying that if you're adding one check, there's a whole heap
> > of checks that still need to be added, *especially* if this is going
> > to fall back to page cache copy between superblocks that may have
> > different limits and constraints.
> >
> > There's security issues in this API. They need to be fixed before we
> > allow it to do more and potentially expose more problems due to it's
> > wider capability.
> 
> Before I totally give up on this feature, can you help me understand
> your concerns with allowing the generic copy_file_range via
> do_splice().

it's not do_splice_direct() i'm concerned about. It's /writing data
without adequate checks/ that I'm concerned about.
->copy_file_range() also writes data, so it needs to undergo the
same safety checks as well.

> I have mentioned I'm not a VFS expert thus I come from just looking at
> the available documentation and the code.
> 
> I don't see any restrictions on the files being passed in the
> do_splice_direct(). There are no restrictions that they must be from
> the same filesystem or file system type. But perhaps this not the
> concern you had but more about checking validity of arguments?
> 
> I have looked at Dave Wong's, if I'm not mistaken these 2 are the
> relevant patches:
> [PATCH 02/28] vfs: check file ranges before cloning files
>  -- a couple but not all checks apply to copy_file_range() .

Yes, of course - clone/dedupe have different constraints, but the
core checks are still needed for copy_file_range(). 

For example, the man page says:

EINVAL
	Requested range extends beyond the end of the source
	file; or the flags argument is not 0.

Your patch above doesn't actually check that - it only checks if the
pos_in is beyond EOF. It needs to check if pos_in + len is beyond
EOF. After checking for wraps, of course.

> [PATCH 04/28] vfs: strengthen checking of file range inputs to
> generic_remap_checks
>  -- these checks apply to the code once we fall back to the
> do_splice().

man page says:

EFBIG
       An  attempt  was made to write a file that exceeds the
       implementation-defined maximum file size or the process's
       file size limit, or to write at a position past the maximum
       allowed offset.

These conditions apply to the destination file regards of the method
used to copy the data. That's what the generic methods now check for
clone/dedupe, and need to be used here, too.

e.g. In the case of NFS, if the user ion the NFS client is not
allowed to copy a file (e.g. say user RLIMIT restrictions) then that
should not be bypassed just because the NFS client can do a server
side copy. The restriction has been placed on the local user calling
copy_file_range(), not on the server side implementation.

> Also, can you elaborate one what "security issues" are present in this
> API? Is it "stripping setuid bits" and so something like calling
> file_remove_priv() that should be done when the fallback to the
> do_splice_direct() happens?

>From 4.19-rc8:

7debbf015f58 xfs: update ctime and remove suid before cloning files

Which then got moved into the generic remap_file_range code in
Darrick's "vfs: remap helper should update destination inode
metadata" patch:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=8dde90bca6fca3736ea20109654bcf6dcf2ecf1d

We can't assume that a server side copy is going to strip setuid
bits or even update target files c/mtimes. 

> As for the atime, wouldn't the ->copy_file_range() be updating the
> file attributes? I guess for the fallback case, the attributes need to
> be updated.

Generic VFS code should take care of atime updates. Hence if the
source file needs an atime update, it should be in the generic code
and done for all copy methods.

> If those are checks/issues needed to be addressed and would then get
> the generic copy_file_range() in, I could give a go at a patch (or 2).

yes, those are the ones I'm aware of. BUt there may be more, I
haven't really looked that closely...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
