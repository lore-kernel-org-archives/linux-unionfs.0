From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Virtio-fs as upper layer for overlayfs
Date: Mon, 13 Jan 2020 14:56:51 -0500
Message-ID: <20200113195651.GA9780@redhat.com>
References: <7904C889-F0AC-4473-8C02-887EF6593564@intel.com>
 <20200106183500.GA14619@redhat.com>
 <CAJfpegszhftUxkhaAaF3Gj4u+S5M74RwCrXLTptW=zcKz+_xug@mail.gmail.com>
 <20200107160918.GB15920@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49419 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726494AbgAMT6F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jan 2020 14:58:05 -0500
Content-Disposition: inline
In-Reply-To: <20200107160918.GB15920@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, "Ernst, Eric" <eric.ernst@intel.com>
Cc: "mszeredi@redhat.com" <mszeredi@redhat.com>, "kata-dev@lists.katacontainers.io" <kata-dev@lists.katacontainers.io>, Stefan Hajnoczi <stefanha@redhat.com>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 07, 2020 at 11:09:18AM -0500, Vivek Goyal wrote:
> On Mon, Jan 06, 2020 at 08:58:23PM +0100, Miklos Szeredi wrote:
> > On Mon, Jan 6, 2020 at 7:35 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Mon, Jan 06, 2020 at 05:27:05PM +0000, Ernst, Eric wrote:
> > >
> > > [CC linux-unionfs@vger.kernel.org and amir]
> > >
> > > > Hi Miklos,
> > > >
> > > > One of the popular use cases for Kata Containers is running docker-in-docker.  That is, a container image is run which in turn will make use of a container runtime to do a container build.
> > > >
> > > > When combined with virtio-fs, we end up with a configuration like:
> > > > xfs/ext4 -> overlayfs -> virtio-fs -> overlayfs
> > > >
> > > > As discussed in [1], per overlayfs spec:
> > > > "The upper filesystem will normally be writable and if it is it must support the creation of trusted.* extended attributes, and must provide valid d_type in readdir responses, so NFS is not suitable."
> > > >
> > >
> > > I don't know exaactly the reasons why NFS is not supported as upper. Are
> > > above only two reasons? These might work with virtio-fs depending on
> > > underlying filesystem. If yes, should we check for these properties
> > > at mount time (instead of relying on dentry flags only,
> > > ovl_dentry_remote()).
> > >
> > > I feel there is more to it.
> > 
> > NFS also has these automount points, that we currently can't cope with
> > in overlayfs.  And there's revalidation, which we reject on upper
> > simply because overlayfs currently doesn't call ->revalidate() on
> > upper.   Not that we would not be able to, it's just something that
> > probably needs some thought.
> > 
> > Virtio-fs does not yet have the magic automount thing (which would be
> > useful to resolve inode number conflicts), but it does have
> > revalidate. In the virtio-fs case, not calling ->revalidate() should
> > not be a problem, so it's safe to try out this configuration by adding
> > a hack to disable the remote check in case of a virtio-fs upper.
> 
> Here is a hack patch to provide an exception to allow virtiofs as upper
> filesystem for overlayfs. 
> 
> I can mount now but I get warning that upper does not support xattr, hence
> disabling index and metaocopy. Still need to test why that's the case. I
> thought xattr are supported on virtiofs.

I have pushed this patch on a branch in my repo for testing.

https://github.com/rhvgoyal/linux/commit/0a0c0e2d9986ecf445e1fdff45b51f37b98ac1e6

I can now mount overlayfs on top of virtiofs with this patch. It needs to
run virtiofsd with option "-o xattr" and also needs following patch for it
to work.

https://www.redhat.com/archives/virtio-fs/2020-January/msg00047.html

Thanks
Vivek
