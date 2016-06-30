From: Xiong Zhou <xzhou@redhat.com>
Subject: Re: [PATCH 2/2] overlay: remove dir which contains whiteout from
 lower dir
Date: Thu, 30 Jun 2016 15:41:01 +0800
Message-ID: <20160630074101.GB10883@xzhoul.usersys.redhat.com>
References: <1467207574-11082-1-git-send-email-eguan@redhat.com>
 <1467207574-11082-2-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbcF3HlE (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 30 Jun 2016 03:41:04 -0400
Content-Disposition: inline
In-Reply-To: <1467207574-11082-2-git-send-email-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, xzhou@redhat.com

On Wed, Jun 29, 2016 at 09:39:34PM +0800, Eryu Guan wrote:
> Test the removal of a dir which contains whiteout from lower dir,
> which could crash the kernel.
> 
> The following kernel commit fixed this issue
> 84889d4 ovl: check dentry positiveness in ovl_cleanup_whiteouts()

Tested and ack these 2 cases.

One minor thought down there.


> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/overlay/010     | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/010.out |  2 ++
>  tests/overlay/group   |  1 +
>  3 files changed, 81 insertions(+)
>  create mode 100755 tests/overlay/010
>  create mode 100644 tests/overlay/010.out
> 
> diff --git a/tests/overlay/010 b/tests/overlay/010
> new file mode 100755
> index 0000000..5d1c2bd
> --- /dev/null
> +++ b/tests/overlay/010
> @@ -0,0 +1,78 @@
> +#! /bin/bash
> +# FS QA Test 010
> +#
> +# Remove dir which contains whiteout from lower dir.
> +#
> +# The following kernel commit fixed the kernel crash on the removal
> +# 84889d4 ovl: check dentry positiveness in ovl_cleanup_whiteouts()
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Red Hat Inc.  All Rights Reserved.
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
> +
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +# Need two lower dirs in this test, and we mount overlay ourselves,
> +# create upper and workdir as well
> +lowerdir1=$SCRATCH_DEV/$OVERLAY_LOWER_DIR.1
> +lowerdir2=$SCRATCH_DEV/$OVERLAY_LOWER_DIR.2
> +upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
> +workdir=$SCRATCH_DEV/$OVERLAY_WORK_DIR
> +mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
> +
> +# One lowerdir contains test dir and test files, the other contains whiteout
> +mkdir -p $lowerdir1/testdir $lowerdir2/testdir
> +touch $lowerdir1/testdir/a $lowerdir1/testdir/b
> +mknod $lowerdir2/testdir/a c 0 0
> +
> +# Mount overlayfs and remove testdir, which led to kernel crash
> +$MOUNT_PROG -t overlay -o lowerdir=$lowerdir2:$lowerdir1 \
> +	    -o upperdir=$upperdir,workdir=$workdir \
> +	    $SCRATCH_DEV $SCRATCH_MNT
> +rm -rf $SCRATCH_MNT/testdir

sleep 1 second here ?  Or we could panic after "Pass all 1 tests"
printed. [untested..]

Thanks,
Xiong
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/overlay/010.out b/tests/overlay/010.out
> new file mode 100644
> index 0000000..1d83a8d
> --- /dev/null
> +++ b/tests/overlay/010.out
> @@ -0,0 +1,2 @@
> +QA output created by 010
> +Silence is golden
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 3f08cd3..06cdb7e 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -12,3 +12,4 @@
>  007 auto quick
>  008 auto quick whiteout
>  009 auto quick
> +010 auto quick whiteout
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
