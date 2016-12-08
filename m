From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] common: implement _require_xfs_io_command "open"
Date: Thu,  8 Dec 2016 12:52:20 +0200
Message-ID: <1481194341-3592-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:33654 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751987AbcLHKwn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Dec 2016 05:52:43 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

-c "open $f" is broken in xfs_io <= 4.8. Using it results
in an endless loop and xfs_io exists with error EMFILE.

A fix for that bug makes "open" a 'one shot' command.
Along with this fix, a new -C flag was introduced to explicitly
request to execute a one shot command.

Check for -C flag support as an indication that -c "open $f"
is not broken.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/common/rc b/common/rc
index 2719b23..cd2e8eb 100644
--- a/common/rc
+++ b/common/rc
@@ -1757,6 +1757,14 @@ _require_xfs_io_command()
 		echo $testio | egrep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"open")
+		# -c "open $f" is broken in xfs_io <= 4.8. Along with the fix,
+		# a new -C flag was introduced to execute one shot commands.
+		# Check for -C flag support as an indication for the bug fix.
+		testio=`$XFS_IO_PROG -F -f -C "open $testfile" $testfile 2>&1`
+		echo $testio | egrep -q "invalid option" && \
+			_notrun "xfs_io $command support is missing"
+		;;
 	*)
 		testio=`$XFS_IO_PROG -c "$command help" 2>&1`
 	esac
-- 
2.7.4
