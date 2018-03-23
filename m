Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180322113834.48168-1-yi.zhang@huawei.com>
References: <20180322113834.48168-1-yi.zhang@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 23 Mar 2018 14:37:44 +0300
Message-ID: <CAOQ4uxi67xAZGL2rEDNffKMybqKiUfmm+e-yFPyT32y5uaDRwg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] overlay: test mount operation if overlay has
 unkown feature set
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <guaneryu@gmail.com>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 22, 2018 at 1:38 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Test mount operation if the underlying root dir have unknown
> feature set:
> - Check unknown compat/ro_compat/incompat feature on the
>   upper root dir
> - Check unknown compat/ro_compat/incompat feature on the
>   lower root dir which used to be the upper root dir
>
> Mount operation should fail if unknown incompat feature is
> detected on the underlying root dir, and read-write mount should
> fail if unknown ro_compat feature is detected on the underlying
> root dir, and mount should succeed otherwise.

Hi Zhangyi,

Thanks for working on this.

I will start with review of tests and then move on to implementation.

This test looks mostly good. There is quite a lot of repetition, so test
could have made use of more helpers to make test shorter and easier to read,
but its not that too bad to read as is.

One thing that is important to note when posting the tests is that they
test a feature that is not even past design review, so they should NOT
be considered for merging yet.


