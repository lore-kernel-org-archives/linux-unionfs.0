From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] test-appliance: add support for overlayfs over xfs
Date: Sun,  6 Nov 2016 12:23:17 +0200
Message-ID: <1478427797-8969-3-git-send-email-amir73il@gmail.com>
References: <1478427797-8969-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1478427797-8969-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

When PRIMARY_FSTYPE is set to xfs, format overlayfs
underlying device as xfs with reflink support, because
clone-up is so much nicer then copy-up.

This requires using the for-next (for 4.9) branch of
xfsprogs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../test-appliance/files/root/fs/overlay/config    | 44 ++++++++++++++++++----
 kvm-xfstests/util/parse_cli                        |  2 +-
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/kvm-xfstests/test-appliance/files/root/fs/overlay/config b/kvm-xfstests/test-appliance/files/root/fs/overlay/config
index 4420cfe..63ae06f 100644
--- a/kvm-xfstests/test-appliance/files/root/fs/overlay/config
+++ b/kvm-xfstests/test-appliance/files/root/fs/overlay/config
@@ -4,18 +4,32 @@
 
 DEFAULT_MKFS_OPTIONS=""
 
+function __fsck()
+{
+	local dev="$1"
+
+	case "$FSTESTTYP" in
+	    ext4)
+		/sbin/e2fsck -fy "$dev"
+		;;
+	    xfs)
+		xfs_repair "$dev"
+		;;
+	esac
+}
+
 function check_filesystem()
 {
 	umount $SM_TST_DEV >& /dev/null
-	/sbin/e2fsck -fy "$SM_TST_DEV"
+	__fsck "$SM_TST_DEV"
 	ret="$?"
-	mount -t ext4 $SM_TST_DEV $SM_TST_MNT
+	mount -t $FSTESTTYP $SM_TST_DEV $SM_TST_MNT
 	echo e2fsck exited with status "$ret"
 
 	umount $SM_SCR_DEV >& /dev/null
-	/sbin/e2fsck -fy "$SM_SCR_DEV"
+	__fsck "$SM_SCR_DEV"
 	ret2="$?"
-	mount -t ext4 $SM_SCR_DEV $SM_SCR_MNT
+	mount -t $FSTESTTYP $SM_SCR_DEV $SM_SCR_MNT
 	echo e2fsck exited with status "$ret2"
 
 	if test "$ret" -eq 0 ; then
@@ -24,16 +38,30 @@ function check_filesystem()
 	return "$ret"
 }
 
+function __mkfs()
+{
+	local dev="$1"
+
+	case "$FSTESTTYP" in
+	    ext4)
+		/sbin/mke2fs -F -q -t ext4 "$dev"
+		;;
+	    xfs)
+		mkfs.xfs -f -m rmapbt=1,reflink=1 "$dev"
+		;;
+	esac
+}
+
 function format_filesystem()
 {
 	umount $SM_TST_DEV >& /dev/null
-	/sbin/mke2fs -F -q -t ext4 $SM_TST_DEV
-	mount -t ext4 $SM_TST_DEV $SM_TST_MNT
+	__mkfs $SM_TST_DEV
+	mount -t $FSTESTTYP $SM_TST_DEV $SM_TST_MNT
 	mkdir -p $SM_TST_MNT/ovl $SM_TST_MNT/testarea
 	      
 	umount $SM_SCR_DEV >& /dev/null
-	/sbin/mke2fs -F -q -t ext4 $SM_SCR_DEV
-	mount -t ext4 $SM_SCR_DEV $SM_SCR_MNT
+	__mkfs $SM_SCR_DEV
+	mount -t $FSTESTTYP $SM_SCR_DEV $SM_SCR_MNT
 	mkdir -p $SM_SCR_MNT/ovl $SM_SCR_MNT/testarea
 
 	return 0
diff --git a/kvm-xfstests/util/parse_cli b/kvm-xfstests/util/parse_cli
index a170931..ea747be 100644
--- a/kvm-xfstests/util/parse_cli
+++ b/kvm-xfstests/util/parse_cli
@@ -59,7 +59,7 @@ print_help ()
 validate_test_name()
 {
     case "$1" in
-	btrfs*|cifs*|ext4*|generic*|shared*|udf*|xfs*) ;;
+	btrfs*|cifs*|ext4*|generic*|shared*|udf*|xfs*|overlay*) ;;
 	*)
 	    echo -e "Invalid test name: $1\n"
 	    print_help
-- 
2.7.4
