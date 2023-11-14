Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A295BC4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 06:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjKNGtM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 01:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjKNGtL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 01:49:11 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BE6D44;
        Mon, 13 Nov 2023 22:49:07 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2c788f5bf53so56912291fa.2;
        Mon, 13 Nov 2023 22:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699944545; x=1700549345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UfDXBa14ns5s9JcVo9HU0xMCh1R5d4DPkqc4xRiVgY=;
        b=a9OGFM/aePGbKPeFlJlh9xltSivYbc8Ue38wKfKtaU7enkJC+SLApKZ/ROfFylW8M+
         2m0APSqIfPW7/2UfTik3QMrZeYyGnuv3zULoAxJ21qoW7BiW+Q3Hp313YOFXwmyQgu8r
         V4ZF+Jov6zpX3uHaeqtnccd1G/sRsktzWvv/ueetKjFR8BRmdzBXXBr4QGbRWDlEQf1x
         6ynG4XfTLGcdyOC+U5CJpFKg8KikxNOSuy/mT5M0UoEbMcApOuoj+bHyeJEZPsTeXSkq
         zdG8XYGCGfgc4ZCWbuddvr+NbIySjzn3x06LCyQpigskoJqUv1VVc/8Pr9uKaX7Zj7FG
         5fQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699944545; x=1700549345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5UfDXBa14ns5s9JcVo9HU0xMCh1R5d4DPkqc4xRiVgY=;
        b=YcIke5095I49dFAUxukVF/wLjGec1miRdsKUTRTzdZ2NBzM4yNEcCJORihTMN9S9rn
         3S6fiR8JvfyKPC3ov4o7rXiQ0p8SgNi1raOIS1Erh9j1LlOPvVxvYJq0j43BzG/8jL11
         M1x5SEFtWXZkQNizAY2iSwn2n8LURuMRluFcWaHTb3UP8ykPIVeE4HnBuye9xaYp/ajY
         gzbmGfjcnT7anFSfC3YoEIypGHNL4fzB6twdpxo7OnjQpPgxKN4GoGOcIec0wdVJZVnI
         4eFO9EkiCJCAwdZNmEMqsfBR1wGSHdtoSfulVR53s2D8IdtWfLAtzZ15kybaC/WkkhI7
         8mCA==
X-Gm-Message-State: AOJu0YzvqULJICIMsAhQchudgUpnfSdGaAndaGlNmVpT/rdaGbhQvwYG
        LuBlT0rx2ukB1BVlnJlGZu2rnsFHyV8=
X-Google-Smtp-Source: AGHT+IG1Qgl2rxQj3BTLgKKZ8o+tUUk2rKmNJNGOXNC4YoyeiK78kMDViMF1AvcB+MrYbDop6jVgBQ==
X-Received: by 2002:a05:651c:332:b0:2b6:fa3f:9230 with SMTP id b18-20020a05651c033200b002b6fa3f9230mr854767ljp.46.1699944545282;
        Mon, 13 Nov 2023 22:49:05 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id p17-20020a05600c469100b004064e3b94afsm16338917wmo.4.2023.11.13.22.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 22:49:04 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 3/4] overlay: test data-only lowerdirs with datadir+ mount option
Date:   Tue, 14 Nov 2023 08:48:56 +0200
Message-Id: <20231114064857.1666718-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114064857.1666718-1-amir73il@gmail.com>
References: <20231114064857.1666718-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Fork test overlay/079 to use the new lowerdir+,datadir+ mount options.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/085     | 332 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/085.out |  42 ++++++
 2 files changed, 374 insertions(+)
 create mode 100755 tests/overlay/085
 create mode 100644 tests/overlay/085.out

