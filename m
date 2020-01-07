MIME-Version: 1.0
Date: Tue, 7 Jan 2020 10:48:37 +0100
References: <7904C889-F0AC-4473-8C02-887EF6593564@intel.com>
	<20200106183500.GA14619@redhat.com>
	<CAJfpegszhftUxkhaAaF3Gj4u+S5M74RwCrXLTptW=zcKz+_xug@mail.gmail.com>
	<20200106222437.GA141177@eernstworkstation>
In-Reply-To: <20200106222437.GA141177@eernstworkstation>
Message-ID: <CAJfpegt0pB-jJUBEmewRgH6MMmj3__MNzZ9ScitgcEehr51awQ@mail.gmail.com>
Subject: Re: Virtio-fs as upper layer for overlayfs
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: "Ernst, Eric" <eric.ernst@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "mszeredi@redhat.com" <mszeredi@redhat.com>, "kata-dev@lists.katacontainers.io" <kata-dev@lists.katacontainers.io>, Stefan Hajnoczi <stefanha@redhat.com>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Jan 6, 2020 at 11:18 PM <eric.ernst@intel.com> wrote:

> Miklos, I'm still learning a bit more about fs implementations, so my
> apologies if this should be obvious. For virtio-fs, one of the use cases
> that is described is sharing memory between two guests (not necessarily
> the Kata use case). I was guessing the dcache would be within the guest,
> and that in at least the shared memory case, there's potential that a
> revalidate may be neccesary, in case any changes are made by the second guest?

Exactly.

> (I could be mixing up the intended use for revalidate, though).
>
> Can you clarify that "not calling ->revalidate() should not be a
> problem?"

I was referring specifically to the overlayfs case.  Overlayfs stacks
on top of some other filesystems, i.e. when ->d_revalidate() is called
on overlayfs it calls ->d_revalidate() on underlying fs.  This only
happens for the lower (read-only) layers, not the upper (read-write)
layer.  So if the underlying upper fs is modified from another guest,
than that modification is not going to be reflected on the overlayfs.
However, overlayfs documents any changes to underlying layers as
resulting in undefined behavior.  It would be strange if docker was
relying on undefined behavior of overlayfs, so not doing the
revalidation should not make a difference.

Thanks,
Miklos
