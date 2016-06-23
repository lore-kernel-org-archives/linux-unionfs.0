From: Xiong Zhou <xzhou@redhat.com>
Subject: Re: [PATCH 1/3] overlay: test visible whiteout issue after rename
Date: Thu, 23 Jun 2016 20:08:49 +0800
Message-ID: <20160623120849.GA4217@dhcp12-144.nay.redhat.com>
References: <1466595538-23719-1-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466595538-23719-1-git-send-email-eguan@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jun 22, 2016 at 07:38:56PM +0800, Eryu Guan wrote:
> Test visible whiteout issue after renaming file from lowerdir to a
> dir in upperdir.
> 
> Upstream commit 45d117389696 ("ovl: ignore lower entries when
> checking purity of non-directory entries") fixed the issue

To this series, git am and test run looks ok.

Reviewed-by: Xiong Zhou <xzhou@redhat.com>

> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/overlay/006     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/006.out |  2 ++
>  tests/overlay/group   |  1 +
>  3 files changed, 80 insertions(+)
>  create mode 100755 tests/overlay/006
>  create mode 100644 tests/overlay/006.out
> 
> diff --git a/tests/overlay/006 b/tests/overlay/006
> new file mode 100755
> index 0000000..31f11ef
> --- /dev/null
> +++ b/tests/overlay/006
> @@ -0,0 +1,77 @@
> +#! /bin/bash
> +# FS QA Test 006
> +#
> +# Test visible whiteout issue after renaming file from lowerdir to a dir in
> +# upperdir.
> +#
> +# Upstream commit 45d117389696 ("ovl: ignore lower entries when checking purity
> +# of non-directory entries") fixed the issue
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Red Hat Inc.,  All Rights Reserved.
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
> +
> +echo "Silence is golden"
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +# Create test file/dir before mount
> +mkdir $SCRATCH_DEV/$OVERLAY_LOWER_DIR
> +mkdir $SCRATCH_DEV/$OVERLAY_UPPER_DIR
> +touch $SCRATCH_DEV/$OVERLAY_LOWER_DIR/lowertestfile
> +mkdir $SCRATCH_DEV/$OVERLAY_UPPER_DIR/uppertestdir
> +
> +_scratch_mount
> +
> +# rename lowertestfile to uppertestdir, this triggers copyup and creates
> +# whiteout in $OVERLAY_UPPER_DIR
> +mv $SCRATCH_MNT/lowertestfile $SCRATCH_MNT/uppertestdir
> +# the lowertestfile can be removed
> +rm $SCRATCH_MNT/uppertestdir/lowertestfile
> +# no file no whiteout file in upptestdir
> +ls $SCRATCH_MNT/uppertestdir
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/006.out b/tests/overlay/006.out
> new file mode 100644
> index 0000000..675c1b7
> --- /dev/null
> +++ b/tests/overlay/006.out
> @@ -0,0 +1,2 @@
> +QA output created by 006
> +Silence is golden
> diff --git a/tests/overlay/group b/tests/overlay/group
> index d8fc597..78a67bf 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -8,3 +8,4 @@
>  003 auto quick whiteout
>  004 attr auto copyup quick
>  005 auto copyup quick
> +006 auto quick copyup whiteout
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
