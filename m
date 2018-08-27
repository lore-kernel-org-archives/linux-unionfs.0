Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
 <1535300717-26686-3-git-send-email-amir73il@gmail.com> <20180827033812.GW31495@dastard>
In-Reply-To: <20180827033812.GW31495@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Aug 2018 09:20:32 +0300
Message-ID: <CAOQ4uxjXdSrLYT-Xy4Y9gg4=JGtoUAWyna3_FC=YR+qUkCpgXw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] ovl: respect FIEMAP_FLAG_SYNC flag
Content-Type: text/plain; charset="UTF-8"
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Aug 27, 2018 at 6:38 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sun, Aug 26, 2018 at 07:25:13PM +0300, Amir Goldstein wrote:
> > Stacked overlayfs fiemap operation broke xfstests that test delayed
> > allocation (with "_test_generic_punch -d"), because ovl_fiemap()
> > failed to write dirty pages when requested.
> >
> > Fixes: 9e142c4102db ("ovl: add ovl_fiemap()")
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/inode.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index e0bb217c01e2..5014749fd4b4 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -467,6 +467,10 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> >               return -EOPNOTSUPP;
> >
> >       old_cred = ovl_override_creds(inode->i_sb);
> > +
> > +     if (fieinfo->fi_flags & FIEMAP_FLAG_SYNC)
> > +             filemap_write_and_wait(realinode->i_mapping);
> > +
> >       err = realinode->i_op->fiemap(realinode, fieinfo, start, len);
>
>
> Where's the fiemap_check_flags() call in the overlay code to
> indicate to userspace what functionality ovl supports?
>
> And, further, you can't take action on FIEMAP_FLAG_SYNC for the
> lower filesystem file because the lower filesystem first has to
> validate the fiemap flags passed in.
>

The is no law against speculative syncing filesystem file pages ;-)
Overlayfs will also fsync a file after first open for write (post copy up)
for obvious reasons.

> So if you need to process FIEMAP_FLAG_SYNC here for the lower
> filesystem, that implies that there is a bug in the filesystem
> implementations and/or the VFS fiemap behaviour.
>
> e.g. in XFS we call iomap_fiemap(), and it does:
>
>         ret = fiemap_check_flags(fi, FIEMAP_FLAG_SYNC);
>         if (ret)
>                 return ret;
>
>         if (fi->fi_flags & FIEMAP_FLAG_SYNC) {
>                 ret = filemap_write_and_wait(inode->i_mapping);
>                 if (ret)
>                         return ret;
>         }
>
> That means you wouldn't have seen this bug on XFS. Ext4 does not do
> this, so it would appear not to observe the FIEMAP_FLAG_SYNC
> behaviour as it was asked to perform.
>

True. overlay over xfs didn't fail those tests.

> Ah, I see - the problem is ioctl_fiemap() - it assumes that it can
> run the flush without first allowing the filesystem to check if that
> flag is supported.
>
> So, shouldn't the correct fix be to move the FIEMAP_FLAG_SYNC from
> the VFS down into the filesystem implementations after they have
> checked the flags field for supported functionality? That way ovl
> doesn't need special case hacks to replicate VFS behaviour...
>

IMO, one line of replicating VFS behavior is better than duplicating
code that is run 99% of the time from VFS into all fs implementations.
Question is whether syncing file pages can be considered harmfull
when issuing FIEMAP_FLAG_XATTR or FIEMAP_FLAG_CACHE?
It can't be considered DoS, because same user can call fsync().

But hey! I can re-write my story about sync_file_ranges() now,
with fiemap(FIEMAP_FLAG_CACHE) can't I? ;-)

Cheers,
Amir.
