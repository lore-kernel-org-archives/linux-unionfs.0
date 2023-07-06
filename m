Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B1DEB64DC
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Jul 2023 09:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjGFJws (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 05:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjGFJwr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Jul 2023 05:52:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450C11BD6
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Jul 2023 02:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688637090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jdZX7kyAmH/XGw71MsrD2NSvr8RyqkDiwoM7SBPHimo=;
        b=jMhf+YtQmwRmY4BgivwuYYTWewEuTb7MNX8cg9Qf6vwP45qQ1IIPGRp9BErZzpz30rfYhm
        AZ7XKgnjWuyJ7PdpF/glEcGcpah0Nl6SbUEDy5W5liMbSUEsheQj74+hbaSu4s+LPVaLlj
        TX6ivaNQGkD0wIrmZq2aNnsqFW6DRsQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-egFkfkYNNoeFixJ3MM2vmg-1; Thu, 06 Jul 2023 05:51:29 -0400
X-MC-Unique: egFkfkYNNoeFixJ3MM2vmg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9AFD280D58B;
        Thu,  6 Jul 2023 09:51:28 +0000 (UTC)
Received: from greebo.redhat.com (unknown [10.39.193.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14ADE492C13;
        Thu,  6 Jul 2023 09:51:27 +0000 (UTC)
From:   alexl@redhat.com
To:     fstests@vger.kernel.org
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 4/4] overlay: Add test coverage for fs-verity support
Date:   Thu,  6 Jul 2023 11:51:01 +0200
Message-Id: <0d9e64f67dfe314f163a5c8c15421a48deb9a9d5.1688634271.git.alexl@redhat.com>
In-Reply-To: <cover.1688634271.git.alexl@redhat.com>
References: <cover.1688634271.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Alexander Larsson <alexl@redhat.com>

This tests that the right xattrs are set during copy-up, and
that we properly fail on missing of erronous fs-verity digests
when validating.

We also ensure that verity=require fails if a metacopy has not
fs-verity, and doesn't do a meta-coopy-up if the base file lacks
verity.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay        |  14 ++
 common/verity         |  10 +-
 tests/overlay/080     | 326 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/080.out |   7 +
 4 files changed, 355 insertions(+), 2 deletions(-)
 create mode 100755 tests/overlay/080
 create mode 100644 tests/overlay/080.out

diff --git a/common/overlay b/common/overlay
index 816ed66d..7004187f 100644
--- a/common/overlay
+++ b/common/overlay
@@ -201,6 +201,20 @@ _require_scratch_overlay_features()
 	_scratch_unmount
 }
 
+_require_scratch_overlay_verity()
+{
+	local lowerdirs="$OVL_BASE_SCRATCH_MNT/$OVL_UPPER:$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
+
+	_require_scratch_verity "$OVL_BASE_FSTYP" "$OVL_BASE_SCRATCH_MNT"
+
+	_scratch_mkfs > /dev/null 2>&1
+	_overlay_scratch_mount_dirs "$lowerdirs" "-" "-" \
+		-o ro,redirect_dir=follow,metacopy=on,verity=on > /dev/null 2>&1 || \
+	        _notrun "overlay verity not supported on ${SCRATCH_DEV}"
+
+	_scratch_unmount
+}
+
 # Check kernel support for <lowerdirs>::<lowerdatadir> format
 _require_scratch_overlay_lowerdata_layers()
 {
diff --git a/common/verity b/common/verity
index 77c257d3..2b663210 100644
--- a/common/verity
+++ b/common/verity
@@ -38,9 +38,12 @@ _require_scratch_verity()
 			"or mkfs options are not compatible with verity"
 	fi
 
+	local fstyp=${1:-$FSTYP}
+	local scratch_mnt=${2:-$SCRATCH_MNT}
+
 	# The filesystem may be aware of fs-verity but have it disabled by
 	# CONFIG_FS_VERITY=n.  Detect support via sysfs.
-	if [ ! -e /sys/fs/$FSTYP/features/verity ]; then
+	if [ ! -e /sys/fs/$fstyp/features/verity ]; then
 		_notrun "kernel $FSTYP isn't configured with verity support"
 	fi
 
@@ -68,7 +71,7 @@ _require_scratch_verity()
 	# The filesystem may have fs-verity enabled but not actually usable by
 	# default.  E.g., ext4 only supports verity on extent-based files, so it
 	# doesn't work on ext3-style filesystems.  So, try actually using it.
-	if ! _fsv_can_enable $SCRATCH_MNT/tmpfile; then
+	if ! _fsv_can_enable $scratch_mnt/tmpfile; then
 		_notrun "$FSTYP verity isn't usable by default with these mkfs options"
 	fi
 
@@ -201,6 +204,9 @@ _scratch_mkfs_verity()
 	btrfs)
 		_scratch_mkfs
 		;;
+	overlay)
+		_scratch_mkfs # This relies on the scratch fs supporting verity
+                ;;
 	*)
 		_notrun "No verity support for $FSTYP"
 		;;
