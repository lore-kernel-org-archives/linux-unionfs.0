Return-Path: <SRS0=VDYA=5Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30242C2BB86
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 11:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0258620B1F
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 11:22:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTuuFuDy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDILWc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 07:22:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53809 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDILWb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 07:22:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id d77so3522200wmd.3;
        Thu, 09 Apr 2020 04:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=v6LixSSBcxhrlu4cXoEjUaKeTbMukJaZS/lNy0y20bk=;
        b=fTuuFuDysArGXloKeMc8coE7+83B1SZTLNHE5XzLPWWQffRVwcpTJikhw+rwms/r5Y
         OOswoVzrUiV/lGp1h+zi285xIL+tM1s4+En7ue07R3p5QB7hxnS3HMaQn94xt2PLCk3B
         ESDoGh5ckl4HvOGIIsFBQuYHD8++V2NA0n/3XXMlqQj1GFVN1FDqLgFysfh1ZsFvOK/Z
         EWudl1SYZKupN2Gf2vqsQTAkk5s583YN4/mapPeivLnX9Mk1FtNXjfG5FoZvOn0GMoHg
         quAHwhleb8qb05xIz0Z5+nLC5+H+Q4LQ0tx4tcfRF5+XizvvxkUQlSoerxS0NPd8xG0f
         MpcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v6LixSSBcxhrlu4cXoEjUaKeTbMukJaZS/lNy0y20bk=;
        b=bIkGStFA2Qwz38haVK+AkR0WghpeeMDSy8eDPsrSqkm/SD340pe505oOj09t981EqG
         as/aEwXggPT/iudreJqTXONjlyUm5vzg6qn57xceNkjhBlqOJbSgY8RbB4WZt0I1y8hf
         10+8j/pg96JzLY1UrhIvjeG0BhDMSPQQNba2LGEdcsThpgAXxh8uk7DPqKg5290hj+5X
         9J2oUAVYq6Q3d5OF/WksCuAjpCBTUZllcuXs8gZ2LTLzvX1fu9Hdk/FLDmeJ7c0pYwlb
         kCLhFG2l4Ny/i+TkLR7D+gFLbctdIeMAlYCfbpWBvRHu/niDtR2t6RDsvRUBMaG1SUtQ
         d+og==
X-Gm-Message-State: AGi0Pub3E9GGKWsBCDcw0jSYBHVmC1MQtATbs6YGpABwtERngZeR80OK
        nnvOk2EbxCFzKtcRgKM3Usk=
X-Google-Smtp-Source: APiQypLUAN2Vk6DwQZu6thDefu/xiNJ9pJNHkDw25odDNeRYh5sbQVcC9PDMgPT7YVwYbNjiYD0jEQ==
X-Received: by 2002:a1c:ac8a:: with SMTP id v132mr9179570wme.62.1586431349157;
        Thu, 09 Apr 2020 04:22:29 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id y15sm15890193wro.68.2020.04.09.04.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 04:22:28 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] overlay: another test for dropping nlink below zero
Date:   Thu,  9 Apr 2020 14:22:23 +0300
Message-Id: <20200409112223.14496-1-amir73il@gmail.com>
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
---

Eryu,

The kernel fix commit just got merged.

Thanks,
Amir.

 tests/overlay/072     | 85 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/072.out |  2 +
 tests/overlay/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/overlay/072
 create mode 100644 tests/overlay/072.out

diff --git a/tests/overlay/072 b/tests/overlay/072
new file mode 100755
index 00000000..e9084e5c
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
+# Create lower hardlink
+mkdir -p $upperdir
+touch $upperdir/0
+ln $upperdir/0 $upperdir/1
+
+_scratch_mount
+
+# Copy up lower hardlink - overlay inode nlink 2 is copied from lower
+touch $SCRATCH_MNT/0
+
+# Add lower hardlinks while overlay is mounted - overlay inode nlink
+# is not being updated
+ln $upperdir/0 $upperdir/2
+ln $upperdir/0 $upperdir/3
+
+# Unlink the 2 un-accounted lower hardlinks - overlay inode nlinks
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
index 00000000..590bbc6c
--- /dev/null
+++ b/tests/overlay/072.out
@@ -0,0 +1,2 @@
+QA output created by 072
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

