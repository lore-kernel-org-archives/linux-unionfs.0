From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v2 2/3] common/rc: add a check case in _require_xfs_io_command() to support syncfs.
Date: Thu,  7 Dec 2017 10:22:06 +0800
Message-ID: <1512613327-218016-2-git-send-email-cgxu519@icloud.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:23489 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752219AbdLGCW7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 21:22:59 -0500
In-Reply-To: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com, amir73il@gmail.com
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
 common/rc | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/rc b/common/rc
index 911dba3..4827ba6 100644
--- a/common/rc
+++ b/common/rc
@@ -2096,6 +2096,10 @@ _require_xfs_io_command()
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
-- 
1.8.3.1
