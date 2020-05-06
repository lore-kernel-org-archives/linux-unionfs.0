Return-Path: <SRS0=Z7uo=6U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8C7C38A24
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E7DC206DB
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:23:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nSwjVV/a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgEFKXK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 6 May 2020 06:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726354AbgEFKXK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 May 2020 06:23:10 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3906AC061A10;
        Wed,  6 May 2020 03:23:10 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h9so1556133wrt.0;
        Wed, 06 May 2020 03:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=drv/lQshwMz8JFGCjWSMSWEKkTBM8hi+ByQlYWp40hs=;
        b=nSwjVV/aXv1ZyEux69h0s4N/dMygvEi8LNiAvPcdo83hVmEn766fuq8IfMt5emxI6z
         67MXWYXipFmC55wl5cjCnxn3LI8ib+l2uEEHDSGpJ94+G+ix5ldFcLqZ0YwMKgooOK2t
         hialsHMyt7JTwwcZqEGpQp6MTAVKwAAYvmR6P48NoAzLJgLCO9awR5egzcxJZ7eQXtWe
         /+iq+SUkOj9ajw/1e+GpNsgqArXgmiyicox4eCYAN0yBf7njmfDL1UNlEfZH5z32l6bC
         z/RG8R8Ovw01x2jg9BfJp0sSdo69WsoW0UNwG1wtMOLplGdbjuA3+5dP3m1nmdki/XYb
         VmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=drv/lQshwMz8JFGCjWSMSWEKkTBM8hi+ByQlYWp40hs=;
        b=O/J7B1xQ216vP6yYYJvMWsNgfSiNTF4v+hchXyU7EyacxoYb5/zcrXYdDgDM9xcvsn
         6kTm8xGp/UtKyL7lqDxwCtlsETwoI1ARF7bRgaGo6cy562p8DJ11Zu6f4mUxjrVOI7dI
         bIEGd9l9xQemsicmm/ob+Uijo4vcpCcoZ5ylmhjLFSc4BM1phNfQL7YmpfSTbVURMOuj
         Tuk6jV6hO33gX65j79RVD4H4+74tETfx1RVe1eRIHVQ1bwr+csm8+KjcJtY9z26g+0Qo
         xaNzLMkBiFf2FWTBZ7lOVpY1I0qzct0TvEdhrByPoOqVpJ+qghcLjrjDd1GwvkI9iryP
         j8Lw==
X-Gm-Message-State: AGi0PuZ70oPnqYGSFQ7GkDQWtkDZkEAB+ZeZNx7q2zOO5Eq+94JtEaFK
        jEfN8qIs6kbMT29yGnCyB/Q=
X-Google-Smtp-Source: APiQypL4WMshvTf8mO8fn2rPkHBdhvgg3je+vqQNo/6idAKMG6DIVSeWQ98O6MG3JMeRnrC0rlJMAw==
X-Received: by 2002:adf:decb:: with SMTP id i11mr8103744wrn.172.1588760588946;
        Wed, 06 May 2020 03:23:08 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id u2sm2421379wrd.40.2020.05.06.03.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 03:23:08 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Lubos Dolezel <lubos@dolezel.info>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 2/2] overlay: regression test for two file handle bugs
Date:   Wed,  6 May 2020 13:22:59 +0300
Message-Id: <20200506102259.28107-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506102259.28107-1-amir73il@gmail.com>
References: <20200506102259.28107-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Test two overlayfs file handle bugs:

 1. Failure to query file handle size
    Fixed by kernel commit:
        ovl: return required buffer size for file handles

 2. Kernel OOPS on open by hand crafted malformed file handle
    Fixed by kernel commit:
        ovl: potential crash in ovl_fid_to_fh()

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/073     | 80 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/073.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 83 insertions(+)
 create mode 100755 tests/overlay/073
 create mode 100644 tests/overlay/073.out

diff --git a/tests/overlay/073 b/tests/overlay/073
new file mode 100755
index 00000000..72233fae
--- /dev/null
+++ b/tests/overlay/073
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test No. 073
+#
+# Test two overlayfs file handle bugs:
+# 1. Failure to query file handle size
+#    Fixed by kernel commit:
+#        ovl: return required buffer size for file handles
+#
+# 2. Kernel OOPS on open by hand crafted malformed file handle
+#    Fixed by kernel commit:
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
+	#rm -f $tmp.*
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
+$XFS_IO_PROG -c "pwrite -S 0 0 8" -c "pwrite -S 1 0 1" -c "pwrite -S 0xfb 4 1" $tmp.file_handle >> $seqres.full
+
+# Verify failure to open by mangled file handle
+# This will trigger NULL pointer dereference on affected kernels
+$here/src/open_by_handle -i $tmp.file_handle $testdir 2>> $seqres.full && \
+	_fail "open by mangaled file handle is expected to fail"
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/073.out b/tests/overlay/073.out
new file mode 100644
index 00000000..d107704c
--- /dev/null
+++ b/tests/overlay/073.out
@@ -0,0 +1,2 @@
+QA output created by 073
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 82876d09..5625a46d 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -75,3 +75,4 @@
 070 auto quick copyup redirect nested
 071 auto quick copyup redirect nested nonsamefs
 072 auto quick copyup hardlink
+073 auto quick exportfs dangerous
-- 
2.17.1

