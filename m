Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45637 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932135AbeEHKG2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 May 2018 06:06:28 -0400
Date: Tue, 8 May 2018 20:06:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
Message-ID: <20180508100624.GL10363@dastard>
References: <20180503152635.14974-1-rgoldwyn@suse.de>
 <20180503152635.14974-4-rgoldwyn@suse.de>
 <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com>
 <20180503221142.GC10363@dastard>
 <8317eac5-d305-4bbd-5d93-4fa6801c8b6a@suse.de>
 <20180505231641.GF10363@dastard>
 <20180507121638.GA27632@lst.de>
 <20180507231646.GK10363@dastard>
 <20180508040242.GA19735@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508040242.GA19735@lst.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 08, 2018 at 06:02:42AM +0200, Christoph Hellwig wrote:
> On Tue, May 08, 2018 at 09:16:46AM +1000, Dave Chinner wrote:
> > This sort of whacky undefined behaviour w.r.t. sparseness was the
> > reason we were given at LSFMM for cp and rsync not implementing
> > copy_file_range() - they could not control it according to the
> > user's direction. Hence my suggestion that we need flags to
> > specifically direct the behaviour of the syscall so that userspace
> > will actually use it....
> 
> They can just use SEEK_HOLE/DATA and just copy the chunk they care
> about.  Especially as they already have the SEEK_HOLE/DATA logic
> for the plain old copy anyway

Well, you think they would given what we've told them in the past
about using fiemap for finding holes and the potential for data
corruption it comes along with. But - as I found out recently - cp
is still using fiemap to find holes, not SEEK_HOLE/DATA. See:

https://github.com/coreutils/coreutils/blob/master/src/extent-scan.c

> - that is the only thing they have
> to create holes in the destination file to start with.  Nevermind
> that a file system with inline dedup will happily create holes for
> them underneath.

Yup, I know. However, it's not me that I'm suggesting we do this
for....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
