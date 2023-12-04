Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8Wu9PJ+"
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41265124;
	Mon,  4 Dec 2023 10:59:09 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40c0873cf84so20165005e9.1;
        Mon, 04 Dec 2023 10:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701716347; x=1702321147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NtXjML0cds8wugdxx7cNsuen1cnfJsm+4xi7LzBgwtU=;
        b=a8Wu9PJ+kfYRbtvYBankOhrNr+tbRz5b1uVyJJgtYJh7RMWzTkfngK76hkjeO5ais1
         N92IOzp9E5KvFSEPdOoKqdUouhgZC0OVROFF9yqZVeL3M4UwGrfUbQsfZbEd2UcY1xvQ
         4/Juv7RR8zVXCNoDQmwlZqK8I1fZDSdumeeDXogDUOKpxZBc91LaiRXz7uzOl0lSqxyt
         SGaiO41LHHFyjmOIvahjY4BAAA/krVoILdJVHnQvAmZIRHmMrPs+ZU1/vVjmxv3+TV0U
         SnonKJ021UBg2E3qxamXiWKxEYcd9ocgxDxcarUJiE+WrvI2JPOyYRFVjwgH50WE99IT
         qqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701716347; x=1702321147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NtXjML0cds8wugdxx7cNsuen1cnfJsm+4xi7LzBgwtU=;
        b=iIYha9dG6iIgO6bFleIET+aN/UJgPQvOAjxEKaEV5WdzzjOLjM0fhXTy4B/39nyaNN
         tUtQa0mPlGQSKZBzUyIFNhYjKkEdZxSqoA5I03HpDVD6nhR+ujJXHL0I9reM7kvB7SB8
         Jb2cWt2aSAuqtv9rAmxzqabiTM36+PQxIFskCnaZ9MZcknHHF5nwUxZJ3c9kisXnR9Tu
         QuVBnmJIt0SWj/Zr+t4+SKGBq9z35Ld00ctNpPITaS5WtR4UjUrzBWS+LNftO9XLF2x1
         M0Vgiu2Cex1rxA4IvvfQno2lVzM+j85ZsNj5w3ahWVWxpxzArqaEX6UV63PhJKVzgi5q
         rmBg==
X-Gm-Message-State: AOJu0Yz2Fep7H30RXsw9mcI/GuEHwNSz5IlKpH1IBLRXxZYGsZvrIJEz
	EVXeub/Zbje+Yk3L/znwdzk=
X-Google-Smtp-Source: AGHT+IEdpL/E16zc9GqCewiOrh/+u2Xn2f8dGbQR/EiP9M8I3oxMjsGwTFqHWGALjTUyIkuihVJJ+w==
X-Received: by 2002:a05:600c:1384:b0:405:1c19:b747 with SMTP id u4-20020a05600c138400b004051c19b747mr2816793wmf.15.1701716347505;
        Mon, 04 Dec 2023 10:59:07 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id d9-20020a05600c34c900b0040b2c195523sm20008098wmq.31.2023.12.04.10.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 10:59:07 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2 1/4] overlay: Add tests for nesting private xattrs
Date: Mon,  4 Dec 2023 20:58:56 +0200
Message-Id: <20231204185859.3731975-2-amir73il@gmail.com>
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

If overlayfs xattr escaping is supported, ensure:
 * We can create "overlay.*" xattrs on a file in the overlayfs
 * We can create an xwhiteout file in the overlayfs

We check for nesting support by trying to getattr an "overlay.*" xattr
in an overlayfs mount, which will return ENOSUPP in older kernels.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/084     | 169 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/084.out |  61 +++++++++++++++
 2 files changed, 230 insertions(+)
 create mode 100755 tests/overlay/084
 create mode 100644 tests/overlay/084.out

diff --git a/tests/overlay/084 b/tests/overlay/084
new file mode 100755
index 00000000..ff451f38
--- /dev/null
+++ b/tests/overlay/084
@@ -0,0 +1,169 @@
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
+	local extra_options=""
+	if [ "$prefix" == "user" ]; then
+            extra_options="-o userxattr"
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
+	local extra_options=""
+	if [ "$prefix" == "user" ]; then
+            extra_options="-o userxattr"
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

