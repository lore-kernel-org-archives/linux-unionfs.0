Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39893 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728039AbgAGNiE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Jan 2020 08:38:04 -0500
Date: Tue, 7 Jan 2020 08:37:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Virtio-fs as upper layer for overlayfs
Message-ID: <20200107133758.GA15920@redhat.com>
References: <7904C889-F0AC-4473-8C02-887EF6593564@intel.com>
 <20200106183500.GA14619@redhat.com>
 <CAJfpegszhftUxkhaAaF3Gj4u+S5M74RwCrXLTptW=zcKz+_xug@mail.gmail.com>
 <20200106222437.GA141177@eernstworkstation>
 <CAJfpegt0pB-jJUBEmewRgH6MMmj3__MNzZ9ScitgcEehr51awQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt0pB-jJUBEmewRgH6MMmj3__MNzZ9ScitgcEehr51awQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Ernst, Eric" <eric.ernst@intel.com>, "mszeredi@redhat.com" <mszeredi@redhat.com>, "kata-dev@lists.katacontainers.io" <kata-dev@lists.katacontainers.io>, Stefan Hajnoczi <stefanha@redhat.com>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jan 07, 2020 at 10:48:37AM +0100, Miklos Szeredi wrote:
> On Mon, Jan 6, 2020 at 11:18 PM <eric.ernst@intel.com> wrote:
> 
> > Miklos, I'm still learning a bit more about fs implementations, so my
> > apologies if this should be obvious. For virtio-fs, one of the use cases
> > that is described is sharing memory between two guests (not necessarily
> > the Kata use case). I was guessing the dcache would be within the guest,
> > and that in at least the shared memory case, there's potential that a
> > revalidate may be neccesary, in case any changes are made by the second guest?
> 
> Exactly.
> 
> > (I could be mixing up the intended use for revalidate, though).
> >
> > Can you clarify that "not calling ->revalidate() should not be a
> > problem?"
> 
> I was referring specifically to the overlayfs case.  Overlayfs stacks
> on top of some other filesystems, i.e. when ->d_revalidate() is called
> on overlayfs it calls ->d_revalidate() on underlying fs.  This only
> happens for the lower (read-only) layers, not the upper (read-write)
> layer.  So if the underlying upper fs is modified from another guest,
> than that modification is not going to be reflected on the overlayfs.
> However, overlayfs documents any changes to underlying layers as
> resulting in undefined behavior.  It would be strange if docker was
> relying on undefined behavior of overlayfs, so not doing the
> revalidation should not make a difference.

Hi Miklos,

Thanks for the explanation. I had the same question as Eric. So we will
basically rely on assumption that overlayfs upper (virtio-fs in this
case) is not shared and will not be modified underneath. Which probably
is true in this specific case. In fact I think even overlayfs lower will
not be modified as well because once docker prepares a rootfs for a 
container, it is not shared by any other container. IOW, following
seems to be the setup.

xfs/ext4 --> overlayfs1 --> virtiofs --->overlayfs2

Docker on host will prepare container root overlayfs1 on host and export
that into container using virtiofs. IIUC, overlayfs1 mount point will
not be shared with any other container. Only overlayfs1/lower will be
shared with other overlayfs mount point to enable container image
sharing. 

Given overlayfs1 will not be shared with other containers, that means
virtiofs is not changing outside this container. And docker will prepare
overlayfs2 inside contiainer for nested container. There also upper will
not be shared by other nested containers so even if we don't call
revalidate on upper, it should be fine for this configuration.

This is now all dependent on whether user has done the configuration right
and kernel can't enforce correct configuration.

Thanks
Vivek
