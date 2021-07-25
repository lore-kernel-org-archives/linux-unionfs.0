Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79587C4338F
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Jul 2021 16:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A30F60F39
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Jul 2021 16:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhGYPrM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Jul 2021 11:47:12 -0400
Received: from out20-111.mail.aliyun.com ([115.124.20.111]:35707 "EHLO
        out20-111.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGYPrM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jul 2021 11:47:12 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07439385|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.378771-0.00242189-0.618807;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047190;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.KqkZOmF_1627230459;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KqkZOmF_1627230459)
          by smtp.aliyun-inc.com(10.147.40.7);
          Mon, 26 Jul 2021 00:27:39 +0800
Date:   Mon, 26 Jul 2021 00:27:39 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] overlay: add test for copy up of lower file attributes
Message-ID: <YP2Q+xTjGICXfOwl@desktop>
References: <20210722164634.394499-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722164634.394499-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 22, 2021 at 07:46:34PM +0300, Amir Goldstein wrote:
> Overlayfs copies up a subset of lower file attributes since kernel
> commits:
> 173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
> 2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")
> 
> This test verifies this functionality works correctly and that it
> survives power failure and/or mount cycle.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks good to me overall, just one minor question below.

> ---
> 
> Eryu,
> 
> This test is failing on master and passes on overlayfs-next.
> 
> Thanks,
> Amir.
> 
>  tests/overlay/078     | 145 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/078.out |   2 +
>  2 files changed, 147 insertions(+)
>  create mode 100755 tests/overlay/078
>  create mode 100644 tests/overlay/078.out
> 
> diff --git a/tests/overlay/078 b/tests/overlay/078
> new file mode 100755
> index 00000000..b43449d1
> --- /dev/null
> +++ b/tests/overlay/078
> @@ -0,0 +1,145 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Huawei.  All Rights Reserved.
> +# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
> +#
> +# FS QA Test 078
> +#
> +# Test copy up of lower file attributes.
> +#
> +# Overlayfs copies up a subset of lower file attributes since kernel commits:
> +# 173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
> +# 2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")
> +#
> +# This test is similar and was derived from generic/507, but instead
> +# of creating new files which are created in upper layer, prepare
> +# the file with attributes in lower layer and verify that attributes
> +# are not lost during copy up, (optional) shutdown and mount cycle.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick perms shutdown

I noticed that generic/507 has the same groups defined, but I'm
wondering if 'perms' is right group, 'attr' seems a better fit to me.
And we could add 'copyup' group as well.

> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	$CHATTR_PROG -ai $lowertestfile &> /dev/null
> +	rm -f $tmp.*
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic

s/generic/overlay/

Thanks,
Eryu

> +
> +_require_command "$LSATTR_PROG" lasttr
> +_require_command "$CHATTR_PROG" chattr
> +_require_chattr ASai
> +_require_xfs_io_command "syncfs"
> +
> +_require_scratch
> +_require_scratch_shutdown
> +
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> +lowertestfile=$lowerdir/testfile
> +testfile=$SCRATCH_MNT/testfile
> +
> +_scratch_mkfs
> +mkdir -p $lowerdir
> +touch $lowertestfile
> +_scratch_mount
> +
> +# Set another flag on lowertestfile and verify all flags
> +# are kept though copy up (optional shutdown) and mount cycle
> +do_check()
> +{
> +	attr=$1
> +
> +	echo "Test chattr +$1 $2" >> $seqres.full
> +
> +	$UMOUNT_PROG $SCRATCH_MNT
> +
> +	# Add attribute to lower file
> +	$CHATTR_PROG +$attr $lowertestfile
> +
> +	# Re-create upperdir/workdir
> +	rm -rf $upperdir $workdir
> +	mkdir -p $upperdir $workdir
> +
> +	if [ "$2" == "shutdown" ]; then
> +		$XFS_IO_PROG -r $lowertestfile -c "fsync" | _filter_xfs_io
> +	fi
> +
> +	_scratch_mount
> +
> +	before=`$LSATTR_PROG $testfile`
> +
> +	# Write file in append mode to test copy up of append-only attribute
> +	# Expect failure on write to immutable file
> +	expect=0
> +	if [ "$1" == "i" ]; then
> +		expect=1
> +	fi
> +	$XFS_IO_PROG -a -c "pwrite -S 0x61 0 10" $testfile >> $seqres.full 2>&1
> +	result=$?
> +	if [ $result != $expect ]; then
> +		echo "Write unexpectedly returned $result for file with attribute '$attr'"
> +	fi
> +
> +	if [ "$2" == "shutdown" ]; then
> +		$XFS_IO_PROG -r $testfile -c "fsync" | _filter_xfs_io
> +		_scratch_shutdown | tee -a $seqres.full
> +	fi
> +
> +	_scratch_cycle_mount
> +
> +	after=`$LSATTR_PROG $testfile`
> +	echo "Before copy up: $before" >> $seqres.full
> +	echo "After  copy up: $after" >> $seqres.full
> +
> +	# Verify attributes were not lost during copy up, shutdown and mount cycle
> +	if [ "$before" != "$after" ]; then
> +		echo "Before copy up: $before"
> +		echo "After  copy up: $after"
> +	fi
> +
> +	echo "Test chattr -$1 $2" >> $seqres.full
> +
> +	# Delete attribute from overlay file
> +	$CHATTR_PROG -$attr $testfile
> +
> +	before=`$LSATTR_PROG $testfile`
> +
> +	if [ "$2" == "shutdown" ]; then
> +		$XFS_IO_PROG -r $testfile -c "fsync" | _filter_xfs_io
> +		_scratch_shutdown | tee -a $seqres.full
> +	fi
> +
> +	_scratch_cycle_mount
> +
> +	after=`$LSATTR_PROG $testfile`
> +	echo "Before mount cycle: $before" >> $seqres.full
> +	echo "After  mount cycle: $after" >> $seqres.full
> +
> +	# Verify attribute deletion was not lost during shutdown or mount cycle
> +	if [ "$before" != "$after" ]; then
> +		echo "Before mount cycle: $before"
> +		echo "After  mount cycle: $after"
> +	fi
> +}
> +
> +echo "Silence is golden"
> +
> +# This is the subset of attributes copied up by overlayfs since kernel
> +# commit ...
> +opts="A S a i"
> +for i in $opts; do
> +	do_check $i
> +	do_check $i shutdown
> +done
> +
> +status=0
> +exit
> diff --git a/tests/overlay/078.out b/tests/overlay/078.out
> new file mode 100644
> index 00000000..b8acea8c
> --- /dev/null
> +++ b/tests/overlay/078.out
> @@ -0,0 +1,2 @@
> +QA output created by 078
> +Silence is golden
> -- 
> 2.32.0
> 
