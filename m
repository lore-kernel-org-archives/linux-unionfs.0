MIME-Version: 1.0
In-Reply-To: <CAOQ4uximXwPiHySiRxKi4UYxdBt=Y8jj38h0ybrrPGCG0F60nQ@mail.gmail.com>
References: <490ed00a-7e41-71a5-4318-cc95b36a1b2e@gmx.com>
	<CAOQ4uximXwPiHySiRxKi4UYxdBt=Y8jj38h0ybrrPGCG0F60nQ@mail.gmail.com>
Date: Mon, 8 Oct 2018 16:41:24 +0200
Message-ID: <CAJfpegvJU32_9_mVh7kem0s529-8Qs02fPSr4ChCC3ZJ2pRhLw@mail.gmail.com>
Subject: Re: Postpone copy-up until first real write?
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jun 29, 2018 at 12:28 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jun 29, 2018 at 6:35 AM, cgxu519 <cgxu519@gmx.com> wrote:
>> Hi guys,
>>
>> I have a simple question about copy-up timing after implementing stacked
>> file operation.
>> Could we postpone copy-up until first real write happens?
>>
>> The background is consuming much time on open is unexpected for some of our
>> applications.
>>
>
> I need this behavior as well for snapshots.
> On first glance it looks feasible to me.
> Seems like we could relax copy up on open(O_RDWR) if there were no special
> open flags (O_TRUNC, O_CREATE, O_APPEND...), then mask out O_ACCMODE
> if opening a lower inode and defer copy up to ovl_real_fdget_meta() in case the
> O_ACCMODE flags of file and real->file don't match.
>
> Then we can introduce ovl_real_fdget_read() call to be used in ovl_read_iter()
> and ovl_copyfile() (in_file) in which cases the mismatch O_ACCMODE flags
> doesn't need to be corrected with copy up.
>
> Miklos? Does this sound reasonable to you?

So now that the stacked file ops are merged we can take a look at
these somewhat related issues:

 - shared r/o mmap of lower file
 - delayed copy up until first write
 - delayed copy up until first write fault on shared r/w mmap.

My idea would be to have three (or four) states for each in core overlay inode:

  LOWER:  opened only for read or not opened at all and mmaped with
MAP_PRIVATE  or not mapped at all
  LOWER_SHARED: opened for read/write or mmaped MAP_SHARED
  UPPER_SHARED: copied up
  (UPPER:  copied up and all open files referring to the inode were
opened in the UPPER state)

The LOWER_SHARED state is basically in anticipation of copy-up,
without actually committing to the upper layer.

The UPPER state could just be an optimization, that would be otherwise
equivalent to the UPPER_SHARED state.

I/O paths for the different states would be:

LOWER/UPPER: just like now: read/write are stacked, mmap goes directly
to "realfile"
*_SHARED: just like a normal filesystem: uses
generic_file_{read|write}_iter, generic_mmap, defines own a_ops,
vm_ops.

So basically the _SHARED mode loses the cache sharing property of
LOWER, but gains the consistency offered by a unified page cache
regardless of which layer the file is stored in.

Thoughts?

Does this make sense wrt. overlay-snapshots?

One detail is whether we should ever make the LOWER_SHARED -> LOWER
transition while the inode is cached.  My gut feeling is that we
probably needn't bother.

Also I'm not sure we'd actually need the UPPER state at all, since (if
implemented right) UPPER_SHARED should offer a very similar cache
footprint and performance.

Thanks,
Miklos
