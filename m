Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44791 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfEGPXs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 May 2019 11:23:48 -0400
MIME-Version: 1.0
References: <20190507112914.20856-1-jiufei.xue@linux.alibaba.com>
In-Reply-To: <20190507112914.20856-1-jiufei.xue@linux.alibaba.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 7 May 2019 18:23:36 +0300
Message-ID: <CAOQ4uxiQXcuDqQdVMXH6FQbDnHmd7QA-tsGsfiD5hFyOYx=YGQ@mail.gmail.com>
Subject: Re: [PATCH] generic: add a testcase to check the capability CAP_LINUX_IMMUTABLE
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, joseph.qi@linux.alibaba.com, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 7, 2019 at 2:29 PM Jiufei Xue <jiufei.xue@linux.alibaba.com> wrote:
>
> It should return error while changing IMMUTABLE_FL flag if the process
> has no capability CAP_LINUX_IMMUTABLE.
>
> However, it's not true on overlayfs after kernel version v4.19 since
> the process's subjective cred is overridden with ofs->creator_cred
> before calling real vfs_ioctl.
>
> The following patch for ovl fix the problem:
>   "ovl: check the capability before cred overridden"
>
> Add this testcase to cover this bug.
>
> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
> ---
>  common/config         |  1 +
>  tests/generic/545     | 61 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/545.out |  5 ++++
>  tests/generic/group   |  1 +
>  4 files changed, 68 insertions(+)
>  create mode 100755 tests/generic/545
>  create mode 100755 tests/generic/545.out
>
> diff --git a/common/config b/common/config
> index 64f87057..364432bb 100644
> --- a/common/config
> +++ b/common/config
> @@ -196,6 +196,7 @@ export SQLITE3_PROG="$(type -P sqlite3)"
>  export TIMEOUT_PROG="$(type -P timeout)"
>  export SETCAP_PROG="$(type -P setcap)"
>  export GETCAP_PROG="$(type -P getcap)"
> +export CAPSH_PROG="$(type -P capsh)"
>  export CHECKBASHISMS_PROG="$(type -P checkbashisms)"
>  export XFS_INFO_PROG="$(type -P xfs_info)"
>  export DUPEREMOVE_PROG="$(type -P duperemove)"
> diff --git a/tests/generic/545 b/tests/generic/545
> new file mode 100755
> index 00000000..89bdf885
> --- /dev/null
> +++ b/tests/generic/545
> @@ -0,0 +1,61 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.

Wrongly copied.

> +#
> +# FS QA Test No. 545
> +#
> +# Check that we can't add IMMUTABLE_FL flag to file when the process has
> +# no capbility CAP_LINUX_IMMUTABLE

Better check APPEND_FL while at it. Trivial to add.
Another think worth testing is chattr -i, so for example you could

touch foo bar
chattr +ia foo
capsh...
chattr +a bar # fail
chattr +i bar # fail
chattr -i foo # fail
chattr -a foo # fail

Order matters, because after Darrick's patches
chattr -/+a on immutable file should fail regardless of capabilities.

> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    $CHATTR_PROG -i $testdir/file 2>&1
> +    cd /
> +    rm -rf $tmp.* $testdir
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +
> +# real QA test starts here
> +_supported_os Linux
> +_require_chattr i
> +_require_command "$CAPSH_PROG" "capsh"
> +
> +rm -f $seqres.full
> +
> +echo "Format and mount"
> +testdir="$TEST_DIR/test-$seq"
> +rm -rf $testdir
> +mkdir $testdir
> +
> +echo "Create the original files"
> +blksz="$(_get_block_size $testdir)"
> +blks=1000
> +sz=$((blksz * blks))
> +_pwrite_byte 0x61 0 $sz $testdir/file >> $seqres.full
> +sync

touch $testdir/file is plenty enough

> +
> +do_filter_output()
> +{
> +    err_str=`_filter_test_dir | grep "Operation not permitted"`
> +    test -n "$err_str" && echo "Operation not permitted"
> +}
> +
> +echo "Try to add IMMUTABLE_FL flag"
> +$CAPSH_PROG --drop=cap_linux_immutable -- -c "$CHATTR_PROG +i $testdir/file" 2>&1 | do_filter_output
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/545.out b/tests/generic/545.out
> new file mode 100755
> index 00000000..740bb980
> --- /dev/null
> +++ b/tests/generic/545.out
> @@ -0,0 +1,5 @@
> +QA output created by 545
> +Format and mount
> +Create the original files
> +Try to add IMMUTABLE_FL flag
> +Operation not permitted
> diff --git a/tests/generic/group b/tests/generic/group
> index 40deb4d0..2f60b4af 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -547,3 +547,4 @@
>  542 auto quick clone
>  543 auto quick clone
>  544 auto quick clone
> +545 auto quick clone

Not 'clone'. Perhaps 'cap', although from the 5 tests that use setcap,
only one uses this tag.
You may send another patch to amend that if you want.

Thanks,
Amir.
