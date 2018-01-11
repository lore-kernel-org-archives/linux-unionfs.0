From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/7] Overlayfs exportfs tests
Date: Thu, 11 Jan 2018 19:43:35 +0800
Message-ID: <20180111114335.GK5123@eguan.usersys.redhat.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jan 07, 2018 at 08:07:18PM +0200, Amir Goldstein wrote:
> Eryu,
> 
> Following patches were used to test overlayfs NFS export.
> 
> Patches 1-5 improve generic/exportfs tests, by adding test coverage
> of some directory file handle use cases.

open_by_handle test is covering more and more cases, thanks! OTOH, it's
getting more and more complicated :) Everytime I start looking at
open_by_handle tests/patches I need some time to get familiar with it
again, so the review process might be slow..

But from a quick scan, I think it's time to stop adding new sub-tests to
existing tests (maybe we should have done this since last time we added
new sub-tests to generic/467), because generic/467 is getting more
complex too and makes review harder. Perhaps we can factor out some
helper functions from generic/467 to common helpers and use them in new
tests.

> 
> Patches 6-7 add two overlay specific tests for NFS file handles
> for overlay setup of same fs and non same fs.
> 
> The new overlay tests don't run on upstream kernel and pass with
> my overlayfs NFS export V2 branch [1]. You may want to wait with
> merging those tests until overlayfs NFS support is merged - up to you,
> but a review would be most welcome.

OK, I'll see after reviewing all the tests.

> 
> Merging patches 1-5 seems like a good idea to me regardless of
> overlayfs NFS export support.

Agreed.

Thanks,
Eryu

> 
> Thanks,
> Amir.
> 
> [1] https://github.com/amir73il/linux/commits/ovl-nfs-export-v2
> 
> Amir Goldstein (7):
>   open_by_handle: store and load file handles from file
>   open_by_handle: verify dir content only with -r flag
>   generic/exportfs: golden output is not silent
>   generic/exportfs: store and load file handles from file
>   generic/exportfs: add a test case for renamed parent dir
>   overlay: test encode/decode overlay file handles
>   overlay: test encode/decode of non-samefs overlay file handles
> 
>  src/open_by_handle.c  | 112 +++++++++++++-----
>  tests/generic/426     |   1 -
>  tests/generic/426.out |   1 -
>  tests/generic/467     |  37 ++++--
>  tests/generic/467.out |  10 +-
>  tests/overlay/050     | 291 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/050.out |  50 ++++++++
>  tests/overlay/051     | 311 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/051.out |  50 ++++++++
>  tests/overlay/group   |   2 +
>  10 files changed, 822 insertions(+), 43 deletions(-)
>  create mode 100755 tests/overlay/050
>  create mode 100644 tests/overlay/050.out
>  create mode 100755 tests/overlay/051
>  create mode 100644 tests/overlay/051.out
> 
> -- 
> 2.7.4
> 
