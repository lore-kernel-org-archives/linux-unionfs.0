From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH 1/5] common/rc: improve mounted check helper
Date: Thu, 25 Jan 2018 14:39:45 +0800
Message-ID: <20180125063949.12916-2-yi.zhang@huawei.com>
References: <20180125063949.12916-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4696 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751374AbeAYGbi (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Jan 2018 01:31:38 -0500
In-Reply-To: <20180125063949.12916-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Modify _is_mounted() to accept a dir and fstype as input, and check
whether this dir is a specified type of mount point. This patch also
fix the problem of invalid fstype check and remove invalid error
message.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 common/rc | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/common/rc b/common/rc
index 77a4eb4..ceb5d44 100644
--- a/common/rc
+++ b/common/rc
@@ -2372,27 +2372,22 @@ _scratch_mkfs_richacl()
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
+	if [ $# -lt 1 ]; then
+		echo "Usage: _is_mounted <device|mountpoint> [fstype]" 1>&2
+		exit 1
+	fi
 
-    device=$1
+	local name=$1
+	local fstype=${2-$FSTYP}
 
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
2.5.0
