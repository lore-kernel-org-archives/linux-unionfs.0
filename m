From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: 45aebeaf4f67 "ovl: Ensure upper filesystem supports d_type"
 breaking Docker
Date: Mon, 16 May 2016 09:07:27 -0400
Message-ID: <20160516130727.GA26411@redhat.com>
References: <87d1ombix6.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d1ombix6.fsf@gamma.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>
Cc: linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, mpe@ellerman.id.au, mszeredi@redhat.com, dchinner@redhat.com
List-Id: linux-unionfs@vger.kernel.org

On Mon, May 16, 2016 at 04:45:09PM +1000, Daniel Axtens wrote:
> Hi,
> 
> I installed a fresh 4.6.0 kernel on my ppc64le system, and tried to run
> a docker container. It failed.
> 
> Docker gave me errors like this:
> 
> docker: Error response from daemon: error creating overlay mount to /var/lib/docker/overlay/2bc07cedad2770da2f384d5c1e81a6f45fa3c44a7658f10d02e5973ef76620fc-init/merged: invalid argument.
> 
> In dmesg, I'm seeing:
> 
> overlayfs: upper fs needs to support d_type.
> 

Hi Daniel,

What't the underlying fs you are using. overlayfs requires underlying
filesystem to support d_type and there were cases where xfs was
built with ftype=0 and in that case xfs does not support d_type. That
means it led to issues like whiteouts not being recognized and being
left behind during various operations.

So it became clear that we need a check at mount time to make sure
d_type is supported otherwise error out. This will require users to
do mkfs.xfs with ftype=1 to make progress.

I think new defaults for mkfs.xfs are such that ftype=1 is set. I am
not sure which version that change was made in.

Thanks
Vivek

> Reverting 45aebeaf4f67 ("ovl: Ensure upper filesystem supports d_type")
> fixes the issue for me. I haven't investigated the root cause yet - at a
> guess I'd say either Docker's layering system, or some weird interaction
> with namespacing, maybe? I'll have a look when I get a spare moment.
> 
> For reference, I'm using docker 1.11.0-dev.
> 
> Regards,
> Daniel Axtens
