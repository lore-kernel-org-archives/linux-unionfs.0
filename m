Return-Path: <SRS0=O/kl=67=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498FFC433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 17 May 2020 14:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2173120801
	for <linux-unionfs@archiver.kernel.org>; Sun, 17 May 2020 14:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgEQO3h (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 17 May 2020 10:29:37 -0400
Received: from out20-50.mail.aliyun.com ([115.124.20.50]:50414 "EHLO
        out20-50.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgEQO3h (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 17 May 2020 10:29:37 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.0924481|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.174589-0.00132937-0.824082;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03299;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.HZr2UIA_1589725762;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HZr2UIA_1589725762)
          by smtp.aliyun-inc.com(10.147.41.178);
          Sun, 17 May 2020 22:29:22 +0800
Date:   Sun, 17 May 2020 22:29:22 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] generic/484: test data integrity for rdonly remount
Message-ID: <20200517142922.GA2704@desktop>
References: <20200422045210.11017-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422045210.11017-1-cgxu519@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 22, 2020 at 12:52:10PM +0800, Chengguang Xu wrote:
> This test checks data integrity when remounting from
> rw to ro mode.
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

The test itself looks fine. I'm just wondering that is there a real bug
which is exposed by this test? And what's the purpose of the shutdown?
More background info would be great if there's any.

> ---
>  tests/generic/484     | 54 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/484.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 57 insertions(+)
>  create mode 100755 tests/generic/484
>  create mode 100644 tests/generic/484.out
> 
> diff --git a/tests/generic/484 b/tests/generic/484
> new file mode 100755
> index 00000000..bc640214
> --- /dev/null
> +++ b/tests/generic/484
> @@ -0,0 +1,54 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
> +# All Rights Reserved.
> +#
> +# FS QA Test 484
> +#
> +# Test data integrity for ro remount.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=0
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_fssum
> +_require_scratch
> +_require_scratch_shutdown
> +
> +_scratch_mkfs &>/dev/null
> +_scratch_mount
> +
> +localdir=$SCRATCH_MNT/dir
> +mkdir $localdir
> +sync
> +
> +# fssum used for comparing checksum of test file(data & metedata),
> +# exclude checking about atime, block structure, open error.
> +$FSSUM_PROG -ugomAcdES -f -w $tmp.fssum $localdir
> +_scratch_remount ro
> +_scratch_shutdown
> +_scratch_cycle_mount
> +$FSSUM_PROG -r $tmp.fssum $localdir
> +
> +exit
> diff --git a/tests/generic/484.out b/tests/generic/484.out
> new file mode 100644
> index 00000000..e33c7815
> --- /dev/null
> +++ b/tests/generic/484.out
> @@ -0,0 +1,2 @@
> +QA output created by 484
> +OK
> diff --git a/tests/generic/group b/tests/generic/group
> index 718575ba..cc58ff0d 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -486,6 +486,7 @@
>  481 auto quick log metadata
>  482 auto metadata replay thin
>  483 auto quick log metadata
> +484 auto quick remount

Also in shutdown group.

Thanks,
Eryu

>  485 auto quick insert
>  486 auto quick attr
>  487 auto quick eio
> -- 
> 2.20.1
> 
