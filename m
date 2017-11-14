From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V2] overlay: Test consistent st_ino numbers for non-samefs scenario
Date: Tue, 14 Nov 2017 15:45:17 +0200
Message-ID: <CAOQ4uxj993Dihz3aTbC-ejcnZrxnh2AqufV25agpjfW_02Dbbg@mail.gmail.com>
References: <20171114110948.31345-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:55963 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755066AbdKNNpT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2017 08:45:19 -0500
In-Reply-To: <20171114110948.31345-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Tue, Nov 14, 2017 at 1:09 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit adds a test to verify consistent st_ino feature when
> the overlayfs instance is composed of two different underlying
> filesystem instances.
>
> For example,
> $ mount -t xfs /dev/loop0 /mnt/test
> $ mount -t xfs /dev/loop1 /mnt/scratch
> $ mkdir /mnt/scratch/upper
> $ mkdir /mnt/scratch/work
> $ mount -t overlay overlay -o lowerdir=/mnt/test \
>         -o upperdir=/mnt/scratch/upper \
>         -o workdir=/mnt/scratch/work /mnt/merge
>
> The goal of this test is to verify that overlayfs returns consistent
> st_ino for the following scenarios,
> - Copy-up of lowerdir files
> - Rename files and drop dentry/inode cache
> - Remount the overlayfs instance
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
> Changelog:
> v1->v2:
> Address review comments provided by Amir.
> 1. To succeed, the test now requires the underlying base filesystems to provide
>    32-bit inode numbers or the user to provide "xino" mount option. The test
>    also requires that either overlayfs 'index' config feature to be enabled by
>    default or to be enabled by using the 'index=on' mount option.
> 2. Require $TEST_DEV for use as Overlayfs' lowerdir.
> 3. Pass $OVERLAY_MOUNT_OPTIONS as argument to _overlay_scratch_mount_dirs().
>
>  tests/overlay/043     | 167 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/043.out |   2 +
>  tests/overlay/group   |   1 +
>  3 files changed, 170 insertions(+)
>  create mode 100755 tests/overlay/043
>  create mode 100644 tests/overlay/043.out
>
> diff --git a/tests/overlay/043 b/tests/overlay/043
> new file mode 100755
> index 0000000..5778564
> --- /dev/null
> +++ b/tests/overlay/043
> @@ -0,0 +1,167 @@
> +#! /bin/bash
> +# FSQA Test No. 043
> +#
> +# Test constant inode numbers on non-samefs setup
> +# This is a variant of overlay/017 to test constant st_ino numbers for
> +# non-samefs setup.
> +#
> +# This simple test demonstrates a known issue with overlayfs:
> +# - stat file A shows inode number X
> +# - modify A to trigger copy up
> +# - stat file A shows inode number Y != X
> +#
> +# Also test if d_ino of readdir entries changes after copy up
> +# and if inode numbers persist after rename, drop caches and
> +# mount cycle.
> +#
> +# This test succeeds when either the underlying filesystems provide 32-bit
> +# inode numbers or when the xino mount option is provided. This test
> +# also requires that either overlayfs 'index' config feature to be enabled by
> +# default or to be enabled by using the 'index=on' mount option.
> +#


Test looks good, but I am not happy with merging this text, even though I wrote
part of it...

Regarding the claim that the test succeeds on 32bit ino file systems,
this is not
yet true and may not be true in the future. We won't know how 'xino' will be
call or configured until the feature is merged, so I suggest to leave
this paragraph
out of the test description before merging.

Regarding the 'index' feature text, I don't like the situation as it is.
I would like to get a feedback from Eryu after he understands the options,
but my proposal is as follows:

- Test overlay/017 (constant st_ino/d_ino) should be independent of index
  so remove "hardlink1 hardlink2" from overlay/017 FILES, because the
  hardlinks use case is already covered by the more specific 018 test
  which does require and enable index.
- Add the d_ino verification from 017 also to 018, so test coverage for
  hardlinks doesn't change
- That makes 017 a regression test for constant st_ino/d_ino (excluding
  hardlinks), even if index is disabled and 018 a regression test for hardlinks
  (including st_ino/d_ino) which depends on index feature

If that is acceptable then the new variants 017 should not require index
and a nonsamefs variant of 018 which does require index would be nice.

Thinking out loud: would it have been better if we added a general way
to configure all tests to tun in non-samefs configuration instead of duplicating
individual test? I don't have any good ideas how that would work.

Eryu,

What do you think about all this?

Amir.
