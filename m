MIME-Version: 1.0
Date: Mon, 28 Jan 2019 22:17:31 +0100
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
	<20190128192207.GA10240@redhat.com>
	<CAOQ4uxg7E=K6_RTd7-qKt6gPGiMx7S46ZYkCECzwEUmxzBkKxQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxg7E=K6_RTd7-qKt6gPGiMx7S46ZYkCECzwEUmxzBkKxQ@mail.gmail.com>
Message-ID: <CAJfpegth1vkgo67MbqfcmjXZLjxAW9mjoNaxLUW78iRtEqcaLQ@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Jan 28, 2019 at 9:58 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > > I'll stick with the simple copy_page() implementation (back and forth)
> > > > unless you come up with a better suggestion. We will probably want
> > > > something more efficient later on, but I rather start with something
> > > > simple and working.
> > > >
> > >
> > > Like this:
> > > https://github.com/amir73il/linux/commits/ovl-aops-wip
> > >
> >
> > Am I understanding it right, that we will use page cache at overlay inode
> > as well as upper file system. So there is duplication and memory usage
> > for upper files will double?
>
> That won't be acceptable, but using upper page cache as temporary pages
> for the duration of writeback makes overlayfs code much simpler IMO and
> avoids vma -> vfs locking order issues.
>
> My idea was to get rid of the upper pages once writeback is done
> (or periodically), but that wasn't implemented yet, because I am still
> waiting to hear if the idea is inherently bad.

The problem with that is unnecessary memory copies.   If done right,
direct I/O will be simpler, faster, and won't have locking issues,
beacuse it can be done asynchronously.

Trying to put some code together...

Thanks,
Miklos
