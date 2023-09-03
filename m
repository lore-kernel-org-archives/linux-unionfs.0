Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69FFC83F2D
	for <linux-unionfs@archiver.kernel.org>; Sun,  3 Sep 2023 07:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjICHyV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 03:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjICHyV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 3 Sep 2023 03:54:21 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656C212E;
        Sun,  3 Sep 2023 00:54:17 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-401c90ed2ecso5114015e9.0;
        Sun, 03 Sep 2023 00:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693727656; x=1694332456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=myK1oq3x664TINacbafir9+NyUQlPgaIT0SL5O6FbM8=;
        b=k6lgluYkymHbb1qJ+1dWlMLfwPWN/6arQrx+vOlxc1kmZg+aygb0xgjFB+302dcYW4
         Vkj1x1f+sfb6NO39EW03NVSscHjnG+06f6/vM14ZnIGfrNJ4OTx3I+2see+cXQQJNRWj
         pBP/8xXhof5QLe3V8LA0V96GHH4y/zDP8xmvtFWWZQbP7pIKu9PtF1sfvISRp2KLlAYf
         SEELulgE2hzs+ujT6vROOEDHRLXU4EMaWk1rd/J+ASjtnYbqJOEazMqPzU8NAafRGHoa
         lesk/hDLfjfBgoVClIE+AfbeZYEMzkuUYqcfhoY6FWojKyXRnfHYxLBu1KlmB701eDgR
         Bxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693727656; x=1694332456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=myK1oq3x664TINacbafir9+NyUQlPgaIT0SL5O6FbM8=;
        b=IzeIcfi+uVbEXaH+bCewmIvJOgm8KB0NpD4HMG9H8U+drVRKXbhwxNWJoAIOjFM3AB
         sTpmLv5r+yitKJopE5tVQ+lczSNTHIalIWGZ6IeTSIMJI1QID0PID7HYbv/62Uii1ioe
         BAYH85Zp7iQy74OP1LT5Gcd27i5+akmAd76Mw3XtlcmczuwogQXvyrtdguHGGMd6LX1Z
         pmESObd7SqQhDyXxj21xuPvwXWuyWKg3Uy+gWquHvyZJrFNFhYVqBhExTKr3y/pwDTCG
         70o0/0i042RpCQP7I83X4EzNgZeWcjnl21GUeRwEdA+HjVMGAQ13HIWeiVPSSs9XpdZ8
         PbXA==
X-Gm-Message-State: AOJu0YxsLnIDvUrxSbbkCjn6dsJxfvEsdQDjI/na4v6e1dF6e32eTz2e
        DN698w9zB9BlW547MeVYr3Ujd1tizks=
X-Google-Smtp-Source: AGHT+IEppZZBUdzPKcjVr24WYr7S85jEbxy5QxrCXDGa2M7PnQRKRb7T4FF1blHQwEkFjj7WKTZdDw==
X-Received: by 2002:a05:600c:11c7:b0:3fe:d7c8:e0d with SMTP id b7-20020a05600c11c700b003fed7c80e0dmr4734769wmi.34.1693727655535;
        Sun, 03 Sep 2023 00:54:15 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c021100b003fefca26c72sm10328040wmi.23.2023.09.03.00.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 00:54:15 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Larsson <alexl@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] overlay: add test for persistent unique fsid
Date:   Sun,  3 Sep 2023 10:54:11 +0300
Message-Id: <20230903075411.2596590-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Test overlayfs fsid behavior with new mount options uuid=null/on
that were introduced in kernel v6.6:

- Test inherited upper fs fsid with mount option uuid=off/null
- Test uuid=null behavior for existing overlayfs by default
- Test persistent unique fsid with mount option uuid=on
- Test uuid=on behavior for new overlayfs by default

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

This is the functional test for an overlayfs feature merged to v6.6.
The test does _notrun on older kernels:

overlay/081 14s ...  [07:40:13][   57.780790] overlay: Bad value for 'uuid'
 [07:40:14] [not run]
	overlay/081 -- Overlayfs does not support unique fsid feature

The test for another big overlayfs feature that was merged to v6.6,
overlay/080 (validate lower using fs-verity) is already merged to fstests.

Note that overlay/080 requires running overlayfs over a base filesystem
with fs-verity support enabled, for example, on ext4 formatted with
mkfs.ext4 -O verity [1].

Thanks,
Amir.

[1] https://lore.kernel.org/fstests/20230625135033.3205742-2-amir73il@gmail.com/

 tests/overlay/081     | 128 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/081.out |   2 +
 2 files changed, 130 insertions(+)
 create mode 100755 tests/overlay/081
 create mode 100644 tests/overlay/081.out

