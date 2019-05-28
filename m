Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 2/4] overlay: fix _repair_scratch_fs
Date: Tue, 28 May 2019 18:17:21 +0300
Message-Id: <20190528151723.12525-3-amir73il@gmail.com>
In-Reply-To: <20190528151723.12525-1-amir73il@gmail.com>
References: <20190528151723.12525-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

_repair_scratch_fs did not do the right thing for overlay.
Implement and call _repair_overlay_scratch_fs to repair
overlay filesystem and then fall through to repair base filesystem.

The only tests currentrly calling _repair_scratch_fs on a
./check -overlay run are generic/330 generic/332 in case the
base fs supports reflink. The rest of the tests calling
_repair_scratch_fs require that $SCRATCH_DEV is a block device.

Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay | 17 +++++++++++++++++
 common/rc      | 13 +++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/common/overlay b/common/overlay
index b526f24d..a71c2035 100644
--- a/common/overlay
+++ b/common/overlay
@@ -320,3 +320,20 @@ _check_overlay_scratch_fs()
 		"$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
 		$OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
 }
+
+_repair_overlay_scratch_fs()
+{
+	_overlay_fsck_dirs $OVL_BASE_SCRATCH_MNT/$OVL_LOWER \
+		$OVL_BASE_SCRATCH_MNT/$OVL_UPPER \
+		$OVL_BASE_SCRATCH_MNT/$OVL_WORK -y
+	local res=$?
+	case $res in
+	$FSCK_OK|$FSCK_NONDESTRUCT)
+		res=0
+		;;
+	*)
+		_dump_err2 "fsck.overlay failed, err=$res"
+		;;
+	esac
+	return $res
+}
diff --git a/common/rc b/common/rc
index cedc1cfa..d0aa36a0 100644
--- a/common/rc
+++ b/common/rc
@@ -1112,8 +1112,17 @@ _repair_scratch_fs()
 	return $res
         ;;
     *)
-        # Let's hope fsck -y suffices...
-        fsck -t $FSTYP -y $SCRATCH_DEV 2>&1
+	local dev=$SCRATCH_DEV
+	local fstyp=$FSTYP
+	if [ $FSTYP = "overlay" -a -n "$OVL_BASE_SCRATCH_DEV" ]; then
+		_repair_overlay_scratch_fs
+		# Fall through to repair base fs
+		dev=$OVL_BASE_SCRATCH_DEV
+		fstyp=$OVL_BASE_FSTYP
+		$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT
+	fi
+	# Let's hope fsck -y suffices...
+	fsck -t $fstyp -y $dev 2>&1
 	local res=$?
 	case $res in
 	$FSCK_OK|$FSCK_NONDESTRUCT|$FSCK_REBOOT)
-- 
2.17.1
