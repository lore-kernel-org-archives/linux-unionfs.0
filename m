Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C86C43333
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D0AE64E3B
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhBJTEx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234224AbhBJTE0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Feb 2021 14:04:26 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEEAC061786;
        Wed, 10 Feb 2021 11:03:44 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id p20so6088117ejb.6;
        Wed, 10 Feb 2021 11:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7vQQseBKx2a8Kjbt1q8bbcNuAJE164apTHT1g73Artw=;
        b=R/uNuGafcduNgOb9+Oh4kSgFbpgfK9fAft8BBDzAOcHsXlmU44MYgowl1Drtp1EsKs
         TmSRKM0nrEv2yot1+2FrsZVV3WIyG6VwG5vCnJ0nubk8Cgx5r60ZBv3WuS6EVUtlDsI1
         YD58TC90WfMAOwyh2VBssUormvXSo80IMZA/qVREkjGMhwh4ofBpTQwc816NSfagiOD8
         eGbrw7zlKxtbNI/G36dVu5d4qNguH4P1B7Qacr2nLTeVyKWQD9rqYa/ONnDZ0LVoNEI/
         GmpcXSj91AkeFvOr+s4HCy8ChLSc6La2xPfL6JAdWiHyo5YfZ4FZcDQM+5V/qofQEH9y
         QucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7vQQseBKx2a8Kjbt1q8bbcNuAJE164apTHT1g73Artw=;
        b=ZQQQKlDiSTsyLA4mHWVDVaySSkAaq8PK08w+iTs2EWD80NEBo1wQFKF14fmD4law4v
         B0OdFugAXdsb9fhuboWaEHeuRbUqtVP1r1qdROplGpL7nlHKZHaItmcisIKdPbWCEGI8
         W/WfHkE65sXlIK3npj166WdpMxUpiViWB158smB3Zy13fI7yDtNRZHOVI4W8Y6Tcfc98
         940wdrcaJI0EKYW6ESOV4ZdRlMKvKkBun04neRYI0tCFIio8poXOlegjLMnNEtybF9bu
         u0Zv0QsA5pfGi4SS7Ct6PbpEohAxBoGsVhNiO3Jff4ogewk5x2KBk5A239k5ldsGinHX
         VM6w==
X-Gm-Message-State: AOAM531A+0g8EUMMMcwntvZc3Y2C/uw6wj/bDRNDGfEQ4NJkzHv11Lrz
        O79w4QS6+YN2EN6Vajh/HUo=
X-Google-Smtp-Source: ABdhPJzfbgOj7am4rmgfKXPs52pILq5vN5c133TTZK9WcxcM2Fq352aIbdjgjCj6DeinTp3yjG1Fbw==
X-Received: by 2002:a17:907:9626:: with SMTP id gb38mr4369492ejc.301.1612983823087;
        Wed, 10 Feb 2021 11:03:43 -0800 (PST)
Received: from localhost.localdomain ([141.226.162.179])
        by smtp.gmail.com with ESMTPSA id m19sm1743617edq.81.2021.02.10.11.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 11:03:42 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 4/5] overlay: Test lost immutable/append-only flags on copy-up
Date:   Wed, 10 Feb 2021 21:03:33 +0200
Message-Id: <20210210190334.1212210-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210190334.1212210-1-amir73il@gmail.com>
References: <20210210190334.1212210-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Chengguang Xu reported [1] that append-only flag is lost on copy-up.
I had noticed that for directories, immutable flag can also be lost on
copy up (when parent is copied up). That's an old overlayfs bug.

[1] https://lore.kernel.org/linux-unionfs/20201226104618.239739-1-cgxu519@mykernel.net/

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/075     | 92 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/075.out | 11 ++++++
 tests/overlay/group   |  1 +
 3 files changed, 104 insertions(+)
 create mode 100755 tests/overlay/075
 create mode 100644 tests/overlay/075.out

diff --git a/tests/overlay/075 b/tests/overlay/075
new file mode 100755
index 00000000..5a6c3be0
--- /dev/null
+++ b/tests/overlay/075
@@ -0,0 +1,92 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test No. 075
+#
+# Run the t_immutable test program for immutable/append-only files
+# and directories that exist in overlayfs lower layer.
+#
+# This test is similar and was derived from generic/079, but instead
+# of creating new files which are created in upper layer, prepare
+# the test area in lower layer before running the t_immutable test on
+# the overlayfs mount.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+timmutable=$here/src/t_immutable
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	# -r will fail to remove test dirs, because we added subdirs
+	# we just need to remove the flags so use -R
+	$timmutable -R $upperdir/testdir &> /dev/null
+	$timmutable -R $lowerdir/testdir &> /dev/null
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_supported_fs overlay
+
+_require_chattr ia
+_require_test_program "t_immutable"
+_require_scratch
+
+_scratch_mkfs
+
+# Preparing test area files in lower dir and check chattr support of base fs
+mkdir -p $lowerdir
+mkdir -p $upperdir
+$timmutable -C $lowerdir/testdir >$tmp.out 2>&1
+if grep -q -e 'Operation not supported' -e "Inappropriate ioctl" $tmp.out; then
+	_notrun "Setting immutable/append flag not supported"
+fi
+# Remove the immutable/append-only flags and create subdirs
+$timmutable -R $lowerdir/testdir >$tmp.out 2>&1
+for dir in $lowerdir/testdir/*.d; do
+	mkdir $dir/subdir
+done
+# Restore the immutable/append-only flags
+$timmutable -C $lowerdir/testdir >$tmp.out 2>&1
+
+_scratch_mount
+
+# Test immutability of files in overlay
+echo "Before directories copy up"
+$timmutable $SCRATCH_MNT/testdir 2>&1
+
+# Trigger copy-up of immutable/append-only dirs by touching their subdirs
+# inode flags are not copied-up, so immutable/append-only flags are lost
+for dir in $SCRATCH_MNT/testdir/*.d; do
+	touch $dir/subdir
+done
+
+# Trigger copy-up of append-only files by touching them
+# inode flags are not copied-up, so append-only flags are lost
+# touch on the immutable files is expected to fail, so immutable
+# flags will not be lost
+for file in $SCRATCH_MNT/testdir/*.f; do
+	touch $file > /dev/null 2>&1
+done
+
+# immutable/append-only flags still exist on the overlay in-core inode
+# After mount cycle, flags are forever lost
+_scratch_cycle_mount
+
+# Test immutability of files in overlay after directories copy-up
+echo "After directories copy up"
+$timmutable $SCRATCH_MNT/testdir 2>&1
+
+status=$?
+exit
diff --git a/tests/overlay/075.out b/tests/overlay/075.out
new file mode 100644
index 00000000..ab39c6b8
--- /dev/null
+++ b/tests/overlay/075.out
@@ -0,0 +1,11 @@
+QA output created by 075
+Before directories copy up
+testing immutable...PASS.
+testing append-only...PASS.
+testing immutable as non-root...PASS.
+testing append-only as non-root...PASS.
+After directories copy up
+testing immutable...PASS.
+testing append-only...PASS.
+testing immutable as non-root...PASS.
+testing append-only as non-root...PASS.
diff --git a/tests/overlay/group b/tests/overlay/group
index 047ea046..cfc75bb1 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -77,6 +77,7 @@
 072 auto quick copyup hardlink
 073 auto quick whiteout
 074 auto quick exportfs dangerous
+075 auto quick perms
 100 auto quick union samefs
 101 auto quick union nonsamefs
 102 auto quick union nonsamefs xino
-- 
2.25.1

