Return-Path: <SRS0=lkgI=6G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4B9C38A30
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 04:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B674320747
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 04:53:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="BX9W62jv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgDVExP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 00:53:15 -0400
Received: from [163.53.93.247] ([163.53.93.247]:21176 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1725835AbgDVExP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Apr 2020 00:53:15 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1587531151; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=KuT8ywzGQkfIze9INjVQCxeMUPQNemRa6A8spzNCWB7O5XWkKwonn7tmstqdaB7wn6fFHqtDZsV32Bk5lnfYVuC3sMf5LjbBl3zVyCMQrv8f+3srNiWZ52F9VWVuyotysEiN9+dbRZA9kG6VnS+xuSY8Rb3Otd7uwXIxXnmru90=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1587531151; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=0wCcrn01aUbkP6uUsfGPJ+tKuZ3hnHNtuVHtzrpMEnI=; 
        b=K8wklrXdSOiA11I161izFw8a1VPpqCimSnDAjhqe7lE9X2HNltrGbPkeBhkuZatyW+jqkpgr6ZKeEXTEUiRekjgS4qI+wfOmx3A2a1cORHsxmKTMf0AtlcWH7T0Y3Iy9eMEJzC8MvKkkhBjSC2MYRJbeOj+5xE3U/0s8vGopiOQ=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1587531151;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=0wCcrn01aUbkP6uUsfGPJ+tKuZ3hnHNtuVHtzrpMEnI=;
        b=BX9W62jvpTym2RwoVI8bxlpiIz29LmYsxB/ze+5kxPoM2JvcXGk+QwG7zLj1FNPj
        eLfcBBQwyuerT3genTFB2uziY40+yU560PPsXV5tQsHAFa6c6BTo1v+YY3zaep6NTBp
        c9Q08XLu9E+TjgxDt3DkV2jUhGApU4eEilhKbIBA=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1587531149479502.74777769135153; Wed, 22 Apr 2020 12:52:29 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     guaneryu@gmail.com
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org,
        guan@eryu.me, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200422045210.11017-1-cgxu519@mykernel.net>
Subject: [PATCH] generic/484: test data integrity for rdonly remount
Date:   Wed, 22 Apr 2020 12:52:10 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This test checks data integrity when remounting from
rw to ro mode.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 tests/generic/484     | 54 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/484.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 57 insertions(+)
 create mode 100755 tests/generic/484
 create mode 100644 tests/generic/484.out

diff --git a/tests/generic/484 b/tests/generic/484
new file mode 100755
index 00000000..bc640214
--- /dev/null
+++ b/tests/generic/484
@@ -0,0 +1,54 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
+# All Rights Reserved.
+#
+# FS QA Test 484
+#
+# Test data integrity for ro remount.
+#
+seq=3D`basename $0`
+seqres=3D$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=3D`pwd`
+tmp=3D/tmp/$$
+status=3D0
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+=09cd /
+=09rm -f $tmp.*
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
+_supported_fs generic
+_supported_os Linux
+_require_fssum
+_require_scratch
+_require_scratch_shutdown
+
+_scratch_mkfs &>/dev/null
+_scratch_mount
+
+localdir=3D$SCRATCH_MNT/dir
+mkdir $localdir
+sync
+
+# fssum used for comparing checksum of test file(data & metedata),
+# exclude checking about atime, block structure, open error.
+$FSSUM_PROG -ugomAcdES -f -w $tmp.fssum $localdir
+_scratch_remount ro
+_scratch_shutdown
+_scratch_cycle_mount
+$FSSUM_PROG -r $tmp.fssum $localdir
+
+exit
diff --git a/tests/generic/484.out b/tests/generic/484.out
new file mode 100644
index 00000000..e33c7815
--- /dev/null
+++ b/tests/generic/484.out
@@ -0,0 +1,2 @@
+QA output created by 484
+OK
diff --git a/tests/generic/group b/tests/generic/group
index 718575ba..cc58ff0d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -486,6 +486,7 @@
 481 auto quick log metadata
 482 auto metadata replay thin
 483 auto quick log metadata
+484 auto quick remount
 485 auto quick insert
 486 auto quick attr
 487 auto quick eio
--=20
2.20.1


