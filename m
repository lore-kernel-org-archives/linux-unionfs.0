From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests v3 2/8] overlay: work dir in overlay inherits no ACLs
Date: Tue, 21 Feb 2017 14:04:12 +0800
Message-ID: <20170221060412.GP24562@eguan.usersys.redhat.com>
References: <1487580524-21503-1-git-send-email-xzhou@redhat.com>
 <1487580524-21503-3-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751018AbdBUGEO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Feb 2017 01:04:14 -0500
Content-Disposition: inline
In-Reply-To: <1487580524-21503-3-git-send-email-xzhou@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, mszeredi@redhat.com

On Mon, Feb 20, 2017 at 04:48:38PM +0800, Xiong Zhou wrote:
> They should be cleaned while mounting overlayfs.
> 
> CC: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Xiong Zhou <xzhou@redhat.com>
> ---
>  tests/overlay/023     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/023.out |  8 +++++
>  tests/overlay/group   |  1 +
>  3 files changed, 90 insertions(+)
>  create mode 100755 tests/overlay/023
>  create mode 100644 tests/overlay/023.out
> 
> diff --git a/tests/overlay/023 b/tests/overlay/023
> new file mode 100755
> index 0000000..9f4ace5
> --- /dev/null
> +++ b/tests/overlay/023
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# FS QA Test 023
> +#
> +# The "work" directory in an overlyfs workdir should not inherit
> +# ACL attrs from workdir.
> +# Kernel commits below fix it.
> +#   c11b9fdd6a61 ovl: remove posix_acl_default from workdir
> +#   e1ff3dd1ae52 ovl: fix workdir creation
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
> +. ./common/filter
> +. ./common/attr
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs overlay
> +_supported_os Linux
> +_require_acls
> +_require_scratch
> +
> +# Remove all files from previous tests
> +_scratch_mkfs
> +
> +# setting acls before mount
> +wkdir=$SCRATCH_DEV/$OVERLAY_WORK_DIR
> +mkdir -p $wkdir
> +setfacl -d -m o::rwx $wkdir
> +
> +_scratch_mount
> +
> +# getting acls and doing a non-common filter,
> +# since getfacl will remove leading / from absolute
> +# path names.
> +getfacl $wkdir/work 2>&1 | \
> +	sed -e "s,${wkdir#/},wkdir,g" \
> +	    -e "/Removing leading/ d"

You could use "-p" or "--absolute-names" option of getfacl to not strip
leading "/", which could simplify sed filter a bit. This applies to
other acl related tests in this patchset too.

Thanks,
Eryu

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/023.out b/tests/overlay/023.out
> new file mode 100644
> index 0000000..3bdaca4
> --- /dev/null
> +++ b/tests/overlay/023.out
> @@ -0,0 +1,8 @@
> +QA output created by 023
> +# file: wkdir/work
> +# owner: root
> +# group: root
> +user::---
> +group::---
> +other::---
> +
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 45768f5..09da1be 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -25,3 +25,4 @@
>  020 auto quick copyup perms
>  021 auto quick copyup
>  022 auto quick
> +023 auto quick attr
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
