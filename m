Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
 <CAOQ4uxj=c9F5NNBNm+ek3NOPPpj4bh86V6WQyN1N88e76QZWdg@mail.gmail.com>
 <CAJfpegusiOjWo-dR3eM0yBWeSE0QTaDwM0-kAoo=fSyuVJgZFQ@mail.gmail.com>
 <CAOQ4uxhgK0tanvqZn9a9=q80Sc4L3GO1Nou7amU51Q66uUXhOg@mail.gmail.com>
 <CAJfpegv48DRJ4Cd40gFX+ssmNmQTtej+8SNAtzCoPtjgBnws9Q@mail.gmail.com>
 <CAOQ4uxjStG-KYaTHcaheZYcPDq7it2c_82RePFnmSzfFND_--A@mail.gmail.com>
 <CAJfpeguv8gebY_7dhOtb7LrhYPW6x3=upqakMTa3f4VuRkEgpA@mail.gmail.com>
 <CAJfpegsVy=tep29H=zWhRYCVHBd4mYO=e_181DinZUQOaetoJA@mail.gmail.com>
 <CAOQ4uxha2VNZ-Da-w6U5yxrqA3PkixXPevk9_5NvMzg4-KkWSg@mail.gmail.com>
 <CAOQ4uxiKss89-J+Wv1q9QtvMMsypKFy-ktBom_Ss9kPr7_te6w@mail.gmail.com> <20190128192207.GA10240@redhat.com>
In-Reply-To: <20190128192207.GA10240@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 28 Jan 2019 22:57:55 +0200
Message-ID: <CAOQ4uxg7E=K6_RTd7-qKt6gPGiMx7S46ZYkCECzwEUmxzBkKxQ@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

> > > I'll stick with the simple copy_page() implementation (back and forth)
> > > unless you come up with a better suggestion. We will probably want
> > > something more efficient later on, but I rather start with something
> > > simple and working.
> > >
> >
> > Like this:
> > https://github.com/amir73il/linux/commits/ovl-aops-wip
> >
>
> Am I understanding it right, that we will use page cache at overlay inode
> as well as upper file system. So there is duplication and memory usage
> for upper files will double?

That won't be acceptable, but using upper page cache as temporary pages
for the duration of writeback makes overlayfs code much simpler IMO and
avoids vma -> vfs locking order issues.

My idea was to get rid of the upper pages once writeback is done
(or periodically), but that wasn't implemented yet, because I am still
waiting to hear if the idea is inherently bad.

Think of upper inode page cache as a storage device cache.
Filesystem writes to storage device cache (not to media) and cache
is flushed to media on explicit from filesystem or periodically.

Once overlay pages have been copied to upper page cache, they
are "clean" and can be reclaimed at any time, even before upper
inode writeback has completed.

> If yes, this will be reason to provide
> separate option for lazy copy up (Or switch to using O_DIRECT).
>

Although I started this series with lazy copy up, it is lazy copy up that
depends on overlay aops and not the other way around.
The plan (as Miklos depicted it) is to use overlay page cache for copied
up file (UPPER_SHARED) as well as for lower files that were open
for write or mmap shared (LOWER_SHARED).

Lazy copy up is just a very simple stepping stone on the way there,
because it demonstrates that we can defer the decision of switching
from LOWER state (no page cache) to LOWER_SHARED until mmap
time and the decision to switch to UPPER_SHARED state (copy up data)
until the first page fault (later it will be on writable page fault).

In the end, "lazy copy up" will mean no copy up at all on open and it will
not depend on metacopy. There is also no expected reason why users
would need to opt-out of overlay page cache that solves shared mmap
inconsistency and improved efficiency of syncfs.

Thanks,
Amir.
