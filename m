Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0BA7C43460
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 09:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A99F61444
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 09:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhDUJYI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 05:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238118AbhDUJYA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 05:24:00 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A9CC06138C;
        Wed, 21 Apr 2021 02:23:24 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id f195-20020a1c1fcc0000b029012eb88126d7so835631wmf.3;
        Wed, 21 Apr 2021 02:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RvZRrbekUx6Qvs6DuFQOsZkAqzPTl7cFvojkGqmAjp4=;
        b=SBmAmil2htMH0ItJeT0xWEDP7A13YQC0GazOuqYVKp61zIHwPTiMSK/jhS7sw6v9W8
         u2vULy07LdkdDQY3ozakM6115obMH1lmzyEwCZc/uf90LwzENwhMysEWE1S9US7JyfQ3
         yNSGpKKim/SdMLy/glol9XJzraN/z5QzU8/wwPyzi82CxAON+Ap/CHstS0DKos6vljG6
         k2gWdYHGNpmnfPzngVFxEJ54kObj1UX12qksL8iPR2EBFzJVuVdQU2sE7J7N13AOm8ci
         gHXE6MfBYi8PQfVk4abVQSg8P71b7D3a9cd1G0l720l8fumRLhCBUpHYSZN3PHs7saWb
         VYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RvZRrbekUx6Qvs6DuFQOsZkAqzPTl7cFvojkGqmAjp4=;
        b=unXIh518lsF1/d+Pcsf4EFKA/SWBBt2JUblqmoxpXNwPsVoz502sXRckX5NVO91/Me
         uMIuaUELrmk6utblGZrWjtuNqPcjUj6wq6hDcz0PizCswMHsJ6NcXsnYVq2IjV+1wSLW
         TmWTO18zQXSlUSnpGzOaE/4yab9ZeLbyznOe9am/p9/PkM7m1f3Sd14Uu+gYcRrQxsft
         08oiJr4/1xlWG7n82t1k78+jqPSo1HiEV+nWVNEfUvsIE3kRRy5iU0eWSLeGmYghiNuL
         J4hoiF2x/2K/ycJKMUmKJwyZkyuiCV9m+XmyYDrwOdIVkSXsLXpaTt2Z9XBB8Rz7L7gH
         3/qA==
X-Gm-Message-State: AOAM531apLt7wNO73f5UEasdhwlEySN85ygLt3yIB3dfrr3hRkbNobxB
        NSFFXefgAn/9fKf9aJAl7aw=
X-Google-Smtp-Source: ABdhPJydPLAvnDp5nsZbm2FEKK6VutcFDcRKtlaFBhzx8lTu7vsdzK/vzWf5tzkb/OGpCApoxlqJHw==
X-Received: by 2002:a1c:4102:: with SMTP id o2mr8822815wma.177.1618997003163;
        Wed, 21 Apr 2021 02:23:23 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.37])
        by smtp.gmail.com with ESMTPSA id p3sm1551754wmq.31.2021.04.21.02.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:23:22 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH 2/2] overlay: Test invalidate of readdir cache
Date:   Wed, 21 Apr 2021 12:23:17 +0300
Message-Id: <20210421092317.68716-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210421092317.68716-1-amir73il@gmail.com>
References: <20210421092317.68716-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This is a regression test for kernel commit 65cd913ec9d9
("ovl: invalidate readdir cache on changes to dir with origin")

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/077     | 105 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/077.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 108 insertions(+)
 create mode 100755 tests/overlay/077
 create mode 100644 tests/overlay/077.out

diff --git a/tests/overlay/077 b/tests/overlay/077
new file mode 100755
index 00000000..e254aec1
--- /dev/null
+++ b/tests/overlay/077
@@ -0,0 +1,105 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 077
+#
+# Test invalidate of readdir cache
+#
+# This is a regression test for kernel commit 65cd913ec9d9
+# ("ovl: invalidate readdir cache on changes to dir with origin")
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# create test directory and test file, mount overlayfs and remove
+# testfile to create a whiteout in upper dir.
+create_whiteout()
+{
+	local lower=$1
+	local upper=$2
+	local work=$3
+	local file=$4
+
+	mkdir -p $lower/testdir
+	touch $lower/testdir/$file
+
+	_overlay_scratch_mount_dirs $lower $upper $work
+
+	rm -f $SCRATCH_MNT/testdir/$file
+
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_require_scratch_nocheck
+
+# remove all files from previous runs
+_scratch_mkfs
+
+# Create test area with a merge dir, a "former" merge dir and
+# a pure upper dir
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+
+mkdir -p $lowerdir/merge $lowerdir/former $upperdir/pure
+touch $lowerdir/merge/{a,b,c}
+
+_scratch_mount
+
+touch $SCRATCH_MNT/pure/{a,b,c}
+touch $SCRATCH_MNT/former/{a,b,c}
+
+# Remove the lower directory and mount overlay again to create
+# a "former merge dir"
+$UMOUNT_PROG $SCRATCH_MNT
+rm -rf $lowerdir/former
+_scratch_mount
+
+# Check readdir cache invalidate on pure upper dir
+echo "Create file in pure upper dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/pure A 2>&1 >> $seqres.full || \
+	echo "Missing created file in pure upper dir (see $seqres.full for details)"
+echo "Remove files in pure upper dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/pure -u 2>&1 >> $seqres.full || \
+	echo "Found unlinked files in pure upper dir (see $seqres.full for details)"
+
+# Check readdir cache invalidate on merge dir
+echo "Create file in merge dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/merge A 2>&1 >> $seqres.full || \
+	echo "Missing created file in merge dir (see $seqres.full for details)"
+echo "Remove files in merge dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/merge -u 2>&1 >> $seqres.full || \
+	echo "Found unlinked files in merge dir (see $seqres.full for details)"
+
+# Check readdir cache invalidate on former merge dir
+echo "Create file in former merge dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/former A 2>&1 >> $seqres.full || \
+	echo "Missing created file in former merge dir (see $seqres.full for details)"
+echo "Remove files in former merge dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/former -u 2>&1 >> $seqres.full || \
+	echo "Found unlinked files in former merge dir (see $seqres.full for details)"
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/077.out b/tests/overlay/077.out
new file mode 100644
index 00000000..11538276
--- /dev/null
+++ b/tests/overlay/077.out
@@ -0,0 +1,2 @@
+QA output created by 077
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index ddc355e5..a8f98789 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -79,6 +79,7 @@
 074 auto quick exportfs dangerous
 075 auto quick perms
 076 auto quick perms dangerous
+077 auto quick whiteout dir
 100 auto quick union samefs
 101 auto quick union nonsamefs
 102 auto quick union nonsamefs xino
-- 
2.25.1

