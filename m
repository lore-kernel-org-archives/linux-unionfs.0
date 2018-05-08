Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38273 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755072AbeEHQV0 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 May 2018 12:21:26 -0400
Date: Tue, 8 May 2018 18:24:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
Message-ID: <20180508162449.GA1389@lst.de>
References: <20180503152635.14974-4-rgoldwyn@suse.de> <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com> <20180503221142.GC10363@dastard> <8317eac5-d305-4bbd-5d93-4fa6801c8b6a@suse.de> <20180505231641.GF10363@dastard> <20180507121638.GA27632@lst.de> <20180507231646.GK10363@dastard> <20180508040242.GA19735@lst.de> <20180508100624.GL10363@dastard> <5fd8ee75-58ee-c254-2912-f28e913bd6ad@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fd8ee75-58ee-c254-2912-f28e913bd6ad@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 08, 2018 at 11:11:33AM -0500, Goldwyn Rodrigues wrote:
> What should the default behavior (without flags) be?

Create holes if and how the file systems thinks is best.  That
might even include creating holes if the original file didnt have
any.

> options: CFR_FILL_HOLES or CFR_KEEP_HOLES. Alternatively, we can
> document the state of holes in the destination is not determinant and
> coreutils/cp can perform the lseek(SEEK_HOLE/DATA)

Create holes by default, and no flag that just create confusion as
holes are a file system implementation detail subject to change
at any time.

> If cp calls copy_file_range(), it will clone the portion if the
> filesystem supports it, which may not work with "cp --reflink=never"
> option. In that case, should we have CFR_NO_REFLINK option for
> copy_file_range()?

cp --reflink=never is pretty idiotic.  Think of inline dedup for example
which will just create reflink behinds its back in the file system,
or just dedup invisibly to it in the storage device.

> 
> 
> -- 
> Goldwyn
---end quoted text---
