From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] overlay: test hardlink breakage on copy up
Date: Tue, 13 Dec 2016 11:35:50 +0800
Message-ID: <20161213033550.GG29149@eguan.usersys.redhat.com>
References: <1481538561-10558-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40268 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751180AbcLMDfx (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Dec 2016 22:35:53 -0500
Content-Disposition: inline
In-Reply-To: <1481538561-10558-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Dec 12, 2016 at 12:29:21PM +0200, Amir Goldstein wrote:
> Introduce a new test to demonstrate a known issue with overlayfs:
> - file A and B are hardlinked in lower
> - modify A to trigger copy up
> - file A is no longer a hardlink of file B
> 
> There is no fix for this issue at this time.

Is this something we want to fix eventually? If not, do we want a test
that is failing forever? I ask because I heard that this is something
not easy/worth fixing, at least low priority. But things may change now.

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/019     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/019.out |  2 ++
>  tests/overlay/group   |  1 +
>  3 files changed, 91 insertions(+)
>  create mode 100755 tests/overlay/019
>  create mode 100644 tests/overlay/019.out
> 
> diff --git a/tests/overlay/019 b/tests/overlay/019
> new file mode 100755
> index 0000000..382e4ee
> --- /dev/null
> +++ b/tests/overlay/019
> @@ -0,0 +1,88 @@
> +#! /bin/bash
> +# FSQA Test No. 019
> +#
> +# Test hardlink breakage
> +#
> +# This simple test demonstrates a known issue with overlayfs:
> +# - file A and B are hardlinked in lower
> +# - modify A to trigger copy up
> +# - file A is no longer a hardlink of file B
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
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +
> +# Create 2 hardlinked files in lower
> +lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
> +mkdir -p $lowerdir
> +echo "patient zero" >> $lowerdir/foo
> +ln $lowerdir/foo $lowerdir/bar
> +
> +
> +_scratch_mount
> +
> +cd $SCRATCH_MNT

It's uncommon to cd to $SCRATCH_MNT in fstests, if it can be done
without doing so. Usually we do

testfile1=$SCRATCH_MNT/foo
testfile2=$SCRATCH_MNT/bar

<do tests on $testfile1 and $testfile2>

Can this test be updated in this way? And patch "overlay: test unstable
inode number"? Sorry that I forgot about this yesterday..

Thanks!

Eryu

> +
> +rm -f $tmp.before $tmp.after
> +
> +# Record inode number and nlink before copy up
> +ls -li foo bar | awk '{ print $1, $3 }' > $tmp.before
> +
> +# Modify content of one of the hardlinks
> +echo "mutated" >> foo
> +
> +# Record inode number and nlink after copy up
> +ls -li foo bar | awk '{ print $1, $3 }' > $tmp.after
> +
> +# Compare ino/nlink before..after - expect silence
> +diff $tmp.before $tmp.after
> +
> +# Compare content of files - expect silence
> +diff foo bar
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/overlay/019.out b/tests/overlay/019.out
> new file mode 100644
> index 0000000..163484b
> --- /dev/null
> +++ b/tests/overlay/019.out
> @@ -0,0 +1,2 @@
> +QA output created by 019
> +Silence is golden
> diff --git a/tests/overlay/group b/tests/overlay/group
> index fb6610d..f266b0a 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -20,3 +20,4 @@
>  015 auto quick whiteout
>  016 auto quick copyup
>  018 auto quick copyup
> +019 auto quick copyup
> -- 
> 2.7.4
> 
