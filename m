From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH xfstest v2 2/4] overlay: add fsck.overlay whiteout test
Date: Thu, 28 Dec 2017 14:11:16 +0200
Message-ID: <CAOQ4uxjOyDY7O9vX8zpv8=MzZ3LCNSLsthckz2FWSz-G_cdr0g@mail.gmail.com>
References: <20171228114933.47759-1-yi.zhang@huawei.com> <20171228114933.47759-3-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171228114933.47759-3-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Thu, Dec 28, 2017 at 1:49 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Add fsck.overlay test case to test it how to deal with orphan/valid
> whiteouts in underlying directories of overlayfs.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Very nice!
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

minor suggestions below

> ---
>  tests/overlay/201     | 232 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/201.out |  10 +++
>  tests/overlay/group   |   1 +
>  3 files changed, 243 insertions(+)
>  create mode 100755 tests/overlay/201
>  create mode 100644 tests/overlay/201.out
>
> diff --git a/tests/overlay/201 b/tests/overlay/201
> new file mode 100755
> index 0000000..6331b61
> --- /dev/null
> +++ b/tests/overlay/201
> @@ -0,0 +1,232 @@
> +#! /bin/bash
> +# FS QA Test 201
> +#
> +# Test fsck.overlay how to deal with whiteouts in overlayfs.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Huawei.  All Rights Reserved.
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
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch
> +_require_command "$FSCK_OVERLAY_PROG" fsck.overlay
> +
> +# remove all files from previous tests
> +_scratch_mkfs
> +
> +OVL_REDIRECT_XATTR="trusted.overlay.redirect"
> +OVL_OPAQUE_XATTR="trusted.overlay.opaque"
> +OVL_OPAQUE_XATTR_VAL="y"
> +
> +# Check whiteout
> +check_whiteout()
> +{
> +       local target=$1
> +
> +       target_type=`stat -c "%F:%t,%T" $target`
> +
> +       [[ $target_type == "character special file:0,0" ]] || \
> +               echo "Valid whiteout removed incorrectly"
> +}
> +
> +# Create a whiteout
> +make_whiteout()
> +{
> +       local target=$1
> +
> +       mknod $target c 0 0
> +}
> +
> +# Create an opaque directory
> +make_opaque_dir()
> +{
> +       local target=$1
> +
> +       mkdir -p $target
> +       $SETFATTR_PROG -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $target
> +}
> +
> +# Create a redirect directory
> +make_redirect_dir()
> +{
> +       local target=$1
> +       local value=$2
> +
> +       mkdir -p $target
> +       $SETFATTR_PROG -n $OVL_REDIRECT_XATTR -v $value $target
> +}
> +
> +# Create test directories
> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
> +
> +mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir

Would be nice to pack these mkdir after rm -rf as make_dirs helper
to run before every test case, instead of mkdir once and rm -rf after each test.

