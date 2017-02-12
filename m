From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 2/9] fstests: use _test_mount() consistently
Date: Sun, 12 Feb 2017 22:43:37 +0200
Message-ID: <1486932224-17075-3-git-send-email-amir73il@gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On start of every test run and on every test, in init_rc() helper,
the test partition is verified to be mounted, or is mounted by
the helper _test_mount().

_test_mount() uses mount options $TEST_FS_MOUNT_OPTS and not
$MOUNT_OPTIONS like _scratch_mount() does.

_test_cycle_mount(), which is called by some tests uses the
_test_mount() helper as well.

Contrary to those cases, in _require_test() helper, if test
partition is not mounted, the helper _mount_or_remount_rw()
is called to mount the test partition with $MOUNT_OPTIONS.
Although this should never happen, because of the test in
init_rc(), this case is inconsistent with the rest of the code,
so it has been changed to use _test_mount() as it should.

When running tests with a multi section configuration, and
either FSTYP or MOUNT_OPTIONS change between sections, the
helper _test_unmount() is called to unmount the old test mount
and then _mount_or_remount_rw() is called to mount it again
with new FSTYP and/or MOUNT_OPTIONS.
This is again inconsistent with the rest of the code, so
was changed to use _test_mount() and instead of checking
if MOUNT_OPTIONS have changed between sections, we check if
TEST_FS_MOUNT_OPTS were changed between sections.
Otherwise, we can leave the test partition mounted.

This change is needed to support overlay base fs mount
and for multi section config files which include overlay FSTYP.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 check     | 22 ++++++++++------------
 common/rc |  6 +++---
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/check b/check
index 5a93c94..ec9798a 100755
--- a/check
+++ b/check
@@ -474,7 +474,7 @@ fi
 
 for section in $HOST_OPTIONS_SECTIONS; do
 	OLD_FSTYP=$FSTYP
-	OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
+	OLD_TEST_FS_MOUNT_OPTS=$TEST_FS_MOUNT_OPTS
 	get_next_config $section
 
 	# Do we need to run only some sections ?
@@ -527,20 +527,18 @@ for section in $HOST_OPTIONS_SECTIONS; do
 			status=1
 			exit
 		fi
-		out=`_mount_or_remount_rw "$MOUNT_OPTIONS" $TEST_DEV $TEST_DIR`
-		if [ $? -ne 1 ]; then
-			echo $out
-			status=1
-			exit
+		if ! _test_mount
+		then
+			echo "check: failed to mount $TEST_DEV on $TEST_DIR"
+			exit 1
 		fi
 		_prepare_test_list
-	elif [ "$OLD_MOUNT_OPTIONS" != "$MOUNT_OPTIONS" ]; then
+	elif [ "$OLD_TEST_FS_MOUNT_OPTS" != "$TEST_FS_MOUNT_OPTS" ]; then
 		_test_unmount 2> /dev/null
-		out=`_mount_or_remount_rw "$MOUNT_OPTIONS" $TEST_DEV $TEST_DIR`
-		if [ $? -ne 1 ]; then
-			echo $out
-			status=1
-			exit
+		if ! _test_mount
+		then
+			echo "check: failed to mount $TEST_DEV on $TEST_DIR"
+			exit 1
 		fi
 	fi
 
diff --git a/common/rc b/common/rc
index d831b17..00afb31 100644
--- a/common/rc
+++ b/common/rc
@@ -1485,9 +1485,9 @@ _require_test()
 
     if ! _check_mounted_on TEST_DEV $TEST_DEV TEST_DIR $TEST_DIR
     then
-	out=`_mount_or_remount_rw "$MOUNT_OPTIONS" $TEST_DEV $TEST_DIR`
-	if [ $? -ne 1 ]; then
-		echo $out
+	if ! _test_mount
+	then
+		echo "!!! failed to mount $TEST_DEV on $TEST_DIR"
 		exit 1
 	fi
     fi
-- 
2.7.4
