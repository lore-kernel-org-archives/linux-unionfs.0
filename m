Return-Path: <SRS0=GnLN=63=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30388C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 19:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC080206A5
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 19:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IE+SKavm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390608AbgEMTXw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 13 May 2020 15:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTXw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 May 2020 15:23:52 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4586C061A0C;
        Wed, 13 May 2020 12:23:51 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u16so29824060wmc.5;
        Wed, 13 May 2020 12:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Yef0hcqxJF9dKmAER/NjnbSzka2RXYVT5qt1mSN2THU=;
        b=IE+SKavmm7g9LJzJdHs6XMUBS7c7HUOhLlDoFv2B1MEXqtfelG6YYy/N6uwdUGPkT+
         gjUHQLBIShhultQgX7odomsOkk6A1mQXTSTcyhqYpSf0VPgo/2doYW41IRAUsBr+q3Qh
         Z6IRjcLfz4uuBpR1TCvareogCcuJFPlhVvzlb1LWCyiXykLk5mTj4HbYxI3lRJf7Fgwi
         mqhTGaacahqreiy/oUBZMq9ToE7cguTtbdsKYmVga2ZLEUze03PudLsDvJgPb2iHMtVv
         A73eD5MKJg9Iw7La0PQdDDRfG4T9Tu3Or8MoIOKOshhsPlYV0TRwX9rDyl3Xtu2KFDV4
         kCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Yef0hcqxJF9dKmAER/NjnbSzka2RXYVT5qt1mSN2THU=;
        b=KLn1o33ZEbkmilWi2xTM+SGRhtbikYZNw0RcuPpCC1bM/CO54vtJFDCElvLzalV4uK
         WFqIK888DOqgeXdAPmvY8nbz+O7YAaQ8+9xOv2Ldu3/M+FvXGcL1A1ciH7PDeEVXKCF5
         gJF5KdlwIOqHwHczrljb02i1R5gCs2tT7VpdIJsMeV2W+cSmD994wnn4n3rTzwi+yKBj
         sQaRvgT2RoY9g86CJYONhFXwOb1rsUzc9U9DMP0rcCcPQCuYVnXEg5hYcnp7nMpysw/B
         3LGXWSRsxfjKHfKofZv1IroGgA6wbARA7fJ+UqcnfqaR9zgn0siIw9wlvk9G1ugqAlj5
         +pVw==
X-Gm-Message-State: AGi0PubB7ZqZYiN8Jpikf+MM0EVtajeW1htq6tvbfPWb+8wi4iLQSwb2
        gNI1Cj9S0eYRkbpjtk+fs/s=
X-Google-Smtp-Source: APiQypJww+53mAVt+wsJVqbZXRly7g2QIx8nZGR1ETmHiGVXHFcgUONUeg5wLeC8kZF97yZtApgVig==
X-Received: by 2002:a7b:c850:: with SMTP id c16mr42208312wml.108.1589397830501;
        Wed, 13 May 2020 12:23:50 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id v2sm639784wrn.21.2020.05.13.12.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 12:23:49 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v5] overlay: test for whiteout inode sharing
Date:   Wed, 13 May 2020 22:23:38 +0300
Message-Id: <20200513192338.13584-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

This is a test for whiteout inode sharing feature.

[Amir] added check for whiteout sharing support
       and whiteout of lower dir.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Chengguang,

I decided to take a stab at Eryu's challenge ;-)

Amir.

 tests/overlay/074     | 117 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/074.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 120 insertions(+)
 create mode 100755 tests/overlay/074
 create mode 100644 tests/overlay/074.out

diff --git a/tests/overlay/074 b/tests/overlay/074
new file mode 100755
index 00000000..4088c0e7
--- /dev/null
+++ b/tests/overlay/074
@@ -0,0 +1,117 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
+# All Rights Reserved.
+#
+# FS QA Test 074
+#
+# Test whiteout inode sharing functionality.
+#
+# A "whiteout" is an object that has special meaning in overlayfs.
+# A whiteout on an upper layer will effectively hide a matching file
+# in the lower layer, making it appear as if the file didn't exist.
+#
+# Whiteout inode sharing means multiple whiteout objects will share
+# one inode in upper layer, without this feature every whiteout object
+# will consume one inode in upper layer.
+
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+# Require index dir to test if workdir/work is not in use
+# which implies that whiteout sharing is supported
+_require_scratch_overlay_features index
+
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
+# Make some testing files in lowerdir.
+# Argument:
+# $1: Testing file number
+make_lower_files()
+{
+	mkdir $lowerdir/dir
+	for name in `seq ${1}`; do
+		touch $lowerdir/${name} &>/dev/null
+	done
+}
+
+# Delete all copied-up files in upperdir.
+make_whiteout_files()
+{
+	# whiteout inode sharing implies that workdir/work is not in use
+	# If workdir/work is in use, delete of lower dir will fail and
+	# we won't run the test.
+	rmdir $workdir/work
+	rmdir $SCRATCH_MNT/dir &>/dev/null || \
+		_notrun "overlay does not support whiteout inode sharing"
+	rm $SCRATCH_MNT/* &>/dev/null
+}
+
+# Check link count of whiteout files.
+# Arguments:
+# $1: Testing file number
+# $2: Expected link count
+check_whiteout_files()
+{
+	for name in dir `seq ${1}`; do
+		local real_count=`stat -c %h $upperdir/${name} 2>/dev/null`
+		if [[ ${2} != $real_count ]]; then
+			echo "Expected link count is ${2} but real count is $real_count, file name is ${name}"
+		fi
+	done
+	local tmpfile_count=`ls $workdir/index/\#* 2>/dev/null |wc -l 2>/dev/null`
+	if [[ -n "$tmpfile_count" && $tmpfile_count > 1 ]]; then
+		echo "There are more than one whiteout tmpfile in index dir!"
+		ls -l $workdir/index/\#* 2>/dev/null
+	fi
+}
+
+# Run test case with specific arguments.
+# Arguments:
+# $1: Testing file number
+# $2: Expected link count
+run_test_case()
+{
+	_scratch_mkfs
+	make_lower_files ${1}
+	_scratch_mount -o "index=on"
+	make_whiteout_files
+	check_whiteout_files ${1} ${2}
+	_scratch_unmount
+}
+
+# Test case
+file_count=10
+# +1 for dir +1 for temp whiteout
+link_count=12
+run_test_case $file_count $link_count
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/074.out b/tests/overlay/074.out
new file mode 100644
index 00000000..380f0657
--- /dev/null
+++ b/tests/overlay/074.out
@@ -0,0 +1,2 @@
+QA output created by 074
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 5625a46d..2f21db00 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -76,3 +76,4 @@
 071 auto quick copyup redirect nested nonsamefs
 072 auto quick copyup hardlink
 073 auto quick exportfs dangerous
+074 auto quick whiteout
-- 
2.17.1

