Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDFppR1Q"
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C7ED6;
	Sun, 10 Dec 2023 22:52:29 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3333074512bso2624100f8f.1;
        Sun, 10 Dec 2023 22:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702277548; x=1702882348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+xVv3jYFWhA12Dncqx2HyGdj4DUz1a1ciOOAHG4MXn4=;
        b=EDFppR1QZPU16crnWfAp5xN7l+H/FfBdtiY4qGI+mMsMoO8QEy1XhBhuK9R9v0AwjK
         V6ffZSV3EQB4rFVQozxFmKGjwV+j73bZE6zJv7kcAhrV94J/wpmTZ7bQCYy3fWoStw9p
         rgTUO/0hKDqfFXx7KJ3DSf/pm/M487YE08Pu5cUsJ6VQfOiop1zYQU0I6vYTMZqXsGIr
         WBRG4u/407LSEFEz3yQmHzByKbEqsIkXJM82yG4tN9F6LRUKXMEnbOzkjEQPsIiqx7US
         rDg/As8Fi0TzF7lC8trmXigduhmLbU0Ukh8DjsIontIcSzSRbbt2iDm4WjxNnvz4zrVy
         KkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702277548; x=1702882348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+xVv3jYFWhA12Dncqx2HyGdj4DUz1a1ciOOAHG4MXn4=;
        b=qPCDaHW3CGiORWYnWIWLMlyNh2l0ZIo7ksDUt96/QOliYDl9CgN+boIKJDkcxgZGoR
         TocswTAiQxHQDBzFMxOF1qGEZfcavw/wQPbCC4tnyZY0/17zcE7NyLr1UhTQH2Guhp3O
         A57zf0JhMsaZRfYkshAfd7EHNYFhuuSP5w+/d+GCsEKxtnJpJO/3P0WJMgEbBqbZryox
         YtmvXSYmBze2Sx6DJCLzuWQYETC1GVMdX4MUdCtjkyrJ88WgDh61j2DGxkuo9o/M3KMd
         d8Odjjxcv19UKKS2rA20fYm6P/njawmNuz4/b4wV2IgeHWFAEjzkFnjxO7Twr3MoT3Vt
         tM2g==
X-Gm-Message-State: AOJu0Yx+DRkR7LHJ2+/VXgfv9usOgOsfCnaXZgZSr4dvqhGiDmvOIo8s
	wgp/K7bwDg8ojCcfd5Y6uf+PXoUSVyc=
X-Google-Smtp-Source: AGHT+IGb0yBh4dOiGuIqDQu+XoHhCvr5WK3ICQ3NVyvKr68Wz4HMcOtqEvjS/AGqn1BsUVj+/UDO/g==
X-Received: by 2002:a05:600c:1e02:b0:40c:192f:6ae5 with SMTP id ay2-20020a05600c1e0200b0040c192f6ae5mr1857325wmb.112.1702277547447;
        Sun, 10 Dec 2023 22:52:27 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id e12-20020a05600c4e4c00b0040b398f0585sm12069090wmq.9.2023.12.10.22.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Dec 2023 22:52:27 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v3] overlay: Add tests for nesting private xattrs
Date: Mon, 11 Dec 2023 08:52:24 +0200
Message-Id: <20231211065224.86771-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If overlayfs xattr escaping is supported, ensure:
 * We can create "overlay.*" xattrs on a file in the overlayfs
 * We can create an xwhiteout file in the overlayfs

We check for nesting support by trying to getattr an "overlay.*" xattr
in an overlayfs mount, which will return ENOTSUPP in older kernels.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi Zorro,

This version fixes the failure with Kconfig
CONFIG_OVERLAY_FS_INDEX=y.

Thanks,
Amir.

 tests/overlay/084     | 171 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/084.out |  61 +++++++++++++++
 2 files changed, 232 insertions(+)
 create mode 100755 tests/overlay/084
 create mode 100644 tests/overlay/084.out

