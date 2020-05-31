Return-Path: <SRS0=LZCd=7N=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC484C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 31 May 2020 11:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEBF420671
	for <linux-unionfs@archiver.kernel.org>; Sun, 31 May 2020 11:02:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aK3zD/Is"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgEaLCL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 31 May 2020 07:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaLCG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 31 May 2020 07:02:06 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D582C061A0E;
        Sun, 31 May 2020 04:02:06 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l11so8638564wru.0;
        Sun, 31 May 2020 04:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n32a/poMcKnM2/4gUcrU/a+tbrotBbiPg7VuMcoStXE=;
        b=aK3zD/IsSoutuN2lGFOpFWwF2KU3UfasEPD1qS6XKO5GlWgap96h3OWKa8OGZDkM9T
         JzzorBaqdiqyKxpRTRjzha1qdEwTNRkbG2d9vBxUgIvfkG+PjMknwyX2QJndLA4tw8C3
         MaMT7MJIPKBbiTp1ovLRg7rAIjZ5Mj+/7cOvFqK+bXVHuz3ZM3UDpPb600q8PbcLVXQ+
         B/un6RVSDWZZ+4bfFUJRaA0gyuAN8FJTYwwwQO5pedXds9ZNI8XlgqjmsciRUTFetfvM
         GpL39IYx9y1cR0IaWZ9O8B1IuQBarkt58uuIApBjr1qHF5DYBX94L9c8ELqgDHgQY486
         V18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n32a/poMcKnM2/4gUcrU/a+tbrotBbiPg7VuMcoStXE=;
        b=q4hDODlEbD+vVrGgsJEDV9tA1gciLwGK146WlSkMaw1jpm9utaDIVcgsf+N2qC9CoT
         e8hTBp18X0KbpxJskfwaJQdptDNqG81UhMCK8G0yKhpLIR15UvUSwC6qWRpn1IzmHCSa
         +0sxr/Y0mBkaIgjNzZA+JMQKqNqbbL3+X+IPP+DzqeCjTJkbK69d0+V4Mgxf9yea8MlR
         vzSeDqXGwDoS4HBJS6pfU2amazji2XYMl3XntdmBkR8kM9vp/N/W8K98/Eg8AZ8SQ30I
         95I6HW7/rc9DO641VBU829l2fm8uD/notZTX9U8JyvVxSSadaKTos920hN1AdKClGjxa
         KVFg==
X-Gm-Message-State: AOAM5323ZC8BDpMb024y6FVVJwFj8LUO7IupXZe5T/EqD9wmQTAVwow+
        WeOXXNg3WWrcUt6w8Q5deJM=
X-Google-Smtp-Source: ABdhPJzz+tiWrVnrBb+9fr5Ljfzn8FODYVr1Bk/fTWpdX2qT6mvAbRDm+V6Vlhb1EtqqFAINZV3++g==
X-Received: by 2002:a5d:4dc9:: with SMTP id f9mr16687855wru.407.1590922924685;
        Sun, 31 May 2020 04:02:04 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id j190sm7846430wmb.33.2020.05.31.04.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 04:02:04 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH 1/3] overlay: run unionmount testsuite test cases
Date:   Sun, 31 May 2020 14:01:54 +0300
Message-Id: <20200531110156.6613-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200531110156.6613-1-amir73il@gmail.com>
References: <20200531110156.6613-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Add support for running unionmount-testsuite from xfstests.
This requires that unionmount-testsuite is installed under src dir or
that UNIONMOUNT_TESTSUITE variable points to the location of the
testsuite.  It also requires a recent version of unionmount-testsuite
that supports setting basedir path via UNIONMOUNT_* environment variables.

Add tests for three basic configurations:
1. overlay with upper/lower on same fs
2. overlay with upper/lower not on same fs without xino
3. overlay with upper/lower not on same fs with xino

The samefs test uses scratch partition for lower/upper layers.
The non samefs tests use the scratch partition for upper layer and the
test partition for lower layer.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 README.overlay        | 15 ++++++++++++
 common/config         |  2 ++
 common/overlay        | 54 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/100     | 38 ++++++++++++++++++++++++++++++
 tests/overlay/100.out |  2 ++
 tests/overlay/101     | 39 +++++++++++++++++++++++++++++++
 tests/overlay/101.out |  2 ++
 tests/overlay/102     | 40 ++++++++++++++++++++++++++++++++
 tests/overlay/102.out |  2 ++
 tests/overlay/group   |  3 +++
 10 files changed, 197 insertions(+)
 create mode 100755 tests/overlay/100
 create mode 100644 tests/overlay/100.out
 create mode 100755 tests/overlay/101
 create mode 100644 tests/overlay/101.out
 create mode 100755 tests/overlay/102
 create mode 100644 tests/overlay/102.out

diff --git a/README.overlay b/README.overlay
index 30b5ddb2..39e25ada 100644
--- a/README.overlay
+++ b/README.overlay
@@ -50,3 +50,18 @@ In the example above, MOUNT_OPTIONS will be used to mount the base scratch fs,
 TEST_FS_MOUNT_OPTS will be used to mount the base test fs,
 OVERLAY_MOUNT_OPTIONS will be used to mount both test and scratch overlay and
 OVERLAY_FSCK_OPTIONS will be used to check both test and scratch overlay.
+
+
+Unionmount Testsuite
+====================
+
+xfstests can be used as a test harness to run unionmount testsuite test cases
+and provide extended test coverage for overlayfs.
+
+To enable running unionmount testsuite, clone the git repository from:
+  https://github.com/amir73il/unionmount-testsuite.git
+under the xfstests src directory, or set the environment variable
+UNIONMOUNT_TESTSUITE to the local path where the repository was cloned.
+
+Run './check -overlay -g overlay/union' to execute all the unionmount testsuite
+test cases.
diff --git a/common/config b/common/config
index 8023273d..e356bcda 100644
--- a/common/config
+++ b/common/config
@@ -71,6 +71,8 @@ export OVL_LOWER="ovl-lower"
 export OVL_WORK="ovl-work"
 # overlay mount point parent must be the base fs root
 export OVL_MNT="ovl-mnt"
