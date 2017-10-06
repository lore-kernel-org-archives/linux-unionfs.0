From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] constant d_ino test for non-samefs setup
Date: Fri, 6 Oct 2017 14:51:28 +0300
Message-ID: <CAOQ4uxgCZUYMW0qgeSgKV7TRnTDtw=cC999RcyPTT7BcB8C+Wg@mail.gmail.com>
References: <20171006092946.15718-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35474 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbdJFLv3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 07:51:29 -0400
In-Reply-To: <20171006092946.15718-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Fri, Oct 6, 2017 at 12:29 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  tests/overlay/041     | 210 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/041.out |   2 +
>  tests/overlay/group   |   1 +
>  3 files changed, 213 insertions(+)
>  create mode 100755 tests/overlay/041
>  create mode 100644 tests/overlay/041.out
>
> diff --git a/tests/overlay/041 b/tests/overlay/041
> new file mode 100755
> index 0000000..b992346
> --- /dev/null
> +++ b/tests/overlay/041
> @@ -0,0 +1,210 @@
> +#! /bin/bash
> +# FSQA Test No. 041
> +#
> +# Test constant d_ino numbers on non-samefs setup

Chandan,

Some of my comments may also apply to the origin 038 test,
which I missed in review, starting with the description of the test -
"Test constant d_ino numbers" is not really what this test does,
what it really does is "Test consistent d_ino/st_ino numbers"

Also, please note in description that this is a variant of test 038,
so if someone fixes this test, they will know to fix the origin as well.

BTW, it would be good, when you are done with this test to also add
a test for "Test constant inode numbers on non-samefs setup", a variant
of overlay/017, which also checks the st_dev assertions.
I know you wrote these tests for unionmount testsuite, but an
xfstest has greater value.

...

> +
> +_scratch_unmount &>>$seqres.full
> +_test_unmount &>>$seqres.full
> +
> +$MOUNT_PROG $OVL_BASE_SCRATCH_DEV $OVL_BASE_SCRATCH_MNT
> +$MOUNT_PROG $OVL_BASE_TEST_DEV $OVL_BASE_TEST_DIR

FYI, OVL_BASE_SCRATCH_DEV/OVL_BASE_TEST_DEV may not be configured
at all. Doesn't matter because you shouldn't be using those commands anyway
(see below)

> +
> +rm -rf $OVL_BASE_SCRATCH_MNT/*
> +rm -rf $OVL_BASE_TEST_DIR/*
> +

Wiping out TEST_DIR is not playing by the rules.
Tests should not format TEST partition.
You  can either use tmpfs for lower dir, like some other tests do
or you can use a directory in BASE_TEST_DIR for lower dir, for example:
lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
rm -rf $lowerdir


> +lowerdir=$OVL_BASE_TEST_DIR/ovl-lower
> +upperdir=$OVL_BASE_SCRATCH_MNT/ovl-upper
> +workdir=$OVL_BASE_SCRATCH_MNT/ovl-work
> +ovlmnt=$OVL_BASE_SCRATCH_MNT/ovl-mnt
> +
> +mkdir $lowerdir
> +mkdir $upperdir
> +mkdir $workdir
> +mkdir $ovlmnt
> +

All of the operations above with SCRATCH partition beginning with
_scratch_unmount should be replaced with a single command that
does exactly what you re-implemented:

_scratch_mkfs

> +# Create our test files.
> +mkdir $lowerdir/test_dir/
> +mkdir $lowerdir/test_dir/pure_lower_dir
> +mkdir $lowerdir/test_dir/merged_dir
> +
> +touch $lowerdir/test_file
> +
> +$MOUNT_PROG -t overlay overlay -o lowerdir=$lowerdir \
> +           -o upperdir=$upperdir -o workdir=$workdir $ovlmnt
> +

This should be using _overlay_mount_dirs()
I already fixed this for overlay/038 on my overlayfs-devel branch
that was posted for review last week.

...

> +
> +chown -h 100 $ovlmnt/test_file

This chown looks like a leftover from test overlay/017
Not sure what is the role it is playing in this test, unless
I am missing something (mv will already copy up test_file).
Same comment applies to test 038.

> +test_file_st_ino=$(stat -c '%i' $ovlmnt/test_file)
> +
> +mv $ovlmnt/test_file $impure_dir
> +

Thanks,
Amir.
