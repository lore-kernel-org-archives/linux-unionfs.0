Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F157C433B4
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC49E61288
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Apr 2021 07:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhDYHPg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Apr 2021 03:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhDYHPf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Apr 2021 03:15:35 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED1CC061574;
        Sun, 25 Apr 2021 00:14:55 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e5so23903348wrg.7;
        Sun, 25 Apr 2021 00:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vY9pa33hAaQweAU2f1GgzuYkEAL50qzPDAnuDVOks2k=;
        b=lzAgTVcYw0/kYHhA8bfSI1fg+6a8NNraagklwbCrZtf/Uh76TaHbx0BSAJijI4TvkQ
         iBChb+d4D5mBtnLWWSdl5XwvdNmwQeJF9zQaNuJTu6LYgHhoxOAbSytiB7yQKjALAmLe
         51Rc7rssXJ5YtyiyD0DWrJUXvmdbIPUzoTrsGcuHyNX1+QW26a8YUPqy8RyOpchiVheg
         C3P0g9NRFCghlS1FfxMppwSnCaaR55sJUxRN+ewWQ7b3i5Zo9bm12ADx/Vy4EUrhvW5A
         9R8JukhCdwqmUDTVUUI69FY49Iz90BVISRuKgpXWCTBQ8rHSVGXXxbFuk9E7rOKR/VNE
         8n4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vY9pa33hAaQweAU2f1GgzuYkEAL50qzPDAnuDVOks2k=;
        b=ki6wSXywQQ2GP+2kDN2Tnp9pimK/ShAXKvp07CLyQVj1UYxPSDJ41WEa9PHpr7czIz
         gH3zVOFKFD40WvsvGZ7IXrKyc5PkqcPUUOmzlMK9DBCBW1vLksfncW6i0LT9PPFl2kIp
         oEGX14W9NmZ6m4/uyMpLWTr/pZtlkVZ8badMxZJFI4MSIiC50qUMNsBDbiiGrBe87vIh
         hjRnSMCeUuswehOO7tJb0ms53mcvPG0J3hiayzgC/7W/9olHdi+sEVJSGy8bcLzPRPxS
         LzGqi1zSJ18cB4ZQGKIXzwe/L/JrwW+z4eEFfNBHPaZrforMyUcQ4DIws7NgUhiE3EMD
         pb5Q==
X-Gm-Message-State: AOAM531gU2lLS8VEyx/73LQFyxRaJtKgiqnfVEGXwMQgpnJ+mcANHPKR
        6yhenG5n9ct+TN0/aQeT/t0=
X-Google-Smtp-Source: ABdhPJxNys0eQFuCgpM13ZoxtfVVriem1NNgKwxBtOGQfBtnK/SajBdprNA6wB3P5KqDjUiei5Kqzw==
X-Received: by 2002:a5d:5745:: with SMTP id q5mr2110842wrw.250.1619334893804;
        Sun, 25 Apr 2021 00:14:53 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.37])
        by smtp.gmail.com with ESMTPSA id x189sm15885626wmg.17.2021.04.25.00.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 00:14:53 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 5/5] overlay: Test invalidate of readdir cache
Date:   Sun, 25 Apr 2021 10:14:45 +0300
Message-Id: <20210425071445.29547-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210425071445.29547-1-amir73il@gmail.com>
References: <20210425071445.29547-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This is a regression test for kernel commit 65cd913ec9d9
("ovl: invalidate readdir cache on changes to dir with origin")

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/077     | 117 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/077.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 120 insertions(+)
 create mode 100755 tests/overlay/077
 create mode 100644 tests/overlay/077.out

