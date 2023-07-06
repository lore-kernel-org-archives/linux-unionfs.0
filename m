Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1534EEB64D9
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Jul 2023 09:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbjGFJws (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 05:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjGFJwr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Jul 2023 05:52:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4867A1BD4
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Jul 2023 02:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688637089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEMT123v1QMT/712TnsgWDQE7HQrbA8EyxlF8Cy020c=;
        b=epIVaZeQ9TYRHhI5Ocjpr7Yvf2hTK3H1LynEJIoY/+h/C3Ena/txBBWpVRG4V8xqNfMHtY
        8cw5qe7qlP3K5CeQynnSyfOh+HZaO460wlWjFhX0Dl+f4/CDAHU3gkgfIp86VaJZWeSKlT
        WtsHQYK0jVRNdxPfZLhQ11X4OtWzZFU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-u5YcPgyAPoq3uv4kMyMo6A-1; Thu, 06 Jul 2023 05:51:26 -0400
X-MC-Unique: u5YcPgyAPoq3uv4kMyMo6A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35EA680269A;
        Thu,  6 Jul 2023 09:51:26 +0000 (UTC)
Received: from greebo.redhat.com (unknown [10.39.193.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74066492C13;
        Thu,  6 Jul 2023 09:51:25 +0000 (UTC)
From:   alexl@redhat.com
To:     fstests@vger.kernel.org
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 3/4] overlay: Add test for follow of lowerdata in data-only layers
Date:   Thu,  6 Jul 2023 11:51:00 +0200
Message-Id: <02eb0ba956ca7eeed76ec80965e544fb7cb7d30f.1688634271.git.alexl@redhat.com>
In-Reply-To: <cover.1688634271.git.alexl@redhat.com>
References: <cover.1688634271.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Add test coverage for following metacopy from lower layer to
data-only lower layers.

Data-only lower layers are configured using the syntax:
lowerdir=<lowerdir1>:<lowerdir2>::<lowerdata1>::<lowerdata2>.

Test that lowerdata files can be followed only by absolute redirect
from lower layer.

Test that with two lowerdata dirs, we can lookup individual lowerdata
files in both, and that a shared file is resolved from the uppermost
lowerdata dir.

There is also test case for lazy-data lookups, where we remove the
lowerdata file and validate that we get metadata from the metacopy
file, but open fails.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay        |  13 ++
 tests/overlay/079     | 325 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/079.out |  42 ++++++
 3 files changed, 380 insertions(+)
 create mode 100755 tests/overlay/079
 create mode 100644 tests/overlay/079.out

diff --git a/common/overlay b/common/overlay
index 452b3b09..816ed66d 100644
--- a/common/overlay
+++ b/common/overlay
@@ -201,6 +201,19 @@ _require_scratch_overlay_features()
 	_scratch_unmount
 }
 
+# Check kernel support for <lowerdirs>::<lowerdatadir> format
+_require_scratch_overlay_lowerdata_layers()
+{
+	local lowerdirs="$OVL_BASE_SCRATCH_MNT/$OVL_UPPER::$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
+
+	_scratch_mkfs > /dev/null 2>&1
+	_overlay_scratch_mount_dirs "$lowerdirs" "-" "-" \
+		-o ro,redirect_dir=follow,metacopy=on > /dev/null 2>&1 || \
+	        _notrun "overlay data-only layers not supported on ${SCRATCH_DEV}"
+
+	_scratch_unmount
+}
+
 # Helper function to check underlying dirs of overlay filesystem
 _overlay_fsck_dirs()
 {
diff --git a/tests/overlay/079 b/tests/overlay/079
new file mode 100755
index 00000000..77f94598
--- /dev/null
+++ b/tests/overlay/079
@@ -0,0 +1,325 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test No. 079
+#
+# Test data-only layers functionality.
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
+_require_scratch_overlay_lowerdata_layers
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
+	local _lowerdir=$1
+
+	_overlay_scratch_mount_dirs "$_lowerdir" $upperdir $workdir -o redirect_dir=on,index=on,metacopy=on
+}
+
+mount_ro_overlay()
+{
+	local _lowerdir=$1
+
+	_overlay_scratch_mount_dirs "$_lowerdir" "-" "-" -o ro,redirect_dir=follow,metacopy=on
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
+	mount_ro_overlay "$lowerdir::$datadir2::$datadir"
+
+	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
+		echo "No access to lowerdata layer $_target"
+
+	echo "Unmount and Mount rw"
+	umount_overlay
+	mount_overlay "$lowerdir::$datadir2::$datadir"
+	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
+		echo "No access to lowerdata layer $_target"
+	umount_overlay
+}
+
+test_common()
+{
+	local _lowerdirs=$1 _target=$2 _size=$3 _blocks=$4 _data="$5"
+	local _redirect=$6
+
+	echo "Mount ro"
+	mount_ro_overlay $_lowerdirs
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
+	mount_overlay $_lowerdirs
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
+	mount_overlay $_lowerdirs
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
+	mount_overlay "$lowerdir::$datadir2::$datadir"
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
+test_common "$lowerdir::$datadir2::$datadir" "$dataname" $datasize $datablocks \
+		"$datacontent" "/subdir/$dataname"
+test_common "$lowerdir::$datadir2::$datadir" "$dataname2" $datasize $datablocks \
+		"$datacontent2" "/subdir/$dataname.2"
+# Shared file should be picked from upper datadir
+test_common "$lowerdir::$datadir2::$datadir" "$sharedname" $datasize $datablocks \
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
diff --git a/tests/overlay/079.out b/tests/overlay/079.out
new file mode 100644
index 00000000..4807cdb5
--- /dev/null
+++ b/tests/overlay/079.out
@@ -0,0 +1,42 @@
+QA output created by 079
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
2.40.1

