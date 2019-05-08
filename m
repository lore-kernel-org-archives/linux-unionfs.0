Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38759 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbfEHGYO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 May 2019 02:24:14 -0400
MIME-Version: 1.0
References: <20190508041119.25145-1-jiufei.xue@linux.alibaba.com>
In-Reply-To: <20190508041119.25145-1-jiufei.xue@linux.alibaba.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 8 May 2019 09:24:01 +0300
Message-ID: <CAOQ4uxj_nHixOyUiuOO-eM0_E0dAF8eetb80u4vpKju=DYSoRg@mail.gmail.com>
Subject: Re: [PATCH v2] generic: add a testcase to check the capability CAP_LINUX_IMMUTABLE
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: fstests <fstests@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, joseph.qi@linux.alibaba.com
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 8, 2019 at 7:11 AM Jiufei Xue <jiufei.xue@linux.alibaba.com> wrote:
>
> It should return error while changing IMMUTABLE_FL flag if the process
> has no capability CAP_LINUX_IMMUTABLE.

and APPEND_FL

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
> v2: add testcases to check APPEND_FL and clear these flags. Suggested by
> Amir Goldstein.

Patch revision info goes after --- line (edit after fomat-patch), so it
doesn't end up in commit message

>
> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
> ---
>  common/config         |  1 +
>  tests/generic/545     | 74 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/545.out | 10 ++++++
>  tests/generic/group   |  1 +
>  4 files changed, 86 insertions(+)
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
> index 00000000..a7c142e2
> --- /dev/null
> +++ b/tests/generic/545
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Alibaba Group.  All Rights Reserved.
> +#
> +# FS QA Test No. 545
> +#
> +# Check that we can't set the FS_APPEND_FL and FS_IMMUTABLE_FL inode
> +# flags without capbility CAP_LINUX_IMMUTABLE
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

You must have cleanup of flags on both file also here in case test is
aborted (i.e. CTRL-C), so we have no immutable/append-only files
left behind in test partition.

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
> +_require_chattr a
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
> +touch $testdir/file1
> +touch $testdir/file2
> +
> +do_filter_output()
> +{
> +    err_str=`_filter_test_dir | grep "Operation not permitted"`
> +    test -n "$err_str" && echo "Operation not permitted"
> +}
> +
> +echo "Try to chattr +ia with capabilities CAP_LINUX_IMMUTABLE"
> +$CHATTR_PROG +a $testdir/file1 2>&1
> +$CHATTR_PROG +i $testdir/file1 2>&1
> +
> +echo "Try to chattr +ia/-ia without capability CAP_LINUX_IMMUTABLE"
> +$CAPSH_PROG --drop=cap_linux_immutable -- -c "$CHATTR_PROG +a $testdir/file2" 2>&1 | do_filter_output
> +$CAPSH_PROG --drop=cap_linux_immutable -- -c "$CHATTR_PROG +i $testdir/file2" 2>&1 | do_filter_output
> +
> +$CAPSH_PROG --drop=cap_linux_immutable -- -c "$CHATTR_PROG -i $testdir/file1" 2>&1 | do_filter_output
> +$CAPSH_PROG --drop=cap_linux_immutable -- -c "$CHATTR_PROG -a $testdir/file1" 2>&1 | do_filter_output
> +
> +echo "Try to chattr -ia with capability CAP_LINUX_IMMUTABLE"
> +$CHATTR_PROG -i $testdir/file1 2>&1
> +$CHATTR_PROG -a $testdir/file1 2>&1
> +
> +# in case chattr +ia succeed without capability
> +$CHATTR_PROG -i $testdir/file2 2>&1
> +$CHATTR_PROG -a $testdir/file2 2>&1

Might as well leave this one only in cleanup() as it is not
part of the test and it needs to be in cleanup() anyway.

Thanks,
Amir.
