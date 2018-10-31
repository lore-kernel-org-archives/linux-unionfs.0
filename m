Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38143 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbeJaTP1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Oct 2018 15:15:27 -0400
MIME-Version: 1.0
References: <20181031095502.12504-1-mszeredi@redhat.com>
In-Reply-To: <20181031095502.12504-1-mszeredi@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Oct 2018 12:17:45 +0200
Message-ID: <CAOQ4uxi9YX23C7NLQ2yqsz1Ur4nwMZFbQta=nBU=6bvYPU2YGg@mail.gmail.com>
Subject: Re: [PATCH] overlay: create directory over deleted whiteout
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 11:55 AM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> There's a bug in the overlayfs implementation starting from the very first
> merged version that may cause an Oops of various forms if a directory is created
> over a whiteout dentry, but the actual whiteout on the upper layer was removed
> to the directory creation.
>
> Reported by: kaixuxia <xiakaixu1987@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---

Looks good. A bit of commentary could be useful...

>  tests/overlay/062     | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/062.out |  2 ++
>  tests/overlay/group   |  1 +
>  3 files changed, 63 insertions(+)
>  create mode 100644 tests/overlay/062
>  create mode 100644 tests/overlay/062.out
>
> diff --git a/tests/overlay/062 b/tests/overlay/062
> new file mode 100644
> index 000000000000..b2cc350afefb
> --- /dev/null
> +++ b/tests/overlay/062
> @@ -0,0 +1,60 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test 062
> +#
> +# Create dir over cached negative dentry, but whiteout removed from upper
> +#
> +# The following kernel commit fixed the kernel crash: ???
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
> +_require_scratch
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +# Create test file
> +lowerdir=${OVL_BASE_SCRATCH_MNT}/${OVL_LOWER}
> +upperdir=${OVL_BASE_SCRATCH_MNT}/${OVL_UPPER}
> +mkdir -p $lowerdir
> +touch ${lowerdir}/file
> +
> +_scratch_mount
> +

# Create whiteout and populate dcache with negative dentry

> +rm ${SCRATCH_MNT}/file
> +ls -l ${SCRATCH_MNT}/file > /dev/null 2>&1

# Remove whiteout and try to create dir over negative dentry

> +rm ${upperdir}/file
> +mkdir ${SCRATCH_MNT}/file > /dev/null 2>&1
> +
> +# unmount overlayfs
> +$UMOUNT_PROG $SCRATCH_MNT

Umount of scratch is not needed at the end of the test.

Thanks,
Amir.
