From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7/7] overlay: test encode/decode of non-samefs overlay file handles
Date: Sun,  7 Jan 2018 20:07:25 +0200
Message-ID: <1515348445-1403-8-git-send-email-amir73il@gmail.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This is a variant of overlay file handles test for an overlayfs that
is composed of multiple lower layers not on the same underlying fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/051     | 311 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/051.out |  50 ++++++++
 tests/overlay/group   |   1 +
 3 files changed, 362 insertions(+)
 create mode 100755 tests/overlay/051
 create mode 100644 tests/overlay/051.out

diff --git a/tests/overlay/051 b/tests/overlay/051
new file mode 100755
index 0000000..6f11e9e
--- /dev/null
+++ b/tests/overlay/051
@@ -0,0 +1,311 @@
+#! /bin/bash
+# FS QA Test No. 051
+#
+# Test encode/decode overlay file handles
+#
+# This is a variant of overlay file handles test for an overlayfs that is
+# composed of multiple lower layers not on the same underlying fs.
+#
+# - Check encode/write/decode/read content of lower/upper file handles
+# - Check encode/decode/write/read content of lower/upper file handles
+# - Check decode/read of unlinked lower/upper files and directories
+# - Check decode/read of lower file handles after copy up, link and unlink
+# - Check decode/read of lower file handles after rename of parent and self
+#
+# This test does not cover connectable file handles of non-directories,
+# because name_to_handle_at() syscall does not support requesting connectable
+# file handles.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
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
+	# Unmount the non-samefs overlay mount
+	$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
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
+_require_test
+_require_scratch
+# _require_exportfs already requires open_by_handle, but let's not count on it
+_require_test_program "open_by_handle"
+_require_exportfs
+
+# Lower is on test partition
+lower=$OVL_BASE_TEST_DIR/$OVL_LOWER-$seq
+# Upper/work are on scratch partition
+middle=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upper=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+work=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
+lowerdir=$lower/lowertestdir
+upperdir=$upper/uppertestdir
+lowertestdir=$SCRATCH_MNT/lowertestdir
+uppertestdir=$SCRATCH_MNT/uppertestdir
+NUMFILES=1
+
+# Create test dir and empty test files
+create_test_files()
+{
+	local dir=$1
+	local opt=$2
+
+	mkdir -p $dir
+	src/open_by_handle -cp $opt $dir $NUMFILES
+}
+
+# Test encode/decode file handles on overlay mount
+test_file_handles()
+{
+	local dir=$1
+	shift
+
+	echo test_file_handles $dir $* | _filter_scratch | _filter_ovl_dirs | \
+				sed -e "s,$tmp\.,,g"
+	$here/src/open_by_handle $* $dir $NUMFILES
+}
+
+# Re-create lower/upper/work dirs
+create_dirs()
+{
+	# Create lower dir on test partition
+	rm -rf $lower
+	mkdir $lower
+
+	# Create upper/work dirs on scratch partition
+	_scratch_mkfs
+}
+
+# Mount an overlay on $SCRATCH_MNT with lower layer on test partition
+# and middle and upper layer on scratch partition
+mount_dirs()
+{
+	_overlay_mount_dirs $middle:$lower $upper $work \
+		$OVERLAY_MOUNT_OPTIONS overlay $SCRATCH_MNT
+}
+
+# Unmount & check the non samefs overlay
+unmount_dirs()
+{
+	$UMOUNT_PROG $SCRATCH_MNT
+	_overlay_check_dirs $lower $upper $work
+}
+
+# Check non-stale file handles of lower/upper files and verify
+# that handle decoded before copy up is encoded to upper after
+# copy up. Verify reading data from file open by file handle
+# and verify access_at() with dirfd open by file handle.
+create_dirs
+create_test_files $upperdir
+create_test_files $lowerdir
+mount_dirs
+# Check encode/decode of upper regular file handles
+test_file_handles $uppertestdir
+# Check encode/decode of upper dir file handle
+test_file_handles $uppertestdir -p
+# Check encode/write/decode/read/write of upper file handles
+test_file_handles $uppertestdir -wrap
+# Check encode/decode of lower regular file handles before copy up
+test_file_handles $lowertestdir
+# Check encode/decode of lower dir file handles before copy up
+test_file_handles $lowertestdir -p
+# Check encode/write/decode/read/write of lower file handles across copy up
+test_file_handles $lowertestdir -wrap
+unmount_dirs
+
+# Check copy up after encode/decode of lower/upper files
+# (copy up of disconnected dentry to index dir)
+create_dirs
+create_test_files $upperdir
+create_test_files $lowerdir
+mount_dirs
+# Check encode/decode/write/read of upper regular file handles
+test_file_handles $uppertestdir -a
+test_file_handles $uppertestdir -r
+# Check encode/decode/write/read of lower regular file handles
+test_file_handles $lowertestdir -a
+test_file_handles $lowertestdir -r
+unmount_dirs
+
+# Check non-stale handles to unlinked but open lower/upper files
+create_dirs
+create_test_files $upperdir
+create_test_files $upperdir.rw
+create_test_files $lowerdir
+create_test_files $lowerdir.rw
+mount_dirs
+test_file_handles $uppertestdir -dk
+# Check encode/write/unlink/decode/read of upper regular file handles
+test_file_handles $uppertestdir.rw -rwdk
+test_file_handles $lowertestdir -dk
+# Check encode/write/unlink/decode/read of lower file handles across copy up
+test_file_handles $lowertestdir.rw -rwdk
+unmount_dirs
+
+# Check stale handles of unlinked lower/upper files (nlink = 1,0)
+create_dirs
+create_test_files $upperdir
+create_test_files $lowerdir
+mount_dirs
+# Check decode of upper file handles after unlink/rmdir (nlink == 0)
+test_file_handles $uppertestdir -dp
+# Check decode of lower file handles after unlink/rmdir (nlink == 0)
+test_file_handles $lowertestdir -dp
+unmount_dirs
+
+# Check non-stale file handles of linked lower/upper files (nlink = 1,2,1)
+create_dirs
+create_test_files $upperdir
+create_test_files $lowerdir
+mount_dirs
+# Check encode/decode of upper file handles (nlink == 1)
+test_file_handles $uppertestdir
+# Check decode/read of upper file handles after link (nlink == 2)
+test_file_handles $uppertestdir -wlr
+# Check decode/read of upper file handles after link + unlink (nlink == 1)
+test_file_handles $uppertestdir -ur
+# Check encode/decode of lower file handles before copy up (nlink == 1)
+test_file_handles $lowertestdir
+# Check decode/read of lower file handles after copy up + link (nlink == 2)
+test_file_handles $lowertestdir -wlr
+# Check decode/read of lower file handles after copy up + link + unlink (nlink == 1)
+test_file_handles $lowertestdir -ur
+unmount_dirs
+
+# Check non-stale file handles of linked lower/upper hardlinks (nlink = 2,1)
+create_dirs
+create_test_files $upperdir
+create_test_files $lowerdir
+# Create lower/upper hardlinks
+test_file_handles $lowerdir -l >/dev/null
+test_file_handles $upperdir -l >/dev/null
+mount_dirs
+# Check encode/decode of upper hardlink file handles (nlink == 2)
+test_file_handles $uppertestdir
+# Check decode/read of upper hardlink file handles after unlink (nlink == 1)
+test_file_handles $uppertestdir -wur
+# Check encode/decode of lower hardlink file handles before copy up (nlink == 2)
+test_file_handles $lowertestdir
+# Check decode/read of lower hardlink file handles after copy up + unlink (nlink == 1)
+test_file_handles $lowertestdir -wur
+unmount_dirs
+
+# Check stale file handles of unlinked lower/upper hardlinks (nlink = 2,0)
+create_dirs
+create_test_files $upperdir
+create_test_files $lowerdir
+# Create lower/upper hardlinks
+test_file_handles $lowerdir -l >/dev/null
+test_file_handles $upperdir -l >/dev/null
+mount_dirs
+# Check encode/decode of upper hardlink file handles (nlink == 2)
+test_file_handles $uppertestdir
+# Check decode of upper hardlink file handles after 2*unlink (nlink == 0)
+test_file_handles $uppertestdir -d
+# Check encode/decode of lower hardlink file handles before copy up (nlink == 2)
+test_file_handles $lowertestdir
+# Check decode of lower hardlink file handles after copy up + 2*unlink (nlink == 0)
+test_file_handles $lowertestdir -d
+unmount_dirs
+
+# Check non-stale file handles of lower/upper renamed files
+create_dirs
+create_test_files $upperdir
+create_test_files $lowerdir
+mount_dirs
+# Check decode/read of upper file handles after rename in same upper parent
+test_file_handles $uppertestdir -wmr
+# Check decode/read of lower file handles after copy up + rename in same merge parent
+test_file_handles $lowertestdir -wmr
+unmount_dirs
+
+# Check non-stale file handles of lower/upper moved files
+create_dirs
+create_test_files $upperdir -w
+create_test_files $lowerdir -w
+mkdir -p $lowerdir.lo $lowerdir.up $upperdir.lo $upperdir.up
+mount_dirs
+# Check encode/decode/read of lower/upper file handles after move to new upper testdir
+test_file_handles $uppertestdir -o $tmp.upper_file_handles
+test_file_handles $lowertestdir -o $tmp.lower_file_handles
+mv $uppertestdir/* $uppertestdir.up/
+mv $lowertestdir/* $uppertestdir.lo/
+# Check open and read from stored file handles
+test_file_handles $SCRATCH_MNT -r -i $tmp.upper_file_handles
+test_file_handles $SCRATCH_MNT -r -i $tmp.lower_file_handles
+# Check encode/decode/read of lower/upper file handles after move to new merge testdir
+test_file_handles $uppertestdir.up -o $tmp.upper_file_handles
+test_file_handles $uppertestdir.lo -o $tmp.lower_file_handles
+mv $uppertestdir.up/* $lowertestdir.up/
+mv $uppertestdir.lo/* $lowertestdir.lo/
+# Check open and read from stored file handles
+test_file_handles $SCRATCH_MNT -r -i $tmp.upper_file_handles
+test_file_handles $SCRATCH_MNT -r -i $tmp.lower_file_handles
+unmount_dirs
+
+# Check non-stale file handles of lower/upper renamed dirs
+create_dirs
+create_test_files $upperdir -w
+create_test_files $lowerdir -w
+create_test_files $upperdir/subdir -w
+create_test_files $lowerdir/subdir -w
+mount_dirs
+# Check encode/decode/read of lower/upper file handles after rename of testdir
+test_file_handles $uppertestdir -p -o $tmp.upper_file_handles
+test_file_handles $lowertestdir -p -o $tmp.lower_file_handles
+# Check encode/decode/read of lower/upper file handles after rename of testdir's parent
+test_file_handles $uppertestdir/subdir -p -o $tmp.upper_subdir_file_handles
+test_file_handles $lowertestdir/subdir -p -o $tmp.lower_subdir_file_handles
+# Rename pure upper dir
+mv $uppertestdir $uppertestdir.new/
+# Copy up lower dir, index and rename
+mv $lowertestdir $lowertestdir.new/
+# Check open, read and readdir from stored file handles
+# (testdir argument is the mount point and NOT the dir
+#  we are trying to open by stored file handle)
+test_file_handles $SCRATCH_MNT -rp -i $tmp.upper_file_handles
+test_file_handles $SCRATCH_MNT -rp -i $tmp.lower_file_handles
+test_file_handles $SCRATCH_MNT -rp -i $tmp.upper_subdir_file_handles
+test_file_handles $SCRATCH_MNT -rp -i $tmp.lower_subdir_file_handles
+# Retry decoding lower subdir file handle when indexed testdir is in dcache
+# (providing renamed testdir argument pins the indexed testdir to dcache)
+test_file_handles $lowertestdir.new -rp -i $tmp.lower_subdir_file_handles
+unmount_dirs
+
+status=0
+exit
diff --git a/tests/overlay/051.out b/tests/overlay/051.out
new file mode 100644
index 0000000..505e37e
--- /dev/null
+++ b/tests/overlay/051.out
@@ -0,0 +1,50 @@
+QA output created by 051
+test_file_handles SCRATCH_MNT/uppertestdir
+test_file_handles SCRATCH_MNT/uppertestdir -p
+test_file_handles SCRATCH_MNT/uppertestdir -wrap
+test_file_handles SCRATCH_MNT/lowertestdir
+test_file_handles SCRATCH_MNT/lowertestdir -p
+test_file_handles SCRATCH_MNT/lowertestdir -wrap
+test_file_handles SCRATCH_MNT/uppertestdir -a
+test_file_handles SCRATCH_MNT/uppertestdir -r
+test_file_handles SCRATCH_MNT/lowertestdir -a
+test_file_handles SCRATCH_MNT/lowertestdir -r
+test_file_handles SCRATCH_MNT/uppertestdir -dk
+test_file_handles SCRATCH_MNT/uppertestdir.rw -rwdk
+test_file_handles SCRATCH_MNT/lowertestdir -dk
+test_file_handles SCRATCH_MNT/lowertestdir.rw -rwdk
+test_file_handles SCRATCH_MNT/uppertestdir -dp
+test_file_handles SCRATCH_MNT/lowertestdir -dp
+test_file_handles SCRATCH_MNT/uppertestdir
+test_file_handles SCRATCH_MNT/uppertestdir -wlr
+test_file_handles SCRATCH_MNT/uppertestdir -ur
+test_file_handles SCRATCH_MNT/lowertestdir
+test_file_handles SCRATCH_MNT/lowertestdir -wlr
+test_file_handles SCRATCH_MNT/lowertestdir -ur
+test_file_handles SCRATCH_MNT/uppertestdir
+test_file_handles SCRATCH_MNT/uppertestdir -wur
+test_file_handles SCRATCH_MNT/lowertestdir
+test_file_handles SCRATCH_MNT/lowertestdir -wur
+test_file_handles SCRATCH_MNT/uppertestdir
+test_file_handles SCRATCH_MNT/uppertestdir -d
+test_file_handles SCRATCH_MNT/lowertestdir
+test_file_handles SCRATCH_MNT/lowertestdir -d
+test_file_handles SCRATCH_MNT/uppertestdir -wmr
+test_file_handles SCRATCH_MNT/lowertestdir -wmr
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
diff --git a/tests/overlay/group b/tests/overlay/group
index 6cb3763..380a382 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -50,3 +50,4 @@
 047 auto quick copyup hardlink
 048 auto quick copyup hardlink
 050 auto quick copyup hardlink exportfs
+051 auto quick copyup hardlink exportfs nonsamefs
-- 
2.7.4
