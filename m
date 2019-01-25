MIME-Version: 1.0
Date: Fri, 25 Jan 2019 14:31:27 +0100
References: <20190122123457.10600-1-amir73il@gmail.com>
	<CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
	<CAOQ4uxj=c9F5NNBNm+ek3NOPPpj4bh86V6WQyN1N88e76QZWdg@mail.gmail.com>
	<CAJfpegusiOjWo-dR3eM0yBWeSE0QTaDwM0-kAoo=fSyuVJgZFQ@mail.gmail.com>
	<CAOQ4uxhgK0tanvqZn9a9=q80Sc4L3GO1Nou7amU51Q66uUXhOg@mail.gmail.com>
	<CAJfpegv48DRJ4Cd40gFX+ssmNmQTtej+8SNAtzCoPtjgBnws9Q@mail.gmail.com>
	<CAOQ4uxjStG-KYaTHcaheZYcPDq7it2c_82RePFnmSzfFND_--A@mail.gmail.com>
In-Reply-To: <CAOQ4uxjStG-KYaTHcaheZYcPDq7it2c_82RePFnmSzfFND_--A@mail.gmail.com>
Message-ID: <CAJfpeguv8gebY_7dhOtb7LrhYPW6x3=upqakMTa3f4VuRkEgpA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jan 25, 2019 at 2:04 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > One questions about your patch:
> > > Skipping the ovl_change_flags() for upper realfile, that's just a
> > > quick hack, right?
> > > I'll need to fix this up properly.
> >
> > Yes.
> >
> > Speaking of hacks: I don't really like the O_RDWR | O_WRONLY thing.  I
> > understand why it works, but I think handling it explicitly would be
> > much cleaner.
> >
>
> I figured... in fact, it is not at all interesting to propagate f_flags
> to copy up helpers, so I was thinking of translating them to simple
> copy_up_flags *before* the call to ovl_maybe_copy_up(), i.e.:
>
> OVL_COPY_UP = 1,
> OVL_COPY_UP_DATA = 2,
> OVL_COPY_UP_WITH_DATA = 3,

Much better.

>
> > > About the way forward, implementing writepage() should be quite straight forward
> > > from this, so I will add write support re-work the series and re-post.
> >
> > The one issue is, we don't have the open file available from
> > writepage(s) like we do in readpage(s).   In fact leaving the
> > writeback till after close is an important optimization (e.g.
> > compilers write temporary files, that are then immediately deleted, so
> > no need to actually do any writeback).
> >
> > That opens some interesting questions about how to do the writeback...
> >
>
> Mmm.... so now using upper page cache for write does sound so bad.
> If only we had shared cache pages ;-)
> We can treat upper page cache as a vessel for writeback and invalidate
> it upon completion, since it is *ours*.
> I'll see what I can come up with.

Just calling ->writepage() of upper fs won't work, filesystems do
preparatory work in ->prepare_write(), etc, and those need the struct
file...  I don't think we are better off, than calling
vfs_write_iter().

Thanks,
Miklos
