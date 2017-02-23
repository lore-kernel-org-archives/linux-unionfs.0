From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests v4 4/8] overlay: permission check with cached acls in
 tmpfs
Date: Thu, 23 Feb 2017 18:52:56 +0800
Message-ID: <20170223105256.GC24562@eguan.usersys.redhat.com>
References: <1487842966-30986-1-git-send-email-xzhou@redhat.com>
 <1487842966-30986-5-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751017AbdBWKze (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 23 Feb 2017 05:55:34 -0500
Content-Disposition: inline
In-Reply-To: <1487842966-30986-5-git-send-email-xzhou@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, mszeredi@redhat.com

On Thu, Feb 23, 2017 at 05:42:42PM +0800, Xiong Zhou wrote:
> tmpfs does not implement ->get_acl method, overlayfs
> need to get its cached acls in permission check when
> lower or upper fs is tmpfs.
> 
> CC: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Xiong Zhou <xzhou@redhat.com>
> ---
>  common/rc             | 10 +++++++
>  tests/overlay/025     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/025.out |  2 ++
>  tests/overlay/group   |  1 +
>  4 files changed, 94 insertions(+)
>  create mode 100755 tests/overlay/025
>  create mode 100644 tests/overlay/025.out
> 
> diff --git a/common/rc b/common/rc
> index ec59b88..b58f7c6 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3297,6 +3297,16 @@ _get_fs_sysfs_attr()
>  }
>  
>  
> +# Attempt to mount tmpfs at given directory in $1.
> +#
> +# Example:
> +# _require_and_mount_tmpfs $tmpdir
> +#
> +_require_and_mount_tmpfs()
> +{
> +	$MOUNT_PROG -t tmpfs tmpfs $1 || \
> +		_notrun "this test requires valid tmpfs"
> +}

We don't mix a _require rule with doing a specific operation. And we can
follow the way in _require_ext2, e.g.

# this test requires tmpfs filesystem support
#
_require_tmpfs()
{
	modprobe tmpfs >/dev/null 2>&1
	grep -q tmpfs /proc/filesystems ||
		_notrun "this test requires tmpfs support"
}

>  
>  init_rc
>  
> diff --git a/tests/overlay/025 b/tests/overlay/025
> new file mode 100755
> index 0000000..3c9f843
> --- /dev/null
> +++ b/tests/overlay/025
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# FS QA Test 025
> +#
> +# Overlayfs failed to get posix acls if lower or upper
> +# fs is tmpfs.
> +# Kernel commit below fixed it.
> +# 5201dc449e4b ovl: use cached acl on underlying layer
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
> +	$UMOUNT_PROG $tmpfsdir/mnt
> +	$UMOUNT_PROG $tmpfsdir
> +	rm -rf $tmpfsdir
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
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
> +_require_user

_require_tmpfs

> +
> +# create a tmpfs in $TEST_DIR
> +tmpfsdir=$TEST_DIR/tmpfs
> +mkdir -p $tmpfsdir
> +_require_and_mount_tmpfs $tmpfsdir

then this simply becomes

$MOUNT_PROG -t tmpfs tmpfs $tmpfsdir

If all these look sane to you, I can do this straightforward update at
commit time.

Thanks,
Eryu

> +
> +mkdir -p $tmpfsdir/{lower,upper,work,mnt}
> +mkdir -p -m 0 $tmpfsdir/upper/testd
> +# grant permission for $qa_user
> +setfacl -m u:$qa_user:rx $tmpfsdir/upper/testd
> +
> +# mount overlay using dirs in tmpfs
> +_overlay_mount_dirs $tmpfsdir/{lower,upper,work,overlay,mnt}
> +
> +# user accessing test dir, should be OKay
> +_user_do "ls $tmpfsdir/mnt/testd"
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/025.out b/tests/overlay/025.out
> new file mode 100644
> index 0000000..3d70951
> --- /dev/null
> +++ b/tests/overlay/025.out
> @@ -0,0 +1,2 @@
> +QA output created by 025
> +Silence is golden
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 0563a04..82fe69e 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -27,3 +27,4 @@
>  022 auto quick
>  023 auto quick attr
>  024 auto quick
> +025 auto quick attr
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
