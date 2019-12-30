Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 4/5] overlay: test constant ino with nested overlay over samefs lower
Date: Mon, 30 Dec 2019 16:14:22 +0200
Message-Id: <20191230141423.31695-5-amir73il@gmail.com>
In-Reply-To: <20191230141423.31695-1-amir73il@gmail.com>
References: <20191230141423.31695-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@poochiereds.net>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Also test that d_ino of readdir entries and i_ino from /proc/locks are
consistent with st_ino and that inode numbers persist after rename to
new parent, drop caches and mount cycle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/070     | 222 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/070.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 225 insertions(+)
 create mode 100755 tests/overlay/070
 create mode 100644 tests/overlay/070.out

diff --git a/tests/overlay/070 b/tests/overlay/070
new file mode 100755
index 00000000..5782ecdd
--- /dev/null
+++ b/tests/overlay/070
@@ -0,0 +1,222 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 CTERA Networks. All Rights Reserved.
+#
+# FSQA Test No. 070
+#
+# This is a variant of overlay/017 to test constant st_ino numbers for
+# nested overlay setup, where all layers of both overlays are on the
+# same fs.
+#
+# This simple test demonstrates a known issue with overlayfs:
+# - stat file A shows inode number X
+# - modify A to trigger copy up
+# - stat file A shows inode number Y != X
+#
+# Also test that d_ino of readdir entries and i_ino from /proc/locks are
+# consistent with st_ino and that inode numbers persist after rename to
+# new parent, drop caches and mount cycle.
+#
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
+	# Unmount the nested overlay mount
+	$UMOUNT_PROG $mnt2 2>/dev/null
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch_nocheck
+_require_test_program "af_unix"
+_require_test_program "t_dir_type"
+# We need to require all features together, because nfs_export cannot
+# be enabled when index is disabled
+_require_scratch_overlay_features index nfs_export redirect_dir
+
+lower=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upper=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+work=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+# Lower dir of nested overlay is the scratch overlay mount at SCRATCH_MNT
+upper2=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER.2
+work2=$OVL_BASE_SCRATCH_MNT/$OVL_WORK.2
+mnt2=$OVL_BASE_SCRATCH_MNT/$OVL_MNT.2
+
+lowerdir=$lower/lowertestdir
+upperdir=$upper/uppertestdir
+lowertestdir=$mnt2/lowertestdir
+uppertestdir=$mnt2/uppertestdir
+
+create_dirs()
+{
+	# Create the underlying overlay dirs
+	_scratch_mkfs
+
+	# Create the nested overlay upper dirs
+	mkdir -p $upper2 $work2 $mnt2
+}
+
+# Mount a nested overlay with $SCRATCH_MNT as lower layer
+mount_dirs()
+{
+	# Mount the underlying overlay with file handle support
+	_scratch_mount -o "index=on,nfs_export=on"
+
+	# Mount the nested overlay
+	# Enable redirect_dir for renaming a merge directory.
+	# Enabling xino in this test requires that base filesystem inode numbers will
+	# not use bit 63 in inode number of the test files, because bit 63 is used by
+	# overlayfs to indicate the layer. Let's just assume that this is true for all
+	# tested filesystems and if we are wrong, the test may fail.
+	_overlay_mount_dirs $SCRATCH_MNT $upper2 $work2 overlay2 $mnt2 \
+		-o "redirect_dir=on,index=on,xino=on" || \
+		_notrun "cannot mount nested overlay with xino=on option"
+	_fs_options overlay2 | grep -q "xino=on" || \
+		_notrun "cannot enable xino feature on nested overlay"
+}
+
+# Unmount the nested overlay mount and check underlying overlay layers
+unmount_dirs()
+{
+	# unmount & check nested overlay
+	$UMOUNT_PROG $mnt2
+	_overlay_check_dirs $SCRATCH_MNT $upper2 $work2 \
+		-o "redirect_dir=on,index=on,xino=on"
+
+	# unmount & check underlying overlay
+	$UMOUNT_PROG $SCRATCH_MNT
+	_overlay_check_scratch_dirs $lower $upper $work \
+		-o "index=on,nfs_export=on"
+}
+
+FILES="dir file symlink link chrdev blkdev fifo socket"
+
+create_test_files()
+{
+	local dir=$1
+
+	# Create our test files.
+	mkdir -p $dir/dir
+	touch $dir/file
+	ln -s $dir/file $dir/symlink
+	touch $dir/link
+	ln $dir/link $dir/link2
+	mknod $dir/chrdev c 1 1
+	mknod $dir/blkdev b 1 1
+	mknod $dir/fifo p
+	$here/src/af_unix $dir/socket
+}
+
+# Record inode numbers in format <ino> <basename>
+record_inode_numbers()
+{
+	local dir=$1
+	local outfile=$2
+
+	echo "record_inode_numbers $outfile" >> $seqres.full
+
+	for n in $FILES; do
+		ls -id $dir/$n
+	done | \
+	while read ino file; do
+		f=`basename $file`
+		echo $ino $f | tee -a $seqres.full >> $outfile
+		# /proc/locks exposes i_ino - compare it to st_ino. flock -n
+		# doesn't follow symlink, blocks on fifo and fails on socket
+		[[ $f =~ fifo|socket|symlink ]] || \
+		flock -n $file cat /proc/locks | tee -a $seqres.full | grep -q ":$ino " || \
+			echo "lock for $f not found by ino $ino ($outfile) - see $seqres.full"
+	done
+}
+
+# Check inode numbers match recorder inode numbers
+check_inode_numbers()
+{
+	local dir=$1
+	local before=$2
+	local after=$3
+
+	record_inode_numbers $dir $after
+
+	# Test constant stat(2) st_ino -
+	# Compare before..after - expect silence
+	# We use diff -u so out.bad will tell us which stage failed
+	diff -u $before $after
+
+	# Test constant readdir(3)/getdents(2) d_ino -
+	# Expect to find file by inode number
+	cat $before | while read ino f; do
+		$here/src/t_dir_type $dir $ino | tee -a $seqres.full | grep -q $f || \
+			echo "$f not found by ino $ino (from $before) - see $seqres.full"
+	done
+}
+
+rm -f $seqres.full
+
+create_dirs
+
+create_test_files $lowerdir
+create_test_files $upperdir
+
+mount_dirs
+
+# Record inode numbers in the lower overlay
+record_inode_numbers $SCRATCH_MNT/lowertestdir $tmp.lower.lo
+record_inode_numbers $SCRATCH_MNT/uppertestdir $tmp.lower.up
+
+# Record inode numbers before copy up
+record_inode_numbers $lowertestdir $tmp.before.lo
+record_inode_numbers $uppertestdir $tmp.before.up
+
+# Copy up all files
+for f in $FILES; do
+	# chown -h modifies all those file types
+	chown -h 100 $lowertestdir/$f
+	chown -h 100 $uppertestdir/$f
+done
+
+# Compare inode numbers before/after copy up
+check_inode_numbers $lowertestdir $tmp.before.lo $tmp.after_copyup.lo
+check_inode_numbers $uppertestdir $tmp.before.up $tmp.after_copyup.up
+
+# Move all files to another dir
+mkdir $lowertestdir.2 $uppertestdir.2
+
+for f in $FILES; do
+	mv $lowertestdir/$f $lowertestdir.2/
+	mv $uppertestdir/$f $uppertestdir.2/
+done
+
+echo 3 > /proc/sys/vm/drop_caches
+
+# Compare inode numbers before/after rename and drop caches
+check_inode_numbers $lowertestdir.2 $tmp.after_copyup.lo $tmp.after_move.lo
+check_inode_numbers $uppertestdir.2 $tmp.after_copyup.up $tmp.after_move.up
+
+# Verify that the inode numbers survive a mount cycle
+unmount_dirs
+mount_dirs
+
+# Compare inode numbers before/after mount cycle
+check_inode_numbers $lowertestdir.2 $tmp.after_move.lo $tmp.after_cycle.lo
+check_inode_numbers $uppertestdir.2 $tmp.after_move.up $tmp.after_cycle.up
+
+unmount_dirs
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/070.out b/tests/overlay/070.out
new file mode 100644
index 00000000..8940c5da
--- /dev/null
+++ b/tests/overlay/070.out
@@ -0,0 +1,2 @@
+QA output created by 070
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 9290ce99..45f6885b 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -72,3 +72,4 @@
 067 auto quick copyup nonsamefs
 068 auto quick copyup hardlink exportfs nested
 069 auto quick copyup hardlink exportfs nested nonsamefs
+070 auto quick copyup redirect nested
-- 
2.17.1
