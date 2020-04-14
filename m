Return-Path: <SRS0=sqyI=56=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C76C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Apr 2020 02:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C8502072A
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Apr 2020 02:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="dZM81xq4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404126AbgDNCcA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Apr 2020 22:32:00 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21111 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728787AbgDNCb7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Apr 2020 22:31:59 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1586831494; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=mGx8ZWJFLudppO+rLehFTuK9/bOek4n0erhz1z9vTPmxe2rO+F22pvojq/KBeRSmG4CfFsJTzRRaYGxw95V9xxCsWRqbT24sAxOxOMrYubZIguuedSK5GT/G7bWQsjhBUA3IKcfQ9xqzdKAqF52vDnRTzRusZYQPKsaZNhXmPZk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586831494; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=jmJ3DZa3AzQqDsTyJxHEVcDXa7r2+k89362b/f+DFgU=; 
        b=U/SXurY7w9iGRP3WydMEMJmKmLmSwIb9NpaO+mQVHJZwnVXR8e26Nubal7IEAPw6vojJE3dbN92vWoh8FHXEC7mCEe+i8dBkmscPGVtGbgm5da3c1c1aOGG5aeT27yqaNNlY7pemsp/nXucsU27RRmLU1BccgpZ++qOGdwxyzY0=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586831494;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=jmJ3DZa3AzQqDsTyJxHEVcDXa7r2+k89362b/f+DFgU=;
        b=dZM81xq4Z9hWs+/snzO5whajekWyQc84MkPhV0s9C8Vg8xwupcTgbXJd7jhpjdmo
        DKeDZRv3XOlrMcWPosW/iRCn5H5YIuI+3sVha+NI+neYS2MdcOnB7TdxfN0oOwaybnw
        A0FZVOHF8xmK21aZQ4YEL9RovYC8GjvevvkzVlJs=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1586831491350315.98897441673193; Tue, 14 Apr 2020 10:31:31 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     guaneryu@gmail.com
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, amir73il@gmail.com,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200414023105.28261-1-cgxu519@mykernel.net>
Subject: [PATCH v2] overlay/072: test for whiteout inode sharing
Date:   Tue, 14 Apr 2020 10:31:05 +0800
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
- Address Amir's comments in v1.

 common/module         |   9 +++
 tests/overlay/072     | 148 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/072.out |   2 +
 tests/overlay/group   |   1 +
 4 files changed, 160 insertions(+)
 create mode 100755 tests/overlay/072
 create mode 100644 tests/overlay/072.out

diff --git a/common/module b/common/module
index 39e4e793..148e8c8f 100644
--- a/common/module
+++ b/common/module
@@ -81,3 +81,12 @@ _get_fs_module_param()
 {
 =09cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
 }
+ # Set the value of a filesystem module parameter
+ # at /sys/module/$FSTYP/parameters/$PARAM
+ #
+ # Usage example:
+ #   _set_fs_module_param param value
+ _set_fs_module_param()
+{
+=09echo ${2} > /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
+}
diff --git a/tests/overlay/072 b/tests/overlay/072
new file mode 100755
index 00000000..e1244394
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
+# This is a test for whiteout inode sharing feature.
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
+=09_set_fs_module_param $param_name $orig_param_value
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
+
+# Check overlayfs module param(whiteout_link_max)
+check_whiteout_link_max()
+{
+=09orig_param_value=3D`_get_fs_module_param ${param_name}`
+=09if [ -z ${orig_param_value} ]; then
+=09=09_notrun "${FSTYP} does not support whiteout inode sharing"
+=09fi
+}
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
+=09for name in `seq -s' ' ${1}`
+=09do
+=09=09touch $lowerdir/file${name} 1>&2 2>/dev/null
+=09done
+}
+
+# Delete all copy-uped files in upperdir.
+make_whiteout_files()
+{
+=09rm -f $SCRATCH_MNT/* 1>&2 2>/dev/null
+}
+
+# Check link count of whiteout files.
+# Arguments:
+# $1: Testing file number
+# $2: Expected link count
+check_whiteout_files()
+{
+=09for name in `seq -s' ' ${1}`
+=09do
+=09=09local real_count=3D`stat -c %h $upperdir/file${name} 2>/dev/null`
+=09=09if [[ ${2} !=3D $real_count ]]; then
+=09=09=09echo "Expected link count is ${2} but real count is $real_count, =
file name is file${name}"
+=09=09fi
+=09done
+=09local tmpfile_count=3D`ls $workdir/work/\#* $workdir/index/\#* 2>/dev/n=
ull |wc -l 2>/dev/null`
+=09if [[ -n $tmpfile_count && $tmpfile_count > 1 ]]; then
+=09=09echo "There are more than one whiteout tmpfile in work/index dir!"
+=09=09ls -l $workdir/work/\#* $workdir/index/\#* 2>/dev/null
+=09fi
+}
+
+# Run test case with specific arguments.
+# Arguments:
+# $1: Maximum link count
+# $2: Testing file number
+# $3: Expected link count
+run_test_case()
+{
+=09_scratch_mkfs
+=09_set_fs_module_param $param_name ${1}
+=09make_lower_files ${2}
+=09_scratch_mount
+=09make_whiteout_files
+=09check_whiteout_files ${2} ${3}
+=09_scratch_unmount
+}
+
+check_whiteout_link_max
+
+# Case1:
+# Setting whiteout_link_max=3D0 means whiteout files will not
+# share inode, each whiteout file will have it's own inode.
+
+link_max=3D0
+file_count=3D10
+link_count=3D1
+run_test_case $link_max $file_count $link_count
+
+# Case2:
+# Setting whiteout_link_max=3D0 means whiteout files will not
+# share inode, each whiteout file will have it's own inode.
+
+link_max=3D1
+file_count=3D10
+link_count=3D1
+run_test_case $link_max $file_count $link_count
+
+# Case3:
+# Setting whiteout_link_max>2 means whiteout files will share
+# inode and link count could up to whiteout_link_max.
+
+link_max=3D2
+file_count=3D10
+link_count=3D2
+run_test_case $link_max $file_count $link_count
+
+# Case4:
+# Setting whiteout_link_max>2 means whiteout files will share
+# inode and link count could up to whiteout_link_max.
+
+link_max=3D10
+file_count=3D20
+link_count=3D10
+run_test_case $link_max $file_count $link_count
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


