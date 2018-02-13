From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v3 6/6] overlay: correct test mount options
Date: Tue, 13 Feb 2018 15:08:32 +0800
Message-ID: <20180213070832.43159-7-yi.zhang@huawei.com>
References: <20180213070832.43159-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:50720 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S933437AbeBMG7y (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Feb 2018 01:59:54 -0500
In-Reply-To: <20180213070832.43159-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Current overlay's _test_mount functions mount base test filesystem
with TEST_FS_MOUNT_OPTS and mount test overlayfs with MOUNT_OPTIONS
instead of TEST_FS_MOUNT_OPTS. The TEST_FS_MOUNT_OPTS variable
should be used for test overlayfs like MOUNT_OPTIONS use for scratch
overlayfs.

This patch rename OVL_BASE_MOUNT_OPTIONS to
OVL_BASE_SCRATCH_MOUNT_OPTIONS and introduce an counterpart variable
OVL_BASE_TEST_MOUNT_OPTIONS for test base filesystem, and then use
TEST_FS_MOUNT_OPTS for test overlayfs. We also modify overlay mount
helpers to adapt mount options.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 common/config     | 17 +++++++++++++----
 common/overlay    | 31 +++++++++++++++++++++++--------
 tests/overlay/022 |  2 +-
 tests/overlay/025 |  2 +-
 tests/overlay/029 |  6 +++---
 tests/overlay/036 | 20 ++++++++++----------
 6 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/common/config b/common/config
index 20f0e5f..fd04a16 100644
--- a/common/config
+++ b/common/config
@@ -346,6 +346,9 @@ _test_mount_opts()
 	glusterfs)
 		export TEST_FS_MOUNT_OPTS=$GLUSTERFS_MOUNT_OPTIONS
 		;;
+	overlay)
+		export TEST_FS_MOUNT_OPTS=$OVERLAY_MOUNT_OPTIONS
+		;;
 	ext2|ext3|ext4|ext4dev)
 		# acls & xattrs aren't turned on by default on older ext$FOO
 		export TEST_FS_MOUNT_OPTS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
@@ -546,16 +549,19 @@ _overlay_config_override()
 	# Store original base fs vars
 	export OVL_BASE_TEST_DEV="$TEST_DEV"
 	export OVL_BASE_TEST_DIR="$TEST_DIR"
-	# If config does not set MOUNT_OPTIONS, its value may be
-	# leftover from previous _overlay_config_override, so
+	# If config does not set MOUNT_OPTIONS and TEST_FS_MOUNT_OPTS, its
+	# value may be leftover from previous _overlay_config_override, so
 	# don't use that value for base fs mount
 	[ "$MOUNT_OPTIONS" != "$OVERLAY_MOUNT_OPTIONS" ] || unset MOUNT_OPTIONS
-	export OVL_BASE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+	export OVL_BASE_SCRATCH_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+	[ "$TEST_FS_MOUNT_OPTS" != "$OVERLAY_MOUNT_OPTIONS" ] || unset TEST_FS_MOUNT_OPTS
+	export OVL_BASE_TEST_MOUNT_OPTIONS="$TEST_FS_MOUNT_OPTS"
 
 	# Set TEST vars to overlay base and mount dirs inside base fs
 	export TEST_DEV="$OVL_BASE_TEST_DIR"
 	export TEST_DIR="$OVL_BASE_TEST_DIR/$OVL_MNT"
 	export MOUNT_OPTIONS="$OVERLAY_MOUNT_OPTIONS"
+	export TEST_FS_MOUNT_OPTS="$OVERLAY_MOUNT_OPTIONS"
 
 	[ -b "$SCRATCH_DEV" ] || return 0
 
@@ -580,7 +586,10 @@ _overlay_config_restore()
 	[ -z "$OVL_BASE_TEST_DIR" ] || export TEST_DIR=$OVL_BASE_TEST_DIR
 	[ -z "$OVL_BASE_SCRATCH_DEV" ] || export SCRATCH_DEV=$OVL_BASE_SCRATCH_DEV
 	[ -z "$OVL_BASE_SCRATCH_MNT" ] || export SCRATCH_MNT=$OVL_BASE_SCRATCH_MNT
