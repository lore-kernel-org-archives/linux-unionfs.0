Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B727C433E6
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2665964E3B
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhBJTFW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbhBJTFQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Feb 2021 14:05:16 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCE2C061788;
        Wed, 10 Feb 2021 11:03:45 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s5so4266490edw.8;
        Wed, 10 Feb 2021 11:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zhs8E2as/K5hxOttBuP4bqtfk2cYGV03BLwkm3GAQwA=;
        b=XtWQoTXW85A7Q5ogJDKkBpsOx+0RR+6rWkKc7PiNktx69vqCc4bZl7MnOkTcahoVae
         XfyCDiIWhQnjFZWeJIs63RKVGdJ59arvucBhU+YBX2Hz5dzteYwoXzK/jTYUvV4BfrAa
         tS/UQnHBYeRw1WIj1Bpy+eU24woALKJPeWM4EuQob1JzZYW19PvsxYP0qCQ/t7iqVLKb
         e8ZG8AF5RRn0WnmkFH2jtVln4G+h6V88nKYeUfZOWfBkLRy+cehlJrSTgE6u4ODh5KnA
         jEIIbxy3lUfWQ/QGI/ZZ8jckJdOV0RfPrQrVvD7azodnBqUBjaQUiFCYiZkdi8N3ns7r
         vvgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zhs8E2as/K5hxOttBuP4bqtfk2cYGV03BLwkm3GAQwA=;
        b=Ew0Hnu46YULWW/Gk8/+D3Ra10aPSY49zdMBbNYq7C8WUxZiwmYSxX58usDERvwnn1A
         GkQpoio19LyAdzh28+vFR3HF4xrK48sUQMixlqb4MKipDxZ59t+y1cbgNLCyAGV8eHQx
         wNi5UWfkLCsQAKFjOd4b3MJAb4rY+riWehpwiEH+kHSL2W9MH1pM9y5/GAojLZRicm5N
         gJwu8kJYgltFZlKd6JNbfalgODE4tmvtHTJ5fpSb0w9TslIbs7YRgHRHIm5QIvEpDRqN
         mFHi2Bxfvz4PspQ0Nr6xnBGmF+BC5wGBxUuRKuGznxlw9w9PEGtGhdBiNl+kK2HYXiTU
         cSHw==
X-Gm-Message-State: AOAM531ccbiZOGOEubbW4rrke7Lyqzv8+iXOQLBColtOSnBuqOKzbSNp
        PhryiG3YPRl8ZlJSUowA+rWoYZRbNbo=
X-Google-Smtp-Source: ABdhPJy2XiNkQrehg5Yd0tTXI4Af2FdHz4yA5d0vA1izNv7B7o6jGwEmu209zyJ4epbtfqA7w/SxSw==
X-Received: by 2002:aa7:c94c:: with SMTP id h12mr4696939edt.40.1612983824634;
        Wed, 10 Feb 2021 11:03:44 -0800 (PST)
Received: from localhost.localdomain ([141.226.162.179])
        by smtp.gmail.com with ESMTPSA id m19sm1743617edq.81.2021.02.10.11.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 11:03:44 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 5/5] overlay: Regression test for deadlock on directory ioctl
Date:   Wed, 10 Feb 2021 21:03:34 +0200
Message-Id: <20210210190334.1212210-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210190334.1212210-1-amir73il@gmail.com>
References: <20210210190334.1212210-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Overlayfs added the ability to set inode flags (e.g. chattr +i) in
kernel 5.10 by commit 61536bed2149 ("ovl: support [S|G]ETFLAGS and
FS[S|G]ETXATTR ioctls for directories").
Icenowy Zheng reported [1] a regression in that commit that causes
a deadlock when setting inode flags on lower dir.

The regression was fixed by commit b854cc659dcb ("ovl: avoid deadlock
on directory ioctl") and applied to kernel 5.10.15.

[1] https://lore.kernel.org/linux-unionfs/20210101201230.768653-1-icenowy@aosc.io/

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/076     | 66 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/076.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 69 insertions(+)
 create mode 100644 tests/overlay/076
 create mode 100644 tests/overlay/076.out

diff --git a/tests/overlay/076 b/tests/overlay/076
new file mode 100644
index 00000000..07827c0b
--- /dev/null
+++ b/tests/overlay/076
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 076
+#
+# Support for chattr on overlayfs directories was added in kernel v5.10
+# by commit 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR
+# ioctls for directories").  That commit introduced a deadlock.
+#
+# This is a regression test for the fix commit b854cc659dcb ("ovl: avoid
+# deadlock on directory ioctl")
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+        cd /
+        $CHATTR_PROG -i $lowerdir/foo > /dev/null 2>&1
+        $CHATTR_PROG -i $upperdir/foo > /dev/null 2>&1
+        rm -f $tmp.*
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
+_require_scratch
+_require_chattr i
+
+# remove all files from previous runs
+_scratch_mkfs
+
+# prepare lower test file
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+mkdir -p $lowerdir
+mkdir $lowerdir/foo
+
+# mounting overlay
+_scratch_mount
+
+# Try to add the immutable attributes, it will invoke ioctl() on the directory
+# The ioctl will fail on kernel < 5.10, succeed on kernel >= 5.10.15 and hang
+# on kernel v5.10..v5.10.14.  Anything but hang is considered a test success.
+$CHATTR_PROG +i $SCRATCH_MNT/foo > /dev/null 2>&1
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/076.out b/tests/overlay/076.out
new file mode 100644
index 00000000..248e095d
--- /dev/null
+++ b/tests/overlay/076.out
@@ -0,0 +1,2 @@
+QA output created by 076
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index cfc75bb1..ddc355e5 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -78,6 +78,7 @@
 073 auto quick whiteout
 074 auto quick exportfs dangerous
 075 auto quick perms
+076 auto quick perms dangerous
 100 auto quick union samefs
 101 auto quick union nonsamefs
 102 auto quick union nonsamefs xino
-- 
2.25.1

