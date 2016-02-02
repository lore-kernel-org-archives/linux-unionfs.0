From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] overlay: test permission checks within upper layer
Date: Tue, 2 Feb 2016 11:56:37 +0800
Message-ID: <20160202035637.GB11419@eguan.usersys.redhat.com>
References: <145427548927.28315.7391257381640174593.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <145427548927.28315.7391257381640174593.stgit@zurg>
Sender: fstests-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: fstests@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Feb 01, 2016 at 12:24:49AM +0300, Konstantin Khlebnikov wrote:
> Verify that unpriveleged user cannot copy-up and change file mode.

unprivileged, and there're two more typos below :)

> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> ---
>  tests/overlay/001     |   87 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/001.out |    2 +
>  tests/overlay/group   |    6 +++
>  3 files changed, 95 insertions(+)
>  create mode 100755 tests/overlay/001
>  create mode 100644 tests/overlay/001.out
>  create mode 100644 tests/overlay/group
> 
> diff --git a/tests/overlay/001 b/tests/overlay/001
> new file mode 100755
> index 000000000000..28fdf2af2b57
> --- /dev/null
> +++ b/tests/overlay/001
> @@ -0,0 +1,87 @@
> +#! /bin/bash
> +# FS QA Test 001
> +#
> +# Test permission checks for operations within upper layer
> +#
> +# Ubuntu CVE-2015-1328
> +# acff81ec2c79 ("ovl: fix permission checking for setattr")
> +# cf9a6784f7c1 ("ovl: setattr: check permissions before copy-up")
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Konstantin Khlebnikov.  All Rights Reserved.
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
> +runas=$here/src/runas
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	rm -fr $TEST_DEV/lower/$seq.dir
> +	rm -fr $TEST_DEV/upper/$seq.dir

I have a patch to turn the hard-coded "lower" and "upper" to exported
variables like $OVERLAY_UPPER_DIR $OVERLAY_LOWER_DIR. I think you can
use these variables.

[PATCH v2 2/3] common: export overlay lower/upper/work directories as variables

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
> +_require_test
> +_need_to_be_root
> +
> +echo "Silence is golden."
> +
> +[ -x $runas ] || _notrun "$runas executable not found"
> +
> +cd $TEST_DEV/lower
> +mkdir $seq.dir
> +touch $seq.dir/file
> +chmod 444 $seq.dir/file

Changes directly to the underlying filesystems when overlay is mounted
are not allowed, the behavior of the overlay is undefined then.

I'd do "_require_scratch" and create necessary files/dirs in
$SCRATCH_DEV before "_scratch_mount"

But note that The "lower" and "upper" dirs are not guaranteed to exist
before you call _scratch_mount, better to mkdir first.

> +
> +cd $TEST_DEV/upper
> +mkdir $seq.dir
> +chmod 555 $seq.dir
> +
> +cd $TEST_DIR
> +$runas -u 99 -g 99 chmod 777 $seq.dir/file >/dev/null 2>&1

The "fsgqa" user is used to do test as an unprivileged user.

_require_user first and "$runas -u `id -u fsgqa` -g `id -g fsgqa` ...

Thanks,
Eryu

> +
> +cd $TEST_DEV/upper
> +if [ -e $seq.dir/file ] ; then
> +	echo "FAIL: unpriveleged user copied-up file into upper"
> +	if [ `stat -c '%a' $seq.dir/file` != 444 ] ; then
> +		echo "FAIL: unpriveleged user changed file attributes"
> +	fi
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/001.out b/tests/overlay/001.out
> new file mode 100644
> index 000000000000..2d86e35be2fb
> --- /dev/null
> +++ b/tests/overlay/001.out
> @@ -0,0 +1,2 @@
> +QA output created by 001
> +Silence is golden.
> diff --git a/tests/overlay/group b/tests/overlay/group
> new file mode 100644
> index 000000000000..51a62cf64b89
> --- /dev/null
> +++ b/tests/overlay/group
> @@ -0,0 +1,6 @@
> +# QA groups control
> +#
> +# define groups and default group owners
> +# do not start group name with a digit
> +#
> +001 perms auto quick
> 
