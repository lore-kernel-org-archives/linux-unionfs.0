From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v2 2/4] overlay: add fsck.overlay whiteout test
Date: Tue, 6 Feb 2018 12:22:38 +0800
Message-ID: <20180206042238.GO18267@eguan.usersys.redhat.com>
References: <20180131102604.40701-1-yi.zhang@huawei.com>
 <20180131102604.40701-3-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180131102604.40701-3-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jan 31, 2018 at 06:26:02PM +0800, zhangyi (F) wrote:
> Add fsck.overlay test case to test it how to deal with orphan/valid
> whiteouts in underlying directories of overlayfs.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

So sorry for the late review! All four patches look fine to me overall,
just some minor issues inline.

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
> index 0000000..219fad4
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
                   ^^^^ 2018? Other tests also have 2017.
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
> +_require_scratch_nocheck
> +_require_command "$FSCK_OVERLAY_PROG" fsck.overlay

I noticed that you sourced common/attr and added _require_attrs in patch
3/4, but not 2/4 and 4/4, maybe we need it in all three tests.

> +
> +# remove all files from previous tests
> +_scratch_mkfs
> +
> +OVL_REDIRECT_XATTR="trusted.overlay.redirect"
> +OVL_OPAQUE_XATTR="trusted.overlay.opaque"

I think we can put these common ovl xattr keys (along with
OVL_IMPURE_XATTR)to common/overlay

> +OVL_OPAQUE_XATTR_VAL="y"
> +
> +# Check whiteout
> +check_whiteout()
> +{
> +	for arg in $*
> +	do

We prefer the format in fstests as

for arg in $*; do
...
done

> +		local ttype=`stat -c "%F:%t,%T" $arg`
> +
> +		[[ $ttype == "character special file:0,0" ]] || \

I'd quote $ttype (and other check_* functions in other tests) in case
stat returned nothing, then it runs into a syntax error

		[[ == "character special file:0,0" ]] # bash syntax error

and with $ttype quoted

		[[ "" == "character special file:0,0" ]]

it's a valid test.

> +			echo "Valid whiteout removed incorrectly"
> +	done
> +}
> +
> +# Create a whiteout
> +make_whiteout()
> +{
> +	for arg in $*
> +	do
> +		mknod $arg c 0 0
> +	done
> +}
> +
> +# Create an opaque directory
> +make_opaque_dir()
> +{
> +	local target=$1
> +
> +	mkdir -p $target
> +	$SETFATTR_PROG -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $target
> +}
> +
> +# Create a redirect directory
> +make_redirect_dir()
> +{
> +	local target=$1
> +	local value=$2
> +
> +	mkdir -p $target
> +	$SETFATTR_PROG -n $OVL_REDIRECT_XATTR -v $value $target
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
> +	rm -rf $lowerdir $lowerdir2 $upperdir $workdir
> +	mkdir -p $lowerdir $lowerdir2 $upperdir $workdir
> +}
> +
> +# Test orphan whiteout in lower and upper layer, should remove
> +echo "+ Orphan whiteout"
> +make_test_dirs
> +make_whiteout $lowerdir/foo $upperdir/{foo,bar}
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +	_fail "fsck should not fail"

No need to _fail, we could let test to continue, so just echo. The same
is true for all other tests.

