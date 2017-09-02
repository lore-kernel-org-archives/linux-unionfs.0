From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V3] overlay: Test constant d_ino feature
Date: Sat, 2 Sep 2017 19:28:14 +0300
Message-ID: <CAOQ4uxg65KP+pXG5hMCrouae=caMkpcP1=QvCTTNYuGfF6pnqA@mail.gmail.com>
References: <20170901142341.28872-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33600 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752697AbdIBQ2P (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 2 Sep 2017 12:28:15 -0400
In-Reply-To: <20170901142341.28872-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Sep 1, 2017 at 5:23 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit adds a test to verify constant d_ino feature. The following
> scenarios are checked,
> - Parent's (i.e. "..") d_ino must always be calculated because a pure
>   dir can be residing inside a merged dir.
> - d_ino for "." must always be calculated because the present directory
>   can have a copy-up origin.
> - Verify d_ino of '.' and '..' before and after dir becomes
>   impure. While at it also verify if trusted.overlay.impure xattr is
>   set/reset appropriately and invalidation of readdir cache.
> - Verify copied up file's (inside a impure dir) d_ino.
> - Verify d_ino values corresponding to "." and ".." entries of a pure
>   lower dir.
> - Verify d_ino of ".." entry of a merged dir.
> - Verify pure lower residing in dir which has another lower layer
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Chandan,

The test looks good, test coverage is very good now and I also tested that
it passes with overlayfs-next.
Timing is also good with merge window coming up.
We are down to petty bash nit picking ;-) (see below)

...

> +[[ $parent_d != ".. d" ]] && \
> +       echo "Pure dir inside a merged dir: Invalid d_ino reported for .."
> +

This is not incorrect for an xfstest, but I much prefer the construct
[ expected condition ] || echo "condition not met"

The difference is purely semantic, but the result of this construct is success
and the result of the construct you used is failure, so if it the last statement
in a script of function, the overall result (failure) may be confusing.

So unless you have a strong counter argument, please fix all those
constructs and be careful, this is the stage where typos sneak in... ;-)
...

> +$GETFATTR_PROG --absolute-names --dump -m trusted $upperdir/test_dir/impure_dir \
> +       | grep -q -F 'trusted.overlay.impure'
> +[[ $? != 0 ]] && echo "Impure directory missing impure xattr"
> +


How about:

$GETFATTR_PROG --absolute-names -n 'trusted.overlay.impure'
$upperdir/test_dir/impure_dir \
                > /dev/null || echo "Impure directory missing impure xattr"

...
> +
> +$GETFATTR_PROG --absolute-names --dump -m trusted $upperdir/test_dir/impure_dir \
> +       | grep -q -F 'trusted.overlay.impure'
> +[[ $? == 0 ]] && echo "Pure directory has impure xattr"
> +

IMO, here its fine to use && echo "Pure directory has impure xattr"
but grep is also not needed.

...

> +# Verify pure lower residing in dir which has another lower layer
> +_scratch_mkfs
> +
> +OVL_LOWER0=${OVL_LOWER}0
> +OVL_LOWER1=${OVL_LOWER}1
> +
> +middir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER0
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER1
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> +
> +mkdir -p $middir
> +mkdir -p $lowerdir
> +mkdir -p $upperdir
> +mkdir -p $workdir
> +
> +mkdir -p $middir/dir0
> +mkdir -p $lowerdir/dir0/dir1

instead of dir0/dir1,
mkdir $lowerdir/test_dir/
mkdir $lowerdir/test_dir/pure_lower_dir

and then use same variable names use use in first part of the test
will make this part of the test easier to understand.

Cheers,
Amir.
