Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10807757EB
	for <linux-unionfs@vger.kernel.org>; Sun, 28 Jul 2024 21:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722201732; cv=none; b=HwcfwezQ+hTFsn+GMGQxucYLHEEH5xpVzWYJ3Kz24vbjHxsbDpxfmr7dlR8pb8HhibAF+CCSuNu+8zc9YmIralRZ9wrBS/Y6pJFf/JJy8qDnUlmR/I0DY2phP/aqfBhMbDHIt6S0McMo9CnxUNL9eABOca8ovKbmPwDHJc9coc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722201732; c=relaxed/simple;
	bh=Trm0K7WQXEho3VZHcTz6lRkjpejmiLuJkW8womRRA1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p67yToPbYnqMglFiXJUpzbiLdS2Ns5qGM8n1QMOJlcp0RNvDL/3NEPc28f5UlJ+bcOM665Y3jN5rsv18bexpoalorbNnixkcL2KWYOMJn8yFNqRBLZBA7oPOOir80o7f61VYDTPGLpxMQ8x86HcuASgVMS+pLgSSxan1WMzWcEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=JlcJFcTY; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="JlcJFcTY"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6b78c3670d0so14542236d6.1
        for <linux-unionfs@vger.kernel.org>; Sun, 28 Jul 2024 14:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1722201729; x=1722806529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uJwLY+uNpu6PYXN+lHtuzgyqa7k7AIeC7iZwiExIt08=;
        b=JlcJFcTY4Gsz003EdMBVMmsCnH8d62HdWwgTveJDvJsWpcSK6HdSQbacZu6n9AxKPF
         02RAeztFj13RBVYmo4ZZihBG4YzINpR4zKTmSy/wio9+V0XTNLRMUZbxGWGc+0Lzqzt4
         1fUw/gTN1gIiVnL2RpLoPE2bfbLaB0x1AYwkjSX+wTuJPLLUx1FjKBUbRje4FCFgjjFd
         beaAS67eAcae89P+NAco1lb/VNzC/KWcnKRYirNnB/+dmzbNkkn8mqCoTrvUxybJ736W
         uUzGg8ECowKw3IflNJuORhzx/G8n+3Lv4Qt1E088WZKL5Uf+o5xA3ZrWT2gYFJ8c8hmU
         Uatg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722201729; x=1722806529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uJwLY+uNpu6PYXN+lHtuzgyqa7k7AIeC7iZwiExIt08=;
        b=BvcOW9QR1jYLtBSfrdmonZfYpg3boqAFZyWwdRd24ewEWWDh1sGLEx2Ro8w1jdf8Nz
         v/51xqAereD7Gyt00oix7emI46h44MO+4AaXolO/CSo19iQt8OkSLar6wPp+S/zT4qft
         4wQnWEUpCD968kwiDx/USpcTMOhoWoVrH/GpQO+4dASgNtFDA3oo78K7eoXS34pUgIDj
         HIWqmPl+3D607QsE6lWBPmKAywaSKWoBZnZ3gixRCWataeTd1gmFfBMA3HQg/qh4uLy+
         jvUH6dqS1rA+eWPEPBE1G2rDxh0/CgBFo7vphLDaosane4GUM2nrUDF7JM9SVSd/Ub1q
         i7Gw==
X-Forwarded-Encrypted: i=1; AJvYcCVDdcsRJ/QCAtsIyhbhwlgjeFAo7gY3UzgzBiE48u3vFDVDo0Zxd0ETO4QwBhLs6STQkewkRIctiJBqK/K4pmLidRtALq0H3w9WGLCNJA==
X-Gm-Message-State: AOJu0Yy/SEX08GyRY6ACvCSqMxRyAlPcY5F5av0587+P3Y97lnopmebB
	GpLPJQ4b1/MAUQ06R0FdyvRi5NBMz/vwD94/Dnw5CEPgk5Lz4Kld3qagWYtjUYg=
X-Google-Smtp-Source: AGHT+IHllngLBDqZHAgETs5h1rEmtS0c4Y0I3aSiq8YcqWB8R0AWKd/bTeriVtD5zNykYGzRxPnacw==
X-Received: by 2002:a05:6214:3001:b0:6b7:a3f1:3248 with SMTP id 6a1803df08f44-6bb55a14cb1mr74982346d6.25.1722201728850;
        Sun, 28 Jul 2024 14:22:08 -0700 (PDT)
