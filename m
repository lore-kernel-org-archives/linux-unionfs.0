Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Fri, 16 Mar 2018 10:53:20 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH V3] xfstest: overlay: Absolute redirect should be
 followed even if ancestor is opaque
Message-ID: <20180316025320.GL30836@localhost.localdomain>
References: <20180314131618.GA1001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180314131618.GA1001@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 14, 2018 at 09:16:18AM -0400, Vivek Goyal wrote:
> Typically, when following absolute redirect, if an opauqe dentry is
> found, lookup in further lower directories is stopped. But if a
> child dentry has another absolute redirect, then lookup in further
> lower layers should continue.
> 
> Say, following is example setup.
> upper:  /redirect (redirect=/a/b/c)
> lower1: /a/[b]/c       ([b] is opaque) (c has absolute redirect=/a/b/d/)
> lower0: /a/b/d/foo
> 
> "redirect" directory in upper should merge with lower1:/a/b/c/ and
> lower0:/a/b/d/, despite lower1:/a/b/ being opaque.
> 
> This example and kernel fix has come from Amir Goldstein. I am just putting
> a test for it to make sure its not broken down the line.
> 
> v3: Took care of more comments from amir.
>     - Added some comments.
>     - Added _overlay_check_scratch_dirs call.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tests/overlay/057     |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/057.out |    2 +
>  tests/overlay/group   |    1 
>  3 files changed, 103 insertions(+)
> 
> Index: xfstests-dev/tests/overlay/057
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/tests/overlay/057	2018-03-14 09:10:00.577179042 -0400
> @@ -0,0 +1,100 @@
> +#! /bin/bash
> +# FS QA Test No. 057
> +#
> +# Test absolute redirect is followed even if ancestor is opaque
> +#
> +# Typically, when following absolute redirect, if an opauqe dentry is
> +# found, lookup in further lower directories is stopped. But if a
> +# child dentry has another absolute redirect, then lookup in further
> +# lower layers should continue.
> +#
> +# Say, following is example setup.
> +# upper:  /redirect (redirect=/a/b/c)
> +# lower1: /a/[b]/c       ([b] is opaque) (c has absolute redirect=/a/b/d/)
> +# lower0: /a/b/d/foo
> +#
> +# "redirect" directory in upper should merge with lower1:/a/b/c/ and
> +# lower0:/a/b/d/, despite lower1:/a/b/ being opaque.
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
> +# We use non-default scratch underlying overlay dirs, we need to check
> +# them explicity after test.
> +_require_scratch_nocheck
> +_require_scratch_overlay_features redirect_dir
> +
> +# remove all files from previous tests
> +_scratch_mkfs
> +
> +# Create test directories
> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
> +workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
> +
> +mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir2
> +mkdir -p $lowerdir/origin
> +touch $lowerdir/origin/foo
> +_overlay_scratch_mount_dirs $lowerdir $lowerdir2 $workdir2 -o redirect_dir=on
> +
> +# Create opaque parent with absolute redirect child in middle layer
> +mkdir $SCRATCH_MNT/pure
> +mv $SCRATCH_MNT/origin $SCRATCH_MNT/pure/redirect
> +$UMOUNT_PROG $SCRATCH_MNT
> +_overlay_scratch_mount_dirs $lowerdir2:$lowerdir $upperdir $workdir -o redirect_dir=on
> +mv $SCRATCH_MNT/pure/redirect $SCRATCH_MNT/redirect

I think we'd better do a "ls $SCRATCH_MNT/redirect/" here too, right
after the rename and before mount cycle, to make sure 'foo' is there as
well. I can add it on commit (and change the .out file too) if this
change looks OK to you.

BTW, I stopped using eguan@redhat.com, please refer to the following
email (though it's not so obvious..)

[ANNOUNCE] fstests: master branch updated to 5e6514523342, and Eryu's comming role change
https://www.spinics.net/lists/fstests/msg09052.html

Thanks,
Eryu

> +
> +# Verify that redirects are followed after mount cycle
> +$UMOUNT_PROG $SCRATCH_MNT
> +_overlay_scratch_mount_dirs $lowerdir2:$lowerdir $upperdir $workdir -o redirect_dir=on
> +ls $SCRATCH_MNT/redirect/
> +
> +# check overlayfs
> +_overlay_check_scratch_dirs "$lowerdir2:$lowerdir" $upperdir $workdir -o redirect_dir=on
> +
> +# success, all done
> +status=0
> +exit
> Index: xfstests-dev/tests/overlay/group
> ===================================================================
> --- xfstests-dev.orig/tests/overlay/group	2018-02-28 15:27:29.981693615 -0500
> +++ xfstests-dev/tests/overlay/group	2018-03-12 09:31:45.692818432 -0400
> @@ -59,3 +59,4 @@
>  054 auto quick copyup redirect exportfs
>  055 auto quick copyup redirect exportfs nonsamefs
>  056 auto quick fsck
> +057 auto quick redirect
> Index: xfstests-dev/tests/overlay/057.out
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/tests/overlay/057.out	2018-03-12 13:09:42.061818432 -0400
> @@ -0,0 +1,2 @@
> +QA output created by 057
> +foo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
