Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C2F2FC890
	for <linux-unionfs@vger.kernel.org>; Fri, 17 Oct 2025 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760720818; cv=none; b=ShlSz03M746FC5q+CFfgtvTuEQ0+XMbCtfc03USmV+DDGChnzGA910w5yoqqXniWf4TcnPXCK70YOUwW+vTgIALL8fczqslWJ+oEBPuyM+8+B0ZYIXQ/rX1QkEp5v1AMI/VuUubNFOZ7wQ2dDK7p8+PMIfxhPYVy1/RIgCNbESE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760720818; c=relaxed/simple;
	bh=ZBIz6637B97cl+2Mu704ObwDp3tez+7Dya0yN/9mHdc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O+SrSMh5SdPSORyxysqtaXwF0+bODlaSNH0pzh83liytCUOavhFo3PEBiuUozUBbKjnz5dUKbr1QaeY9rvn4JWhGfuK6FzFY1LTkxrv4kdNMnVEwwp4H4zmi7wF0Uxjxd509lUwISWo1EmfkeKwZP0t9zvo2ucY2r/j+Nx7yFqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QbKm9Zv8; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QbKm9Zv8"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63c11011e01so3245982a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Oct 2025 10:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760720813; x=1761325613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uuVtFMJghFoaORBDZMM/SwK57hrtfhUV9weZMZCmgfY=;
        b=QbKm9Zv80n4ZYjKDfaDlt74sTYGSGSXATIGrMlXLZak1b+vomDG5MGNjBTRuV2Ds7Q
         UnoHrJE3XPjE6jBLSjmXXR8/jzC7sq7Mbha/a36Z/GmD//q/OeBCUCFwGJlgEGsD4oxU
         ZGt5y3RqDVKeA+q4CeNkyv1UZzdv7LlLQQgkCBOVb5MSMF6A6agmsqm/OmdEwUUnv4SK
         14xK8egJko0UW+cOM56Tm1j7Oy8AEfuxIhyfPoeswsy8Kq7+7GZhRvJPpD4qCZOnqhPP
         a58rmG3SY9KipgWox8KmZ/jLmxwJeFxlIOdPFxma1ya14KMMJUeQPjzZUnqDxCFwSifZ
         i7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760720813; x=1761325613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uuVtFMJghFoaORBDZMM/SwK57hrtfhUV9weZMZCmgfY=;
        b=esNS3O8wFiGK4dFmDA4ygQXU482WLwGNM/hTW2PujvSKohizTJivcYiuzM4FIo+0r3
         75phZxDKewosRUyYj8T3K+p+7p+GK/oA1hoTg6aIgHhPenHB6bfW7LAvNJnX7CUsXdI0
         Z0aDJ8qzYM71fvqaZbS88va5E6sl8dFKb2aEpQw5xuQF0UyjMQ81E/aPgGVZaV9rGefn
         eWPId5TPxPZiNSbAjcS1rQtpKrSryOImesN5VeoR7DB03BAeGiOKVclVlNvNTUz4nAhl
         n/n4oFcn5AZ80C0iyvaptvKjeSrpYWLngmxMa1ZmyeY/cPP+nkXEOg10v6GMauxOGvdt
         uDwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwNU4iyQ/76BCF88/clvAcE5G0BUTIplD2a3myKQry+r+SgVzzGlrxPHd8A2ikdaivQ9SwmV3lCPGFDTi9@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrp2X8eS3kOvT7g/SzHS0fKvhXO3fP6MmdcRft2X7qJVVOVWH+
	cT7dSxjWuWd6fDfaYKcW7xTX6UTk9/bZXo+Fo5QpILHM6hBY6BcKYYgX
X-Gm-Gg: ASbGncs6CCYvSnZJ9DsamB+TFGN0m/pJ4IE24fnOta0gY96z5/f4ZZdBj+fgDxofgIO
	zBCC93ngIw3hequK2KtmS3u9sC4/3KBdmvsgyKtNhGdWb/ewOx1QYfh2emDuKBY6DSfh6yArDZi
	sYjntbaBK+M73GsPIjzYKb1H8Y924QblKwt0+Bxzu2+YtDnJQHV8WA9ZHRsvuOUVk/Ni4n1/onc
	EoqYVB6j7n5rfe//8SFBSggjpAIXpfCMjuCK10cIvb38U4ezTX3yhASzf1SRFHbmUR7e5EEL1aa
	Phd8FSQCotkO/1ZW1J1hWLsKvwKJN534/pZxUgr6TJ4CpTDQu62MqbWxCs/dTAeG+t8Gj6cFSBE
	kHiRoThIrVc3cc+4EQ1BcEdBMRaf5jRQZcskWpmc8yNHE6KCPDY87G4npo6Uu6pJD52Q64crP3L
	P8X7nhcY2ccwgqAEvt5KDOPgY/bS4ATAiXI+M2WJoDF/vY44CsVQhcj5GH5adwfOkqvuJEv0P4J
	N/IG8VNFt70NP6VlPl3tR2UIgyQtiS/
