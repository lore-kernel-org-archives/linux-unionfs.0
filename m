From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v5 1/3] common/rc: add scratch shutdown support for overlayfs
Date: Fri, 15 Dec 2017 15:47:33 +0800
Message-ID: <1513324055-77618-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:11531 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752740AbdLOHsM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 02:48:12 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com, amir73il@gmail.com
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

check -overlay overrides variable SCRATCH_MNT to it's own,
so overlayfs can not be accepted by _require_scratch_shutdown.
In order to test some cases which require shutdown on overlayfs,
adjust shutdown target from SCRATCH_MNT to
OVL_BASE_SCRATCH_MNT(underlaying filesystem) when detecting
overlayfs to pass require check successfully. And in actual case,
convert bare godown calling to a helper _scratch_shutdown which
can recognize overlayfs and handle shutdown correctly for avoiding
failure of original cases in the generic shutdown group except cases
require local device.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---

Changes since v4:
1. Add return code check for _scratch_mkfs and _scratch_mount in
_require_scratch_shutdown.
2. Change commit log.

Changes since v3:
1. When _scratch_shutdown() detecting improper shutdown on overlayfs,
prompt error message and exit immediately.
2. Convert godown to _scratch_shutdown for the cases overlayfs shuold run.
3. Add _require_local_device to the cases overlayfs should not run.

Changes since v2:
1. Make option for _scratch_shutdown(), so caller can
specify option when calling.
2. Add comment for why overlay requires special handling.
3. Add commit log.

Changes since v1:
_scratch_shutdown() does not call notrun.

 common/rc         | 42 ++++++++++++++++++++++++++++++++++++++----
 tests/generic/042 |  1 +
 tests/generic/043 |  2 +-
 tests/generic/044 |  2 +-
 tests/generic/045 |  2 +-
 tests/generic/046 |  2 +-
 tests/generic/047 |  2 +-
 tests/generic/048 |  2 +-
 tests/generic/049 |  2 +-
 tests/generic/050 |  1 +
 tests/generic/051 |  2 +-
 tests/generic/052 |  2 +-
 tests/generic/054 |  2 +-
 tests/generic/055 |  2 +-
 tests/generic/388 |  3 ++-
 tests/generic/392 |  2 +-
 tests/generic/417 |  2 +-
 tests/generic/461 |  2 +-
 tests/generic/468 |  2 +-
 19 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/common/rc b/common/rc
index 4c053a5..035ad22 100644
--- a/common/rc
+++ b/common/rc
@@ -382,6 +382,25 @@ _scratch_cycle_mount()
     _scratch_mount "$opts"
 }
 
