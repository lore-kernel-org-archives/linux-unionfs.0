Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191105053510.13849-1-cgxu519@mykernel.net>
In-Reply-To: <20191105053510.13849-1-cgxu519@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 5 Nov 2019 09:29:46 +0200
Message-ID: <CAOQ4uxg9BpH+V50novSRz6vqEP08USFgdgYagQyyK7v6q_kzDg@mail.gmail.com>
Subject: Re: [PATCH v2] overlay/066: adjust test file size && add more test patterns
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Nov 5, 2019 at 7:35 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Making many small holes in 10M test file seems not very
> helpful for test coverage and it takes too much time on
> creating test files. In order to improve test speed we
> adjust test file size to (10 * iosize) for iosize aligned
> hole files and meanwhile add more test patterns for small
> random holes and small empty file.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
> v1->v2:
> - Check result in one diff command.
> - Print more information(file layout) to full log when test failed.
> - Truncate test file name.
>
>  tests/overlay/066 | 97 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 69 insertions(+), 28 deletions(-)
>
> diff --git a/tests/overlay/066 b/tests/overlay/066
> index 285a5aff..c353bdc7 100755
> --- a/tests/overlay/066
> +++ b/tests/overlay/066
> @@ -40,48 +40,85 @@ _require_scratch
>  # Remove all files from previous tests
>  _scratch_mkfs
>
> -# We have totally 14 test files in this test.
> +# We have totally 16 test files in this test.
>  # The detail as below:
> -# 1 empty file(10M) + 2^0(K)..2^11(K) hole size files(each 10M) + 1 random hole size file(100M).
> +# 1 small empty file 4K
> +# 1 big empty file 4M
> +# 1 small random hole file 10M
> +# 1 big random hole file 100M
> +#
> +# 12 files with variant iosize aligned holes.
> +# 2^0(K)..2^11(K) hole size files(file size = 10 * iosize)
>  #
>  # Considering both upper and lower fs will fill zero when copy-up
>  # hole area in the file, this test at least requires double disk
>  # space of the sum of above test files' size.
>
> -_require_fs_space $OVL_BASE_SCRATCH_MNT $(((10*1024*13 + 100*1024*1) * 2))
> +_require_fs_space $OVL_BASE_SCRATCH_MNT $((((4) + (4096) + (10 * 1024) \
> +                + (100 * 1024) + (10 * (1 + 2048) * 12 / 2)) * 2))
>
>  lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
>  upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
>  testfile="copyup_sparse_test"
>
> -# Create a completely empty hole file(10M).
> -file_size=10240
> -$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_empty_holefile" \
> +# Create a small completely empty hole file(4K).
> +file_size=4
> +$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_empty_small" \
>                  >>$seqres.full
>
> -# Create 2^0(K)..2^11(K) hole size test files(each 10M).
> +# Create a big completely empty hole file(4M).
> +file_size=4096
> +$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_empty_big" \
> +                >>$seqres.full
> +
> +# Create 2^0(K)..2^11(K) hole size test files(file size = 10 * iosize).
>  #
>  # The pattern is like below, both hole and data are equal to
>  # iosize except last hole.
>  #
>  # |-- hole --|-- data --| ... |-- data --|-- hole --|
>
> -iosize=1
> +min_iosize=1
>  max_iosize=2048
> -file_size=10240
> -max_pos=`expr $file_size - $max_iosize`
> +iosize=$min_iosize
>
>  while [ $iosize -le $max_iosize ]; do
> +       file_size=$(($iosize * 10))
> +       max_pos=$(($file_size - $iosize))
>         pos=$iosize
>         $XFS_IO_PROG -fc "truncate ${file_size}K" \
> -               "${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
> +               "${lowerdir}/${testfile}_iosize${iosize}K" >>$seqres.full
> +       echo -e "\niosize=${iosize}K hole test write scenarios ---\n" >>$seqres.full
>         while [ $pos -lt $max_pos ]; do
>                 $XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
> -               "${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
> -               pos=`expr $pos + $iosize + $iosize`
> +               "${lowerdir}/${testfile}_iosize${iosize}K" >>$seqres.full
> +               pos=$(($pos + $iosize * 2))
>         done
> -       iosize=`expr $iosize + $iosize`
> +       iosize=$(($iosize * 2))
>  done
> +echo >>$seqres.full
> +
> +# Create test file with many random small holes(hole size is between 4K and 512K),
> +# total file size is 10M.
> +
> +pos=4
> +max_pos=9216

