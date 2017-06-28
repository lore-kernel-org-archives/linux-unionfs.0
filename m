From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstest PATCH] overlay/031: add tests of whiteouts in lowerdir
 and both dirs
Date: Wed, 28 Jun 2017 13:49:36 +0300
Message-ID: <CAOQ4uxipk=T_+mCzpkDS8xGnhnYkO1jqbbG5Mho8bk4He2nL8w@mail.gmail.com>
References: <1498644722-43912-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34791 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdF1Kti (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Jun 2017 06:49:38 -0400
In-Reply-To: <1498644722-43912-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Wed, Jun 28, 2017 at 1:12 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> In overlay/031, it only cover the test case of whiteouts in
> origined upper dir. This patch add two cases cover the other
> two situations:
>
> 1) Lower origined dir have whiteouts;
> 2) Both upper and lower origined dirs have whiteouts (although
> this case is pass now, still add this to cover all three kinds
> of situations).
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Great work.
Some minor comments...

> ---
>  tests/overlay/031 | 83 +++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 63 insertions(+), 20 deletions(-)
>
> diff --git a/tests/overlay/031 b/tests/overlay/031
> index 674c11f..0835ddf 100755
> --- a/tests/overlay/031
> +++ b/tests/overlay/031
> @@ -1,9 +1,10 @@
>  #! /bin/bash
>  # FS QA Test 031
>  #
> -# The unmerged and impure upper directories may contain invalid
> -# whiteouts when we change lowerdir(e.g. clean up dir) and remount
> -# overlay. This may lead to whiteouts exposure and rmdir failure.
> +# The unmerged and origined directories may contain invalid
> +# whiteouts when we change underlaying dir(e.g. clean up lowerdir)
> +# and remount overlay. This may lead to whiteouts exposure and
> +# rmdir failure.
>  #
>  #-----------------------------------------------------------------------
>  # Copyright (c) 2017 Huawei.  All Rights Reserved.
> @@ -38,6 +39,20 @@ _cleanup()
>         rm -f $tmp.*
>  }
>
> +# create test directory and test file, mount overlayfs and remove
> +# testfile to create a whiteout.
> +_create_whiteout()
> +{
> +       mkdir -p $1/testdir
> +       touch $1/testdir/$4
> +
> +       _overlay_mount_dirs $1 $2 $3 $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
> +
> +       rm -f $SCRATCH_MNT/testdir/$4
> +
> +       $UMOUNT_PROG $SCRATCH_MNT
> +}
> +

Please introduce the helper in a separate patch.

>  # get standard environment, filters and checks
>  . ./common/rc
>  . ./common/filter
> @@ -52,26 +67,22 @@ _require_scratch
>  # remove all files from previous runs
>  _scratch_mkfs
>
> -# create test directory and test file
> -lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> -upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> -workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> -mkdir -p $lowerdir/testdir
> -touch $lowerdir/testdir/a
> -
> -# mount overlayfs and remove testfile to create a whiteout
> -_scratch_mount
> +# create test directorys and whiteout
> +lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
> +testfile1=a
> +testfile2=b
> +mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
>
> -rm -f $SCRATCH_MNT/testdir/a
> -
> -# unmount overlayfs but not base fs
> -$UMOUNT_PROG $SCRATCH_MNT
> +_create_whiteout $lowerdir1 $upperdir $workdir $testfile1
>
>  # clean up the lower directory and mount overlay again,
>  # whiteout will expose.
> -rm -rf $lowerdir/testdir
> +rm -rf $lowerdir1/testdir
>
> -_scratch_mount
> +_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>
>  ls $SCRATCH_MNT/testdir
>
> @@ -82,15 +93,47 @@ rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
>  # umount overlay again, create a new file with the same name and
>  # mount overlay again.
>  $UMOUNT_PROG $SCRATCH_MNT
> -touch $lowerdir/testdir
> +touch $lowerdir1/testdir
>
> -_scratch_mount
> +_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>
>  # try to remove test dir from overlay dir, trigger ovl_remove_and_whiteout,
>  # it will not clean up the dir and lead to residue.
>  rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
>  ls $workdir/work
>
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +# exchange lower dir and upper dir, repeat ls and rmidr test again,
> +# the lower dir will have invalid whiteout this time.

typo (rmidr)

> +rm -rf $lowerdir1/testdir
> +rm -rf $upperdir/testdir
> +
> +_create_whiteout $lowerdir1 $upperdir $workdir $testfile1
> +
> +rm -rf $lowerdir1/testdir
> +
> +_overlay_mount_dirs $upperdir $lowerdir1 $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT

May I suggest something different that the exchange trick
although exchange trick is perfectly fine too, but the proposed
alternative is a real world use case (rotating upper to lower stack).
Also, with the proposed mount, you also get coverage for whiteouts
in middle layer, which are not tested by the tests you proposed.

+_create_whiteout $lowerdir1 $lowerdir2 $workdir $testfile1
+ _overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
                    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT

> +
> +ls $SCRATCH_MNT/testdir
> +rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
> +
> +$UMOUNT_PROG $SCRATCH_MNT
> +
> +# let lower dir and upper dir both have invalid whiteouts, repeat ls and rmdir again.
> +rm -rf $lowerdir1/testdir
> +rm -rf $upperdir/testdir
> +
> +_create_whiteout $lowerdir1 $upperdir $workdir $testfile1

Please use:
+_create_whiteout $lowerdir2 $upperdir $workdir $testfile1

Because with inodes index feature same upper cannot be
mounted again with a different lower. the proposed
alternative is a real world use case (rotating upper to lower stack)


Thanks,
Amir.
