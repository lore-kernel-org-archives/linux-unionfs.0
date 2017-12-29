From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH xfstest v2 2/4] overlay: add fsck.overlay whiteout test
Date: Fri, 29 Dec 2017 09:27:30 +0800
Message-ID: <cb266c08-9702-1a9f-e97c-848a2153e841@huawei.com>
References: <20171228114933.47759-1-yi.zhang@huawei.com>
 <20171228114933.47759-3-yi.zhang@huawei.com>
 <CAOQ4uxjOyDY7O9vX8zpv8=MzZ3LCNSLsthckz2FWSz-G_cdr0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3243 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753498AbdL2B2F (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Dec 2017 20:28:05 -0500
In-Reply-To: <CAOQ4uxjOyDY7O9vX8zpv8=MzZ3LCNSLsthckz2FWSz-G_cdr0g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On 2017/12/28 20:11, Amir Goldstein Wrote:
> On Thu, Dec 28, 2017 at 1:49 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Add fsck.overlay test case to test it how to deal with orphan/valid
>> whiteouts in underlying directories of overlayfs.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> 
> Very nice!
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> minor suggestions below
> 

Thanks a lot for your suggestions!

[..]
>> +# Create test directories
>> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
>> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
>> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
>> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
>> +
>> +mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir
> 
> Would be nice to pack these mkdir after rm -rf as make_dirs helper
> to run before every test case, instead of mkdir once and rm -rf after each test.
> 
It looks better, will change it for all 3 test cases.

[..]
>> +# Test orphan whiteout whose parent path is not an merged directory,
>> +# should remove
>> +echo "+ Orphan whiteout(3)"
>> +mkdir $lowerdir2/testdir1 $lowerdir2/testdir2 $lowerdir2/testdir3
>> +touch $lowerdir2/testdir1/foo $lowerdir2/testdir2/foo $lowerdir2/testdir3/foo
>> +mkdir $upperdir/testdir1 $upperdir/testdir2 $upperdir/testdir3
> 
> How about mkdir $upperdir/testdir4 (case of parent is a pure upper dir)
> 
Yes, it's perfect, will add.

Thanks,
Yi.
