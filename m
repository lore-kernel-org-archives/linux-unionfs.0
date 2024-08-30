Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF95B1B81B3;
	Fri, 30 Aug 2024 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725041332; cv=none; b=k1UvtHi0h0oRvhJHKyeFkVNK1KWaDWuWo/Dqw1HPom5GwpenypIGWKiLg9JBoAdDb34MuEbaMNWE5ZwOj+TXog/a8JcdLQf3noERirLMoRP4IvZu+qutG52R6tikoK62R/rSOOLrPy4HaGt6tyYa3/XAbAKa6FvhXz52yIEZ+kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725041332; c=relaxed/simple;
	bh=+rLY0lJ1ZfcqY4Ro97t0A5mnRsWEn40RojmArtENPaI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=goiwE3urRdLJzmYFdjKu6WE6Y+tS8R3seja87iM237hqoGrgGQIc3L76mZ6eCNZ95FJRkfa60NC9eYCO5bBv2LTeU6UuV/z5ZcHYlYrDGRwkbdm1h2H6LCLj8oHS7NlwJYapwVldlSOhbC8nkOvKbKwVqTbhr0Y2EbpMT9UYZK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSEsK7gc; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSEsK7gc"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37196681d3bso1365751f8f.3;
        Fri, 30 Aug 2024 11:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725041329; x=1725646129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=279diSxyieZJXgY4RiZErWjkHxjDWeRkNnGGtbkFDtw=;
        b=YSEsK7gcOP9+Km2PdwWCpAL7czXrD14VFBRPVgOPomFocrzPLCSowaslNH7EcIP3QM
         pFdpScvnx801uqN64me5jneJ84w0ALnAqyxiSG777Cb3WFgWJegxSJBoG6DPpm8OZjrU
         q0ZdwFdmQuJJcaYw+SybjAnmRiQLCRPiB43gtN2XrXG7Py53qtJATe/HUMNC2lwRzFer
         JGLMb5B1MP7MnYBWBAWiQPpmd8XIcs4gTsWvsp0UTrO7YAyD7bvBd9p1XufTL1Eyqcqi
         U+4mDxepAxswuHfGCvQo6JEAhiUa+O6qwbgeVFLWWNS2GpHymh7wYFmVXjHyKAY5zhjp
         C29A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725041329; x=1725646129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=279diSxyieZJXgY4RiZErWjkHxjDWeRkNnGGtbkFDtw=;
        b=An6ACafnKCfvQfyMVIZaiXB6h/sTyDv3awrod8583K8WGtfvMZV7I1Nkxpcgs/YXxe
         C7zd8CuXJOK0N3yuvU7KqdPKt+x2G8Khcq1/hxk/olkkerI2uDzdpJ6bVaQKJ/F5bFaS
         JUAZP5B/7I25V9vbSluMWxfCgiToc5TtfF741OCt4KDNPy4MmXf03sI3EFSj2mkT+UHd
         hOYZ3xLLfExJiCtw9k2V2sf1R/nXJc6IF/4LK62X1irjeimG3yLXDPYGBqRG2DnuVRUL
         9c/4YaGF+sKXVRoXY+ia53oQG3D4eEnViPuo3vdwt+olf5e+6uGclOfgK+oghkQtaCXT
         +zcA==
X-Forwarded-Encrypted: i=1; AJvYcCWiZdU8JUjW3PAuQU0mNrR+9EXhbBO1Eng7Kj5IHQHdHctlZ51ckCbo6y2OrUlQZaJqkoatlq6qQmgpJOkezQ==@vger.kernel.org, AJvYcCXQbMSHR0mqZR4J3B4SLP8CAjXPSdHgcz/f0t8O1RpGDaWUkaydSxSny4u9thVh+TY69YS2zhts@vger.kernel.org
X-Gm-Message-State: AOJu0YzLT0m4wWoZO7lWDWwk0kuJze51jOsND/NENJeqMnj3T+UUKBBS
	nNN8/lOXAtm+NhHgChO3lNgKZq/vxThFoVvRISQafMjPWZsHyuxzX5oPOFX8
