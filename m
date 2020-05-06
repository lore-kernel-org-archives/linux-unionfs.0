Return-Path: <SRS0=Z7uo=6U=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FBEC28CBC
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFBF320747
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 May 2020 10:16:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="VGFH9rUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgEFKQE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 6 May 2020 06:16:04 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21128 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726354AbgEFKQE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 May 2020 06:16:04 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1588760140; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=mm7/+5PPpn1lWayFVZ2bxIhX2UYnTCaDjJD4RfDn0Xxk5tiZHKU7pEhbznl7HgaDl+uQaPZKoYmZQ012QVQnKj6XYxPgWL2YMqCUn5lG+he3VSRENp4Me1F77rOdcnMsw1wGQhe9ZdqsVgSw9O2FpKgEBLs461mqRTV6oWiMxgQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1588760140; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=Ggml1o82k6KVm5HD6w6KjbpDYIEsphB7H0u6YgALDCo=; 
        b=AG8SFEnn5hTbRVM27gBGSESscNOOWh4jA7ZiRWr7RiUrsqH5fVMZm4WQEDvpSZNNRwgRzMC33VY8/IK/Qm+eaFnCskQi4r7WzI9Wh5KIm61taEk7E6sTz+XQHUOAi12zt9AZFKshYG6WDolJ5zmVIFWlTvmVeoJ/MkEP6HQyGu8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1588760140;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=Ggml1o82k6KVm5HD6w6KjbpDYIEsphB7H0u6YgALDCo=;
        b=VGFH9rUu+BUVt090JwxWlhQo4nY/lqWIARbRS1bJL+4VsMd5tnQo6cui/rlrshNJ
        xK9iorGzMX3UGtveNGezq+o0uvcBI5MZ34iMSNf4NGgzUYgAtAMKrS4j/v7yTjAyJUf
        7uBgpgqQlJzS8NIWOF4uB5kY2vfoOXLPsKIUsuQo=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1588760138811260.042708897837; Wed, 6 May 2020 18:15:38 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     guan@eryu.me, miklos@szeredi.hu, amir73il@gmail.com
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200506101528.27359-1-cgxu519@mykernel.net>
Subject: [PATCH v4] overlay/072: test for whiteout inode sharing
Date:   Wed,  6 May 2020 18:15:28 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This is a test for whiteout inode sharing feature.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
v1->v2:
- Address Amir's comments in v1

v2->v3:
- Address Amir's comments in v2=20

v3->v4:
- Fix test case based on latest kernel patch(removed module param)
https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git/commit/?h=
=3Doverlayfs-next&id=3D4e49695244661568130bfefcb6143dd1eaa3d8e7

 tests/overlay/072     | 106 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/072.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 109 insertions(+)
 create mode 100755 tests/overlay/072
 create mode 100644 tests/overlay/072.out

diff --git a/tests/overlay/072 b/tests/overlay/072
new file mode 100755
index 00000000..fc847092
--- /dev/null
+++ b/tests/overlay/072
@@ -0,0 +1,106 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
+# All Rights Reserved.
+#
+# FS QA Test 072
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
+seq=3D`basename $0`
+seqres=3D$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=3D`pwd`
+tmp=3D/tmp/$$
+status=3D1=09# failure is the default!
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
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+
+lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
+# Make some testing files in lowerdir.
+# Argument:
+# $1: Testing file number
+make_lower_files()
+{
+=09for name in `seq ${1}`; do
+=09=09touch $lowerdir/file${name} &>/dev/null
+=09done
+}
+
+# Delete all copy-uped files in upperdir.
+make_whiteout_files()
+{
+=09rm -f $SCRATCH_MNT/* &>/dev/null
+}
+
+# Check link count of whiteout files.
+# Arguments:
+# $1: Testing file number
+# $2: Expected link count
+check_whiteout_files()
+{
+=09for name in `seq ${1}`; do
+=09=09local real_count=3D`stat -c %h $upperdir/file${name} 2>/dev/null`
+=09=09if [[ ${2} !=3D $real_count ]]; then
+=09=09=09echo "Expected link count is ${2} but real count is $real_count, =
file name is file${name}"
+=09=09fi
+=09done
+=09local tmpfile_count=3D`ls $workdir/work/\#* $workdir/index/\#* 2>/dev/n=
ull |wc -l 2>/dev/null`
+=09if [[ -n "$tmpfile_count" && $tmpfile_count > 1 ]]; then
+=09=09echo "There are more than one whiteout tmpfile in work/index dir!"
+=09=09ls -l $workdir/work/\#* $workdir/index/\#* 2>/dev/null
+=09fi
+}
+
+# Run test case with specific arguments.
+# Arguments:
+# $1: Testing file number
+# $2: Expected link count
+run_test_case()
+{
+=09_scratch_mkfs
+=09make_lower_files ${1}
+=09_scratch_mount
+=09make_whiteout_files
+=09check_whiteout_files ${1} ${2}
+=09_scratch_unmount
+}
+
+#Test case
+file_count=3D10
+link_count=3D11
+run_test_case $file_count $link_count
+
+# success, all done
+echo "Silence is golden"
+status=3D0
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
index 43ad8a52..8b2276f1 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -74,3 +74,4 @@
 069 auto quick copyup hardlink exportfs nested nonsamefs
 070 auto quick copyup redirect nested
 071 auto quick copyup redirect nested nonsamefs
+072 auto quick whiteout
--=20
2.20.1


