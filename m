Return-Path: <SRS0=8c8p=7H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCA4C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 May 2020 02:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7EE72075F
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 May 2020 02:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="AZlWIkUw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388684AbgEYCRf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 24 May 2020 22:17:35 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17148 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388308AbgEYCRf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 24 May 2020 22:17:35 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1590373039; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=bW0O/N0Rlum7EN6Pcfvfvw/Ntq3RSd6bOc1QJAC5JZb0Ngf1LN0K19JGZLEHH8Qrb/iJpKKmeVOsAjcFOgd045ICttcpKBuU5hbglejRwrq6R5YSr2mCAIBwOAP2ZXZCVIQ/minigpqw0et+3qN4zDfWvS/tlmqO1glQqdFvaos=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1590373039; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=e4hCrP9Qq/Fpb+5Fj4itrcGuD/o8Xgut2R9oLeeZYac=; 
        b=ADR4+DnoQo1mjBt0mpjPJxD1fCKq8A9/aT0IGvEXbXI5lQVVwnU3ol9G3xHlrsxz7DVys7q4UIKVaQdh/8aAG2Zw+nmlOTxqEUC7Ws+na6ASuZ8cfkY94NMYq5GdAYdy9ba56gZf5lAcIrQGk70cydtKXpUOojfnYN19/Abzn7U=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1590373039;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=e4hCrP9Qq/Fpb+5Fj4itrcGuD/o8Xgut2R9oLeeZYac=;
        b=AZlWIkUwdStxge2byHkl/jeblVtn6lhKXlkXgUcHm92IUA0dGaA6I+WUr0+rwC+z
        bBwszso3LQpNI2g8MkRUK1OKwXjguDdu2GTWP4Daa1h1qRvf5HF53xzfbMkh9C0Qhmm
        r2RMNLRXm4JE0XoQSPXwc2yWD1MhpjeDvlfVmVlg=
Received: from [192.168.166.138] (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 159037303616935.78440166541725; Mon, 25 May 2020 10:17:16 +0800 (CST)
Subject: Re: [PATCH v2] generic/597: test data integrity for rdonly remount
To:     fdmanana@gmail.com
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
References: <20200519080929.18030-1-cgxu519@mykernel.net>
 <CAL3q7H4aObeXLuhv05AOyrLU1B_3M81y_ddH1cY0pAEEEO+Law@mail.gmail.com>
From:   cgxu <cgxu519@mykernel.net>
Message-ID: <69537fa5-ebd7-c233-0741-5fc4f9798abd@mykernel.net>
Date:   Mon, 25 May 2020 10:17:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4aObeXLuhv05AOyrLU1B_3M81y_ddH1cY0pAEEEO+Law@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoCNMailClient: External
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 5/20/20 11:09 PM, Filipe Manana wrote:
> On Tue, May 19, 2020 at 9:10 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>>
>> This test checks data integrity when remounting from
>> rw to ro mode.
>>
>> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>> ---
>> v1->v2:
>> - Add to shutdown greoup.
>> - Change case number to 597
>>
>>   tests/generic/597     | 54 +++++++++++++++++++++++++++++++++++++++++++
>>   tests/generic/597.out |  2 ++
>>   tests/generic/group   |  1 +
>>   3 files changed, 57 insertions(+)
>>   create mode 100755 tests/generic/597
>>   create mode 100644 tests/generic/597.out
>>
>> diff --git a/tests/generic/597 b/tests/generic/597
>> new file mode 100755
>> index 00000000..d96e750b
>> --- /dev/null
>> +++ b/tests/generic/597
>> @@ -0,0 +1,54 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
>> +# All Rights Reserved.
>> +#
>> +# FS QA Test 597
>> +#
>> +# Test data integrity for ro remount.
>> +#
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=0
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
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +_supported_fs generic
>> +_supported_os Linux
>> +_require_fssum
>> +_require_scratch
>> +_require_scratch_shutdown
> 
> Couldn't the test be using dm's flakey instead of shutdown?
> As shutdown is not implemented by all filesystems (btrfs for example),
> it would allow more coverage.
> 

Thanks for the suggestion, I tried with dmflakey but unfortunately it 
could not work on overlayfs, a possible solution is that move current 
test case to overlay specific directory and create new test case with 
dmflakey for generic purpose.


Test results with dmflakey on xfs, btrfs and overlayfs.

[root@hades xfstests-dev]# ./check  generic/597
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hades 5.6.0-rc3+ #31 SMP Fri May 22 
11:27:07 CST 2020
MKFS_OPTIONS  -- -f -bsize=4096 /dev/nvme0n1p8
MOUNT_OPTIONS -- /dev/nvme0n1p8 /mnt/scratch

generic/597 1s ...  0s
Ran: generic/597
Passed all 1 tests


[root@hades xfstests-dev]# ./check generic/597
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 hades 5.6.0-rc3+ #31 SMP Fri May 22 
11:27:07 CST 2020
MKFS_OPTIONS  -- /dev/nvme0n1p8
MOUNT_OPTIONS -- /dev/nvme0n1p8 /mnt/scratch

generic/597 0s ...  0s
Ran: generic/597
Passed all 1 tests


[root@hades xfstests-dev]# ./check -overlay generic/597
FSTYP         -- overlay
PLATFORM      -- Linux/x86_64 hades 5.6.0-rc3+ #31 SMP Fri May 22 
11:27:07 CST 2020
MKFS_OPTIONS  -- /mnt/scratch
MOUNT_OPTIONS -- /mnt/scratch /mnt/scratch/ovl-mnt

generic/597 0s ... [not run] require /mnt/scratch to be valid block disk
Ran: generic/597
Not run: generic/597
Passed all 1 tests


Thanks,
cgxu











