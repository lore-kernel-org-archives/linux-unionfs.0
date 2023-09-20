Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C85CE79CF
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Sep 2023 13:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbjITNEM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbjITNEL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Sep 2023 09:04:11 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE7F110;
        Wed, 20 Sep 2023 06:04:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-40472f9db24so69201415e9.2;
        Wed, 20 Sep 2023 06:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695215040; x=1695819840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B18NZDPfSxLy6d5nXGVRy8wMCFyVvLEDcpyKM5b/hlI=;
        b=CB1I8QY1hqN69B5xSwcumIHedW+Y8bbBR9NrqcnbaCLv/qIq33ioGIH4NOF7CNv9th
         QRlJdi+4PTrroHkkbUW7/kPJyeZqe3gMWAJmgduks3Rt4qsy03XBU2HEFzQRzdpaKlHj
         H6bzxE9TD02FO0c5vDcv68ZJLlp0duMkMzQTnSm4PUKPrXSwFsmWSjZkTPtQuXCAP0oX
         6pn1nSPr3YnWe1Y1MBjTCns6KKezJQIMC8j0yU8/jnJUHOUC0eRJB/ZJCkd8z2GNY69T
         KAnOJtd7TfPzOxM1rLwXAbw0ay469J3AEaopMQVgUdeqNMikuYeajarozUZU8o7i2VCU
         9xGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695215040; x=1695819840;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B18NZDPfSxLy6d5nXGVRy8wMCFyVvLEDcpyKM5b/hlI=;
        b=c91c+RhV8yMgJweX+urCHzfT2vqUDU36C3R3zWnaAr0Y4kNTwSsVDzMsHOeLb7HVq0
         YksRiHPpvzIYcgu3oRLfJE4OQILmGOpLzy7FyfVbBOY8uT6x3I9sSLTb7OgYxcMINzKX
         wO30PJy1dpqKH45PWionAUE4hvhc8CmkbOjWOpIkngBEHS2y3gIFPTu4NrEzy5v/nmze
         J4uVw2T0/4CTV+3QpD8MrUeKwrh5d4DWCTE4JM17lze6IDOTfEJyVAbBpqxY8SgY/J79
         znIFlZBDy6j/BywKCDBx4P6XAU5X0umlDjkKwNyt0TpSQx5ZjskKJKtXmlBBi19fX/uR
         l+IA==
X-Gm-Message-State: AOJu0YxesXNrn6u/0O+yzHU2OJL89WRfAI7J3TsMv0JUU+egVrg+z9bl
        d2Bd6MU+MH5JZRed76Ode1M=
X-Google-Smtp-Source: AGHT+IFvbdS9547ny1cSX1oyaXCUGCEUmWh1XOzUYmFRlAc1ViDVU473QhIKU4HRVGSJ795iEblaJw==
X-Received: by 2002:a05:600c:22ce:b0:401:b493:f7c1 with SMTP id 14-20020a05600c22ce00b00401b493f7c1mr2356758wmg.35.1695215039797;
        Wed, 20 Sep 2023 06:03:59 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id bi19-20020a05600c3d9300b00404719b05b5sm1914807wmb.27.2023.09.20.06.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 06:03:59 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] overlay: add test for rename of lower symlink with NOATIME attr
Date:   Wed, 20 Sep 2023 16:03:55 +0300
Message-Id: <20230920130355.62763-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

A test for a regression from v5.15 reported by Ruiwen Zhao:
https://lore.kernel.org/linux-unionfs/CAKd=y5Hpg7J2gxrFT02F94o=FM9QvGp=kcH1Grctx8HzFYvpiA@mail.gmail.com/

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

This is a test for a regression in kernel v5.15.
The fix was merged for 6.6-rc2 and has been picked for
the upcoming LTS releases 5.15, 6.1, 6.5.

The reproducer only manifests the bug in fs that inherit noatime flag,
namely ext4, btrfs, ... but not xfs.

The test does _notrun on xfs for that reason.

Thanks,
Amir.

 tests/overlay/082     | 68 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/082.out |  2 ++
 2 files changed, 70 insertions(+)
 create mode 100755 tests/overlay/082
 create mode 100644 tests/overlay/082.out

diff --git a/tests/overlay/082 b/tests/overlay/082
new file mode 100755
index 00000000..abea3c2b
--- /dev/null
+++ b/tests/overlay/082
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 082
+#
+# kernel commit 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
+# from v5.15 introduced a regression.
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs overlay
+_fixed_by_kernel_commit ab048302026d \
+	"ovl: fix failed copyup of fileattr on a symlink"
+
+_require_scratch
+_require_chattr A
+
+# remove all files from previous runs
+_scratch_mkfs
+
+# prepare lower test dir with NOATIME flag
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $lowerdir/testdir
+$CHATTR_PROG +A $lowerdir/testdir >> $seqres.full 2>&1 ||
+	_notrun "base fs $OVL_BASE_FSTYP does not support No_Atime flag"
+
+# The NOATIME is inheritted to children symlink in ext4/fs2fs
+# (and on tmpfs on recent kernels).
+# The overlayfs test will not fail unless base fs is
+# one of those filesystems.
+#
+# The problem with this inheritence is that the NOATIME flag is inheritted
+# to a symlink and the flag does take effect, but there is no way to query
+# the flag (lsattr) or change it (chattr) on a symlink, so overlayfs will
+# fail when trying to copy up NOATIME flag from lower to upper symlink.
+#
+touch $lowerdir/testdir/foo
+ln -sf foo $lowerdir/testdir/lnk
+
+$LSATTR_PROG -l $lowerdir/testdir/foo >> $seqres.full 2>&1
+$LSATTR_PROG -l $lowerdir/testdir/foo | grep -q No_Atime || \
+	_notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag"
+
+before=$(stat -c %x $lowerdir/testdir/lnk)
+echo "symlink atime before readlink: $before" >> $seqres.full 2>&1
+cat $lowerdir/testdir/lnk
+after=$(stat -c %x $lowerdir/testdir/lnk)
+echo "symlink atime after readlink: $after" >> $seqres.full 2>&1
+
+[ "$before" == "$after" ] || \
+	_notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag on symlink"
+
+# mounting overlay
+_scratch_mount
+
+# moving symlink will try to copy up lower symlink flags
+mv $SCRATCH_MNT/testdir/lnk $SCRATCH_MNT/
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/082.out b/tests/overlay/082.out
new file mode 100644
index 00000000..2977f141
--- /dev/null
+++ b/tests/overlay/082.out
@@ -0,0 +1,2 @@
+QA output created by 082
+Silence is golden
-- 
2.34.1

