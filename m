MIME-Version: 1.0
Date: Tue, 26 Feb 2019 22:20:44 +0100
References: <20190226152739.26408-1-amir73il@gmail.com>
	<CAJfpegt8sHTJ-CRZhQ+hNj7XWASKa4L0HUDcsyf2vM+BYs0aag@mail.gmail.com>
	<CAOQ4uxgsKbOA3nruProL=yG1rk4XaMrARVSdYja7z7KvY9Eedw@mail.gmail.com>
	<CAJfpegskJEL=5ORX6DcnXTkU39bk85ctV8q9z+xkp1AD7GD=1A@mail.gmail.com>
	<CAOQ4uxgHac1hO-YcquTjoVWdBRc9O64JhqPXBQxHr=1aZNiiHg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgHac1hO-YcquTjoVWdBRc9O64JhqPXBQxHr=1aZNiiHg@mail.gmail.com>
Message-ID: <CAJfpegtmcYdTM0OjYyMUjK_nZnLrdE=z02TFe40sZuKCpQcXkA@mail.gmail.com>
Subject: Re: [PATCH] ovl: support stacked SEEK_HOLE/SEEK_DATA
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eddie Horng <eddiehorng.tw@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Feb 26, 2019 at 10:16 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Feb 26, 2019 at 10:32 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Tue, Feb 26, 2019 at 6:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Tue, Feb 26, 2019 at 6:07 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Tue, Feb 26, 2019 at 4:27 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > Overlay file f_pos is the master copy that is preserved
> > > > > through copy up, but only real fs knows how to SEEK_HOLE/
> > > > > SEEK_DATA. So we copy f_pos from overlay file, perform the seek
> > > > > on real file and copy f_pos back to overlay file.
> > > > >
> > > > > Fixes: d1d04ef8572b ("ovl: stack file ops")
> > > > > Reported-by: Eddie Horng <eddiehorng.tw@gmail.com>
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > > >
> > > > > Miklos,
> > > > >
> > > > > I verified no regressions with xfstests quick tests.
> > > > > The improved generic/seek tests that I posted to fstests
> > > > > are failing on master and passing with this fix.
> > > > >
> > > > > Thanks,
> > > > > Amir.
> > > > >
> > > > >  fs/overlayfs/file.c | 27 +++++++++++++++++++++++----
> > > > >  1 file changed, 23 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > > > > index 84dd957efa24..0d472940ce9e 100644
> > > > > --- a/fs/overlayfs/file.c
> > > > > +++ b/fs/overlayfs/file.c
> > > > > @@ -145,11 +145,30 @@ static int ovl_release(struct inode *inode, struct file *file)
> > > > >
> > > > >  static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
> > > > >  {
> > > > > -       struct inode *realinode = ovl_inode_real(file_inode(file));
> > > > > +       struct fd real;
> > > > > +       const struct cred *old_cred;
> > > > > +       ssize_t ret;
> > > > >
> > > > > -       return generic_file_llseek_size(file, offset, whence,
> > > > > -                                       realinode->i_sb->s_maxbytes,
> > > > > -                                       i_size_read(realinode));
> > > > > +       ret = ovl_real_fdget(file, &real);
> > > > > +       if (ret)
> > > > > +               return ret;
> > > > > +
> > > > > +       /*
> > > > > +        * Overlay file f_pos is the master copy that is preserved
> > > > > +        * through copy up, but only real fs knows how to SEEK_HOLE/
> > > > > +        * SEEK_DATA.
> > > > > +        */
> > > > > +       real.file->f_pos = file->f_pos;
> > > >
> > > > Parallel invocations of ovl_llseek would mean trouble.   I suggest
> > > > doing generic_file_llseek_size for SET/CUR/END and doing the recursive
> > > > one under ovl inode lock for HOLE/DATA.
> > > >
> > >
> > > OK. What about Eddie's question:
> > > If realinode is nested overlay inode, then realinode->i_sb->s_maxbytes
> > > will not reflect the "real" inode's maxbytes.
> > > Not to mention other crazy things that filesystems may do for SET/CUR/END.
> > > Take ext4_llseek() for example, for the less common case (ext3 format inode)
> > > the value of inode->i_sb->s_maxbytes is not used as maxbytes, but a smaller
> > > value.
> > >
> > > Would it be worse or better than exclusive lock if we allocate a new
> > > realfile instance for every call to ovl_llseek? (as we do anyway for the
> > > transient state of ro fd of file that was copied up).
> >
> > Hell knows. Simplest is definitely the exclusive inode lock.   Then we
> > can look at optimizing that...  I don't think lseek would be
> > particularly performance sensitive: those would be using the
> > pread/pwrite interfaces anyway.
> >
>
> Just to be clear, so exclusive inode lock and recursive for any type of seek?
> To be on the safe side?

Yes.  As a trivial optimization SEEK_CUR/0 (return current pos) could
be done without messing with underlying fs.  Probably same for
SEEK_SET/0.

Looking ahead, inode lock is definitely excessive, since we are not
doing anything to the inode here, so ideally this would be a per-file
mutex, but we've nowhere to put such a thing at the moment.

Thanks,
Miklos
