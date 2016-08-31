From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] overlay: sgid inheritance over whiteout
Date: Wed, 31 Aug 2016 17:45:54 +0800
Message-ID: <20160831094554.GV27776@eguan.usersys.redhat.com>
References: <1472112972-11919-1-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759075AbcHaJqB (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Aug 2016 05:46:01 -0400
Content-Disposition: inline
In-Reply-To: <1472112972-11919-1-git-send-email-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org

On Thu, Aug 25, 2016 at 04:16:12PM +0800, Eryu Guan wrote:
> Newly created files and dirs should inherit sgit bit from parent
> dir, no matter the new files & dirs are created over whiteout or
> not.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

And please someone help review this patch?

Thanks,
Eryu

> ---
>  tests/overlay/015     | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/015.out |  6 ++++
>  tests/overlay/group   |  1 +
>  3 files changed, 104 insertions(+)
>  create mode 100755 tests/overlay/015
>  create mode 100644 tests/overlay/015.out
> 
> diff --git a/tests/overlay/015 b/tests/overlay/015
> new file mode 100755
> index 0000000..c39caed
> --- /dev/null
> +++ b/tests/overlay/015
> @@ -0,0 +1,97 @@
> +#! /bin/bash
> +# FS QA Test 015
> +#
> +# SGID bit inheritance over whiteout.
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
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch
> +_require_user
> +_require_group
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +# set umask to make output deterministic
> +umask 022
> +
> +# Create test dir in lower dir and set sgid bit
> +lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
> +mkdir -p $lowerdir/dir
> +chown $qa_user:$qa_group $lowerdir/dir
> +chmod 2775 $lowerdir/dir
> +touch $lowerdir/dir/testdir
> +touch $lowerdir/dir/testfile
> +touch $lowerdir/dir/hardlink
> +
> +# mount overlayfs, create new file and dir in parent dir with sgid bit set, new
> +# files and dirs all should inherit the sgid bit and the group
> +_scratch_mount
> +
> +# new dir
> +mkdir $SCRATCH_MNT/dir/newdir
> +stat -c "%A %G" $SCRATCH_MNT/dir/newdir
> +
> +# new file
> +touch $SCRATCH_MNT/dir/newfile
> +stat -c "%A %G" $SCRATCH_MNT/dir/newfile
> +
> +# new dir over whiteout
> +rm -f $SCRATCH_MNT/dir/testdir
> +mkdir $SCRATCH_MNT/dir/testdir
> +stat -c "%A %G" $SCRATCH_MNT/dir/testdir
> +
> +# new file over whiteout
> +rm -f $SCRATCH_MNT/dir/testfile
> +touch $SCRATCH_MNT/dir/testfile
> +stat -c "%A %G" $SCRATCH_MNT/dir/testfile
> +
> +# new hardlink over whiteout
> +rm -f $SCRATCH_MNT/dir/hardlink
> +ln $SCRATCH_MNT/dir/testfile $SCRATCH_MNT/dir/hardlink
> +stat -c "%A %G" $SCRATCH_MNT/dir/hardlink
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/015.out b/tests/overlay/015.out
> new file mode 100644
> index 0000000..263509d
> --- /dev/null
> +++ b/tests/overlay/015.out
> @@ -0,0 +1,6 @@
> +QA output created by 015
> +drwxr-sr-x fsgqa
> +-rw-r--r-- fsgqa
> +drwxr-sr-x fsgqa
> +-rw-r--r-- fsgqa
> +-rw-r--r-- fsgqa
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 71eaadb..84850b1 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -17,3 +17,4 @@
>  012 auto quick
>  013 auto quick
>  014 auto quick copyup
> +015 auto quick whiteout
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
