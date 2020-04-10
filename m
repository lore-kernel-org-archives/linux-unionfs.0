Return-Path: <SRS0=xMZa=52=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BDFC2BA19
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 01:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C33720730
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 01:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="axZyRF1y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgDJBWE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 21:22:04 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21182 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgDJBWE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 21:22:04 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1586481708; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=dGAfQxIlFykBXH2oL4JzxDbym4JQTvUQycqeNJaKGO3g7x5GejR+tr1L59OINct+WwoqeqLe10UXEZ3Y4Lk84VNwpjvNoyVap2JqpByPVMQ0Ry8uoF8RQZHAVSbmCkDU+gaJ1s5Ljc/uS++cPyI5mLXSgzYqXZBbpEwS8L3D8Aw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586481708; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=JTACoukFeV8GJSGPxB3UNCum4AgaukuTvb8ICxNxzGw=; 
        b=CgF/7DM2kgCaRGa57N7LtRLIvpN/J7YzeRcGJrKIEHFsM34zWSBDwyRrnscZNpHPfOtI9r8Hx0Re/wd/YbGO3MAgNpwNO2y3O/vfXS05EIUDc9jhUS93G55mIl+bFri69cA5SUZVQWd8bHuTfDWi2LanfG0NY0wkT806o0byNeI=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586481708;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=JTACoukFeV8GJSGPxB3UNCum4AgaukuTvb8ICxNxzGw=;
        b=axZyRF1yJCFmif3Q089m7WiXcNaRDzOPe0a5p7J3XBNiO9NY0pI/FVjtXrZJjavZ
        kbLNbaMn41+iVkap8HB0/fMpUMRNV8twNxZymp3Uy0Xk8fsXyGtGlEKdTMC8Ytx6O5j
        OH58P567y/Rexa16JR2GWYjg2UY+WaGFPoMbRZos=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1586481706402339.1360331165083; Fri, 10 Apr 2020 09:21:46 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     guaneryu@gmail.com
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, amir73il@gmail.com,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200410012059.27210-2-cgxu519@mykernel.net>
Subject: [PATCH 2/2] overlay/072: test for sharing inode with whiteout files
Date:   Fri, 10 Apr 2020 09:20:59 +0800
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410012059.27210-1-cgxu519@mykernel.net>
References: <20200410012059.27210-1-cgxu519@mykernel.net>
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
Hi Eryu,

Kernel patch of this feature is still in review but I hope to merge
test case first, so that we can check the correctness in a convenient
way. The test case will carefully check new module param and skip the
test if the param does not exist.


 tests/overlay/072     | 148 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/072.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 151 insertions(+)
 create mode 100755 tests/overlay/072
 create mode 100644 tests/overlay/072.out

diff --git a/tests/overlay/072 b/tests/overlay/072
new file mode 100755
index 00000000..1cff386d
--- /dev/null
+++ b/tests/overlay/072
@@ -0,0 +1,148 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chengguang Xu <cgxu519@mykernel.net>.
+# All Rights Reserved.
+#
+# FS QA Test 072
+#
+# This is a test for inode sharing with whiteout files.
+#
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
+_require_test
+_require_scratch
+
+param_name=3D"whiteout_link_max"
+check_whiteout_link_max()
+{
+=09local param_value=3D`_get_fs_module_param ${param_name}`
+=09if [ -z ${param_value} ]; then
+=09=09_notrun "${FSTYP} module param ${param_name} does not exist"
+=09fi
+}
+
+lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+merged=3D$OVL_BASE_SCRATCH_MNT/$OVL_MNT
+
+#Make some files in lowerdir.
+make_lower_files()
+{
+=09seq 1 $file_count | while read line; do
+=09=09`touch $lowerdir/test${line} 1>&2 2>/dev/null`
+=09done
+}
+
+#Delete all copy-uped files in upperdir.
+make_whiteout_files()
+{
+=09rm -f $merged/* 1>&2 2>/dev/null
+}
+
+#Check link count of whiteout files.
+check_whiteout_files()
+{
+=09seq 1 $file_count | while read line; do
+=09=09local real_count=3D`stat -c %h $upperdir/test${line} 2>/dev/null`
+=09=09if [[ $link_count !=3D $real_count ]]; then
+=09=09=09echo "Expected whiteout link count is $link_count but real count =
is $real_count"
+=09=09fi
+=09done
+}
+
+check_whiteout_link_max
+
+# Case1:
+# Setting whiteout_link_max=3D0 will not share inode
+# with whiteout files, it means each whiteout file
+# will has it's own inode.
+
+file_count=3D10
+link_max=3D0
+link_count=3D1
+_scratch_mkfs
+_set_fs_module_param $param_name $link_max
+make_lower_files
+_scratch_mount
+make_whiteout_files
+check_whiteout_files
+$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
+
+# Case2:
+# Setting whiteout_link_max=3D1 will not share inode
+# with whiteout files, it means each whiteout file
+# will has it's own inode.
+
+file_count=3D10
+link_max=3D1
+link_count=3D1
+_scratch_mkfs
+_set_fs_module_param $param_name $link_max
+make_lower_files
+_scratch_mount
+make_whiteout_files
+check_whiteout_files $link_count
+$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
+
+# Case3:
+# Setting whiteout_link_max=3D2 will not share inode
+# with whiteout files, it means each whiteout file
+# will has it's own inode. However, the inode will
+# be shared with tmpfile(in workdir) which is used
+# for creating whiteout file.
+
+file_count=3D10
+link_max=3D2
+link_count=3D2
+_scratch_mkfs
+_set_fs_module_param $param_name $link_max
+make_lower_files
+_scratch_mount
+make_whiteout_files
+check_whiteout_files
+$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
+
+# Case4:
+# Setting whiteout_link_max=3D10 will share inode
+# with 9 whiteout files and meanwhile the inode
+# will also share with tmpfile(in workdir) which
+# is used for creating whiteout file.
+
+file_count=3D18
+link_max=3D10
+link_count=3D10
+_scratch_mkfs
+_set_fs_module_param $param_name $link_max
+make_lower_files
+_scratch_mount
+make_whiteout_files
+check_whiteout_files
+$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/$OVL_MNT
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


