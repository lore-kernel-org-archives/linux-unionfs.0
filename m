Return-Path: <SRS0=3eGR=7B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA31CC433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 May 2020 08:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76B56207D8
	for <linux-unionfs@archiver.kernel.org>; Tue, 19 May 2020 08:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="EhMaellB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgESIJz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 19 May 2020 04:09:55 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17109 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726943AbgESIJz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 May 2020 04:09:55 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589875785; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=TbDslXawFPlDrk7MfZ7kTHPNdLoWDSalin0O8GghG3/J94KLX+c6BJtJMDRa9/rOeebSuKDTz9ftCLs2tvYXgjhQ7/CGD5i1v9wPb4a+8qVk9Ruuh5Meyq+mMSvXvEz4aR0/bpOUD+8Nb0aWLJ56MWa4J+dzyz+nxCsIr2bPQDQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589875785; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=/grsoLC3wLMOVmOUeNiyU0jilmT1TITVnzWgH4P7dwg=; 
        b=WnjMeRFULvHx7heON1ln2av5lBzYSjIQsXifs51TYkRe6oo9Ax11Tw+zXFYfTP5LAx6dfSDo6R/YVFymjb4SMcchHQIex48qJKzplfnUW+k6XX4opz5XrV2f/mtxMrZfDFfm+lM7jdxnPyj7vXe45/3TBwwSwE67xy6JGdgWEQk=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589875785;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=/grsoLC3wLMOVmOUeNiyU0jilmT1TITVnzWgH4P7dwg=;
        b=EhMaellBCgRMv92tcZJyQGKKfElBmfsi4NzJ7zrymSNATwPJrRKt9teaX61Q2gOd
        uC/44D3RnTJUH7gTg9Oh5HvDEBcSxan7oD5cGdY95WSqr4DKjT0NRaWV3HsO0tlG/1k
        csoSkGTIMUkRwxxs6NfjxLwvaTxaJtXBqmIDmtJA=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1589875783960843.5830726554441; Tue, 19 May 2020 16:09:43 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     guaneryu@gmail.com
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200519080929.18030-1-cgxu519@mykernel.net>
Subject: [PATCH v2] generic/597: test data integrity for rdonly remount
Date:   Tue, 19 May 2020 16:09:29 +0800
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
v1->v2:
- Add to shutdown greoup.
- Change case number to 597

 tests/generic/597     | 54 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/597.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 57 insertions(+)
 create mode 100755 tests/generic/597
 create mode 100644 tests/generic/597.out

diff --git a/tests/generic/597 b/tests/generic/597
new file mode 100755
index 00000000..d96e750b
--- /dev/null
+++ b/tests/generic/597
@@ -0,0 +1,54 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
+# All Rights Reserved.
+#
+# FS QA Test 597
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
diff --git a/tests/generic/597.out b/tests/generic/597.out
new file mode 100644
index 00000000..a847cfe2
--- /dev/null
+++ b/tests/generic/597.out
@@ -0,0 +1,2 @@
+QA output created by 597
+OK
diff --git a/tests/generic/group b/tests/generic/group
index e82004e8..d68fee9a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -599,3 +599,4 @@
 594 auto quick quota
 595 auto quick encrypt
 596 auto quick
+597 auto quick remount shutdown
--=20
2.20.1


