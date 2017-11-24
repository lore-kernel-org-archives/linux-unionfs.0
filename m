From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH] overlay: add a test for multiple redirects to the same
 lower dir
Date: Fri, 24 Nov 2017 15:32:35 +0800
Message-ID: <db0174cd-938d-e365-01ae-03afb9bd3d66@huawei.com>
References: <1511447224-2301-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:56081 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751719AbdKXHe3 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 24 Nov 2017 02:34:29 -0500
In-Reply-To: <1511447224-2301-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, Miao Xie <miaoxie@huawei.com>

On 2017/11/23 22:27, Amir Goldstein Wrote:
> Multiple redirects to the same lower dir will falsely return the
> same st_ino/st_dev for two different upper dirs and will cause 'diff'
> to falsely report that content of directories is the same when it is not.
> 
> This is a test for a regression introduced in kernel v4.12 by
> commit 72b608f08528 ("ovl: constant st_ino/st_dev across copy up"),
> but also the first xfstest to require the redirect_dir feature that
> was introduced as an opt-in feature in kernel v4.10.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Eryu,
> 
> This test is for a "bug" that has not been acknoledges by Miklos
> as a kernel bug yet. It may well fall within the jurisdiction of
> fsck.overlayfs.
> 
> IMO, cp -a of upper files and dirs qualifies to the statement in
> Documentation/filesystems/overlayfs.txt:
> "Offline changes, when the overlay is not mounted, are allowed to either
> the upper or the lower trees."
> 
Hi Amir:

I have some persional opinions.

If I understand right, I think we need to change this statement and add
some limitations. I make an analogy with Ext4 filesystem:

1) Creating lower layers and upper dirs in overlayfs before first mount
   is like mkfs.ext4 to create an image in Ext4fs. Ext4 filesystem can
   guarantee consistency in this step but overlayfs cannot, so It's better
   to hint users to check the "overlay image" through fsck.overlay after
   he finish this "image".

2) Change lower layers or upper dirs when overlayfs is offline is like
   user modify ext4 image through tune2fs/debugfs or even modify it in
   block device directly. Ext4fs also cannot guarantee everything is right
   when user modify fs image limitless(should not crash), so fsck.ext4 is
   necessary after modifing image(except fault injection). From overlayfs's
   point of view, modify "overlay image" when it's offline is okay, but it
   should pass fsck.overlay's check before next mount.

I guess most general users don't know which one the redirect xattr points to
or even what the redirect xattr is, they maybe just want to copy whole
directory in upperdir when they call "cp -a", so I think it can handled by
fsck.overlay.

Do I understand this correctly, any thoughts ?

Thanks,
Yi.

> So unless Miklos objects to ever fixing this "bug"?
> I suggest that we include the failing test until kernel is fixed.
> 
> Incidently, I already have patches for 'verify' feature [1], which
> I intend to post after the merge window closes.
> With 'verify' feature enabled this test passes.
> 
> Amir.
> 
> [1] https://github.com/amir73il/linux/commits/ovl-index-all
> 
>  tests/overlay/049     | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/049.out |   2 +
>  tests/overlay/group   |   1 +
>  3 files changed, 107 insertions(+)
>  create mode 100755 tests/overlay/049
>  create mode 100644 tests/overlay/049.out
> 
> diff --git a/tests/overlay/049 b/tests/overlay/049
> new file mode 100755
> index 0000000..701a649
> --- /dev/null
> +++ b/tests/overlay/049
> @@ -0,0 +1,104 @@
> +#! /bin/bash
> +# FS QA Test 049
> +#
> +# Test multiple redirects to the same lower dir.
> +#
> +# Multiple redirects to the same lower dir will falsely return
> +# the same st_ino/st_dev for two different upper dirs and will
> +# cause 'diff' to falsely report that content of directories
> +# is the same when it is not.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
> +# Author: Amir Goldstein <amir73il@gmail.com>
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
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# Rename lower dir to create a redirected upper dir and
> +# touch lower file to create copy up with origin xattr
> +create_redirect()
> +{
> +	local redirect=$1
> +
> +	mkdir -p $lowerdir/origin
> +	touch $lowerdir/origin/file
> +
> +	_scratch_mount -o redirect_dir=on
> +	touch $SCRATCH_MNT/origin/file
> +	mv $SCRATCH_MNT/origin $SCRATCH_MNT/$redirect
> +
> +	$UMOUNT_PROG $SCRATCH_MNT
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch
> +_require_scratch_feature redirect_dir
> +
> +# remove all files from previous runs
> +_scratch_mkfs
> +
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +
> +# Create redirected dir with copied up file
> +create_redirect redirect1
> +# Duplicate the redirected dir and copied up file
> +cp -a $upperdir/redirect1 $upperdir/redirect2
> +
> +# Diverge the content of the two copies of file
> +# and the content of two copies of redirected dir
> +echo right >> $upperdir/redirect1/file
> +touch $upperdir/redirect1/right
> +echo wrong >> $upperdir/redirect2/file
> +touch $upperdir/redirect2/wrong
> +
> +_scratch_mount -o redirect_dir=on
> +
> +# If both copies of file/dir use the same st_dev/st_ino in overlay
> +# diff won't detect that their content differs
> +diff -q $SCRATCH_MNT/redirect1/file $SCRATCH_MNT/redirect2/file &>/dev/null && \
> +	echo "diff on files inside duplicate redirect parent doesn't know right from wrong!"
> +
> +diff -q $SCRATCH_MNT/redirect1 $SCRATCH_MNT/redirect2 &> /dev/null && \
> +	echo "diff on duplicate redirect dirs doesn't know right from wrong!"
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/overlay/049.out b/tests/overlay/049.out
> new file mode 100644
> index 0000000..c69568a
> --- /dev/null
> +++ b/tests/overlay/049.out
> @@ -0,0 +1,2 @@
> +QA output created by 049
> +Silence is golden
> diff --git a/tests/overlay/group b/tests/overlay/group
> index b32c6cd..cf21750 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -47,3 +47,4 @@
>  042 auto quick copyup hardlink
>  043 auto quick copyup nonsamefs
>  044 auto quick copyup hardlink nonsamefs
> +049 auto quick copyup redirect
> 
