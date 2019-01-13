Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <490ed00a-7e41-71a5-4318-cc95b36a1b2e@gmx.com> <CAOQ4uximXwPiHySiRxKi4UYxdBt=Y8jj38h0ybrrPGCG0F60nQ@mail.gmail.com>
 <CAJfpegvJU32_9_mVh7kem0s529-8Qs02fPSr4ChCC3ZJ2pRhLw@mail.gmail.com>
In-Reply-To: <CAJfpegvJU32_9_mVh7kem0s529-8Qs02fPSr4ChCC3ZJ2pRhLw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 13 Jan 2019 13:25:00 +0200
Message-ID: <CAOQ4uxg=Qzau99ZWwNRoEHAKgpMTapDFxjQhCE+ntEbV2AFVOg@mail.gmail.com>
Subject: Re: Postpone copy-up until first real write?
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
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

Getting back to this with some more questions...

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

These 3 issues map closely together, but do not cover all "delayed copy up"
cases. Even if we do implement copy up on first write fault, we'd still need
to perform delayed copy up for fallocate(),clone_range(),dedupe_range(),
so perhaps my suggestion above for simpler(?) first step implementation of
"delayed copy up until first write" without bundling it together with the
shared maps issues still makes some sense?

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
>

Did you give any consideration to the locking order of copy up
from write fault context?

I suppose you are aware of this hence the proposal of pre_mmap op:
https://marc.info/?l=linux-fsdevel&m=152760695502640&w=2

Do we gain anything (simplicity? relaxed locking order) if we always
copy up metadata on open O_RDWR and only delay data copy up
until first write/page fault?

Chengguang,

For your use case, is it acceptable if we copy up metadata
(and parents) before first write?

Anyway, if no one else is working on this I am willing to take
a swing at it, but it seems to me like it would be best to leave
stacked a_ops for phase two. Thoughts?

Thanks,
Amir.
