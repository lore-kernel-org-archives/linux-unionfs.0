Return-Path: <SRS0=LZCd=7N=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D497C433E4
	for <linux-unionfs@archiver.kernel.org>; Sun, 31 May 2020 11:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D60420707
	for <linux-unionfs@archiver.kernel.org>; Sun, 31 May 2020 11:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sV9wg1HU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgEaLCR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 31 May 2020 07:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgEaLCJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 31 May 2020 07:02:09 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA24C061A0E;
        Sun, 31 May 2020 04:02:09 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y17so8520232wrn.11;
        Sun, 31 May 2020 04:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=njmwgWPUw/GV5aYZwf+RIQBn0ZuJmsiVzCYdG8QWhyE=;
        b=sV9wg1HUMk5EkweD+ZBpJy6+lB5rGC0gRK4KE3wk5sfh6b7CMJVSsEuxAEH7r8BJcG
         RgEatZQph6vVFGJ2VuAcYvEImbss4/prwXp8dUaOvdEvHMbiuRKgY1Wwx17g4DZSYP2j
         ATMsxHeguvdKxsaLoouAcQqfN2cTmFfQIfxm5qNqoZezel9p+/cbi4oPuIM68yfXd16j
         JLLRVPhMU6vxxkg2zZVFONsHJan729IBLLavw9By/zb5hB36adT8IYRqvKIcv6vlQPCb
         fwzYjXC3SoMt5P8cDOp8JPPwhG49fUPTafGs88m5LTU4gDwhrLmEmZ9e+1gK/+hTkCCU
         e68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=njmwgWPUw/GV5aYZwf+RIQBn0ZuJmsiVzCYdG8QWhyE=;
        b=hL7ZwZvfJ/fnjqDa1BoOyBpfR0AqcWeNWCyspzVXfLIFya4Py8HhLE1CW8SsKmErhh
         uL4lda0t1u11aNN6FdMkSxbnzqvdwg6rCIY8/nN8HyZYy8x3albSzmulhtJw6ONboU9m
         v1pgKjtdiTs1ECVx0bw8TydNxMFPKyjTZNDtv3GAKf/5WXWyyZ+zccdpO1G7zMLD1kVK
         eQDNphlvw735OnPiSAQhpUoPxihdasJvD5B1t2fwjnNAXfNGepnmP916kiODR7h5qJqJ
         cucTMUrYBD79ZSrVWjLK5YjTK545jRz0hlCz9f2Mr0keefIneXyDuI7wMcOxaLZNiPZ1
         J6zw==
X-Gm-Message-State: AOAM530GULlv6l7STErFnMQPCc/xI0VXQZpt6Afvt11faR0tZCWi125n
        19Vuxr2dzcu7lV3Xv/tpABU=
X-Google-Smtp-Source: ABdhPJzUAgd4UXi3cGSG8BYEbK1wovBvu11yix4efUV3JPWtjr2iTMY77FCN13yTjbVKRBnEzy67uA==
X-Received: by 2002:a5d:68c2:: with SMTP id p2mr17072302wrw.253.1590922927709;
        Sun, 31 May 2020 04:02:07 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id j190sm7846430wmb.33.2020.05.31.04.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 04:02:07 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH 3/3] overlay: add unionmount tests with nested overlay
Date:   Sun, 31 May 2020 14:01:56 +0300
Message-Id: <20200531110156.6613-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200531110156.6613-1-amir73il@gmail.com>
References: <20200531110156.6613-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

These tests use an overlay mount as lower layer for a nested overlay.
That provides test coverage for a lower layer with null uuid and
lower layer with real inode numbers that use the high xino bits.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/110     | 39 +++++++++++++++++++++++++++++++++++++++
 tests/overlay/110.out |  2 ++
 tests/overlay/111     | 40 ++++++++++++++++++++++++++++++++++++++++
 tests/overlay/111.out |  2 ++
 tests/overlay/112     | 40 ++++++++++++++++++++++++++++++++++++++++
 tests/overlay/112.out |  2 ++
 tests/overlay/113     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/overlay/113.out |  2 ++
 tests/overlay/114     | 39 +++++++++++++++++++++++++++++++++++++++
 tests/overlay/114.out |  2 ++
 tests/overlay/115     | 40 ++++++++++++++++++++++++++++++++++++++++
 tests/overlay/115.out |  2 ++
 tests/overlay/116     | 40 ++++++++++++++++++++++++++++++++++++++++
 tests/overlay/116.out |  2 ++
 tests/overlay/117     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/overlay/117.out |  2 ++
 tests/overlay/group   |  8 ++++++++
 17 files changed, 344 insertions(+)
 create mode 100755 tests/overlay/110
 create mode 100644 tests/overlay/110.out
 create mode 100755 tests/overlay/111
 create mode 100644 tests/overlay/111.out
 create mode 100755 tests/overlay/112
 create mode 100644 tests/overlay/112.out
 create mode 100755 tests/overlay/113
 create mode 100644 tests/overlay/113.out
 create mode 100755 tests/overlay/114
 create mode 100644 tests/overlay/114.out
 create mode 100755 tests/overlay/115
 create mode 100644 tests/overlay/115.out
 create mode 100755 tests/overlay/116
 create mode 100644 tests/overlay/116.out
 create mode 100755 tests/overlay/117
 create mode 100644 tests/overlay/117.out