+# By default unionmount-testsuite is expected under src
+export UNIONMOUNT_TESTSUITE=${UNIONMOUNT_TESTSUITE:=$here/src/unionmount-testsuite}
 
 # From e2fsprogs/e2fsck/e2fsck.h:
 # Exit code used by fsck-type programs
diff --git a/common/overlay b/common/overlay
index f8e1e27f..5e6a7e0f 100644
--- a/common/overlay
+++ b/common/overlay
@@ -363,3 +363,57 @@ _repair_overlay_scratch_fs()
 	esac
 	return $res
 }
+
+# This test requires that unionmount testsuite is installed at
+# $UNIONMOUNT_TESTSUITE and that it supports configuring layers and overlay
+# mount paths via UNIONMOUNT_* environment variables.
+_require_unionmount_testsuite()
+{
+	[ -x "$UNIONMOUNT_TESTSUITE/run" ] || \
+		_notrun "unionmount testsuite required."
+
+	# Verify that UNIONMOUNT_* vars are supported
+	local usage=`UNIONMOUNT_BASEDIR=_ "$UNIONMOUNT_TESTSUITE/run" 2>&1`
+	echo $usage | grep -wq "UNIONMOUNT_BASEDIR" || \
+		_notrun "newer version of unionmount testsuite required."
+}
+
+_unionmount_testsuite_run()
+{
+	[ "$FSTYP" = overlay ] || \
+		_notrun "Filesystem $FSTYP not supported with unionmount testsuite."
+
+	# Provide the mounted base fs for upper and lower dirs and the
+	# overlay mount point.
+	# unionmount testsuite will perform the overlay mount.
+	# test fs is used for lower layer in non-samefs runs.
+	# scratch fs is used for upper layer in non-samefs runs and
+	# for both layers in samefs runs.
+	if (echo $* | grep -qv samefs) ; then
+		_overlay_base_test_mount
+		export UNIONMOUNT_LOWERDIR=$OVL_BASE_TEST_DIR/union
+	fi
+	export UNIONMOUNT_BASEDIR=$OVL_BASE_SCRATCH_MNT/union
+
+	_scratch_mkfs
+	rm -rf $UNIONMOUNT_BASEDIR $UNIONMOUNT_LOWERDIR
+	mkdir -p $UNIONMOUNT_BASEDIR $UNIONMOUNT_LOWERDIR
+
+	cd $UNIONMOUNT_TESTSUITE
+	echo "run $* ..." > $seqres.full
+	./run $* >> $seqres.full || \
+		echo "unionmount testsuite failed! see $seqres.full for details."
+}
+
+_unionmount_testsuite_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+
+	[ -n "$UNIONMOUNT_BASEDIR" ] || return 0
+
+	# Cleanup overlay mount after unionmount testsuite run
+	cd $UNIONMOUNT_TESTSUITE
+	echo "run --clean-up ..." >> $seqres.full
+	./run --clean-up >> $seqres.full 2>&1
+}
diff --git a/tests/overlay/100 b/tests/overlay/100
new file mode 100755
index 00000000..a2e82dfa
--- /dev/null
+++ b/tests/overlay/100
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 100
+#
+# Run unionmount testsuite to verify correctness
+# with single lower layer on same fs as upper
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_unionmount_testsuite_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_unionmount_testsuite
+
+_unionmount_testsuite_run --ov --samefs --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/100.out b/tests/overlay/100.out
new file mode 100644
index 00000000..798c0136
--- /dev/null
+++ b/tests/overlay/100.out
@@ -0,0 +1,2 @@
+QA output created by 100
+Silence is golden
diff --git a/tests/overlay/101 b/tests/overlay/101
new file mode 100755
index 00000000..2b3a75d4
--- /dev/null
+++ b/tests/overlay/101
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 101
+#
+# Run unionmount testsuite to verify correctness
+# with single lower layer not on same fs as upper
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_unionmount_testsuite_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs overlay
+_supported_os Linux
+_require_test
+_require_scratch
+_require_unionmount_testsuite
+
+_unionmount_testsuite_run --ov --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/101.out b/tests/overlay/101.out
new file mode 100644
index 00000000..e651a915
--- /dev/null
+++ b/tests/overlay/101.out
@@ -0,0 +1,2 @@
+QA output created by 101
+Silence is golden
diff --git a/tests/overlay/102 b/tests/overlay/102
new file mode 100755
index 00000000..2dddbe50
--- /dev/null
+++ b/tests/overlay/102
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 102
+#
+# Run unionmount testsuite to verify correctness
+# with single lower layer not on same fs as upper
+# with xino enabled
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_unionmount_testsuite_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs overlay
+_supported_os Linux
+_require_test
+_require_scratch
+_require_unionmount_testsuite
+
+_unionmount_testsuite_run --ov --xino --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/102.out b/tests/overlay/102.out
new file mode 100644
index 00000000..86dd1f96
--- /dev/null
+++ b/tests/overlay/102.out
@@ -0,0 +1,2 @@
+QA output created by 102
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 0cebcad0..267161f4 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -77,3 +77,6 @@
 072 auto quick copyup hardlink
 073 auto quick whiteout
 074 auto quick exportfs dangerous
+100 auto quick union samefs
+101 auto quick union nonsamefs
+102 auto quick union nonsamefs xino
-- 
2.17.1

