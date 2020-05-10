Return-Path: <SRS0=/s4Q=6Y=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1510FC38A2A
	for <linux-unionfs@archiver.kernel.org>; Sun, 10 May 2020 15:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3F820735
	for <linux-unionfs@archiver.kernel.org>; Sun, 10 May 2020 15:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgEJPuq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 10 May 2020 11:50:46 -0400
Received: from out20-110.mail.aliyun.com ([115.124.20.110]:55865 "EHLO
        out20-110.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgEJPuq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 10 May 2020 11:50:46 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07439546|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0153519-0.000446275-0.984202;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03293;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.HWNOXHt_1589125838;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HWNOXHt_1589125838)
          by smtp.aliyun-inc.com(10.147.42.135);
          Sun, 10 May 2020 23:50:38 +0800
Date:   Sun, 10 May 2020 23:50:37 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     miklos@szeredi.hu, amir73il@gmail.com, fstests@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v4] overlay: test for whiteout inode sharing
Message-ID: <20200510155037.GB9345@desktop>
References: <20200506101528.27359-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506101528.27359-1-cgxu519@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 06, 2020 at 06:15:28PM +0800, Chengguang Xu wrote:
> This is a test for whiteout inode sharing feature.
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
> v1->v2:
> - Address Amir's comments in v1
> 
> v2->v3:
> - Address Amir's comments in v2 
> 
> v3->v4:
> - Fix test case based on latest kernel patch(removed module param)
> https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git/commit/?h=overlayfs-next&id=4e49695244661568130bfefcb6143dd1eaa3d8e7
> 
>  tests/overlay/073     | 106 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/073.out |   2 +
>  tests/overlay/group   |   1 +
>  3 files changed, 109 insertions(+)
>  create mode 100755 tests/overlay/073
>  create mode 100644 tests/overlay/073.out
> 
> diff --git a/tests/overlay/073 b/tests/overlay/073
> new file mode 100755
> index 00000000..fc847092
> --- /dev/null
> +++ b/tests/overlay/073
> @@ -0,0 +1,106 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
> +# All Rights Reserved.
> +#
> +# FS QA Test 073
> +#
> +# Test whiteout inode sharing functionality.
> +#
> +# A "whiteout" is an object that has special meaning in overlayfs.
> +# A whiteout on an upper layer will effectively hide a matching file
> +# in the lower layer, making it appear as if the file didn't exist.
> +#
> +# Whiteout inode sharing means multiple whiteout objects will share
> +# one inode in upper layer, without this feature every whiteout object
> +# will consume one inode in upper layer.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
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

I see no feature detection logic, so test just fails on old kernels
without this feature? I tried with v5.7-r4 kernel, test fails because
each whiteout file has only one hardlink.

Thanks,
Eryu

> +
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> +
> +# Make some testing files in lowerdir.
> +# Argument:
> +# $1: Testing file number
> +make_lower_files()
> +{
> +	for name in `seq ${1}`; do
> +		touch $lowerdir/file${name} &>/dev/null
> +	done
> +}
> +
> +# Delete all copy-uped files in upperdir.
> +make_whiteout_files()
> +{
> +	rm -f $SCRATCH_MNT/* &>/dev/null
> +}
> +
> +# Check link count of whiteout files.
> +# Arguments:
> +# $1: Testing file number
> +# $2: Expected link count
> +check_whiteout_files()
> +{
> +	for name in `seq ${1}`; do
> +		local real_count=`stat -c %h $upperdir/file${name} 2>/dev/null`
> +		if [[ ${2} != $real_count ]]; then
> +			echo "Expected link count is ${2} but real count is $real_count, file name is file${name}"
> +		fi
> +	done
> +	local tmpfile_count=`ls $workdir/work/\#* $workdir/index/\#* 2>/dev/null |wc -l 2>/dev/null`
> +	if [[ -n "$tmpfile_count" && $tmpfile_count > 1 ]]; then
> +		echo "There are more than one whiteout tmpfile in work/index dir!"
> +		ls -l $workdir/work/\#* $workdir/index/\#* 2>/dev/null
> +	fi
> +}
> +
> +# Run test case with specific arguments.
> +# Arguments:
> +# $1: Testing file number
> +# $2: Expected link count
> +run_test_case()
> +{
> +	_scratch_mkfs
> +	make_lower_files ${1}
> +	_scratch_mount
> +	make_whiteout_files
> +	check_whiteout_files ${1} ${2}
> +	_scratch_unmount
> +}
> +
> +#Test case
> +file_count=10
> +link_count=11
> +run_test_case $file_count $link_count
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/overlay/073.out b/tests/overlay/073.out
> new file mode 100644
> index 00000000..590bbc6c
> --- /dev/null
> +++ b/tests/overlay/073.out
> @@ -0,0 +1,2 @@
> +QA output created by 073
> +Silence is golden
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 43ad8a52..8b2276f1 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -74,3 +74,4 @@
>  070 auto quick copyup redirect nested
>  071 auto quick copyup redirect nested nonsamefs
>  072 auto quick copyup hardlink
> +073 auto quick whiteout
> -- 
> 2.20.1
> 
