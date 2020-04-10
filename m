Return-Path: <SRS0=xMZa=52=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B652C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 07:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E50B620753
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 07:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VG4bFYig"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgDJHWG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 03:22:06 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:42114 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgDJHWF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Apr 2020 03:22:05 -0400
Received: by mail-il1-f194.google.com with SMTP id f16so1072188ilj.9;
        Fri, 10 Apr 2020 00:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C/oMPzsCQWwgMfCTZmxGAT/S3EySbUtr9PeCOExfuuA=;
        b=VG4bFYigJng4xwD9hqGfRuKMBsEZfOd+Au47xy5xbYWcLA+/d1gkedupT6d6BcxnBZ
         nEYXcXZvcsAUAKm8CgMYZKYDDxZSJOBkWJe9OzWHKBiH/5LnA72aLBktFmCWMy5ILmFq
         q4bRMcvMPBRCFYM1MTLTB3SUTxk3CYB0HOwD7o+7k6HQ+FDb0kOP8105skNrPO7RuDMY
         gOpppKg5q485dbe+4uAClok+41b4FNPQn2wHNCXjbGP1adjNoGVLThy1g63jwTWKhplr
         SM37U6A4R+6ZFwBplGyRfUOlfrWfq/eojz5ANEuh++Ws9RL5klpe4LJIW4M4v8xFuHuX
         cvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C/oMPzsCQWwgMfCTZmxGAT/S3EySbUtr9PeCOExfuuA=;
        b=ZzC9qo0bA9cw7zzBFzX9gjSErovi1Yi9d9tft2DENxqJyG4AlZ12HrkVBEebFkq3rG
         mXBPO7eJhvx4OqWspEqbJZ/4cp4mzxFc9jRtZZ+j/f7YEKaQmWdozap0D0GneH192pZU
         zBdZzn7tKbzSlzMiLg+QA3wyEi59wVSr9n6Wc4ae/NgyrL8Y4JxWW0pWiYlVOwn3ooTO
         t1q8Rn7s/bqqhltw1OoDfD8WxD5pWT10LEZ47LQSrRUIuhHf9A05MDfSPaH0mpraIMk5
         nnyn4CkCgYfgTBbyu+g88zERO4c7aEv5RdJeIyKvSBmciVmf69tAicoquA1o3tvWmdOk
         Y+sw==
X-Gm-Message-State: AGi0PuY9HZHrsw8JN/DpOsKa9PdnANnr8aWRUUI0ZgQxs9YMKSL9KCSm
        T9SV/3Ka5Vhh/fxfuqWgH0Xw5txOYr9Un3ny8OpMShUl
X-Google-Smtp-Source: APiQypJ8fnG1pvyII5Yq+xR25fauTic9XLUD1XCtvnELPCRrGuCs6A6P2Vu+7Z+zsUCeZsiLM3sdSVbcT7CBIqpDaBk=
X-Received: by 2002:a05:6e02:68a:: with SMTP id o10mr4022246ils.72.1586503323234;
 Fri, 10 Apr 2020 00:22:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200410012059.27210-1-cgxu519@mykernel.net> <20200410012059.27210-2-cgxu519@mykernel.net>
In-Reply-To: <20200410012059.27210-2-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 10 Apr 2020 10:21:51 +0300
Message-ID: <CAOQ4uxghdvj9QVJ3DQ3g1p0hbvz5mfMoxgoEAKyQAf4v78p2YA@mail.gmail.com>
Subject: Re: [PATCH 2/2] overlay/072: test for sharing inode with whiteout files
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 10, 2020 at 4:21 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> This is a test for whiteout inode sharing feature.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
> Hi Eryu,
>
> Kernel patch of this feature is still in review but I hope to merge
> test case first, so that we can check the correctness in a convenient
> way. The test case will carefully check new module param and skip the
> test if the param does not exist.
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
> +status=1       # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
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
> +       local param_value=`_get_fs_module_param ${param_name}`

Keep this value and set it back on _cleanup()

> +       if [ -z ${param_value} ]; then
> +               _notrun "${FSTYP} module param ${param_name} does not exist"

This message will be more helpful:
"overlayfs does not support whiteout inode sharing"

> +       fi
> +}
> +
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +merged=$OVL_BASE_SCRATCH_MNT/$OVL_MNT

Best if you use $SCRATCH_MNT instead of $merged

> +
> +#Make some files in lowerdir.
> +make_lower_files()
> +{
> +       seq 1 $file_count | while read line; do

I think that a for statement would be more readable here.

> +               `touch $lowerdir/test${line} 1>&2 2>/dev/null`
> +       done
> +}
> +
> +#Delete all copy-uped files in upperdir.
> +make_whiteout_files()
> +{
> +       rm -f $merged/* 1>&2 2>/dev/null
> +}
> +
> +#Check link count of whiteout files.
> +check_whiteout_files()
> +{
> +       seq 1 $file_count | while read line; do
> +               local real_count=`stat -c %h $upperdir/test${line} 2>/dev/null`
> +               if [[ $link_count != $real_count ]]; then
> +                       echo "Expected whiteout link count is $link_count but real count is $real_count"
> +               fi
> +       done
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

Would be nicer to put all the below in a run_test_case() function
with above as arguments.

> +_scratch_mkfs
> +_set_fs_module_param $param_name $link_max
> +make_lower_files
> +_scratch_mount
> +make_whiteout_files
> +check_whiteout_files
> +$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT

Better:
$UMOUNT_PROG $SCRATCH_MNT

Even better:
_scratch_umount

The difference is that if the test case has reference leaks on inode or
dentry, _overlay_base_unmount() will detect them.

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

First, that is  strange outcome of whiteout_link_max=2
I would not expect it.
Second, how can every whiteout be shared with tmpfile?
There should be at most one tmpfile at all times, so the
whiteouts that already reached whiteout_link_max should
not be linked to any tmpfile.

Please add to test_case() verification that work dir contains
at most one tmpfile.
But please make sure that the test is clever enough to check
both work and index dirs for tmpfiles (names beginning with #).

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

Same here. nlink 10 is what I would expect, not 9.

Thanks,
Amir.
