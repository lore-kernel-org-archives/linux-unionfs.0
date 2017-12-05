From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH 1/2] common/rc: Add syncfs check and a helper
 _scratch_shutdown()
Date: Tue, 05 Dec 2017 23:50:02 +0800
Message-ID: <2D8A66F2-6AB9-4B7D-90B0-D3B6807FB353@icloud.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv43p51im-ztdg06051601.me.com ([17.133.164.142]:48255 "EHLO
        pv43p51im-ztdg06051601.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751288AbdLEQuQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Dec 2017 11:50:16 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>, Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Chengguang Xu <cgxu519@icloud.com>

1. Add a check case in _require_xfs_io_command() to support syncfs.
2. Introduce a helper to support scratch shutdown for overlayfs.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
common/rc | 22 ++++++++++++++++++++--
1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 4c053a5..e36ee24 100644
--- a/common/rc
+++ b/common/rc
@@ -669,6 +669,21 @@ _scratch_cleanup_files()
	esac
}

+_scratch_shutdown()
+{
+
+	case $FSTYP in
+	overlay)
+		src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
+			|| _notrun "Underlying filesystem does not support shutdown"
+		;;
+	*)
+		src/godown -f $SCRATCH_MNT 2>&1 \
+			|| _notrun "$FSTYP does not support shutdown"
+		;;
+	esac
+}
+
_scratch_mkfs()
{
	local mkfs_cmd=""
@@ -2087,6 +2102,10 @@ _require_xfs_io_command()
	"utimes" )
		testio=`$XFS_IO_PROG -f -c "utimes" 0 0 0 0 $testfile 2>&1`
		;;
+	"syncfs")
+		touch $testfile
+		testio=`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
+		;;
	*)
		testio=`$XFS_IO_PROG -c "help $command" 2>&1`
	esac
@@ -2908,8 +2927,7 @@ _require_scratch_shutdown()

	_scratch_mkfs > /dev/null 2>&1
	_scratch_mount
-	src/godown -f $SCRATCH_MNT 2>&1 \
-		|| _notrun "$FSTYP does not support shutdown"
+	_scratch_shutdown
	_scratch_unmount
}

-- 
1.8.3.1
