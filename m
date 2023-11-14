Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7D3C4167B
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 06:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjKNGtK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 01:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjKNGtJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 01:49:09 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1397D45;
        Mon, 13 Nov 2023 22:49:05 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40806e4106dso30391835e9.1;
        Mon, 13 Nov 2023 22:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699944544; x=1700549344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZVf9DL80qWypckzs4NLQwWSEKE0rR0qyUo3ts621uw=;
        b=JOzitWkCIssFtQT3mj7X4bnYuwBEDT0jDpLYFmJUZFO8eJx4kXMjlduJfxajNJC4xe
         UypwKyP/V28FzOKb3q9rv1Pa8Kk+yxqyrqQHGrT8zZRTtwZq/XLqsUqD4Mj/O5jrIpLj
         LIiKq508y0X4aaElVRBNlvnCcV+P0R8sJPpS9dMdec0H/6AgwRrxPNxkVdDgXYRiVCGd
         XSWRxF6Vt53SF/ghgO3q6/DXlOYduSXSoU69L7yFoVi4Tn9X8oT2jgRz8HJ2lYvRxyVn
         7d+PedQo2KoGUWyXABDkgWG+U2c8f6CVnCSDau1efJAHIiUS4sZwLaptfrZnOpSRxxPt
         CFxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699944544; x=1700549344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zZVf9DL80qWypckzs4NLQwWSEKE0rR0qyUo3ts621uw=;
        b=AOCZWl8cHaB6B8w0K28d2htq1m4JuMXR5/K2F1GupgxQQgcG+i/5jNJDhPh1Jh5wtf
         UjKil5qM1X7ObUA4UxisGb8g8Rx5lNqUxi5icra4YnFOrTgOkpu/frsRRskgyEwL0s3w
         B3R/+5pa6O85obQc5aZX+vDxcPRN1JABYs/9Ty0YfqkenPxXWAMG68jFyn+ZZv7g04yN
         j41KbofLTUFmHGB3wEZaAyn0Cm7W3HER4p4RjrRyaRCGm8sCTCdiHf6L+AtcuSjokF/N
         WyU9OAnDGNuS6rdkQAMUjPHe098qXLZmUiYPGrlWzPQx75u8kHbIgUISXF/auGZ30pvK
         Af5g==
X-Gm-Message-State: AOJu0YzimDYrnGQA7SDoz/J+gRx2f10hKGVoFzui7mjqNUU3h4jcnHQR
        Ef+UOzdtv6YMoW95J2okLuY=
X-Google-Smtp-Source: AGHT+IFFUa9cl6KjETzEdj4z5z/fDAwA8G5TNwtsksKeaBA5Zol86thIKCOgCoPRvhOtAMKKVRsoYQ==
X-Received: by 2002:a05:600c:5390:b0:407:73fc:6818 with SMTP id hg16-20020a05600c539000b0040773fc6818mr1244712wmb.2.1699944543996;
        Mon, 13 Nov 2023 22:49:03 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id p17-20020a05600c469100b004064e3b94afsm16338917wmo.4.2023.11.13.22.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 22:49:03 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 2/4] overlay: prepare for new lowerdir+,datadir+ tests
Date:   Tue, 14 Nov 2023 08:48:55 +0200
Message-Id: <20231114064857.1666718-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114064857.1666718-1-amir73il@gmail.com>
References: <20231114064857.1666718-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In preparation to forking tests for new lowerdir+,datadir+ mount options,
prepare a helper to test kernel support and pass datadirs into mount
helpers in overlay/079 test.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay    | 15 +++++++++++++++
 tests/overlay/079 | 36 +++++++++++++++++++++---------------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/common/overlay b/common/overlay
index f6017e4e..028019ce 100644
--- a/common/overlay
+++ b/common/overlay
@@ -240,6 +240,21 @@ _require_scratch_overlay_lowerdata_layers()
 	_scratch_unmount
 }
 
