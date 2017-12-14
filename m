From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v4 2/3] common/rc: check syncfs support
Date: Thu, 14 Dec 2017 22:19:04 +0800
Message-ID: <1513261145-127502-2-git-send-email-cgxu519@icloud.com>
References: <1513261145-127502-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:26585 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752690AbdLNOVB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 09:21:01 -0500
In-Reply-To: <1513261145-127502-1-git-send-email-cgxu519@icloud.com>
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
index fc9a4f5..da7c827 100644
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
