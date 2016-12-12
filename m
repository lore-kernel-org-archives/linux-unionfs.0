From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] overlay: test unstable inode number
Date: Mon, 12 Dec 2016 13:44:09 +0800
Message-ID: <20161212054409.GS29149@eguan.usersys.redhat.com>
References: <1481474280-3821-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750796AbcLLFoM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Dec 2016 00:44:12 -0500
Content-Disposition: inline
In-Reply-To: <1481474280-3821-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Dec 11, 2016 at 06:38:00PM +0200, Amir Goldstein wrote:
> Introduce a new test to demonstrate a known issue with overlayfs:
> - stat file A shows inode number X
> - modify A to trigger copy up
> - stat file A shows inode number Y != X
> 
> Also test if d_ino of readdir entries changes after copy up.
> 
> There is a POC patch by Miklos Szeredi that fixes this issue.
> ---
>  tests/overlay/018     | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/018.out |  5 +++
>  tests/overlay/group   |  1 +
>  3 files changed, 102 insertions(+)
>  create mode 100755 tests/overlay/018
>  create mode 100644 tests/overlay/018.out
> 
> diff --git a/tests/overlay/018 b/tests/overlay/018
> new file mode 100755
> index 0000000..4b358e5
> --- /dev/null
> +++ b/tests/overlay/018
> @@ -0,0 +1,96 @@
> +#! /bin/bash
> +# FSQA Test No. 018
> +#
> +# Test unstable inode number
> +#
> +# This simple test demonstrates a known issue with overlayfs:
> +# - stat file A shows inode number X
> +# - modify A to trigger copy up
> +# - stat file A shows inode number Y != X
> +#
> +# Also test if d_ino of readdir entries changes after copy up.
> +#
> +#-----------------------------------------------------------------------
> +#
> +# Copyright (C) 2016 CTERA Networks. All Rights Reserved.
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
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs overlay
> +_supported_os Linux

Need a "_require_user" here.

> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +
> +# Create our test files
> +lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
> +mkdir -p $lowerdir
> +mkdir $lowerdir/dir
> +touch $lowerdir/file
> +ln -s $lowerdir/file $lowerdir/symlink
> +mkfifo $lowerdir/fifo

Should hardlink and device-special be tested too?

Thanks,
Eryu