diff --git a/tests/overlay/084 b/tests/overlay/084
new file mode 100755
index 00000000..8465caeb
--- /dev/null
+++ b/tests/overlay/084
@@ -0,0 +1,171 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test No. 084
+#
+# Test advanded nesting functionallity
+#
+. ./common/preamble
+_begin_fstest auto quick nested
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	# Unmount nested mounts if things fail
+	$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/nested  2>/dev/null
+	rm -rf $tmp
+}
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
+_require_scratch_overlay_xattr_escapes
+
+# remove all files from previous tests
+_scratch_mkfs
+
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+middir=$OVL_BASE_SCRATCH_MNT/mid
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+nesteddir=$OVL_BASE_SCRATCH_MNT/nested
+
+umount_overlay()
+{
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+test_escape()
+{
+	local prefix=$1
+
+	echo -e "\n== Check xattr escape $prefix =="
+
+	# index feature would require nfs_export on $nesteddir mount
+	local extra_options="-o index=off"
+	if [ "$prefix" == "user" ]; then
+            extra_options+=",userxattr"
+	fi
+
+	_scratch_mkfs
+	mkdir -p $lowerdir $middir $upperdir $workdir $nesteddir
+
+	_overlay_scratch_mount_dirs $lowerdir $middir $workdir $extra_options
+
+	mkdir -p $SCRATCH_MNT/layer1/dir/ $SCRATCH_MNT/layer2/dir
+
+	touch $SCRATCH_MNT/layer1/dir/file
+
+	# Make layer2/dir an opaque file
+	# Only one of these will be escaped, but both should succeed
+	setfattr -n user.overlay.opaque -v "y" $SCRATCH_MNT/layer2/dir
+	setfattr -n trusted.overlay.opaque -v "y" $SCRATCH_MNT/layer2/dir
+
+	getfattr -m "overlay\\." --absolute-names -d $SCRATCH_MNT/layer2/dir | _filter_scratch
+
+	umount_overlay
+
+	getfattr -m "overlay\\." --absolute-names -d $middir/layer2/dir | _filter_scratch
+
+	# Remount as lower and try again
+	_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir $extra_options
+
+	getfattr -m "overlay\\." --absolute-names -d $SCRATCH_MNT/layer2/dir | _filter_scratch
+
+	# Recursively mount and ensure the opaque dir is working with both trusted and user xattrs
+	echo "nested xattr mount with trusted.overlay"
+	_overlay_mount_dirs $SCRATCH_MNT/layer2:$SCRATCH_MNT/layer1 - - overlayfs $nesteddir
+	stat $nesteddir/dir/file  2>&1 | _filter_scratch
+	$UMOUNT_PROG $nesteddir
+
+	echo "nested xattr mount with user.overlay"
+	_overlay_mount_dirs $SCRATCH_MNT/layer2:$SCRATCH_MNT/layer1 - - -o userxattr overlayfs $nesteddir
+	stat $nesteddir/dir/file  2>&1 | _filter_scratch
+	$UMOUNT_PROG $nesteddir
+
+	# Also ensure propagate the escaped xattr when we copy-up layer2/dir
+	echo "copy-up of escaped xattrs"
+	touch $SCRATCH_MNT/layer2/dir/other_file
+	getfattr -m "$prefix.overlay\\.overlay" --absolute-names -d $upperdir/layer2/dir | _filter_scratch
+
+	umount_overlay
+}
+
+test_escape trusted
+test_escape user
+
+do_test_xwhiteout()
+{
+	local prefix=$1
+	local basedir=$2
+
+	local extra_options=""
+	if [ "$prefix" == "user" ]; then
+            extra_options="-o userxattr"
+	fi
+
+	mkdir -p $basedir/lower $basedir/upper $basedir/work
+	touch $basedir/lower/regular $basedir/lower/hidden  $basedir/upper/hidden
+	setfattr -n $prefix.overlay.whiteouts -v "y" $basedir/upper
+	setfattr -n $prefix.overlay.whiteout -v "y" $basedir/upper/hidden
+
+	# Test the hidden is invisible
+	_overlay_scratch_mount_dirs $basedir/upper:$basedir/lower - - $extra_options
+	ls $SCRATCH_MNT
+	stat $SCRATCH_MNT/hidden 2>&1 | _filter_scratch
+	umount_overlay
+}
+
+# Validate that xwhiteouts work like whiteouts
+test_xwhiteout()
+{
+	local prefix=$1
+
+	echo -e "\n== Check xwhiteout $prefix =="
+
+	_scratch_mkfs
+
+	do_test_xwhiteout $prefix $OVL_BASE_SCRATCH_MNT
+}
+
+test_xwhiteout trusted
+test_xwhiteout user
+
+# Validate that (escaped) xwhiteouts work inside a nested overlayfs mount
+test_escaped_xwhiteout()
+{
+	local prefix=$1
+
+	echo -e "\n== Check escaped xwhiteout $prefix =="
+
+	# index feature would require nfs_export on $nesteddir mount
+	local extra_options="-o index=off"
+	if [ "$prefix" == "user" ]; then
+            extra_options+=",userxattr"
+	fi
+
+	_scratch_mkfs
+	mkdir -p $lowerdir $upperdir $workdir $nesteddir
+
+	_overlay_mount_dirs $lowerdir $upperdir $workdir $extra_options overlayfs $nesteddir
+
+	do_test_xwhiteout $prefix $nesteddir
+
+	$UMOUNT_PROG $nesteddir
+}
+
+test_escaped_xwhiteout trusted
+test_escaped_xwhiteout user
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/084.out b/tests/overlay/084.out
new file mode 100644
index 00000000..54b890de
--- /dev/null
+++ b/tests/overlay/084.out
@@ -0,0 +1,61 @@
+QA output created by 084
+
+== Check xattr escape trusted ==
+# file: SCRATCH_MNT/layer2/dir
+trusted.overlay.opaque="y"
+user.overlay.opaque="y"
+
+# file: SCRATCH_DEV/mid/layer2/dir
+trusted.overlay.overlay.opaque="y"
+user.overlay.opaque="y"
+
+# file: SCRATCH_MNT/layer2/dir
+trusted.overlay.opaque="y"
+user.overlay.opaque="y"
+
+nested xattr mount with trusted.overlay
+stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
+nested xattr mount with user.overlay
+stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
+copy-up of escaped xattrs
+# file: SCRATCH_DEV/upper/layer2/dir
+trusted.overlay.overlay.opaque="y"
+
+
+== Check xattr escape user ==
+# file: SCRATCH_MNT/layer2/dir
+trusted.overlay.opaque="y"
+user.overlay.opaque="y"
+
+# file: SCRATCH_DEV/mid/layer2/dir
+trusted.overlay.opaque="y"
+user.overlay.overlay.opaque="y"
+
+# file: SCRATCH_MNT/layer2/dir
+trusted.overlay.opaque="y"
+user.overlay.opaque="y"
+
+nested xattr mount with trusted.overlay
+stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
+nested xattr mount with user.overlay
+stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
+copy-up of escaped xattrs
+# file: SCRATCH_DEV/upper/layer2/dir
+user.overlay.overlay.opaque="y"
+
+
+== Check xwhiteout trusted ==
+regular
+stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory
+
+== Check xwhiteout user ==
+regular
+stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory
+
+== Check escaped xwhiteout trusted ==
+regular
+stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory
+
+== Check escaped xwhiteout user ==
+regular
+stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory
-- 
2.34.1

