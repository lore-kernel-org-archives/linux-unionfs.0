Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389B04B1268;
	Tue, 15 Sep 2026 15:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486581; cv=none; b=mlJON6uPxbcU7WZgAqMdc8NkH8JWTm25Db9yd/sSgw9fDbISyeTwezaoU14cbgycLDiCFvqna1BKV6YPcW/XCGn5aZzBnj/hr1Bo5YddCijTjzq5Zexl7gLmob1SP5A+VXzFxr8xownvRtBIEEYCxLeY9xejyXvEEjn2I70o9Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486581; c=relaxed/simple;
	bh=0r3WEvnybFywwjgJM4MpzTe3Dh5zZmjeGi/IjhIeHUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQGLkGlAGmauShGGOPRZmUsrTu+5baAIZOBU67bvmtqp0KTlvfeS7kVUn7FPN6TZYCAd7B3tF6kz6K4lQmZEthJWv4y+ciU1p4zBXDGYwwvI19gtQFtbJpAgzBkc6RdQQwMwJotF6HKpF6lWShuscsccD9ci5IgbgZVa/Zw4bVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=u1oIKl5M; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=MvbHBITR; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="u1oIKl5M";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="MvbHBITR"
Received: from pps.filterd (m0170390.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FF798V3257281;
	Tue, 15 Sep 2026 11:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=smtpout1; bh=XZQ3ExJueATg
	4PqH6cAwCKzmdfS2G4k0F1CzE0GhWuo=; b=u1oIKl5M66JvfY2oOCG4Zscl3LZ7
	asv2Xt9sBiZdqqfhuM+kEb1GLvhA+N0vOcternT9d7TTJ2HCWmgu+wH8WBVQIOAA
	j8LYuq2HIvAf++T8XWKxeZf8Qm4DR7L86o3QSGVF56bbfC6bBc3fv9oEzRhHVDwO
	omsp+cJlwO5Y/7fTX32137jnWZBExnzYZOqvHv15NQ748+zC4yqkCEg3hiaK+8Tv
	kEvxwU8u0c0uccvXtkB1FoPcKWH6kV4ukpnodn1HRaa1fBIKheX6ZtPikzwzj++l
	NuyJmIqfvU4sqO4Qc4VajnCN1H0dKTo0jJzfMFyrj6kLkvBhGCvQmGMXvw==
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gn1sy47kf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 11:36:17 -0400 (EDT)
Received: from pps.filterd (m0144103.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FFX5E42279432;
	Tue, 15 Sep 2026 11:36:17 -0400
Received: from esapsmtpat04.us.dell.com (esapsmtpat04.us.dell.com [143.166.211.147])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 4gq6ksjp7y-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 11:36:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789486577; x=1821022577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XZQ3ExJueATg4PqH6cAwCKzmdfS2G4k0F1CzE0GhWuo=;
  b=MvbHBITR7ZH5MDgpwhWhdcqdu5LJyRFzStYRfiG7GxCx+JHa5toh6s7N
   5Gnc0r06Dup22QhIu+rX/OjVsLQmRTkG/FokxCEl4kexnKmUJrzHHIPgb
   534xC+mCgsmlqBauBTdAgxERcIPCB+G+KK8wdmcxRl2McaI0vD1U3Dx8w
   jFCEdwJQK+u0dbOGeAM+JYGsnQPcmPMt1enqfBTQS0mUNMEk4k4lCi2n+
   /OaPNMBC6+6yJTVzPB5eeHqcyUzU4Frqb/yU8eH7AhYiyS11fysLm6vVM
   I6nQ5p2aXqKqb3J8eC7+hTGvU3V+9cZB9A8JU2yOEln6MDmxWAwR86QGH
   g==;
X-CSE-ConnectionGUID: J+4ntrTlTjm+hLCwiNfdTg==
X-CSE-MsgGUID: Exh9zSptQYWYLCwCM9rC1A==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtpat04.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 15 Sep 2026 15:36:15 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 2/3] tests/overlay: use _require_scratch_overlay_features for xino
Date: Tue, 15 Sep 2026 15:36:06 +0000
Message-ID: <20260915153608.5197-3-prabhakar.pujeri@dell.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915153608.5197-1-prabhakar.pujeri@dell.com>
References: <20260915153608.5197-1-prabhakar.pujeri@dell.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_04,2026-09-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150227
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDIyOCBTYWx0ZWRfX8hy2p9TCWY9E
 tGnRQRL/ZKWD62MnCilhUpyQUM5yqSiMBGwjtJ+mE/NYMSI6vWy7eFGm3zLZrpSdhgYShfLFaN5
 zMSY6yWCsNoKW66TC246rU1R/ndWSdI=
X-Authority-Analysis: v=2.4 cv=FtyQbGrq c=1 sm=1 tr=0 ts=6aa965f1 cx=c_pps
 a=Z2e5DKjA+8LiMDv5v6mwwA==:117 a=xQoiRHjKKYbJmV+sD1MyuQ==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=sEWawkeXllE7TocFc0N_:22 a=iLNU1ar6AAAA:8
 a=wWKavpsxSNkLsbxkdx8A:9 a=hlJyneSgMmFPbskH-t2w:22
X-Proofpoint-GUID: nPWD-SoASWKplPbRMEPPSnqvx9QFj2c5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDIyOCBTYWx0ZWRfX/PU3A5Y6HdzM
 tM9mcL7/+srpbNEHdS4+MPF5hDChkj0jWay7j4B4ENeJdvF0U1kw0FTFrKd6/Rc8f1CYAy3nIvi
 hyAx9FEhkHPkfM+5absAy48rqwcci4L1If672OybNXbuhdcOMt3QcCYb3DeVLrf6m/LzyeU2aag
 n1HzhOGDNwRim0CVnicKbSnwjx90StE74PYRdNbPY1hx/PNHFFzgnSEM3jnAHHUWcQmWFw96FVM
 vFhckuuiur/bYVp1KXg0X39ZMb9CXmwU1OhYBaBVvhsfg4ZO+GnUzU8Mup9O0icZjp1SG1MJ2B1
 IN665fZ9yDG2vcAHqxEteBr5o3xziUSY9jm6k7Nv1g6lFFLAJDMjHR678PFMFxYqBEO7+rW/xMg
 /EhIHkyb0Tsx4Z+rUQrBbzMfRO4s8ar0jRR68qG2v+OJJ1UWm/AS2zs1zsy2W/xBzfAi+rgGFot
 qtWgewJ2ycbKITapXWg==
X-Proofpoint-ORIG-GUID: nPWD-SoASWKplPbRMEPPSnqvx9QFj2c5
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150228

overlay/041, 043, 044, 067, 070 and 071 open-code their xino probes:
a mount with -o xino=on|off followed by a selective grep of the mount
options.  Now that _check_overlay_feature handles param-less options,
fold all six onto _require_scratch_overlay_features xino and delete
the open-coded variants.  The behavior is unchanged - a kernel that
does not support xino rejects the probe mount and the test notruns.

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
 tests/overlay/041 |  6 ++----
 tests/overlay/043 |  6 ++----
 tests/overlay/044 |  6 ++----
 tests/overlay/067 |  4 ++--
 tests/overlay/070 |  7 ++-----
 tests/overlay/071 | 12 +++---------
 6 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/tests/overlay/041 b/tests/overlay/041
index 36491b8f..4d2c830d 100755
--- a/tests/overlay/041
+++ b/tests/overlay/041
@@ -23,6 +23,7 @@ _require_scratch_nocheck
 _require_test
 _require_attrs trusted
 _require_test_program "t_dir_type"
+_require_scratch_overlay_features xino
 
 lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
 rm -rf $lowerdir
@@ -41,10 +42,7 @@ workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 # not use bit 63 in inode number of the test files, because bit 63 is used by
 # overlayfs to indicate the layer. Let's just assume that this is true for all
 # tested filesystems and if we are wrong, the test may fail.
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o xino=on || \
-	_notrun "cannot mount overlay with xino=on option"
-_fs_options $SCRATCH_DEV | grep -q "xino=on" || \
-	_notrun "cannot enable xino feature"
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o xino=on
 
 test_dir=$SCRATCH_MNT/test_dir/
 
diff --git a/tests/overlay/043 b/tests/overlay/043
index 7325c653..efb99cd5 100755
--- a/tests/overlay/043
+++ b/tests/overlay/043
@@ -33,6 +33,7 @@ _require_test_program "af_unix"
 _require_test_program "t_dir_type"
 # Require redirect_dir for renaming a merge directory
 _require_scratch_feature redirect_dir
+_require_scratch_overlay_features xino
 
 lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
 rm -rf $lowerdir
@@ -57,10 +58,7 @@ workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 # not use bit 63 in inode number of the test files, because bit 63 is used by
 # overlayfs to indicate the layer. Let's just assume that this is true for all
 # tested filesystems and if we are wrong, the test may fail.
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o redirect_dir=on,xino=on || \
-	_notrun "cannot mount overlay with xino=on option"
-_fs_options $SCRATCH_DEV | grep -q "xino=on" || \
-	_notrun "cannot enable xino feature"
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o redirect_dir=on,xino=on
 
 FILES="dir file symlink chrdev blkdev fifo socket"
 
diff --git a/tests/overlay/044 b/tests/overlay/044
index 4d04d883..08e38dfd 100755
--- a/tests/overlay/044
+++ b/tests/overlay/044
@@ -26,6 +26,7 @@ _require_scratch_nocheck
 _require_test
 _require_scratch_feature index
 _require_test_program "t_dir_type"
+_require_scratch_overlay_features xino
 
 # Record inode numbers in format <ino> <nlink>
 function record_ino_nlink()
@@ -73,10 +74,7 @@ workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 # not use bit 63 in inode number of the test files, because bit 63 is used by
 # overlayfs to indicate the layer. Let's just assume that this is true for all
 # tested filesystems and if we are wrong, the test may fail.
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on,xino=on || \
-	_notrun "cannot mount overlay with xino=on option"
-_fs_options $SCRATCH_DEV | grep -q "xino=on" || \
-	_notrun "cannot enable xino feature"
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on,xino=on
 
 rm -f $tmp.*
 
diff --git a/tests/overlay/067 b/tests/overlay/067
index bb09a604..d3f98f17 100755
--- a/tests/overlay/067
+++ b/tests/overlay/067
@@ -25,6 +25,7 @@ _fixed_by_kernel_commit 9c6d8f13e9da \
 # them explicity after test.
 _require_scratch_nocheck
 _require_test
+_require_scratch_overlay_features xino
 
 # Lower is on test partition
 lower=$OVL_BASE_TEST_DIR/$OVL_LOWER-$seq
@@ -47,8 +48,7 @@ echo wrong > $realfile
 # Mount an overlay on $SCRATCH_MNT with lower layer on test partition
 # and middle and upper layer on scratch partition.
 # Disable xino, so not all overlay inodes are on the same st_dev.
-_overlay_scratch_mount_dirs $middle:$lower $upper $work -o xino=off || \
-	_notrun "cannot mount overlay with xino=off option"
+_overlay_scratch_mount_dirs $middle:$lower $upper $work -o xino=off
 
 stat $realfile >>$seqres.full
 stat $testfile >>$seqres.full
diff --git a/tests/overlay/070 b/tests/overlay/070
index 36991229..c64e7907 100755
--- a/tests/overlay/070
+++ b/tests/overlay/070
@@ -41,7 +41,7 @@ _require_test_program "t_dir_type"
 _require_command "$FLOCK_PROG" "flock"
 # We need to require all features together, because nfs_export cannot
 # be enabled when index is disabled
-_require_scratch_overlay_features index nfs_export redirect_dir
+_require_scratch_overlay_features index nfs_export redirect_dir xino
 _require_loop
 
 lower=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
@@ -83,10 +83,7 @@ mount_dirs()
 	# overlayfs to indicate the layer. Let's just assume that this is true for all
 	# tested filesystems and if we are wrong, the test may fail.
 	_overlay_mount_dirs $SCRATCH_MNT $upper2 $work2 overlay2 $mnt2 \
-		-o "redirect_dir=on,index=on,xino=on" || \
-		_notrun "cannot mount nested overlay with xino=on option"
-	_fs_options overlay2 | grep -q "xino=on" || \
-		_notrun "cannot enable xino feature on nested overlay"
+		-o "redirect_dir=on,index=on,xino=on"
 }
 
 # Unmount the nested overlay mount and check underlying overlay layers
