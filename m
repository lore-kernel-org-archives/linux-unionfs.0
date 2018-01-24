From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 0/7] Overlayfs exportfs tests
Date: Wed, 24 Jan 2018 18:40:23 +0800
Message-ID: <20180124104023.GB18267@eguan.usersys.redhat.com>
References: <1516741152-20345-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516741152-20345-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jan 23, 2018 at 10:59:05PM +0200, Amir Goldstein wrote:
> Eryu,
> 
> This is the 2nd revision of test for overlayfs NFS export.
> 
> Changes since v1:
> - Added new generic/exportfs test instead of changing existing test
> - Addressed review comments on open_by_handle [-i|-o] patch
> - Added the test that uses open_by_handle [-i|-o] in the same patch
> - Split new overlay/exportfs tests to four tests, a pair of tests
>   for samefs and a pair of tests for non-samefs configuration.
> - For each configuration, one test requires and enables redirect_dir
>   for directory rename test cases and both tests require and enable
>   nfs_export feature.
> 
> The new overlay tests don't run on upstream kernel and pass with
> my overlayfs NFS export V3 branch [1]. You may want to wait with
> merging those tests until overlayfs NFS support is merged.

Yeah, I probably will wait and let the kernel patches go first. (And
I'll go through the overlay specific patches later.)

> 
> Merging patches 1-3 seems like a good idea to me regardless of
> overlayfs NFS export support.

Patches 1-3 look good to me. One minor issue is that my compiler
complained about "may be used uninitialized" on 'infile' and 'outfile'

open_by_handle.c:350:12: warning: 'outfile' may be used uninitialized in this function [-Wmaybe-uninitialized]

though I don't think we'll use them uninitialized in practice, I'd like
to initialize them with NULL on commit.

Thanks for the revision!

Eryu