Received: from mike-laptop.lan.mbaynton.com ([2601:444:600:440:4da3:c9a6:89b8:5a72])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb3fa9512asm45787326d6.80.2024.07.28.14.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 14:22:08 -0700 (PDT)
From: Mike Baynton <mike@mbaynton.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Daire Byrne <daire@dneg.com>,
	overlayfs <linux-unionfs@vger.kernel.org>,
	Mike Baynton <mike@mbaynton.com>
Subject: [PATCH] Defined behaviors if files are added to data-only layers
Date: Sun, 28 Jul 2024 16:19:57 -0500
Message-Id: <20240728211956.2759194-1-mike@mbaynton.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <91e8c240-ed60-40ab-8c55-f06347e26841@mbaynton.com>
References: <91e8c240-ed60-40ab-8c55-f06347e26841@mbaynton.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test only covers for files added, but not files undergoing any
modification, including during their initial write. This generally means
a technique such as renaming the file into the data-only area of the
underlying filesystem is required.

The defined behaviors are fairly minimal:
 * A file added to a data-only layer while mounted will not appear in
   the overlayfs via readdir or lookup, but it is safe for applications
   to attempt to do so.
 * A subsequently mounted overlayfs that includes redirects to the added
   files will be able to iterate and open the added files.

Signed-off-by: Mike Baynton <mike@mbaynton.com>
---
Looks like somewhere wrapping got added despite my best efforts with the
patch on my last email. Sending patch on its own as well in case someone
wants to actually apply/run it.

 tests/overlay/087     | 170 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/087.out |  13 ++++
 2 files changed, 183 insertions(+)
 create mode 100755 tests/overlay/087
 create mode 100644 tests/overlay/087.out

