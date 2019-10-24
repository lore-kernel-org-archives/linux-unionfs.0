Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191024055435.6059-1-cgxu519@mykernel.net>
In-Reply-To: <20191024055435.6059-1-cgxu519@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 24 Oct 2019 09:29:27 +0300
Message-ID: <CAOQ4uxixTyXxoTPsuz91+1rB+GupWR256QCAoi7sEbDiRxksyA@mail.gmail.com>
Subject: Re: [PATCH v2] overlay/066: copy-up test for variant sparse files
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 24, 2019 at 8:54 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> This is intensive copy-up test for sparse files,
> these cases will be mainly used for regression test
> of copy-up improvement for sparse files.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

You can add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

after fixing nits below...

> ---
> v1->v2:
> - Call _get_block_size to get fs block size.
> - Add comment for test space requirement.
> - Print meaningful error message when copy-up fail.
> - Adjust random hole range to 1M~5M.
> - Fix typo.
>
>  tests/overlay/066     | 120 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/066.out |   2 +
>  tests/overlay/group   |   1 +
>  3 files changed, 123 insertions(+)
>  create mode 100755 tests/overlay/066
>  create mode 100644 tests/overlay/066.out
>
> diff --git a/tests/overlay/066 b/tests/overlay/066
> new file mode 100755
> index 00000000..b01fc2a4
> --- /dev/null
> +++ b/tests/overlay/066
> @@ -0,0 +1,120 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Chengguang Xu <cgxu519@mykernel.net>
> +# All Rights Reserved.
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
> +# We have totally 14 test files in this test,
> +# one file for 100M and 13 files for 10M.

So we need double that amount of space if both upper and lower
do not support holes.

Also it is not obvious to the reader how the number 13 came to
be. It is better to explicitly say 1 empty file + 2^0 .. 2^11 hole size
file, so if ever the test pattern changes, it will be easier to adapt this
formula.

> +_require_fs_space $OVL_BASE_SCRATCH_MNT $((10*1024*13 + 100*1024*1))
> +
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +testfile="copyup_sparse_test"
> +mkdir -p $lowerdir
> +
> +# Create a completely empty hole file.
> +$XFS_IO_PROG -fc "truncate 10M" "${lowerdir}/${testfile}_empty_holefile" \
> +                >>$seqres.full
> +
> +iosize=$(_get_block_size "${lowerdir}")
> +if [ $iosize -le 1024 ]; then
> +       iosize=1
> +else
> +       iosize=`expr $iosize / 1024`
> +fi
> +
> +# Create test files with different hole size patterns.

Better be more verbose in the comment about the pattern of
the files, so reader won't need to follow code to understand.
Also better to have constants to make the algorithm clearer:

max_iosize=2048
file_size=10240
max_pos=`expr $file_size - $max_iosize`

> +while [ $iosize -le 2048 ]; do
> +       pos=$iosize
> +       $XFS_IO_PROG -fc "truncate 10M" \
> +               "${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
> +       while [ $pos -lt 8192 ]; do
> +               $XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
> +               "${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
> +               pos=`expr $pos + $iosize + $iosize`
> +       done
> +       iosize=`expr $iosize + $iosize`
> +done
> +
> +# Create test file with many random holes(1M~5M).
> +$XFS_IO_PROG -fc "truncate 100M" "${lowerdir}/${testfile}_random_holefile" \
> +               >>$seqres.full

Same comment about using constants instead of unexplained numbers,
including:
min_hole=1024
max_hole=5120

> +pos=2048
> +while [ $pos -le 81920 ]; do
> +       iosize=`expr $RANDOM % 5120`
> +       if [ $iosize -lt 1024 ]; then
> +               iosize=`expr $iosize + 1024`
> +       fi

So that is a weird way to express random 1MB~5MB
it results in 2 times higher probability for holes in the range
1MB~2MB and I don't think that was intentional. Better use:

   iosize=$(($RANDOM % ($max_hole - $min_hole) + $min_hole))

Thanks,
Amir.
