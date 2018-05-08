Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35176 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754216AbeEHD7X (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 23:59:23 -0400
Date: Tue, 8 May 2018 06:02:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
Message-ID: <20180508040242.GA19735@lst.de>
References: <20180503152635.14974-1-rgoldwyn@suse.de> <20180503152635.14974-4-rgoldwyn@suse.de> <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com> <20180503221142.GC10363@dastard> <8317eac5-d305-4bbd-5d93-4fa6801c8b6a@suse.de> <20180505231641.GF10363@dastard> <20180507121638.GA27632@lst.de> <20180507231646.GK10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507231646.GK10363@dastard>
Sender: linux-unionfs-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 08, 2018 at 09:16:46AM +1000, Dave Chinner wrote:
> This sort of whacky undefined behaviour w.r.t. sparseness was the
> reason we were given at LSFMM for cp and rsync not implementing
> copy_file_range() - they could not control it according to the
> user's direction. Hence my suggestion that we need flags to
> specifically direct the behaviour of the syscall so that userspace
> will actually use it....

They can just use SEEK_HOLE/DATA and just copy the chunk they care
about.  Especially as they already have the SEEK_HOLE/DATA logic
for the plain old copy anyway - that is the only thing they have
to create holes in the destination file to start with.  Nevermind
that a file system with inline dedup will happily create holes for
them underneath.
