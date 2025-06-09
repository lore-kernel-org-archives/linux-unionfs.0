Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094DE80B;
	Mon,  9 Jun 2025 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749482364; cv=none; b=lr3H3JTUQushsKvf7g6vQ2R1KO62t2+FO1whUYvkGQuuKKaa7VhCZl0IanjPom/TGWzPBjl16seADSlcqA0j8kmYZat/q+EFm59h6MGMNaupDh3QC6qIA+WUDkpOGXINy6nTd4MfG5IJGsGaZsHJdo+3LdyXP31FW/KUynP7eI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749482364; c=relaxed/simple;
	bh=i+vtMNZJZ9jhIo6JSsJPCn+K8o2MLKATiwjDT44Goec=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k6VpCHadH3Tpya8tV2flOEeKeDbmF86BP6KONUqjOMhqVgiW9Y/+NILBfcY0hi05EtlybFPQjZt58mG0dCyliL76erV38A+FXNQCZX0o6VHRXvxa/xvIJnkg387RMT8dpxtHpMyIB/L39or2vdoIrUmuULpzs88Hvqrd6JFDMK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aS7EfPlP; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aS7EfPlP"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cfe63c592so51481305e9.2;
        Mon, 09 Jun 2025 08:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749482361; x=1750087161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MPBkjw3danYqUCq5kIp84dcBTfUE3lboh5mJGBq0wXE=;
        b=aS7EfPlPMu0h7qCur571bAvD1yrSDXglkPRcfhti909hREAeZvnUHutvwQhVes1jjz
         SSYREb0Zv5NkA9OsJW3ODUC7W60eRB+u/0sjNlXpFJ4glt9uL1AHFy4karPsYolBWndB
         ip3vkIUlq5aG+zDJ5iZ210OcaKSIfkkChF3mh18TnoFxteUXJ9WVT3HqHv8fyd5jUV0F
         SkS5L/w5g5y+itWZPX5J/N/PJ/gMO4vM6Dy/JLx/pJtdbFPCh2AYVRLdFigEIWNG4foy
         TSffpmG9aHzvb5YomgpamYTVB1j6xAgofH01MJeaYmOjapY55g19lyN9G+uDkBdIhu16
         ZRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749482361; x=1750087161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MPBkjw3danYqUCq5kIp84dcBTfUE3lboh5mJGBq0wXE=;
        b=QuVB3PPdfoZ7JgiuoGdWQ5qmovNgHUP4I6mnVTVRESFNrOE83rv5fJsh2U+fk+2zT5
         Y33s6E5q6xV/1uK4/uQmVU1QpWj85y6h8hiu/CaL8ilf6WXTVtospk2o/q+5F6M6bPcR
         MyBPXHWXDnADoZGguTebLNB0fhu8W1wlaztorpT/RL4fmH/lr8X3Kd9cYd3p7WbywxsA
         dgIR1G5x38L0EcYbtSYh94zgRIWl7cuKuTBoeZg36mHwA9p0SlNPeH1YpQIgW1xocOvQ
         WpXUbfsMVYidR9sVSTsc0UEXkollqgVZ2T7kv62ZTe4tmI2ANIQYy1F0Hap7YM0I8YCL
         YFIg==
X-Forwarded-Encrypted: i=1; AJvYcCVHMKU0rKlUE7l4VvdK+Su/oW08Vd1SD3/hNASQG4xwFPZkKGu0H4aS9dkz6IXvaIHdEQ17UpEn@vger.kernel.org, AJvYcCVhEsqiwtZdpIcoyrQLBAiRBk6bzpOl9AIJAC4oD/F7yk4q9J29HL8aL9vA9/GVEw/4l6Hyr3JFmRyzYjZN/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywhky28TSzii7qBAkgxZ5Ag/BL3wjVbqyAN12X5pFr/v1FRnTrR
	MTESkbcaUBG7wjMA4HxTR2ODATDsszwHSWoYM9BTjrxYOqxC7QVSHqTCF/kRkaHo
X-Gm-Gg: ASbGncuOt1UiEz9VzWc8EQXwZFt+5g5oXSbwoE2gbAWMVn12unaUx9qRRWa9/BAV3Nq
	eMSnFj4nFYl2M164ETa5DxM+rXUAjFgG3ieKoVHFIM4WD19NVoxyDNKSljq1VAkzFkOemAMNcWL
	tIqMcTobXM1u9CA/FjCaOBjjs+UqQ1L7cxlGIpKLuVGnActqWmb/ZNjY4msetu3dnd1bhPFkvna
	BlgtC22Ln406/O5uCJxf3RQEMMnxo2jKdMrhhdhzRwnsIYOFZvLoSFRLbBJ8JXeP8tuGHrcYf+c
	DM/N6n9of+xAuaNvu177BC95OzNf4qEpMwKOnBF18UU2LAQvo0s9grm+3pXCZeYv4mO0YriWzr/
	JBeXReNrDSqgqAtdFAV+GEjeQfpuiixf65iAo9DtHY/pgtX7K
