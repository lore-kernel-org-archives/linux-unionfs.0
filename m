Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7A5C433F5
	for <linux-unionfs@archiver.kernel.org>; Sat, 26 Feb 2022 15:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiBZP0Z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 26 Feb 2022 10:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiBZP0X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 26 Feb 2022 10:26:23 -0500
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73823265854
        for <linux-unionfs@vger.kernel.org>; Sat, 26 Feb 2022 07:25:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645889135; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=Qz0FAPXDQtEh4QfEw1aVbL83Bje8Exp2ISrWYH6qDqQKtK3OeP7HgQBOO8gnNIOOatV3qmalen1MUQ/96tHqUQaG+TX0aEjextr6wGHsuoGtrhioWVsgDJWtU5UVWFCQLjgFGNgA1LFZxDfvfpPeAWGjldxshC3HPaB6+1YK9Pk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1645889135; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=YSqK2GkSvbIYwNDxP/VTlXxnQ+l9K4qtNQBB8E7AszY=; 
        b=ZTswfufYLfBUTlM3G1LBJcvEOmvOr5U1Zgx1jGN80MJ+FSruTfU5NXjc9aPZJ79IgxqJGfdmvRcgxjleOEBtcmgh09awRF/NhRc8Xmyuq3K5JG2tmrBI8yJ2dNHPkCclzLciSnuJxzUy24kXqu0CF+bn9qSe2YfAPnA7ZTfWwuM=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645889135;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=YSqK2GkSvbIYwNDxP/VTlXxnQ+l9K4qtNQBB8E7AszY=;
        b=f8ytak353nzQgQDHAn/b1i+eTQt9a/zwxQMndn/JCfTpK/XUokjnX42BMmckjAJQ
        c5kKKKNkcRstCXj/pTGZaUMast6iwlb9B0Yr75KVzDbaKs2P5meL/+wghkjoOq1Jffh
        t2I79yh4U1zVvxwxYAwjIv4FXjOrmNiXnyl+Y1cM=
Received: from localhost.localdomain (106.55.170.121 [106.55.170.121]) by mx.zoho.com.cn
        with SMTPS id 1645889133994450.43592543281284; Sat, 26 Feb 2022 23:25:33 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     guaneryu@gmail.com
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220226152520.289069-1-cgxu519@mykernel.net>
Subject: [PATCH] overlay/079: test for parent directory consistancy in copy-up
Date:   Sat, 26 Feb 2022 23:25:20 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Make sure the change for parent direcotry get synced in copy-up.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 tests/overlay/079     | 50 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/079.out |  2 ++
 2 files changed, 52 insertions(+)
 create mode 100755 tests/overlay/079
 create mode 100644 tests/overlay/079.out

diff --git a/tests/overlay/079 b/tests/overlay/079
new file mode 100755
index 00000000..c542cfc9
--- /dev/null
+++ b/tests/overlay/079
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Chengguang Xu <cgxu519@mykernel.net>.
+# All Rights Reserved.
+#
+# FS QA Test 079
+#
+# Test copy up consistency for parent directory.
+#
+. ./common/preamble
+_begin_fstest copyup quick
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs overlay
+_require_scratch
+#_require_command "$FLOCK_PROG" flock
+_require_scratch_shutdown
+
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+mkdir -p $lowerdir/foo_dir
+echo a > /tmp/foo
+echo a > $lowerdir/foo_dir/foo
+
+# Mounting overlay
+_scratch_mount
+
+touch $SCRATCH_MNT/foo_dir/foo
+_scratch_shutdown
+_scratch_cycle_mount
+
+echo "Silence is golden"
+diff /tmp/foo $upperdir/foo_dir/foo
+
+# success, all done
+status=3D0
+exit
diff --git a/tests/overlay/079.out b/tests/overlay/079.out
new file mode 100644
index 00000000..dc0bbb6a
--- /dev/null
+++ b/tests/overlay/079.out
@@ -0,0 +1,2 @@
+QA output created by 079
+Silence is golden
--=20
2.27.0


