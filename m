From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 2/5] overlay: test encode/decode overlay file handles
Date: Mon, 29 Jan 2018 22:39:40 +0800
Message-ID: <20180129143940.GW18267@eguan.usersys.redhat.com>
References: <1517131356-8048-1-git-send-email-amir73il@gmail.com>
 <1517131356-8048-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517131356-8048-3-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jan 28, 2018 at 11:22:33AM +0200, Amir Goldstein wrote:
> - Check encode/write/decode/read content of lower/upper file handles
> - Check encode/decode/write/read content of lower/upper file handles
> - Check decode/read of unlinked lower/upper files and directories
> - Check decode/read of lower file handles after copy up, link and unlink
> 
> This test requires and enables overlayfs NFS export support.
> NFS export support depends on and enables overlayfs index feature.
> 
> This test covers only encode/decode of file handles for overlayfs
> configuration of all layers on the same base fs.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks good to me overall, just two minor issues in comments.

> ---
>  tests/overlay/050     | 237 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/050.out |  31 +++++++
>  tests/overlay/group   |   1 +
>  3 files changed, 269 insertions(+)
>  create mode 100755 tests/overlay/050
>  create mode 100644 tests/overlay/050.out
> 
> diff --git a/tests/overlay/050 b/tests/overlay/050
> new file mode 100755
> index 0000000..ab20b1f
> --- /dev/null
> +++ b/tests/overlay/050
> @@ -0,0 +1,237 @@
> +#! /bin/bash
> +# FS QA Test No. 050
> +#
> +# Test encode/decode overlay file handles
> +#
> +# - Check encode/write/decode/read content of lower/upper file handles
> +# - Check encode/decode/write/read content of lower/upper file handles
> +# - Check decode/read of unlinked lower/upper files and directories
> +# - Check decode/read of lower file handles after copy up, link and unlink
> +#
> +# This test requires and enables overlayfs NFS export support.
> +# NFS export support depends on and enables overlayfs index feature.
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
> +_require_scratch_features index nfs_export
> +
> +# All overlay dirs are on scratch partition
> +lower=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +upper=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> +work=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> +
> +NUMFILES=1
> +
> +# Create test dir and empty test files
> +create_test_files()
> +{
> +	local dir=$1
> +
> +	mkdir -p $dir
> +	$here/src/open_by_handle -cp $dir $NUMFILES
> +}
> +
> +# Create hard links to test files
> +link_test_files()
> +{
> +	local dir=$1
> +
> +	$here/src/open_by_handle -l $dir $NUMFILES
> +}
> +
> +# Test encode/decode file handles on overlay mount
> +test_file_handles()
> +{
> +	local dir=$1
> +	local opt=$2
> +
> +	echo test_file_handles $dir $opt | _filter_scratch
> +	$here/src/open_by_handle $opt $dir $NUMFILES
> +}
> +
> +# Re-create lower/upper/work dirs
> +create_dirs()
> +{
> +	_scratch_mkfs
> +}
> +
> +# Mount an overlay on $SCRATCH_MNT with all layers on scratch partition
> +mount_dirs()
> +{
> +	_scratch_mount -o "index=on,nfs_export=on"
> +}
> +
> +# Unmount the overlay without unmounting base fs
> +unmount_dirs()
> +{
> +	$UMOUNT_PROG $SCRATCH_MNT
> +}
> +
> +# Check non-stale file handles of lower/upper files and verify
> +# that handle encoded before copy up is decoded to upper after
> +# copy up. Verify reading data from file open by file handle
> +# and verify access_at() with dirfd open by file handle.
> +create_dirs
> +create_test_files $upper/uppertestdir
> +create_test_files $lower/lowertestdir
> +mount_dirs
> +# Check encode/decode of upper regular file handles
> +test_file_handles $SCRATCH_MNT/uppertestdir
> +# Check encode/decode of upper dir file handle
> +test_file_handles $SCRATCH_MNT/uppertestdir -p
> +# Check encode/write/decode/read/write of upper file handles
> +test_file_handles $SCRATCH_MNT/uppertestdir -wrap
> +# Check encode/decode of lower regular file handles before copy up
> +test_file_handles $SCRATCH_MNT/lowertestdir
> +# Check encode/decode of lower dir file handles before copy up
> +test_file_handles $SCRATCH_MNT/lowertestdir -p
> +# Check encode/write/decode/read/write of lower file handles across copy up
> +test_file_handles $SCRATCH_MNT/lowertestdir -wrap
> +unmount_dirs
> +
> +# Check copy up after encode/decode of lower/upper files
> +# (copy up of disconnected dentry to index dir)
> +create_dirs
> +create_test_files $upper/uppertestdir
> +create_test_files $lower/lowertestdir
> +mount_dirs
> +# Check encode/decode/write/read of upper regular file handles
> +test_file_handles $SCRATCH_MNT/uppertestdir -a
> +test_file_handles $SCRATCH_MNT/uppertestdir -r
> +# Check encode/decode/write/read of lower regular file handles
> +test_file_handles $SCRATCH_MNT/lowertestdir -a
> +test_file_handles $SCRATCH_MNT/lowertestdir -r
> +unmount_dirs
> +
> +# Check non-stale handles to unlinked but open lower/upper files
> +create_dirs
> +create_test_files $upper/uppertestdir
> +create_test_files $upper/uppertestdir.rw
> +create_test_files $lower/lowertestdir
> +create_test_files $lower/lowertestdir.rw
> +mount_dirs
> +test_file_handles $SCRATCH_MNT/uppertestdir -dk
> +# Check encode/write/unlink/decode/read of upper regular file handles
> +test_file_handles $SCRATCH_MNT/uppertestdir.rw -rwdk
> +test_file_handles $SCRATCH_MNT/lowertestdir -dk
> +# Check encode/write/unlink/decode/read of lower file handles across copy up
> +test_file_handles $SCRATCH_MNT/lowertestdir.rw -rwdk
> +unmount_dirs
> +
> +# Check stale handles of unlinked lower/upper files (nlink = 1,0)
                                                       ^^^^^^^^^^^^^
