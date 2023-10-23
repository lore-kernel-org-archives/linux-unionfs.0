Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B17FC004C0
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Oct 2023 16:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbjJWQdK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 12:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjJWQdJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Oct 2023 12:33:09 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD4F127;
        Mon, 23 Oct 2023 09:33:05 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-4083cd39188so27248025e9.2;
        Mon, 23 Oct 2023 09:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698078784; x=1698683584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sTfKxVAahfIINjB7Pkvys5g8SGDugdeKHRIB/ORxmLU=;
        b=S11GAFjk8cmaJ6UTevkZDciYyQeCCHDSZT4OXRE7aG87fOZIgDiZRWWvgoO5j7fGD+
         eGugqzR8ZaJoJF8wRDPRL7/SBz6iFdCeeC6uiHTlQ+LoqZwIs01jXQtHBDh2/O4BJwUs
         nPGPd21dp+vHQP8K/sw7kST8lhGKcHS718Qsi+KrXB3nDLdhX7bzcIe18eST451VZIzp
         LO9tsReGeE3dkZvHMm0Q7zVMTuUCz8ZF66TOt70ecubOz4uLYVgNjHSzegKEOIjDcazw
         rk7jRvhmtxIcUzydsoOtR5KafBfA/CLw78AT/zxrYmIWoSlSxnXVoxBoG+pE5Zsn0VA4
         +RXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698078784; x=1698683584;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sTfKxVAahfIINjB7Pkvys5g8SGDugdeKHRIB/ORxmLU=;
        b=D1QByliM36hsmsJUANuxQhhL5GtDk+SXn1iwfY27og6HL6NkZc0AzORFS0Pt/2F8Du
         PrqOXFtW9sMtnPQrZW3QShtbLpejP7SH90KgNmDyYcmJoNTZQvtj1ckkOcbYQo9c19Yt
         DBh2lZi9X6IJyJcWKQjWxU3cZtf2Wt9J7d7XE74SJgIZg7KmAxyn25J+YmpeROongc+3
         efRwOycO6/5B+Ljj7OJzG4yc3wU6uhtXApXyHBrBdDaK8TmHpqhqGQevzhHmWiCBOOJ4
         bDs7fGPFGS0aLvhoZ0CFRVhbTOICXMsSTZ0jb7k9+mdMnqE24v1yZFp7f2sO57A+AzR9
         xUig==
X-Gm-Message-State: AOJu0YyZLi05fK5ZVjNL09nGJMEiEqkvZxkamcLHySZONTcSRor3Pv3V
        fU59CYPsvmm7Bc09tS2WQdI=
X-Google-Smtp-Source: AGHT+IFHtstWIUCFNLfEta3PTeUw/es/+IsrQdznFdgMVzFNyCFKZGFEYgrW3yekYHW2DvjT+Lt1zg==
X-Received: by 2002:a05:600c:1912:b0:407:58e1:24ed with SMTP id j18-20020a05600c191200b0040758e124edmr7051473wmq.39.1698078783749;
        Mon, 23 Oct 2023 09:33:03 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t22-20020a05600c41d600b004083996dad8sm14384665wmh.18.2023.10.23.09.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 09:33:03 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        Karel Zak <kzak@redhat.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v3] overlay: add test for lowerdir mount option parsing
Date:   Mon, 23 Oct 2023 19:32:59 +0300
Message-Id: <20231023163259.2949803-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Check parsing and display of spaces and escaped colons and commans in
lowerdir mount option.

This is a regression test for two bugs introduced in v6.5 with the
conversion to new mount api.

There is another regression of new mount api related to libmount parsing
of escaped commas, but this needs a fix in libmount - this test only
verifies the fixes in the kernel, so it uses LIBMOUNT_FORCE_MOUNT2=always
to force mount(2) and kernel pasring of the comma separated options list.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Changes since v2:
- Fix test for when index feature is enabled

Changes since v1:
- Fix test for libmount >= 2.39

 tests/overlay/083     | 76 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/083.out |  2 ++
 2 files changed, 78 insertions(+)
 create mode 100755 tests/overlay/083
 create mode 100644 tests/overlay/083.out

diff --git a/tests/overlay/083 b/tests/overlay/083
new file mode 100755
index 00000000..df82d1fd
--- /dev/null
+++ b/tests/overlay/083
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 083
+#
+# Test regressions in parsing and display of special chars in mount options.
+#
+# The following kernel commits from v6.5 introduced regressions:
+#  b36a5780cb44 ("ovl: modify layer parameter parsing")
+#  1784fbc2ed9c ("ovl: port to new mount api")
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
+_fixed_by_kernel_commit 32db51070850 \
+	"ovl: fix regression in showing lowerdir mount option"
+_fixed_by_kernel_commit c34706acf40b \
+	"ovl: fix regression in parsing of mount options with escaped comma"
+
+# _overlay_check_* helpers do not handle special chars well
+_require_scratch_nocheck
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create lowerdirs with special characters
+lowerdir_spaces="$OVL_BASE_SCRATCH_MNT/lower1 with  spaces"
+lowerdir_colons="$OVL_BASE_SCRATCH_MNT/lower2:with::colons"
+lowerdir_commas="$OVL_BASE_SCRATCH_MNT/lower3,with,,commas"
+lowerdir_colons_esc="$OVL_BASE_SCRATCH_MNT/lower2\:with\:\:colons"
+lowerdir_commas_esc="$OVL_BASE_SCRATCH_MNT/lower3\,with\,\,commas"
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+mkdir -p "$lowerdir_spaces" "$lowerdir_colons" "$lowerdir_commas"
+
+# _overlay_mount_* helpers do not handle special chars well, so execute mount directly.
+# if escaped colons are not parsed correctly, mount will fail.
+$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
+	-o"upperdir=$upperdir,workdir=$workdir" \
+	-o"lowerdir=$lowerdir_colons_esc:$lowerdir_spaces" \
+	2>&1 | tee -a $seqres.full
+
+# if spaces are not escaped when showing mount options,
+# mount command will not show the word 'spaces' after the spaces
+$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full | grep -v spaces && \
+	echo "ERROR: escaped spaces truncated from lowerdir mount option"
+
+# Re-create the upper/work dirs to mount them with a different lower
+# This is required in case index feature is enabled
+$UMOUNT_PROG $SCRATCH_MNT
+rm -rf "$upperdir" "$workdir"
+mkdir -p "$upperdir" "$workdir"
+
+# Kernel commit c34706acf40b fixes parsing of mount options with escaped comma
+# when the mount options string is provided via data argument to mount(2) syscall.
+# With libmount >= 2.39, libmount itself will try to split the comma separated
+# options list provided to mount(8) commnad line and call fsconfig(2) for each
+# mount option seperately.  Since libmount does not obay to overlayfs escaped
+# commas format, it will call fsconfig(2) with the wrong path (i.e. ".../lower3")
+# and this test will fail, but the failure would indicate a libmount issue, not
+# a kernel issue.  Therefore, force libmount to use mount(2) syscall, so we only
+# test the kernel fix.
+LIBMOUNT_FORCE_MOUNT2=always $MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_DEV $SCRATCH_MNT \
+	-o"upperdir=$upperdir,workdir=$workdir,lowerdir=$lowerdir_commas_esc" 2>> $seqres.full || \
+	echo "ERROR: incorrect parsing of escaped comma in lowerdir mount option"
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/083.out b/tests/overlay/083.out
new file mode 100644
index 00000000..0beba309
--- /dev/null
+++ b/tests/overlay/083.out
@@ -0,0 +1,2 @@
+QA output created by 083
+Silence is golden
-- 
2.34.1

