From: Xiong Zhou <xzhou@redhat.com>
Subject: Re: [PATCH] overlay: copy-up lowerdir which has opaque xattr set
Date: Tue, 9 Aug 2016 12:09:46 +0800
Message-ID: <20160809040946.uxfx4ggalhvyw53j@xzhoul.usersys.redhat.com>
References: <1470677033-7035-1-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbcHIEJs (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 9 Aug 2016 00:09:48 -0400
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

Tested and ack.

Thanks,
Xiong

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
> +rm -rf $SCRATCH_MNT/testdir
> +mkdir -p $SCRATCH_MNT/testdir/visibledir
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +# mount overlay again, with lowerdir1 and lowerdir2 as multiple lowerdirs,
> +# and create a new file in testdir, triggers copyup from lowerdir,
> +# copyup should not copy overlayfs private xattr
> +$MOUNT_PROG -t overlay -o lowerdir=$lowerdir2:$lowerdir1,upperdir=$upperdir \
> +	-o workdir=$workdir none $SCRATCH_MNT
> +touch $SCRATCH_MNT/testdir/visiblefile
> +
> +# umount and mount overlay again, buggy kernel treats the copied-up dir as
> +# opaque, visibledir is not seen in merged dir.
> +$UMOUNT_PROG $SCRATCH_MNT
> +$MOUNT_PROG -t overlay -o lowerdir=$lowerdir2:$lowerdir1,upperdir=$upperdir \
> +	-o workdir=$workdir none $SCRATCH_MNT
> +ls $SCRATCH_MNT/testdir
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/014.out b/tests/overlay/014.out
> new file mode 100644
> index 0000000..ec09c4d
> --- /dev/null
> +++ b/tests/overlay/014.out
> @@ -0,0 +1,3 @@
> +QA output created by 014
> +visibledir
> +visiblefile
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 5c80566..71eaadb 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -16,3 +16,4 @@
>  011 auto quick
>  012 auto quick
>  013 auto quick
> +014 auto quick copyup
> -- 
> 2.7.4
> 
