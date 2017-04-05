From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/2] overlay/030: test immutable and append-only upper
 files
Date: Wed, 5 Apr 2017 19:57:14 +0800
Message-ID: <20170405115714.GE22845@eguan.usersys.redhat.com>
References: <1491389271-24726-1-git-send-email-amir73il@gmail.com>
 <1491389271-24726-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491389271-24726-2-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 05, 2017 at 01:47:51PM +0300, Amir Goldstein wrote:
> Run the t_immutable test program for immutable/append-only files
> and directories in an overlayfs upper directory.
> 
> This test is similar and was derived from generic/079, but
> the original test is _notrun on overlay mount because FS_IOC_GETFLAGS
> FS_IOC_SETFLAGS ioctls fail on overlay directory inodes.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks good to me. Some minor issues inline.

> ---
>  tests/overlay/030     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/030.out |  5 ++++
>  tests/overlay/group   |  1 +
>  3 files changed, 80 insertions(+)
>  create mode 100755 tests/overlay/030
>  create mode 100644 tests/overlay/030.out
> 
> Eryu, Xiong,
> 
> While looking at overlay/027 and comparing it to generic/079,
> I realized that overlay/027 wasn't testing quite enough.

Thanks for the test!

> 
> There are many tests from t_immutable where overlayfs fails,
> because:
> - either overlay directory inodes don't inherit the upper flags
> - or vfs checks the flags on overlay inode (e.g. IS_APPEND() on ftruncate)
> 
> This test fails on kernel v4.10 as follows:
> open(SCRATCH_MNT/t_immutable/append-only.f, O_RDWR) did not fail
> open(SCRATCH_MNT/t_immutable/append-only.f, O_WRONLY) did not fail
> open(SCRATCH_MNT/t_immutable/append-only.f, O_RDWR|O_TRUNC) did not fail
> open(SCRATCH_MNT/t_immutable/append-only.f, O_WRONLY|O_TRUNC) did not fail
> open(SCRATCH_MNT/t_immutable/append-only.f, O_RDWR|O_APPEND|O_TRUNC) did not fail
> open(SCRATCH_MNT/t_immutable/append-only.f, O_WRONLY|O_APPEND|O_TRUNC) did not fail
> truncate(SCRATCH_MNT/t_immutable/append-only.f, 0) did not fail
> testing immutable...PASS.
> testing append-only...FAILED! (7 tests failed)
> 
> But actually, I think t_immutable stops too early as there are other
> (directory tests) that should also be failing, but at least overlay does not
> allow setting attr flags on directories so this is a lesser concern.
> 
> Miklos,
> 
> Do you think we should propagate the S_IMMUTABLE/S_APPEND flags to overlay
> inodes?
> We could also implement the FS_IOC_GETFLAGS/FS_IOC_SETFLAGS ioctls for
> overlay directory inodes if you think this is useful to have.
> 
> Amir.
> 
> diff --git a/tests/overlay/030 b/tests/overlay/030
> new file mode 100755
> index 0000000..d51189a
> --- /dev/null
> +++ b/tests/overlay/030
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# FS QA Test No. 030
> +#
> +# Run the t_immutable test program for immutable/append-only files
> +# and directories in an overlayfs upper directory.
> +#
> +# This test is similar and was derived from generic/079, but
> +# the original test is _notrun on overlay mount because FS_IOC_GETFLAGS
> +# FS_IOC_SETFLAGS ioctls fail on overlay directory inodes.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
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
> +#
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +timmutable=$here/src/t_immutable
> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	$timmutable -r $upperdir/t_immutable &> /dev/null
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +_supported_fs generic

Should be overlay not generic

> +_supported_os Linux
> +
> +_require_chattr ia
> +_require_scratch
> +
> +[ -x $timmutable ] || _notrun "t_immutable was not built for this platform"

We have _require_test_program helper now, just

_require_test_program "t_immutable"

> +
> +_scratch_mkfs
> +
> +# Preparing immutable files in uppper dir
> +mkdir -p $upperdir
> +$timmutable -C $upperdir/t_immutable >$tmp.out 2>&1
> +if grep -q -e 'Operation not supported' -e "Inappropriate ioctl" $tmp.out; then
> +	_notrun "Setting immutable/append flag not supported"
> +fi
> +
> +_scratch_mount
> +
> +# Test immutability of files in overlay
> +$timmutable $SCRATCH_MNT/t_immutable 2>&1 | _filter_scratch

Seems _filter_scratch is not needed.

Thanks,
Eryu
> +status=$?
> +exit
> diff --git a/tests/overlay/030.out b/tests/overlay/030.out
> new file mode 100644
> index 0000000..57ba0cd
> --- /dev/null
> +++ b/tests/overlay/030.out
> @@ -0,0 +1,5 @@
> +QA output created by 030
> +testing immutable...PASS.
> +testing append-only...PASS.
> +testing immutable as non-root...PASS.
> +testing append-only as non-root...PASS.
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 7e72a30..c5048c4 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -32,3 +32,4 @@
>  027 auto quick perms
>  028 auto copyup quick
>  029 auto quick
> +030 auto quick perms
> -- 
> 2.7.4
> 
