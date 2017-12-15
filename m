From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v5 2/3] common/rc: check syncfs support
Date: Fri, 15 Dec 2017 15:47:34 +0800
Message-ID: <1513324055-77618-2-git-send-email-cgxu519@icloud.com>
References: <1513324055-77618-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:11529 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752642AbdLOHsM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 02:48:12 -0500
In-Reply-To: <1513324055-77618-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com, amir73il@gmail.com
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

common/rc: add a check case in _require_xfs_io_command() to support syncfs

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
 common/rc | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/rc b/common/rc
index 035ad22..3133bdd 100644
--- a/common/rc
+++ b/common/rc
@@ -2106,6 +2106,10 @@ _require_xfs_io_command()
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
