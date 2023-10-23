Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4277C001E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 23 Oct 2023 10:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjJWKt2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 06:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjJWKt1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Oct 2023 06:49:27 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC86D76;
        Mon, 23 Oct 2023 03:49:23 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-32df66c691dso713553f8f.3;
        Mon, 23 Oct 2023 03:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698058162; x=1698662962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Al4aLml/xy+weWyHVCXdvWuTfYQMUhnSE97h2bvaWTU=;
        b=Q5TsdT6TjQkMkf3d5VCxsIpASCrdTl7av28f2B6jJjJ02gPZGbkbHFeIMreEJmFpUj
         AmmtmHyHvY4mG4tjetzbiLRaOvq1kgLaUVGYOxf5YLxfEViRBchS18b0w5y9/DQ5I/K5
         E/3TCiV02LRnlXpCLr5/tPUkrtzhZD5LzhU/HdjDH+CiShHGT607QZ+EssWThRQ3vfD6
         SsEJxYSfsC4nukVkY1GLAJfJhnklROEOlhZ0wuA6YyLgRdZlAxxO6b14nBbKrnj9qfJh
         bhuEqMKyb4kZ+6WiTFHBpKRSbP+yLZPQJFYLZoKiJ4BI6ni1phpTq/iSKz3+ImSf9tEf
         G0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698058162; x=1698662962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Al4aLml/xy+weWyHVCXdvWuTfYQMUhnSE97h2bvaWTU=;
        b=imu7W+8rP39NQZz+lGD75hFza3JLn7zKxeC7VURpbMlMkA2SSLjLaDTbDmiZzVlMCL
         Dlwvedi+t6goB4DLOvk4hbAy98qemR+HO85bHn2Ie9jY3jkLEw8xoZmGrf5pk13/BCdx
         iRHD85Scrk7AnrW4reTl7Y66GaNj3xw06fKmu0TiF5u4quMfr7NK48K8J3PJGJujaIAX
         FqgIMaGTrP7g8Ce/89f+4ELovEtUSHG0K1EAkLEkD5w9PDMo1VxHC8K8JSsTpGeA17Z9
         LtPL2DVrKOtR7ycyz2ydNJV/szABMEHf+RL8l/TkPYWuhWcRWOKrYP8tBUGH49IAoZT1
         1pHw==
X-Gm-Message-State: AOJu0YzSh397wzJ1vTAM/ACJdo6hiFk7twObRwXtYzArC1/2kVOuKU5t
        SGAbsDbXAW2oZCNBBrTUMX32LYzFjmg=
X-Google-Smtp-Source: AGHT+IHCoJlRjSW+BF/KGSahu9OrnjCznGgoGqQY9KfxPHW4rKtLvjcp1j2LT1VcRinAJCLsvBRtfA==
X-Received: by 2002:a5d:53d1:0:b0:323:36f1:c256 with SMTP id a17-20020a5d53d1000000b0032336f1c256mr4765025wrw.11.1698058161622;
        Mon, 23 Oct 2023 03:49:21 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id f10-20020adff98a000000b0031aef72a021sm7510581wrr.86.2023.10.23.03.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 03:49:19 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        Karel Zak <kzak@redhat.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2] overlay: add test for lowerdir mount option parsing
Date:   Mon, 23 Oct 2023 13:49:16 +0300
Message-Id: <20231023104916.2932366-1-amir73il@gmail.com>
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

Zorro,

I've fixed the libmount issue by splitting the combined test cases
to two test cases that corresspond to the two kernel fix commits.

The first test case (lowerdir_spaces) is agnostic to libmount version.

The second test case (lowerdir_commas) explicitly opts-in to mount(2)
syscall.

ATM, using LIBMOUNT_FORCE_MOUNT2=always, as the second test cases does,
would be our recommended workaround for the escaped commas regression
in v6.5, until libmount gets a fix to detect overlayfs escaped commas.

Thanks,
Amir.

 tests/overlay/083     | 71 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/083.out |  2 ++
 2 files changed, 73 insertions(+)
 create mode 100755 tests/overlay/083
 create mode 100644 tests/overlay/083.out

diff --git a/tests/overlay/083 b/tests/overlay/083
new file mode 100755
index 00000000..0f434951
--- /dev/null
+++ b/tests/overlay/083
@@ -0,0 +1,71 @@
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
+$UMOUNT_PROG $SCRATCH_MNT
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