diff --git a/tests/overlay/110 b/tests/overlay/110
new file mode 100755
index 00000000..8d34f23e
--- /dev/null
+++ b/tests/overlay/110
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 110
+#
+# Run unionmount testsuite on a nested overlay filesystem
+# with single lower overlay layer, whose layers are
+# on same fs
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
+_unionmount_testsuite_run --ovov --samefs --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/110.out b/tests/overlay/110.out
new file mode 100644
index 00000000..4284b8b0
--- /dev/null
+++ b/tests/overlay/110.out
@@ -0,0 +1,2 @@
+QA output created by 110
+Silence is golden
diff --git a/tests/overlay/111 b/tests/overlay/111
new file mode 100755
index 00000000..b99f94da
--- /dev/null
+++ b/tests/overlay/111
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 111
+#
+# Run unionmount testsuite on a nested overlay filesystem
+# with single lower overlay layer, whose layers are
+# on same fs
+# with xino enabled (xino overflow not expected)
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
+_unionmount_testsuite_run --ovov --samefs --xino --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/111.out b/tests/overlay/111.out
new file mode 100644
index 00000000..fedcd590
--- /dev/null
+++ b/tests/overlay/111.out
@@ -0,0 +1,2 @@
+QA output created by 111
+Silence is golden
diff --git a/tests/overlay/112 b/tests/overlay/112
new file mode 100755
index 00000000..5e8f980b
--- /dev/null
+++ b/tests/overlay/112
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 112
+#
+# Run unionmount testsuite on a nested overlay filesystem
+# with single lower overlay layer, whose layers are
+# not on same fs
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
+_unionmount_testsuite_run --ovov --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/112.out b/tests/overlay/112.out
new file mode 100644
index 00000000..0f75273b
--- /dev/null
+++ b/tests/overlay/112.out
@@ -0,0 +1,2 @@
+QA output created by 112
+Silence is golden
diff --git a/tests/overlay/113 b/tests/overlay/113
new file mode 100755
index 00000000..b865f364
--- /dev/null
+++ b/tests/overlay/113
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 113
+#
+# Run unionmount testsuite on a nested overlay filesystem
+# with single lower overlay layer, whose layers are
+# not on same fs
+# with xino enabled (expected xino overflows)
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
+_unionmount_testsuite_run --ovov --xino --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/113.out b/tests/overlay/113.out
new file mode 100644
index 00000000..5cdea7de
--- /dev/null
+++ b/tests/overlay/113.out
@@ -0,0 +1,2 @@
+QA output created by 113
+Silence is golden
diff --git a/tests/overlay/114 b/tests/overlay/114
new file mode 100755
index 00000000..fc783f57
--- /dev/null
+++ b/tests/overlay/114
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 114
+#
+# Run unionmount testsuite on a nested overlay filesystem
+# with multi lower layers, lowermost is an overlay layer,
+# whose layers are on same fs
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
+_unionmount_testsuite_run --ovov=10 --samefs --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/114.out b/tests/overlay/114.out
new file mode 100644
index 00000000..a2aa4a21
--- /dev/null
+++ b/tests/overlay/114.out
@@ -0,0 +1,2 @@
+QA output created by 114
+Silence is golden
diff --git a/tests/overlay/115 b/tests/overlay/115
new file mode 100755
index 00000000..b82128d6
--- /dev/null
+++ b/tests/overlay/115
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 115
+#
+# Run unionmount testsuite on a nested overlay filesystem
+# with multi lower layers, lowermost is an overlay layer,
+# whose layers are on same fs
+# with xino enabled (xino overflow not expected)
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
+_unionmount_testsuite_run --ovov=10 --samefs --xino --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/115.out b/tests/overlay/115.out
new file mode 100644
index 00000000..d9dd136f
--- /dev/null
+++ b/tests/overlay/115.out
@@ -0,0 +1,2 @@
+QA output created by 115
+Silence is golden
diff --git a/tests/overlay/116 b/tests/overlay/116
new file mode 100755
index 00000000..1575bece
--- /dev/null
+++ b/tests/overlay/116
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 116
+#
+# Run unionmount testsuite on a nested overlay filesystem
+# with multi lower layers, lowermost is an overlay layer,
+# whose layers are not on same fs
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
+_unionmount_testsuite_run --ovov=10 --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/116.out b/tests/overlay/116.out
new file mode 100644
index 00000000..a2013bc3
--- /dev/null
+++ b/tests/overlay/116.out
@@ -0,0 +1,2 @@
+QA output created by 116
+Silence is golden
diff --git a/tests/overlay/117 b/tests/overlay/117
new file mode 100755
index 00000000..819edc9b
--- /dev/null
+++ b/tests/overlay/117
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 117
+#
+# Run unionmount testsuite on a nested overlay filesystem
+# with multi lower layers, lowermost is an overlay layer,
+# whose layers are not on same fs
+# with xino enabled (expected xino overflows)
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
+_unionmount_testsuite_run --ovov=10 --xino --verify
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/117.out b/tests/overlay/117.out
new file mode 100644
index 00000000..986c5152
--- /dev/null
+++ b/tests/overlay/117.out
@@ -0,0 +1,2 @@
+QA output created by 117
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 079ff0af..047ea046 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -87,3 +87,11 @@
 107 auto union rotate nonsamefs xino
 108 auto union rotate nonsamefs
 109 auto union rotate nonsamefs xino
+110 auto quick union nested samefs
+111 auto quick union nested samefs xino
+112 auto quick union nested nonsamefs
+113 auto quick union nested nonsamefs xino
+114 auto union rotate nested samefs
+115 auto union rotate nested samefs xino
+116 auto union rotate nested nonsamefs
+117 auto union rotate nested nonsamefs xino
-- 
2.17.1

