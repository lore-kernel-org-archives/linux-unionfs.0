From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] overlay: copy-up lowerdir which has opaque xattr set
Date: Tue, 9 Aug 2016 16:37:30 +1000
Message-ID: <20160809063730.GG19025@dastard>
References: <1470677033-7035-1-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:37060 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbcHIGhd (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 9 Aug 2016 02:37:33 -0400
Content-Disposition: inline
In-Reply-To: <1470677033-7035-1-git-send-email-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, xzhou@redhat.com

On Tue, Aug 09, 2016 at 01:23:53AM +0800, Eryu Guan wrote:
> When copying up a directory with opaque xattr set, the xattr was
> copied up as well, after a remount the opaque flag is honored so the
> copied-up directory is treated as opaque, which causes files created
> in the lowerdir to be hidden when using multiple lower directories.
> 
> This is fixed by "ovl: don't copy up opaqueness".
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/overlay/014     | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/014.out |  3 ++
>  tests/overlay/group   |  1 +
>  3 files changed, 100 insertions(+)
>  create mode 100755 tests/overlay/014
>  create mode 100644 tests/overlay/014.out
> 
> diff --git a/tests/overlay/014 b/tests/overlay/014
> new file mode 100755
> index 0000000..d9d8b5d
> --- /dev/null
> +++ b/tests/overlay/014
> @@ -0,0 +1,96 @@
> +#! /bin/bash
> +# FS QA Test 014
> +#
> +# Test copy-up of lowerdir with opaque xattr set.
> +#
> +# When copying up a directory with opaque xattr set, the xattr was copied up as
> +# well, after a remount the opaque flag is honored so the copied-up directory
> +# is treated as opaque, which causes files created in the lowerdir to be hidden
> +# when using multiple lower directories.
> +#
> +# This is fixed by "ovl: don't copy up opaqueness".
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Red Hat Inc. All Rights Reserved.
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
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_test
> +_require_scratch
> +_require_attrs
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +# Create multiple lowerdirs and upperdir, workdir, and testdir on lowerdir
> +lowerdir1=$SCRATCH_DEV/lower1
> +lowerdir2=$SCRATCH_DEV/lower2
> +upperdir=$SCRATCH_DEV/upper
> +workdir=$SCRATCH_DEV/workdir
> +mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
> +mkdir -p $lowerdir1/testdir/d
> +
> +# mount overlay with $lowerdir2 as upperdir, and remove & recreate testdir,
> +# make testdir on $lowerdir2 opaque
> +$MOUNT_PROG -t overlay -o lowerdir=$lowerdir1,upperdir=$lowerdir2 \
> +	-o workdir=$workdir none $SCRATCH_MNT

We really need a _overlay_scratch_mount_dirs() function here. i.e.

_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir

and factor the _overlay_scratch_mount/_overlay_mount code to
use a single implemention of _overlay_mount_dirs()....

> +rm -rf $SCRATCH_MNT/testdir
> +mkdir -p $SCRATCH_MNT/testdir/visibledir
> +$UMOUNT_PROG $SCRATCH_MNT

_overlay_scratch_unmount

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
