Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DFECDB483
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Oct 2023 10:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343690AbjJQKMH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 06:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343548AbjJQKL5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2023 06:11:57 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3064D114;
        Tue, 17 Oct 2023 03:11:53 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-32003aae100so4172429f8f.0;
        Tue, 17 Oct 2023 03:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697537511; x=1698142311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=abEVXyRKc81NsrCd6gmVxyPfhCrSclCAws76jFlb9bU=;
        b=jHZ4yC4DR2839F5u4mk6vNSwwuYEJJ+cE7/x/Kg9vqVgqdFA4i4hcyEAc91gmmAJBG
         cwpx32+OUSHcDFrUMXJjRX5mkLCnigVKOdKXbyRTE9WTIR6QUsMa208Y4r7G86VAT/D6
         5g4DlH/iS8yB0Y0ZzIVcc9AcXcTBlQ2HyiDyXlkBHXkrF1JAazT3X/dtN3QZwPXX4iyZ
         UqhdPdQIYF5Y6hM694f2WvaO8NER9i67PjgvQG6DjQWHT92+hKRhwMER9QxdG08hPSJD
         2evdLhzFC59YP7xhvUwwc+f+DfVdoOJ7slrUOb2+1LV5/ObB0NpoTyPRr03cmKS1clJz
         SIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697537511; x=1698142311;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=abEVXyRKc81NsrCd6gmVxyPfhCrSclCAws76jFlb9bU=;
        b=G6w6WHEqk9WJ5nKou/nm4+dYkjEN5eA5MuLcRGICl8XuBphAVWXMUcWkx7YZt+0p3+
         p7b+7WelLl2dtSXjM7CKudwiT4/zVYP7Vc1H1IkHaZYTuiZpemN45hYy1lh5OaxxMAWu
         COCPhSHhuZNXR/0L1WFId9bV0v/El7EuxqTCtTZrR/4PSHXkwOx1NOnUngroDMm2Sw6g
         0fWIhAD2jz7/bynVQzDt4gHWClw4fOMGdqGjvkg1vvUPKIMnT14O/R0t7TCuLyE0141H
         14eLawG7IQtEZ8g8/49dxEIywFzYJSMW3Vngby7aFEyNO0DNGNKmS4qjBdKvc7D6gMt8
         pyIw==
X-Gm-Message-State: AOJu0YwCrJVhlc7to/HPPTzhjL9It/JIrg2Plfv85lAtXjtTFilA+pk4
        bZL41XfGiQI5Z1fj8wLxeuY=
X-Google-Smtp-Source: AGHT+IFhPm/ML70anniu2XzBO1zj2firLtJi69avDmb5GYfl876S553+vvp31f1n/wlSmuD4IYPEMQ==
X-Received: by 2002:a5d:65c6:0:b0:32d:81f9:7712 with SMTP id e6-20020a5d65c6000000b0032d81f97712mr1367688wrw.20.1697537511030;
        Tue, 17 Oct 2023 03:11:51 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id a9-20020adffac9000000b003232380ffd5sm1314294wrs.106.2023.10.17.03.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 03:11:50 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] overlay: add test for lowerdir mount option parsing
Date:   Tue, 17 Oct 2023 13:11:45 +0300
Message-Id: <20231017101145.2348571-1-amir73il@gmail.com>
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

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

This is a test for two regressions in kernel v6.5.
The two fixes were merged in 6.6-rc6 and have been picked for
the upcoming LTS 6.5.y release.

Thanks,
Amir.

 tests/overlay/083     | 54 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/083.out |  2 ++
 2 files changed, 56 insertions(+)
 create mode 100755 tests/overlay/083
 create mode 100644 tests/overlay/083.out

diff --git a/tests/overlay/083 b/tests/overlay/083
new file mode 100755
index 00000000..071b4b84
--- /dev/null
+++ b/tests/overlay/083
@@ -0,0 +1,54 @@
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
+lowerdir1="$OVL_BASE_SCRATCH_MNT/lower1 with  spaces"
+lowerdir2="$OVL_BASE_SCRATCH_MNT/lower2:with::colons"
+lowerdir3="$OVL_BASE_SCRATCH_MNT/lower3,with,,commas"
+lowerdir2_esc="$OVL_BASE_SCRATCH_MNT/lower2\:with\:\:colons"
+lowerdir3_esc="$OVL_BASE_SCRATCH_MNT/lower3\,with\,\,commas"
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+mkdir -p "$lowerdir1" "$lowerdir2" "$lowerdir3"
+
+# _overlay_mount_* helpers do not handle special chars well, so execute mount directly.
+# if escaped colons and commas are not parsed correctly, mount will fail.
+$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
+	-o"upperdir=$upperdir,workdir=$workdir,lowerdir=$lowerdir3_esc:$lowerdir2_esc:$lowerdir1"
+
+# if spaces are not escaped when showing mount options,
+# mount command will not show the word 'spaces' after the spaces
+$MOUNT_PROG -t overlay | grep ovl_esc_test  | tee -a $seqres.full | grep -v spaces
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