X-Google-Smtp-Source: AGHT+IF11/0SceAfwEjAFpUORjvt6kYsG60n2BWDgRXPHTIMeDeO9CUmQJbmpufgm93ymah5pYdmNA==
X-Received: by 2002:a05:6000:1092:b0:368:3789:1a2 with SMTP id ffacd0b85a97d-3749b5448d0mr4816854f8f.21.1725041328294;
        Fri, 30 Aug 2024 11:08:48 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee4981asm4653674f8f.24.2024.08.30.11.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 11:08:47 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] overlay: create a variant to syncfs error test xfs/546
Date: Fri, 30 Aug 2024 20:08:44 +0200
Message-Id: <20240830180844.857283-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test overlayfs over xfs with and without "volatile" mount option.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zorro,

I was going to make a generic test from xfs/546, so that overlayfs could
also run it, but then I realized that ext4 does not behave as xfs in
that case (it returns success on syncfs post shutdown).

Unless and until this behavior is made a standard, I made an overlayfs
specialized test instead, which checks for underlying fs xfs.
While at it, I also added test coverage for the "volatile" mount options
that is expected to return succuss in that case regardles of the
behavior of the underlying fs.

Thanks,
Amir.

 tests/overlay/087     | 62 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/087.out |  4 +++
 2 files changed, 66 insertions(+)
 create mode 100755 tests/overlay/087
 create mode 100644 tests/overlay/087.out

diff --git a/tests/overlay/087 b/tests/overlay/087
new file mode 100755
index 00000000..a5afb0d5
--- /dev/null
+++ b/tests/overlay/087
@@ -0,0 +1,62 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+# Copyright (c) 2024 CTERA Networks.  All Rights Reserved.
+#
+# FS QA Test No. 087
+#
+# This is a variant of test xfs/546 for overlayfs
+# with and without the "volatile" mount option.
+# It only works over xfs underlying fs.
+#
+# Regression test for kernel commits:
+#
+# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
+# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
+#
+# During a code inspection, I noticed that sync_filesystem ignores the return
+# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
+# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
+# that syncfs(2) does not capture internal filesystem errors that are neither
+# visible from the block device (e.g. media error) nor recorded in s_wb_err.
+# XFS historically returned 0 from ->sync_fs even if there were log failures,
+# so that had to be corrected as well.
+#
+# The kernel commits above fix this problem, so this test tries to trigger the
+# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
+# hope that the EIO generated as a result of the filesystem being shut down is
+# only visible via ->sync_fs.
+#
+. ./common/preamble
+_begin_fstest auto quick mount shutdown
+
+
+# Modify as appropriate.
+_require_xfs_io_command syncfs
+_require_scratch_nocheck
+_require_scratch_shutdown
+
+[ "$OVL_BASE_FSTYP" == "xfs" ] || \
+	_notrun "base fs $OVL_BASE_FSTYP has unknown behavior with syncfs after shutdown"
+
+# Reuse the fs formatted when we checked for the shutdown ioctl, and don't
+# bother checking the filesystem afterwards since we never wrote anything.
+echo "=== syncfs after shutdown"
+_scratch_mount
+# This command is complicated a bit because in the case of overlayfs the
+# syncfs fd needs to be opened before shutdown and it is different from the
+# shutdown fd, so we cannot use the _scratch_shutdown() helper.
+# Filter out xfs_io output of active fds.
+$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
+	grep -vF '[00'
+
+# Now repeat the same test with a volatile overlayfs mount and expect no error
+_scratch_unmount
+echo "=== syncfs after shutdown (volatile)"
+_scratch_mount -o volatile
+$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
+	grep -vF '[00'
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/087.out b/tests/overlay/087.out
new file mode 100644
index 00000000..44b538d8
--- /dev/null
+++ b/tests/overlay/087.out
@@ -0,0 +1,4 @@
+QA output created by 087
+=== syncfs after shutdown
+syncfs: Input/output error
+=== syncfs after shutdown (volatile)
-- 
2.34.1

