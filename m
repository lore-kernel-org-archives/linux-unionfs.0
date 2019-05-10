Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38198 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfEJIcG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 May 2019 04:32:06 -0400
Date: Fri, 10 May 2019 16:31:55 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] generic: add a testcase to check the capability
 CAP_LINUX_IMMUTABLE
Message-ID: <20190510083155.GF15846@desktop>
References: <20190508071000.99448-1-jiufei.xue@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508071000.99448-1-jiufei.xue@linux.alibaba.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: fstests@vger.kernel.org, darrick.wong@oracle.com, linux-unionfs@vger.kernel.org, amir73il@gmail.com, joseph.qi@linux.alibaba.com
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 08, 2019 at 03:10:00PM +0800, Jiufei Xue wrote:
> It should return error while changing IMMUTABLE_FL and APPEND_FL if the
> process has no capability CAP_LINUX_IMMUTABLE.
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

Thanks for the patch! Some minor issues inline, and I can fix them up on
commit.

> ---
> v2: add testcases for APPEND_FL and flags clearing. Suggested by
>     Amir Goldstein.
> v3: clear the flags on both the file in cleanup() in case test is
>     aborted.
> 
>  common/config         |  1 +
>  tests/generic/545     | 73 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/545.out | 10 ++++++
>  tests/generic/group   |  1 +
>  4 files changed, 85 insertions(+)
>  create mode 100755 tests/generic/545
>  create mode 100755 tests/generic/545.out

mode of .out file should be 100644

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
> index 00000000..da2eac2e
> --- /dev/null
> +++ b/tests/generic/545
> @@ -0,0 +1,73 @@
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
> +    # Cleanup of flags on both file in case test is aborted
> +    # (i.e. CTRL-C), so we have no immutable/append-only files
> +    $CHATTR_PROG -ia $testdir/file1 2>&1
> +    $CHATTR_PROG -ia $testdir/file2 2>&1

       $CHATTR_PROG -ia $testdir/file2 >/dev/null 2>&1

And use 8 spaces tab for indention.

> +
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

_supported_fs generic

> +_require_chattr i
> +_require_chattr a
> +_require_command "$CAPSH_PROG" "capsh"

Need _require_test too.

> +
> +echo "Format and mount"

Not needed, you don't do format and mount anyway :)

> +testdir="$TEST_DIR/test-$seq"

I renamed it to workdir to avoid the confusion with TEST_DIR.

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

I think this is sufficient

	grep -o "Operation not permitted"

> +}
> +
> +echo "Try to chattr +ia with capabilities CAP_LINUX_IMMUTABLE"
> +$CHATTR_PROG +a $testdir/file1 2>&1
> +$CHATTR_PROG +i $testdir/file1 2>&1

No need to do the redirection, 'check' will capture both stdout and
stderr.

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

Same here, no redirection.

Thanks,
Eryu

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/545.out b/tests/generic/545.out
> new file mode 100755
> index 00000000..8c6e4082
> --- /dev/null
> +++ b/tests/generic/545.out
> @@ -0,0 +1,10 @@
> +QA output created by 545
> +Format and mount
> +Create the original files
> +Try to chattr +ia with capabilities CAP_LINUX_IMMUTABLE
> +Try to chattr +ia/-ia without capability CAP_LINUX_IMMUTABLE
> +Operation not permitted
> +Operation not permitted
> +Operation not permitted
> +Operation not permitted
> +Try to chattr -ia with capability CAP_LINUX_IMMUTABLE
> diff --git a/tests/generic/group b/tests/generic/group
> index 40deb4d0..7a457e81 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -547,3 +547,4 @@
>  542 auto quick clone
>  543 auto quick clone
>  544 auto quick clone
> +545 auto quick cap
> -- 
> 2.19.1.856.g8858448bb
> 
