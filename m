From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH for xfstests 3/4] overlay: add fsck.overlay opaque
 directory test
Date: Thu, 14 Dec 2017 15:25:34 +0200
Message-ID: <CAOQ4uxj2hm2KTPzf5iHT_FCr7LsBLynjPd0iSA_vFt_Zb_Hn5Q@mail.gmail.com>
References: <20171214064846.21587-1-yi.zhang@huawei.com> <20171214064846.21587-4-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:42232 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbdLNNZf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 08:25:35 -0500
In-Reply-To: <20171214064846.21587-4-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On Thu, Dec 14, 2017 at 8:48 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Add fsck.overlay test case to test it how to deal with invalid/valid
> opaque xattr in underlying directories of overlayfs.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  tests/overlay/202     | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/202.out |   5 ++
>  tests/overlay/group   |   1 +
>  3 files changed, 147 insertions(+)
>  create mode 100755 tests/overlay/202
>  create mode 100644 tests/overlay/202.out
>
> diff --git a/tests/overlay/202 b/tests/overlay/202
> new file mode 100755
> index 0000000..3f217ad
> --- /dev/null
> +++ b/tests/overlay/202
> @@ -0,0 +1,141 @@
> +#! /bin/bash
> +# FS QA Test 202
> +#
> +# Test fsck.overlay how to deal with opaque xattr in overlayfs.
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
> +. ./common/attr
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch
> +_require_attrs
> +_require_command "$FSCK_OVERLAY_PROG" fsck.overlay
> +
> +# remove all files from previous tests
> +_scratch_mkfs
> +
> +OVL_OPAQUE_XATTR="trusted.overlay.opaque"
> +OVL_OPAQUE_XATTR_VAL="y"
> +
> +# Set opaque xattr to a directory
> +set_opaque()
> +{
> +       local target=$1
> +
> +       $SETFATTR_PROG -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $target
> +}
> +
> +# Check opaque xattr
> +check_opaque()
> +{
> +       local dir=$1
> +
> +       opaque=$($GETFATTR_PROG --absolute-names --only-values -n \
> +               $OVL_OPAQUE_XATTR $dir)
> +
> +       [[ $opaque == $OVL_OPAQUE_XATTR_VAL ]] || \
> +               echo "Opaque xattr removed incorrectly"
> +}
> +
> +# Create test directories
> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
> +
> +mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir
> +
> +# Test invalid opaque xattr covering a nonexistent lower target, should remove
> +echo "+ Invalid opaque"
> +mkdir $lowerdir/testdir1
> +mkdir -p $upperdir/testdir/testdir2
> +set_opaque $lowerdir/testdir1
> +set_opaque $upperdir/testdir/testdir2
> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
> +       _fail "fsck should not fail"
> +$GETFATTR_PROG --absolute-names -d -m $OVL_OPAQUE_XATTR_VAL $lowerdir/testdir1
> +$GETFATTR_PROG --absolute-names -d -m $OVL_OPAQUE_XATTR_VAL $upperdir/testdir/testdir2
> +rm -rf $lowerdir/* $upperdir/*
> +
> +# Test valid opaque xattr in upper covering lower target, should not remove
> +echo "+ Valid opaque"
> +mkdir $lowerdir/testdir
> +touch $lowerdir/foo
> +mkdir $upperdir/testdir
> +mkdir $upperdir/foo
> +set_opaque $upperdir/testdir
> +set_opaque $upperdir/foo
> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \

Looks good except ;-p

> +       _fail "fsck should not fail"
> +check_opaque $upperdir/testdir
> +check_opaque $upperdir/foo
> +rm -rf $lowerdir/* $upperdir/*
> +
> +# Test valid opaque xattr in middle layer covering lower target, should not remove
> +echo "+ Valid opaque(2)"
> +mkdir $lowerdir2/testdir
> +touch $lowerdir2/foo
> +mkdir $lowerdir/testdir
> +mkdir $lowerdir/foo
> +set_opaque $lowerdir/testdir
> +set_opaque $lowerdir/foo
> +_overlay_fsck_dirs -a "$lowerdir:$lowerdir2" $upperdir $workdir >> \
> +       $seqres.full 2>&1 || _fail "fsck should not fail"
> +check_opaque $lowerdir/testdir
> +check_opaque $lowerdir/foo
> +rm -rf $lowerdir2/* $lowerdir/*
> +
> +# Test valid opaque in merged directory, should not remove
> +echo "+ Valid opaque(3)"
> +mkdir $lowerdir/testdir1
> +mkdir -p $upperdir/testdir1/testdir2
> +set_opaque $upperdir/testdir1/testdir2
> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
> +       _fail "fsck should not fail"
> +check_opaque $upperdir/testdir1/testdir2
> +rm -rf $lowerdir/* $upperdir/*
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/202.out b/tests/overlay/202.out
> new file mode 100644
> index 0000000..1aadc4d
> --- /dev/null
> +++ b/tests/overlay/202.out
> @@ -0,0 +1,5 @@
> +QA output created by 202
> ++ Invalid opaque
> ++ Valid opaque
> ++ Valid opaque(2)
> ++ Valid opaque(3)
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 7c5fcbb..e39b5e0 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -50,3 +50,4 @@
>  047 auto quick copyup hardlink
>  048 auto quick copyup hardlink
>  201 auto quick fsck
> +202 auto quick fsck
> --
> 2.5.0
>