+_scratch_shutdown()
+{
+	if [ $FSTYP = "overlay" ]; then
+		# In lagacy overlay usage, it may specify directory as
+		# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
+		# will be null, so check OVL_BASE_SCRATCH_DEV before
+		# running shutdown to avoid shutting down base fs accidently.
+		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
+			_fail "Called _scratch_shutdown without validating " \
+				"\$OVL_BASE_SCRATCH_DEV, " \
+				"please call _require_scratch_shutdown first."
+		else
+			src/godown $* $OVL_BASE_SCRATCH_MNT
+		fi
+	else
+		src/godown $* $SCRATCH_MNT
+	fi
+}
+
 _test_mount()
 {
     if [ "$FSTYP" == "overlay" ]; then
@@ -2906,10 +2925,25 @@ _require_scratch_shutdown()
 {
 	[ -x src/godown ] || _notrun "src/godown executable not found"
 
-	_scratch_mkfs > /dev/null 2>&1
-	_scratch_mount
-	src/godown -f $SCRATCH_MNT 2>&1 \
-		|| _notrun "$FSTYP does not support shutdown"
+	_scratch_mkfs > /dev/null 2>&1 || _notrun "_scratch_mkfs failed on $SCRATCH_DEV"
+	_scratch_mount || _notrun "_scratch_mount failed on $SCRATCH_MNT"
+
+	if [ $FSTYP = "overlay" ]; then
+		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
+			# In lagacy overlay usage, it may specify directory as
+			# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
+			# will be null, so check OVL_BASE_SCRATCH_DEV before
+			# running shutdown to avoid shutting down base fs accidently.
+			_notrun "$SCRATCH_DEV is not a block device"
+		else
+			src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
+			|| _notrun "Underlying filesystem does not support shutdown"
+		fi
+	else
+		src/godown -f $SCRATCH_MNT 2>&1 \
+			|| _notrun "$FSTYP does not support shutdown"
+	fi
+
 	_scratch_unmount
 }
 
diff --git a/tests/generic/042 b/tests/generic/042
index 68ff03c..00b3a34 100755
--- a/tests/generic/042
+++ b/tests/generic/042
@@ -92,6 +92,7 @@ _require_xfs_io_command "fpunch"
 _require_xfs_io_command "fzero"
 
 _scratch_mkfs >/dev/null 2>&1
+_require_local_device $SCRATCH_DEV
 _require_metadata_journaling $SCRATCH_DEV
 _scratch_mount
 
diff --git a/tests/generic/043 b/tests/generic/043
index 5dadab3..f61222c 100755
--- a/tests/generic/043
+++ b/tests/generic/043
@@ -63,7 +63,7 @@ done
 # give the system a chance to write something out
 sleep 10
 
-src/godown $SCRATCH_MNT
+_scratch_shutdown
 
 _scratch_unmount
 _scratch_mount
diff --git a/tests/generic/044 b/tests/generic/044
index 804b1b1..f327ee0 100755
--- a/tests/generic/044
+++ b/tests/generic/044
@@ -69,7 +69,7 @@ done
 # give the system a chance to write something out
 sleep 10
 
-src/godown $SCRATCH_MNT
+_scratch_shutdown
 
 _scratch_unmount
 _scratch_mount
diff --git a/tests/generic/045 b/tests/generic/045
index 5fa7b09..5348910 100755
--- a/tests/generic/045
+++ b/tests/generic/045
@@ -69,7 +69,7 @@ done
 # give the system a chance to write something out
 sleep 10
 
-src/godown $SCRATCH_MNT
+_scratch_shutdown
 
 _scratch_unmount
 _scratch_mount
diff --git a/tests/generic/046 b/tests/generic/046
index bf38d53..1155ee9 100755
--- a/tests/generic/046
+++ b/tests/generic/046
@@ -69,7 +69,7 @@ done
 # give the system a chance to write something out
 sleep 10
 
-src/godown $SCRATCH_MNT
+_scratch_shutdown
 
 _scratch_unmount
 _scratch_mount
diff --git a/tests/generic/047 b/tests/generic/047
index 7d09b04..66965f2 100755
--- a/tests/generic/047
+++ b/tests/generic/047
@@ -92,7 +92,7 @@ do
 done
 
 # shutdown immediately after, then remount and test
-src/godown $SCRATCH_MNT
+_scratch_shutdown
 _scratch_unmount
 _scratch_mount
 _scratch_unmount
diff --git a/tests/generic/048 b/tests/generic/048
index ae561fc..fd9fcd9 100755
--- a/tests/generic/048
+++ b/tests/generic/048
@@ -96,7 +96,7 @@ done
 
 # sync, then shutdown immediately after, then remount and test
 sync
-src/godown $SCRATCH_MNT
+_scratch_shutdown
 _scratch_unmount
 _scratch_mount
 _scratch_unmount
diff --git a/tests/generic/049 b/tests/generic/049
index ef2b44c..0003046 100755
--- a/tests/generic/049
+++ b/tests/generic/049
@@ -93,7 +93,7 @@ done
 
 # sync, then shutdown immediately after, then remount and test
 sync
-src/godown $SCRATCH_MNT
+_scratch_shutdown
 _scratch_unmount
 _scratch_mount
 _scratch_unmount
diff --git a/tests/generic/050 b/tests/generic/050
index efa45f0..dbf0ac5 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -44,6 +44,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_local_device $SCRATCH_DEV
 _require_scratch_nocheck
 _require_scratch_shutdown
 _require_norecovery
diff --git a/tests/generic/051 b/tests/generic/051
index 29ac61b..129a466 100755
--- a/tests/generic/051
+++ b/tests/generic/051
@@ -80,7 +80,7 @@ sync
 
 # now shutdown and unmount
 sleep 5
-$here/src/godown $load_dir
+_scratch_shutdown
 $KILLALL_PROG -q $FSSTRESS_PROG
 wait
 
diff --git a/tests/generic/052 b/tests/generic/052
index cf0f456..126f08e 100755
--- a/tests/generic/052
+++ b/tests/generic/052
@@ -63,7 +63,7 @@ echo "touch files"
 touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
 
 echo "godown"
-src/godown -v -f $SCRATCH_MNT >> $seqres.full
+_scratch_shutdown -v -f >> $seqres.full
 
 echo "unmount"
 _scratch_unmount
diff --git a/tests/generic/054 b/tests/generic/054
index db41500..12f471a 100755
--- a/tests/generic/054
+++ b/tests/generic/054
@@ -108,7 +108,7 @@ for s in sync nosync ; do
 	ls $SCRATCH_MNT | _filter_lostfound
 
 	_echofull "godown"
-	src/godown -v -f $SCRATCH_MNT >> $seqres.full
+	_scratch_shutdown -v -f >> $seqres.full
 
 	_echofull "unmount"
 	_scratch_unmount >>$seqres.full 2>&1 \
diff --git a/tests/generic/055 b/tests/generic/055
index 1bbe310..c543e75 100755
--- a/tests/generic/055
+++ b/tests/generic/055
@@ -118,7 +118,7 @@ do
     ls -RF $SCRATCH_MNT >$tmp.ls1
 
     _echofull "godown"
-    src/godown -v -f $SCRATCH_MNT >> $seqres.full
+    _scratch_shutdown -v -f >> $seqres.full
 
     _echofull "unmount"
     _scratch_unmount >>$seqres.full 2>&1 \
diff --git a/tests/generic/388 b/tests/generic/388
index 4f5a63b..e0f4821 100755
--- a/tests/generic/388
+++ b/tests/generic/388
@@ -54,6 +54,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_scratch
+_require_local_device $SCRATCH_DEV
 _require_scratch_shutdown
 _require_command "$KILLALL_PROG" "killall"
 
@@ -72,7 +73,7 @@ for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
 	# purposely include 0 second sleeps to test shutdown immediately after
 	# recovery
 	sleep $((RANDOM % 3))
-	./src/godown $SCRATCH_MNT
+	_scratch_shutdown
 
 	ps -e | grep fsstress > /dev/null 2>&1
 	while [ $? -eq 0 ]; do
diff --git a/tests/generic/392 b/tests/generic/392
index 6922f7d..9d53413 100755
--- a/tests/generic/392
+++ b/tests/generic/392
@@ -73,7 +73,7 @@ check_inode_metadata()
 	before=`stat "$stat_opt" $testfile`
 
 	$XFS_IO_PROG -c "$sync_mode" $testfile | _filter_xfs_io
-	src/godown $SCRATCH_MNT | tee -a $seqres.full
+	_scratch_shutdown | tee -a $seqres.full
 	_scratch_cycle_mount
 
 	after=`stat "$stat_opt" $testfile`
diff --git a/tests/generic/417 b/tests/generic/417
index 690ceb5..e66e0ae 100755
--- a/tests/generic/417
+++ b/tests/generic/417
@@ -75,7 +75,7 @@ function create_dirty_orphans() {
 	sleep 3
 
 	echo "godown"
-	src/godown -v -f $SCRATCH_MNT >> $seqres.full
+	_scratch_shutdown -v -f >> $seqres.full
 
 	# kill the multi_open_unlink
 	kill $pid 2>/dev/null
diff --git a/tests/generic/461 b/tests/generic/461
index 2f85114..50b9c6d 100755
--- a/tests/generic/461
+++ b/tests/generic/461
@@ -68,7 +68,7 @@ sync
 
 # now shutdown and unmount
 sleep 5
-$here/src/godown $load_dir
+_scratch_shutdown
 $KILLALL_PROG -q $FSSTRESS_PROG
 wait
 
diff --git a/tests/generic/468 b/tests/generic/468
index b97a8d6..30c4174 100755
--- a/tests/generic/468
+++ b/tests/generic/468
@@ -84,7 +84,7 @@ check_inode_metadata()
 	before=`stat "$stat_opt" $testfile`
 
 	$XFS_IO_PROG -c "$sync_mode" $testfile | _filter_xfs_io
-	$here/src/godown $SCRATCH_MNT | tee -a $seqres.full
+	_scratch_shutdown | tee -a $seqres.full
 	_scratch_cycle_mount
 
 	after=`stat "$stat_opt" $testfile`
-- 
1.8.3.1
