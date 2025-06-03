Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54B41C3306;
	Tue,  3 Jun 2025 10:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945281; cv=none; b=TusEP312XN6tZLK73JavgCn9Dvv2319VF97HSewqjlNB+nqduzIIWg0AO4yt/z7M5lhGCxMttTom4MfyWlH8aDpc/91q8CEkE0m6/hc500wnxuGBLAqp6WQexdlQd9mXy35A+MjRcEd+hDSL+4UckKce1OkF6tcvUn9Z/WfPXPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945281; c=relaxed/simple;
	bh=BZDVif7tWEMZfDtoQqcnGWWjJhpedwKHIVShEuZm7mA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U4qP1z2AkCpOeicWpyNphiCYjtz4K8QkU9bkLexpPwIaGlJXDKUHYI2jvpsdpEux2fpljt2SPa/3i8VPMhb+LATLMAv9vZQ9Zc31wWtmNza1Eer39NWmk/CchMth7+cZFTltLe37CuMB9T/9R8Y8bveue1vOJAuQQ5eDFtrTca8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mI4hAZ3D; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mI4hAZ3D"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43edecbfb46so39966825e9.0;
        Tue, 03 Jun 2025 03:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748945277; x=1749550077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOI8mmSoylOr0dXUp6w9uz/kB1zeeDhNGn5K7GQLrqM=;
        b=mI4hAZ3DGifRmvmryjVHhEcmldVEFKbWakDuSPz3LQNx1+tGTasU5SvC9j6SThuQNx
         mafClMM5KSuidRzkAaaTv42JTXu4HsZIx0f10S82cuBCUreymBqdZfuLaKGL2RZfNUeM
         HRRD1v/EjjPVat2YdHtaBYSFEjJnrkDz3YvyTtkgpqs1rUr50NqI3rs6wJYfRUYdNMRb
         uABVdd6cvCwNxWecBPIGhPbFWXoaG+fcqLHCPPGhmB5GuClNLA+9PRqenk2yjjcWze3c
         YXyBjjVd+A1DSlhrpmZS4sSaaYhq6yATKEvPcc/EKWFoBtkbwXr00aZ39KUHFuwZD4US
         +eCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748945277; x=1749550077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOI8mmSoylOr0dXUp6w9uz/kB1zeeDhNGn5K7GQLrqM=;
        b=bJTUQY7S5/d8m+oNiIpIG+HFrVNcJkuPsuN5k0OkAp0Ht6Oyb9xePJ2aEOGjZurkWv
         /BDRdcIGn3v6d1jl/9MXRFgHMuECX/jnKVnQ6pO5Eq9MYOMuF9BIc2p0h7sEeEDeSl/U
         mXLlYsxv9asy7wXvEfeBNco3CRk7tVBXiLD5Iwyf048GaZcz4Hta+2bk8DavTQxqdZaZ
         ooVc9tV00p156CpodBq6cZed85hgQZQ6KZl6m43AVgkIG1dkomJunsDlkXEbYFK8QiX8
         7rCIsIDWxoS1atm5Uyivv3ok00Z+mLr5D9u6cLRCkCCX9H8662FlRIDqKQDg+MfMrjes
         itKA==
X-Forwarded-Encrypted: i=1; AJvYcCUplqr3M5PWOS9ry8C/6r9tHETS7NSGkBS5Av24mtEcX1HBKM2Enn3RVpMWwVtRn3JCqnazGaO6YRNNXvvreQ==@vger.kernel.org, AJvYcCXk9P1w/PVmTc/9AQbUoxb/cVyn7nqBqhdjiLY5oT40vLalC2eTJ+QB1VA6cGQ/ZYSvpV4/+GUB@vger.kernel.org
X-Gm-Message-State: AOJu0Ywidp8E1C0nb41eRUA3/CUU2LF4v/g8Kkn/Jiulb/c0C+RUQR7w
	tX/+ARvlQUdY9JNgojbq9b71eZNNH4iBxxQFCmBsBuML0yucNTnoMPAO
X-Gm-Gg: ASbGncsmddxpZfb83yK246q2dcNA90ovP6ZULh6b/AlyGUTISZLAvO43v/zzvCcIKwO
	PGemyg4lFyrPJFPntYkI3IGWHfFsBAy88b6dTbXxLFnJJvXGv04ELq98fJkmJhy8Wk+r0Lbr+lK
	ZHixw8R5jAiuC4gpMBJF55+pg2yWPTJyvsq1P6uOWBhPq0GB5A6bP94QTYuKAhwtckenVoVT9zv
	iJmBDGRAABJSnt2brI7UMP3vzab58ADohRFH1Yws7Ai3I1uPQP1e3N+STEwom/IvqYG0ianINo5
	TPAiIKjPOO2tC3hK33bmeR5pP3Q5Tz+WfuVRF5v1ZsRqlk5zftfY2bJ2/x5cpp4ydEESozVHLO/
	o+qZ1vfWskUswGHb6H/WcL9/KYfbO2TJThEixPKlW/7KanrJp
