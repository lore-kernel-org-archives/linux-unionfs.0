From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V3] overlay: Test consistent d_ino feature for non-samefs setup
Date: Thu, 12 Oct 2017 17:53:26 +0530
Message-ID: <1938763.T7SD7VcFGF@localhost.localdomain>
References: <20171009080615.19375-1-chandan@linux.vnet.ibm.com> <CAOQ4uxhBOXfv+E--QtwRP6tOf1o83-n2sorqVD__ysESuY5ghQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhBOXfv+E--QtwRP6tOf1o83-n2sorqVD__ysESuY5ghQ@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Thursday, October 12, 2017 1:17:57 PM IST Amir Goldstein wrote:
> On Mon, Oct 9, 2017 at 11:06 AM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > This commit adds a test to verify consistent d_ino feature when
> > the overlayfs instance is composed of two different underlying
> > filesystem instances.
> >
> > For example,
> > $ mount -t xfs /dev/loop0 /mnt/test
> > $ mount -t xfs /dev/loop1 /mnt/scratch
> > $ mkdir /mnt/scratch/upper
> > $ mkdir /mnt/scratch/work
> > $ mount -t overlay overlay -o lowerdir=/mnt/test \
> >         -o upperdir=/mnt/scratch/upper \
> >         -o workdir=/mnt/scratch/work /mnt/merge
> >
> > The goal of this test is to verify that the inode numbers returned by
> > readdir(3) (i.e. dirent->d_ino) are consistent with inode numbers
> > returned by stat(2) (i.e. stat->st_ino) in all the below listed cases,
> > - Parent's (i.e. "..") d_ino must always be calculated because a
> >   pure dir can be residing inside a merged dir.
> > - d_ino for "." must always be calculated because the present
> >   directory can have a copy-up origin.
> > - Verify d_ino of '.' and '..' before and after dir becomes impure.
> >   While at it also verify if trusted.overlay.impure xattr is
> >   set/reset appropriately and invalidation of readdir cache.
> > - Verify copied up file's (inside a impure dir) d_ino.
> > - Verify invalidation of readdir cache.
> > - Verify d_ino values corresponding to "." and ".." entries of a
> >   pure lower dir.
> > - Verify d_ino of ".." entry of a merged dir.
> > - Verify pure lower residing in dir which has another lower layer
> >
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> Pending fixing of the nits below.
> 
> > ---
> 
> Chandan,
> 
> When posting tests for functionality/bugfix not yet in upstream, it is
> important to
> make a note for Eryu about this with the current status of pending
> patches. (in review).
> This status doesn't need to be commit message as it looses context when
> upstream moves on.

