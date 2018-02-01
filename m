From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/2] overlay: test overlay file handles of lower dir with
 non-indexed ancestor
Date: Thu, 1 Feb 2018 15:27:19 +0800
Message-ID: <20180201072719.GI18267@eguan.usersys.redhat.com>
References: <1517399095-28512-1-git-send-email-amir73il@gmail.com>
 <1517399095-28512-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751713AbeBAH1V (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Feb 2018 02:27:21 -0500
Content-Disposition: inline
In-Reply-To: <1517399095-28512-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jan 31, 2018 at 01:44:54PM +0200, Amir Goldstein wrote:
> Overlayfs with nfs_export enabled, indexes all directories on copy up.
> Directory index is requires for decoding lower directory file handles
> in case ancestors have been renamed.
> 
> When enabling nfs_export on an overlay that already has non-indexed
> merge dirs, the possibility of non-indexed ancestor rename requires
> special handling when encoding lower directory file handles.
> 
> - Check encode/decode/read file handles of non-indexed merge dir
> - Check encode/decode/read file handles of dir with non-indexed parent
> - Check encode/decode/read file handles of dir with non-indexed grandparent
> - Check decode/read of file handles after rename of non-indexed merge dir
> - Check decode/read of file handles after rename of non-indexed parent
> - Check decode/read of file handles after rename of non-indexed grandparent
> 
> This test requires and enables overlayfs NFS export support and merge
> dir rename support (redirect_dir).
> NFS export support depends on and requires overlayfs index feature.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/054     | 162 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/054.out |  11 ++++
>  tests/overlay/group   |   1 +
>  3 files changed, 174 insertions(+)
>  create mode 100755 tests/overlay/054
>  create mode 100644 tests/overlay/054.out
> 
> diff --git a/tests/overlay/054 b/tests/overlay/054
> new file mode 100755
> index 0000000..c788460
> --- /dev/null
> +++ b/tests/overlay/054
> @@ -0,0 +1,162 @@
> +#! /bin/bash
> +# FS QA Test No. 054
> +#
> +# Test encode/decode overlay file handle of dir with non-indexed ancestor
> +#
> +# Overlayfs with nfs_export enabled, indexes all directories on copy up.
> +# Directory index is requires for decoding lower directory file handles
> +# in case ancestors have been renamed.
> +#
> +# When enabling nfs_export on an overlay that already has non-indexed
> +# merge dirs, the possibility of non-indexed ancestor rename requires
> +# special handling when encoding lower directory file handles.
> +#
> +# - Check encode/decode/read file handles of non-indexed merge dir
> +# - Check encode/decode/read file handles of dir with non-indexed parent
> +# - Check encode/decode/read file handles of dir with non-indexed grandparent
> +# - Check decode/read of file handles after rename of non-indexed merge dir
> +# - Check decode/read of file handles after rename of non-indexed parent
> +# - Check decode/read of file handles after rename of non-indexed grandparent
> +#
> +# This test requires and enables overlayfs NFS export support and merge
> +# dir rename support (redirect_dir).
> +# NFS export support depends on and requires overlayfs index feature.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2018 CTERA Networks. All Rights Reserved.
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
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +_supported_fs overlay
> +_supported_os Linux
> +_require_scratch
> +_require_test_program "open_by_handle"
> +# We need to require all features together, because nfs_export cannot
> +# be enabled when index is disabled
> +_require_scratch_overlay_features index nfs_export redirect_dir
> +
> +# All overlay dirs are on scratch partition
> +lower=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +middle=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER.2

The middle dir doesn't seem to be used in this test. Can I just remove
it on commit?

Thanks,
Eryu

> +upper=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +work=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> +
> +NUMFILES=1
> +
> +# Create test dir and empty test files
> +create_test_files()
> +{
> +	local dir=$1
> +	local opt=$2
> +
> +	mkdir -p $dir
> +	$here/src/open_by_handle -cp $opt $dir $NUMFILES
> +}
> +
> +# Test encode/decode file handles on overlay mount
> +test_file_handles()
> +{
> +	local dir=$1
> +	shift
> +
> +	echo test_file_handles $dir $* | _filter_scratch | \
> +				sed -e "s,$tmp\.,,g"
> +	$here/src/open_by_handle $* $dir $NUMFILES
> +}
> +
> +# Re-create lower/middle/upper/work dirs
> +create_dirs()
> +{
> +	_scratch_mkfs
> +	mkdir -p $middle
> +}
> +
> +# Mount an overlay on $SCRATCH_MNT with all layers on scratch partition
> +mount_dirs()
> +{
> +	_scratch_mount -o "index=on,nfs_export=on,redirect_dir=on"
> +}
> +
> +# Unmount the overlay without unmounting base fs
> +unmount_dirs()
> +{
> +	$UMOUNT_PROG $SCRATCH_MNT
> +}
> +
> +# Check encode/decode/read file handles of dir with non-indexed ancestor
> +create_dirs
> +create_test_files $lower/merged -w
> +create_test_files $lower/merged/dir -w
> +create_test_files $lower/merged/dir/subdir -w
> +create_test_files $lower/merged/parent/child -w
> +# Create non-indexed merge dir
> +mkdir $upper/merged
> +mount_dirs
> +# Check encode/decode/read file handles of non-indexed merge dir
> +# This is expected to encode an upper file handle
> +test_file_handles $SCRATCH_MNT/merged -p -o $tmp.merged_file_handles
> +# Check encode/decode/read file handles of dir with non-indexed parent
> +# This is expected to copy up merged/dir and encode an upper file handle
> +test_file_handles $SCRATCH_MNT/merged/dir -p -o $tmp.dir_file_handles
> +test -d $upper/merged/dir || echo "merged/dir not copied up"
> +# Check encode/decode/read file handles of dir with non-indexed grandparent
> +# This is expected to encode a lower file handle
> +test_file_handles $SCRATCH_MNT/merged/dir/subdir -p -o $tmp.subdir_file_handles
> +test -d $upper/merged/dir/subdir && echo "merged/dir/subdir unexpected copy up"
> +# This is expected to copy up parent and encode a lower file handle
> +test_file_handles $SCRATCH_MNT/merged/parent/child -p -o $tmp.child_file_handles
> +test -d $upper/merged/parent || echo "merged/parent not copied up"
> +test -d $upper/merged/parent/child && echo "merged/parent/child unexpected copy up"
> +
> +# Rename non-indexed merge dir
> +mv $SCRATCH_MNT/merged $SCRATCH_MNT/merged.new/
> +# Check open, read and readdir from stored file handles
> +# (testdir argument is the mount point and NOT the dir
> +#  we are trying to open by stored file handle)
> +test_file_handles $SCRATCH_MNT -rp -i $tmp.merged_file_handles
> +test_file_handles $SCRATCH_MNT -rp -i $tmp.dir_file_handles
> +test_file_handles $SCRATCH_MNT -rp -i $tmp.subdir_file_handles
> +test_file_handles $SCRATCH_MNT -rp -i $tmp.child_file_handles
> +# Retry decoding lower subdir file handles when indexed ancestor is in dcache
> +# (providing the ancestor dir argument pins the ancestor to dcache)
> +test_file_handles $SCRATCH_MNT/merged.new/dir -rp -i $tmp.subdir_file_handles
> +test_file_handles $SCRATCH_MNT/merged.new/parent -rp -i $tmp.child_file_handles
> +unmount_dirs
> +
> +status=0
> +exit
> diff --git a/tests/overlay/054.out b/tests/overlay/054.out
> new file mode 100644
> index 0000000..dd8fddf
> --- /dev/null
> +++ b/tests/overlay/054.out
> @@ -0,0 +1,11 @@
> +QA output created by 054
> +test_file_handles SCRATCH_MNT/merged -p -o merged_file_handles
> +test_file_handles SCRATCH_MNT/merged/dir -p -o dir_file_handles
> +test_file_handles SCRATCH_MNT/merged/dir/subdir -p -o subdir_file_handles
> +test_file_handles SCRATCH_MNT/merged/parent/child -p -o child_file_handles
> +test_file_handles SCRATCH_MNT -rp -i merged_file_handles
> +test_file_handles SCRATCH_MNT -rp -i dir_file_handles
> +test_file_handles SCRATCH_MNT -rp -i subdir_file_handles
> +test_file_handles SCRATCH_MNT -rp -i child_file_handles
> +test_file_handles SCRATCH_MNT/merged.new/dir -rp -i subdir_file_handles
> +test_file_handles SCRATCH_MNT/merged.new/parent -rp -i child_file_handles
> diff --git a/tests/overlay/group b/tests/overlay/group
> index ec0b711..4326a27 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -54,3 +54,4 @@
>  051 auto quick copyup hardlink exportfs nonsamefs
>  052 auto quick copyup redirect exportfs
>  053 auto quick copyup redirect exportfs nonsamefs
> +054 auto quick copyup redirect exportfs
> -- 
> 2.7.4
> 
