Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794455896;
	b=oKhz7cfL8MH0aDiwmDqBw7XVRpI3E0I/w8aqz/cMyn5THn9OeYC78cPcgGy3uWzRQLhB
	 OUlwIDc4m0/X9SnHhts34aqJaiHZvvq6Q5PBRD9lZhw9kSGNqXOFtko2br/Nb4pKMfyVP
	 JEOX505Elw35+Atl7EDWqpQ/+/52xkBAN3Y/jgGoer5WdnMGLeYpTy+ElXT/eEjGcKP1i
	 BB+6mML5KkfYtlnZBJqDlm+crgYLKdU88ykjO+hIgC5mfuJFWionlQO2nBD1CnG6BP2C5
	 7X2ex3CQnp6RFPqx70IJ+s4bugJAOTu0oyg1Xn5lx6Ve7gYdCHDpyewxKeiFf1y/hUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794455896;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iwx45yD8rGo5BwjYbGiHDAeVNtOmwXFoNQbOJBRIlfA=;
	b=OvUH1e+3R1FJ4zAgRnGDblrrN/29B+U4Me/aQKCqKxvIxdD0axvU5zGjdM9A+SAwTMv1
	 hcYsFW975mCy4n4R9fA5qPUTwcDnHioOckc63qe1Mh1QyYThIWTjtF9E3zGVZTvGAkvFW
	 +UewEMP3HCjJKe+1QsmcMEDL16Jr9jUB2hkVPqJwVavnjVZyT/L9S2JwEVuIsHUiHHg9j
	 IpF/8flEqrRZgpcIKnPPKX0l881P3YG40kWEiyuo9sXIhGCVFzTlm1Eoh6UCS5IeO63xx
	 dnoIFVULXf7ThpTtPNO9IA1wVaLwHJSY9y9FcXwwcgYm7LPDuUVOvDJr62hWN+NuKcQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l3VCj916;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15B9606A321;
	Thu, 12 Nov 2026 03:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l3VCj916
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794455896;
	b=Kzljv41kh+lyWSgmTg1AbrJNzb7T6L1CzmgV2gHaGva+6yIY0iPHvhnn7PsqNya391t+
	 EUWi8ftzi+MRteXjPBnYj6ps7BLLhceetqpaWkwy0agmqYRQR2xH3+Ju/niS6ut7CkqQF
	 3CN6QX8OykzKx7mbMg9IKun4xt748XGzABD8VNMwxqjyFK5qMwUCz0nHr4mslB9drAeH1
	 cRLPEw0xIvl6jvJg3PWmV8AwNc8eD6BgWJ8awjEXOwHYNLthOiq5xAKNg6PU7MmfTlQCj
	 An5qQWGMNci7XqrrP2Qx3P4Hgvwsmt5Ee5LAj7LTjzv0FeFArrcPrNVMNSGFXiRmLYQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794455896;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=iwx45yD8rGo5BwjYbGiHDAeVNtOmwXFoNQbOJBRIlfA=;
	b=pVstdYuuVJxjmNxxQW3ojeMVqwNHvAhx1aA0C1CKaC4rBKyL5c2QlXSo2gfox6JzYJac
	 Tl6Ra55PPluo3rjDfNlt7RfOqUSWYH+HIdeAAsW25wkMRuZyxiYq1L7ejFP6V2oq5QPG8
	 nrCtQZDRuxOeiXnuaqGsubIxBm46a/xlPwlndYM3kBKRHCmNZbdjFzCuYOsAxXaGCC6VX
	 Gth8tqzo2Zgf2+dE3Tf9EK802SRTg3GDktpDymNV0epms/sx5nteY6KRaHQOKjZ1lkSsN
	 HVv9U0X3Yr3k6iOAi7aJMUN9hGKsqCbwFNq4FV7MR+zoIXsUJFzVjFTflyQt2R7LUNQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E0CF81F00A05;
	Thu, 12 Nov 2026 03:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794455896;
	bh=iwx45yD8rGo5BwjYbGiHDAeVNtOmwXFoNQbOJBRIlfA=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=l3VCj916jDlP1w+N6iqECx9R6TzxBxz6ViDMFsVb5n1Y/Ifh+lzae8DlGE5IUfm0A
	 pbqSbbRP/EbR0sX/sOfENFXVqPQ2+KNLKY+nid83JNaLudb96OAryEhZnfko82QoN+
	 Rx38kfqapf4TlP1Cz2Rp3SnSEG+e9MvffJ30QmMset8S3X03VQSJT0EI5tNt1VJ8PO
	 ka9RsOzzY/ux+ZgTiFuJ0o71Pm9/P59mbvjpPzC+3BmLmAnXyQA2CAl2dcs7W/2yaq
	 ySePvwdYyEQHbP1AA82XQdfJYKKcIbgcSR1woy4rnqsaDzK8QSuLoBnQj0YWEp7ljL
	 9PhVLulN/EG1w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 73F3949261;
	Thu, 12 Nov 2026 03:58:15 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 12 Nov 2026 12:58:15 +0900
