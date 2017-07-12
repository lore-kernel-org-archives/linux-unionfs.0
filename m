From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/5] overlay/014: fix test with inodes index enabled
Date: Wed, 12 Jul 2017 18:36:42 +0800
Message-ID: <20170712103642.GC7015@eguan.usersys.redhat.com>
References: <1499802726-11045-1-git-send-email-amir73il@gmail.com>
 <1499802726-11045-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755279AbdGLKgo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jul 2017 06:36:44 -0400
Content-Disposition: inline
In-Reply-To: <1499802726-11045-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jul 11, 2017 at 10:52:03PM +0300, Amir Goldstein wrote:
> When overlayfs is configured with CONFIG_OVERLAY_FS_INDEX=y,
> workdir from previous overlay mount cannot be reused in a new
> overlay mount that uses a different upper dir.
> 
> Fix the test to use a different workdir when mounting with a
> different upper dir.
> 
> This change has not effect on older kernels and overlay
> configured without CONFIG_OVERLAY_FS_INDEX.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/014 | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/overlay/014 b/tests/overlay/014
> index 40d10f5..6a551b7 100755
> --- a/tests/overlay/014
> +++ b/tests/overlay/014
> @@ -63,12 +63,13 @@ lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
>  lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
>  upperdir=$OVL_BASE_SCRATCH_MNT/upper
>  workdir=$OVL_BASE_SCRATCH_MNT/workdir
> -mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir

I added some comments before creating workdir2 (mostly copied from your
overlay document patch), please let me know if you have different
thoughts.

+# When overlay inode index feature is enabled, using an upper layer path and/or
+# a workdir path that are already used by another overlay mount is not allowed
+# and will fail with EBUSY, so create another workdir for the second overlay
+# mount
> +workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
> +mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir $workdir2
>  mkdir -p $lowerdir1/testdir/d

Thanks,
Eryu

>  
>  # mount overlay with $lowerdir2 as upperdir, and remove & recreate testdir,
>  # make testdir on $lowerdir2 opaque
> -_overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
> +_overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir2 $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
>  rm -rf $SCRATCH_MNT/testdir
>  mkdir -p $SCRATCH_MNT/testdir/visibledir
>  # unmount overlayfs but not base fs
> -- 
> 2.7.4
> 