Just nlink = 0? The nlink = 1 case was tested above not here, it's a
mismatch between comments and the actual code.

> +create_dirs
> +create_test_files $upper/uppertestdir
> +create_test_files $lower/lowertestdir
> +mount_dirs
> +# Check decode of upper file handles after unlink/rmdir (nlink == 0)
> +test_file_handles $SCRATCH_MNT/uppertestdir -dp
> +# Check decode of lower file handles after unlink/rmdir (nlink == 0)
> +test_file_handles $SCRATCH_MNT/lowertestdir -dp
> +unmount_dirs
> +
> +# Check non-stale file handles of linked lower/upper files (nlink = 1,2,1)

Same here, the first nlink = 1 case was tested above not here. I think
we can either add more comments or just drop the first "1" in comment.

Thanks,
Eryu

> +create_dirs
> +create_test_files $upper/uppertestdir
> +create_test_files $lower/lowertestdir
> +mount_dirs
> +# Check decode/read of upper file handles after link (nlink == 2)
> +test_file_handles $SCRATCH_MNT/uppertestdir -wlr
> +# Check decode/read of upper file handles after link + unlink (nlink == 1)
> +test_file_handles $SCRATCH_MNT/uppertestdir -ur
> +# Check decode/read of lower file handles after copy up + link (nlink == 2)
> +test_file_handles $SCRATCH_MNT/lowertestdir -wlr
> +# Check decode/read of lower file handles after copy up + link + unlink (nlink == 1)
> +test_file_handles $SCRATCH_MNT/lowertestdir -ur
> +unmount_dirs
> +
> +# Check non-stale file handles of linked lower/upper hardlinks (nlink = 2,1)
> +create_dirs
> +create_test_files $upper/uppertestdir
> +create_test_files $lower/lowertestdir
> +# Create lower/upper hardlinks
> +link_test_files $lower/lowertestdir
> +link_test_files $upper/uppertestdir
> +mount_dirs
> +# Check encode/decode of upper hardlink file handles (nlink == 2)
> +test_file_handles $SCRATCH_MNT/uppertestdir
> +# Check decode/read of upper hardlink file handles after unlink (nlink == 1)
> +test_file_handles $SCRATCH_MNT/uppertestdir -wur
> +# Check encode/decode of lower hardlink file handles before copy up (nlink == 2)
> +test_file_handles $SCRATCH_MNT/lowertestdir
> +# Check decode/read of lower hardlink file handles after copy up + unlink (nlink == 1)
> +test_file_handles $SCRATCH_MNT/lowertestdir -wur
> +unmount_dirs
> +
> +# Check stale file handles of unlinked lower/upper hardlinks (nlink = 2,0)
> +create_dirs
> +create_test_files $upper/uppertestdir
> +create_test_files $lower/lowertestdir
> +# Create lower/upper hardlinks
> +link_test_files $lower/lowertestdir
> +link_test_files $upper/uppertestdir
> +mount_dirs
> +# Check encode/decode of upper hardlink file handles (nlink == 2)
> +test_file_handles $SCRATCH_MNT/uppertestdir
> +# Check decode of upper hardlink file handles after 2*unlink (nlink == 0)
> +test_file_handles $SCRATCH_MNT/uppertestdir -d
> +# Check encode/decode of lower hardlink file handles before copy up (nlink == 2)
> +test_file_handles $SCRATCH_MNT/lowertestdir
> +# Check decode of lower hardlink file handles after copy up + 2*unlink (nlink == 0)
> +test_file_handles $SCRATCH_MNT/lowertestdir -d
> +unmount_dirs
> +
> +# Check non-stale file handles of lower/upper renamed files
> +create_dirs
> +create_test_files $upper/uppertestdir
> +create_test_files $lower/lowertestdir
> +mount_dirs
> +# Check decode/read of upper file handles after rename in same upper parent
> +test_file_handles $SCRATCH_MNT/uppertestdir -wmr
> +# Check decode/read of lower file handles after copy up + rename in same merge parent
> +test_file_handles $SCRATCH_MNT/lowertestdir -wmr
> +unmount_dirs
> +
> +status=0
> +exit
> diff --git a/tests/overlay/050.out b/tests/overlay/050.out
> new file mode 100644
> index 0000000..6e3d0be
> --- /dev/null
> +++ b/tests/overlay/050.out
> @@ -0,0 +1,31 @@
> +QA output created by 050
> +test_file_handles SCRATCH_MNT/uppertestdir
> +test_file_handles SCRATCH_MNT/uppertestdir -p
> +test_file_handles SCRATCH_MNT/uppertestdir -wrap
> +test_file_handles SCRATCH_MNT/lowertestdir
> +test_file_handles SCRATCH_MNT/lowertestdir -p
> +test_file_handles SCRATCH_MNT/lowertestdir -wrap
> +test_file_handles SCRATCH_MNT/uppertestdir -a
> +test_file_handles SCRATCH_MNT/uppertestdir -r
> +test_file_handles SCRATCH_MNT/lowertestdir -a
> +test_file_handles SCRATCH_MNT/lowertestdir -r
> +test_file_handles SCRATCH_MNT/uppertestdir -dk
> +test_file_handles SCRATCH_MNT/uppertestdir.rw -rwdk
> +test_file_handles SCRATCH_MNT/lowertestdir -dk
> +test_file_handles SCRATCH_MNT/lowertestdir.rw -rwdk
> +test_file_handles SCRATCH_MNT/uppertestdir -dp
> +test_file_handles SCRATCH_MNT/lowertestdir -dp
> +test_file_handles SCRATCH_MNT/uppertestdir -wlr
> +test_file_handles SCRATCH_MNT/uppertestdir -ur
> +test_file_handles SCRATCH_MNT/lowertestdir -wlr
> +test_file_handles SCRATCH_MNT/lowertestdir -ur
> +test_file_handles SCRATCH_MNT/uppertestdir
> +test_file_handles SCRATCH_MNT/uppertestdir -wur
> +test_file_handles SCRATCH_MNT/lowertestdir
> +test_file_handles SCRATCH_MNT/lowertestdir -wur
> +test_file_handles SCRATCH_MNT/uppertestdir
> +test_file_handles SCRATCH_MNT/uppertestdir -d
> +test_file_handles SCRATCH_MNT/lowertestdir
> +test_file_handles SCRATCH_MNT/lowertestdir -d
> +test_file_handles SCRATCH_MNT/uppertestdir -wmr
> +test_file_handles SCRATCH_MNT/lowertestdir -wmr
> diff --git a/tests/overlay/group b/tests/overlay/group
> index 4e138b9..18c26b7 100644
> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -50,3 +50,4 @@
>  047 auto quick copyup hardlink
>  048 auto quick copyup hardlink
>  049 auto quick copyup redirect
> +050 auto quick copyup hardlink exportfs
> -- 
> 2.7.4
> 
