Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2518AE7D0A0
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Sep 2023 17:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjIURYB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjIURXm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Sep 2023 13:23:42 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E103B444DC;
        Thu, 21 Sep 2023 10:13:36 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c00c0f11b2so19101951fa.1;
        Thu, 21 Sep 2023 10:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695316415; x=1695921215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GKT1xX/9LF4huDE0b1Wt9eblC8UcJ/pJ2jSIojgaJLo=;
        b=fIKdivjCx8oID7T526jApoeRvOdkj6FS9oMNu6GgsW2BGZ6Sk+q7oslzLUObfYzzD4
         x9/dBpsl6fuV+3Jcc+gTlKsxoUw6ghU1RfZWPlTj5yLXXTGxIS3EeEQ1mwUvnJkFivVP
         hayaFXg+K2dzEWc2wg12M9hPxeuTPIMSed5nrFPNwaBj0xoqz/P+jKkCQy+F2ccRGIuv
         khghqiBgSZcYHfm7HB8eRfVc0kjkfI+yU9yrRA+ptr+enzK+pXyJBF7xx6qIcT6WJ7m1
         QZHjrRM+Pj0P+bxrOx7yj7Y8xufi8KxBdJxa+BcB25zXxAsAdqFCJeMGqksd762s6JxP
         GMDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695316415; x=1695921215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GKT1xX/9LF4huDE0b1Wt9eblC8UcJ/pJ2jSIojgaJLo=;
        b=q5SQW5UIBtUhcz9QuvdzsG5dWIEtloegmjbUo+uEtnj6llLc4xgWJIOtcdmUI0/grT
         glJ1MtAvPAbU20oASdz34NmnZIwHHZYngUPZW4ouS1MBc1B//OFCd31ACX9tQaeWACUU
         vrMXMdxIe2ofklaCOkLJTuyxKEfC1V448adXYaos/l76/7qnKYrF9Dj9ryIPGS+A6Vbd
         1+KBpziBTsrWvUUldpdUkz11lz5arwkwyMrn0xv3LofVnvU/Sc5ShD0grU5p5CpzJEib
         0Xygg/eN2QFVnT01KGoJXcVfGSRQgVJVuDfubFFEmkGKIp3QkC81qEJX2s162+DngRMU
         kz6Q==
X-Gm-Message-State: AOJu0YxhfvkVpN1CH7buaPQpZo0MD8FgQI2RgQUR0zp9ofJCCSFcEF7F
        SfztHjI1gte/yEsNZMZxMPFJf9pE33Q=
X-Google-Smtp-Source: AGHT+IFhYxvMbp7ER2Xfi0Rd4cqRcTLN3tXvf+Bb5iMo0jweZDdHh1BEmgTvohZ1YLltIbfB+kQjUA==
X-Received: by 2002:a1c:4b0e:0:b0:404:737a:17d with SMTP id y14-20020a1c4b0e000000b00404737a017dmr5479774wma.9.1695306669212;
        Thu, 21 Sep 2023 07:31:09 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id y2-20020a7bcd82000000b00403bbe69629sm2099334wmj.31.2023.09.21.07.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 07:31:08 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 2/2] overlay: add test for rename of lower symlink with NOATIME attr
Date:   Thu, 21 Sep 2023 17:31:02 +0300
Message-Id: <20230921143102.127526-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230921143102.127526-1-amir73il@gmail.com>
References: <20230921143102.127526-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Test for a regression in copy up of symlink that has the S_NOATIME
inode flag.

This is a regression from v5.15 reported by Ruiwen Zhao:
https://lore.kernel.org/linux-unionfs/CAKd=y5Hpg7J2gxrFT02F94o=FM9QvGp=kcH1Grctx8HzFYvpiA@mail.gmail.com/

In the bug report, the symlink has the S_NOATIME inode flag because it is
on an NFS/FUSE filesystem that sets S_NOATIME for all inodes.

The reproducer uses another technique to create a symlink with
S_NOATIME inode flag by using chattr +A inheritance on filesystems
that inherit chattr flags to symlinks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/082     | 66 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/082.out |  2 ++
 2 files changed, 68 insertions(+)
 create mode 100755 tests/overlay/082
 create mode 100644 tests/overlay/082.out

diff --git a/tests/overlay/082 b/tests/overlay/082
new file mode 100755
index 00000000..97ef445e
--- /dev/null
+++ b/tests/overlay/082
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 082
+#
+# Test for a regression in copy up of symlink that has the noatime inode
+# attribute.
+#
+# kernel commit 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
+# from v5.15 introduced the regression.
+#
+. ./common/preamble
+_begin_fstest auto quick copyup symlink atime
+
+# real QA test starts here
+_supported_fs overlay
+_fixed_by_kernel_commit ab048302026d \
+	"ovl: fix failed copyup of fileattr on a symlink"
+
+_require_scratch
+_require_chattr_inherit A
+
+# remove all files from previous runs
+_scratch_mkfs
+
+# prepare lower test dir with NOATIME flag
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $lowerdir/testdir
+$CHATTR_PROG +A $lowerdir/testdir >> $seqres.full 2>&1 ||
+	echo "failed to set No_Atime flag on $lowerdir/testdir"
+
+# The NOATIME is inherited to children symlink in ext4/fs2fs
+# (and on tmpfs on recent kernels).
+# The overlayfs test will not fail unless base fs is
+# one of those filesystems.
+#
+# The problem with this inheritence is that the NOATIME flag is inherited
+# to a symlink and the flag does take effect, but there is no way to query
+# the flag (lsattr) or change it (chattr) on a symlink, so overlayfs will
+# fail when trying to copy up NOATIME flag from lower to upper symlink.
+#
+touch $lowerdir/testdir/foo
+ln -sf foo $lowerdir/testdir/lnk
+$LSATTR_PROG -l $lowerdir/testdir/foo >> $seqres.full
+
+before=$(stat -c %x $lowerdir/testdir/lnk)
+echo "symlink atime before readlink: $before" >> $seqres.full 2>&1
+cat $lowerdir/testdir/lnk
+after=$(stat -c %x $lowerdir/testdir/lnk)
+echo "symlink atime after readlink: $after" >> $seqres.full 2>&1
+
+[ "$before" == "$after" ] || \
+	_notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag on symlink"
+
+# mounting overlay
+_scratch_mount
+
+# moving symlink will try to copy up lower symlink flags
+# and fails with error ENXIO, if the bug is reproduced
+mv $SCRATCH_MNT/testdir/lnk $SCRATCH_MNT/
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/082.out b/tests/overlay/082.out
new file mode 100644
index 00000000..2977f141
--- /dev/null
+++ b/tests/overlay/082.out
@@ -0,0 +1,2 @@
+QA output created by 082
+Silence is golden
-- 
2.34.1