diff --git a/tests/overlay/077 b/tests/overlay/077
new file mode 100755
index 00000000..58c0f3b5
--- /dev/null
+++ b/tests/overlay/077
@@ -0,0 +1,117 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 077
+#
+# Test invalidate of readdir cache
+#
+# This is a regression test for kernel commit 65cd913ec9d9
+# ("ovl: invalidate readdir cache on changes to dir with origin")
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
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_require_scratch_nocheck
+
+# Use small getdents bufsize to fit less than 10 entries
+# stuct linux_dirent64 is 20 bytes not including d_name
+bufsize=200
+
+# Create enough files to be returned in multiple gendents() calls.
+# At least one of the files that we delete will not be listed in the
+# first call, so we may encounter stale entries in following calls.
+create_files() {
+	for n in {1..100}; do
+		touch ${1}/${2}${n}
+	done
+}
+
+# remove all files from previous runs
+_scratch_mkfs
+
+# Create test area with a merge dir, a "former" merge dir,
+# a pure upper dir and impure upper dir. For each case, overlayfs
+# readdir cache is used a bit differently.
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+
+mkdir -p $lowerdir/merge $lowerdir/former $upperdir/pure $upperdir/impure
+# Lower files in merge dir are listed first
+create_files $lowerdir/merge m
+# Files to be moved into impure upper dir
+create_files $lowerdir o
+# File to be copied up to make former merge dir impure
+touch $lowerdir/former/f100
+
+_scratch_mount
+
+create_files $SCRATCH_MNT/pure p
+create_files $SCRATCH_MNT/former f
+# Copy up file so readdir will need to lookup its origin d_ino
+touch $SCRATCH_MNT/merge/m100
+# Move copied up files so readdir will need to lookup origin d_ino
+mv $SCRATCH_MNT/o* $SCRATCH_MNT/impure/
+
+# Remove the lower directory and mount overlay again to create
+# a "former merge dir"
+$UMOUNT_PROG $SCRATCH_MNT
+rm -rf $lowerdir/former
+_scratch_mount
+
+# Check readdir cache invalidate on pure upper dir
+echo -e "\nCreate file in pure upper dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/pure $bufsize "+p0" 2>&1 >> $seqres.full || \
+	echo "Missing created file in pure upper dir (see $seqres.full for details)"
+echo -e "\nRemove file in pure upper dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/pure $bufsize "-p100" 2>&1 >> $seqres.full || \
+	echo "Found unlinked file in pure upper dir (see $seqres.full for details)"
+
+# Check readdir cache invalidate on impure upper dir
+echo -e "\nCreate file in impure upper dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/impure $bufsize "+o0" 2>&1 >> $seqres.full || \
+	echo "Missing created file in impure upper dir (see $seqres.full for details)"
+echo -e "\nRemove file in impure upper dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/impure $bufsize  "-o100" 2>&1 >> $seqres.full || \
+	echo "Found unlinked file in impure upper dir (see $seqres.full for details)"
+
+# Check readdir cache invalidate on merge dir
+echo -e "\nCreate file in merge dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/merge $bufsize "+m0" 2>&1 >> $seqres.full || \
+	echo "Missing created file in merge dir (see $seqres.full for details)"
+echo -e "\nRemove file in merge dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/merge $bufsize "-m100" 2>&1 >> $seqres.full || \
+	echo "Found unlinked file in merge dir (see $seqres.full for details)"
+
+# Check readdir cache invalidate on former merge dir
+echo -e "\nCreate file in former merge dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/former $bufsize "+f0" 2>&1 >> $seqres.full || \
+	echo "Missing created file in former merge dir (see $seqres.full for details)"
+echo -e "\nRemove file in former merge dir:" >> $seqres.full
+$here/src/t_dir_offset2 $SCRATCH_MNT/former $bufsize "-f100" 2>&1 >> $seqres.full || \
+	echo "Found unlinked file in former merge dir (see $seqres.full for details)"
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/077.out b/tests/overlay/077.out
new file mode 100644
index 00000000..11538276
--- /dev/null
+++ b/tests/overlay/077.out
@@ -0,0 +1,2 @@
+QA output created by 077
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index ddc355e5..bd014f20 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -79,6 +79,7 @@
 074 auto quick exportfs dangerous
 075 auto quick perms
 076 auto quick perms dangerous
+077 auto quick dir
 100 auto quick union samefs
 101 auto quick union nonsamefs
 102 auto quick union nonsamefs xino
-- 
2.31.1

