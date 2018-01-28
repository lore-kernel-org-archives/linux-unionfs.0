From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 4/5] overlay: test encode/decode overlay file handles with renames
Date: Sun, 28 Jan 2018 11:22:35 +0200
Message-ID: <1517131356-8048-5-git-send-email-amir73il@gmail.com>
References: <1517131356-8048-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1517131356-8048-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

- Check decode/read of file handles after rename of parent
- Check decode/read of file handles after rename of grandparent
- Check decode/read of file handles after move to new parent
- Check encode/decode/read of file handles in non-upper overlay

This test requires and enables overlayfs NFS export support and merge
dir rename support (redirect_dir).
NFS export support depends on and enables overlayfs index feature.

This test covers only encode/decode of file handles for overlayfs
configuration of all layers on the same base fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/052     | 182 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/052.out |  22 ++++++
 tests/overlay/group   |   1 +
 3 files changed, 205 insertions(+)
 create mode 100755 tests/overlay/052
 create mode 100644 tests/overlay/052.out

diff --git a/tests/overlay/052 b/tests/overlay/052
new file mode 100755
index 0000000..148d35b
--- /dev/null
+++ b/tests/overlay/052
@@ -0,0 +1,182 @@
+#! /bin/bash
+# FS QA Test No. 052
+#
+# Test encode/decode overlay file handles with renames
+#
+# - Check decode/read of file handles after rename of parent
+# - Check decode/read of file handles after rename of grandparent
+# - Check decode/read of file handles after move to new parent
+# - Check encode/decode/read of file handles in non-upper overlay
+#
+# This test requires and enables overlayfs NFS export support and merge
+# dir rename support (redirect_dir).
+# NFS export support depends on and enables overlayfs index feature.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2018 CTERA Networks. All Rights Reserved.
+# Author: Amir Goldstein <amir73il@gmail.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_test_program "open_by_handle"
+_require_scratch_features index nfs_export redirect_dir
+
+# All overlay dirs are on scratch partition
+lower=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+middle=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER.2
+upper=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+work=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
+NUMFILES=1
+
+# Create test dir and empty test files
+create_test_files()
+{
+	local dir=$1
+	local opt=$2
+
+	mkdir -p $dir
+	$here/src/open_by_handle -cp $opt $dir $NUMFILES
+}
+
+# Test encode/decode file handles on overlay mount
+test_file_handles()
+{
+	local dir=$1
+	shift
+
+	echo test_file_handles $dir $* | _filter_scratch | \
+				sed -e "s,$tmp\.,,g"
+	$here/src/open_by_handle $* $dir $NUMFILES
+}
+
+# Re-create lower/middle/upper/work dirs
+create_dirs()
+{
+	_scratch_mkfs
+	mkdir -p $middle
+}
+
+# Mount an overlay on $SCRATCH_MNT with all layers on scratch partition
+mount_dirs()
+{
+	_scratch_mount -o "index=on,nfs_export=on,redirect_dir=on"
+}
+
+# Unmount the overlay without unmounting base fs
+unmount_dirs()
+{
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+# Check non-stale file handles of lower/upper moved files
+create_dirs
+create_test_files $upper/uppertestdir -w
+create_test_files $lower/lowertestdir -w
+mkdir -p $lower/lowertestdir.lo $lower/lowertestdir.up $upper/uppertestdir.lo $upper/uppertestdir.up
+mount_dirs
+# Check encode/decode/read of lower/upper file handles after move to new upper testdir
+test_file_handles $SCRATCH_MNT/uppertestdir -o $tmp.upper_file_handles
+test_file_handles $SCRATCH_MNT/lowertestdir -o $tmp.lower_file_handles
+mv $SCRATCH_MNT/uppertestdir/* $SCRATCH_MNT/uppertestdir.up/
+mv $SCRATCH_MNT/lowertestdir/* $SCRATCH_MNT/uppertestdir.lo/
+# Check open and read from stored file handles
+test_file_handles $SCRATCH_MNT -r -i $tmp.upper_file_handles
+test_file_handles $SCRATCH_MNT -r -i $tmp.lower_file_handles
+# Check encode/decode/read of lower/upper file handles after move to new merge testdir
+test_file_handles $SCRATCH_MNT/uppertestdir.up -o $tmp.upper_file_handles
+test_file_handles $SCRATCH_MNT/uppertestdir.lo -o $tmp.lower_file_handles
+mv $SCRATCH_MNT/uppertestdir.up/* $SCRATCH_MNT/lowertestdir.up/
+mv $SCRATCH_MNT/uppertestdir.lo/* $SCRATCH_MNT/lowertestdir.lo/
+# Check open and read from stored file handles
+test_file_handles $SCRATCH_MNT -r -i $tmp.upper_file_handles
+test_file_handles $SCRATCH_MNT -r -i $tmp.lower_file_handles
+unmount_dirs
+
+# Check non-stale file handles of lower/upper renamed dirs
+create_dirs
+create_test_files $upper/uppertestdir -w
+create_test_files $lower/lowertestdir -w
+create_test_files $upper/uppertestdir/subdir -w
+create_test_files $lower/lowertestdir/subdir -w
+mount_dirs
+# Check encode/decode/read of lower/upper file handles after rename of testdir
+test_file_handles $SCRATCH_MNT/uppertestdir -p -o $tmp.upper_file_handles
+test_file_handles $SCRATCH_MNT/lowertestdir -p -o $tmp.lower_file_handles
+# Check encode/decode/read of lower/upper file handles after rename of testdir's parent
+test_file_handles $SCRATCH_MNT/uppertestdir/subdir -p -o $tmp.upper_subdir_file_handles
+test_file_handles $SCRATCH_MNT/lowertestdir/subdir -p -o $tmp.lower_subdir_file_handles
+# Rename pure upper dir
+mv $SCRATCH_MNT/uppertestdir $SCRATCH_MNT/uppertestdir.new/
+# Copy up lower dir, index and rename
+mv $SCRATCH_MNT/lowertestdir $SCRATCH_MNT/lowertestdir.new/
+# Check open, read and readdir from stored file handles
+# (testdir argument is the mount point and NOT the dir
+#  we are trying to open by stored file handle)
+test_file_handles $SCRATCH_MNT -rp -i $tmp.upper_file_handles
+test_file_handles $SCRATCH_MNT -rp -i $tmp.lower_file_handles
+test_file_handles $SCRATCH_MNT -rp -i $tmp.upper_subdir_file_handles
+test_file_handles $SCRATCH_MNT -rp -i $tmp.lower_subdir_file_handles
+# Retry decoding lower subdir file handle when indexed testdir is in dcache
+# (providing renamed testdir argument pins the indexed testdir to dcache)
+test_file_handles $SCRATCH_MNT/lowertestdir.new -rp -i $tmp.lower_subdir_file_handles
+unmount_dirs
+
+# Check encode/decode/read of lower file handles on lower layers only r/o overlay.
+# For non-upper overlay mount, nfs_export requires disabling redirect_dir.
+$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+			-o ro,redirect_dir=nofollow,nfs_export=on,lowerdir=$middle:$lower
+test_file_handles $SCRATCH_MNT/lowertestdir -rp
+test_file_handles $SCRATCH_MNT/lowertestdir/subdir -rp
+unmount_dirs
+
+# Check encode/decode/read of lower file handles on lower layers only r/o overlay
+# with non-indexed redirects from top lower layer to bottom lower layer.
+# Overlay lookup cannot follow the redirect from $upper/lowertestdir.new to
+# $lower/lowertestdir. Instead, we mount an overlay subtree rooted at these
+# directories.
+$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+		-o ro,redirect_dir=nofollow,nfs_export=on,lowerdir=$upper/lowertestdir.new:$lower/lowertestdir
+test_file_handles $SCRATCH_MNT -r
+test_file_handles $SCRATCH_MNT/subdir -rp
+unmount_dirs
+
+status=0
+exit
diff --git a/tests/overlay/052.out b/tests/overlay/052.out
new file mode 100644
index 0000000..f9f4ff7
--- /dev/null
+++ b/tests/overlay/052.out
@@ -0,0 +1,22 @@
+QA output created by 052
+test_file_handles SCRATCH_MNT/uppertestdir -o upper_file_handles
+test_file_handles SCRATCH_MNT/lowertestdir -o lower_file_handles
+test_file_handles SCRATCH_MNT -r -i upper_file_handles
+test_file_handles SCRATCH_MNT -r -i lower_file_handles
+test_file_handles SCRATCH_MNT/uppertestdir.up -o upper_file_handles
+test_file_handles SCRATCH_MNT/uppertestdir.lo -o lower_file_handles
+test_file_handles SCRATCH_MNT -r -i upper_file_handles
+test_file_handles SCRATCH_MNT -r -i lower_file_handles
+test_file_handles SCRATCH_MNT/uppertestdir -p -o upper_file_handles
+test_file_handles SCRATCH_MNT/lowertestdir -p -o lower_file_handles
+test_file_handles SCRATCH_MNT/uppertestdir/subdir -p -o upper_subdir_file_handles
+test_file_handles SCRATCH_MNT/lowertestdir/subdir -p -o lower_subdir_file_handles
+test_file_handles SCRATCH_MNT -rp -i upper_file_handles
+test_file_handles SCRATCH_MNT -rp -i lower_file_handles
+test_file_handles SCRATCH_MNT -rp -i upper_subdir_file_handles
+test_file_handles SCRATCH_MNT -rp -i lower_subdir_file_handles
+test_file_handles SCRATCH_MNT/lowertestdir.new -rp -i lower_subdir_file_handles
+test_file_handles SCRATCH_MNT/lowertestdir -rp
+test_file_handles SCRATCH_MNT/lowertestdir/subdir -rp
+test_file_handles SCRATCH_MNT -r
+test_file_handles SCRATCH_MNT/subdir -rp
diff --git a/tests/overlay/group b/tests/overlay/group
index 9b00e30..07dcf52 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -52,3 +52,4 @@
 049 auto quick copyup redirect
 050 auto quick copyup hardlink exportfs
 051 auto quick copyup hardlink exportfs nonsamefs
+052 auto quick copyup redirect exportfs
-- 
2.7.4
