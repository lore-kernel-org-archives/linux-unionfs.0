From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/2] overlay: Test consistent st_ino numbers for
 non-samefs scenario
Date: Mon, 13 Nov 2017 19:47:55 +0200
Message-ID: <CAOQ4uxj6kLdqdzukFU1JciwmpBmKS7j5pEnbFH2fjfMf7rfBcQ@mail.gmail.com>
References: <20171113144527.1034-1-chandan@linux.vnet.ibm.com> <20171113144527.1034-2-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:50231 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754172AbdKMRr5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Nov 2017 12:47:57 -0500
In-Reply-To: <20171113144527.1034-2-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Mon, Nov 13, 2017 at 4:45 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit adds a test to verify consistent st_ino feature when
> the overlayfs instance is composed of two different underlying
> filesystem instances.
>
> For example,
> $ mount -t xfs /dev/loop0 /mnt/test
> $ mount -t xfs /dev/loop1 /mnt/scratch
> $ mkdir /mnt/scratch/upper
> $ mkdir /mnt/scratch/work
> $ mount -t overlay overlay -o lowerdir=/mnt/test \
>         -o upperdir=/mnt/scratch/upper \
>         -o workdir=/mnt/scratch/work /mnt/merge
>
> The goal of this test is to verify that overlayfs returns consistent
> st_ino for the following scenarios,
> - Copy-up of lowerdir files
> - Rename files and drop dentry/inode cache
> - Remount the overlayfs instance
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
> Eryu,
> To pass, This test requires Amir's "Overlayfs: constant st_ino/d_ino for
> non-samefs" patchset. But this patch can be merged as it indicates an
> incorrect behaviour by overlayfs code as presently available on
> upstream kernel.
>
>  tests/overlay/043     | 197 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/043.out |   2 +
>  tests/overlay/group   |   1 +
>  3 files changed, 200 insertions(+)
>  create mode 100755 tests/overlay/043
>  create mode 100644 tests/overlay/043.out
>
> diff --git a/tests/overlay/043 b/tests/overlay/043
> new file mode 100755
> index 0000000..2b3c1c2
> --- /dev/null
> +++ b/tests/overlay/043
> @@ -0,0 +1,197 @@
> +#! /bin/bash
> +# FSQA Test No. 043
> +#
> +# Test constant inode numbers on non-samefs setup
> +# This is a variant of overlay/017 to test constant st_ino numbers for
> +# non-samefs setup.
> +#
> +# This simple test demonstrates a known issue with overlayfs:
> +# - stat file A shows inode number X
> +# - modify A to trigger copy up
> +# - stat file A shows inode number Y != X
> +#
> +# Test if inode numbers of all file types persist after copy-up. For
> +# non-dirs, test if inode numbers persist after rename, drop caches
> +# and mount cycle.
> +#
> +# With 'xino' mount option enabled, test if d_ino of readdir entries changes
> +# after copy up and if inode numbers persist after rename, drop caches and
> +# mount cycle.
> +#

There are 2 ways we can do this IMO:
1. require that xino mount option is supported and force enable xino on
    _overlay_scratch_mount_dirs
2. Let the test check what it is meant to test regardless of mount options
    provided by user, so test will fail (as in real setups) with no
xino mount option

I am leaning towards options #1, which is what overlay/018 does for index=on,
but it is worth noting that overlay/017, the origin of this test, does
not require nor
enable index=on and in fact fails without index=on mount/config option.

It is also worth mentioning that for fs with 32bit inode numbers, the test is
expected to pass even without the xino mount option.

For now I chose option #2 for my enhanced overlay/041 test.
Please see commit "overlay/041: adapt test to 'xino' mount option" on
my overlayfs-devel branch for the details.


> +#-----------------------------------------------------------------------
> +#
> +# Copyright (C) 2017 IBM Corporation. All Rights Reserved.
> +# Author: Chandan Rajendra <chandan@linux.vnet.ibm.com>
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
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch
_require_test
> +_require_test_program "af_unix"
> +_require_test_program "t_dir_type"
> +
> +rm -f $seqres.full
> +
> +lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
> +rm -rf $lowerdir
> +mkdir $lowerdir
> +
> +# Create our test files.
> +mkdir $lowerdir/dir
> +touch $lowerdir/file
> +ln -s $lowerdir/file $lowerdir/symlink
> +mknod $lowerdir/chrdev c 1 1
> +mknod $lowerdir/blkdev b 1 1
> +mknod $lowerdir/fifo p
> +$here/src/af_unix $lowerdir/socket
> +touch $lowerdir/hardlink1
> +ln $lowerdir/hardlink1 $lowerdir/hardlink2
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> +
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir

