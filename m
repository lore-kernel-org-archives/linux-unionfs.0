Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v5 1/5] common/rc: improve dev mounted check helper
Date: Thu, 1 Mar 2018 20:13:43 +0800
Message-ID: <20180301121347.5824-2-yi.zhang@huawei.com>
In-Reply-To: <20180301121347.5824-1-yi.zhang@huawei.com>
References: <20180301121347.5824-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

There is a problem of missing fstype check in _is_mounted() helper,
it will return the mountpoint if only the device arguments matches.

For example:
  Base mounted filesystem:
    /dev/sda2 on /boot type ext4 (rw,relatime,data=ordered)

  FSTYPE=xfs
  mountpoint=`_is_mounted /dev/sda1`
  echo "$mountpoint"

  Output: /boot

This patch rename _is_mounted to _is_dev_mounted because it check
the given device only (not mount dir), and add an optional "fstype"
parameter, let user specify file system type instead of default
FSTYPE. Finally, use findmnt instead of mount to avoid complex
processing of mount info and fix this problem simply.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 common/rc  | 29 ++++++++++-------------------
 common/xfs |  2 +-
 2 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/common/rc b/common/rc
index a68e6cc..1dae3bf 100644
--- a/common/rc
+++ b/common/rc
@@ -2381,27 +2381,18 @@ _scratch_mkfs_richacl()
 	esac
 }
 
-# check that a FS on a device is mounted
-# if so, return mount point
-#
-_is_mounted()
+# check if the given device is mounted, if so, return mount point
+_is_dev_mounted()
 {
-    if [ $# -ne 1 ]
-    then
-	echo "Usage: _is_mounted device" 1>&2
-	exit 1
-    fi
+	local dev=$1
+	local fstype=${2:-$FSTYP}
 
-    device=$1
+	if [ $# -lt 1 ]; then
+		echo "Usage: _is_dev_mounted <device> [fstype]" 1>&2
+		exit 1
+	fi
 
-    if _mount | grep "$device " | $AWK_PROG -v pattern="type $FSTYP" '
-        pattern        { print $3 ; exit 0 }
-        END            { exit 1 }
-    '
-    then
-        echo "_is_mounted: $device is not a mounted $FSTYP FS"
-        exit 1
-    fi
+	findmnt -rncv -S $dev -t $fstype -o TARGET | head -1
 }
 
 # remount a FS to a new mode (ro or rw)
@@ -2441,7 +2432,7 @@ _umount_or_remount_ro()
     fi
 
     device=$1
-    mountpoint=`_is_mounted $device`
+    mountpoint=`_is_dev_mounted $device`
 
     if [ $USE_REMOUNT -eq 0 ]; then
         $UMOUNT_PROG $device
diff --git a/common/xfs b/common/xfs
index 354f584..37cd80c 100644
--- a/common/xfs
+++ b/common/xfs
@@ -356,7 +356,7 @@ _check_xfs_filesystem()
 	ok=1
 
 	# Run online scrub if we can.
-	mntpt="$(_is_mounted $device)"
+	mntpt="$(_is_dev_mounted $device)"
 	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
 		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device > $tmp.scrub 2>&1
 		if [ $? -ne 0 ]; then
-- 
2.5.0
