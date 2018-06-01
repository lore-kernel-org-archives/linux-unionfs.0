Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180529194108.GB13363@redhat.com>
References: <20180529194108.GB13363@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 1 Jun 2018 11:34:38 +0300
Message-ID: <CAOQ4uxgjbK=XHy0E0n94KoLhkxEbNU-YFz05mHYaiQTuXPmiRQ@mail.gmail.com>
Subject: Re: [PATCH V3] xfstest: overlay: Add tests for overlay metadata only
 copy up feature
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <guaneryu@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 29, 2018 at 10:41 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi,
>
> Find attached V3 of the patch. It now works on top of ext4 as well as
> xfs with reflink enabled.

I can confirm that.

> I removed some of nr_block checks which could
> not be guaranteed.
>
> Add tests for metadata only copy up feature.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

You may add
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Once one last comment is addressed

> ---
>  common/overlay        |    1
>  tests/overlay/060     |  285 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/060.out |   42 +++++++
>  tests/overlay/group   |    1
>  4 files changed, 329 insertions(+)
>
> Index: xfstests-dev/tests/overlay/060
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/tests/overlay/060      2018-05-29 15:34:52.430714715 -0400
> @@ -0,0 +1,285 @@
> +#! /bin/bash
> +# FS QA Test No. 060
> +#
> +# Test metadata only copy up functionality.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
> +# Author: Vivek Goyal <vgoyal@redhat.com>
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1       # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +# We use non-default scratch underlying overlay dirs, we need to check
> +# them explicity after test.
> +_require_scratch_nocheck
> +_require_scratch_overlay_features index redirect_dir metacopy
> +
> +# remove all files from previous tests
> +_scratch_mkfs
> +
> +# File size on lower
> +lowername="lowerfile"
> +lowerlink="lowerfile-link"
> +lowerdata="lower"
> +lowerblocks="32"
> +lowersize=$(( $lowerblocks * 512 ))
> +

Although the test passes now on ext4/xfs, my comment remains -
it makes no sense for this test to calculate expected nr of blocks
instead of using actual lower file blocks.

While fallocate $size guaranties that resulting file size is $size
you cannot say the same about $blocks. There is no guarantie
that file systems will use $size / 512 blocks to store size$.
file systems can and do allocate more blocks for e.g. xattr and
other file metadata. There is really no reason for this test to
make the assumption about $blocks however probable it may be.

Thanks,
Amir.
