Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191022122621.27374-1-cgxu519@mykernel.net>
In-Reply-To: <20191022122621.27374-1-cgxu519@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 22 Oct 2019 16:31:32 +0300
Message-ID: <CAOQ4uxiXwJp4dh_yENsxskbSvuGew2ZqRFyKccdFUMLGWUaz3Q@mail.gmail.com>
Subject: Re: [PATCH] overlay/066: copy-up test for variant sparse files
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Oct 22, 2019 at 3:26 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> This is intensive copy-up test for sparse files,
> these cases are mainly used for regression test
> of copy-up improvement for sparse files.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  tests/overlay/066     | 108 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/066.out |   2 +
>  tests/overlay/group   |   1 +
>  3 files changed, 111 insertions(+)
>  create mode 100755 tests/overlay/066
>  create mode 100644 tests/overlay/066.out
>
> diff --git a/tests/overlay/066 b/tests/overlay/066
> new file mode 100755
> index 00000000..0394b14e
> --- /dev/null
> +++ b/tests/overlay/066
> @@ -0,0 +1,108 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Chengguang Xu <cgxu519@mykernel.net>. All Rights Reserved.
> +#
> +# FS QA Test 066
> +#
> +# Test overlayfs copy-up function for variant sparse files.
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
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_test
> +_require_scratch
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +_require_fs_space $OVL_BASE_SCRATCH_MNT $((10*1024*13 + 100*1024))

Please add a comment about how the above is calculated.
Should it depend on fs reported iosize or blocksize?

> +
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +testfile="copyup_sparse_test"
> +mkdir -p $lowerdir
> +
> +# Create a completely empty hole file.
> +$XFS_IO_PROG -fc "truncate 10M" "${lowerdir}/${testfile}_empty_holefile" >>$seqres.full
> +
> +iosize=`stat -c %o "${lowerdir}/${testfile}_empty_holefile"`

I am not sure why fs reported iosize is interesting for this test case.
If anything you need _get_file_block_size

> +if [ $iosize -le 1024 ]; then
> +       ioszie=1

typo: ioszie

> +else
> +       iosize=`expr $iosize / 1024`
> +fi
> +
> +# Create test files with different hole size patterns.
> +while [ $iosize -le 2048 ]; do
> +       pos=$iosize
> +       $XFS_IO_PROG -fc "truncate 10M" "${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
> +       while [ $pos -lt 8192 ]; do
> +               $XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" "${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
> +               pos=`expr $pos + $iosize + $iosize`
> +       done
> +       iosize=`expr $iosize + $iosize`
> +done
> +
> +# Create test file with many random holes(1M~2M).
> +$XFS_IO_PROG -fc "truncate 100M" "${lowerdir}/${testfile}_random_holefile" >>$seqres.full
> +pos=2048
> +while [ $pos -le 81920 ]; do
> +       iosize=`expr $RANDOM % 2048`
> +       if [ $iosize -lt 1024 ]; then
> +               iosize=`expr $iosize + 1024`
> +       fi

IOW: iosize=`expr $RANDOM % 1024 + 1024`

> +       $XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" "${lowerdir}/${testfile}_random_holefile" >>$seqres.full
> +       pos=`expr $pos + $iosize + $iosize`
> +done
> +
> +_scratch_mount
> +
> +# Open the files should succeed, no errors are expected.
> +for f in $SCRATCH_MNT/*; do
> +       $XFS_IO_PROG -c "open" $f >>$seqres.full
> +done
> +
> +echo "Silence is golden"
> +
> +# Check all copy-up files in upper layer.
> +iosize=`stat -c %o "${lowerdir}/${testfile}_empty_holefile"`
> +if [ $iosize -le 1024 ]; then
> +       ioszie=1

typo: ioszie

> +else
> +       iosize=`expr $iosize / 1024`
> +fi
> +
> +while [ $iosize -le 2048 ]; do
> +       diff "${lowerdir}/${testfile}_iosize${iosize}K_holefile" "${upperdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
> +       iosize=`expr $iosize + $iosize`
> +done
> +
> +diff "${lowerdir}/${testfile}_empty_holefile"  "${upperdir}/${testfile}_empty_holefile"  >>$seqres.full
> +diff "${lowerdir}/${testfile}_random_holefile" "${upperdir}/${testfile}_random_holefile" >>$seqres.full

This expression does not fail the test if file differ?
Did you mean:

diff "${lowerdir}/${testfile}_empty_holefile"
"${upperdir}/${testfile}_empty_holefile"  >>$seqres.full || \
    echo ${testfile}_empty_holefile" copy up failed

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/066.out b/tests/overlay/066.out
> new file mode 100644
> index 00000000..b60cc24c
> --- /dev/null
> +++ b/tests/overlay/066.out
> @@ -0,0 +1,2 @@
> +QA output created by 066
> +Silence is golden
> diff --git a/tests/overlay/group b/tests/overlay/group
> index ef8517a1..1dec7db9 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -68,3 +68,4 @@
>  063 auto quick whiteout
>  064 auto quick copyup
>  065 auto quick mount
> +066 auto quick copyup

I'm curious, how long does the test run with and without copy up hole
optimization patch?

Thanks,
Amir.
