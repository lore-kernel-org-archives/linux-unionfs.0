Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B150C6379C
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Jul 2021 16:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA9E66120C
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Jul 2021 16:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhGVQK0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 12:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbhGVQJi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Jul 2021 12:09:38 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C8DC061382;
        Thu, 22 Jul 2021 09:46:38 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id x14-20020a7bc20e0000b0290249f2904453so2843637wmi.1;
        Thu, 22 Jul 2021 09:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VY98RONH0CLQ5/qAXEC3gp6xNB0Es/MOMLpLdQtdYNw=;
        b=rA99PoLQhAbEv1gKFxcLstXJtD98mPz0sr2g1qkLyCSLAw4khrhYn8zehmbgf6UpPR
         8sb7zCPHfvyf1VUH4wb2T8bY21dbZc5NqAuRFhW4mAiYUgqETdN+3O8xfkMPUXJF8aN6
         XkZq46s6AeiR+WP5ShVvGfGC5i6MHKGFf4euTkdVMmjVxA8zDEs69ES2+LuU1R3MuTI2
         a5vOFoO+0dsGXSCgWlG9ySLClrFeZpU6DNb7lftmRKudx6bePAitmI6hMYKcf2QBj5MZ
         My3q0kfkBQV3aKn+46FsuqE1iYgb83NK0zebAhlwJpmUGTcfTQI1T591lS/6QH0JQ0+K
         WfAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VY98RONH0CLQ5/qAXEC3gp6xNB0Es/MOMLpLdQtdYNw=;
        b=Yf6ylApdyyZZJ5Wo5djdMQGlcF+qMc6jOU3Yx0MTG19Cii/GGItSV+AeOIQ+N7PhDS
         SnazrILA4DjkpYxLWh57wzVndUQjlPmfWzn1KERrWtQDn/64JwTQ1MvoWuezD8Xcq+97
         LQ9fM7zOyz1Agtl0c5lFxmVRGQDbiPBSB7v+MupqMx2KemUj05im9ZpziKJg9AyXw3jS
         bTf0spSOAEpP1eMAD+Ep22R3qUynlksoLDkM1eNPP/o/nDpxGlfYQd1tqnhS1Vi6nvT5
         yi9RKQOHEHBHRHREoCNc1X67ktzzrRCvoRuPOPQWxaqCAnAqVRG0IcAaOPFvLpY86xCe
         wx1w==
X-Gm-Message-State: AOAM532yVIx735krPWep9wWy3h28Md6KsUTaH0+nROX0O2PikOCzvmn+
        75P8nR+Fn+csLxQuoYt4+mI=
X-Google-Smtp-Source: ABdhPJygNvdLIviuiBVHtXyKxq92sm/Q3tah6up/hOP75FYxsnmj4Rl2pUnnIrlXeXN5YH8Umcx+mg==
X-Received: by 2002:a05:600c:8a9:: with SMTP id l41mr10366853wmp.152.1626972397178;
        Thu, 22 Jul 2021 09:46:37 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.223])
        by smtp.gmail.com with ESMTPSA id w18sm8460426wrs.44.2021.07.22.09.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 09:46:36 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] overlay: add test for copy up of lower file attributes
Date:   Thu, 22 Jul 2021 19:46:34 +0300
Message-Id: <20210722164634.394499-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Overlayfs copies up a subset of lower file attributes since kernel
commits:
173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")

This test verifies this functionality works correctly and that it
survives power failure and/or mount cycle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

This test is failing on master and passes on overlayfs-next.

Thanks,
Amir.

 tests/overlay/078     | 145 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/078.out |   2 +
 2 files changed, 147 insertions(+)
 create mode 100755 tests/overlay/078
 create mode 100644 tests/overlay/078.out

