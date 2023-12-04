Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8dQlSJw"
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE22FF;
	Mon,  4 Dec 2023 10:59:28 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-40bda47c489so28244415e9.3;
        Mon, 04 Dec 2023 10:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701716367; x=1702321167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UfDXBa14ns5s9JcVo9HU0xMCh1R5d4DPkqc4xRiVgY=;
        b=D8dQlSJwOu6895OoYcBZSMqAxW01vlwxqcRA2QQPqv3smlEE5R0M1W7hMrXMO9owOt
         GCzXCqVHRwI76ILjouT72RmPwe5w/3VeF6kh+tc5p8ki8tWz/D1dh0Ap4sComKiIJavJ
         FPDkYHiBic+B6VXgO1ti25EXEPPOl29HhSjns7zAPJ6tAQ6QFej394BXMHbZisSwdnKg
         YNY+crdtG9Jd6eifRfqDLtvYYCeBZ9tKdUkrdTQNqsFu3JKs4oOHnmHF6faZkX9lQtNY
         janUNGyi+dme/rTgu9bH5DcEJFw7cSyEjcCbiedcMZHckUHKwWulTqOkU47F0y2XIkjA
         qtlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701716367; x=1702321167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5UfDXBa14ns5s9JcVo9HU0xMCh1R5d4DPkqc4xRiVgY=;
        b=DuUM+7ONKxd8xdLlXbHOhnwdzN/UWvpRe7VyR6H217e8jH6JQ+m/U518U9r+2i7YD4
         emWMNMw+gq5af4pbfhKDRNkcFsPADJKCaofPWOSllZ8crCmJO0B2w6l7SPPvypkthj1l
         DAAzr3HJTsAOu/qEASgOxgLOZ7UQHCV045gISJYvH1+zjOchvYv/lAeHg2HN4KIRb0l4
         lkwLFQ0mr8FJ6zv1YE2i5YrJpNwSqQe9/NffhsuMQLCfxBxbMrtd/AG8LYkU9alBYkXu
         EU5W4IuaeS7Pv1ct+n1050TFkDx1yHwD0PagxkrZ1GSnMf6uQ+RZo1pkAm0d/qrcDvww
         sSqg==
X-Gm-Message-State: AOJu0Yw6sREcURsR0hm01htedQ8sU2UCmvbmlMM65VqkYwg4MkBklVcf
	7Duss15YWoQ00VfjuX6NDhQFadyTb2Y=
X-Google-Smtp-Source: AGHT+IHakOy0cBDRYGzRKezodWTINWKCYEkXJ5O3ot6ZIIqVwrs1T3Ji7u6efCEqgxUS43NhU+wHpA==
X-Received: by 2002:a05:600c:84c9:b0:40b:5e59:c58f with SMTP id er9-20020a05600c84c900b0040b5e59c58fmr2875354wmb.185.1701716366573;
        Mon, 04 Dec 2023 10:59:26 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id d9-20020a05600c34c900b0040b2c195523sm20008098wmq.31.2023.12.04.10.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 10:59:26 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2 3/4] overlay: test data-only lowerdirs with datadir+ mount option
Date: Mon,  4 Dec 2023 20:58:58 +0200
Message-Id: <20231204185859.3731975-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231204185859.3731975-1-amir73il@gmail.com>
References: <20231204185859.3731975-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

