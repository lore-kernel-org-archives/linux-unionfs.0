Return-Path: <SRS0=WHUq=54=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3576C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Sun, 12 Apr 2020 11:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A20BD20708
	for <linux-unionfs@archiver.kernel.org>; Sun, 12 Apr 2020 11:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDLL0j (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 12 Apr 2020 07:26:39 -0400
Received: from out20-86.mail.aliyun.com ([115.124.20.86]:58824 "EHLO
        out20-86.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgDLL0j (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 12 Apr 2020 07:26:39 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07439129|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0417568-0.00106229-0.957181;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03268;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.HFDfDdK_1586690796;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HFDfDdK_1586690796)
          by smtp.aliyun-inc.com(10.147.41.121);
          Sun, 12 Apr 2020 19:26:37 +0800
Date:   Sun, 12 Apr 2020 19:27:34 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        amir73il@gmail.com
Subject: Re: [PATCH 2/2] overlay/072: test for sharing inode with whiteout
 files
Message-ID: <20200412112734.GC3923113@desktop>
References: <20200410012059.27210-1-cgxu519@mykernel.net>
 <20200410012059.27210-2-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410012059.27210-2-cgxu519@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 10, 2020 at 09:20:59AM +0800, Chengguang Xu wrote:
> This is a test for whiteout inode sharing feature.
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
> Hi Eryu,
> 
> Kernel patch of this feature is still in review but I hope to merge

If this case tests a new & unmerged feature, I'd wait for the kernel
patch land in first, or at least the maintainer of the subsystem of the
kernel acks that the feature will be in kernel, just that the patch
itself needs some improvements at the moment.

As there were cases that I merged a case that aimed to test a new
feature or a new behavior, but the kernel patch was dropped eventually,
and the case became broken.

> test case first, so that we can check the correctness in a convenient
> way. The test case will carefully check new module param and skip the
> test if the param does not exist.

Or you could provide a personal repo that contains the case, so kernel
maintainers & reviewers could verify the feature with that repo?

Thanks,
Eryu

> 
> 
>  tests/overlay/072     | 148 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/072.out |   2 +
>  tests/overlay/group   |   1 +
>  3 files changed, 151 insertions(+)
>  create mode 100755 tests/overlay/072
>  create mode 100644 tests/overlay/072.out
> 
> diff --git a/tests/overlay/072 b/tests/overlay/072
> new file mode 100755
> index 00000000..1cff386d
> --- /dev/null
> +++ b/tests/overlay/072
> @@ -0,0 +1,148 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
> +# All Rights Reserved.
> +#
> +# FS QA Test 072
> +#
> +# This is a test for inode sharing with whiteout files.
> +#
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
> +_require_test
> +_require_scratch
> +
> +param_name="whiteout_link_max"
> +check_whiteout_link_max()
> +{
> +	local param_value=`_get_fs_module_param ${param_name}`
> +	if [ -z ${param_value} ]; then
> +		_notrun "${FSTYP} module param ${param_name} does not exist"
> +	fi
> +}
> +
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +merged=$OVL_BASE_SCRATCH_MNT/$OVL_MNT
> +
> +#Make some files in lowerdir.
> +make_lower_files()
> +{
> +	seq 1 $file_count | while read line; do
> +		`touch $lowerdir/test${line} 1>&2 2>/dev/null`
> +	done
> +}
> +
> +#Delete all copy-uped files in upperdir.
> +make_whiteout_files()
> +{
> +	rm -f $merged/* 1>&2 2>/dev/null
> +}
> +
> +#Check link count of whiteout files.
> +check_whiteout_files()
> +{
> +	seq 1 $file_count | while read line; do
> +		local real_count=`stat -c %h $upperdir/test${line} 2>/dev/null`
> +		if [[ $link_count != $real_count ]]; then
> +			echo "Expected whiteout link count is $link_count but real count is $real_count"
> +		fi
> +	done
> +}
> +
> +check_whiteout_link_max
> +
> +# Case1:
> +# Setting whiteout_link_max=0 will not share inode
> +# with whiteout files, it means each whiteout file
> +# will has it's own inode.
> +
> +file_count=10
> +link_max=0
> +link_count=1
> +_scratch_mkfs
> +_set_fs_module_param $param_name $link_max
> +make_lower_files
> +_scratch_mount
> +make_whiteout_files
> +check_whiteout_files
> +$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
> +
> +# Case2:
> +# Setting whiteout_link_max=1 will not share inode
> +# with whiteout files, it means each whiteout file
> +# will has it's own inode.
> +
> +file_count=10
> +link_max=1
> +link_count=1
> +_scratch_mkfs
> +_set_fs_module_param $param_name $link_max
> +make_lower_files
> +_scratch_mount
> +make_whiteout_files
> +check_whiteout_files $link_count
> +$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
> +
> +# Case3:
> +# Setting whiteout_link_max=2 will not share inode
> +# with whiteout files, it means each whiteout file
> +# will has it's own inode. However, the inode will
> +# be shared with tmpfile(in workdir) which is used
> +# for creating whiteout file.
> +
> +file_count=10
> +link_max=2
> +link_count=2
> +_scratch_mkfs
> +_set_fs_module_param $param_name $link_max
> +make_lower_files
> +_scratch_mount
> +make_whiteout_files
> +check_whiteout_files
> +$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
> +
> +# Case4:
> +# Setting whiteout_link_max=10 will share inode
> +# with 9 whiteout files and meanwhile the inode
> +# will also share with tmpfile(in workdir) which
> +# is used for creating whiteout file.
> +
> +file_count=18
> +link_max=10
> +link_count=10
> +_scratch_mkfs
> +_set_fs_module_param $param_name $link_max
> +make_lower_files
> +_scratch_mount
> +make_whiteout_files
> +check_whiteout_files
> +$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
> +
> +# success, all done
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
> index 43ad8a52..8b2276f1 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -74,3 +74,4 @@
>  069 auto quick copyup hardlink exportfs nested nonsamefs
>  070 auto quick copyup redirect nested
>  071 auto quick copyup redirect nested nonsamefs
> +072 auto quick whiteout
> -- 
> 2.20.1
> 
> 
