Return-Path: <vgoyal@redhat.com>
Date: Mon, 28 Jan 2019 14:22:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
Message-ID: <20190128192207.GA10240@redhat.com>
References: <CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
 <CAOQ4uxj=c9F5NNBNm+ek3NOPPpj4bh86V6WQyN1N88e76QZWdg@mail.gmail.com>
 <CAJfpegusiOjWo-dR3eM0yBWeSE0QTaDwM0-kAoo=fSyuVJgZFQ@mail.gmail.com>
 <CAOQ4uxhgK0tanvqZn9a9=q80Sc4L3GO1Nou7amU51Q66uUXhOg@mail.gmail.com>
 <CAJfpegv48DRJ4Cd40gFX+ssmNmQTtej+8SNAtzCoPtjgBnws9Q@mail.gmail.com>
 <CAOQ4uxjStG-KYaTHcaheZYcPDq7it2c_82RePFnmSzfFND_--A@mail.gmail.com>
 <CAJfpeguv8gebY_7dhOtb7LrhYPW6x3=upqakMTa3f4VuRkEgpA@mail.gmail.com>
 <CAJfpegsVy=tep29H=zWhRYCVHBd4mYO=e_181DinZUQOaetoJA@mail.gmail.com>
 <CAOQ4uxha2VNZ-Da-w6U5yxrqA3PkixXPevk9_5NvMzg4-KkWSg@mail.gmail.com>
 <CAOQ4uxiKss89-J+Wv1q9QtvMMsypKFy-ktBom_Ss9kPr7_te6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiKss89-J+Wv1q9QtvMMsypKFy-ktBom_Ss9kPr7_te6w@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Jan 27, 2019 at 08:22:50PM +0200, Amir Goldstein wrote:
> On Fri, Jan 25, 2019 at 11:18 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Fri, Jan 25, 2019 at 5:57 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Fri, Jan 25, 2019 at 2:31 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Fri, Jan 25, 2019 at 2:04 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > > > Mmm.... so now using upper page cache for write does sound so bad.
> > > > > If only we had shared cache pages ;-)
> > > > > We can treat upper page cache as a vessel for writeback and invalidate
> > > > > it upon completion, since it is *ours*.
> > > > > I'll see what I can come up with.
> > > >
> > > > Just calling ->writepage() of upper fs won't work, filesystems do
> > > > preparatory work in ->prepare_write(), etc, and those need the struct
> > > > file...  I don't think we are better off, than calling
> > > > vfs_write_iter().
> > >
> > > With the cache on the overlay, I think we need to anchor the real file
> > > in the overlay inode instead of the overlay file.  That applies to
> > > reads as well as writes.  Not sure about lifetimes, obviously it's not
> > > good to keep the real file open if there's no I/O being done.  Some
> > > heuristics will be needed, but first version could just keep the file
> > > open until the inode is evicted.
> > >
> >
> > I may be way off, but could you be over complicating this?
> > We can call vfs_write_iter() from ovl_write_end() after data has been
> > copied to overlay pages and while we still have a reference to realfile.
> > Then we copy over the dirt from overlay page cache to upper page cache.
> > When writeback comes along to overlay inode (maybe after close) we
> > only need to writeback the already dirty pages of upper.
> > Once not dirty, we can invalidate upper pages to reduce page cache
> > usage.
> >
> > And what about readpage? why do you say that this applies to reads
> > as well? Do we not have the file during readpage()? Besides, AFAIKT
> > readahead() necessitates that ->readpage() can be called on an inode
> > so we don't need more than the upper inode to for ovl_readpage().
> > The direct IO read is just an optimization, isn't it?
> >
> > I'll stick with the simple copy_page() implementation (back and forth)
> > unless you come up with a better suggestion. We will probably want
> > something more efficient later on, but I rather start with something
> > simple and working.
> >
> 
> Like this:
> https://github.com/amir73il/linux/commits/ovl-aops-wip
> 

Am I understanding it right, that we will use page cache at overlay inode
as well as upper file system. So there is duplication and memory usage
for upper files will double? If yes, this will be reason to provide
separate option for lazy copy up (Or switch to using O_DIRECT).

Vivek