diff --git a/tests/overlay/071 b/tests/overlay/071
index 2a631314..ef429d41 100755
--- a/tests/overlay/071
+++ b/tests/overlay/071
@@ -45,7 +45,7 @@ _require_test_program "t_dir_type"
 _require_command "$FLOCK_PROG" "flock"
 # We need to require all features together, because nfs_export cannot
 # be enabled when index is disabled
-_require_scratch_overlay_features index nfs_export redirect_dir
+_require_scratch_overlay_features index nfs_export redirect_dir xino
 _require_loop
 
 # Lower overlay lower layer is on test fs, upper is on scratch fs
@@ -81,10 +81,7 @@ mount_dirs()
 {
 	# Mount the underlying overlay with file handle support
 	_overlay_mount_dirs $lower $upper $work overlay1 $SCRATCH_MNT \
-		-o "index=on,nfs_export=on,xino=on" || \
-                _notrun "cannot mount overlay with xino=on option"
-	_fs_options overlay1 | grep -q "xino=on" || \
-		_notrun "cannot enable xino feature on overlay"
+		-o "index=on,nfs_export=on,xino=on"
 
 	# Mount the nested overlay
 	# Enable redirect_dir for renaming a merge directory.
@@ -93,10 +90,7 @@ mount_dirs()
 	# overlayfs to indicate the layer. Let's just assume that this is true for all
 	# tested filesystems and if we are wrong, the test may fail.
 	_overlay_mount_dirs $SCRATCH_MNT $upper2 $work2 overlay2 $mnt2 \
-		-o "redirect_dir=on,index=on,xino=on" || \
-		_notrun "cannot mount nested overlay with xino=on option"
-	_fs_options overlay2 | grep -q "xino=on" || \
-		_notrun "cannot enable xino feature on nested overlay"
+		-o "redirect_dir=on,index=on,xino=on"
 }
 
 # Unmount the nested overlay mount and check underlying overlay layers
-- 
2.55.0

