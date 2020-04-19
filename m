Return-Path: <SRS0=BYJY=6D=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57CEC38A30
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 15:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BABCD214D8
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 15:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgDSPAo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 11:00:44 -0400
Received: from out20-61.mail.aliyun.com ([115.124.20.61]:60339 "EHLO
        out20-61.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgDSPAo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Apr 2020 11:00:44 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07440823|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0124179-0.000947159-0.986635;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03267;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.HJrAIfw_1587308439;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HJrAIfw_1587308439)
          by smtp.aliyun-inc.com(10.147.41.121);
          Sun, 19 Apr 2020 23:00:39 +0800
Date:   Sun, 19 Apr 2020 23:01:47 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] overlay: another test for dropping nlink below zero
Message-ID: <20200419150147.GF388005@desktop>
References: <20200409112223.14496-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409112223.14496-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 09, 2020 at 02:22:23PM +0300, Amir Goldstein wrote:
> This is a variant on test overlay/034.
> 
> This variant is mangling upper hardlinks instead of lower hardlinks
> and does not require the inodes index feature.
> 
> This is a regression test for kernel commit 83552eacdfc0
> ("ovl: fix WARN_ON nlink drop to zero")
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Eryu,
> 
> The kernel fix commit just got merged.
> 
> Thanks,
> Amir.
> 
>  tests/overlay/072     | 85 +++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/072.out |  2 +
>  tests/overlay/group   |  1 +
>  3 files changed, 88 insertions(+)
>  create mode 100755 tests/overlay/072
>  create mode 100644 tests/overlay/072.out
> 
> diff --git a/tests/overlay/072 b/tests/overlay/072
> new file mode 100755
> index 00000000..e9084e5c
> --- /dev/null
> +++ b/tests/overlay/072
> @@ -0,0 +1,85 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
> +#
> +# FS QA Test 072
> +#
> +# Test overlay nlink when adding upper hardlinks.
> +#
> +# nlink of overlay inode could be dropped indefinitely by adding
> +# unaccounted upper hardlinks underneath a mounted overlay and
> +# trying to remove them.
> +#
> +# This is a variant of test overlay/034 with mangling of upper instead
> +# of lower hardlinks. Unlike overlay/034, this test does not require the
> +# inode index feature and will pass whether is it enabled or disabled
> +# by default.
> +#
> +# This is a regression test for kernel commit 83552eacdfc0
> +# ("ovl: fix WARN_ON nlink drop to zero").
> +# Without the fix, the test triggers
> +# WARN_ON(inode->i_nlink == 0) in drop_link().
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +tmp=/tmp/$$
> +status=1	# failure is the default!
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
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch
> +
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +# Create lower hardlink

It seems there're some stale comments that are copied from overlay/034,
above is one of them, should be "Create upper hardlink"

> +mkdir -p $upperdir
> +touch $upperdir/0
> +ln $upperdir/0 $upperdir/1
> +
> +_scratch_mount
> +
> +# Copy up lower hardlink - overlay inode nlink 2 is copied from lower
> +touch $SCRATCH_MNT/0

There's no copyup, then do we need this touch at all?

> +
> +# Add lower hardlinks while overlay is mounted - overlay inode nlink

Add upper hardlinks ...

> +# is not being updated
> +ln $upperdir/0 $upperdir/2
> +ln $upperdir/0 $upperdir/3
> +
> +# Unlink the 2 un-accounted lower hardlinks - overlay inode nlinks
                               ^^^^^ upper?

Thanks,
Eryu

> +# drops 2 and may reach 0 if the situation is not detected
> +rm $SCRATCH_MNT/2
> +rm $SCRATCH_MNT/3
> +
> +# Check if getting ENOENT when trying to link !I_LINKABLE with nlink 0
> +ln $SCRATCH_MNT/0 $SCRATCH_MNT/4
> +
> +# Unlink all hardlinks - if overlay inode nlink is 0, this will trigger
> +# WARN_ON() in drop_nlink()
> +rm $SCRATCH_MNT/0
> +rm $SCRATCH_MNT/1
> +rm $SCRATCH_MNT/4
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/overlay/072.out b/tests/overlay/072.out
> new file mode 100644
> index 00000000..590bbc6c
> --- /dev/null
> +++ b/tests/overlay/072.out
> @@ -0,0 +1,2 @@
> +QA output created by 072
> +Silence is golden
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 43ad8a52..82876d09 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -74,3 +74,4 @@
>  069 auto quick copyup hardlink exportfs nested nonsamefs
>  070 auto quick copyup redirect nested
>  071 auto quick copyup redirect nested nonsamefs
> +072 auto quick copyup hardlink
> -- 
> 2.17.1
> 
