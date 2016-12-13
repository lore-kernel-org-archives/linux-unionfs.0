From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] overlay/01[6,8]: do not cd into $SCRATCH_MNT
Date: Tue, 13 Dec 2016 13:18:06 +0800
Message-ID: <20161213051806.GJ29149@eguan.usersys.redhat.com>
References: <1481605502-8361-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11885 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbcLMFSI (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Dec 2016 00:18:08 -0500
Content-Disposition: inline
In-Reply-To: <1481605502-8361-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Dec 13, 2016 at 07:05:02AM +0200, Amir Goldstein wrote:
> - Avoid cd into $SCRATCH_MNT
> - Cleanup unneeded _cleanup()
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/016     | 21 +++++++--------------
>  tests/overlay/016.out |  4 ++--
>  tests/overlay/018     | 10 ++++------
>  tests/overlay/018.out | 12 ++++++------
>  4 files changed, 19 insertions(+), 28 deletions(-)
> 
> diff --git a/tests/overlay/016 b/tests/overlay/016
> index 041ab3d..c37a0d4 100755
> --- a/tests/overlay/016
> +++ b/tests/overlay/016
> @@ -32,15 +32,9 @@ seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
> -tmp=/tmp/$$
>  status=1	# failure is the default!
> -trap "_cleanup; exit \$status" 0 1 2 3 15
> +trap "exit \$status" 0 1 2 3 15
>  
> -_cleanup()
> -{
> -	cd /
> -	rm -f $tmp.*
> -}

These initial common setups are still needed, especially "tmp", even if
it's not used in the test, because it may be used by other common helper
functions. So there's no need to update these initial setups come with
the template from "new" script, for no good reason.

>  
>  # get standard environment, filters and checks
>  . ./common/rc
> @@ -64,7 +58,6 @@ echo "This is old news" > $lowerdir/bar
>  
>  _scratch_mount
>  
> -cd $SCRATCH_MNT
>  
>  #
>  # case #1:
> @@ -73,12 +66,12 @@ cd $SCRATCH_MNT
>  # write to rwfd
>  # read from rofd
>  #
> -$XFS_IO_PROG -r foo \
> -	-C "open foo" \
> +$XFS_IO_PROG -r $SCRATCH_MNT/foo \
> +	-C "open $SCRATCH_MNT/foo" \
>  	-C "pwrite -S 0x61 0 16" \
>  	-C "file 0" \
>  	-C "pread -v 0 16" \
> -| _filter_xfs_io
> +| _filter_xfs_io | _filter_scratch
>  
>  #
>  # case #2:
> @@ -86,12 +79,12 @@ $XFS_IO_PROG -r foo \
>  # write to rwfd
>  # read from mapped memory
>  #
> -$XFS_IO_PROG -r bar \
> +$XFS_IO_PROG -r $SCRATCH_MNT/bar \
>  	-C "mmap -r 0 16" \
> -	-C "open bar" \
> +	-C "open $SCRATCH_MNT/bar" \
>  	-C "pwrite -S 0x61 0 16" \
>  	-C "mread -v 0 16" \
> -| _filter_xfs_io
> +| _filter_xfs_io | _filter_scratch

Only the test itself need to be updated, to avoid cd into SCRATCH_MNT.

And can you please come up with a patch that updates overlay/016 only
and fold 018 updates into its original patch and resend? Because 016 has
been committed and pushed to upstream, but 018 is still in my local tree
and pending pushing to upstream.

Sorry about being a bit picky.. and thank you!

Eryu