diff --git a/tests/overlay/081 b/tests/overlay/081
new file mode 100755
index 00000000..05156a3c
--- /dev/null
+++ b/tests/overlay/081
@@ -0,0 +1,128 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+#
+# FSQA Test No. 081
+#
+# Test persistent (and optionally unique) overlayfs fsid
+# with mount options uuid=null/on introduced in kernel v6.6
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs overlay
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+# Create overlay layer with pre-packaged merge dir
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $upperdir/test_dir
+mkdir -p $lowerdir/test_dir
+test_dir=$SCRATCH_MNT/test_dir/
+
+# Record base fs fsid
+upper_fsid=$(stat -f -c '%i' $upperdir)
+lower_fsid=$(stat -f -c '%i' $lowerdir)
+
+# Sanity tests
+[[ -n "$upper_fsid" ]] || \
+	echo "invalid upper fs fsid"
+[[ "$lower_fsid" == "$upper_fsid" ]] || \
+	echo "lower fs and upper fs fsid differ"
+
+# Test legacy behavior - ovl fsid inherited from upper fs
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o uuid=null 2>/dev/null || \
+	_notrun "Overlayfs does not support unique fsid feature"
+
+# Lookup of test_dir marks upper root as "impure", so following (uuid=auto) mounts
+# will NOT behave as first time mount of a new overlayfs
+ovl_fsid=$(stat -f -c '%i' $test_dir)
+[[ "$ovl_fsid" == "$upper_fsid" ]] || \
+	echo "Overlayfs (uuid=null) and upper fs fsid differ"
+
+# Keep base fs mounted in case it has a volatile fsid (e.g. tmpfs)
+$UMOUNT_PROG $SCRATCH_MNT
+
+# Test legacy behavior is preserved by default for existing "impure" overlayfs
+_scratch_mount
+
+ovl_fsid=$(stat -f -c '%i' $test_dir)
+[[ "$ovl_fsid" == "$upper_fsid" ]] || \
+	echo "Overlayfs (uuid=auto) and upper fs fsid differ"
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+# Test unique fsid on explicit opt-in for existing "impure" overlayfs
+_scratch_mount -o uuid=on
+
+ovl_fsid=$(stat -f -c '%i' $test_dir)
+ovl_unique_fsid=$ovl_fsid
+[[ "$ovl_fsid" != "$upper_fsid" ]] || \
+	echo "Overlayfs (uuid=on) and upper fs fsid are the same"
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+# Test unique fsid is persistent by default after it was created
+_scratch_mount
+
+ovl_fsid=$(stat -f -c '%i' $test_dir)
+[[ "$ovl_fsid" == "$ovl_unique_fsid" ]] || \
+	echo "Overlayfs (uuid=auto) unique fsid is not persistent"
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+# Test ignore existing persistent fsid on explicit opt-out
+_scratch_mount -o uuid=off
+
+ovl_fsid=$(stat -f -c '%i' $test_dir)
+[[ "$ovl_fsid" == "$upper_fsid" ]] || \
+	echo "Overlayfs (uuid=off) and upper fs fsid differ"
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+# Test fallback to uuid=null with non-upper ovelray
+_overlay_scratch_mount_dirs "$upperdir:$lowerdir" "-" "-" -o ro,uuid=on
+
+ovl_fsid=$(stat -f -c '%i' $test_dir)
+[[ "$ovl_fsid" == "$lower_fsid" ]] || \
+	echo "Overlayfs (uuid=null) and lower fs fsid differ"
+
+# Re-create fresh overlay layers, so following (uuid=auto) mounts
+# will behave as first time mount of a new overlayfs
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+mkdir -p $upperdir/test_dir
+mkdir -p $lowerdir/test_dir
+
+# Record new base fs fsid
+upper_fsid=$(stat -f -c '%i' $upperdir)
+
+# Test unique fsid by default for first time mount of new overlayfs
+_scratch_mount
+
+ovl_fsid=$(stat -f -c '%i' $test_dir)
+ovl_unique_fsid=$ovl_fsid
+[[ "$ovl_fsid" != "$upper_fsid" ]] || \
+	echo "Overlayfs (uuid=auto) and upper fs fsid are the same"
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+# Test unique fsid is persistent by default after it was created
+_scratch_mount -o uuid=on
+
+ovl_fsid=$(stat -f -c '%i' $test_dir)
+[[ "$ovl_fsid" == "$ovl_unique_fsid" ]] || \
+	echo "Overlayfs (uuid=on) unique fsid is not persistent"
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/081.out b/tests/overlay/081.out
new file mode 100644
index 00000000..663a8864
--- /dev/null
+++ b/tests/overlay/081.out
@@ -0,0 +1,2 @@
+QA output created by 081
+Silence is golden
-- 
2.34.1

