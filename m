Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754992AbeEHQLi (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 May 2018 12:11:38 -0400
Subject: Re: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
References: <20180503152635.14974-1-rgoldwyn@suse.de>
 <20180503152635.14974-4-rgoldwyn@suse.de>
 <CAOQ4uxhjhds4avkGBTHsqLp72nWjP=mAFPtxmUarcF1-jp89ng@mail.gmail.com>
 <20180503221142.GC10363@dastard>
 <8317eac5-d305-4bbd-5d93-4fa6801c8b6a@suse.de>
 <20180505231641.GF10363@dastard> <20180507121638.GA27632@lst.de>
 <20180507231646.GK10363@dastard> <20180508040242.GA19735@lst.de>
 <20180508100624.GL10363@dastard>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <5fd8ee75-58ee-c254-2912-f28e913bd6ad@suse.de>
Date: Tue, 8 May 2018 11:11:33 -0500
MIME-Version: 1.0
In-Reply-To: <20180508100624.GL10363@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Anna Schumaker <Anna.Schumaker@netapp.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>



On 05/08/2018 05:06 AM, Dave Chinner wrote:
> On Tue, May 08, 2018 at 06:02:42AM +0200, Christoph Hellwig wrote:
>> On Tue, May 08, 2018 at 09:16:46AM +1000, Dave Chinner wrote:
>>> This sort of whacky undefined behaviour w.r.t. sparseness was the
>>> reason we were given at LSFMM for cp and rsync not implementing
>>> copy_file_range() - they could not control it according to the
>>> user's direction. Hence my suggestion that we need flags to
>>> specifically direct the behaviour of the syscall so that userspace
>>> will actually use it....
>>
>> They can just use SEEK_HOLE/DATA and just copy the chunk they care
>> about.  Especially as they already have the SEEK_HOLE/DATA logic
>> for the plain old copy anyway
> 
> Well, you think they would given what we've told them in the past
> about using fiemap for finding holes and the potential for data
> corruption it comes along with. But - as I found out recently - cp
> is still using fiemap to find holes, not SEEK_HOLE/DATA. See:
> 
> https://github.com/coreutils/coreutils/blob/master/src/extent-scan.c
> 
>> - that is the only thing they have
>> to create holes in the destination file to start with.  Nevermind
>> that a file system with inline dedup will happily create holes for
>> them underneath.
> 
> Yup, I know. However, it's not me that I'm suggesting we do this
> for....
> 

What should the default behavior (without flags) be? Should it create
holes or not? If the filesystem supports reflink then we would end up
with destination having holes and if it does not we will have
destination not having holes even though the filesystem supports sparse
files. It is not consistent though there is no documentation to specify
it will be one way or the other. Are users okay with inconsistent
behavior? Depending on the answer, we can add either one of the two
options: CFR_FILL_HOLES or CFR_KEEP_HOLES. Alternatively, we can
document the state of holes in the destination is not determinant and
coreutils/cp can perform the lseek(SEEK_HOLE/DATA)

If we do handle the hole behavior, should the individual filesystems
handle this or should we handle in in VFS. VFS seems simple because
NFS42: nfs42_copy_args does not seem to have a field which could
represent flags.

If cp calls copy_file_range(), it will clone the portion if the
filesystem supports it, which may not work with "cp --reflink=never"
option. In that case, should we have CFR_NO_REFLINK option for
copy_file_range()?


-- 
Goldwyn