Here we must either add -o xino or add $OVERLAY_MOUNT_OPTIONS,
because _overlay_scratch_mount_dirs won't carry those options by itself.

> +
> +FILES="dir file symlink chrdev blkdev fifo socket hardlink1 hardlink2"
> +
> +# Record inode numbers in format <ino> <basename>
> +function record_inode_numbers()
> +{
> +       local dir=$1
> +       local outfile=$2
> +
> +       for f in $FILES; do
> +               ls -id $dir/$f
> +       done | \
> +       while read ino file; do
> +               echo $ino `basename $file` `stat -c '%F' $file` >> $outfile
> +       done
> +}
> +
> +# Check inode numbers match recorder inode numbers
> +function check_inode_numbers()
> +{
> +       local dir=$1
> +       local before=$2
> +       local after=$3
> +       local xino=$4
> +       local ignore_dir=$5
> +
> +       record_inode_numbers $dir $after
> +
> +       if [[ $ignore_dir && $xino == 0 ]]; then

What's all this about?
Test should not change depending on xino.
Test is should check correctness/consistency of inode numbers.
Either we not_run the test if xino is not supported of we let it fail,
like overlay/017 fails when index=off.

> +               cat $before | $AWK_PROG '
> +               /directory/ {
> +                           sub(/^[[:digit:]]+/, "XXXX", $0)
> +                           print
> +                           next
> +               }
> +               {
> +                       print
> +                       next
> +               }' > $tmp.mod_before
> +               cat $after | $AWK_PROG '
> +               /directory/ {
> +                           sub(/^[[:digit:]]+/, "XXXX", $0)
> +                           print
> +                           next
> +               }
> +               {
> +                       print
> +                       next
> +               }' > $tmp.mod_after
> +
> +               before=$tmp.mod_before
> +               after=$tmp.mod_after
> +       fi
> +
> +       # Test constant stat(2) st_ino -
> +       # Compare before..after - expect silence
> +       # We use diff -u so out.bad will tell us which stage failed
> +       diff -u $before $after
> +
> +       [[ $xino == 0  ]] && return

No discounts please ;)
Fs is wrong, so fs shoulud fail the test.

> +
> +       # Test constant readdir(3)/getdents(2) d_ino -
> +       # Expect to find file by inode number
> +       cat $before | while read ino f ftype; do
> +               $here/src/t_dir_type $dir $ino | grep -q $f || \
> +                       echo "$f not found by ino $ino (from $before)"
> +       done
> +}
> +
> +rm -f $tmp.*
> +testdir=$SCRATCH_MNT/test
> +mkdir -p $testdir
> +
> +xino=0
> +echo $MOUNT_OPTIONS | grep -q xino
> +[[ $? == 0 ]] && xino=1
> +
> +# Record inode numbers before copy up
> +record_inode_numbers $SCRATCH_MNT $tmp.before
> +
> +for f in $FILES; do
> +       # chown -h modifies all those file types
> +       chown -h 100 $SCRATCH_MNT/$f
> +done
> +
> +# Compare inode numbers before/after copy up
> +check_inode_numbers $SCRATCH_MNT $tmp.before $tmp.after_copyup $xino 0
> +
> +for f in $FILES; do
> +       # move to another dir
> +       mv $SCRATCH_MNT/$f $testdir/
> +done
> +
> +echo 3 > /proc/sys/vm/drop_caches
> +
> +# Compare inode numbers before/after rename and drop caches
> +check_inode_numbers $testdir $tmp.after_copyup $tmp.after_move $xino 1
> +
> +# Verify that the inode numbers survive a mount cycle
> +$UMOUNT_PROG $SCRATCH_MNT
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
> +
> +# Compare inode numbers before/after mount cycle
> +check_inode_numbers $testdir $tmp.after_move $tmp.after_cycle $xino 1
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/overlay/043.out b/tests/overlay/043.out
> new file mode 100644
> index 0000000..f90f0a5
> --- /dev/null
> +++ b/tests/overlay/043.out
> @@ -0,0 +1,2 @@
> +QA output created by 043
> +Silence is golden
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 782c39f..a99ff07 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -45,3 +45,4 @@
>  040 auto quick
>  041 auto quick copyup nonsamefs
>  042 auto quick copyup hardlink
> +043 auto quick copyup nonsamefs
> --
> 2.9.5
>