diff --git a/tests/overlay/085 b/tests/overlay/085
new file mode 100755
index 00000000..07a32c24
--- /dev/null
+++ b/tests/overlay/085
@@ -0,0 +1,332 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test No. 085
+#
+# Test data-only layers functionality.
+# This is a variant of test overlay/079 with lowerdir+,datadir+ mount options
+#
+. ./common/preamble
+_begin_fstest auto quick metacopy redirect prealloc
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs overlay
+# We use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
+_require_scratch_overlay_features redirect_dir metacopy
+_require_scratch_overlay_lowerdir_add_layers
+_require_xfs_io_command "falloc"
+
+# remove all files from previous tests
+_scratch_mkfs
+
+# File size on lower
+dataname="datafile"
+sharedname="shared"
+datacontent="data"
+dataname2="datafile2"
+datacontent2="data2"
+datasize="4096"
+
+# Number of blocks allocated by filesystem on lower. Will be queried later.
+datarblocks=""
+datarblocksize=""
+estimated_datablocks=""
+
+udirname="pureupper"
+ufile="upperfile"
+
+# Check metacopy xattr
+check_metacopy()
+{
+	local target=$1 exist=$2
+	local out_f target_f
+	local msg
+
+	out_f=$(_getfattr --absolute-names --only-values -n \
+		$OVL_XATTR_METACOPY $target 2>&1 | _filter_scratch)
+
+	if [ "$exist" == "y" ];then
+		[ "$out_f" == "" ] && return
+		echo "Metacopy xattr does not exist on ${target}. stdout=$out_f"
+		return
+	fi
+
+	if [ "$out_f" == "" ];then
+		echo "Metacopy xattr exists on ${target} unexpectedly."
+		return
+	fi
+
+	target_f=`echo $target | _filter_scratch`
+	msg="$target_f: trusted.overlay.metacopy: No such attribute"
+
+	[ "$out_f" == "$msg" ] && return
+
+	echo "Error while checking xattr on ${target}. stdout=$out"
+}
+
+# Check redirect xattr
+check_redirect()
+{
+	local target=$1
+	local expect=$2
+
+	value=$(_getfattr --absolute-names --only-values -n \
+		$OVL_XATTR_REDIRECT $target)
+
+	[[ "$value" == "$expect" ]] || echo "Redirect xattr incorrect. Expected=\"$expect\", actual=\"$value\""
+}
+
+# Check size
+check_file_size()
+{
+	local target=$1 expected_size=$2 actual_size
+
+	actual_size=$(_get_filesize $target)
+
+	[ "$actual_size" == "$expected_size" ] || echo "Expected file size $expected_size but actual size is $actual_size"
+}
+
+check_file_blocks()
+{
+	local target=$1 expected_blocks=$2 nr_blocks
+
+	nr_blocks=$(stat -c "%b" $target)
+
+	[ "$nr_blocks" == "$expected_blocks" ] || echo "Expected $expected_blocks blocks but actual number of blocks is ${nr_blocks}."
+}
+
+check_file_contents()
+{
+	local target=$1 expected=$2
+	local actual target_f
+
+	target_f=`echo $target | _filter_scratch`
+
+	read actual<$target
+
+	[ "$actual" == "$expected" ] || echo "Expected file $target_f contents to be \"$expected\" but actual contents are \"$actual\""
+}
+
+check_no_file_contents()
+{
+	local target=$1
+	local actual target_f out_f
+
+	target_f=`echo $target | _filter_scratch`
+	out_f=`cat $target 2>&1 | _filter_scratch`
+	msg="cat: $target_f: No such file or directory"
+
+	[ "$out_f" == "$msg" ] && return
+
+	echo "$target_f unexpectedly has content"
+}
+
+
+check_file_size_contents()
+{
+	local target=$1 expected_size=$2 expected_content=$3
+
+	check_file_size $target $expected_size
+	check_file_contents $target $expected_content
+}
+
+mount_overlay()
+{
+	local _lowerdir=$1 _datadir2=$2 _datadir=$3
+
+	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+		-o"lowerdir+=$_lowerdir,datadir+=$_datadir2,datadir+=$_datadir" \
+		-o"upperdir=$upperdir,workdir=$workdir" \
+		-o redirect_dir=on,metacopy=on
+}
+
+mount_ro_overlay()
+{
+	local _lowerdir=$1 _datadir2=$2 _datadir=$3
+
+	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+		-o"lowerdir+=$_lowerdir,datadir+=$_datadir2,datadir+=$_datadir" \
+		-o redirect_dir=follow,metacopy=on
+}
+
+umount_overlay()
+{
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+test_no_access()
+{
+	local _target=$1
+
+	mount_ro_overlay "$lowerdir" "$datadir2" "$datadir"
+
+	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
+		echo "No access to lowerdata layer $_target"
+
+	echo "Unmount and Mount rw"
+	umount_overlay
+	mount_overlay "$lowerdir" "$datadir2" "$datadir"
+	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
+		echo "No access to lowerdata layer $_target"
+	umount_overlay
+}
+
+test_common()
+{
+	local _lowerdir=$1 _datadir2=$2 _datadir=$3
+	local _target=$4 _size=$5 _blocks=$6 _data="$7"
+	local _redirect=$8
+
+	echo "Mount ro"
+	mount_ro_overlay $_lowerdir $_datadir2 $_datadir
+
+	# Check redirect xattr to lowerdata
+	[ -n "$_redirect" ] && check_redirect $lowerdir/$_target "$_redirect"
+
+	echo "check properties of metadata copied up file $_target"
+	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
+	check_file_blocks $SCRATCH_MNT/$_target $_blocks
+
+	# Do a mount cycle and check size and contents again.
+	echo "Unmount and Mount rw"
+	umount_overlay
+	mount_overlay $_lowerdir $_datadir2 $_datadir
+	echo "check properties of metadata copied up file $_target"
+	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
+	check_file_blocks $SCRATCH_MNT/$_target $_blocks
+
+	# Trigger metadata copy up and check existence of metacopy xattr.
+	chmod 400 $SCRATCH_MNT/$_target
+	umount_overlay
+	check_metacopy $upperdir/$_target "y"
+	check_file_size_contents $upperdir/$_target $_size ""
+
+	# Trigger data copy up and check absence of metacopy xattr.
+	mount_overlay $_lowerdir $_datadir2 $_datadir
+	$XFS_IO_PROG -c "falloc 0 1" $SCRATCH_MNT/$_target >> $seqres.full
+	echo "check properties of data copied up file $_target"
+	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
+	umount_overlay
+	check_metacopy $upperdir/$_target "n"
+	check_file_size_contents $upperdir/$_target $_size "$_data"
+}
+
+test_lazy()
+{
+	local _target=$1
+
+	mount_overlay "$lowerdir" "$datadir2" "$datadir"
+
+	# Metadata should be valid
+	check_file_size $SCRATCH_MNT/$_target $datasize
+	check_file_blocks $SCRATCH_MNT/$_target $estimated_datablocks
+
+	# But have no content
+	check_no_file_contents $SCRATCH_MNT/$_target
+
+	umount_overlay
+}
+
+create_basic_files()
+{
+	_scratch_mkfs
+	mkdir -p $datadir/subdir $datadir2/subdir $lowerdir $lowerdir2 $upperdir $workdir $workdir2
+	mkdir -p $upperdir/$udirname
+	echo "$datacontent" > $datadir/$dataname
+	chmod 600 $datadir/$dataname
+	echo "$datacontent2" > $datadir2/$dataname2
+	chmod 600 $datadir2/$dataname2
+
+	echo "$datacontent" > $datadir/$sharedname
+	echo "$datacontent2" > $datadir2/$sharedname
+	chmod 600 $datadir/$sharedname  $datadir2/$sharedname
+
+	# Create files of size datasize.
+	for f in $datadir/$dataname $datadir2/$dataname2 $datadir/$sharedname $datadir2/$sharedname; do
+		$XFS_IO_PROG -c "falloc 0 $datasize" $f
+		$XFS_IO_PROG -c "fsync" $f
+	done
+
+	# Query number of block
+	datablocks=$(stat -c "%b" $datadir/$dataname)
+
+	# For lazy lookup file the block count is estimated based on size and block size
+	datablocksize=$(stat -c "%B" $datadir/$dataname)
+	estimated_datablocks=$(( ($datasize + $datablocksize - 1)/$datablocksize ))
+}
+
+prepare_midlayer()
+{
+	local _redirect=$1
+
+	_scratch_mkfs
+	create_basic_files
+	if [ -n "$_redirect" ]; then
+		mv "$datadir/$dataname" "$datadir/$_redirect"
+		mv "$datadir2/$dataname2" "$datadir2/$_redirect.2"
+		mv "$datadir/$sharedname" "$datadir/$_redirect.shared"
+		mv "$datadir2/$sharedname" "$datadir2/$_redirect.shared"
+	fi
+	# Create midlayer
+	_overlay_scratch_mount_dirs $datadir2:$datadir $lowerdir $workdir2 -o redirect_dir=on,index=on,metacopy=on
+	# Trigger a metacopy with or without redirect
+	if [ -n "$_redirect" ]; then
+		mv "$SCRATCH_MNT/$_redirect" "$SCRATCH_MNT/$dataname"
+		mv "$SCRATCH_MNT/$_redirect.2" "$SCRATCH_MNT/$dataname2"
+		mv "$SCRATCH_MNT/$_redirect.shared" "$SCRATCH_MNT/$sharedname"
+	else
+		chmod 400 $SCRATCH_MNT/$dataname
+		chmod 400 $SCRATCH_MNT/$dataname2
+		chmod 400 $SCRATCH_MNT/$sharedname
+	fi
+	umount_overlay
+}
+
+# Create test directories
+datadir=$OVL_BASE_SCRATCH_MNT/data
+datadir2=$OVL_BASE_SCRATCH_MNT/data2
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
+
+echo -e "\n== Check no follow to lowerdata layer without redirect =="
+prepare_midlayer
+test_no_access "$dataname"
+test_no_access "$dataname2"
+test_no_access "$sharedname"
+
+echo -e "\n== Check no follow to lowerdata layer with relative redirect =="
+prepare_midlayer "$dataname.renamed"
+test_no_access "$dataname"
+test_no_access "$dataname2"
+test_no_access "$sharedname"
+
+echo -e "\n== Check follow to lowerdata layer with absolute redirect =="
+prepare_midlayer "/subdir/$dataname"
+test_common "$lowerdir" "$datadir2" "$datadir" "$dataname" $datasize $datablocks \
+		"$datacontent" "/subdir/$dataname"
+test_common "$lowerdir" "$datadir2" "$datadir" "$dataname2" $datasize $datablocks \
+		"$datacontent2" "/subdir/$dataname.2"
+# Shared file should be picked from upper datadir
+test_common "$lowerdir" "$datadir2" "$datadir" "$sharedname" $datasize $datablocks \
+		"$datacontent2" "/subdir/$dataname.shared"
+
+echo -e "\n== Check lazy follow to lowerdata layer =="
+
+prepare_midlayer "/subdir/$dataname"
+rm $datadir/subdir/$dataname
+test_lazy $dataname
+
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/085.out b/tests/overlay/085.out
new file mode 100644
index 00000000..4b9b2d7c
--- /dev/null
+++ b/tests/overlay/085.out
@@ -0,0 +1,42 @@
+QA output created by 085
+
+== Check no follow to lowerdata layer without redirect ==
+No access to lowerdata layer datafile
+Unmount and Mount rw
+No access to lowerdata layer datafile
+No access to lowerdata layer datafile2
+Unmount and Mount rw
+No access to lowerdata layer datafile2
+No access to lowerdata layer shared
+Unmount and Mount rw
+No access to lowerdata layer shared
+
+== Check no follow to lowerdata layer with relative redirect ==
+No access to lowerdata layer datafile
+Unmount and Mount rw
+No access to lowerdata layer datafile
+No access to lowerdata layer datafile2
+Unmount and Mount rw
+No access to lowerdata layer datafile2
+No access to lowerdata layer shared
+Unmount and Mount rw
+No access to lowerdata layer shared
+
+== Check follow to lowerdata layer with absolute redirect ==
+Mount ro
+check properties of metadata copied up file datafile
+Unmount and Mount rw
+check properties of metadata copied up file datafile
+check properties of data copied up file datafile
+Mount ro
+check properties of metadata copied up file datafile2
+Unmount and Mount rw
+check properties of metadata copied up file datafile2
+check properties of data copied up file datafile2
+Mount ro
+check properties of metadata copied up file shared
+Unmount and Mount rw
+check properties of metadata copied up file shared
+check properties of data copied up file shared
+
+== Check lazy follow to lowerdata layer ==
-- 
2.34.1