X-Google-Smtp-Source: AGHT+IFJ1WTZOe9of+G6sYYOWUdesbpnvJMxq4m9aVyQ0jZjQhzm/g5VVRp2CU3tj4a9lbqwuLdP5g==
X-Received: by 2002:a05:600c:46cb:b0:442:d9fb:d9f1 with SMTP id 5b1f17b1804b1-450d882b051mr144726725e9.4.1748945276543;
        Tue, 03 Jun 2025 03:07:56 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fa24c6sm157191525e9.12.2025.06.03.03.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 03:07:56 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Anthony Iliopoulos <ailiop@suse.com>,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH v2 5/6] generic: remove incorrect _require_idmapped_mounts checks
Date: Tue,  3 Jun 2025 12:07:44 +0200
Message-Id: <20250603100745.2022891-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250603100745.2022891-1-amir73il@gmail.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit f5661920 ("generic: add missed _require_idmapped_mounts check")
wrongly adds _require_idmapped_mounts to tests that do not require
idmapped mounts support.

The added _require_idmapped_mounts in test generic/633 goes against
commit d8dee122 ("idmapped-mounts: always run generic vfs tests")
that intentionally removed this requirement from the generic tests.

The added _require_idmapped_mounts in tests generic/69{6,7} causes
those tests not to run with overlayfs, which does not support idmapped
mounts. However, those tests are regression tests to kernel commit
1639a49ccdce ("fs: move S_ISGID stripping into the vfs_*() helpers")
which is documented as also solving a correction issue with overlayfs,
so removing this test converage is very much undesired.

Remove the incorrectly added _require_idmapped_mounts checks.
Also fix the log in _require_idmapped_mounts to say that
"idmapped mounts not support by $FSTYP", which is what the helper
checks instead of "vfstests not support by $FSTYP" which is incorrect.

Cc: Yang Xu <xuyang2018.jy@fujitsu.com>
Cc: Anthony Iliopoulos <ailiop@suse.com>
Cc: David Disseldorp <ddiss@suse.de>
Fixes: commit f5661920 ("generic: add missed _require_idmapped_mounts check")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc         | 2 +-
 tests/generic/633 | 1 -
 tests/generic/696 | 1 -
 tests/generic/697 | 1 -
 4 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/common/rc b/common/rc
index bffd576a..96d65d1c 100644
--- a/common/rc
+++ b/common/rc
@@ -2639,7 +2639,7 @@ _require_idmapped_mounts()
 		--fstype "$FSTYP"
 
 	if [ $? -ne 0 ]; then
-		_notrun "vfstest not support by $FSTYP"
+		_notrun "idmapped mounts not support by $FSTYP"
 	fi
 }
 
diff --git a/tests/generic/633 b/tests/generic/633
index f58dbbf5..b683c427 100755
--- a/tests/generic/633
+++ b/tests/generic/633
@@ -12,7 +12,6 @@ _begin_fstest auto quick atime attr cap idmapped io_uring mount perms rw unlink
 # Import common functions.
 . ./common/filter
 
-_require_idmapped_mounts
 _require_test
 
 echo "Silence is golden"
diff --git a/tests/generic/696 b/tests/generic/696
index d2e86c96..48b3aea0 100755
--- a/tests/generic/696
+++ b/tests/generic/696
@@ -17,7 +17,6 @@ _begin_fstest auto quick cap idmapped mount perms rw unlink
 # Import common functions.
 . ./common/filter
 
-_require_idmapped_mounts
 _require_test
 _require_scratch
 _fixed_by_kernel_commit ac6800e279a2 \
diff --git a/tests/generic/697 b/tests/generic/697
index 1ce673f7..66444a95 100755
--- a/tests/generic/697
+++ b/tests/generic/697
@@ -17,7 +17,6 @@ _begin_fstest auto quick cap acl idmapped mount perms rw unlink
 . ./common/filter
 . ./common/attr
 
-_require_idmapped_mounts
 _require_test
 _require_acls
 _fixed_by_kernel_commit 1639a49ccdce \
-- 
2.34.1