+# Check kernel support for lowerdir+=<lowerdir>,datadir+=<lowerdatadir> format
+_require_scratch_overlay_lowerdir_add_layers()
+{
+	local lowerdir="$OVL_BASE_SCRATCH_MNT/$OVL_UPPER"
+	local datadir="$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
+
+	_scratch_mkfs > /dev/null 2>&1
+	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+		-o"lowerdir+=$lowerdir,datadir+=$datadir" \
+		-o"redirect_dir=follow,metacopy=on" > /dev/null 2>&1 || \
+	        _notrun "overlay lowerdir+,datadir+ not supported on ${SCRATCH_DEV}"
+
+	_scratch_unmount
+}
+
 # Helper function to check underlying dirs of overlay filesystem
 _overlay_fsck_dirs()
 {
diff --git a/tests/overlay/079 b/tests/overlay/079
index 77f94598..078ee816 100755
--- a/tests/overlay/079
+++ b/tests/overlay/079
@@ -139,16 +139,21 @@ check_file_size_contents()
 
 mount_overlay()
 {
-	local _lowerdir=$1
+	local _lowerdir=$1 _datadir2=$2 _datadir=$3
 
-	_overlay_scratch_mount_dirs "$_lowerdir" $upperdir $workdir -o redirect_dir=on,index=on,metacopy=on
+	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+		-o"lowerdir=$_lowerdir::$_datadir2::$_datadir" \
+		-o"upperdir=$upperdir,workdir=$workdir" \
+		-o redirect_dir=on,metacopy=on
 }
 
 mount_ro_overlay()
 {
-	local _lowerdir=$1
+	local _lowerdir=$1 _datadir2=$2 _datadir=$3
 
-	_overlay_scratch_mount_dirs "$_lowerdir" "-" "-" -o ro,redirect_dir=follow,metacopy=on
+	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+		-o"lowerdir=$_lowerdir::$_datadir2::$_datadir" \
+		-o redirect_dir=follow,metacopy=on
 }
 
 umount_overlay()
@@ -160,14 +165,14 @@ test_no_access()
 {
 	local _target=$1
 
-	mount_ro_overlay "$lowerdir::$datadir2::$datadir"
+	mount_ro_overlay "$lowerdir" "$datadir2" "$datadir"
 
 	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
 		echo "No access to lowerdata layer $_target"
 
 	echo "Unmount and Mount rw"
 	umount_overlay
-	mount_overlay "$lowerdir::$datadir2::$datadir"
+	mount_overlay "$lowerdir" "$datadir2" "$datadir"
 	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
 		echo "No access to lowerdata layer $_target"
 	umount_overlay
@@ -175,11 +180,12 @@ test_no_access()
 
 test_common()
 {
-	local _lowerdirs=$1 _target=$2 _size=$3 _blocks=$4 _data="$5"
-	local _redirect=$6
+	local _lowerdir=$1 _datadir2=$2 _datadir=$3
+	local _target=$4 _size=$5 _blocks=$6 _data="$7"
+	local _redirect=$8
 
 	echo "Mount ro"
-	mount_ro_overlay $_lowerdirs
+	mount_ro_overlay $_lowerdir $_datadir2 $_datadir
 
 	# Check redirect xattr to lowerdata
 	[ -n "$_redirect" ] && check_redirect $lowerdir/$_target "$_redirect"
@@ -191,7 +197,7 @@ test_common()
 	# Do a mount cycle and check size and contents again.
 	echo "Unmount and Mount rw"
 	umount_overlay
-	mount_overlay $_lowerdirs
+	mount_overlay $_lowerdir $_datadir2 $_datadir
 	echo "check properties of metadata copied up file $_target"
 	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
 	check_file_blocks $SCRATCH_MNT/$_target $_blocks
@@ -203,7 +209,7 @@ test_common()
 	check_file_size_contents $upperdir/$_target $_size ""
 
 	# Trigger data copy up and check absence of metacopy xattr.
-	mount_overlay $_lowerdirs
+	mount_overlay $_lowerdir $_datadir2 $_datadir
 	$XFS_IO_PROG -c "falloc 0 1" $SCRATCH_MNT/$_target >> $seqres.full
 	echo "check properties of data copied up file $_target"
 	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
@@ -216,7 +222,7 @@ test_lazy()
 {
 	local _target=$1
 
-	mount_overlay "$lowerdir::$datadir2::$datadir"
+	mount_overlay "$lowerdir" "$datadir2" "$datadir"
 
 	# Metadata should be valid
 	check_file_size $SCRATCH_MNT/$_target $datasize
@@ -305,12 +311,12 @@ test_no_access "$sharedname"
 
 echo -e "\n== Check follow to lowerdata layer with absolute redirect =="
 prepare_midlayer "/subdir/$dataname"
-test_common "$lowerdir::$datadir2::$datadir" "$dataname" $datasize $datablocks \
+test_common "$lowerdir" "$datadir2" "$datadir" "$dataname" $datasize $datablocks \
 		"$datacontent" "/subdir/$dataname"
-test_common "$lowerdir::$datadir2::$datadir" "$dataname2" $datasize $datablocks \
+test_common "$lowerdir" "$datadir2" "$datadir" "$dataname2" $datasize $datablocks \
 		"$datacontent2" "/subdir/$dataname.2"
 # Shared file should be picked from upper datadir
-test_common "$lowerdir::$datadir2::$datadir" "$sharedname" $datasize $datablocks \
+test_common "$lowerdir" "$datadir2" "$datadir" "$sharedname" $datasize $datablocks \
 		"$datacontent2" "/subdir/$dataname.shared"
 
 echo -e "\n== Check lazy follow to lowerdata layer =="
-- 
2.34.1

