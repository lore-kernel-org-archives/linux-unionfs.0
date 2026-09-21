Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034DC26ED3E;
	Mon, 21 Sep 2026 07:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.133.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975024; cv=none; b=e3uQv6FsLgYNuASVXpGzR7LbQOCP9vRy1WjPQWqg2yMly3YnegxfPHyxHBbTdBhg5E//F0g/WdYDE8G3WzELdxDKtRjqBss2sDIP3vjG2V+1olpGcgeoW/HJw5HvWt2Sjllk6LxcIat+ayM7fnq59pfWvNi9GfiKk95LilJei+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975024; c=relaxed/simple;
	bh=wX+T+5bss7SYDef/bDmR1258XXi2/+rSew2Z1OPIayA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ufig9raQep7LJzmIqL87Ko53TwsDb9zESLYx81ON4XYpopVekUnh9ihEGQZWKlVZsT13kRe5gm0pP1zYJTHz80Cvh9F4wxnH36h9FkQ9UMIMvHr1Elts4Xr0Y8kogyxDeJHRae6YHdbB+DP22iaFAgkkMUpNpnujyumNgABQxPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=XootSZ+J; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=pptr8ey/; arc=none smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="XootSZ+J";
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="pptr8ey/"
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L79FE1189996;
	Mon, 21 Sep 2026 03:17:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=smtpout1; bh=XXDxagjGLUTn
	ZnUyPYN+kJI5j+zNwiNB6PCbP/CQfzE=; b=XootSZ+JxcJSLG3JWQcx6/g0xuVy
	45qhvkDjPJU2hlLbouFv6LXuNIoReGCXK1O0eqT6yR+LfeMmQDTW2wqjBjqdk10M
	YaolKvgnTrqMMUc7AF4NO8rscqnMeScrUplJJA3oHXv8noGwuMCQLUfl3eEKp4+x
	ZV9bTMzwEJaF+sNucXDLjD4cE4+qFWixIBORGvFO8RYkyUxOZ5BIrnR3lb1FrH4H
	BkNNXZeKBRMlRJI7X3gzHeGY4EelePZhrD+JpYhqTVfsVzTtMePyKygCtgdYVjI/
	1LNp0IBLmPjilHospx6mvMnMCIleA7nrhMBcQ2jjNDbVQbsB0rj33d0Wwg==
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 4gsnj6500e-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 03:17:02 -0400 (EDT)
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L78iaF2613475;
	Mon, 21 Sep 2026 03:17:01 -0400
Received: from esapsmtplv03.us.dell.com (esapsmtplv03.us.dell.com [143.166.203.148])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 4gty35rrf8-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Mon, 21 Sep 2026 03:17:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=dell.com; i=@dell.com; q=dns/txt; s=smtpdev1;
  t=1789975022; x=1821511022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XXDxagjGLUTnZnUyPYN+kJI5j+zNwiNB6PCbP/CQfzE=;
  b=pptr8ey/L+AhpWwTpEw3LsB9tUht52nVsVWToFpYicgTpgrx47DwYIE7
   2K/cpqjClOxIanHXzBgsvwm/RUHi7j+6K1hc2ZJkLn3G/aXE6BmwINUdF
   0AkqtmgHbB9Gs3/EUx/Fnsy2LhAJbQ3T0Xr6/Gv9Syyu3yJJYgmO4EAim
   eViv7OM8SKz9b+ZDSkWPI4vYUArTWPQcWurAkIaVujiSUVn7ODeP2hVn7
   oBvNqPEtNu+nGc56zD0W08WxpiOiasUFrKRqhCDux5yiY4FIZG+2i1zpE
   V2ykWnvv6KVxEnvcUiCUAXk5gjhxzMdtAwkHybLmZlvZ0M+cIsNStidPf
   Q==;
X-CSE-ConnectionGUID: 09KcFV9gRCCMbiT8hY0lSw==
X-CSE-MsgGUID: 8F8zL/yRSC68KsUn66wojQ==
X-LoopCount0: from 10.94.9.174
X-MS-Exchange-CrossPremises-AuthAs: Internal
Received: from w-96j1th4.apac.dell.com (HELO W-96J1TH4.blr.amer.dell.com) ([10.94.9.174])
  by esapsmtplv03.us.dell.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 Sep 2026 07:16:59 +0000
From: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
To: fstests@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
        Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 2/3] tests/overlay: use _require_scratch_overlay_features for xino
Date: Mon, 21 Sep 2026 07:16:50 +0000
Message-ID: <20260921071651.25862-3-prabhakar.pujeri@dell.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921071651.25862-1-prabhakar.pujeri@dell.com>
References: <20260921071651.25862-1-prabhakar.pujeri@dell.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609210102
X-Proofpoint-ORIG-GUID: pxH7qvVg1rKJIc5Xr4lGekvccrWf_VTy
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEwMSBTYWx0ZWRfXwmp+8gFYc/in
 Jkt83/AFH2jokcRY5L7e3JvgA28fAZ+dwp4l+1sdDDAsw9zNfc4JNuuHe64pka+fLDj0r9uTrDz
 0NnQd4a1bCcfN0SQMhopGu+iFN1QtF8=
X-Proofpoint-GUID: pxH7qvVg1rKJIc5Xr4lGekvccrWf_VTy
X-Authority-Analysis: v=2.4 cv=aoknmiZV c=1 sm=1 tr=0 ts=6ab0d9ee cx=c_pps
 a=j0++y401J6f/BxNAf5EDow==:117 a=iGMIhCliR854E25UHWhNxg==:17
 a=VdqzKS8jKosA:10 a=ke5jqHz-1hQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6gNNCFAoQcIphELLPWWu:22 a=m3zZTHMLHbwB7Lmtoed2:22 a=pGLkceISAAAA:8
 a=iLNU1ar6AAAA:8 a=wWKavpsxSNkLsbxkdx8A:9 a=gbU3OgOOxF9bX48Letew:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEwMSBTYWx0ZWRfXxwg2IFrCo6C/
 MNH5nIOolorAoTCJRo1GMBv5r+WgA4LISyAufarTsM2k1k85VIcbls8E/YerwN/kr8wl87mfgcY
 oKYXUkJoippVtXTsklgHqNZDZEs+3P00Bq8qJ0lW/GSEjD0UNZhBPyAhjKMKxI3bCoOz++ukqy7
 uRPRo9ixomq4TCuh15za0cvvj2hCSn7GUV91yh3vY+nTlfeLmJdCJNM3MuTO1EPu2ZVrNr9IZL0
 csobs5cE15w4AjS0gQJCkpp3+9omJSij72ICXSAbIWbdGzeipxJn69mgSkVicp6SPr82GbwN575
 n5shBOBCLYuAcRc8mldOw0ME27AjL3jIlpy0PmgEUB4DUSBMOPFyPBR/0VUERnFmHetKwbVCPMg
 zM9HjQtVQSL6y7MpSdemb/mJSre/qnz9qVQQTI7oFBSYkmm5PvbZ+QDhkQexuqOpfYzXxOyQNYH
 70yPJ1JeNNQ10Vfb/2w==
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0
 spamscore=0 adultscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210101

overlay/041, 043, 044, 067, 070 and 071 open-code their xino probes:
a mount with -o xino=on|off followed by a selective grep of the mount
options.  Now that _check_overlay_feature handles param-less options,
fold all six onto _require_scratch_overlay_features xino and delete
the open-coded variants.  The behavior is unchanged - a kernel that
does not support xino rejects the probe mount and the test notruns.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
---
Changes in v2:
- No code change.
- Add Amir's Reviewed-by.
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

