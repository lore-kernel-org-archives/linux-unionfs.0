From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH xfstests 2/2] overlay: test chattr lower file in overlay
Date: Fri, 15 Sep 2017 09:06:53 +0800
Message-ID: <c03c7d9b-51d0-0160-aa3d-ee060640e5f7@huawei.com>
References: <1505390643-6981-1-git-send-email-yi.zhang@huawei.com>
 <1505390643-6981-2-git-send-email-yi.zhang@huawei.com>
 <20170914133136.GL8034@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:6482 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbdIOBHn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Sep 2017 21:07:43 -0400
In-Reply-To: <20170914133136.GL8034@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com

On 2017/9/14 21:31, Eryu Guan Wrote:
> On Thu, Sep 14, 2017 at 08:04:03PM +0800, zhangyi (F) wrote:
>> chattr with [iap..] attributes open file for read-only and
>> invoke ioctl(). If we chattr a lower file in overlay, it
>> will get the lower file but not trigger copy-up, so ioctl()
>> lead to modification of that lower file incorrectly. Add this
>> test for this case.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  tests/overlay/040     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/overlay/040.out |  2 ++
>>  tests/overlay/group   |  1 +
>>  3 files changed, 92 insertions(+)
>>  create mode 100755 tests/overlay/040
>>  create mode 100644 tests/overlay/040.out
>>
>> diff --git a/tests/overlay/040 b/tests/overlay/040
>> new file mode 100755
>> index 0000000..4d0c7ef
>> --- /dev/null
>> +++ b/tests/overlay/040
>> @@ -0,0 +1,89 @@
>> +#! /bin/bash
>> +# FS QA Test 040
>> +#
>> +# chattr with [iap..] attributes open file for read-only and
>> +# invoke ioctl(). If we chattr a lower file in overlay, it
>> +# will get the lower file but not trigger copy-up, so ioctl()
>> +# lead to modification of that lower file.
>> +#
>> +# Upstream Commit 7c6893e3c9ab ("ovl: don't allow writing
>> +# ioctl on lower layer") return EPERM for this case to avoid
>> +# this issue.
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
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	$CHATTR_PROG -i $lowerdir/foo
>> +	rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +_supported_fs overlay
>> +_supported_os Linux
>> +_require_scratch
>> +_require_chattr i
>> +
>> +# remove all files from previous runs
>> +_scratch_mkfs
>> +
>> +# prepare lower test file
>> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
>> +mkdir -p $lowerdir
>> +touch $lowerdir/foo
>> +
>> +# mounting overlay
>> +_scratch_mount
>> +
>> +# Try to add immutable attributes in overlay, it will
>> +# open file for read-only and invoke ioctl(), it should not
>> +# modify lower origin file.
>> +$CHATTR_PROG +i $SCRATCH_MNT/foo > /dev/null 2>&1
>> +
>> +$UMOUNT_PROG $SCRATCH_MNT
>> +
>> +# touching origin file in lower, should succeed
>> +touch $lowerdir/foo > /dev/null 2>&1
>> +
>> +if [ $? -ne 0 ]; then
>> +        echo "Test Fail, immutable attributes is modified in lower."
>> +fi
> 
> No need to check return value of 'touch', a bare 'touch $lowerdir/foo'
> would work, if touch failed the error message would break the golden
> image. I can fix it at commit time. Thanks for the tests!

Yes, you are right, it's more simple, thanks!

Thanks,
Yi.
