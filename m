Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180223120325.33255-1-yangerkun@huawei.com>
References: <20180223120325.33255-1-yangerkun@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 24 Feb 2018 08:56:29 +0200
Message-ID: <CAOQ4uxhpn-JfWc9Hg-dX1OLdD1C8b2PCd+d5hq1V5=3mZ8jGtQ@mail.gmail.com>
Subject: Re: [xfstests PATCH] overlay: add origin test for fsck.overlay
Content-Type: text/plain; charset="UTF-8"
To: yangerkun <yangerkun@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, zhaohongjiang@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Feb 23, 2018 at 2:03 PM, yangerkun <yangerkun@huawei.com> wrote:
> Add fsck.overlay test case to test it how to deal with origin xattr
> in file or dir of overlayfs.
>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  tests/overlay/057     | 200 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/057.out |   6 ++
>  tests/overlay/group   |   1 +
>  3 files changed, 207 insertions(+)
>  create mode 100644 tests/overlay/057
>  create mode 100644 tests/overlay/057.out
>
> diff --git a/tests/overlay/057 b/tests/overlay/057
> new file mode 100644
> index 00000000..c2299c4f
> --- /dev/null
> +++ b/tests/overlay/057
> @@ -0,0 +1,200 @@
> +#! /bin/bash
> +# FS QA Test 057
> +#
> +# Test fsck.overlay how to deal with origin xattr in overlayfs.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2018 Huawei.  All Rights Reserved.
> +
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
> +status=1        # failure is the default!
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
> +#remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test start here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch_nocheck
> +_require_attrs
> +_require_command "$FSCK_OVERLAY_PROG" fsck.overlay
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +create_origin()
> +{
> +       local lowerdir=$1
> +       local upperdir=$2
> +       local workdir=$3
> +
> +       mkdir $lowerdir/testdir
> +       touch $lowerdir/testfile
> +
> +       _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
> +
> +       # Copy up files and directory
> +       touch $SCRATCH_MNT/{testdir,testfile}
> +       $UMOUNT_PROG $SCRATCH_MNT
> +}
> +
> +# Get the origin xattr of file or dir, maybe null
> +get_origin()
> +{
> +       local target=$1
> +       local value
> +
> +       value=`$GETFATTR_PROG --absolute-names --only-values -n \
> +               $OVL_XATTR_ORIGIN $target 2>&1`
> +       [ $? -eq 1 ] && return 1
> +
> +       if [ -n "$value" ]
> +       then
> +               value=`echo $value | base64`
> +               echo "0s"${value}
> +       else
> +               echo ""
> +       fi
> +       return 0
> +}
> +
> +set_origin()
> +{
> +       local target=$1
> +       local value=$2
> +
> +       if [ -n "$value" ]
> +       then
> +               $SETFATTR_PROG -n $OVL_XATTR_ORIGIN -v $value $target
> +       else
> +               $SETFATTR_PROG -n $OVL_XATTR_ORIGIN $target
> +       fi
> +}
> +
> +# Value of origin equals to the expect value?(1 : equal, 0 : not equal)
> +check_origin()
> +{
> +       local target=$1
> +       local expres=$2
> +       local expect=$3

No need for both 'expres' and 'expect'
Provide only 2nd argument 'expect' with expected value being either empty or
non-empty and expect the value of xattr to match, where failure to get_origin
and empty 'expect' is a match.


> +       local origin
> +
> +       origin=`get_origin $target`
> +       if [ $? -eq 1 ]
> +       then
> +               [ $expect -eq 0 ] || echo "Missing origin xattr"
> +       else
> +               [ "$origin" == "$expres" ] && ( [ $expect -eq 1 ] \
> +                       || echo "Invalid origin xattr" )
> +       fi
> +}
> +
> +# Create test directories
> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
> +
> +make_test_dirs()
> +{
> +       rm -rf $lowerdir $lowerdir2 $upperdir  $workdir
> +       mkdir -p $lowerdir $lowerdir2 $upperdir $workdir
> +}
> +
> +# Test valid origin xattr created when copyup, should not remove
> +make_test_dirs
> +echo "valid origin"
> +create_origin $lowerdir $upperdir $workdir
> +origin1=`get_origin $upperdir/testdir`
> +origin2=`get_origin $upperdir/testfile`
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +       echo "fsck should not fail"
> +check_origin $upperdir/testdir "$origin1" 1
> +check_origin $upperdir/testfile "$origin2" 1
> +
> +# Test invalid origin xattr point to a missing lower target, should remove
> +make_test_dirs
> +echo "invalid origin"
> +create_origin $lowerdir $upperdir $workdir
> +rm -rf $lowerdir/{testfile,testdir}
> +origin1=`get_origin $upperdir/testdir`
> +origin2=`get_origin $upperdir/testfile`
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +       echo "fsck should not fail"
> +check_origin $upperdir/testdir "$origin1" 0
> +check_origin $upperdir/testfile "$origin2" 0
> +
> +# Test invalid origin xattr when there is no lower layer, should remove
> +make_test_dirs
> +echo "invalid origin(2)"
> +create_origin $lowerdir2 $lowerdir $workdir
> +origin1=`get_origin $lowerdir/testdir`
> +origin2=`get_origin $lowerdir/testfile`

get_origin has no meaning if you expect nothing in check_origin.

> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +       echo "fsck should not fail"
> +check_origin $lowerdir/testdir "$origin1" 0
> +check_origin $lowerdir/testfile "$origin2" 0
> +
> +# Test invalid origin xattr which value of origin has changed, should remove
> +make_test_dirs
> +echo "invalid origin(3)"
> +create_origin $lowerdir $upperdir $workdir
> +origin=`get_origin $upperdir/testdir`
> +set_origin $upperdir/testdir $"origin"${origin}
> +origin=`get_origin $upperdir/testfile`
> +set_origin $upperdir/testfile $"origin"${origin}
> +origin1=`get_origin $upperdir/testdir`
> +origin2=`get_origin $upperdir/testfile`

get_origin has no meaning if you expect nothing in check_origin.

> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +       echo "fsck should not fail"
> +check_origin $upperdir/testdir "$origin1" 0
> +check_origin $upperdir/testfile "$origin2" 0
> +
> +# Test valid origin xattr which the value is NULL

How about another test where origin xattr are removed before fsck?

> +make_test_dirs
> +echo "valid origin(2)"
> +create_origin $lowerdir $upperdir $workdir
> +set_origin $upperdir/testdir ""
> +set_origin $upperdir/testfile ""
> +origin1=`get_origin $upperdir/testdir`
> +origin2=`get_origin $upperdir/testfile`

get_origin has no meaning if you know the value is "".
The test below would be more clear if you use "" instead
of "$origin.."

> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +       echo "fsck should not fail"
> +check_origin $upperdir/testdir "$origin1" 1
> +check_origin $upperdir/testfile "$origin2" 1
> +
> +# sucess, all done
> +status=0
> +exit
> diff --git a/tests/overlay/057.out b/tests/overlay/057.out
> new file mode 100644
> index 00000000..7c375880
> --- /dev/null
> +++ b/tests/overlay/057.out
> @@ -0,0 +1,6 @@
> +QA output created by 057
> +valid origin
> +invalid origin
> +invalid origin(2)
> +invalid origin(3)
> +valid origin(2)
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 65f1fe63..b595a003 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -59,3 +59,4 @@
>  054 auto quick copyup redirect exportfs
>  055 auto quick copyup redirect exportfs nonsamefs
>  056 auto quick fsck
> +057 auto quick fsck
> --
> 2.13.6
>
