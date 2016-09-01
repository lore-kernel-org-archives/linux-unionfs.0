From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/2] overlay: copy-up lowerdir which has opaque xattr
 set
Date: Thu, 1 Sep 2016 10:22:41 +1000
Message-ID: <20160901002241.GB30056@dastard>
References: <1470741381-32610-1-git-send-email-eguan@redhat.com>
 <1470741381-32610-2-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470741381-32610-2-git-send-email-eguan@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Aug 09, 2016 at 07:16:21PM +0800, Eryu Guan wrote:
> When copying up a directory with opaque xattr set, the xattr was
> copied up as well, after a remount the opaque flag is honored so the
> copied-up directory is treated as opaque, which causes files created
> in the lowerdir to be hidden when using multiple lower directories.
> 
> This is fixed by "ovl: don't copy up opaqueness".
....
> +_scratch_mkfs
> +
> +# Create multiple lowerdirs and upperdir, workdir, and testdir on lowerdir
> +lowerdir1=$SCRATCH_DEV/lower1
> +lowerdir2=$SCRATCH_DEV/lower2
> +upperdir=$SCRATCH_DEV/upper
> +workdir=$SCRATCH_DEV/workdir
> +mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
> +mkdir -p $lowerdir1/testdir/d
> +
> +# mount overlay with $lowerdir2 as upperdir, and remove & recreate testdir,
> +# make testdir on $lowerdir2 opaque
> +_overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir none $SCRATCH_MNT

What is the "none" here? If _overlay_mount_dirs() doesn't require
this parameter to have a specifically valid value, then why are
we passing it in at all?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
