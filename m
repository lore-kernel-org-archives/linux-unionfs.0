Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
 <1535300717-26686-7-git-send-email-amir73il@gmail.com> <CAJfpegv50HELSZuwt9gGjgSyB+4aPbiTncc-yBNqUVgTLNHaXw@mail.gmail.com>
 <CAOQ4uxioVN8iL4JTz4B5gpSmyEu36yiQD1KHQj+D-iPDfKtGJQ@mail.gmail.com> <20180827042343.GY31495@dastard>
In-Reply-To: <20180827042343.GY31495@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Aug 2018 09:37:09 +0300
Message-ID: <CAOQ4uxhjoe00e36AdbkS-M2ROQBNh5GfyBNcMcaFcXK6jh0Unw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] vfs: fix sync_file_range syscall on an overlayfs file
Content-Type: text/plain; charset="UTF-8"
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Aug 27, 2018 at 7:25 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Aug 27, 2018 at 12:55:36AM +0300, Amir Goldstein wrote:
> > On Sun, Aug 26, 2018 at 10:34 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Sun, Aug 26, 2018 at 6:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > For an overlayfs file/inode, page io is operating on the real underlying
> > > > file, so sync_file_range() should operate on the real underlying file
> > > > mapping to take affect.
> > >
> > > The man page tells us that this syscall basically gives no guarantees
> > > at all and shouldn't be used in portable programs.
> > >
> >
> > Oh no. You need to understand the context of this very bold warning.
> > The warning speaks lengthy about durability and it rightfully states that
> > you have no way of knowing what data will persist after crash.
> > This is relevant for application developers looking for durability, but that is
> > not the only use case for sync_file_range().
> >
> > I have an application using sync_file_range() for consistency, which is not
> > the same game as durability.
> >
> > They will tell you that the only safe way to guaranty consistency of data in a
> > new file is to do:
> > open(...O_TMPFILE) or open(TEMPFILE, ...)
> > write()
> > fsync()
> > link() or rename()
> >
> > Then you don't know if file will exist after crash, but if it will
> > exist its content
> > will be consistent.
> >
> > But the fact is that if you need to do many of those new file writes,
> > many fsync()
> > calls cost much more than the cost of syncing the inode pages, because every
> > new file writes metadata and metadata forces fsync to flush the journal.
> >
> > Amplify that times number of containers and you have every fsync() on every
> > file in every overlayfs container all slamming of the underlying fs journal.
> >
> > The fsync() in the snippet above can be safely replaced with sync_file_range()
> > eliminating all cost of excessive journal flushes without loosing any
> > consistency
> > guaranty on "strictly ordered metadata" filesystems - and all major filesystems
> > today are.
>
> Wrong.
>
> Nice story, but wrong.
>
> sync_file_range does this:
>
>         if (flags & SYNC_FILE_RANGE_WRITE) {
>                 ret = __filemap_fdatawrite_range(mapping, offset, endbyte,
>                                                  WB_SYNC_NONE);
>         ......
>
> Note the use of "WB_SYNC_NONE"?
>
> This writeback type provides no guarantees that the entire range is
> written back.  Writeback can skip pages for any reason when it is
> set - to avoid blocking, lock contention, maybe complex allocation
> is required, etc. WB_SYNC_NONE doesn't even tag pages in
> write_cache_pages() so there's no way to ensure no pages are missed
> or retried when set_page_writeback_keepwrite() is called due to
> partial page writeback requiring another writeback call to the page
> to finish writeback. It doesn't try to write back newly dirty
> pages that are already under writeback. And so on.
>
> sync_file_range() provides *no guarantees* about getting your data
> to disk at all and /never has/.
>

Thanks for clarifying that!
I guess we'll need to go and re-fix concurrent _xfs_log_force()
optimization ;-/

> > > So, I'd just let the non-functionality be for now.   If someone
> > > complains of a regression (unlikely) we can look into it.
> >
> > I would like to place a complaint :-)
> >
> > I guess we could go for f_op->sync_ranges()?
>
> No. sync_file_range() needs to die.
>

I guess if we really wanted we could add a new FADV_WILLSYNC...
Anyway, I am withdrawing the complaint.

Thanks,
Amir.
