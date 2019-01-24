Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190122123457.10600-1-amir73il@gmail.com> <CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 25 Jan 2019 00:35:02 +0200
Message-ID: <CAOQ4uxj=c9F5NNBNm+ek3NOPPpj4bh86V6WQyN1N88e76QZWdg@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Jan 24, 2019 at 7:18 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> >
> > Can you please point me in the direction of how to implement proper
> > aops? Or better yet, send me a demo patch?
> > I figure we need to call vfs_iter_read/vfs_iter_write of real file
> > with IOCB_DIRECT for page io? But I am very uncertain about locking
> > order requirements and whether there is already some infrastructure
> > that we can use (some splice variant)?
> >
> > Any other thoughts?
> >
>
> Miklos,
>
> I've made a small progress.
>
> Pushed two more commits to ovl-lazy-copyup-wip:
> ea9a0083d1ed - ovl: readahead upper inode page cache on overlay page fault
> d1ff6e6366d5 - ovl: implement overlay stacked readpage

Pushed two more:
838c119934a2 - ovl: implement write_begin/write_end aops
44b9e89154ba - ovl: return overlay inode i_size for stat()

>
> That implements readpage by reading and copying from upper page cache.
>
> With that change, the basic unionmount test on tmpfs passes.

That is not surprising. overlay filemap ops are disabled for upper
tmpfs in current
implementation, because tmpfs has no readpage().

> With unionmount over xfs, tests fail because partial page write
> is not working correctly, although mmap partial write works well.
>

But that is fixed now, so ./run --ov --samefs also passes over xfs.
Which says something bad about our test coverage...

> I will try to follow similar pattern to implement writepage by copy to
> upper page cache.
>

...Luckily, I have implemented ./run --ov --recycle way back, otherwise we
would have had very poor test coverage for persistency of overlayfs writes.

So we currently have 6 xfstests failing on write persistency:
overlay/018 overlay/032 overlay/044 overlay/047 overlay/050 overlay/051

and 2 unionmount tests (over /base xfs):
./run --ov --samefs --recycle rename-new-pop-dir
./run --ov --samefs --recycle rename-mass-dir

Thanks,
Amir.
