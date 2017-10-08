From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] overlay/038: Miscellaneous fixes
Date: Sun,  8 Oct 2017 16:55:35 +0530
Message-ID: <20171008112535.18975-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751556AbdJHLY4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 8 Oct 2017 07:24:56 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v98BNoAN018918
        for <linux-unionfs@vger.kernel.org>; Sun, 8 Oct 2017 07:24:56 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2dfd71kb7k-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Sun, 08 Oct 2017 07:24:56 -0400
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 8 Oct 2017 07:24:55 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org, amir73il@gmail.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, eguan@redhat.com

This commit removes the redundant chown operation which was supposed to
cause the test file to be copied up. Also, _overlay_scratch_unmount() is
used to unmount the overlay filesystem rather than invoking $UMOUNT_PROG.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/overlay/038 | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tests/overlay/038 b/tests/overlay/038
index 57281fa..148995b 100755
--- a/tests/overlay/038
+++ b/tests/overlay/038
@@ -1,7 +1,7 @@
 #! /bin/bash
 # FSQA Test No. 038
 #
-# Test constant d_ino numbers
+# Test consistent d_ino numbers for samefs setup.
 #
 #-----------------------------------------------------------------------
 #
@@ -102,10 +102,8 @@ current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
 [[ $current_d == ". d" ]] || \
     echo "Before dir becomes impure: Invalid d_ino reported for ."
 
-chown -h 100 $SCRATCH_MNT/test_file
-test_file_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_file)
-
 mv $SCRATCH_MNT/test_file $impure_dir
+test_file_st_ino=$(stat -c '%i' $impure_dir/test_file)
 
 impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impure' \
 			$upperdir/test_dir/impure_dir)
@@ -187,7 +185,7 @@ parent_d=$($here/src/t_dir_type $SCRATCH_MNT/test_dir/pure_lower_dir $test_dir_s
 [[ $parent_d == ".. d" ]] || \
 	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
 
-$UMOUNT_PROG $SCRATCH_MNT
+_overlay_scratch_unmount
 
 echo "Silence is golden"
 status=0
-- 
2.9.5
