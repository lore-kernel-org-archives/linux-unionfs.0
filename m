Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBC6C43460
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3BED61288
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhDYHPe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Apr 2021 03:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhDYHPe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Apr 2021 03:15:34 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABE4C061756;
        Sun, 25 Apr 2021 00:14:53 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e5so23903334wrg.7;
        Sun, 25 Apr 2021 00:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S2iJdrFUBFYZMKDHDAlnw9LDDh8hRAveUSxMiqeVjXQ=;
        b=WORP8m33oIiU7UYyKj7+iwGS9TMNqqkbN45xyef1LNyt+dR6A65Y5zXufdlQea6VQ3
         jCrMpnmNVgzfT4m8Tl0my3/+ahMm1H1X5KRT7z2o5ZCF30JhCAB+ouDq2jqpuMMHqqpN
         dHok1HkWtQkRkVd7TnUEfwt8aCQkYWTlxdOnul7bvH/8kGNaJsPTh8UYv7guZbrv47Mp
         TKUPrL/suHQQMwPqFBb5IuPrtNK+qJNj1nDqCLzZ8XdaUQ72DGVnWYQaC1W1CwXtanVG
         OmmftHCluroMJiQ+Jc9Ojc724MN47/hwgO/w6+EYhXtAAP/6ZNywYldpL9jCQt1XiVTk
         kSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S2iJdrFUBFYZMKDHDAlnw9LDDh8hRAveUSxMiqeVjXQ=;
        b=ZqtK4ar1aDZlmXXj6vaVL3vCDPUzh3HXA2FNIGc+mxZUjIfear1BQqGkjONO8/Lca6
         tHeXWvdxQsBok5hu/copn6xnmAy69HiEUQKyPQqdIdnQyxEQl+qimyMkBQVgR4R0t4KF
         H+hpZGbA1pEgsvvqwVBU/TCOUqfpo9QmvdmTmBfk/qG/JaZ356wtTlctsRr+EwjoFOSq
         7dOGWyyTQNi/QPviHOlct8yRddJF+Hk8HSm+PKe/JxMuK9xOJOqmCrQH5bOsnTXV9HFU
         twWoTZEdp2dtXAdzZ51/5ZXuWlpH/ippwuCsaVJjMe11DOTUr3UebSTZSPqg9HUgv6hL
         7Zqw==
X-Gm-Message-State: AOAM5320TLSkBbG8Xic2/47tL3UYtVlgUoD2nCvli1hHT5orLCyYt02F
        5oQB9b0STdG5p+Nj0hC/7vo=
X-Google-Smtp-Source: ABdhPJxzvZPSkbFmULhqQ50YcWT/9AqHz15M9XpKK5ROhd5TpZwja+rSQfraJFfIy5FSwypfpQAFhQ==
X-Received: by 2002:adf:a119:: with SMTP id o25mr15104991wro.36.1619334892544;
        Sun, 25 Apr 2021 00:14:52 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.37])
        by smtp.gmail.com with ESMTPSA id x189sm15885626wmg.17.2021.04.25.00.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 00:14:51 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 4/5] generic: Test readdir of modified directrory
Date:   Sun, 25 Apr 2021 10:14:44 +0300
Message-Id: <20210425071445.29547-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210425071445.29547-1-amir73il@gmail.com>
References: <20210425071445.29547-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Check that directory modifications to an open dir fd are observed
by a new open fd.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/700     | 62 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/700.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 65 insertions(+)
 create mode 100755 tests/generic/700
 create mode 100644 tests/generic/700.out

diff --git a/tests/generic/700 b/tests/generic/700
new file mode 100755
index 00000000..3ece88d4
--- /dev/null
+++ b/tests/generic/700
@@ -0,0 +1,62 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
+#
+# Check that directory modifications to an open dir are observed
+# by a new open fd
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_require_test
+
+rm -f $seqres.full
+
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
+
+# Use small getdents bufsize to fit less than 10 entries
+# stuct linux_dirent64 is 20 bytes not including d_name
+bufsize=200
+
+# Check readdir content of an empty dir changes when adding a new file
+echo -e "\nCreate file 0 in an open dir:" >> $seqres.full
+$here/src/t_dir_offset2 $testdir $bufsize "+0" 2>&1 >> $seqres.full || \
+	echo "Missing created file in open dir (see $seqres.full for details)"
+
+# Create enough files to be returned in multiple gendents() calls.
+# At least one of the files that we delete will not be listed in the
+# first call, so we may encounter stale entries in following calls.
+for n in {1..100}; do
+    touch $testdir/$n
+done
+
+# Check readdir content changes after removing files
+for n in {1..10}; do
+	echo -e "\nRemove file ${n}0 in an open dir:" >> $seqres.full
+	$here/src/t_dir_offset2 $testdir $bufsize "-${n}0" 2>&1 >> $seqres.full || \
+		echo "Found unlinked files in open dir (see $seqres.full for details)"
+done
+
+# success, all done
+echo "Silence is golden"
+status=0
diff --git a/tests/generic/700.out b/tests/generic/700.out
new file mode 100644
index 00000000..f9acaa71
--- /dev/null
+++ b/tests/generic/700.out
@@ -0,0 +1,2 @@
+QA output created by 700
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index ab00cc04..bac5aa48 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -634,3 +634,4 @@
 629 auto quick rw copy_range
 630 auto quick rw dedupe clone
 631 auto rw overlay rename
+700 auto quick dir
-- 
2.31.1

