From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 3/3] generic/470: add syncfs test
Date: Tue, 12 Dec 2017 08:00:54 +0200
Message-ID: <CAOQ4uxhRymi9Ka6ZMQZy+mn4-mr-EOETgiKHOfytkgoJ4OHtag@mail.gmail.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com> <1513048179-151065-3-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:46111 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdLLGA4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 01:00:56 -0500
In-Reply-To: <1513048179-151065-3-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Dec 12, 2017 at 5:09 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes in
> underlying filesystem.
> Run syncfs and shutdown filesystem(or underlying filesystem of overlayfs)
> to check syncfs result.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
>
> Changes since v2:
> 1. Modify multiple test files to single small test file.
> 2. Use fssum to check result instead of diff.
> 3. Add comment for why running sync before test.
> 4. Add option explanation of fssum.
>
> Changes since v1:
> Use fs shutdown and fssum to check syncfs result instead of
> checking delalloc state of extents.
>
>  tests/generic/470     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/470.out |   2 +
>  tests/generic/group   |   1 +
>  3 files changed, 105 insertions(+)
>  create mode 100755 tests/generic/470
>  create mode 100644 tests/generic/470.out
>
> diff --git a/tests/generic/470 b/tests/generic/470
> new file mode 100755
> index 0000000..9d6c37a
> --- /dev/null
> +++ b/tests/generic/470
> @@ -0,0 +1,102 @@
> +#! /bin/bash
> +# FS QA Test 470
> +#
> +# Inspired by syncfs bug of overlayfs which does not sync dirty inodes in
> +# underlying filesystem.
> +#
> +# Create a small file then run syncfs and shutdown filesystem(or underlying
> +# filesystem of overlayfs) to check syncfs result.
> +#
> +# Test will be skipped if filesystem(or underlying filesystem of overlayfs)
> +# does not support shutdown.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>
> +# All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1
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
> +_supported_fs generic
> +_supported_os Linux
> +_require_fssum
> +_require_scratch
> +_require_scratch_shutdown
> +_require_xfs_io_command "syncfs"
> +
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +# Background writeback will flush dirty inode by dirty ratio and dirty time
> +# period(default 30 seconds), in order to avoid interference from it,
> +# run sync before test to make all dirty inodes clean, and it also
> +# accelerates syncfs on testing filesystem so that test case can finish
> +# in 30 seconds.
> +
> +sync
> +
> +$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/testfile >/dev/null 2>&1
> +
> +# fssum used for comparing checksum of test file(data & metedata).
> +# option explanation:
> +#    -f          : write out a full manifest file
> +#    -w <file>   : send output to file
> +#    -r <file>   : read checksum or manifest from file
> +#
> +#    -[ugoamcde] : specify which fields to include in checksum calculation.
> +#         u      : include uid
> +#         g      : include gid
> +#         o      : include mode
> +#         m      : include mtime
> +#         a      : include atime
> +#         c      : include ctime
> +#         d      : include file data
> +#         e      : include open errors (aborts otherwise)
> +#         s      : include block structure (holes)
> +#    -[UGOAMCDES]: exclude respective field from calculation
> +

That's too much. A comment about what attributes you are not comparing
would have been enough.

> +$FSSUM_PROG -ugomAcdES -f -w $tmp.fssum $SCRATCH_MNT

You can fssum $SCRATCH_MNT/testfile. you only have one file..


> +$XFS_IO_PROG -c "syncfs" $SCRATCH_MNT/testfile >/dev/null 2>&1
> +_scratch_shutdown
> +_scratch_cycle_mount
> +$FSSUM_PROG -r $tmp.fssum $SCRATCH_MNT >/dev/null 2>&1

$SCRATCH_MNT/testfile

Otherwise looks good.
Amir.
