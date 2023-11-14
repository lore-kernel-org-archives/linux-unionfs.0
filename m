Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E019AC4167D
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 06:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjKNGtJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 01:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjKNGtI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 01:49:08 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2176D43;
        Mon, 13 Nov 2023 22:49:04 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-40891d38e3fso38862855e9.1;
        Mon, 13 Nov 2023 22:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699944543; x=1700549343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bw0h9gFXlZYYMDHGobY26F6HHIbyTIfb69sBhweoBmw=;
        b=JCFVlgJmMHYsbRwngAoN4N6B3ds0+cOUq8RVqavwvigtno+yYJkba4PYllb3XBZ01E
         kpUd49+vyedB4g8fDWdykAAhmQZIm6zxxzYOdfz01rov3Z3D9PVHPnesongG8JHMWAmd
         W12l8wbrQ6bMwIBTZrOEkDyM9t+hoXhXfZzI/jXVFL0y/q6aPfprKhb70pHX54hG/3pt
         p7X3OBGWBKl0C6LnU7wGvz00Ca6VSs2huTjvPsS8EaHqRrORY4J9++ypMikiHtl+nau5
         kwXffftnlmU3wD4czUOrNVKXws8wkZ7hjG/bZZPd5gzvCQB+kqyo0QI7QsIoU71DwVfh
         4uKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699944543; x=1700549343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bw0h9gFXlZYYMDHGobY26F6HHIbyTIfb69sBhweoBmw=;
        b=i4Z6mCKfV7FbZZbqGxnDa6E5EgVWQc9U/HVYlb75XmNlmUdotui7P/70Hn3noqbb1K
         vQBaUg442gl4AqOJoQwQslGwkq0X+DO6b/R+n3MJNUxvwuJJ04fzxbg5TXPgidOJmwZw
         vvU8s1sRY52jMJaM02eG6nptCzBF6m3b2tzUNSzhHgshvyMAMrv7orAD0EBrKWIrzGGe
         LpXe9lqLYYp5jIG+dfzwP+IQ4p+3fzboqxZZqQX2wlY1JjsEP37F8/b3pvQ7e5MlDJ0O
         svQygAfEyrtyZLpks37wmUO2rf4GBi8t1rmf4eQGrQhcYrEunnvvh2KqdsEJJNOd0rxr
         kPHA==
X-Gm-Message-State: AOJu0Ywy9lrv98WBq938LnIQe+0adxVWffNe5ddugwk8eAfHa4IyoKV9
        SKJpHbnHELzbXv7KAdSKETU=
X-Google-Smtp-Source: AGHT+IENpBhZ9V0b1CXRsl+YBWoS+SiQyksRgsBF8/9Kxiqiu7fVx1JLCFhFFASiyd4pYlByH7ACVQ==
X-Received: by 2002:a05:600c:3b91:b0:405:3455:e1a3 with SMTP id n17-20020a05600c3b9100b004053455e1a3mr6977846wms.17.1699944542568;
        Mon, 13 Nov 2023 22:49:02 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id p17-20020a05600c469100b004064e3b94afsm16338917wmo.4.2023.11.13.22.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 22:49:02 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 1/4] overlay: Add tests for nesting private xattrs
Date:   Tue, 14 Nov 2023 08:48:54 +0200
Message-Id: <20231114064857.1666718-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114064857.1666718-1-amir73il@gmail.com>
References: <20231114064857.1666718-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Alexander Larsson <alexl@redhat.com>

If overlayfs xattr escaping is supported, ensure:
 * We can create "overlay.*" xattrs on a file in the overlayfs
 * We can create an xwhiteout file in the overlayfs

We check for nesting support by trying to getattr an "overlay.*" xattr
in an overlayfs mount, which will return ENOSUPP in older kernels.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay        |  12 +++
 tests/overlay/084     | 169 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/084.out |  61 +++++++++++++++
 3 files changed, 242 insertions(+)
 create mode 100755 tests/overlay/084
 create mode 100644 tests/overlay/084.out

diff --git a/common/overlay b/common/overlay
index 7004187f..f6017e4e 100644
--- a/common/overlay
+++ b/common/overlay
@@ -201,6 +201,18 @@ _require_scratch_overlay_features()
 	_scratch_unmount
 }
 
+_require_scratch_overlay_xattr_escapes()
+{
+	_scratch_mkfs > /dev/null 2>&1
+	_overlay_scratch_mount_dirs $OVL_BASE_SCRATCH_MNT/$OVL_LOWER $OVL_BASE_SCRATCH_MNT/$OVL_UPPER $OVL_BASE_SCRATCH_MNT/$OVL_WORK -o rw
+
+        touch $SCRATCH_MNT/file
+        (getfattr -n trusted.overlay.foo $SCRATCH_MNT/file 2>&1 | grep -q "not supported") && \
+                  _notrun "xattr escaping is not supported by overlay"
+
+	_scratch_unmount
+}
+
 _require_scratch_overlay_verity()
 {
 	local lowerdirs="$OVL_BASE_SCRATCH_MNT/$OVL_UPPER:$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
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

