Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:10942 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgAFWSs (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jan 2020 17:18:48 -0500
From: eric.ernst@intel.com
Date: Mon, 6 Jan 2020 14:24:37 -0800
Subject: Re: Virtio-fs as upper layer for overlayfs
Message-ID: <20200106222437.GA141177@eernstworkstation>
References: <7904C889-F0AC-4473-8C02-887EF6593564@intel.com>
 <20200106183500.GA14619@redhat.com>
 <CAJfpegszhftUxkhaAaF3Gj4u+S5M74RwCrXLTptW=zcKz+_xug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegszhftUxkhaAaF3Gj4u+S5M74RwCrXLTptW=zcKz+_xug@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, "mszeredi@redhat.com" <mszeredi@redhat.com>, "kata-dev@lists.katacontainers.io" <kata-dev@lists.katacontainers.io>, Stefan Hajnoczi <stefanha@redhat.com>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Jan 06, 2020 at 08:58:23PM +0100, Miklos Szeredi wrote:
> On Mon, Jan 6, 2020 at 7:35 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Mon, Jan 06, 2020 at 05:27:05PM +0000, Ernst, Eric wrote:
> >
> > [CC linux-unionfs@vger.kernel.org and amir]
> >
> > > Hi Miklos,
> > >
> > > One of the popular use cases for Kata Containers is running docker-in-docker.  That is, a container image is run which in turn will make use of a container runtime to do a container build.
> > >
> > > When combined with virtio-fs, we end up with a configuration like:
> > > xfs/ext4 -> overlayfs -> virtio-fs -> overlayfs
> > >
> > > As discussed in [1], per overlayfs spec:
> > > "The upper filesystem will normally be writable and if it is it must support the creation of trusted.* extended attributes, and must provide valid d_type in readdir responses, so NFS is not suitable."
> > >
> >
> > I don't know exaactly the reasons why NFS is not supported as upper. Are
> > above only two reasons? These might work with virtio-fs depending on
> > underlying filesystem. If yes, should we check for these properties
> > at mount time (instead of relying on dentry flags only,
> > ovl_dentry_remote()).
> >
> > I feel there is more to it.
> 
> NFS also has these automount points, that we currently can't cope with
> in overlayfs.  And there's revalidation, which we reject on upper
> simply because overlayfs currently doesn't call ->revalidate() on
> upper.   Not that we would not be able to, it's just something that
> probably needs some thought.
> 
> Virtio-fs does not yet have the magic automount thing (which would be
> useful to resolve inode number conflicts), but it does have
> revalidate. In the virtio-fs case, not calling ->revalidate() should
> not be a problem, so it's safe to try out this configuration by adding
> a hack to disable the remote check in case of a virtio-fs upper.
>

Miklos, I'm still learning a bit more about fs implementations, so my
apologies if this should be obvious. For virtio-fs, one of the use cases
that is described is sharing memory between two guests (not necessarily
the Kata use case). I was guessing the dcache would be within the guest,
and that in at least the shared memory case, there's potential that a 
revalidate may be neccesary, in case any changes are made by the second guest?
(I could be mixing up the intended use for revalidate, though).

Can you clarify that "not calling ->revalidate() should not be a
problem?"

Thanks for the help.

-Eric


> Thanks,
> Miklos