diff --git a/tests/overlay/087 b/tests/overlay/087
new file mode 100755
index 00000000..100bb213
--- /dev/null
+++ b/tests/overlay/087
@@ -0,0 +1,170 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc. All Rights Reserved.
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+# Copyright (C) 2024 Mike Baynton. All Rights Reserved.
+#
+# FS QA Test 087
+#
+# Tests limited defined behaviors in case of additions to data-only layers
+# while participating in a mounted overlayfs.
+#
+. ./common/preamble
+_begin_fstest auto quick metacopy redirect
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs overlay
+# We use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
+_require_scratch_overlay_features redirect_dir metacopy
+_require_scratch_overlay_lowerdata_layers
+_require_xfs_io_command "falloc"
+
+# remove all files from previous tests
+_scratch_mkfs
+
+# File size on lower
+dataname="d1/datafile"
+datacontent="data"
+dataname2="d2/datafile2"
+datacontent2="data2"
+datasize="4096"
+
+# Check size
+check_file_size()
+{
+	local target=$1 expected_size=$2 actual_size
+
+	actual_size=$(_get_filesize $target)
+
+	[ "$actual_size" == "$expected_size" ] || echo "Expected file size $expected_size but actual size is $actual_size"
+}
+
+check_file_contents()
+{
+	local target=$1 expected="$2"
+	local actual target_f
+
+	target_f=`echo $target | _filter_scratch`
+
+	read actual<"$target"
+
+	[ "$actual" == "$expected" ] || echo "Expected file $target_f contents to be \"$expected\" but actual contents are \"$actual\""
+}
+
+check_file_size_contents()
+{
+	local target=$1 expected_size=$2 expected_content="$3"
+
+	check_file_size $target $expected_size
+	check_file_contents $target "$expected_content"
+}
+
+create_basic_files()
+{
+	_scratch_mkfs
+	# create a few different directories on the data layer
+	mkdir -p "$datadir/d1" "$datadir/d2" "$lowerdir" "$upperdir" "$workdir"
+	echo "$datacontent" > $datadir/$dataname
+	chmod 600 $datadir/$dataname
+	echo "$datacontent2" > $datadir/$dataname2
+	chmod 600 $datadir/$dataname2
+
+	# Create files of size datasize.
+	for f in $datadir/$dataname $datadir/$dataname2; do
+		$XFS_IO_PROG -c "falloc 0 $datasize" $f
+		$XFS_IO_PROG -c "fsync" $f
+	done
+}
+
+mount_overlay()
+{
+	_overlay_scratch_mount_opts \
+		-o"lowerdir=$lowerdir::$datadir" \
+		-o"upperdir=$upperdir,workdir=$workdir" \
+		-o redirect_dir=on,metacopy=on
+}
+
+umount_overlay()
+{
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+prepare_midlayer()
+{
+	_scratch_mkfs
+	create_basic_files
+	# Create midlayer
+	_overlay_scratch_mount_dirs $datadir $lowerdir $workdir -o redirect_dir=on,index=on,metacopy=on
+	# Trigger metacopy and redirect xattrs
+	mv "$SCRATCH_MNT/$dataname" "$SCRATCH_MNT/file1"
+	mv "$SCRATCH_MNT/$dataname2" "$SCRATCH_MNT/file2"
+	umount_overlay
+}
+
+# Create test directories
+datadir=$OVL_BASE_SCRATCH_MNT/data
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+
+echo -e "\n== Create overlayfs and access files in data layer =="
+#set -x
+prepare_midlayer
+mount_overlay
+
+# This creates a lookup under $datadir/d1, the directory later appended
+check_file_size_contents "$SCRATCH_MNT/file1" $datasize $datacontent
+# iterate some dirs through the overlayfs to populate caches
+ls $SCRATCH_MNT > /dev/null
+ls $SCRATCH_MNT/d1 > /dev/null
+
+echo -e "\n== Add new files to data layer, online and offline =="
+
+f="$OVL_BASE_SCRATCH_MNT/birthing_file"
+echo "new file 1" > $f
+chmod 600 $f
+$XFS_IO_PROG -c "falloc 0 $datasize" $f
+$XFS_IO_PROG -c "fsync" $f
+# rename completed file under mounted ovl's data dir
+mv $f $datadir/d1/newfile1
+
+newfile1="$SCRATCH_MNT/d1/newfile1"
+newfile2="$SCRATCH_MNT/d1/newfile2"
+# Try to open some files that will exist in future
+read <"$newfile1" 2>/dev/null || echo "newfile1 expected missing"
+read <"$newfile2" 2>/dev/null || echo "newfile2 expected missing"
+
+umount_overlay
+
+echo "new file 2" > "$datadir/d1/newfile2"
+chmod 600 "$datadir/d1/newfile2"
+$XFS_IO_PROG -c "falloc 0 $datasize" "$datadir/d1/newfile2"
+$XFS_IO_PROG -c "fsync" "$datadir/d1/newfile2"
+
+# Add new files to midlayer with redirects to the files we appended to the lower dir
+_overlay_scratch_mount_dirs $datadir $lowerdir $workdir -o redirect_dir=on,index=on,metacopy=on
+mv "$newfile1" "$SCRATCH_MNT/_newfile1"
+mv "$newfile2" "$SCRATCH_MNT/_newfile2"
+umount_overlay
+mv "$lowerdir/_newfile1" "$lowerdir/d1/newfile1"
+mv "$lowerdir/_newfile2" "$lowerdir/d1/newfile2"
+
+echo -e "\n== Verify files appended to data layer while mounted are available after remount =="
+mount_overlay
+
+ls "$SCRATCH_MNT/d1"
+check_file_size_contents "$newfile1" $datasize "new file 1"
+check_file_size_contents "$newfile2" $datasize "new file 2"
+check_file_size_contents "$SCRATCH_MNT/file1" $datasize $datacontent
+
+umount_overlay
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/087.out b/tests/overlay/087.out
new file mode 100644
index 00000000..db16c8a2
--- /dev/null
+++ b/tests/overlay/087.out
@@ -0,0 +1,13 @@
+QA output created by 087
+
+== Create overlayfs and access files in data layer ==
+
+== Add new files to data layer, online and offline ==
+/root/projects/xfstests-dev/tests/overlay/087: line 138: /mnt/scratch/ovl-mnt/d1/newfile1: No such file or directory
+newfile1 expected missing
+/root/projects/xfstests-dev/tests/overlay/087: line 139: /mnt/scratch/ovl-mnt/d1/newfile2: No such file or directory
+newfile2 expected missing
+
+== Verify files appended to data layer while mounted are available after remount ==
+newfile1
+newfile2
-- 
2.43.0

