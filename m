Return-Path: <SRS0=Z7uo=6U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3D8C28CBC
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6A92068E
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:20:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vH/sLugz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgEFKUF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 6 May 2020 06:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728306AbgEFKUE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 May 2020 06:20:04 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA43C061A0F;
        Wed,  6 May 2020 03:20:04 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z2so1519809iol.11;
        Wed, 06 May 2020 03:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y0LxyBq8J7mVn3oq8cVLqkxjqLn4jQd1Y+yAJRwuq6A=;
        b=vH/sLugzlUKbytCS7nqYVIFKQuxlsuEvhmu1XsgNBSJI5a63P/3jK0chDaBYDPeS+z
         I1LI9cSpJXFZTPpToBLApQpJ7R31KjFbZIfNUj97GTzUHG2N08Lp0iJ1vz1SZ20tyzZd
         zw86sohau9biNLRAhUBE3Qhf0o/y/y5zipj5HOEaVfBqXZXmFnvWzFL+EU73eWL4R8es
         cZJ51jEzkvG6LPXxPWZcOuqYSQ3/+L/S8iuTuDROTZDOhVpGPyPHNaVmCfbDRbKjlFBY
         qYXe6x5WG4q7uQD3EAJu2rFoJWnK3g5nY9Md18Ir6lO544h7lLCslfzPxnVZupQ7S2QO
         rDOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y0LxyBq8J7mVn3oq8cVLqkxjqLn4jQd1Y+yAJRwuq6A=;
        b=Q5oFe68Llkpva/ZMguKuYpM6m23xA6WOe4BN+82ni0eKbdYqwWQiMmXR15WNxlPZZj
         ke0SEoHt1GOPAE8CV4QIlLGLdV0ac7BcZNIi3Ob1hu0Z8dWfAWYYKgIKTrHmPAPcXM0s
         vNVsGJQ9BXxyu171rhqFkpI7xxCvshn2Cifa/YxcPmvtecCbGUJQ4v4zL99R6IijqHe/
         W59GF17tOlh/VDA9kytwQn+DlN2ZJVZWlImt6cqQWhtQYVnSsSPPc+GldPJvCRmqlA0u
         yxS0mI3OOUeAG84RBcUVhCvKYzvg8QObXbaHr0kETIvjXxTaELrzIjFp75XsDq43rwXR
         qqAw==
X-Gm-Message-State: AGi0PuZz2XCyrmaQg3oLQLKsx875Z3Np6PL6cNDjbrTz8pV+BFewJhv9
        a1E8bSZkixJeuV9TJhkgDXVkQqSpCfRGgA1bi7U=
X-Google-Smtp-Source: APiQypKGWtGsTgSiBTuj2qZQ7j8V9B/xzOY9kf1rDz3yuvkoArMvo1azzS1FW+PdQmPLdwZYJdBUg/a/0OQ6miXOQYY=
X-Received: by 2002:a6b:ef03:: with SMTP id k3mr7696542ioh.203.1588760402548;
 Wed, 06 May 2020 03:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200506101528.27359-1-cgxu519@mykernel.net>
In-Reply-To: <20200506101528.27359-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 6 May 2020 13:19:51 +0300
Message-ID: <CAOQ4uxh8T1P5Z7Q38vg7xUqwJ+YG2m6d44dWk_DJRyuo6E+djA@mail.gmail.com>
Subject: Re: [PATCH v4] overlay/072: test for whiteout inode sharing
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Eryu Guan <guan@eryu.me>, Miklos Szeredi <miklos@szeredi.hu>,
        fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 6, 2020 at 1:15 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> This is a test for whiteout inode sharing feature.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

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
>  tests/overlay/072     | 106 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/072.out |   2 +
>  tests/overlay/group   |   1 +
>  3 files changed, 109 insertions(+)
>  create mode 100755 tests/overlay/072
>  create mode 100644 tests/overlay/072.out
>
> diff --git a/tests/overlay/072 b/tests/overlay/072
> new file mode 100755
> index 00000000..fc847092
> --- /dev/null
> +++ b/tests/overlay/072
> @@ -0,0 +1,106 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
> +# All Rights Reserved.
> +#
> +# FS QA Test 072
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
> +_require_scratch
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
> +       for name in `seq ${1}`; do
> +               touch $lowerdir/file${name} &>/dev/null
> +       done
> +}
> +
> +# Delete all copy-uped files in upperdir.
> +make_whiteout_files()
> +{
> +       rm -f $SCRATCH_MNT/* &>/dev/null
> +}
> +
> +# Check link count of whiteout files.
> +# Arguments:
> +# $1: Testing file number
> +# $2: Expected link count
> +check_whiteout_files()
> +{
> +       for name in `seq ${1}`; do
> +               local real_count=`stat -c %h $upperdir/file${name} 2>/dev/null`
> +               if [[ ${2} != $real_count ]]; then
> +                       echo "Expected link count is ${2} but real count is $real_count, file name is file${name}"
> +               fi
> +       done
> +       local tmpfile_count=`ls $workdir/work/\#* $workdir/index/\#* 2>/dev/null |wc -l 2>/dev/null`
> +       if [[ -n "$tmpfile_count" && $tmpfile_count > 1 ]]; then
> +               echo "There are more than one whiteout tmpfile in work/index dir!"
> +               ls -l $workdir/work/\#* $workdir/index/\#* 2>/dev/null
> +       fi
> +}
> +
> +# Run test case with specific arguments.
> +# Arguments:
> +# $1: Testing file number
> +# $2: Expected link count
> +run_test_case()
> +{
> +       _scratch_mkfs
> +       make_lower_files ${1}
> +       _scratch_mount
> +       make_whiteout_files
> +       check_whiteout_files ${1} ${2}
> +       _scratch_unmount
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