> +ls $lowerdir
> +ls $upperdir
> +
> +# Test valid whiteout covering lower target, should not remove
> +echo "+ Valid whiteout"
> +make_test_dirs
> +touch $lowerdir2/{foo,bar}
> +make_whiteout $upperdir/foo $lowerdir/bar
> +
> +_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
> +	 $seqres.full 2>&1 || _fail "fsck should not fail"
> +check_whiteout $upperdir/foo $lowerdir/bar
> +
> +# Test orphan whiteout in opaque directory, should remove
> +echo "+ Orphan whiteout(2)"
> +make_test_dirs
> +mkdir $lowerdir/testdir
> +touch $lowerdir/testdir/foo
> +make_opaque_dir $upperdir/testdir
> +make_whiteout $upperdir/testdir/foo
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +	_fail "fsck should not fail"
> +ls $upperdir/testdir
> +
> +# Test orphan whiteout whose parent path is not an merged directory,
> +# should remove
> +echo "+ Orphan whiteout(3)"
> +make_test_dirs
> +mkdir $lowerdir2/{testdir1,testdir2,testdir3}
> +touch $lowerdir2/{testdir1/foo,testdir2/foo,testdir3/foo}
> +mkdir $upperdir/{testdir1,testdir2,testdir3,testdir4}
> +touch $lowerdir/testdir1
> +make_whiteout $lowerdir/testdir2
> +make_opaque_dir $lowerdir/testdir3
> +make_whiteout $upperdir/{testdir1/foo,/testdir2/foo,testdir3/foo,testdir4/foo}
> +
> +_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
> +	$seqres.full 2>&1 || _fail "fsck should not fail"
> +ls $upperdir/testdir1
> +ls $upperdir/testdir2
> +ls $upperdir/testdir3
> +ls $upperdir/testdir4
> +
> +# Test orphan whiteout in redirect directory, should remove
> +echo "+ Orphan whiteout(4)"
> +make_test_dirs
> +mkdir $lowerdir/{testdir,origin}
> +touch $lowerdir/testdir/foo
> +make_redirect_dir $upperdir/testdir "origin"
> +make_whiteout $upperdir/testdir/foo
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +	_fail "fsck should not fail"
> +ls $upperdir/testdir
> +
> +# Test valid whiteout in redirect directory cover file in lower
> +# redirect origin directory, should not remove
> +echo "+ Valid whiteout(2)"
> +make_test_dirs
> +mkdir $lowerdir/origin
> +touch $lowerdir/origin/foo
> +make_redirect_dir $upperdir/testdir "origin"
> +make_whiteout $upperdir/testdir/foo
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +	_fail "fsck should not fail"
> +check_whiteout $upperdir/testdir/foo
> +
> +# Test valid whiteout covering lower target whose parent directory
> +# merge with a redirect directory in the middle layer, should not remove.
> +echo "+ Valid whiteout(3)"
> +make_test_dirs
> +mkdir -p $lowerdir2/origin/subdir
> +touch $lowerdir2/origin/subdir/foo
> +make_redirect_dir $lowerdir/testdir "origin"
> +mkdir -p $upperdir/testdir/subdir
> +make_whiteout $upperdir/testdir/subdir/foo
> +
> +_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p \
> +	>> $seqres.full 2>&1 || _fail "fsck should not fail"
> +check_whiteout $upperdir/testdir/subdir/foo
> +
> +# Test invalid whiteout in opaque subdirectory in a redirect directory,
> +# should remove
> +echo "+ Orphan whiteout(5)"
> +make_test_dirs
> +mkdir -p $lowerdir/origin/subdir
> +touch $lowerdir/origin/subdir/foo
> +make_redirect_dir $upperdir/testdir "origin"
> +make_opaque_dir $upperdir/testdir/subdir
> +make_whiteout $upperdir/testdir/subdir/foo
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +	_fail "fsck should not fail"
> +ls $upperdir/testdir/subdir
> +
> +# Test valid whiteout in reidrect subdirectory in a opaque directory
> +# covering lower target, should not remove
> +echo "+ Valid whiteout(4)"
> +make_test_dirs
> +mkdir $lowerdir/origin
> +touch $lowerdir/origin/foo
> +make_opaque_dir $upperdir/testdir
> +make_redirect_dir $upperdir/testdir/subdir "/origin"
> +make_whiteout $upperdir/testdir/subdir/foo
> +
> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
> +        _fail "fsck should not fail"
> +check_whiteout $upperdir/testdir/subdir/foo
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

It'd be great if you could help rebase the patchset against latest
master in next version. Thanks a lot!

All the comments here apply to the other two tests.

Thanks,
Eryu
