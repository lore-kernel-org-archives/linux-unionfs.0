From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 4/6] overlay/017: create helpers to record and check
 inode numbers
Date: Fri, 28 Apr 2017 17:24:02 +0800
Message-ID: <20170428092402.GQ26397@eguan.usersys.redhat.com>
References: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
 <1493367888-26550-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164497AbdD1JYE (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 05:24:04 -0400
Content-Disposition: inline
In-Reply-To: <1493367888-26550-5-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Apr 28, 2017 at 11:24:46AM +0300, Amir Goldstein wrote:
> Use helpers to records and check inode numbers so we can repeat
> the same test after rename and mount cycle.
> 
> Suggested-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/017 | 57 ++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 42 insertions(+), 15 deletions(-)
> 
> diff --git a/tests/overlay/017 b/tests/overlay/017
> index 779907d..3ff429f 100755
> --- a/tests/overlay/017
> +++ b/tests/overlay/017
> @@ -72,32 +72,59 @@ mknod $lowerdir/blkdev b 1 1
>  mknod $lowerdir/fifo p
>  $here/src/af_unix $lowerdir/socket
>  
> +FILES="dir file symlink chrdev blkdev fifo socket"
> +
> +# Record inode numbers in format <ino> <basename>
> +function record_inode_numbers()
> +{
> +	dir=$1
> +	outfile=$2
> +
> +	for f in $FILES; do
> +		ls -id $dir/$f
> +	done | \
> +	while read ino file; do
> +		echo $ino `basename $file` >> $outfile
> +	done
> +}
> +
> +# Check inode numbers match recorder inode numbers
> +function check_inode_numbers()
> +{
> +	dir=$1
> +	before=$2
> +	after=$2
             ^^^ $3
Otherwise looks good to me. I can fix this typo at commit time.

But I've already kicked off release testing for this week's update,
I'll queue these patches for next update.

Thanks,
Eryu