X-Google-Smtp-Source: AGHT+IEhn6YWxMJP+JijoRJKBciNFg/z9sCb3Iq1sUx8BAG9fAU3OmWcgDA/bPOek/SPf/NJrBkssQ==
X-Received: by 2002:a05:600c:54e6:b0:440:6a1a:d89f with SMTP id 5b1f17b1804b1-452015feff0mr86834565e9.4.1749482360722;
        Mon, 09 Jun 2025 08:19:20 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a532461211sm9622278f8f.86.2025.06.09.08.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 08:19:20 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 1/3] fstests: add helper _scratch_shutdown_and_syncfs
Date: Mon,  9 Jun 2025 17:19:13 +0200
Message-Id: <20250609151915.2638057-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250609151915.2638057-1-amir73il@gmail.com>
References: <20250609151915.2638057-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test xfs/546 has to chain syncfs after shutdown and cannot
use the _scratch_shitdown helper, because after shutdown a fd
cannot be opened to execute syncfs on.

The xfs_io command of chaining syncfs after shutdown is rather
more complex to execute in the derived overlayfs test overlay/087.

Add a helper to abstract this complexity from test writers.
Add a _require statement to match.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc         | 27 +++++++++++++++++++++++++++
 tests/overlay/087 | 13 +++----------
 tests/xfs/546     |  5 ++---
 3 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/common/rc b/common/rc
index f71cc8f0..d9a8b52e 100644
--- a/common/rc
+++ b/common/rc
@@ -595,6 +595,27 @@ _scratch_shutdown_handle()
 	fi
 }
 
+_scratch_shutdown_and_syncfs()
+{
+	if [ $FSTYP = "overlay" ]; then
+		# In lagacy overlay usage, it may specify directory as
+		# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
+		# will be null, so check OVL_BASE_SCRATCH_DEV before
+		# running shutdown to avoid shutting down base fs accidently.
+		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
+			_fail "_scratch_shutdown: call _require_scratch_shutdown first in test"
+		fi
+		# This command is complicated a bit because in the case of overlayfs the
+		# syncfs fd needs to be opened before shutdown and it is different from the
+		# shutdown fd, so we cannot use the _scratch_shutdown() helper.
+		# Filter out xfs_io output of active fds.
+		$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' \
+				-c close -c syncfs $SCRATCH_MNT | grep -vF '[00'
+	else
+		$XFS_IO_PROG -x -c 'shutdown -f ' -c syncfs $SCRATCH_MNT
+	fi
+}
+
 _move_mount()
 {
 	local mnt=$1
@@ -4102,6 +4123,12 @@ _require_scratch_shutdown()
 	_scratch_unmount
 }
 
+_require_scratch_shutdown_and_syncfs()
+{
+	_require_xfs_io_command syncfs
+	_require_scratch_shutdown
+}
+
 _check_s_dax()
 {
 	local target=$1
diff --git a/tests/overlay/087 b/tests/overlay/087
index a5afb0d5..2ad069db 100755
--- a/tests/overlay/087
+++ b/tests/overlay/087
@@ -32,9 +32,8 @@ _begin_fstest auto quick mount shutdown
 
 
 # Modify as appropriate.
-_require_xfs_io_command syncfs
 _require_scratch_nocheck
-_require_scratch_shutdown
+_require_scratch_shutdown_and_syncfs
 
 [ "$OVL_BASE_FSTYP" == "xfs" ] || \
 	_notrun "base fs $OVL_BASE_FSTYP has unknown behavior with syncfs after shutdown"
@@ -43,19 +42,13 @@ _require_scratch_shutdown
 # bother checking the filesystem afterwards since we never wrote anything.
 echo "=== syncfs after shutdown"
 _scratch_mount
-# This command is complicated a bit because in the case of overlayfs the
-# syncfs fd needs to be opened before shutdown and it is different from the
-# shutdown fd, so we cannot use the _scratch_shutdown() helper.
-# Filter out xfs_io output of active fds.
-$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
-	grep -vF '[00'
+_scratch_shutdown_and_syncfs
 
 # Now repeat the same test with a volatile overlayfs mount and expect no error
 _scratch_unmount
 echo "=== syncfs after shutdown (volatile)"
 _scratch_mount -o volatile
-$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
-	grep -vF '[00'
+_scratch_shutdown_and_syncfs
 
 # success, all done
 status=0
diff --git a/tests/xfs/546 b/tests/xfs/546
index 316ffc50..c50d41a6 100755
--- a/tests/xfs/546
+++ b/tests/xfs/546
@@ -27,14 +27,13 @@ _begin_fstest auto quick shutdown
 
 
 # Modify as appropriate.
-_require_xfs_io_command syncfs
 _require_scratch_nocheck
-_require_scratch_shutdown
+_require_scratch_shutdown_and_syncfs
 
 # Reuse the fs formatted when we checked for the shutdown ioctl, and don't
 # bother checking the filesystem afterwards since we never wrote anything.
 _scratch_mount
-$XFS_IO_PROG -x -c 'shutdown -f ' -c syncfs $SCRATCH_MNT
+_scratch_shutdown_and_syncfs
 
 # success, all done
 status=0
-- 
2.34.1

