Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:33746 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726395AbeG3Jqr (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Jul 2018 05:46:47 -0400
Subject: Re: [xfstests PATCH 2/3] overlay: add fsck.overlay stress test
References: <20180728084242.33918-1-yi.zhang@huawei.com>
 <20180728084242.33918-3-yi.zhang@huawei.com>
 <CAOQ4uxgqPXZLWMT2gOd9vLDtqA3c6Ma5gfhrFkjONJ6HXHfHZQ@mail.gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <9191b011-b8ee-83f4-d967-180cb99bb351@huawei.com>
Date: Mon, 30 Jul 2018 16:12:47 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgqPXZLWMT2gOd9vLDtqA3c6Ma5gfhrFkjONJ6HXHfHZQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/7/30 14:24, Amir Goldstein Wrote:
> On Sat, Jul 28, 2018 at 11:42 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Introduce a test case for fsck.overlay which runs on the underlying
>> directories created by fsstress (contain a lot of fs objects) to
>> find potential stability issue.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  tests/overlay/061     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/overlay/061.out |  2 ++
>>  tests/overlay/group   |  1 +
>>  3 files changed, 84 insertions(+)
>>  create mode 100755 tests/overlay/061
>>  create mode 100644 tests/overlay/061.out
>>
>> diff --git a/tests/overlay/061 b/tests/overlay/061
>> new file mode 100755
>> index 0000000..b66b36a
>> --- /dev/null
>> +++ b/tests/overlay/061
>> @@ -0,0 +1,81 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2018 Huawei.  All Rights Reserved.
>> +#
>> +# FS QA Test No. 061
>> +#
>> +# Stress test: test fsck.overlay running on the underlying dirs
>> +# which were created by fsstress.
>> +#
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
>> +_require_scratch_nocheck
>> +_require_command "$FSCK_OVERLAY_PROG" fsck.overlay
>> +
>> +# remove all files from previous tests
>> +_scratch_mkfs
>> +
>> +# Create an underlying layer which contain a lot of random objects
>> +create_layer()
>> +{
>> +       for dir in $*; do
>> +               $FSSTRESS_PROG -s 42 -d $dir -z \
>> +                       -f creat=20 -f link=10 -f mkdir=20 -f mknod=10 \
>> +                       -f rename=10 -f setxattr=10 -f symlink=10 -f write=10 \
>> +                       -p 4 -n 500 -l50 > /dev/null 2>&1 &
>> +       done
>> +}
> 
> There is one main difference between this test and overlay/019 -
> this test is not sensitive to timing issues and therefore:
> 1. You gain nothing from running several fsstress processes in parallel

Sorry, I don't get it, running in parallel couldn't speed up fs objests creation ?

> 2. You loose something from using a constant ransom seed (-s 42)
> current code gives you all layers exactly the same and also
> the same for every invocation of test run, which is not what you want.
> I think what you want is to use a random seed and record that seed along
> with the output of fsstress in $seqres.full so that when test test does catch
> a problem with fsck with some random files, you will be able to reproduce
> the same layers from the full test output.

You are right, Thanks for point it out, I missed this totally, will fix.

Thanks,
Yi.

