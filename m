From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v6 1/8] common/rc: modify mounted check helper
Date: Wed, 24 Jan 2018 15:33:37 +0800
Message-ID: <20180124073344.31970-2-yi.zhang@huawei.com>
References: <20180124073344.31970-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180124073344.31970-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

Modify _is_mounted() to accept a dir and fstype as input, and check
whether this dir is a mount point of specified fstype. This patch also
fix the problem of invalid fstype check and remove invalid error
message.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 common/rc | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/common/rc b/common/rc
index 77a4eb4..2e7aee5 100644
--- a/common/rc
+++ b/common/rc
@@ -2372,27 +2372,27 @@ _scratch_mkfs_richacl()
 	esac
 }
 
-# check that a FS on a device is mounted
+# check that a FS on a device is mounted or a dir is a mount point
 # if so, return mount point
 #
 _is_mounted()
 {
-    if [ $# -ne 1 ]
-    then
-	echo "Usage: _is_mounted device" 1>&2
-	exit 1
-    fi
+	local name
+	local fstype
 
-    device=$1
+	if [ $# -eq 2 ]; then
+		name=$1
+		fstype=$2
+	elif [ $# -eq 1 ]; then
+		name=$1
+	else
+		echo "Usage: _is_mounted <device|mountpoint> [fstype]" 1>&2
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
+	_mount | grep "$name " | $AWK_PROG -v pattern="type $fstype" '
+		$0 ~ pattern	{ print $3 }
+	'
 }
 
 # remount a FS to a new mode (ro or rw)
-- 
2.9.5
