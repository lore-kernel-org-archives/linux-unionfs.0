Return-Path: <SRS0=/kxx=73=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4CFC433E4
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 07:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B9F5207D3
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 07:01:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D/pB2cNR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgFNHBb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 Jun 2020 03:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgFNHBX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 Jun 2020 03:01:23 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DA1C08C5C3;
        Sun, 14 Jun 2020 00:01:22 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u26so11796024wmn.1;
        Sun, 14 Jun 2020 00:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zbzfo518C8JhEbFEZyO7j4q+r+5BxTBmU8yF4vlPh/I=;
        b=D/pB2cNROtVU4YReQc0MzkX6yA14B8U8WPevwnPGcHvTZ6cKprhMj/Ac///T4Vn7DG
         bV7LR2LXo/BrAad81LjR5cbKabcI6e9yV5usxmMuIQRtgOcIedKbG4spGh3SqZ8OMIti
         Nyk96N95dzYo3G6B8bzZKer03EMYy0axfdfSEt1lmZCZLSf4XTXjbam059r1n7XzirYm
         5reMGslIfC0YekQruZw95QlK+IOt0yUCsHJyPUDZTJywRE3STFKZ5TJPLh2BkFZ0MgMe
         0WoJKG4YwZ77dTJJUZJ0ojbY7hhYulIeIZcd4jMlmU+S98wdX2PiCvFY82unThjL66xd
         0IgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zbzfo518C8JhEbFEZyO7j4q+r+5BxTBmU8yF4vlPh/I=;
        b=Y75K1tQU3n/lTUJgl3alvtfKP+8l27tD7JGBmp/bLvu5BnsN1nIFw2XxdsLWmPy21X
         CKKvd+msuBAy0oLEeuqcLLlhs//eE2n4FrzHb6W45ULz0LCWWXL6B/vKIecpMGsAfdKv
         LyAsc7d8RFnFFNIEySZdGJs8TDJcd+Qb4N8hOkcvLhujm6X4b4KpnqnmDFLeo1mMVNVj
         thvBv+lyGgnR+C9Jxs9D2jAHG5v/LRavMqaqKeZqWyCm0eCfrJ7fakQQKxBlL3GZkpYn
         zS7M1V/4Nn9yFMi5AmGKqpc8h/KLYh468/UGckoKk5ekSMCJD9cgmUQPalWuNXHitUaH
         bYtQ==
X-Gm-Message-State: AOAM532OYrm/o+ziR85igkQ53lj3xhC9f0wgdy8riqSL9k3nU1OHpI/T
        I42sRLlrs2NFtKXUNsuHX5o=
X-Google-Smtp-Source: ABdhPJzEyY6wPgT9Vr9s9dvQbNN8+sqVBhoyHd1UskCXjpmO2DQZRpj7xOMgi5TJjktjYaUn5sqUYw==
X-Received: by 2002:a7b:cf13:: with SMTP id l19mr6804844wmg.76.1592118081594;
        Sun, 14 Jun 2020 00:01:21 -0700 (PDT)
Received: from localhost.localdomain ([5.102.204.95])
        by smtp.gmail.com with ESMTPSA id i10sm17951010wrw.51.2020.06.14.00.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 00:01:21 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Lubos Dolezel <lubos@dolezel.info>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 2/2] overlay: regression test for two file handle bugs
Date:   Sun, 14 Jun 2020 10:01:09 +0300
Message-Id: <20200614070109.29842-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200614070109.29842-1-amir73il@gmail.com>
References: <20200614070109.29842-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Test two overlayfs file handle bugs:

 1. Failure to query file handle size
    Fixed by kernel commit 144da23beab8:
        ovl: return required buffer size for file handles

 2. Kernel OOPS on open by hand crafted malformed file handle
    Fixed by kernel commit 9aafc1b01873:
        ovl: potential crash in ovl_fid_to_fh()

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Changes since v1:
- Document final kernel commit id
- Add test for mangled V1 file handle

 tests/overlay/074     | 92 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/074.out |  2 +
 tests/overlay/group   |  1 +
 3 files changed, 95 insertions(+)
 create mode 100755 tests/overlay/074
 create mode 100644 tests/overlay/074.out

diff --git a/tests/overlay/074 b/tests/overlay/074
new file mode 100755
index 00000000..29e3bebf
--- /dev/null
+++ b/tests/overlay/074
@@ -0,0 +1,92 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test No. 074
+#
+# Test two overlayfs file handle bugs:
+# 1. Failure to query file handle size
+#    Fixed by kernel commit 144da23beab8:
+#        ovl: return required buffer size for file handles
+#
+# 2. Kernel OOPS on open by hand crafted malformed file handle
+#    Fixed by kernel commit 9aafc1b01873:
+#        ovl: potential crash in ovl_fid_to_fh()
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
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_test_program "open_by_handle"
+# We need to require all features together, because nfs_export cannot
+# be enabled when index is disabled
+_require_scratch_overlay_features index nfs_export
+
+rm -f $seqres.full
+
+_scratch_mkfs
+_scratch_mount -o "index=on,nfs_export=on"
+
+testdir=$SCRATCH_MNT/testdir
+
+# Create directory with test file
+$here/src/open_by_handle -cp $testdir
+
+# Test query file handle size on dir and file
+$here/src/open_by_handle -pz $testdir
+
+# Export file handle into tmp file
+$here/src/open_by_handle -o $tmp.file_handle $testdir
+
+# Verify open by exported file handle
+$here/src/open_by_handle -i $tmp.file_handle $testdir
+
+# Mangle the exported file handle:
+# handle_bytes = 1
+# handle_type = OVL_FILEID_V0 (0xfb)
+# File handle is encoded in host order
+# The command below crafts this header for little endian.
+# On different big endian architectures the file handle will still
+# be malformed just not with the specific values to trigger the bug
+cp $tmp.file_handle $tmp.file_handle_v0
+$XFS_IO_PROG -c "pwrite -S 0 0 8" -c "pwrite -S 1 0 1" -c "pwrite -S 0xfb 4 1" \
+	$tmp.file_handle_v0 >> $seqres.full
+
+# Craft malformed v1 file handle:
+# handle_bytes = 1
+# handle_type = OVL_FILEID_V1 (0xf8)
+cp $tmp.file_handle $tmp.file_handle_v1
+$XFS_IO_PROG -c "pwrite -S 0 0 8" -c "pwrite -S 1 0 1" -c "pwrite -S 0xf8 4 1" \
+	$tmp.file_handle_v1 >> $seqres.full
+
+# Verify failure to open by mangled file handles
+# This will trigger NULL pointer dereference on affected kernels
+$here/src/open_by_handle -i $tmp.file_handle_v0 $testdir >> $seqres.full 2>&1 && \
+	_fail "open by mangaled file handle (v0) is expected to fail"
+# This may trigger out of bound access warning on affected kernels
+$here/src/open_by_handle -i $tmp.file_handle_v1 $testdir >> $seqres.full 2>&1 && \
+	_fail "open by mangaled file handle (v1) is expected to fail"
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/074.out b/tests/overlay/074.out
new file mode 100644
index 00000000..380f0657
--- /dev/null
+++ b/tests/overlay/074.out
@@ -0,0 +1,2 @@
+QA output created by 074
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 4841e47b..0cebcad0 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -76,3 +76,4 @@
 071 auto quick copyup redirect nested nonsamefs
 072 auto quick copyup hardlink
 073 auto quick whiteout
+074 auto quick exportfs dangerous
-- 
2.17.1

