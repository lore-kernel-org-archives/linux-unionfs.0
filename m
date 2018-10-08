Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <490ed00a-7e41-71a5-4318-cc95b36a1b2e@gmx.com> <CAOQ4uximXwPiHySiRxKi4UYxdBt=Y8jj38h0ybrrPGCG0F60nQ@mail.gmail.com>
 <CAJfpegvJU32_9_mVh7kem0s529-8Qs02fPSr4ChCC3ZJ2pRhLw@mail.gmail.com>
In-Reply-To: <CAJfpegvJU32_9_mVh7kem0s529-8Qs02fPSr4ChCC3ZJ2pRhLw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 8 Oct 2018 23:23:01 +0300
Message-ID: <CAOQ4uxg4qOebcEgqz7XCqoQhF84UjJhLJpuwjmeX_UJ8eAw2+g@mail.gmail.com>
Subject: Re: Postpone copy-up until first real write?
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chengguang Xu <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Oct 8, 2018 at 5:41 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Fri, Jun 29, 2018 at 12:28 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Fri, Jun 29, 2018 at 6:35 AM, cgxu519 <cgxu519@gmx.com> wrote:
> >> Hi guys,
> >>
> >> I have a simple question about copy-up timing after implementing stacked
> >> file operation.
> >> Could we postpone copy-up until first real write happens?
> >>
> >> The background is consuming much time on open is unexpected for some of our
> >> applications.
> >>
> >
> > I need this behavior as well for snapshots.
> > On first glance it looks feasible to me.
> > Seems like we could relax copy up on open(O_RDWR) if there were no special
> > open flags (O_TRUNC, O_CREATE, O_APPEND...), then mask out O_ACCMODE
> > if opening a lower inode and defer copy up to ovl_real_fdget_meta() in case the
> > O_ACCMODE flags of file and real->file don't match.
> >
> > Then we can introduce ovl_real_fdget_read() call to be used in ovl_read_iter()
> > and ovl_copyfile() (in_file) in which cases the mismatch O_ACCMODE flags
> > doesn't need to be corrected with copy up.
> >
> > Miklos? Does this sound reasonable to you?
>
> So now that the stacked file ops are merged we can take a look at
> these somewhat related issues:
>
>  - shared r/o mmap of lower file
>  - delayed copy up until first write
>  - delayed copy up until first write fault on shared r/w mmap.
>
> My idea would be to have three (or four) states for each in core overlay inode:
>
>   LOWER:  opened only for read or not opened at all and mmaped with
> MAP_PRIVATE  or not mapped at all
>   LOWER_SHARED: opened for read/write or mmaped MAP_SHARED
>   UPPER_SHARED: copied up
>   (UPPER:  copied up and all open files referring to the inode were
> opened in the UPPER state)
>
> The LOWER_SHARED state is basically in anticipation of copy-up,
> without actually committing to the upper layer.
>
> The UPPER state could just be an optimization, that would be otherwise
> equivalent to the UPPER_SHARED state.
>
> I/O paths for the different states would be:
>
> LOWER/UPPER: just like now: read/write are stacked, mmap goes directly
> to "realfile"
> *_SHARED: just like a normal filesystem: uses
> generic_file_{read|write}_iter, generic_mmap, defines own a_ops,
> vm_ops.
>
> So basically the _SHARED mode loses the cache sharing property of
> LOWER, but gains the consistency offered by a unified page cache
> regardless of which layer the file is stored in.
>
> Thoughts?

Sounds good and wishfully not too complicated?
I am not familiar enough with mm to understand what we are up
against.

Does IO from upper fs backing inode goes directly to overlay inode
page cache or first to upper fs inode page cache and then moving
pages to overlay inode page cache?
Am I over complicating this?
I suppose sharing pages with LOWER left for another time?

>
> Does this make sense wrt. overlay-snapshots?
>

Snapshots needs the a_ops/vm_ops to COW on page faults
and need delayed copy up on first write (after snapshot take),
so all this will be very useful.

> One detail is whether we should ever make the LOWER_SHARED -> LOWER
> transition while the inode is cached.  My gut feeling is that we
> probably needn't bother.
>
> Also I'm not sure we'd actually need the UPPER state at all, since (if
> implemented right) UPPER_SHARED should offer a very similar cache
> footprint and performance.
>

If we don't have UPPER state then we won't need to call
sync_filesystem(upper_sb) in ovl_sync_fs(), only
sb->s_op->sync_fs(), right? so that is a win for simplicity.

Same for implementing ovl_freeze(). It should mostly "just work".
Snapshots need freeze, but snapshots can turn off the UPPER state
optimization if it is at all implemented.

Thanks,
Amir.
