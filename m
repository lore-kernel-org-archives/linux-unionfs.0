Return-Path: <SRS0=BYJY=6D=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E77EC38A30
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 16:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A4621974
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Apr 2020 15:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgDSP76 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 11:59:58 -0400
Received: from out20-74.mail.aliyun.com ([115.124.20.74]:36578 "EHLO
        out20-74.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgDSP76 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Apr 2020 11:59:58 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07437351|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0323515-0.00129263-0.966356;FP=0|0|0|0|0|-1|-1|-1;HT=e01a16378;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.HJstBlT_1587311990;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HJstBlT_1587311990)
          by smtp.aliyun-inc.com(10.147.40.26);
          Sun, 19 Apr 2020 23:59:50 +0800
Date:   Mon, 20 Apr 2020 00:00:57 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        amir73il@gmail.com
Subject: Re: [PATCH v3] overlay/072: test for whiteout inode sharing
Message-ID: <20200419160057.GH388005@desktop>
References: <20200414093401.9792-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414093401.9792-1-cgxu519@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 14, 2020 at 05:34:01PM +0800, Chengguang Xu wrote:
> This is a test for whiteout inode sharing feature.
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Looks fine to me overall, but still, I'd like to see the kernel patch
lands first.

And some minor comments inline.

It'd be great if you could provide more info about the new feature, so
people understand the feature and could review the tests with such info
in mind, "whiteout inode sharing feature" doesn't explain what it is
very well.

> ---
> v1->v2:
> - Address Amir's comments in v1
> 
> v2->v3:
> - Address Amir's comments in v2
> 
>  common/module         |   9 +++
>  tests/overlay/072     | 149 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/072.out |   2 +
>  tests/overlay/group   |   1 +
>  4 files changed, 161 insertions(+)
>  create mode 100755 tests/overlay/072
>  create mode 100644 tests/overlay/072.out
> 
> diff --git a/common/module b/common/module
> index 39e4e793..148e8c8f 100644
> --- a/common/module
> +++ b/common/module
> @@ -81,3 +81,12 @@ _get_fs_module_param()
>  {
>  	cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
>  }
> + # Set the value of a filesystem module parameter
> + # at /sys/module/$FSTYP/parameters/$PARAM
> + #
> + # Usage example:
> + #   _set_fs_module_param param value
> + _set_fs_module_param()
> +{
> +	echo ${2} > /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
> +}
> diff --git a/tests/overlay/072 b/tests/overlay/072
> new file mode 100755
> index 00000000..81e39a79
> --- /dev/null
> +++ b/tests/overlay/072
> @@ -0,0 +1,149 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
> +# All Rights Reserved.
> +#
> +# FS QA Test 072
> +#
> +# This is a test for whiteout inode sharing feature.
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
> +	if [[ -n "${orig_param_value}" ]]; then
> +		_set_fs_module_param $param_name $orig_param_value
> +	fi
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
> +param_name="whiteout_link_max"
> +
> +# Check overlayfs module param(whiteout_link_max)
> +check_whiteout_link_max()
> +{
> +	orig_param_value=`_get_fs_module_param ${param_name}`
> +	if [ -z ${orig_param_value} ]; then
> +		_notrun "${FSTYP} does not support whiteout inode sharing"
> +	fi
> +}
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
> +	for name in `seq ${1}`
> +	do

Perfer the following style for "for loop":

	for name in `seq ${`}`; do
		...
	done

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
> +	for name in `seq ${1}`
> +	do

Same here.

Thanks,
Eryu

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
> +# $1: Maximum link count
> +# $2: Testing file number
> +# $3: Expected link count
> +run_test_case()
> +{
> +	_scratch_mkfs
> +	_set_fs_module_param $param_name ${1}
> +	make_lower_files ${2}
> +	_scratch_mount
> +	make_whiteout_files
> +	check_whiteout_files ${2} ${3}
> +	_scratch_unmount
> +}
> +
> +check_whiteout_link_max
> +
> +# Case1:
> +# Setting whiteout_link_max=0 means whiteout files will not
> +# share inode, each whiteout file will have it's own inode.
> +
> +link_max=0
> +file_count=10
> +link_count=1
> +run_test_case $link_max $file_count $link_count
> +
> +# Case2:
> +# Setting whiteout_link_max=1 means whiteout files will not
> +# share inode, each whiteout file will have it's own inode.
> +
> +link_max=1
> +file_count=10
> +link_count=1
> +run_test_case $link_max $file_count $link_count
> +
> +# Case3:
> +# Setting whiteout_link_max>1 means whiteout files will share
> +# inode and link count could up to whiteout_link_max.
> +
> +link_max=2
> +file_count=10
> +link_count=2
> +run_test_case $link_max $file_count $link_count
> +
> +# Case4:
> +# Setting whiteout_link_max>1 means whiteout files will share
> +# inode and link count could up to whiteout_link_max.
> +
> +link_max=10
> +file_count=20
> +link_count=10
> +run_test_case $link_max $file_count $link_count
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
