From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstest PATCH V2 2/2] overlay/031: add tests of whiteouts in
 lowerdir and both dirs
Date: Mon, 3 Jul 2017 09:41:22 +0300
Message-ID: <CAOQ4uxgDXdL+RPpH_gTzk6n9ZjqYn25wdVBoHLWEDj1KJ9-trw@mail.gmail.com>
References: <1498792811-17311-1-git-send-email-yi.zhang@huawei.com>
 <1498792811-17311-3-git-send-email-yi.zhang@huawei.com> <CAOQ4uxgnY5tk1Bt7p=MC0GCFgXcSngXuCPQYCkFSovEDCmn5yg@mail.gmail.com>
 <f398ce46-3a40-b0cc-6520-5d1f0ecb3a03@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35607 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbdGCGlX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 3 Jul 2017 02:41:23 -0400
In-Reply-To: <f398ce46-3a40-b0cc-6520-5d1f0ecb3a03@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Mon, Jul 3, 2017 at 4:42 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/6/30 22:28, Amir Goldstein wrote:
>> On Fri, Jun 30, 2017 at 6:20 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>> In overlay/031, it only cover the test case of whiteouts in
>>> origined upper dir. This patch add two cases cover the other
>>> two situations:
>>>
>>> 1) Lower origined dir have whiteouts;
>>> 2) Both upper and lower origined dirs have whiteouts (although
>>> this case is pass now, still add this to cover all three kinds
>>> of situations).
>>>
>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>>
>> Except one issue below.
>>
>>> ---
>>>  tests/overlay/031 | 58 ++++++++++++++++++++++++++++++++++++++++++++-----------
>>>  1 file changed, 47 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/tests/overlay/031 b/tests/overlay/031
>>> index cb29ee5..b7bad3a 100755
>>> --- a/tests/overlay/031
>>> +++ b/tests/overlay/031
>>> @@ -1,9 +1,10 @@
>>>  #! /bin/bash
>>>  # FS QA Test 031
>>>  #
>>> -# The unmerged and impure upper directories may contain invalid
>>> -# whiteouts when we change lowerdir(e.g. clean up dir) and remount
>>> -# overlay. This may lead to whiteouts exposure and rmdir failure.
>>> +# The unmerged and origined directories may contain invalid
>>> +# whiteouts when we change underlaying dir (e.g. clean up lowerdir)
>>> +# and remount overlay. This may lead to whiteouts exposure and
>>> +# rmdir failure.
>>>  #
>>>  #-----------------------------------------------------------------------
>>>  # Copyright (c) 2017 Huawei.  All Rights Reserved.
>>> @@ -67,19 +68,21 @@ _require_scratch
>>>  _scratch_mkfs
>>>
>>>  # create test directorys and whiteout
>>> -lowerdir=$OVL_BASE_SCRATCH_MNT/lower
>>> +lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
>>> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
>>>  upperdir=$OVL_BASE_SCRATCH_MNT/upper
>>>  workdir=$OVL_BASE_SCRATCH_MNT/workdir
>>> -testfile=a
>>> -mkdir -p $lowerdir $upperdir $workdir
>>> +testfile1=a
>>> +testfile2=b
>>> +mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
>>>
>>> -_create_whiteout $lowerdir $upperdir $workdir $testfile
>>> +_create_whiteout $lowerdir1 $upperdir $workdir $testfile1
>>>
>>>  # clean up the lower directory and mount overlay again,
>>>  # whiteout will expose.
>>> -rm -rf $lowerdir/testdir
>>> +rm -rf $lowerdir1/testdir
>>>
>>> -_overlay_mount_dirs $lowerdir $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>>> +_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>>>
>>>  ls $SCRATCH_MNT/testdir
>>>
>>> @@ -90,15 +93,48 @@ rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
>>>  # umount overlay again, create a new file with the same name and
>>>  # mount overlay again.
>>>  $UMOUNT_PROG $SCRATCH_MNT
>>> -touch $lowerdir/testdir
>>> +touch $lowerdir1/testdir
>>>
>>> -_overlay_mount_dirs $lowerdir $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>>> +_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>>>
>>>  # try to remove test dir from overlay dir, trigger ovl_remove_and_whiteout,
>>>  # it will not clean up the dir and lead to residue.
>>>  rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
>>>  ls $workdir/work
>>>
>>> +$UMOUNT_PROG $SCRATCH_MNT
>>> +
>>> +# let lower dir have invalid whiteouts, repeat ls and rmdir test again.
>>> +rm -rf $lowerdir1/testdir
>>> +rm -rf $upperdir/testdir
>>> +
>>> +_create_whiteout $lowerdir2 $lowerdir1 $workdir $testfile1
>>> +
>>> +rm -rf $lowerdir2/testdir
>>> +
>>> +_overlay_mount_dirs "$lowerdir1:$lowerdir2" $upperdir $workdir \
>>> +                    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>>> +
>>> +ls $SCRATCH_MNT/testdir
>>> +rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
>>> +
>>> +$UMOUNT_PROG $SCRATCH_MNT
>>> +
>>> +# let lower dir and upper dir both have invalid whiteouts, repeat ls and rmdir again.
>>> +rm -rf $lowerdir1/testdir
>>> +rm -rf $upperdir/testdir
>>> +
>>> +_create_whiteout $lowerdir1 $upperdir $workdir $testfile1
>>> +
>>> +rm -rf $lowerdir1/testdir
>>> +
>>> +_create_whiteout $lowerdir2 $lowerdir1 $workdir $testfile2
>>> +
>>> +_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>>> +
>>
>> Forgot to rm -rf $lowerdir2/testdir ?
>>
>
> Lowerdir2 is no longer used for the final test, so I think there is no difference
> whether we removed lowerdir2/testdir or not.(I miss something?)
>

Right. I tested with my overlayfs-devel branch and found a different issue
with the 'whiteouts in both upper and lower' test case.
When you run the test you see the warning:
overlayfs: failed to verify origin (lower1/testdir, ino=16777474, err=-116)

This warning is generated by commit ("ovl: verify origin of merge dir lower")
and means that the test does not follow the lower dir at all.

The solution is simple:

rm -f $lowerdir1/testdir/$testfile1 instead of rm -rf $lowerdir1/testdir
to keep the original lower testdir dir intact, instead of recreating the
dir with the second _create_whiteout call.

Cheers,
Amir.