-	[ -z "$OVL_BASE_MOUNT_OPTIONS" ] || export MOUNT_OPTIONS=$OVL_BASE_MOUNT_OPTIONS
+	[ -z "$OVL_BASE_SCRATCH_MOUNT_OPTIONS" ] || \
+		export MOUNT_OPTIONS=$OVL_BASE_SCRATCH_MOUNT_OPTIONS
+	[ -z "$OVL_BASE_TEST_MOUNT_OPTIONS" ] || \
+		export TEST_FS_MOUNT_OPTS=$OVL_BASE_TEST_MOUNT_OPTIONS
 }
 
 # Parse config section options. This function will parse all the configuration
diff --git a/common/overlay b/common/overlay
index 29f9bf8..058b025 100644
--- a/common/overlay
+++ b/common/overlay
@@ -20,7 +20,19 @@ _overlay_mount_dirs()
 	shift 3
 
 	$MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
-		    -o workdir=$workdir `_common_dev_mount_options $*`
+		    -o workdir=$workdir $*
+}
+
+# Mount overlayfs with optional dirs and mount point
+_overlay_mount_optional_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	shift 3
+
+	_overlay_mount_dirs $lowerdir $upperdir $workdir \
+			    `_common_dev_mount_options $*`
 }
 
 # Mount with same options/mnt/dev of scratch mount, but optionally
@@ -33,7 +45,8 @@ _overlay_scratch_mount_dirs()
 	shift 3
 
 	_overlay_mount_dirs $lowerdir $upperdir $workdir \
-				$* $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+			    `_common_dev_mount_options $*` \
+			    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 }
 
 _overlay_mkdirs()
@@ -86,26 +99,28 @@ _overlay_base_test_mount()
 {
 	_overlay_base_mount OVL_BASE_TEST_DEV OVL_BASE_TEST_DIR \
 			"$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR" \
-			$TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS
+			$OVL_BASE_TEST_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
 }
 
 _overlay_test_mount()
 {
 	_overlay_base_test_mount && \
-		_overlay_mount $OVL_BASE_TEST_DIR $TEST_DIR $*
+		_overlay_mount $OVL_BASE_TEST_DIR $TEST_DIR \
+			       $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS $*
 }
 
 _overlay_base_scratch_mount()
 {
 	_overlay_base_mount OVL_BASE_SCRATCH_DEV OVL_BASE_SCRATCH_MNT \
 			"$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
-			$OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
+			$OVL_BASE_SCRATCH_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
 }
 
 _overlay_scratch_mount()
 {
 	_overlay_base_scratch_mount && \
-		_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
+		_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+			       `_common_dev_mount_options $*`
 }
 
 _overlay_base_unmount()
@@ -305,7 +320,7 @@ _check_overlay_test_fs()
 	_overlay_check_fs "$TEST_DIR" \
 		OVL_BASE_TEST_DEV OVL_BASE_TEST_DIR \
 		"$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR" \
-		$TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS
+		$OVL_BASE_TEST_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
 }
 
 _check_overlay_scratch_fs()
@@ -313,5 +328,5 @@ _check_overlay_scratch_fs()
 	_overlay_check_fs "$SCRATCH_MNT" \
 		OVL_BASE_SCRATCH_DEV OVL_BASE_SCRATCH_MNT \
 		"$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
-		$OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
+		$OVL_BASE_SCRATCH_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
 }
diff --git a/tests/overlay/022 b/tests/overlay/022
index ef4d73f..58683fb 100755
--- a/tests/overlay/022
+++ b/tests/overlay/022
@@ -68,7 +68,7 @@ _scratch_mount
 mkdir -p $tmp/{lower,mnt}
 # mount overlay using upper from another overlay upper
 # should fail
-_overlay_mount_dirs $tmp/lower $SCRATCH_MNT/upper \
+_overlay_mount_optional_dirs $tmp/lower $SCRATCH_MNT/upper \
   $SCRATCH_MNT/work overlay $tmp/mnt > /dev/null 2>&1
 if [ $? -ne 0 ] ; then
 	echo "Silence is golden"
diff --git a/tests/overlay/025 b/tests/overlay/025
index bdbb4e5..f82ff4c 100755
--- a/tests/overlay/025
+++ b/tests/overlay/025
@@ -71,7 +71,7 @@ mkdir -p -m 0 $tmpfsdir/upper/testd
 setfacl -m u:$qa_user:rx $tmpfsdir/upper/testd
 
 # mount overlay using dirs in tmpfs
