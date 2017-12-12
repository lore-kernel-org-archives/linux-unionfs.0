From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 3/3] generic/471: add syncfs test
Date: Tue, 12 Dec 2017 21:30:46 +0800
Message-ID: <20171212133046.GT2749@eguan.usersys.redhat.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
 <1513048179-151065-3-git-send-email-cgxu519@icloud.com>
 <20171212092419.GR2749@eguan.usersys.redhat.com>
 <CAOQ4uxge1UEcsVE12XQgwAFSFktSXFiNkvWcODftxe=ZBjnEnw@mail.gmail.com>
 <19AB6F85-BB0D-4CDF-B153-99F0E7514A62@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754466AbdLLNas (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 08:30:48 -0500
Content-Disposition: inline
In-Reply-To: <19AB6F85-BB0D-4CDF-B153-99F0E7514A62@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Dec 12, 2017 at 06:05:50PM +0800, Chengguang Xu wrote:
> > 
> > 在 2017年12月12日，下午5:56，Amir Goldstein <amir73il@gmail.com> 写道：
> > 
> > On Tue, Dec 12, 2017 at 11:24 AM, Eryu Guan <eguan@redhat.com> wrote:
> >> On Tue, Dec 12, 2017 at 11:09:39AM +0800, Chengguang Xu wrote:
> >>> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes in
> >>> underlying filesystem.
> >>> Run syncfs and shutdown filesystem(or underlying filesystem of overlayfs)
> >>> to check syncfs result.
> >>> 
> >>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> >>> ---
> >>> 
> >>> Changes since v2:
> >>> 1. Modify multiple test files to single small test file.
> >>> 2. Use fssum to check result instead of diff.
> >>> 3. Add comment for why running sync before test.
> >>> 4. Add option explanation of fssum.
> >>> 
> >>> Changes since v1:
> >>> Use fs shutdown and fssum to check syncfs result instead of
> >>> checking delalloc state of extents.
> >>> 
> >>> tests/generic/471     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >>> tests/generic/471.out |   2 +
> >>> tests/generic/group   |   1 +
> >>> 3 files changed, 105 insertions(+)
> >>> create mode 100755 tests/generic/471
> >>> create mode 100644 tests/generic/471.out
> >>> 
> >>> diff --git a/tests/generic/471 b/tests/generic/471
> >>> new file mode 100755
> >>> index 0000000..9d6c37a
> >>> --- /dev/null
> >>> +++ b/tests/generic/471
> >>> @@ -0,0 +1,102 @@
> >>> +#! /bin/bash
> >>> +# FS QA Test 471
> >>> +#
> >>> +# Inspired by syncfs bug of overlayfs which does not sync dirty inodes in
> >>> +# underlying filesystem.
> >>> +#
> >>> +# Create a small file then run syncfs and shutdown filesystem(or underlying
> >>> +# filesystem of overlayfs) to check syncfs result.
> >>> +#
> >>> +# Test will be skipped if filesystem(or underlying filesystem of overlayfs)
> >>> +# does not support shutdown.
> >>> +#
> >>> +#-----------------------------------------------------------------------
> >>> +# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>
> >>> +# All Rights Reserved.
> >>> +#
> >>> +# This program is free software; you can redistribute it and/or
> >>> +# modify it under the terms of the GNU General Public License as
> >>> +# published by the Free Software Foundation.
> >>> +#
> >>> +# This program is distributed in the hope that it would be useful,
> >>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>> +# GNU General Public License for more details.
> >>> +#
> >>> +# You should have received a copy of the GNU General Public License
> >>> +# along with this program; if not, write the Free Software Foundation,
> >>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >>> +#-----------------------------------------------------------------------
> >>> +#
> >>> +
> >>> +seq=`basename $0`
> >>> +seqres=$RESULT_DIR/$seq
> >>> +echo "QA output created by $seq"
> >>> +
> >>> +here=`pwd`
> >>> +tmp=/tmp/$$
> >>> +status=1
> >>> +trap "_cleanup; exit \$status" 0 1 2 3 15
> >>> +
> >>> +_cleanup()
> >>> +{
> >>> +     cd /
> >>> +     rm -f $tmp.*
> >>> +}
> >>> +
> >>> +# get standard environment, filters and checks
> >>> +. ./common/rc
> >>> +. ./common/filter
> >>> +
> >>> +# remove previous $seqres.full before test
> >>> +rm -f $seqres.full
> >>> +
> >>> +# real QA test starts here
> >>> +
> >>> +_supported_fs generic
> >>> +_supported_os Linux
> >>> +_require_fssum
> >>> +_require_scratch
> >>> +_require_scratch_shutdown
> >>> +_require_xfs_io_command "syncfs"
> >>> +
> >>> +_scratch_mkfs >/dev/null 2>&1
> >> 
> >> Need "_require_metadata_journaling $SCRATCH_DEV" after _scratch_mkfs, so
> >> filesystems like no-journal mode ext4 or ext2 (driven by ext4 module)
> >> won't run this test.
> >> 
> > 
> > In that case, Chengguang would also have to teach _require_metadata_journaling
> > about OVERLAY_BASE_SCRATCH_DEV....
> > 
> > Chengguang,
> > 
> > Sorry for all the extra work.
> > That means you are making an important improvement to xfstests!
> 
> It’s worth to check all _require functions for overlayfs, but just in this case,
> do we really need this check before test? IMO，if fs supports shutdown then should
> run this test, am I wrong?

I think you're right, I was looking at other shutdown tests for too long
and thought this one needed the jounal check too, sorry about that!

But as Amir suggested, other shutdown tests need overlay support in
_require_metadata_journaling, but I think that can be fixed in a
follow-up patch, as using ext2 or no-journal mode ext4 as the backing
filesystems of overlay is not a common setup, the possiblity of someone
hitting false positive is relative low.

Thanks,
Eryu
