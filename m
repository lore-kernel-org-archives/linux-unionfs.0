Return-Path: <SRS0=M/3b=6E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CD9C38A30
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Apr 2020 10:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55BEE2078E
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Apr 2020 10:35:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nG/zNytA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgDTKfC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 06:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTKfB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Apr 2020 06:35:01 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6F2C061A0C;
        Mon, 20 Apr 2020 03:35:01 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i10so11441958wrv.10;
        Mon, 20 Apr 2020 03:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=71jSQBVB1hEmUSXCpD1ZsizcB1aIAhtY2Vb35LS/asc=;
        b=nG/zNytAujL9D7iHHMb6Y+xHm0Wr7s/3D5cZcNq9/2xqLTpwjoElXA/EujGWKbgO5l
         KxHk4Px37HyP46ekQpcIqqlnhWeJzG5f6mZt63FUTlE9lLIuzyAN9J7mvlg0BhU40d0L
         i5wPV5Ya5ndHuTW209EvP3+C/eu1jKFFxYeKxQmW34DR4R9FhZwV/iWpN6+TzgToPTKE
         Jf/ypy4qNgTStUB6EgsHlh0Ao/DNuJ2xKKd7w3N3eO3xUttP0oRJty2tKV7Bk316Syj+
         gJE3dkn7QMppkc7aIz/cPZMh4/XwlRLMRps3XzA+s2QaEwZ1OsxOt5tVpUX+GqMHTVy5
         n3Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=71jSQBVB1hEmUSXCpD1ZsizcB1aIAhtY2Vb35LS/asc=;
        b=ZanFhi6yesOL2Ymo/u58RAYs3a0+6S1M21yocLyLekpcNLFbVYpPeBE/ITANO9SV5k
         w03tiv/KtTkt6s2VkIyjNwUb4nE1BVTpC2r2lIm6nG1ZtAXHc3TxSvSF+6r+Kel5s7ed
         d4u5Z66A7z7FEUhkLHUXIafUntwNlQYrJ3VwQ6vzJ6UxiqHXgrz80//X7gyv5FH6+fES
         Wn488OmzQyJGstFJCih9bV1xjzdFFOlFgea3VRD1gFPzbGS9nPmINRpeR9NoSb98WE7r
         NukofRLGrjLiXRmC7lFJ9VNzJtNsQSx42Ju9rxyZzyzbvz1lAShx6zaw//EA+GuUlHc8
         A7Uw==
X-Gm-Message-State: AGi0PuahT15WofgLJGkj7OXOWABYiqOy5tQshTf2UkZZCaVI6LVVEG9F
        o/2RfFFeuK4B/i2d0xefFuBHVnaU
X-Google-Smtp-Source: APiQypKQr6uPv5dEl6/bSvi0pATXzNDEC/dXT0ZLFSByTgk0qlYkD35ywaR3/TR/RQSax2i+2e9PEQ==
X-Received: by 2002:adf:aad4:: with SMTP id i20mr14625163wrc.47.1587378899749;
        Mon, 20 Apr 2020 03:34:59 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id 1sm833435wmz.13.2020.04.20.03.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 03:34:59 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2] overlay: another test for dropping nlink below zero
Date:   Mon, 20 Apr 2020 13:34:53 +0300
Message-Id: <20200420103453.26425-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This is a variant on test overlay/034.

This variant is mangling upper hardlinks instead of lower hardlinks
and does not require the inodes index feature.

This is a regression test for kernel commit 83552eacdfc0
("ovl: fix WARN_ON nlink drop to zero")

Signed-off-by: Amir Goldstein <amir73il@gmail.com>

V2:
- Fix stale comments about lower hardlinks
- Replace 'touch' with 'stat' of overlay inode

---
 tests/overlay/072     | 85 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/072.out |  3 ++
 tests/overlay/group   |  1 +
 3 files changed, 89 insertions(+)
 create mode 100755 tests/overlay/072
 create mode 100644 tests/overlay/072.out

diff --git a/tests/overlay/072 b/tests/overlay/072
new file mode 100755
index 00000000..d2cb93b9
--- /dev/null
+++ b/tests/overlay/072
@@ -0,0 +1,85 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 072
+#
+# Test overlay nlink when adding upper hardlinks.
+#
+# nlink of overlay inode could be dropped indefinitely by adding
+# unaccounted upper hardlinks underneath a mounted overlay and
+# trying to remove them.
+#
+# This is a variant of test overlay/034 with mangling of upper instead
+# of lower hardlinks. Unlike overlay/034, this test does not require the
+# inode index feature and will pass whether is it enabled or disabled
+# by default.
+#
+# This is a regression test for kernel commit 83552eacdfc0
+# ("ovl: fix WARN_ON nlink drop to zero").
+# Without the fix, the test triggers
+# WARN_ON(inode->i_nlink == 0) in drop_link().
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create upper hardlink
+mkdir -p $upperdir
+touch $upperdir/0
+ln $upperdir/0 $upperdir/1
+
+_scratch_mount
+
+# Verify overlay inode nlink 2 same as upper inode
+stat -c '%h' $SCRATCH_MNT/0
+
+# Add upper hardlinks while overlay is mounted - overlay inode nlink
+# is not being updated
+ln $upperdir/0 $upperdir/2
+ln $upperdir/0 $upperdir/3
+
+# Unlink the 2 un-accounted upper hardlinks - overlay inode nlinks
+# drops 2 and may reach 0 if the situation is not detected
+rm $SCRATCH_MNT/2
+rm $SCRATCH_MNT/3
+
+# Check if getting ENOENT when trying to link !I_LINKABLE with nlink 0
+ln $SCRATCH_MNT/0 $SCRATCH_MNT/4
+
+# Unlink all hardlinks - if overlay inode nlink is 0, this will trigger
+# WARN_ON() in drop_nlink()
+rm $SCRATCH_MNT/0
+rm $SCRATCH_MNT/1
+rm $SCRATCH_MNT/4
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/072.out b/tests/overlay/072.out
new file mode 100644
index 00000000..28eeb940
--- /dev/null
+++ b/tests/overlay/072.out
@@ -0,0 +1,3 @@
+QA output created by 072
+2
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 43ad8a52..82876d09 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -74,3 +74,4 @@
 069 auto quick copyup hardlink exportfs nested nonsamefs
 070 auto quick copyup redirect nested
 071 auto quick copyup redirect nested nonsamefs
+072 auto quick copyup hardlink
-- 
2.17.1

