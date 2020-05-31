Return-Path: <SRS0=LZCd=7N=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01111C433E3
	for <linux-unionfs@archiver.kernel.org>; Sun, 31 May 2020 11:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D603D20671
	for <linux-unionfs@archiver.kernel.org>; Sun, 31 May 2020 11:02:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7MZzG7s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgEaLCR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 31 May 2020 07:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEaLCI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 31 May 2020 07:02:08 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B44C05BD43;
        Sun, 31 May 2020 04:02:07 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f185so8557521wmf.3;
        Sun, 31 May 2020 04:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6y6ybSFvJzj8la441aFZb6Q4CuXXKgdXsZPwGPiuBEA=;
        b=J7MZzG7sxeToKzXANPZ9hVDL/o2Sij/z2BRXjSJJbustIq51hNUuYSzsl4gQW9zhYc
         ce9mz8n+ixjSQQi+M/PM6eM8Eflr2nZZDAnLjnJbwOA6SnkY2QNFsd6X/WtnJAJRhl1P
         UbbcNSo72q8zvECLEN/mnO+1yxP69OAOEzQx7qnXh97yQ0XdwYcXNEw8jS5+W3l6JwWt
         WUVVPOuBGEw++ZxaBWf0urvuNHy58QNJLH+3UzSirlBqdF9F9rRlXODdjKKTz02PX43G
         NhbeM4pw8vlLVXz3DZBi3z0oLigamy+NQNQDcViF/QBLlXa3bVabM5oIAXAOlrecAU2b
         GIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6y6ybSFvJzj8la441aFZb6Q4CuXXKgdXsZPwGPiuBEA=;
        b=Hct5/tRHyRclpSPvCp2fcORxBw0d/xJmTOqK+t3slQjCZhiOoMuoPMSDF9HPOsE27L
         EIeMvPZpW5j0SQ9oyKJCaJBLFMkNgwFUYtSSwNyrggDdr164YUuDqNxhs4TqUPXfYfV8
         EzJZoyhTeOZY2o7TnNUpmkMIKgm175HeZGLOcZaBpTnKyVJ04fWTs2lRkgoc6jbGSO7R
         PERZC2TM81nM3pDsgnEa3i5MyxIysR2yx4yodjZ7y/j1IkWQyb8S3jC2ixq69ysJoKbY
         JFXykXySgb38bwywiZBEaxNfSROZbLH8Wkhgs9n2TiS2eP0/SfDO9IMDgVSsTRMtr9nr
         dXEw==
X-Gm-Message-State: AOAM532+jdALjGwMSgHwNstPPf88vVkuupzTPd4zzYn4OQig6rsyJTlK
        TN3iLhGJIkixye/AHhJ1Goo=
X-Google-Smtp-Source: ABdhPJyfWfMF2AlGIFcGe6qswDUlvvFIyuDWJ36NsBbZX0SekQirBCb8CxWAK8II68pVMRj7qgSghg==
X-Received: by 2002:a1c:7e52:: with SMTP id z79mr17689605wmc.104.1590922926213;
        Sun, 31 May 2020 04:02:06 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id j190sm7846430wmb.33.2020.05.31.04.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 04:02:05 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH 2/3] overlay: add unionmount tests with multi lower layers
Date:   Sun, 31 May 2020 14:01:55 +0300
Message-Id: <20200531110156.6613-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200531110156.6613-1-amir73il@gmail.com>
References: <20200531110156.6613-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The tests with multi lower layers rotate the upper layer into a lower
layer on specific operations such as mkdir, rename and link.
That provides test coverage for redirect_dir and index features.

The following variations are covered:
1. All layers all on scratch fs (--ov=10 --samefs)
2. All layers on scratch fs expect for lowermost on test fs (--ov=10)
3. Lowermost layer on test fs, one layer on tmpfs and the rest
   on sratch fs (--ov=10 --maxfs=1)
4. Lowermost layer on test fs, one layer on scratch fs and the rest
   are unique tmpfs instances (--ov=10 --maxfs=10)

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/103     | 38 ++++++++++++++++++++++++++++++++++++++
 tests/overlay/103.out |  2 ++
 tests/overlay/104     | 39 +++++++++++++++++++++++++++++++++++++++
 tests/overlay/104.out |  2 ++
 tests/overlay/105     | 40 ++++++++++++++++++++++++++++++++++++++++
 tests/overlay/105.out |  2 ++
 tests/overlay/106     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/overlay/106.out |  2 ++
 tests/overlay/107     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/overlay/107.out |  2 ++
 tests/overlay/108     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/overlay/108.out |  2 ++
 tests/overlay/109     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/overlay/109.out |  2 ++
 tests/overlay/group   |  7 +++++++
 15 files changed, 302 insertions(+)
 create mode 100755 tests/overlay/103
 create mode 100644 tests/overlay/103.out
 create mode 100755 tests/overlay/104
 create mode 100644 tests/overlay/104.out
 create mode 100755 tests/overlay/105
 create mode 100644 tests/overlay/105.out
 create mode 100755 tests/overlay/106
 create mode 100644 tests/overlay/106.out
 create mode 100755 tests/overlay/107
 create mode 100644 tests/overlay/107.out
 create mode 100755 tests/overlay/108
 create mode 100644 tests/overlay/108.out
 create mode 100755 tests/overlay/109
 create mode 100644 tests/overlay/109.out

