Return-Path: <david@fromorbit.com>
Date: Tue, 28 Aug 2018 09:05:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/6] ovl: respect FIEMAP_FLAG_SYNC flag
Message-ID: <20180827230555.GZ31495@dastard>
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
 <1535300717-26686-3-git-send-email-amir73il@gmail.com>
 <20180827033812.GW31495@dastard>
 <CAOQ4uxjXdSrLYT-Xy4Y9gg4=JGtoUAWyna3_FC=YR+qUkCpgXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjXdSrLYT-Xy4Y9gg4=JGtoUAWyna3_FC=YR+qUkCpgXw@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Aug 27, 2018 at 09:20:32AM +0300, Amir Goldstein wrote:
> On Mon, Aug 27, 2018 at 6:38 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Sun, Aug 26, 2018 at 07:25:13PM +0300, Amir Goldstein wrote:
> > > Stacked overlayfs fiemap operation broke xfstests that test delayed
> > > allocation (with "_test_generic_punch -d"), because ovl_fiemap()
> > > failed to write dirty pages when requested.
> > >
> > > Fixes: 9e142c4102db ("ovl: add ovl_fiemap()")
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/overlayfs/inode.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > > index e0bb217c01e2..5014749fd4b4 100644
> > > --- a/fs/overlayfs/inode.c
> > > +++ b/fs/overlayfs/inode.c
> > > @@ -467,6 +467,10 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> > >               return -EOPNOTSUPP;
> > >
> > >       old_cred = ovl_override_creds(inode->i_sb);
> > > +
> > > +     if (fieinfo->fi_flags & FIEMAP_FLAG_SYNC)
> > > +             filemap_write_and_wait(realinode->i_mapping);
> > > +
> > >       err = realinode->i_op->fiemap(realinode, fieinfo, start, len);
> >
> >
> > Where's the fiemap_check_flags() call in the overlay code to
> > indicate to userspace what functionality ovl supports?
> >
> > And, further, you can't take action on FIEMAP_FLAG_SYNC for the
> > lower filesystem file because the lower filesystem first has to
> > validate the fiemap flags passed in.
> >
> 
> The is no law against speculative syncing filesystem file pages ;-)

No, but it can cause all sorts of performance problems for users.

> Overlayfs will also fsync a file after first open for write (post copy up)
> for obvious reasons.
> 
> > So if you need to process FIEMAP_FLAG_SYNC here for the lower
> > filesystem, that implies that there is a bug in the filesystem
> > implementations and/or the VFS fiemap behaviour.
> >
> > e.g. in XFS we call iomap_fiemap(), and it does:
> >
> >         ret = fiemap_check_flags(fi, FIEMAP_FLAG_SYNC);
> >         if (ret)
> >                 return ret;
> >
> >         if (fi->fi_flags & FIEMAP_FLAG_SYNC) {
> >                 ret = filemap_write_and_wait(inode->i_mapping);
> >                 if (ret)
> >                         return ret;
> >         }
> >
> > That means you wouldn't have seen this bug on XFS. Ext4 does not do
> > this, so it would appear not to observe the FIEMAP_FLAG_SYNC
> > behaviour as it was asked to perform.
> 
> True. overlay over xfs didn't fail those tests.
> 
> > Ah, I see - the problem is ioctl_fiemap() - it assumes that it can
> > run the flush without first allowing the filesystem to check if that
> > flag is supported.
> >
> > So, shouldn't the correct fix be to move the FIEMAP_FLAG_SYNC from
> > the VFS down into the filesystem implementations after they have
> > checked the flags field for supported functionality? That way ovl
> > doesn't need special case hacks to replicate VFS behaviour...
> >
> 
> IMO, one line of replicating VFS behavior is better than duplicating
> code that is run 99% of the time from VFS into all fs implementations.

Except when it violates the documented interface behaviour.

That is: filesystems can choose to reject FIEMAP_FLAG_SYNC with
EBADR when it is set in the request (same as they can reject
FIEMAP_FLAG_XATTR), and that means issuing it unconditionally in any
fiemap code without first checking that it is supported is a *bug*.

FWIW, in looking at this  I note that fiemap grew new flags without
adding them to the COMPAT mask, nor did the filesystems check that
they are valid flags. i.e., the FIEMAP_FLAGS_COMPAT mechanism was
subverted by the addition of FIEMAP_FLAG_CACHE - ext4 uses the flag
and returns before it does it's fiemap_check_flags() call to check
for supported flags because that check would fail if
FIEMAP_FLAG_CACHE is set...

<sigh>

Bugs everywhere. How does any of this shit even work?

> Question is whether syncing file pages can be considered harmfull
> when issuing FIEMAP_FLAG_XATTR or FIEMAP_FLAG_CACHE?

If observing the current state of the system can screw up system
performance (like unnecessarily issuing bulk writeback) then it can
be considered harmful.

> It can't be considered DoS, because same user can call fsync().

It doesn't have to be a DoS to be harmful. Users don't tend to walk
their filesystem and issue fsync on every file (we have sync(1) for
that) but maintenance utilities do walk and map extents for every
file...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
