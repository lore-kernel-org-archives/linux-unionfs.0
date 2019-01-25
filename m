MIME-Version: 1.0
Date: Fri, 25 Jan 2019 16:56:54 +0100
References: <20190122123457.10600-1-amir73il@gmail.com>
	<CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
	<CAOQ4uxj=c9F5NNBNm+ek3NOPPpj4bh86V6WQyN1N88e76QZWdg@mail.gmail.com>
	<CAJfpegusiOjWo-dR3eM0yBWeSE0QTaDwM0-kAoo=fSyuVJgZFQ@mail.gmail.com>
	<CAOQ4uxhgK0tanvqZn9a9=q80Sc4L3GO1Nou7amU51Q66uUXhOg@mail.gmail.com>
	<CAJfpegv48DRJ4Cd40gFX+ssmNmQTtej+8SNAtzCoPtjgBnws9Q@mail.gmail.com>
	<CAOQ4uxjStG-KYaTHcaheZYcPDq7it2c_82RePFnmSzfFND_--A@mail.gmail.com>
	<CAJfpeguv8gebY_7dhOtb7LrhYPW6x3=upqakMTa3f4VuRkEgpA@mail.gmail.com>
In-Reply-To: <CAJfpeguv8gebY_7dhOtb7LrhYPW6x3=upqakMTa3f4VuRkEgpA@mail.gmail.com>
Message-ID: <CAJfpegsVy=tep29H=zWhRYCVHBd4mYO=e_181DinZUQOaetoJA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jan 25, 2019 at 2:31 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Fri, Jan 25, 2019 at 2:04 PM Amir Goldstein <amir73il@gmail.com> wrote:

> > Mmm.... so now using upper page cache for write does sound so bad.
> > If only we had shared cache pages ;-)
> > We can treat upper page cache as a vessel for writeback and invalidate
> > it upon completion, since it is *ours*.
> > I'll see what I can come up with.
>
> Just calling ->writepage() of upper fs won't work, filesystems do
> preparatory work in ->prepare_write(), etc, and those need the struct
> file...  I don't think we are better off, than calling
> vfs_write_iter().

With the cache on the overlay, I think we need to anchor the real file
in the overlay inode instead of the overlay file.  That applies to
reads as well as writes.  Not sure about lifetimes, obviously it's not
good to keep the real file open if there's no I/O being done.  Some
heuristics will be needed, but first version could just keep the file
open until the inode is evicted.

Thanks,
Miklos