>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  common/overlay        |   3 +
>  tests/overlay/058     | 173 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/058.out |   2 +
>  tests/overlay/group   |   1 +
>  4 files changed, 179 insertions(+)
>  create mode 100755 tests/overlay/058
>  create mode 100644 tests/overlay/058.out
>
> diff --git a/common/overlay b/common/overlay
> index 441827b8..431fb847 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -10,6 +10,9 @@ export OVL_XATTR_IMPURE="trusted.overlay.impure"
>  export OVL_XATTR_ORIGIN="trusted.overlay.origin"
>  export OVL_XATTR_NLINK="trusted.overlay.nlink"
>  export OVL_XATTR_UPPER="trusted.overlay.upper"
> +export OVL_XATTR_FEATURE_COMPAT="trusted.overlay.feature_compat"
> +export OVL_XATTR_FEATURE_RO_COMPAT="trusted.overlay.feature_ro_compat"
> +export OVL_XATTR_FEATURE_INCOMPAT="trusted.overlay.feature_incompat"
>
>  # helper function to do the actual overlayfs mount operation
>  _overlay_mount_dirs()
> diff --git a/tests/overlay/058 b/tests/overlay/058
> new file mode 100755
> index 00000000..6f88730e
> --- /dev/null
> +++ b/tests/overlay/058
> @@ -0,0 +1,173 @@
> +#! /bin/bash
> +# FS QA Test 058
> +#
> +# Test mount operation if the underlying root dir have unknown
> +# feature set:
> +# - Check unknown compat/ro_compat/incompat feature on the
> +#   upper root dir
> +# - Check unknown compat/ro_compat/incompat feature on the
> +#   lower root dir which used to be the upper root dir
> +#
> +# Mount operation should fail if unknown incompat feature is
> +# detected on the underlying root dir, and read-write mount should
> +# fail if unknown ro_compat feature is detected on the underlying
> +# root dir, and mount should succeed otherwise.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2018 Huawei.  All Rights Reserved.
> +# Author: zhangyi (F) <yi.zhang@huawei.com>
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
> +. ./common/attr
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch_nocheck
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +# Set compat/ro_compat/incompat features to the underlying root dir
> +set_feature()
> +{
> +       local compat_type=$1
> +       local feature=$2
> +       local target=$3
> +
> +       $SETFATTR_PROG -n $compat_type -v $feature $target
> +}
> +
> +# Define lowerdir, middledir, upperdir and workdir
> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
> +middledir=$OVL_BASE_SCRATCH_MNT/middle
> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
> +workdir=$OVL_BASE_SCRATCH_MNT/work
> +
> +make_test_dir()
> +{
> +       rm -rf $lowerdir $middledir $upperdir $workdir
> +       mkdir -p $lowerdir $middledir $upperdir $workdir
> +}
> +
> +# Mount overlay with unknown compat feature, expect success
> +make_test_dir
> +set_feature $OVL_XATTR_FEATURE_COMPAT "unknown" $upperdir
> +
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o ro && \
> +               $UMOUNT_PROG $SCRATCH_MNT
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir && \
> +               $UMOUNT_PROG $SCRATCH_MNT
> +
> +
> +# Mount overlay with unknown ro_rompat feature, expect success
> +# on read-only mount, expect failure on read-write mount
> +make_test_dir
> +set_feature $OVL_XATTR_FEATURE_RO_COMPAT "unknown" $upperdir
> +
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir &>> $seqres.full && \
> +               echo "Mount should fail" && $UMOUNT_PROG $SCRATCH_MNT
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o ro
> +_scratch_remount rw &>> $seqres.full && echo "Remount should fail"
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +
> +# Mount overlay with unknown inrompat feature, expect failure
> +make_test_dir
> +set_feature $OVL_XATTR_FEATURE_INCOMPAT "unknown" $upperdir
> +
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir &>> $seqres.full && \
> +               echo "Mount should fail" && $UMOUNT_PROG $SCRATCH_MNT
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o ro &>> $seqres.full && \
> +               echo "Mount should fail" && $UMOUNT_PROG $SCRATCH_MNT
> +
> +
> +# Mount overlay with unknown compat feature on the lower layer which
> +# used to be the upper layer, expect success
> +make_test_dir
> +set_feature $OVL_XATTR_FEATURE_COMPAT "unknown" $middledir
> +
> +_overlay_scratch_mount_dirs "$middledir:$lowerdir" $upperdir $workdir -o ro && \
> +               $UMOUNT_PROG $SCRATCH_MNT
> +_overlay_scratch_mount_dirs "$middledir:$lowerdir" $upperdir $workdir && \
> +               $UMOUNT_PROG $SCRATCH_MNT
> +
> +$MOUNT_PROG -t overlay -o"lowerdir=$middledir:$lowerdir" \
> +               $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT && \
> +               $UMOUNT_PROG $SCRATCH_MNT
> +
> +
> +# Mount overlay with unknown ro_compat feature on the lower layer
> +# which used to be the upper layer, expect success on read-only
> +# mount, and expect failure on read-write mount
> +make_test_dir
> +set_feature $OVL_XATTR_FEATURE_RO_COMPAT "unknown" $middledir
> +
> +_overlay_scratch_mount_dirs "$middledir:$lowerdir" $upperdir $workdir \
> +               &>> $seqres.full && echo "Mount should fail" && \
> +               $UMOUNT_PROG $SCRATCH_MNT
> +_overlay_scratch_mount_dirs "$middledir:$lowerdir" $upperdir $workdir -o ro
> +_scratch_remount rw &>> $seqres.full && echo "Remount should fail"
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +$MOUNT_PROG -t overlay -o"lowerdir=$middledir:$lowerdir" \
> +               $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT && \
> +               $UMOUNT_PROG $SCRATCH_MNT
> +
> +
> +# Mount overlay with unknown incompat feature on the lower layer
> +# which used to be the upper layer, expect failure
> +make_test_dir
> +set_feature $OVL_XATTR_FEATURE_INCOMPAT "unknown" $middledir
> +
> +_overlay_scratch_mount_dirs "$middledir:$lowerdir" $upperdir $workdir \
> +               &>> $seqres.full && echo "Mount should fail" && \
> +               $UMOUNT_PROG $SCRATCH_MNT
> +_overlay_scratch_mount_dirs "$middledir:$lowerdir" $upperdir $workdir -o ro \
> +               &>> $seqres.full && echo "Mount should fail" && \
> +               $UMOUNT_PROG $SCRATCH_MNT
> +
> +$MOUNT_PROG -t overlay -o"lowerdir=$middledir:$lowerdir" \
> +               $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT &>> $seqres.full && \
> +               echo "Mount should fail" && \
> +               $UMOUNT_PROG $SCRATCH_MNT
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/overlay/058.out b/tests/overlay/058.out
> new file mode 100644
> index 00000000..fb5ca60b
> --- /dev/null
> +++ b/tests/overlay/058.out
> @@ -0,0 +1,2 @@
> +QA output created by 058
> +Silence is golden
> diff --git a/tests/overlay/group b/tests/overlay/group
> index c49ae3aa..605a9f56 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -60,3 +60,4 @@
>  055 auto quick copyup redirect exportfs nonsamefs
>  056 auto quick fsck
>  057 auto quick redirect
> +058 auto quick feature

mount group seems also appropriate.

Thanks,
Amir.