2 above are commutable values, please do not set them manually
pos=$min_hole
max_pos=$(($file_size - 2*$max_hole))

Right?

Please use calculation also for random big file.

> +file_size=10240
> +min_hole=4
> +max_hole=512
> +
> +$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_random_small" \
> +               >>$seqres.full
> +
> +echo -e "\nSmall random hole test write scenarios ---\n" >>$seqres.full
> +while [ $pos -le $max_pos ]; do
> +       iosize=$(($RANDOM % ($max_hole - $min_hole) + $min_hole))
> +       $XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
> +               "${lowerdir}/${testfile}_random_small" >>$seqres.full

I still prefer that you use a helper
do_io "pwrite ${pos}K ${iosize}K" "${lowerdir}/${testfile}_random_small"

which also records the xfs_io command in full log.

> +       pos=$(($pos + $iosize * 2))
> +done
> +echo >>$seqres.full
> +
>
>  # Create test file with many random holes(hole size is between 1M and 5M),
>  # total file size is 100M.
> @@ -92,19 +129,22 @@ file_size=102400
>  min_hole=1024
>  max_hole=5120
>
> -$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_random_holefile" \
> +$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_random_big" \
>                 >>$seqres.full
>
> +echo -e "\nBig random hole test write scenarios ---\n" >>$seqres.full
>  while [ $pos -le $max_pos ]; do
>         iosize=$(($RANDOM % ($max_hole - $min_hole) + $min_hole))
>         $XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
> -               "${lowerdir}/${testfile}_random_holefile" >>$seqres.full
> -       pos=`expr $pos + $iosize + $iosize`
> +               "${lowerdir}/${testfile}_random_big" >>$seqres.full
> +       pos=$(($pos + $iosize * 2))
>  done
> +echo >>$seqres.full
>
>  _scratch_mount
>
>  # Open the test files, no errors are expected.
> +echo -e "\nDoing copy-up...\n" >>$seqres.full
>  for f in $SCRATCH_MNT/*; do
>         $XFS_IO_PROG -c "open" $f >>$seqres.full
>  done
> @@ -112,18 +152,19 @@ done
>  echo "Silence is golden"
>
>  # Check all copy-up files in upper layer.
> -iosize=1
> -while [ $iosize -le 2048 ]; do
> -       diff "${lowerdir}/${testfile}_iosize${iosize}K_holefile" \
> -               "${upperdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full ||\
> -               echo "${upperdir}/${testfile}_iosize${iosize}K_holefile" copy up failed!
> -       iosize=`expr $iosize + $iosize`
> -done
>
> -diff "${lowerdir}/${testfile}_empty_holefile"  "${upperdir}/${testfile}_empty_holefile"  \
> -       >>$seqres.full || echo "${upperdir}/${testfile}_empty_holefile" copy up failed!
> -diff "${lowerdir}/${testfile}_random_holefile" "${upperdir}/${testfile}_random_holefile" \
> -       >>$seqres.full || echo "${upperdir}/${testfile}_random_holefile" copy up failed!
> +diff -qr ${upperdir} ${lowerdir} >>$seqres.full

The output of diff is exactly the interesting output to golden output that
will fail the test if it is not empty.
If you want it also in full log please use | tee -a $seqres.full

Thanks,
Amir.
