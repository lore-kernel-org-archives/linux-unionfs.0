Return-Path: <david@fromorbit.com>
Date: Wed, 31 Oct 2018 10:40:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 02/11] VFS: copy_file_range check validity of input
 source offset
Message-ID: <20181030234019.GP6311@dastard>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-4-olga.kornievskaia@gmail.com>
 <20181027092750.GL6311@dastard>
 <CAN-5tyEeMrRVUyP61Vv-dwFUvm7q55Q3=NVJkeZN+XoCcAOCDQ@mail.gmail.com>
 <20181030090344.GN6311@dastard>
 <CAN-5tyEfYcSvgzhftM7r8YoB7KQDiJnJXQPTE9pcML6BRSbbYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN-5tyEfYcSvgzhftM7r8YoB7KQDiJnJXQPTE9pcML6BRSbbYA@mail.gmail.com>
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Oct 30, 2018 at 09:40:09AM -0400, Olga Kornievskaia wrote:
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
> Sounds like you are arguing that enabling generic copy_file_range()
> via do_splice() isn't a good thing without those checks.

It's already enabled for filesystems that don't provide
->remap_file_range or ->copy_file_range. Your changes don't
introduce new problems, that just made me aware that there are
serious problems here, too.

The problem we've got now is that filesystem that use
->remap_file_range() are going to have very different error
detection and handling when Darrick's patchset is merged. They are
going to reject setuid files, obey rlimit, LFS, superblock max
sizes, etc. while ->copy_file_range() and do_splice_direct() methods
are not.

That really needs to be fixed.

> I'm totally
> OK with removing this functionality. As I mentioned earlier I added it
> as I thought it was beneficial and I assumed that do_splice() was a
> generic enough API to handle what was needed.

That doesn't fix the problems that are already there. :/

> > > I can not volunteer
> > > to provide this comprehensive check.
> >
> > Why not?
> 
> I don't have the expertise in the VFS code.

Just like all the other people without VFS expertise who fix
problems introduced in code written by people without VFS expertise.
I'm certainly no VFS expert, either, I've just seen, found and
helped fix a bunch of serious problems in the VFS dedupe/reflink
code that were uncovered by data corruptions on XFS filesystems.

That's part of being a filesystem developer - the VFS is "common
property" of all the filesystems and everyone has to do their bit to
maintain it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
