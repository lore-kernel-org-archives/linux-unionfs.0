From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests v3 5/8] overlay: filter out xattr starts with
 "trusted.overlay."
Date: Tue, 21 Feb 2017 14:23:22 +0800
Message-ID: <20170221062322.GR24562@eguan.usersys.redhat.com>
References: <1487580524-21503-1-git-send-email-xzhou@redhat.com>
 <1487580524-21503-6-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36204 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750837AbdBUGXY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Feb 2017 01:23:24 -0500
Content-Disposition: inline
In-Reply-To: <1487580524-21503-6-git-send-email-xzhou@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, mszeredi@redhat.com

On Mon, Feb 20, 2017 at 04:48:41PM +0800, Xiong Zhou wrote:
> Not "trusted.overlay".
>   "trusted.overlayxxx" is allowed.
>   "trusted.overlay.xxx" is not allowed.

Need better description in commit log :)

> 
> CC: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Xiong Zhou <xzhou@redhat.com>
> ---
>  tests/overlay/026     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/026.out |  5 +++
>  tests/overlay/group   |  1 +
>  3 files changed, 105 insertions(+)
>  create mode 100755 tests/overlay/026
>  create mode 100644 tests/overlay/026.out
> 
> diff --git a/tests/overlay/026 b/tests/overlay/026
> new file mode 100755
> index 0000000..86f73ea
> --- /dev/null
> +++ b/tests/overlay/026
> @@ -0,0 +1,99 @@
> +#! /bin/bash
> +# FS QA Test 026
> +#
> +# Overlayfs should only filter out xattr starting with
> +# "trusted.overlay.", not "trusted.overlay".
> +# Setting xattrs like "trusted.overlay.xxx" is not allowed.
> +# Setting xattrs like "trusted.overlayxxx" is allowed.
> +#
> +# Kernel commit below fixed it.
> +# fe2b75952347 ovl: Fix OVL_XATTR_PREFIX
> +#
> +# This reproducer was originally written by
> +#     Miklos Szeredi <mszeredi@redhat.com>
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Red Hat Inc.  All Rights Reserved.
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
> +. ./common/attr
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch
> +_require_attrs
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +# Mounting overlay
> +_scratch_mount
> +touch $SCRATCH_MNT/testf0
> +touch $SCRATCH_MNT/testf1
> +
> +# {s,g}etfattr of "trusted.overlayxxx" should work.
> +$SETFATTR_PROG -n "trusted.overlayfsrz" -v "n" \
> +  $SCRATCH_MNT/testf0
> +
> +$GETFATTR_PROG -n "trusted.overlayfsrz" $SCRATCH_MNT/testf0 \
> +  2>&1 | sed -e "s,${SCRATCH_MNT#/},SCRATCH_MNT,g" \

getfattr has "--absolute-names" option too. And does _filter_scratch
work in this case?

> +	     -e "/Removing leading/ d" \
> +	     -e "/^$/ d"
> +
> +# {s,g}etfattr of "trusted.overlay.xxx" should fail.
> +# The errno returned varies between kernel versions,
> +#            v4.3       v4.7       v4.8      v4.10
> +# setfattr  not perm  not perm   not perm   not supp
> +# getfattr  no attr   no attr    not perm   not supp
> +#
> +# Checking the latest(not supported).
> +#

How about filtering all kinds error messages to current "Operation not
supported"?

Thanks,
Eryu

> +$SETFATTR_PROG -n "trusted.overlay.fsz" -v "n" \
> +  $SCRATCH_MNT/testf1 2>&1 | \
> +  sed -e "s,${SCRATCH_MNT},SCRATCH_MNT,g" \
> +
> +$GETFATTR_PROG -n "trusted.overlay.fsz" \
> +  $SCRATCH_MNT/testf1 2>&1 | \
> +  sed -e "s,${SCRATCH_MNT},SCRATCH_MNT,g" \
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/026.out b/tests/overlay/026.out
> new file mode 100644
> index 0000000..94da51b
> --- /dev/null
> +++ b/tests/overlay/026.out
> @@ -0,0 +1,5 @@
> +QA output created by 026
> +# file: SCRATCH_MNT/testf0
> +trusted.overlayfsrz="n"
> +setfattr: SCRATCH_MNT/testf1: Operation not supported
> +SCRATCH_MNT/testf1: trusted.overlay.fsz: Operation not supported
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 82fe69e..92afa8d 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -28,3 +28,4 @@
>  023 auto quick attr
>  024 auto quick
>  025 auto quick attr
> +026 auto attr quick
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