diff --git a/tests/overlay/103 b/tests/overlay/103
new file mode 100755
index 00000000..fb7fce0c
--- /dev/null
+++ b/tests/overlay/103
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 103
+#
+# Run unionmount testsuite to verify correctness
+# with multi lower layers on same fs as upper
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
+_unionmount_testsuite_run --ov=10 --samefs --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/103.out b/tests/overlay/103.out
new file mode 100644
index 00000000..78212a3d
--- /dev/null
+++ b/tests/overlay/103.out
@@ -0,0 +1,2 @@
+QA output created by 103
+Silence is golden
diff --git a/tests/overlay/104 b/tests/overlay/104
new file mode 100755
index 00000000..f867f345
--- /dev/null
+++ b/tests/overlay/104
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 104
+#
+# Run unionmount testsuite to verify correctness
+# with multi lower layers, lowermost on unique fs
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
+_unionmount_testsuite_run --ov=10 --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/104.out b/tests/overlay/104.out
new file mode 100644
index 00000000..3f3bd2e8
--- /dev/null
+++ b/tests/overlay/104.out
@@ -0,0 +1,2 @@
+QA output created by 104
+Silence is golden
diff --git a/tests/overlay/105 b/tests/overlay/105
new file mode 100755
index 00000000..f964c58e
--- /dev/null
+++ b/tests/overlay/105
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 105
+#
+# Run unionmount testsuite to verify correctness
+# with multi lower layers, lowermost on unique fs,
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
+_unionmount_testsuite_run --ov=10 --xino --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/105.out b/tests/overlay/105.out
new file mode 100644
index 00000000..edaafd46
--- /dev/null
+++ b/tests/overlay/105.out
@@ -0,0 +1,2 @@
+QA output created by 105
+Silence is golden
diff --git a/tests/overlay/106 b/tests/overlay/106
new file mode 100755
index 00000000..52d6c7d0
--- /dev/null
+++ b/tests/overlay/106
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 106
+#
+# Run unionmount testsuite to verify correctness
+# with multi lower layers, some layers on unique fs,
+# one layer is on tmpfs.
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
+_require_tmpfs
+_require_test
+_require_scratch
+_require_unionmount_testsuite
+
+_unionmount_testsuite_run --ov=10 --maxfs=1 --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/106.out b/tests/overlay/106.out
new file mode 100644
index 00000000..85af05d8
--- /dev/null
+++ b/tests/overlay/106.out
@@ -0,0 +1,2 @@
+QA output created by 106
+Silence is golden
diff --git a/tests/overlay/107 b/tests/overlay/107
new file mode 100755
index 00000000..abcde30c
--- /dev/null
+++ b/tests/overlay/107
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 107
+#
+# Run unionmount testsuite to verify correctness
+# with multi lower layers, some layers on unique fs,
+# one layer is on tmpfs with xino enabled.
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
+_require_tmpfs
+_require_test
+_require_scratch
+_require_unionmount_testsuite
+
+_unionmount_testsuite_run --ov=10 --maxfs=1 --xino --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/107.out b/tests/overlay/107.out
new file mode 100644
index 00000000..862bdfbd
--- /dev/null
+++ b/tests/overlay/107.out
@@ -0,0 +1,2 @@
+QA output created by 107
+Silence is golden
diff --git a/tests/overlay/108 b/tests/overlay/108
new file mode 100755
index 00000000..d4e9b570
--- /dev/null
+++ b/tests/overlay/108
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 108
+#
+# Run unionmount testsuite to verify correctness
+# with multi lower layers, all layers on unique fs,
+# some layers are on tmpfs.
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
+_require_tmpfs
+_require_test
+_require_scratch
+_require_unionmount_testsuite
+
+_unionmount_testsuite_run --ov=10 --maxfs=10 --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/108.out b/tests/overlay/108.out
new file mode 100644
index 00000000..326ffa96
--- /dev/null
+++ b/tests/overlay/108.out
@@ -0,0 +1,2 @@
+QA output created by 108
+Silence is golden
diff --git a/tests/overlay/109 b/tests/overlay/109
new file mode 100755
index 00000000..71072982
--- /dev/null
+++ b/tests/overlay/109
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 109
+#
+# Run unionmount testsuite to verify correctness
+# with multi lower layers, all layers on unique fs,
+# some layers are on tmpfs with xino enabled.
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
+_require_tmpfs
+_require_test
+_require_scratch
+_require_unionmount_testsuite
+
+_unionmount_testsuite_run --ov=10 --maxfs=10 --xino --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/109.out b/tests/overlay/109.out
new file mode 100644
index 00000000..8356befa
--- /dev/null
+++ b/tests/overlay/109.out
@@ -0,0 +1,2 @@
+QA output created by 109
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 267161f4..079ff0af 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -80,3 +80,10 @@
 100 auto quick union samefs
 101 auto quick union nonsamefs
 102 auto quick union nonsamefs xino
+103 auto union rotate samefs
+104 auto union rotate nonsamefs
+105 auto union rotate nonsamefs xino
+106 auto union rotate nonsamefs
+107 auto union rotate nonsamefs xino
+108 auto union rotate nonsamefs
+109 auto union rotate nonsamefs xino
-- 
2.17.1