X-Google-Smtp-Source: AGHT+IEUUfXHUy7p3WT1iu83aVLoGQuzxpYrqjTdNKJ7THYVhKitPiuPirOSMrDRnMz+eQzu01aAGg==
X-Received: by 2002:a05:6402:d0e:b0:634:ce70:7c5 with SMTP id 4fb4d7f45d1cf-63c1f6d6c07mr3539817a12.17.1760720813231;
        Fri, 17 Oct 2025 10:06:53 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (2001-1c00-570d-ee00-20c4-b852-1954-0ec9.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:20c4:b852:1954:ec9])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4943015bsm224181a12.21.2025.10.17.10.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 10:06:52 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] overlay: add tests for casefolded layers
Date: Fri, 17 Oct 2025 19:06:49 +0200
Message-ID: <20251017170649.2092386-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Overalyfs did not allow mounting layers with casefold capable fs
until kernel v6.17-rc1 and did not allow casefold enabled layers
until kernel v6.18-rc1.

Since kernel v6.18-rc1, overalyfs allows this kind of setups,
as long as the layers have consistent encoding and all the directories
in the subtree have consistent casefolding.

Create test cases for the following scenarios:
- Mounting overlayfs with casefold disabled
- Mounting overlayfs with casefold enabled
- Lookup subdir in overlayfs with mismatch casefold to parent dir
- Change casefold of underlying subdir while overalyfs is mounted
- Mounting overlayfs with strict enconding, but casefold disabled
- Mounting overlayfs with strict enconding casefold enabled
- Mounting overlayfs with layers with inconsistent UTF8 version

Co-developed-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

This test covers the overlayfs casefold feature that was introduced in
two steps - casefold disabled layers in 6.17-rc1 and casefold enabled
layers in 6.18-rc1.

I think there is less interest in testing the v6.17 changes on their own
so this test requires support for casefold enabled layers from 6.18-rc1
and will notrun on kernel < 6.18-rc1:

generic/999 5s ...  [12:43:16] [12:43:18] [not run]
	generic/999 -- overlayfs does not support casefold enabled layers

If there is a demand, we could split a test for the v6.17 support.

Note that this test is written as a generic and not an overlay test,
because we do not have the infrastructure to format and mount a base fs
with casefold support, so this test can run with e.g. ext4 FSTYP, but it
will notrun with e.g. xfs FSTYPE:

generic/999 6s ...  [12:30:03] [12:30:05] [not run]
	generic/999 -- xfs does not support casefold feature

I left the test number 999 for you to re-number.
If you prefer that I post with another test number assignment in the
future please let me know.

