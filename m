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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991E2C433E0
	for <linux-unionfs@archiver.kernel.org>; Sat, 16 Jan 2021 17:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58BC022A83
	for <linux-unionfs@archiver.kernel.org>; Sat, 16 Jan 2021 17:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbhAPRGv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:06:51 -0500
Received: from mail-ed1-f48.google.com ([209.85.208.48]:35688 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbhAPRGt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 16 Jan 2021 12:06:49 -0500
Received: by mail-ed1-f48.google.com with SMTP id u19so13045906edx.2;
        Sat, 16 Jan 2021 09:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QHFxbDhsnQzHQlBD/5Lv++BjjSF2/FwwLkaS9AAgVE0=;
        b=qMhGwpj6g5fSCmYrC3IQmlYsOqbFDcIg1nzlFSWEEguSP1+dh+5HQ+xuscifj0nHuY
         7floZUe48heX3txjcwdcVyJWmP01tMwB0DDA7qnG5NAH7ZqkSxeIK2Mm1ZRB7gLqHqyE
         BpmTbxtM68y2+B6f9UK3w/lq2057x23pNr+DvmFqlRcAT9zn8qjMFCRyugfpoSYIqETc
         AUh0IQdxbmUH6wD9JiT9VHFbNPfSmsaDrrdHIqKbfWqj3BBQVKFppQGj0fXtO18zssyM
         Z/1RpiXetx0MC1fesNgFuPdyLkuGBfPekywKZ0HqVn8lBJq4VD1FvmMQzWT6Jix43noO
         /Erw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QHFxbDhsnQzHQlBD/5Lv++BjjSF2/FwwLkaS9AAgVE0=;
        b=pAhZMkp5ZhRN2kQvBcniKZAr8wNQbeFTHtP8FWa0kMUu+mfvzT9Zhg2I4jZH7wEDuv
         r9PMOiF6T3Z2DnuvexERK1vbyr65Pfmo1z8PAK+cvx4OPudbC65hk+H/yRpVf0kANSLL
         rqQ/F+ChB/WoU3M1oZKTGvSSSzYywGtAev0Nn7bfPWQrzCBJpsdN5mPMlEH9XmWjw+PR
         6pyylAvUJ5pJG6XzaK5wzMU//daLziicC1pUBPA05VYZbCFwd2d2k1CKTk71lAM2pnNs
         MW5xRYOVyKZpKVayEJde9ryrJQmns7HVOexG9qpyfGPgKW1zN+SdzGkaRo8Bbeokhy84
         IuPg==
X-Gm-Message-State: AOAM532AMIQxo963pY0950Byn1x7WcZ/9Bt5y2F3aTgKuqzIhbUFQ6mx
        7GzKkh4cy85w9n3PnvD/sHU5V1v8gAg=
X-Google-Smtp-Source: ABdhPJzUJ/5G/cNwUqRoAWysskvGblpL/ipitKchnbDmhvyj9vShih8KP6+2wrKjBr6Oaj5jxQtWCg==
X-Received: by 2002:a50:fb97:: with SMTP id e23mr14116891edq.208.1610816189674;
        Sat, 16 Jan 2021 08:56:29 -0800 (PST)
Received: from localhost.localdomain ([31.210.181.203])
        by smtp.gmail.com with ESMTPSA id zn8sm7061063ejb.39.2021.01.16.08.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 08:56:29 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 4/4] overlay: Test lost immutable/append-only flags on copy-up
Date:   Sat, 16 Jan 2021 18:56:19 +0200
Message-Id: <20210116165619.494265-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116165619.494265-1-amir73il@gmail.com>
References: <20210116165619.494265-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Chengguang Xu reported [1] that append-only flag is lost on copy-up.
I had noticed that for directories, immutable flag can also be lost on
copy up (when parent is copied up). That's an old overlayfs bug.

Overlayfs added the ability to set inode flags (e.g. chattr +i) in
kernel 5.10 by commit 61536bed2149 ("ovl: support [S|G]ETFLAGS and
FS[S|G]ETXATTR ioctls for directories").
Icenowy Zheng reported [2] a regression in that commit that causes
a deadlock when setting inode flags on lower dir.

There is a commented line in the test that triggers this deadlock,
but it has been left commented out until a fix is merged upstream.

[1] https://lore.kernel.org/linux-unionfs/20201226104618.239739-1-cgxu519@mykernel.net/
[2] https://lore.kernel.org/linux-unionfs/20210101201230.768653-1-icenowy@aosc.io/

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/075     | 97 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/075.out | 11 +++++
 tests/overlay/group   |  1 +
 3 files changed, 109 insertions(+)
 create mode 100755 tests/overlay/075
 create mode 100644 tests/overlay/075.out

diff --git a/tests/overlay/075 b/tests/overlay/075
new file mode 100755
index 00000000..bcdc8d4e
--- /dev/null
+++ b/tests/overlay/075
@@ -0,0 +1,97 @@
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
+_require_chattr iaA
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
+	# chattr on dir fails (not supported) on kernel < 5.10.
+	# chattr on lower dir will deadlock on kernel 5.10 with commit 61536bed2149
+	# ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories"),
+	# so this line is commented out until a fix is merged
+	# $CHATTR_PROG +A $dir/subdir > /dev/null 2>&1
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

