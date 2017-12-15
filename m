From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH for xfstests 4/4] overlay: add fsck.overlay redirect
 directory test
Date: Fri, 15 Dec 2017 14:42:15 +0800
Message-ID: <1cafcd12-6a4c-5c45-65ff-aa859463ad14@huawei.com>
References: <20171214064846.21587-1-yi.zhang@huawei.com>
 <20171214064846.21587-5-yi.zhang@huawei.com>
 <CAOQ4uxgx223rHqo=f+T-RDBk6jvbLuHE1Tm_wj+FT3XXJHvy8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:2688 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751506AbdLOGmz (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 01:42:55 -0500
In-Reply-To: <CAOQ4uxgx223rHqo=f+T-RDBk6jvbLuHE1Tm_wj+FT3XXJHvy8w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On 2017/12/14 21:44, Amir Goldstein Wrote:
> On Thu, Dec 14, 2017 at 8:48 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Add fsck.overlay test case to test it how to deal with invalid/valid
>> redirect xattr in underlying directories of overlayfs. It should remove
>> the invalid redirect dir xattr automatically and keep the valid one.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  tests/overlay/203     | 185 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/overlay/203.out |   8 +++
>>  tests/overlay/group   |   1 +
>>  3 files changed, 194 insertions(+)
>>  create mode 100755 tests/overlay/203
>>  create mode 100644 tests/overlay/203.out
>>
>> diff --git a/tests/overlay/203 b/tests/overlay/203
>> new file mode 100755
>> index 0000000..ccf1109
>> --- /dev/null
>> +++ b/tests/overlay/203
>> @@ -0,0 +1,185 @@
>> +#! /bin/bash
>> +# FS QA Test 203
>> +#
>> +# Test fsck.overlay how to deal with redirect xattr in overlayfs.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2017 Huawei.  All Rights Reserved.
>> +# Author: zhangyi (F) <yi.zhang@huawei.com>
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#-----------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1        # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +       cd /
>> +       rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/attr
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +_supported_fs overlay
>> +_supported_os Linux
>> +_require_scratch
>> +_require_attrs
>> +_require_command "$FSCK_OVERLAY_PROG" fsck.overlay
>> +
>> +# remove all files from previous tests
>> +_scratch_mkfs
>> +
>> +OVL_REDIRECT_XATTR="trusted.overlay.redirect"
>> +OVL_OPAQUE_XATTR="trusted.overlay.opaque"
>> +OVL_OPAQUE_XATTR_VAL="y"
>> +
>> +# Set redirect xattr to a directory
>> +set_redirect()
>> +{
>> +       local target=$1
>> +       local value=$2
>> +
>> +       $SETFATTR_PROG -n $OVL_REDIRECT_XATTR -v $value $target
>> +}
>> +
>> +# Check xattr is correct or not
>> +check_xattr()
>> +{
>> +       local name=$1
>> +       local expect=$2
>> +       local target=$3
>> +
>> +       value=$($GETFATTR_PROG --absolute-names --only-values -n $name $target)
>> +
>> +       [[ $value == $expect ]] || echo "$name xattr incorrect"
>> +}
>> +
> 
> It would be nice if you added check_redirect() and check_opaque() mini helpers.
> 
Will do.

>> +# Check whiteout
>> +check_whiteout()
>> +{
>> +       local target=$1
>> +
>> +       target_type=`stat -c "%F:%t,%T" $target`
>> +
>> +       [[ $target_type == "character special file:0,0" ]] || \
>> +               echo "Valid whiteout removed incorrectly"
>> +}
>> +
>> +# Create test directories
>> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
>> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
>> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
>> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
>> +
>> +mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir
>> +
>> +# Test invalid redirect xattr point to a nonexistent origin, should remove
>> +echo "+ Invalid redirect"
>> +mkdir $upperdir/testdir
>> +set_redirect $upperdir/testdir "abc"
>> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
>> +       _fail "fsck should not fail"
> 
> ;-p
> 
> BTW, if you like -a, I don't mind if you keep it as well.
> e2fsck seems to accept them both.
> 
Will change.

>> +$GETFATTR_PROG --absolute-names -d -m $OVL_REDIRECT_XATTR $upperdir/testdir
>> +rm -rf $upperdir/*
>> +
>> +# Test invalid redirect xattr point to a file origin, should remove
>> +echo "+ Invalid redirect(2)"
>> +touch $lowerdir/origin
>> +mkdir $upperdir/testdir
>> +set_redirect $upperdir/testdir "origin"
>> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
>> +       _fail "fsck should not fail"
>> +$GETFATTR_PROG --absolute-names -d -m $OVL_REDIRECT_XATTR $upperdir/testdir
>> +rm -rf $lowerdir/* $upperdir/*
>> +
>> +# Test valid redirect xattr point to a directory origin in the same directory,
>> +# should not remove
>> +echo "+ Valid redirect"
>> +mkdir $lowerdir/origin
>> +mknod $upperdir/origin c 0 0
>> +mkdir $upperdir/testdir
>> +set_redirect $upperdir/testdir "origin"
>> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
>> +       _fail "fsck should not fail"
>> +check_xattr $OVL_REDIRECT_XATTR "origin" $upperdir/testdir
>> +rm -rf $lowerdir/* $upperdir/*
>> +
>> +# Test valid redirect xattr point to a directory origin in different directories
>> +# should not remove
>> +echo "+ Valid redirect(2)"
>> +mkdir $lowerdir/origin
>> +mknod $upperdir/origin c 0 0
>> +mkdir -p $upperdir/testdir1/testdir2
>> +set_redirect $upperdir/testdir1/testdir2 "/origin"
>> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
>> +       _fail "fsck should not fail"
>> +check_xattr $OVL_REDIRECT_XATTR "/origin" $upperdir/testdir1/testdir2
>> +rm -rf $lowerdir/* $upperdir/*
>> +
>> +# Test missing whiteout with valid redirect directory, should fix whiteout
>> +echo "+ Missing whiteout"
>> +mkdir $lowerdir/origin
>> +mkdir $upperdir/testdir
>> +set_redirect $upperdir/testdir "origin"
>> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
>> +       _fail "fsck should not fail"
>> +check_xattr $OVL_REDIRECT_XATTR "origin" $upperdir/testdir
>> +check_whiteout $upperdir/origin
>> +rm -rf $lowerdir/* $upperdir/*
>> +
> 
> Please test the Valid "rename exchange redirect" case:
> set_redirect $upperdir/testdir1 "testdir2"
> set_redirect $upperdir/testdir2 "testdir1"
> fsck should not remove those redirects.
> 
I can add this case. I was wondering why add this special one? If I understand right,
these two xattrs will not remove after fsck if $lowerdir/testdir1 and $lowerdir/testdir2
exists, just like the second test case "Test valid redirect xattr point to a directory
origin in the same directory".

>> +# Test missing opaque xattr with valid redirect directory, should fix opaque
> 
> Why does fsck prefer redirect over non-redirect?
> Why is this not a private case of duplicate redirect?
> 
Sorry, I not follow.
This test, I simulate the case of the following:
1) mkdir -p lower/testdir upper/testdir
2) mount overlay
3) mv merge/testdir merge/dir2   (will create an whiteout 'testdir' in upper)
4) mkdir merge/testdir   (create opaque dir)
5) umount overlay
6) remove opaque xattr of upper/testdir (missing opaque xattr lead to lower/testdir/* expose)

Am I miss something?

>> +echo "+ Missing opaque"
>> +mkdir $lowerdir/origin
>> +mkdir $upperdir/origin
>> +mkdir $upperdir/testdir
>> +set_redirect $upperdir/testdir "origin"
>> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
>> +       _fail "fsck should not fail"
>> +check_xattr $OVL_REDIRECT_XATTR "origin" $upperdir/testdir
>> +check_xattr $OVL_OPAQUE_XATTR $OVL_OPAQUE_XATTR_VAL $upperdir/origin
>> +rm -rf $lowerdir/* $upperdir/*
>> +
>> +# Test duplicate redirect directories point to one origin, should fail in
>> +# -a 'auto' mode, should remove the duplicate one in -y 'yes' mode
>> +echo "+ Duplicate redirect"
>> +mkdir $lowerdir/origin
>> +mknod $upperdir/origin c 0 0
>> +mkdir $upperdir/testdir1
>> +mkdir $upperdir/testdir2
>> +set_redirect $upperdir/testdir1 "origin"
>> +set_redirect $upperdir/testdir2 "origin"
>> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 && \
>> +       _fail "fsck should fail"
>> +_overlay_fsck_dirs -y $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
>> +       _fail "fsck should not fail"
>> +check_xattr $OVL_REDIRECT_XATTR "origin" $upperdir/testdir2
>> +
> 
> So what guaranty you have that fsck clears testdir1 and not testdir2?
> Maybe check there is exactly one redirect left after fsck?
> What does fsck do with -y to the duplicate dir anyway?
> If copying from e2fsck behavior for duplicate referenced block, should
> copy the content of lower dirs to upper dir and make it opaque, but that can
> get nasty for a nested duplicate tree... OTOH, if user got to duplicate
> redirect dir by cp -a of a redirected upper dir, then a full copy of the tree
> is what user intended for.
> 
Let me see, now, fsck will remove the *later redirect xattr in 'yes' mode,
which means that we guess user want to copy the tree in upperdir if they
call cp -a when overlayfs is offline, not the whole tree expose in merge
layer. I think if we need to copy whole tree include lower dirs maybe too
complicated.

*) fsck just remove the later one when scaning, I understand it maybe cannot guaranty
fsck will clears testdir1 and not testdir2 for some base filesystem, so need to find
better way, thoughts?

Thanks,
Yi.