Ok. I will do that.
> 
> For historic context, overlayfs did not use to be POSIX compliant w.r.t constant
> inode numbers and consistent st_ino/d_ino.
> v4.12 fixes constant st_ino for samefs.
> v4.14-rc1 fixes consistent st_ino/d_ino for samefs.
> Chandan's work aims to fix both cases for non-samefs configuration.
> 
> This test checks for consistent st_ino/d_ino for non-samefs and is
> therefore expected
> to fail with upstream kernel, and pass with Chandan's patches.
> We should also add a non-samefs variant of overlay/017 (Test constant
> inode numbers
> across copy up).
> 
> > Changelog:
> > v1->v2:
> >  Address the following review comments from Amir.
> >  1. overlay/041 now uses _overlay_scratch_mount_dirs() introduced by the patch
> >     "overlay: create helper _overlay_scratch_mount_dirs()" (unmerged patch from
> >     Amir Goldstein).
> >  2. Use _scratch_mkfs() instead of manually setting of the base filesystem.
> >  3. Use a directory in $OVL_BASE_TEST_DIR as the overlay instance's lowerdir.
> >  4. Remove redundant invocation of "chown" operation on a regular file to cause
> >     copy-up to occur.
> >
> > v2->v3:
> >  1. Remove debug code. Thanks to Amir for spotting this.
> >  2. Add a commit message describing non-samefs setup of an overlayfs instance
> >     and the scenarios being tested by this test.
> >
> >  tests/overlay/041     | 195 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/041.out |   2 +
> >  tests/overlay/group   |   1 +
> >  3 files changed, 198 insertions(+)
> >  create mode 100755 tests/overlay/041
> >  create mode 100644 tests/overlay/041.out
> >
> > diff --git a/tests/overlay/041 b/tests/overlay/041
> > new file mode 100755
> > index 0000000..0bc4c83
> > --- /dev/null
> > +++ b/tests/overlay/041
> > @@ -0,0 +1,195 @@
> > +#! /bin/bash
> > +# FSQA Test No. 041
> > +#
> > +# Test consistent d_ino numbers on non-samefs setup
> > +# This is a variant of overlay/038 to test consistent d_ino numbers
> > +# for non-samefs setup.
> > +#
> > +#-----------------------------------------------------------------------
> > +#
> > +# Copyright (C) 2017 IBM Corporation. All Rights Reserved.
> > +# Author: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1       # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +       cd /
> > +       rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/attr
> > +
> > +# real QA test starts here
> > +_supported_fs overlay
> > +_supported_os Linux
> > +_require_scratch
> > +_require_test
> > +_require_attrs
> > +_require_test_program "t_dir_type"
> > +
> > +rm -f $seqres.full
> > +
> > +lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
> > +rm -rf $lowerdir
> > +mkdir $lowerdir
> > +
> > +# Create our test files.
> > +mkdir $lowerdir/test_dir/
> > +mkdir $lowerdir/test_dir/pure_lower_dir
> > +mkdir $lowerdir/test_dir/merged_dir
> > +touch $lowerdir/test_file
> > +
> > +_scratch_mkfs
> > +
> > +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> > +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> > +
> > +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
> > +
> > +test_dir=$SCRATCH_MNT/test_dir/
> > +merged_dir=$test_dir/merged_dir
> > +pure_upper_dir=$merged_dir/pure_upper_dir
> > +
> > +mkdir -p $pure_upper_dir
> > +
> > +merged_dir_st_ino=$(stat -c '%i' $merged_dir)
> > +
> > +# Pure dir's parent d_ino must always be calculated because
> > +# it can be residing inside a merged dir.
> > +parent_d=$($here/src/t_dir_type $pure_upper_dir $merged_dir_st_ino)
> > +[[ $parent_d == ".. d" ]] || \
> > +       echo "Pure dir inside a merged dir: Invalid d_ino reported for .."
> > +
> > +# d_ino for "." must always be calculated because the present
> > +# directory can have a copy-up origin.
> > +current_d=$($here/src/t_dir_type $merged_dir $merged_dir_st_ino)
> > +[[ $current_d == ". d" ]] || echo "Merged dir: Invalid d_ino reported for ."
> > +
> > +# Verify d_ino of '.' and '..' before and after dir becomes impure.
> > +impure_dir=$test_dir/impure_dir
> > +mkdir -p $impure_dir
> > +
> > +impure_dir_st_ino=$(stat -c '%i' $impure_dir)
> > +impure_dir_parent_st_ino=$(stat -c '%i' $test_dir)
> > +
> > +# Before $impure_dir becomes impure
> > +parent_d=$($here/src/t_dir_type $impure_dir $impure_dir_parent_st_ino)
> > +[[ $parent_d == ".. d" ]] || \
> > +    echo "Before dir becomes impure: Invalid d_ino reported for .."
> > +
> > +current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
> > +[[ $current_d == ". d" ]] || \
> > +    echo "Before dir becomes impure: Invalid d_ino reported for ."
> > +
> > +
> > +mv $SCRATCH_MNT/test_file $impure_dir
> > +test_file_st_ino=$(stat -c '%i' $impure_dir/test_file)
> > +
> > +impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impure' \
> > +                       $upperdir/test_dir/impure_dir)
> > +[[ $impure == "y" ]] || echo "Impure directory missing impure xattr"
> > +
> > +# After $impure_dir becomes impure
> > +parent_d=$($here/src/t_dir_type $impure_dir $impure_dir_parent_st_ino)
> > +[[ $parent_d == ".. d" ]] || \
> > +    echo "After dir becomes impure: Invalid d_ino reported for .."
> > +
> > +current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
> > +[[ $current_d == ". d" ]] || \
> > +    echo "After dir becomes impure: Invalid d_ino reported for ."
> > +
> > +# Verify copy up file's d_ino
> > +file_d=$($here/src/t_dir_type $impure_dir $test_file_st_ino)
> > +[[ $file_d == "test_file f" ]] || \
> > +       echo "Impure dir: Invalid d_ino reported for entry with copy-up origin"
> > +
> > +# Make $impure_dir pure
> > +rm -rf $impure_dir/test_file
> > +
> > +# Verify invalidation of readdir cache
> > +$here/src/t_dir_type $impure_dir $test_file_st_ino
> > +[[ $? != 0 ]] || echo "Directory's readdir cache has stale entries"
> > +
> > +impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impure' \
> > +                       $upperdir/test_dir/impure_dir 2>/dev/null)
> > +[[ -z $impure ]] || echo "Pure directory has impure xattr"
> > +
> > +# Verify d_ino values corresponding to "." and ".." entries of a
> > +# pure lower dir.
> > +parent_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_dir)
> > +pure_lower_dir=$SCRATCH_MNT/test_dir/pure_lower_dir
> > +
> > +parent_d=$($here/src/t_dir_type $pure_lower_dir $parent_st_ino)
> > +[[ $parent_d == ".. d" ]] || echo "Pure lower dir: Invalid d_ino reported for .."
> > +
> > +pure_lower_dir_st_ino=$(stat -c '%i' $pure_lower_dir)
> > +
> > +current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
> > +[[ $current_d == ". d" ]] || echo "Pure lower dir: Invalid d_ino reported for ."
> > +
> > +# Verify d_ino of ".." entry of a merged dir.
> > +merged_dir=$SCRATCH_MNT/test_dir/merged_dir
> > +
> > +parent_d=$($here/src/t_dir_type $merged_dir $parent_st_ino)
> > +[[ $parent_d == ".. d" ]] || echo "Merged dir: Invalid d_ino reported for .."
> > +
> > +_overlay_scratch_unmount
> 
> _scratch_unmount
> 
> > +
> > +# Verify pure lower residing in dir which has another lower layer
> > +middir=$OVL_BASE_TEST_DIR/$seq-ovl-mid
> > +lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
> > +rm -rf $middir
> > +rm -rf $lowerdir
> > +mkdir $middir
> > +mkdir $lowerdir
> > +
> > +mkdir -p $middir/test_dir
> > +mkdir -p $lowerdir/test_dir/pure_lower_dir
> > +
> > +_scratch_mkfs
> > +
> > +upperdir=$OVL_BASE_SCRATCH_MNT/ovl-upper
> > +workdir=$OVL_BASE_SCRATCH_MNT/ovl-work
> > +
> > +_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir
> > +
> > +# Copy up test_dir
> > +touch $SCRATCH_MNT/test_dir/test_file
> > +
> > +test_dir_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_dir)
> > +
> > +parent_d=$($here/src/t_dir_type $SCRATCH_MNT/test_dir/pure_lower_dir $test_dir_st_ino)
> > +[[ $parent_d == ".. d" ]] || \
> > +       echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
> > +
> > +_overlay_scratch_unmount
> 
> _scratch_unmount (or nothing at all)
> 
> > +
> > +echo "Silence is golden"
> > +status=0
> > +exit
> > diff --git a/tests/overlay/041.out b/tests/overlay/041.out
> > new file mode 100644
> > index 0000000..04f5bf1
> > --- /dev/null
> > +++ b/tests/overlay/041.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 041
> > +Silence is golden
> > diff --git a/tests/overlay/group b/tests/overlay/group
> > index 022f2ef..89f6325 100644
> > --- a/tests/overlay/group
> > +++ b/tests/overlay/group
> > @@ -43,3 +43,4 @@
> >  038 auto quick copyup
> >  039 auto quick atime
> >  040 auto quick
> > +041 auto quick copyup
> 
> Please add to new group "nonsamefs".
> As I noted earlier, we should invest in enhancing this group.
> 

I will make the suggested changes and also add new tests to nonsamefs group
(starting with a variant of overlay/017)

-- 
chandan