> +
> +# Test orphan whiteout in lower and upper layer, should remove
> +echo "+ Orphan whiteout"
> +make_whiteout $lowerdir/foo
> +make_whiteout $upperdir/foo
> +make_whiteout $upperdir/bar
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +       _fail "fsck should not fail"
> +ls $lowerdir
> +ls $upperdir
> +rm -rf $lowerdir/* $upperdir/*
> +
> +# Test valid whiteout covering lower target, should not remove
> +echo "+ Valid whiteout"
> +touch $lowerdir2/foo $lowerdir2/bar
> +make_whiteout $upperdir/foo
> +make_whiteout $lowerdir/bar
> +
> +_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
> +        $seqres.full 2>&1 || _fail "fsck should not fail"
> +check_whiteout $upperdir/foo
> +check_whiteout $lowerdir/bar
> +rm -rf $lowerdir/* $lowerdir2/* $upperdir/*
> +
> +# Test orphan whiteout in opaque directory, should remove
> +echo "+ Orphan whiteout(2)"
> +mkdir $lowerdir/testdir
> +touch $lowerdir/testdir/foo
> +make_opaque_dir $upperdir/testdir
> +make_whiteout $upperdir/testdir/foo
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +       _fail "fsck should not fail"
> +ls $upperdir/testdir
> +rm -rf $lowerdir/* $upperdir/*
> +
> +# Test orphan whiteout whose parent path is not an merged directory,
> +# should remove
> +echo "+ Orphan whiteout(3)"
> +mkdir $lowerdir2/testdir1 $lowerdir2/testdir2 $lowerdir2/testdir3
> +touch $lowerdir2/testdir1/foo $lowerdir2/testdir2/foo $lowerdir2/testdir3/foo
> +mkdir $upperdir/testdir1 $upperdir/testdir2 $upperdir/testdir3

How about mkdir $upperdir/testdir4 (case of parent is a pure upper dir)

> +touch $lowerdir/testdir1
> +make_whiteout $lowerdir/testdir2
> +make_opaque_dir $lowerdir/testdir3
> +make_whiteout $upperdir/testdir1/foo
> +make_whiteout $upperdir/testdir2/foo
> +make_whiteout $upperdir/testdir3/foo
> +
> +_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
> +       $seqres.full 2>&1 || _fail "fsck should not fail"
> +ls $upperdir/testdir1
> +ls $upperdir/testdir2
> +ls $upperdir/testdir3
> +rm -rf $lowerdir/* $lowerdir2/* $upperdir/*
> +
> +# Test orphan whiteout in redirect directory, should remove
> +echo "+ Orphan whiteout(4)"
> +mkdir $lowerdir/testdir
> +mkdir $lowerdir/origin
> +touch $lowerdir/testdir/foo
> +make_redirect_dir $upperdir/testdir "origin"
> +make_whiteout $upperdir/testdir/foo
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +       _fail "fsck should not fail"
> +ls $upperdir/testdir
> +rm -rf $lowerdir/* $upperdir/*
> +
> +# Test valid whiteout in redirect directory cover file in lower
> +# redirect origin directory, should not remove
> +echo "+ Valid whiteout(2)"
> +mkdir $lowerdir/origin
> +touch $lowerdir/origin/foo
> +make_redirect_dir $upperdir/testdir "origin"
> +make_whiteout $upperdir/testdir/foo
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +       _fail "fsck should not fail"
> +check_whiteout $upperdir/testdir/foo
> +rm -rf $lowerdir/* $upperdir/*
> +
> +# Test valid whiteout covering lower target whose parent directory
> +# merge with a redirect directory in the middle layer, should not remove.
> +echo "+ Valid whiteout(3)"
> +mkdir -p $lowerdir2/origin/subdir
> +touch $lowerdir2/origin/subdir/foo
> +make_redirect_dir $lowerdir/testdir "origin"
> +mkdir -p $upperdir/testdir/subdir
> +make_whiteout $upperdir/testdir/subdir/foo
> +
> +_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p \
> +       >> $seqres.full 2>&1 || _fail "fsck should not fail"
> +check_whiteout $upperdir/testdir/subdir/foo
> +rm -rf $lowerdir/* $lowerdir2/* $upperdir/*
> +
> +# Test invalid whiteout in opaque subdirectory in a redirect directory,
> +# should remove
> +echo "+ Orphan whiteout(5)"
> +mkdir -p $lowerdir/origin/subdir
> +touch $lowerdir/origin/subdir/foo
> +make_redirect_dir $upperdir/testdir "origin"
> +make_opaque_dir $upperdir/testdir/subdir
> +make_whiteout $upperdir/testdir/subdir/foo
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +       _fail "fsck should not fail"
> +ls $upperdir/testdir/subdir
> +rm -rf $lowerdir/* $upperdir/*
> +
> +# Test valid whiteout in reidrect subdirectory in a opaque directory
> +# covering lower target, should not remove
> +echo "+ Valid whiteout(4)"
> +mkdir $lowerdir/origin
> +touch $lowerdir/origin/foo
> +make_opaque_dir $upperdir/testdir
> +make_redirect_dir $upperdir/testdir/subdir "/origin"
> +make_whiteout $upperdir/testdir/subdir/foo
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +        _fail "fsck should not fail"
> +check_whiteout $upperdir/testdir/subdir/foo
> +rm -rf $lowerdir/* $upperdir/*
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/201.out b/tests/overlay/201.out
> new file mode 100644
> index 0000000..157bb85
> --- /dev/null
> +++ b/tests/overlay/201.out
> @@ -0,0 +1,10 @@
> +QA output created by 201
> ++ Orphan whiteout
> ++ Valid whiteout
> ++ Orphan whiteout(2)
> ++ Orphan whiteout(3)
> ++ Orphan whiteout(4)
> ++ Valid whiteout(2)
> ++ Valid whiteout(3)
> ++ Orphan whiteout(5)
> ++ Valid whiteout(4)
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 7e541e4..7c5fcbb 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -49,3 +49,4 @@
>  044 auto quick copyup hardlink nonsamefs
>  047 auto quick copyup hardlink
>  048 auto quick copyup hardlink
> +201 auto quick fsck
> --
> 2.5.0
>
