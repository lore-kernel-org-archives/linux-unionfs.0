Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:53078 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752966AbeEGXVx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 19:21:53 -0400
Date: Tue, 8 May 2018 09:16:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
Message-ID: <20180507231646.GK10363@dastard>
References: <20180503152635.14974-1-rgoldwyn@suse.de>
 <20180503152635.14974-4-rgoldwyn@suse.de>
 <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com>
 <20180503221142.GC10363@dastard>
 <8317eac5-d305-4bbd-5d93-4fa6801c8b6a@suse.de>
 <20180505231641.GF10363@dastard>
 <20180507121638.GA27632@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507121638.GA27632@lst.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 07, 2018 at 02:16:38PM +0200, Christoph Hellwig wrote:
> On Sun, May 06, 2018 at 09:16:41AM +1000, Dave Chinner wrote:
> > > In the patchset description [0], I ask if this should be the default
> > > feature (I think it should be) and holes should be converted to zeros as
> > > a special flag.. The only argument against it could be that applications
> > > are already using this interface, so this would be a change in behavior.
> > 
> > In general, we don't change the behaviour of syscalls after the
> > fact. We have flags to control behaviour, so applications that want
> > to preserve holes will just have to be changed to use that flag.
> 
> copy_file_range isn't documented to either preserve or not preserve
> holes.  And in fact it will preserve holes (or even create new ones)
> for any filesystem that implements it as a clone like btrfs or xfs..

Right, but that's the entire problem. And you can't even say it will
preserve holes on XFS, because that relies on a filesystem format
feature that most users currently don't have enabled. Hence it will
be sparse preserving on some XFS filesystems but not on most.

This sort of whacky undefined behaviour w.r.t. sparseness was the
reason we were given at LSFMM for cp and rsync not implementing
copy_file_range() - they could not control it according to the
user's direction. Hence my suggestion that we need flags to
specifically direct the behaviour of the syscall so that userspace
will actually use it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
