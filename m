Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4320EC4167D
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 06:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjKNGtM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 01:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjKNGtL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 01:49:11 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36589D48;
        Mon, 13 Nov 2023 22:49:08 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-40839807e82so30440065e9.0;
        Mon, 13 Nov 2023 22:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699944546; x=1700549346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95nE7bWkcx0d4JSLcoybDbaWzT7WMYnwMt3WPJsD1uM=;
        b=UUG1I55JdQxFS7mrt/gtvt/Yub5T2ytjMEZzfPqu/C8cCmnR6ZZ5p13Y0YdwsBnint
         q1iNc0px+y1eKlQya/xXHU1RHfBUlqLO9E9MKp4qtM3H9B5+93pFFQ5wLm27mIG8TfWx
         8xhikawYmuMIxcS/tKgzpVGBGV5M/prxcrFgrMxcqMJaXvOianw1qXQbZgz+bB5UbKKm
         R87HLc03xwcTp3mQ+4Q57MSKldq9XcrYRS9KsWhSIvDyqNzgde3oMN2Bg54Z96eLDjtA
         XLf31tJYGOcFXP8W+uojDYrzZ/LIE7oOEbrXViGjt6QDX3Xlx4cqb14cfOw8K/ewK0VW
         pj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699944546; x=1700549346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=95nE7bWkcx0d4JSLcoybDbaWzT7WMYnwMt3WPJsD1uM=;
        b=izl2H+iS4k3+u1AEXYnaYrrAsQylD6afo3RnB7hGAf+Ib9plYaX8ESoY05EZLDG3eR
         CqMp8H0CJrsZozx5p9l5kOc0EWqD1TxvicGvR106u32KPeYKMDSMX81LwfXYZnxb9UUv
         fJuxmRzJ6StavGgG34GEX5Ah24kyRgAFCh82z5qDLejFzeqo62shPptCJIIOYMoCtKzQ
         8wPGW3G6fyuoAfz14lTwW7+atRoYZWkhOOZgq+MqRryQclUfyqtYEWIdgHxA3ARU3PsF
         C93NvQzeEYk2uy7Lq1qV+ZOws+h3Qf8R1VeCKFCifZzimaZQfMmrWm1IH6JsbvK7082g
         jdaQ==
X-Gm-Message-State: AOJu0Ywy3f5nsctzaMvkAWiHCvomeCxbyc8/iiBkbr1kmKgqfQw2TQDd
        z79ylghKSztKaBQjbv1vI6xoaObhJyA=
X-Google-Smtp-Source: AGHT+IH53CFYDggJu1XNd+9A2KSlmatUnwJOwLprt9QmK8LQPk5WTqAOfNUKAVhk3G0bNH9bOUu4AA==
X-Received: by 2002:a05:600c:1f88:b0:406:51a0:17ea with SMTP id je8-20020a05600c1f8800b0040651a017eamr1362610wmb.10.1699944546373;
        Mon, 13 Nov 2023 22:49:06 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id p17-20020a05600c469100b004064e3b94afsm16338917wmo.4.2023.11.13.22.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 22:49:06 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 4/4] overlay: test parsing of lowerdir+,datadir+ mount options
Date:   Tue, 14 Nov 2023 08:48:57 +0200
Message-Id: <20231114064857.1666718-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114064857.1666718-1-amir73il@gmail.com>
References: <20231114064857.1666718-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Fork test overlay/083 to test parsing of lowerdir+,datadir+ mount options.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/086     | 81 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/086.out |  2 ++
 2 files changed, 83 insertions(+)
 create mode 100755 tests/overlay/086
 create mode 100644 tests/overlay/086.out

diff --git a/tests/overlay/086 b/tests/overlay/086
new file mode 100755
index 00000000..b5960517
--- /dev/null
+++ b/tests/overlay/086
@@ -0,0 +1,81 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 086
+#
+# Test lowerdir+,datadir+ mount option restrictions.
+#
+
+. ./common/preamble
+_begin_fstest auto quick mount
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs overlay
+
+# _overlay_check_* helpers do not handle special chars well
+_require_scratch_nocheck
+_require_scratch_overlay_lowerdir_add_layers
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create lowerdirs with special characters
+lowerdir_spaces="$OVL_BASE_SCRATCH_MNT/lower1 with  spaces"
+lowerdir_colons="$OVL_BASE_SCRATCH_MNT/lower2:with::colons"
+lowerdir_colons_esc="$OVL_BASE_SCRATCH_MNT/lower2\:with\:\:colons"
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+mkdir -p "$lowerdir_spaces" "$lowerdir_colons"
+
+# _overlay_mount_* helpers do not handle lowerdir+,datadir+, so execute mount directly.
+
+# check illegal combinations and order of lowerdir,lowerdir+,datadir+
+$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+	-o"lowerdir=$lowerdir,lowerdir+=$lowerdir_colons" \
+	2>> $seqres.full && \
+	echo "ERROR: invalid combination of lowerdir and lowerdir+ mount options"
+
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+	-o"lowerdir=$lowerdir,datadir+=$lowerdir_colons" \
+	-o redirect_dir=follow,metacopy=on 2>> $seqres.full && \
+	echo "ERROR: invalid combination of lowerdir and datadir+ mount options"
+
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+	-o"datadir+=$lowerdir,lowerdir+=$lowerdir_colons" \
+	-o redirect_dir=follow,metacopy=on 2>> $seqres.full && \
+	echo "ERROR: invalid order of lowerdir+ and datadir+ mount options"
+
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+# mount is expected to fail with escaped colons.
+$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+	-o"lowerdir+=$lowerdir_colons_esc" \
+	2>> $seqres.full && \
+	echo "ERROR: incorrect parsing of escaped colons in lowerdir+ mount option"
+
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+# mount is expected to succeed without escaped colons.
+$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
+	-o"lowerdir+=$lowerdir_colons,datadir+=$lowerdir_spaces" \
+	-o redirect_dir=follow,metacopy=on \
+	2>&1 | tee -a $seqres.full
+
+# if spaces are not escaped when showing mount options,
+# mount command will not show the word 'spaces' after the spaces
+$MOUNT_PROG -t overlay | grep ovl_esc_test | tee -a $seqres.full | \
+	grep -q 'datadir+'.*spaces || \
+	echo "ERROR: escaped spaces truncated from datadir+ mount option"
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/086.out b/tests/overlay/086.out
new file mode 100644
index 00000000..b34758fd
--- /dev/null
+++ b/tests/overlay/086.out
@@ -0,0 +1,2 @@
+QA output created by 086
+Silence is golden
-- 
2.34.1

