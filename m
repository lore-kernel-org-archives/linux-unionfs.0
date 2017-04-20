From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 4/4] fstests: add generic test for file handles
Date: Thu, 20 Apr 2017 14:00:54 +0800
Message-ID: <20170420060054.GX8951@eguan.usersys.redhat.com>
References: <1492619359-24763-1-git-send-email-amir73il@gmail.com>
 <1492619359-24763-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S939201AbdDTGA6 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2017 02:00:58 -0400
Content-Disposition: inline
In-Reply-To: <1492619359-24763-5-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Wed, Apr 19, 2017 at 07:29:19PM +0300, Amir Goldstein wrote:
> Cloned from xfs specific test xfs/238, which checks
> stale file handles of deleted files.
> 
> This test uses the generic open_by_handle_at() syscall
> and also tests for non-stale file handles of linked files.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/generic/426     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/426.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 77 insertions(+)
>  create mode 100755 tests/generic/426
>  create mode 100644 tests/generic/426.out
> 
> diff --git a/tests/generic/426 b/tests/generic/426
> new file mode 100755
> index 0000000..c39c165
> --- /dev/null
> +++ b/tests/generic/426
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# FS QA Test No. 426
> +#
> +# Check stale handles pointing to unlinked files
> +# and non-stale handles pointing to linked files
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
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +# _require_exportfs already requires open_by_handle, but let's not count on it
> +_require_test_program "open_by_handle"
> +_require_exportfs
> +
> +numfiles=1024
> +testdir=$TEST_DIR/$seq-dir
> +mkdir -p $testdir
> +
> +# Check stale handles to deleted files
> +rm -f $testdir/*
> +src/open_by_handle -c $testdir $numfiles
> +src/open_by_handle -d $testdir $numfiles
> +
> +# Check non-stale handles to linked files
> +rm -f $testdir/*
> +src/open_by_handle -c $testdir $numfiles
> +src/open_by_handle    $testdir $numfiles
> +
> +# Check non-stale handles to files that were hardlinked and original deleted
> +src/open_by_handle -l $testdir $numfiles
> +src/open_by_handle -u $testdir $numfiles

This last test still depends on test files created in the second test
implicitly. Forgot to update this part?

# Check non-stale handles to files that were hardlinked and original deleted
rm -f $testdir/*
src/open_by_handle -c $testdir $numfiles
src/open_by_handle -l $testdir $numfiles
src/open_by_handle -u $testdir $numfiles

> +
> +echo "Silence is golden"
> +status=$?

$? is always 0 after echo. And any test failure could break golden
image, I think status can be set to 0 unconditionally.

Thanks,
Eryu

> +exit
> diff --git a/tests/generic/426.out b/tests/generic/426.out
> new file mode 100644
> index 0000000..777cbcd
> --- /dev/null
> +++ b/tests/generic/426.out
> @@ -0,0 +1,2 @@
> +QA output created by 426
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 6d6e4f6..f29009c 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -428,3 +428,4 @@
>  423 auto quick
>  424 auto quick
>  425 auto quick attr
> +426 auto quick exportfs
> -- 
> 2.7.4
> 
