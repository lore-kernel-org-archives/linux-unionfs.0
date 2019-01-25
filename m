MIME-Version: 1.0
Date: Fri, 25 Jan 2019 13:21:52 +0100
References: <20190122123457.10600-1-amir73il@gmail.com>
	<CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
	<CAOQ4uxj=c9F5NNBNm+ek3NOPPpj4bh86V6WQyN1N88e76QZWdg@mail.gmail.com>
	<CAJfpegusiOjWo-dR3eM0yBWeSE0QTaDwM0-kAoo=fSyuVJgZFQ@mail.gmail.com>
	<CAOQ4uxhgK0tanvqZn9a9=q80Sc4L3GO1Nou7amU51Q66uUXhOg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhgK0tanvqZn9a9=q80Sc4L3GO1Nou7amU51Q66uUXhOg@mail.gmail.com>
Message-ID: <CAJfpegv48DRJ4Cd40gFX+ssmNmQTtej+8SNAtzCoPtjgBnws9Q@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jan 25, 2019 at 12:24 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > ...Luckily, I have implemented ./run --ov --recycle way back, otherwise we
> > > would have had very poor test coverage for persistency of overlayfs writes.
> > >
> > > So we currently have 6 xfstests failing on write persistency:
> > > overlay/018 overlay/032 overlay/044 overlay/047 overlay/050 overlay/051
> > >
> > > and 2 unionmount tests (over /base xfs):
> > > ./run --ov --samefs --recycle rename-new-pop-dir
> > > ./run --ov --samefs --recycle rename-mass-dir
> >
> > Great progress.  Thanks!
> >
> > I don't think you need to mess with dcache flushing, since this is all
> > kernel (page cache) pages without any possible dcache aliasing issues
> > that plague user pages.  So a simple copy_page() should do.
> >
>
> Pardon my ignorance, but couldn't pages be mapped to user?

Well, yes, but we don't really care about coherency with upper shared
mappings (upper is *our* backing store)

> Anyway, it seems that generic_file_buffered_read() does
> flush_dcache_page() if needed, so we need not worry about it.
>
> > It would be even better to do it with O_DIRECT to remove cache
> > duplication.  Something like the attached...
> >
>
> Yes, definitely better. Thanks for the patch!
>
> You'll be happy to know that the two unionmount tests fails on tmpfs
> as expected (or maybe you already checked that).
>
> I do get one new lockdep splat from xfstest, something we need to
> look into (attached 013.dmesg).

Yeah, I suspected we were going to hit mmap sem lock ordering issue in
readpage.  The easy way out is to submit reads through a workqueue.
Doing the actual read in an async manner is the right way anyway,
otherwise we'd be holding up mmap sem way too long.

> One questions about your patch:
> Skipping the ovl_change_flags() for upper realfile, that's just a
> quick hack, right?
> I'll need to fix this up properly.

Yes.

Speaking of hacks: I don't really like the O_RDWR | O_WRONLY thing.  I
understand why it works, but I think handling it explicitly would be
much cleaner.

> About the way forward, implementing writepage() should be quite straight forward
> from this, so I will add write support re-work the series and re-post.

The one issue is, we don't have the open file available from
writepage(s) like we do in readpage(s).   In fact leaving the
writeback till after close is an important optimization (e.g.
compilers write temporary files, that are then immediately deleted, so
no need to actually do any writeback).

That opens some interesting questions about how to do the writeback...

>
> I think I can now see how to implement the LOWER -> LOWER_SHARED ->
> UPPER_SHARED transitions, but that will require some more juggling of
> realfile flags etc.
>
> With the current implementation of UPPER_SHARED only we can gain:
> - No copy up latency on open() with metacopy=on
> - Very improved ovl_sync_fs() (no longer sync all containers on syncfs(2))
>
> Do you think we should aim for merging just UPPER_SHARED in dev
> cycle to hash out the bugs of overlay page cache or aim for merging
> LOWER_SHARED+UPPER_SHARED when it is ready?

Good plan.

Thanks,
Miklos