Thanks,
Amir.


 tests/generic/999     | 243 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  13 +++
 2 files changed, 256 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..e81ea036
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,243 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 999
+#
+# Test overlayfs error cases with casefold enabled layers
+#
+# Overalyfs did not allow mounting layers with casefold capable fs
+# until kernel v6.17 and with casefold enabled until kernel v6.18.
+# Since kernel v6.17, overalyfs allows the mount, as long as casefolding
+# is disabled on all directories.
+# Since kernel v6.18, overalyfs allows the mount, as long as casefolding
+# is consistent on all directories and encoding is consistent on all layers.
+#
+. ./common/preamble
+_begin_fstest auto quick mount casefold
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_unmount $merge 2>/dev/null
+	rm -r -f $tmp.*
+}
+
+
+# Import common functions.
+. ./common/filter
+. ./common/casefold
+
+_exclude_fs overlay
+_require_extra_fs overlay
+
+_require_scratch_casefold
+
+# Create casefold capable base fs
+_scratch_mkfs_casefold >>$seqres.full 2>&1
+_scratch_mount_casefold
+
+# Create lowerdir, upperdir and workdir without casefold enabled
+lowerdir="$SCRATCH_MNT/ovl-lower"
+upperdir="$SCRATCH_MNT/ovl-upper"
+workdir="$SCRATCH_MNT/ovl-work"
+merge="$SCRATCH_MNT/ovl-merge"
+
+mount_casefold_version()
+{
+	option="casefold=$1"
+	mount -t tmpfs -o $option tmpfs $2
+}
+
+mount_overlay()
+{
+	local lowerdirs=$1
+
+	_mount -t overlay overlay $merge \
+		-o lowerdir=$lowerdirs,upperdir=$upperdir,workdir=$workdir
+}
+
+unmount_overlay()
+{
+	_unmount $SCRATCH_MNT/ovl-merge 2>/dev/null
+}
+
+# Try to mount an overlay with casefold enabled layers.
+# On kernels older than v6.18 expect failure and skip the test
+mkdir -p $merge $upperdir $workdir $lowerdir
+_casefold_set_attr $upperdir >>$seqres.full
+_casefold_set_attr $workdir >>$seqres.full
+_casefold_set_attr $lowerdir >>$seqres.full
+mount_overlay $lowerdir >>$seqres.full 2>&1 || \
+	_notrun "overlayfs does not support casefold enabled layers"
+unmount_overlay
+
+# Re-create casefold disabled layers with lower subdir
+casefolddir=$lowerdir/casefold
+rm -rf $upperdir $workdir $lowerdir
+mkdir -p $upperdir $workdir $lowerdir $casefolddir
+
+# Try to mount an overlay with casefold capable but disabled layers.
+# Since we already verified that overalyfs supports casefold enabled layers
+# this is expected to succeed.
+echo Casefold disabled
+mount_overlay $lowerdir >>$seqres.full 2>&1 || \
+	echo "Overlayfs mount with casefold disabled layers failed (1)"
+ls $merge/casefold/ >>$seqres.full
+unmount_overlay
+
+# Use new upper/work dirs for each test to avoid ESTALE errors
+# on mismatch lowerdir/upperdir (see test overlay/037)
+rm -rf $upperdir $workdir
+mkdir $upperdir $workdir
+
+# Try to mount an overlay with casefold disabled layers and
+# enable casefold on lowerdir root after mount - expect ESTALE error on lookup.
+echo Casefold enabled after mount
+mount_overlay $casefolddir >>$seqres.full || \
+	echo "Overlayfs mount with casefold disabled layers failed (2)"
+_casefold_set_attr $casefolddir >>$seqres.full
+mkdir $casefolddir/subdir
+ls $merge/subdir |& _filter_scratch
+unmount_overlay
+
+# Try to mount an overlay with casefold enabled lowerdir root - expect EINVAL.
+# With libmount version >= v1.39, we expect the following descriptive error:
+# mount: overlay: case-insensitive directory on .../ovl-lower/casefold not supported
+# but we want the test to run with older libmount, so we so not expect this output
+# we just expect a mount failure.
+echo Casefold enabled lower dir
+mount_overlay $casefolddir >>$seqres.full 2>&1 && \
+	echo "Overlayfs mount with casefold enabled lowerdir should have failed" && \
+	unmount_overlay
+
+# Changing lower layer root again
+rm -rf $upperdir $workdir
+mkdir $upperdir $workdir
+
+# Try to mount an overlay with casefold disabled layers, but with
+# casefold enabled subdir in lowerdir - expect EREMOTE error on lookup.
+echo Casefold enabled lower subdir
+mount_overlay $lowerdir >>$seqres.full
+ls $merge/casefold/subdir |& _filter_scratch
+unmount_overlay
+
+# workdir needs to be empty to set casefold attribute
+rm -rf $workdir/*
+
+_casefold_set_attr $upperdir >>$seqres.full
+_casefold_set_attr $workdir >>$seqres.full
+
+echo Casefold enabled upper dir
+mount_overlay $lowerdir >>$seqres.full 2>&1 && \
+	echo "Overlayfs mount with casefold enabled upperdir should have failed" && \
+	unmount_overlay
+
+# lowerdir needs to be empty to set casefold attribute
+rm -rf $lowerdir/*
+_casefold_set_attr $lowerdir >>$seqres.full
+mkdir $casefolddir
+
+# Try to mount an overlay with casefold enabled layers.
+# On kernels older than v6.18 expect failure and skip the rest of the test
+# On kernels v6.18 and newer, expect success and run the rest of the test cases.
+echo Casefold enabled
+mount_overlay $lowerdir >>$seqres.full 2>&1 || \
+	echo "Overlayfs mount with casefold enabled layers failed (1)"
+ls $merge/casefold/ >>$seqres.full
+unmount_overlay
+
+# Try to mount an overlayfs with casefold enabled layers. After the mount,
+# disable casefold on the lower layer and try to lookup a file. Should return
+# -ESTALE
+echo Casefold disabled on lower after mount
+mount_overlay $lowerdir >>$seqres.full 2>&1 || \
+	echo "Overlayfs mount with casefold enabled layers failed (2)"
+rm -rf $lowerdir/*
+_casefold_unset_attr $lowerdir >>$seqres.full
+mkdir $lowerdir/dir
+ls $merge/dir/ |& _filter_scratch
+unmount_overlay
+
+# cleanup
+rm -rf $lowerdir/*
+_casefold_set_attr $lowerdir >>$seqres.full
+
+# Try to mount an overlayfs with casefold enabled layers. After the mount,
+# disable casefold on a subdir in  the lower layer and try to lookup it.
+# Should return -EREMOTE
+echo Casefold disabled on subdir after mount
+mkdir $lowerdir/casefold/
+mount_overlay $lowerdir >>$seqres.full 2>&1 || \
+	echo "Overlayfs mount with casefold enabled layers failed (3)"
+_casefold_unset_attr $lowerdir/casefold/
+mkdir $lowerdir/casefold/subdir
+ls $merge/casefold/subdir |& _filter_scratch
+unmount_overlay
+
+# cleanup
+rm -rf $lowerdir/*
+
+# Test strict enconding, but casefold not enabled. Should work
+_scratch_umount_idmapped
+
+_scratch_mkfs_casefold_strict >>$seqres.full 2>&1
+_scratch_mount_casefold
+
+mkdir -p $merge $upperdir $workdir $lowerdir
+
+mount_overlay $lowerdir >>$seqres.full 2>&1 || \
+	echo "Overlayfs mount with strict casefold disabled layers failed"
+unmount_overlay
+
+# Test strict enconding, with casefold enabled. Should fail
+# dmesg: overlayfs: strict encoding not supported
+rm -rf $upperdir $workdir
+mkdir $upperdir $workdir
+
+_casefold_set_attr $upperdir >>$seqres.full
+_casefold_set_attr $workdir >>$seqres.full
+_casefold_set_attr $lowerdir >>$seqres.full
+
+mount_overlay $lowerdir >>$seqres.full 2>&1 && \
+	echo "Overlayfs mount with strict casefold enabled should have failed" && \
+	unmount_overlay
+
+# Test inconsistent casefold version. Should fail
+# dmesg: overlayfs: all layers must have the same encoding
+
+# use tmpfs to make easier to create two different mount points with different
+# utf8 versions
+testdir="$SCRATCH_MNT/newdir/"
+mkdir $testdir
+
+MNT1="$testdir/mnt1"
+MNT2="$testdir/mnt2"
+
+mkdir $MNT1 $MNT2 "$testdir/merge"
+
+mount_casefold_version "utf8-12.1.0" $MNT1
+mount_casefold_version "utf8-11.0.0" $MNT2
+
+mkdir "$MNT1/dir" "$MNT2/dir"
+
+_casefold_set_attr "$MNT1/dir"
+_casefold_set_attr "$MNT2/dir"
+
+mkdir "$MNT1/dir/lower" "$MNT2/dir/upper" "$MNT2/dir/work"
+
+upperdir="$MNT2/dir/upper"
+workdir="$MNT2/dir/work"
+lowerdir="$MNT1/dir/lower"
+
+mount_overlay $lowerdir >>$seqres.full 2>&1  && \
+	echo "Overlayfs mount different unicode versions should have failed" && \
+	unmount_overlay
+
+umount $MNT1
+umount $MNT2
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..ce383d94
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,13 @@
+QA output created by 999
+Casefold disabled
+Casefold enabled after mount
+ls: cannot access 'SCRATCH_MNT/ovl-merge/subdir': Stale file handle
+Casefold enabled lower dir
+Casefold enabled lower subdir
+ls: cannot access 'SCRATCH_MNT/ovl-merge/casefold/subdir': Object is remote
+Casefold enabled upper dir
+Casefold enabled
+Casefold disabled on lower after mount
+ls: cannot access 'SCRATCH_MNT/ovl-merge/dir/': Stale file handle
+Casefold disabled on subdir after mount
+ls: cannot access 'SCRATCH_MNT/ovl-merge/casefold/subdir': Object is remote
-- 
2.50.1