Subject: [PATCH] overlay: test d_ino of hard links in an impure dir
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261112-ovl013-hlink-v1-1-4bf8f44050e9@samsung.com>
X-B4-Tracking: v=1; b=H4sIAFY59WoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQ0Mj3fyyHANDY92MnMy8bF3z5DRzk0Rzc9MUI2MloJaCotS0zAqwcdG
 xtbUAmgg6GV4AAAA=
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794455894; l=3144;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=plEjgCid8fULCglbzGD9W9G0YpAuKpPG535Rx0K4cHg=;
 b=BNtS5aXvEsUM7uuXY9t2ozHIW284VzT+V96eupm58pb/Xld0SobXUpDoOExFLiP5k6uCqw6A3
 jT4lelpus3/B0oV9drObKKupqWxN2Oms6zXJTaEfPDrp63VeadfyZRi
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

Linking a file with copy up origin into a non-merge impure dir does
not bump the dir version. readdir then reuses the impure dir cache
built before the link. The new link is not in that cache. readdir
reports its upper inode number as d_ino instead of st_ino.

The test builds the cache, then links two files with origin into the
dir: one from the dir itself and one from the overlay root. It checks
that readdir finds each new link by its st_ino.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
On the overlayfs ovl-fixes branch (0d5e729c515f) with default overlay
mount options, the test fails in 3 of 3 runs on ext4 and on xfs. With
the kernel patch "ovl: bump the impure dir version when linking a file
with origin", it passes in 3 of 3 runs on each.
---
 tests/overlay/013     | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/013.out |  2 ++
 2 files changed, 60 insertions(+)

diff --git a/tests/overlay/013 b/tests/overlay/013
new file mode 100755
index 00000000..bc65076c
--- /dev/null
+++ b/tests/overlay/013
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Samsung Electronics. All Rights Reserved.
+#
+# FS QA Test 013
+#
+# Test consistent d_ino of hard links in an impure dir.
+#
+# Overlayfs caches the d_ino of the entries with a copy up origin in a
+# non-merge impure dir. Linking a file with copy up origin into the dir
+# must invalidate that cache, so that readdir reports the new link with
+# the same inode number as stat.
+#
+. ./common/preamble
+_begin_fstest auto quick copyup hardlink
+
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"ovl: bump the impure dir version when linking a file with origin"
+
+_require_scratch
+_require_test_program "t_dir_type"
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $lowerdir
+touch $lowerdir/foo $lowerdir/bar
+
+_scratch_mount
+
+impure_dir=$SCRATCH_MNT/impure_dir
+mkdir $impure_dir
+
+# Expect readdir of $impure_dir to find <name> by the st_ino of <name>
+check_d_ino()
+{
+	local name=$1
+	local ino=$(stat -c '%i' $impure_dir/$name)
+
+	$here/src/t_dir_type $impure_dir $ino | grep -q "^$name f$" || \
+		echo "readdir d_ino of $name does not match st_ino $ino"
+}
+
+# Copy up foo and link it into the pure upper dir, which makes the dir
+# impure. Then read the dir, so its impure entries get cached.
+ln $SCRATCH_MNT/foo $impure_dir/foo
+check_d_ino foo
+
+# Link foo again inside the dir
+ln $impure_dir/foo $impure_dir/foo_link
+check_d_ino foo_link
+
+# Copy up bar and link it into the dir
+ln $SCRATCH_MNT/bar $impure_dir/bar
+check_d_ino bar
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/overlay/013.out b/tests/overlay/013.out
new file mode 100644
index 00000000..3e66423b
--- /dev/null
+++ b/tests/overlay/013.out
@@ -0,0 +1,2 @@
+QA output created by 013
+Silence is golden

---
base-commit: 71641219a506ac62bfa231592394265ca812670e
change-id: 20261112-ovl013-hlink-7cf74a775d23

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