diff --git a/tests/overlay/078 b/tests/overlay/078
new file mode 100755
index 00000000..b43449d1
--- /dev/null
+++ b/tests/overlay/078
@@ -0,0 +1,145 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Huawei.  All Rights Reserved.
+# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 078
+#
+# Test copy up of lower file attributes.
+#
+# Overlayfs copies up a subset of lower file attributes since kernel commits:
+# 173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
+# 2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")
+#
+# This test is similar and was derived from generic/507, but instead
+# of creating new files which are created in upper layer, prepare
+# the file with attributes in lower layer and verify that attributes
+# are not lost during copy up, (optional) shutdown and mount cycle.
+#
+. ./common/preamble
+_begin_fstest auto quick perms shutdown
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	$CHATTR_PROG -ai $lowertestfile &> /dev/null
+	rm -f $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+
+_require_command "$LSATTR_PROG" lasttr
+_require_command "$CHATTR_PROG" chattr
+_require_chattr ASai
+_require_xfs_io_command "syncfs"
+
+_require_scratch
+_require_scratch_shutdown
+
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+lowertestfile=$lowerdir/testfile
+testfile=$SCRATCH_MNT/testfile
+
+_scratch_mkfs
+mkdir -p $lowerdir
+touch $lowertestfile
+_scratch_mount
+
+# Set another flag on lowertestfile and verify all flags
+# are kept though copy up (optional shutdown) and mount cycle
+do_check()
+{
+	attr=$1
+
+	echo "Test chattr +$1 $2" >> $seqres.full
+
+	$UMOUNT_PROG $SCRATCH_MNT
+
+	# Add attribute to lower file
+	$CHATTR_PROG +$attr $lowertestfile
+
+	# Re-create upperdir/workdir
+	rm -rf $upperdir $workdir
+	mkdir -p $upperdir $workdir
+
+	if [ "$2" == "shutdown" ]; then
+		$XFS_IO_PROG -r $lowertestfile -c "fsync" | _filter_xfs_io
+	fi
+
+	_scratch_mount
+
+	before=`$LSATTR_PROG $testfile`
+
+	# Write file in append mode to test copy up of append-only attribute
+	# Expect failure on write to immutable file
+	expect=0
+	if [ "$1" == "i" ]; then
+		expect=1
+	fi
+	$XFS_IO_PROG -a -c "pwrite -S 0x61 0 10" $testfile >> $seqres.full 2>&1
+	result=$?
+	if [ $result != $expect ]; then
+		echo "Write unexpectedly returned $result for file with attribute '$attr'"
+	fi
+
+	if [ "$2" == "shutdown" ]; then
+		$XFS_IO_PROG -r $testfile -c "fsync" | _filter_xfs_io
+		_scratch_shutdown | tee -a $seqres.full
+	fi
+
+	_scratch_cycle_mount
+
+	after=`$LSATTR_PROG $testfile`
+	echo "Before copy up: $before" >> $seqres.full
+	echo "After  copy up: $after" >> $seqres.full
+
+	# Verify attributes were not lost during copy up, shutdown and mount cycle
+	if [ "$before" != "$after" ]; then
+		echo "Before copy up: $before"
+		echo "After  copy up: $after"
+	fi
+
+	echo "Test chattr -$1 $2" >> $seqres.full
+
+	# Delete attribute from overlay file
+	$CHATTR_PROG -$attr $testfile
+
+	before=`$LSATTR_PROG $testfile`
+
+	if [ "$2" == "shutdown" ]; then
+		$XFS_IO_PROG -r $testfile -c "fsync" | _filter_xfs_io
+		_scratch_shutdown | tee -a $seqres.full
+	fi
+
+	_scratch_cycle_mount
+
+	after=`$LSATTR_PROG $testfile`
+	echo "Before mount cycle: $before" >> $seqres.full
+	echo "After  mount cycle: $after" >> $seqres.full
+
+	# Verify attribute deletion was not lost during shutdown or mount cycle
+	if [ "$before" != "$after" ]; then
+		echo "Before mount cycle: $before"
+		echo "After  mount cycle: $after"
+	fi
+}
+
+echo "Silence is golden"
+
+# This is the subset of attributes copied up by overlayfs since kernel
+# commit ...
+opts="A S a i"
+for i in $opts; do
+	do_check $i
+	do_check $i shutdown
+done
+
+status=0
+exit
diff --git a/tests/overlay/078.out b/tests/overlay/078.out
new file mode 100644
index 00000000..b8acea8c
--- /dev/null
+++ b/tests/overlay/078.out
@@ -0,0 +1,2 @@
+QA output created by 078
+Silence is golden
-- 
2.32.0

