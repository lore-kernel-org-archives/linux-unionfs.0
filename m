Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVr/0WTB"
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB7B109;
	Mon,  4 Dec 2023 10:59:29 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40c08af319cso19942155e9.2;
        Mon, 04 Dec 2023 10:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701716368; x=1702321168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95nE7bWkcx0d4JSLcoybDbaWzT7WMYnwMt3WPJsD1uM=;
        b=FVr/0WTBd6f7+4ONP+2vrgcE3/Y6/0tArLzIPa4o6Cf2hT6aJkpYfDwWy/lLAm/h0Z
         ndIOQQv5sOJnhNcwcYKPJuKu5+/p0ixbM3J8uMZ3u8KyOC8PdPyArt1JAiLODhJFXAYl
         7oggLqr+RIyo146GQ7K1qIsz2l0UT0LvxhDq/nL5/nlltPIr64smwmRVCJn7Eop+eM5P
         eRhPlzPTt+VwVp6UU5tK89aNt3I8gLX6zaIR7I/HIMizL92DBpgULnk58InS5KhETs31
         sbWOizE1fmmLC7yVRx4Fw3vVkMvuRUD+W5MGtv5ZmTiD0Im5qaIj4s7QooiZUGTmU9Sy
         flRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701716368; x=1702321168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=95nE7bWkcx0d4JSLcoybDbaWzT7WMYnwMt3WPJsD1uM=;
        b=KVzm3Huj6Prf+eCwKLHUFeE/AHIFk8g8nJkvrod6glmnH8i9pfgaaEEfO6xZZ8nYRv
         x18+sY/npXm6MProxHMWPy+XOeal1to6+xxXLGt0IZQIUGKYWQdlzrZ/HuS1Eqi/TsAy
         s2hAgQe9225ThasL5Lkx1UHzHCY7+vTiROus7TebtxMEwuwZLYpal+Jr+RG7K2zCUouo
         bPjxaLc3akO8hhlsgS4cLX4moA0zqCqUrhyvc6227AtTwF+d5lZ9+INvi/B/URxL8Xk1
         OUejqI2HuoRcvMlKTKUrMZuxoMjoA7pW+nl72CZ9OsjaXeHapt2jsUpfHDSpTkLvu7Ex
         /fjg==
X-Gm-Message-State: AOJu0YzijBFpZhJkDoIcr/kwHMP2ZJPPrRHeHYAEgpok110veLHp2o6y
	a53PRjks88n1jLkh5V9d3s8=
X-Google-Smtp-Source: AGHT+IERtCltiMk+BWmPRnzxtKIiVOYw+aDdnlgo5m+hzvmVMN7qJp6uwhT49UTtcNqQY5wv3RVFIg==
X-Received: by 2002:a05:600c:1e26:b0:40b:5e21:ec34 with SMTP id ay38-20020a05600c1e2600b0040b5e21ec34mr2997088wmb.102.1701716367750;
        Mon, 04 Dec 2023 10:59:27 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id d9-20020a05600c34c900b0040b2c195523sm20008098wmq.31.2023.12.04.10.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 10:59:27 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2 4/4] overlay: test parsing of lowerdir+,datadir+ mount options
Date: Mon,  4 Dec 2023 20:58:59 +0200
Message-Id: <20231204185859.3731975-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231204185859.3731975-1-amir73il@gmail.com>
References: <20231204185859.3731975-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fork test overlay/083 to test parsing of lowerdir+,datadir+ mount options.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/086     | 81 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/086.out |  2 ++
 2 files changed, 83 insertions(+)
 create mode 100755 tests/overlay/086
 create mode 100644 tests/overlay/086.out

diff --git a/tests/overlay/086 b/tests/overlay/086
new file mode 100755
index 00000000..b5960517
--- /dev/null
+++ b/tests/overlay/086
@@ -0,0 +1,81 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 086
+#
+# Test lowerdir+,datadir+ mount option restrictions.
+#
+
+. ./common/preamble
+_begin_fstest auto quick mount
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs overlay
+
+# _overlay_check_* helpers do not handle special chars well
+_require_scratch_nocheck
+_require_scratch_overlay_lowerdir_add_layers
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create lowerdirs with special characters
+lowerdir_spaces="$OVL_BASE_SCRATCH_MNT/lower1 with  spaces"
+lowerdir_colons="$OVL_BASE_SCRATCH_MNT/lower2:with::colons"
+lowerdir_colons_esc="$OVL_BASE_SCRATCH_MNT/lower2\:with\:\:colons"
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+mkdir -p "$lowerdir_spaces" "$lowerdir_colons"
+
+# _overlay_mount_* helpers do not handle lowerdir+,datadir+, so execute mount directly.
+
+# check illegal combinations and order of lowerdir,lowerdir+,datadir+
+$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+	-o"lowerdir=$lowerdir,lowerdir+=$lowerdir_colons" \
+	2>> $seqres.full && \
+	echo "ERROR: invalid combination of lowerdir and lowerdir+ mount options"
+
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+	-o"lowerdir=$lowerdir,datadir+=$lowerdir_colons" \
+	-o redirect_dir=follow,metacopy=on 2>> $seqres.full && \
+	echo "ERROR: invalid combination of lowerdir and datadir+ mount options"
+
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+	-o"datadir+=$lowerdir,lowerdir+=$lowerdir_colons" \
+	-o redirect_dir=follow,metacopy=on 2>> $seqres.full && \
+	echo "ERROR: invalid order of lowerdir+ and datadir+ mount options"
+
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+# mount is expected to fail with escaped colons.
+$MOUNT_PROG -t overlay none $SCRATCH_MNT \
+	-o"lowerdir+=$lowerdir_colons_esc" \
+	2>> $seqres.full && \
+	echo "ERROR: incorrect parsing of escaped colons in lowerdir+ mount option"
+
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+# mount is expected to succeed without escaped colons.
+$MOUNT_PROG -t overlay ovl_esc_test $SCRATCH_MNT \
+	-o"lowerdir+=$lowerdir_colons,datadir+=$lowerdir_spaces" \
+	-o redirect_dir=follow,metacopy=on \
+	2>&1 | tee -a $seqres.full
+
+# if spaces are not escaped when showing mount options,
+# mount command will not show the word 'spaces' after the spaces
+$MOUNT_PROG -t overlay | grep ovl_esc_test | tee -a $seqres.full | \
+	grep -q 'datadir+'.*spaces || \
+	echo "ERROR: escaped spaces truncated from datadir+ mount option"
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/086.out b/tests/overlay/086.out
new file mode 100644
index 00000000..b34758fd
--- /dev/null
+++ b/tests/overlay/086.out
@@ -0,0 +1,2 @@
+QA output created by 086
+Silence is golden
-- 
2.34.1