-_overlay_mount_dirs $tmpfsdir/{lower,upper,work,overlay,mnt}
+_overlay_mount_optional_dirs $tmpfsdir/{lower,upper,work,overlay,mnt}
 
 # user accessing test dir, should be OKay
 _user_do "ls $tmpfsdir/mnt/testd"
diff --git a/tests/overlay/029 b/tests/overlay/029
index 2ac674f..ca04ea8 100755
--- a/tests/overlay/029
+++ b/tests/overlay/029
@@ -77,20 +77,20 @@ _scratch_mount
 
 mkdir -p $tmp/{upper,mnt,work}
 # mount overlay again using upper dir from SCRATCH_MNT dir
-_overlay_mount_dirs $SCRATCH_MNT/up $tmp/{upper,work} \
+_overlay_mount_optional_dirs $SCRATCH_MNT/up $tmp/{upper,work} \
   overlay $tmp/mnt
 # accessing file in the second mount
 cat $tmp/mnt/foo
 $UMOUNT_PROG $tmp/mnt
 
 # mount overlay again using lower dir from SCRATCH_MNT dir
-_overlay_mount_dirs $SCRATCH_MNT/low $tmp/{upper,work} \
+_overlay_mount_optional_dirs $SCRATCH_MNT/low $tmp/{upper,work} \
   overlay $tmp/mnt
 cat $tmp/mnt/bar
 $UMOUNT_PROG $tmp/mnt
 
 # mount overlay again using SCRATCH_MNT dir
-_overlay_mount_dirs $SCRATCH_MNT/ $tmp/{upper,work} \
+_overlay_mount_optional_dirs $SCRATCH_MNT/ $tmp/{upper,work} \
   overlay $tmp/mnt
 cat $tmp/mnt/up/foo
 cat $tmp/mnt/low/bar
diff --git a/tests/overlay/036 b/tests/overlay/036
index 8d3ccf4..2a79ef2 100755
--- a/tests/overlay/036
+++ b/tests/overlay/036
@@ -87,29 +87,29 @@ workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
 mkdir -p $lowerdir $lowerdir2 $upperdir $upperdir2 $workdir $workdir2
 
 # Mount overlay with lowerdir, upperdir, workdir
-_overlay_mount_dirs $lowerdir $upperdir $workdir \
-		    overlay $SCRATCH_MNT
+_overlay_mount_optional_dirs $lowerdir $upperdir $workdir \
+			     overlay $SCRATCH_MNT
 
 # Try to mount another overlay with the same upperdir
 # with index=off - expect success
-_overlay_mount_dirs $lowerdir $upperdir $workdir2 \
-		    overlay0 $SCRATCH_MNT -oindex=off && \
-		    $UMOUNT_PROG $SCRATCH_MNT
+_overlay_mount_optional_dirs $lowerdir $upperdir $workdir2 \
+			     overlay0 $SCRATCH_MNT -oindex=off && \
+			     $UMOUNT_PROG $SCRATCH_MNT
 
 # Try to mount another overlay with the same workdir
 # with index=off - expect success
-_overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
-		    overlay1 $SCRATCH_MNT -oindex=off && \
-		    $UMOUNT_PROG $SCRATCH_MNT
+_overlay_mount_optional_dirs $lowerdir2 $upperdir2 $workdir \
+			     overlay1 $SCRATCH_MNT -oindex=off && \
+			     $UMOUNT_PROG $SCRATCH_MNT
 
 # Try to mount another overlay with the same upperdir
 # with index=on - expect EBUSY
-_overlay_mount_dirs $lowerdir $upperdir $workdir2 \
+_overlay_mount_optional_dirs $lowerdir $upperdir $workdir2 \
 	    overlay2 $SCRATCH_MNT -oindex=on 2>&1 | _filter_busy_mount
 
 # Try to mount another overlay with the same workdir
 # with index=on - expect EBUSY
-_overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
+_overlay_mount_optional_dirs $lowerdir2 $upperdir2 $workdir \
 	    overlay3 $SCRATCH_MNT -oindex=on 2>&1 | _filter_busy_mount
 
 # check overlayfs
-- 
2.5.0
