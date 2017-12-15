From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH for xfstests 2/4] overlay: add fsck.overlay whiteout test
Date: Fri, 15 Dec 2017 13:35:08 +0800
Message-ID: <380c648b-06b7-7afa-ef16-42e2d2d7ea7f@huawei.com>
References: <20171214064846.21587-1-yi.zhang@huawei.com>
 <20171214064846.21587-3-yi.zhang@huawei.com>
 <CAOQ4uxihAUTTP4nrtYxgNmqScmh80GTnDgJmmNFMsvj3Y4Y7ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:36618 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751475AbdLOFfi (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 00:35:38 -0500
In-Reply-To: <CAOQ4uxihAUTTP4nrtYxgNmqScmh80GTnDgJmmNFMsvj3Y4Y7ZA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On 2017/12/14 21:13, Amir Goldstein Wrote:
> On Thu, Dec 14, 2017 at 8:48 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Add fsck.overlay test case to test it how to deal with orphan/valid
>> whiteouts in underlying directories of overlayfs.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  tests/overlay/201     | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/overlay/201.out |  3 ++
>>  tests/overlay/group   |  1 +
>>  3 files changed, 102 insertions(+)
>>  create mode 100755 tests/overlay/201
>>  create mode 100644 tests/overlay/201.out
>>
[..]
>> +# Create test directories
>> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
>> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
>> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
>> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
>> +
>> +mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir
>> +
>> +# Test orphan whiteout in lower and upper layer, should remove
>> +echo "+ Orphan whiteout"
>> +mknod $lowerdir/foo c 0 0
>> +mknod $upperdir/foo c 0 0
>> +mknod $upperdir/bar c 0 0
>> +_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
> 
> Don'y you mean -p ?  ;-p
> 
Will change to use -p and elsewhere, it's easier to understand.

Thanks,
Yi.

>> +       _fail "fsck should not fail"
>> +ls $lowerdir
>> +ls $upperdir
>> +rm -rf $lowerdir/* $upperdir/*
>> +
>> +# Test valid whiteout covering lower target, should not remove
>> +echo "+ Valid whiteout"
>> +touch $lowerdir2/foo $lowerdir2/bar
>> +mknod $upperdir/foo c 0 0
>> +mknod $lowerdir/bar c 0 0
>> +_overlay_fsck_dirs -a "$lowerdir:$lowerdir2" $upperdir $workdir >> \
>> +        $seqres.full 2>&1 || _fail "fsck should not fail"
>> +check_whiteout $upperdir/foo
>> +check_whiteout $lowerdir/bar
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/overlay/201.out b/tests/overlay/201.out
>> new file mode 100644
>> index 0000000..20338db
>> --- /dev/null
>> +++ b/tests/overlay/201.out
>> @@ -0,0 +1,3 @@
>> +QA output created by 201
>> ++ Orphan whiteout
>> ++ Valid whiteout
>> diff --git a/tests/overlay/group b/tests/overlay/group
>> index 7e541e4..7c5fcbb 100644
>> --- a/tests/overlay/group
>> +++ b/tests/overlay/group
>> @@ -49,3 +49,4 @@
>>  044 auto quick copyup hardlink nonsamefs
>>  047 auto quick copyup hardlink
>>  048 auto quick copyup hardlink
>> +201 auto quick fsck
>> --
> 
> 
> Looks good
> 
> Amir.
> 
> .
> 