diff --git a/tests/overlay/080 b/tests/overlay/080
new file mode 100755
index 00000000..0b5dca09
--- /dev/null
+++ b/tests/overlay/080
@@ -0,0 +1,326 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test No. 080
+#
+# Test fs-verity functionallity
+#
+. ./common/preamble
+_begin_fstest auto quick metacopy redirect verity
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+. ./common/verity
+
+# real QA test starts here
+_supported_fs overlay
+# We use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
+_require_scratch_overlay_features redirect_dir metacopy
+_require_scratch_overlay_lowerdata_layers
+_require_scratch_overlay_verity
+
+# remove all files from previous tests
+_scratch_mkfs
+
+verityname="verityfile"
+noverityname="noverityfile"
+wrongverityname="wrongverityfile"
+missingverityname="missingverityfile"
+lowerdata="data1"
+lowerdata2="data2"
+lowerdata3="data3"
+lowerdata4="data4"
+lowersize="5"
+
+# Create test directories
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
+
+# Check metacopy xattr
+check_metacopy()
+{
+	local target=$1 exist=$2 dataonlybase=$3
+	local out_f target_f
+	local msg
+
+	out_f=$( { _getfattr --absolute-names --only-values -n \
+		$OVL_XATTR_METACOPY $target 2>&3 | od -A n -t x1 -w256 ; } 3>&1 | _filter_scratch)
+        has_version0=`echo $out_f | awk 'NR==1{print $1 == 0}'`
+
+	if [ "$exist" == "y" ];then
+		[ "$out_f" == "" -o "$has_version0" == "1" ] && return
+		echo "Metacopy xattr does not exist on ${target}. stdout=$out_f"
+		return
+	fi
+
+	if [ "$out_f" == ""  -o "$has_version0" == "1" ];then
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
+# Check verity set in metacopy
+check_verity()
+{
+	local target=$1 exist=$2
+	local out_f target_f
+	local msg
+
+	out_f=$( { _getfattr --absolute-names --only-values -n $OVL_XATTR_METACOPY $target 2>&3 | od -A n -t x1 -w256 ; } 3>&1 | _filter_scratch)
+
+	target_f=`echo $target | _filter_scratch`
+	msg="$target_f: trusted.overlay.metacopy: No such attribute"
+	has_digest=`echo $out_f | awk 'NR==1{print $4 == 1}'`
+
+	if [ "$exist" == "y" ]; then
+		[ "$out_f" == "$msg" -o "$has_digest" == "0" ] && echo "No verity on ${target}. stdout=$out_f"
+		return
+	fi
+
+	[ "$out_f" == "$msg" -o "$has_digest" == "0" ] && return
+	echo "Verity xattr exists on ${target} unexpectedly. stdout=$out_f"
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
+	[ "$actual_size" == "$expected_size" ] || echo "Expected file size of $target $expected_size but actual size is $actual_size"
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
+check_file_size_contents()
+{
+	local target=$1 expected_size=$2 expected_content=$3
+
+	check_file_size $target $expected_size
+	check_file_contents $target $expected_content
+}
+
+check_io_error()
+{
+	local target=$1
+	local actual target_f out_f
+
+	target_f=`echo $target | _filter_scratch`
+	out_f=`cat $target 2>&1 | _filter_scratch`
+	msg="cat: $target_f: Input/output error"
+
+	[ "$out_f" == "$msg" ] && return
+
+	echo "$target_f unexpectedly has no I/O error"
+}
+
+create_basic_files()
+{
+	local subdir=$1
+
+	_scratch_mkfs
+	mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir2
+
+	if [ "$subdir" != "" ]; then
+	    mkdir $lowerdir/$subdir
+	fi
+
+	echo -n "$lowerdata" > $lowerdir/$subdir$verityname
+	echo -n "$lowerdata2" > $lowerdir/$subdir$noverityname
+	echo -n "$lowerdata3" > $lowerdir/$subdir$wrongverityname
+	echo -n "$lowerdata4" > $lowerdir/$subdir$missingverityname
+
+	for f in $verityname $noverityname $wrongverityname $missingverityname; do
+		chmod 600 $lowerdir/$subdir$f
+
+		if [ "$f" != "$noverityname" ]; then
+			_fsv_enable $lowerdir/$subdir$f
+		fi
+        done
+}
+
+prepare_midlayer()
+{
+	local dataonlybase=$1
+
+	subdir=""
+	if [ "$dataonlybase" == "y" ]; then
+	    subdir="base/"
+	fi
+
+	create_basic_files "$subdir"
+	# Create midlayer
+	_overlay_scratch_mount_dirs $lowerdir $lowerdir2 $workdir2 -o redirect_dir=on,index=on,verity=on,metacopy=on
+	for f in $verityname $noverityname $wrongverityname $missingverityname; do
+		if [ "$dataonlybase" == "y" ]; then
+		    mv $SCRATCH_MNT/base/$f $SCRATCH_MNT/$f
+		else
+		    chmod 400 $SCRATCH_MNT/$f
+		fi
+	done
+	umount_overlay
+
+	if [ "$dataonlybase" == "y" ]; then
+	    rm -rf $lowerdir2/base
+	fi
+
+	for f in $verityname $noverityname $wrongverityname $missingverityname; do
+		# Ensure we have right metacopy and verity xattrs
+		check_metacopy $lowerdir2/$f "y"
+
+		if [ "$f" == "$noverityname" ]; then
+		    check_verity $lowerdir2/$f "n"
+		else
+		    check_verity $lowerdir2/$f "y"
+		fi
+
+		if [ "$dataonlybase" == "y" ]; then
+			check_redirect $lowerdir2/$f "/base/$f"
+		fi
+
+		check_file_size_contents $lowerdir2/$f $lowersize ""
+	done
+
+	# Fixup missing and wrong verity in lowerdir
+	rm -f $lowerdir/$subdir$wrongverityname $lowerdir/$subdir$missingverityname
+	echo -n "changed" > $lowerdir/$subdir$wrongverityname
+	_fsv_enable $lowerdir/$subdir$wrongverityname
+	echo "$lowerdata4" > $lowerdir/$subdir$missingverityname
+}
+
+test_common()
+{
+	local dataonlybase=$1
+	local verity=$2
+
+	if [ $dataonlybase == "y" ]; then
+		mount_overlay "$lowerdir2::$lowerdir" $verity
+	else
+		mount_overlay "$lowerdir2:$lowerdir" $verity
+	fi
+
+	check_file_size_contents $SCRATCH_MNT/$verityname $lowersize "$lowerdata"
+
+	if [ "$verity" == "require" ]; then
+		check_io_error $SCRATCH_MNT/$noverityname
+	else
+		check_file_size_contents $SCRATCH_MNT/$noverityname $lowersize "$lowerdata2"
+	fi
+
+	if [ "$verity" == "off" ]; then
+		check_file_size_contents $SCRATCH_MNT/$wrongverityname $lowersize "changed"
+		check_file_size_contents $SCRATCH_MNT/$missingverityname $lowersize "$lowerdata4"
+	else
+		check_io_error $SCRATCH_MNT/$missingverityname
+		check_io_error $SCRATCH_MNT/$wrongverityname
+	fi
+
+	umount_overlay
+}
+
+mount_overlay()
+{
+	local _lowerdir=$1
+	local _verity=$2
+
+	_overlay_scratch_mount_dirs "$_lowerdir" $upperdir $workdir -o redirect_dir=on,index=on,metacopy=on,verity=$_verity
+}
+
+umount_overlay()
+{
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+
+echo -e "\n== Check fsverity validation =="
+
+prepare_midlayer "n"
+test_common "n" "off"
+prepare_midlayer "n"
+test_common "n" "on"
+
+# Now with data-only layers
+prepare_midlayer "y"
+test_common "y" "off"
+prepare_midlayer "y"
+test_common "y" "on"
+
+echo -e "\n== Check fsverity require =="
+
+prepare_midlayer "n"
+test_common "n" "require"
+
+# Now with data-only layers
+prepare_midlayer "y"
+test_common "y" "require"
+
+echo -e "\n== Check fsverity copy-up =="
+
+# Ensure Second level metacopy sets verity xattr
+prepare_midlayer "n"
+mount_overlay "$lowerdir2:$lowerdir" "on"
+chmod 200 $SCRATCH_MNT/$verityname
+umount_overlay
+check_metacopy $upperdir/$verityname "y"
+check_verity $upperdir/$verityname "y"
+
+# Ensure data copy up remove verity xattr
+create_basic_files ""
+mount_overlay "$lowerdir" "on"
+echo foo >> $SCRATCH_MNT/$verityname
+umount_overlay
+check_metacopy $upperdir/$verityname "n"
+check_verity $upperdir/$verityname "n"
+
+# Ensure metacopy is only used if verity is enabled in lower for verity=require
+create_basic_files ""
+mount_overlay "$lowerdir" "require"
+chmod 200 $SCRATCH_MNT/$verityname
+chmod 200 $SCRATCH_MNT/$noverityname
+umount_overlay
+check_metacopy $upperdir/$verityname "y"
+check_verity $upperdir/$verityname "y"
+check_metacopy $upperdir/$noverityname "n"
+check_verity $upperdir/$noverityname "n"
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/080.out b/tests/overlay/080.out
new file mode 100644
index 00000000..7d1f1d10
--- /dev/null
+++ b/tests/overlay/080.out
@@ -0,0 +1,7 @@
+QA output created by 080
+
+== Check fsverity validation ==
+
+== Check fsverity require ==
+
+== Check fsverity copy-up ==
-- 
2.40.1

