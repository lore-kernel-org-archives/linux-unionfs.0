Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45284 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726569AbgAFSfI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jan 2020 13:35:08 -0500
Date: Mon, 6 Jan 2020 13:35:00 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Virtio-fs as upper layer for overlayfs
Message-ID: <20200106183500.GA14619@redhat.com>
References: <7904C889-F0AC-4473-8C02-887EF6593564@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7904C889-F0AC-4473-8C02-887EF6593564@intel.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: "Ernst, Eric" <eric.ernst@intel.com>
Cc: "mszeredi@redhat.com" <mszeredi@redhat.com>, "kata-dev@lists.katacontainers.io" <kata-dev@lists.katacontainers.io>, Stefan Hajnoczi <stefanha@redhat.com>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Jan 06, 2020 at 05:27:05PM +0000, Ernst, Eric wrote:

[CC linux-unionfs@vger.kernel.org and amir]

> Hi Miklos,
> 
> One of the popular use cases for Kata Containers is running docker-in-docker.  That is, a container image is run which in turn will make use of a container runtime to do a container build.
> 
> When combined with virtio-fs, we end up with a configuration like:
> xfs/ext4 -> overlayfs -> virtio-fs -> overlayfs 
> 
> As discussed in [1], per overlayfs spec: 
> "The upper filesystem will normally be writable and if it is it must support the creation of trusted.* extended attributes, and must provide valid d_type in readdir responses, so NFS is not suitable."
> 

I don't know exaactly the reasons why NFS is not supported as upper. Are
above only two reasons? These might work with virtio-fs depending on
underlying filesystem. If yes, should we check for these properties
at mount time (instead of relying on dentry flags only,
ovl_dentry_remote()).

I feel there is more to it. Just that I don't know. Miklos and Amir
will probably have more thoughts on this.

Vivek

> At this point, with virtio-fs this, [2], check fails.  
> 
> Vivek mentioned that bypassing this check *may* be feasible, [3].  Can you help identify if this is feasible, and rationale for NFS not being available as an upper (though, more importantly, understanding what needs to be done to add proper support for virtio-fs as upper layer).
> 
> Thanks,
> Eric 
> 
> [1] - https://github.com/kata-containers/runtime/issues/1888
> [2] - https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/overlayfs/super.c#n753
> [3] - https://github.com/kata-containers/runtime/issues/1888#issuecomment-518259095
> 
