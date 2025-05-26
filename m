Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278D2202963;
	Mon, 26 May 2025 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748270109; cv=none; b=rzFL7IrL3rfmjzvVyjZwJvj60h6t0znc1q0E9/Dx6joMfUynqBULV4VdeCPvfdK/p6XvBrstO/jgR0aNtaFL/MPALPbtYeaqkTsW7mz1nEGST+EtRoD+cwLIbDQNvMetpbSF+1uwaUC2N70ztO+kLQ6pJtKIiGX4tGDreRf77v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748270109; c=relaxed/simple;
	bh=KRSaRq7VoTXzQ6AUZPRx8aKN7HmVEjKdpP6nXwqvr28=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TP3YglzGMJKUN/hIxNtR2xnsC3ZurMz6PEO15cF2ZsyKHXBDmrSlJm+DUuhYTFNQ+A5qfMCJE6TLTtHrZqrBQDEbn4wyTs7kXanSQCAKQ7rRk/aiKy+27pZCUf7IvSKks/w682+Df1YPhIQysco/iREcoooYEZuEkZrKg67pm1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bBP+G3RI; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bBP+G3RI"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-442f9043f56so15050845e9.0;
        Mon, 26 May 2025 07:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748270105; x=1748874905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvXpA/L6eD5XZI9b+bIYUqcxQBsFds/iGBXYO6awajM=;
        b=bBP+G3RI4jordE4bm+kVsz6O2o/bdSDpfOip8soWbT0dyPnlfPwA/OaVQyxEFueWwi
         6QR5w6WfiD2KyV5QQf0uVe4SqBMmhs1jVaI+ZR2Byhz1ATwWuhx1dwcRy229RdDxp/xv
         EY1mfjYiEACqR8TrI/RKedpEdRjqXdfTRdFXyjQNiaPxVRzVWm0hXmCi/YdiEyAQEXl0
         mBNAgk0cI+FUHhMroYqmrvQxjFnZsLNAc4oZWAPjE9dV8OftoUMZSacfOLbubQ8Xp0KJ
         Q1iWVjh3tptrg6qIOnc2qLJ8xNAb0CD/vgsKw2UO1/S8vLLf/EXgzXS6jLSQcgLxwwdI
         49Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748270105; x=1748874905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bvXpA/L6eD5XZI9b+bIYUqcxQBsFds/iGBXYO6awajM=;
        b=lEX33ZF5HLvlZl8Pfqe/VsmDuXFozHtL0Eqhi+d1LhN9+RPlfuP63qGtPkC62x7CRq
         lM1+gvJJ0AbDzqg638lEERehgYRWrf3XDsh3Qx2TFp/82RYe4iGcM7tP8R3on3WuHuP7
         6X3s/SaqWCzrlmXgPQtbB4eNZocmSPm6Vr9qfDB62pg8eSHGZ2IU/SddOuvVP7lVqVRo
         9vtUoGi4sEoM3D+WAXR4iwWVqq5gYf1vZd3NEdHld/KARJNj4Aa5fUW0NKSSDkXZh0f9
         KOoY3LDSKUCakG8fHTqgMfcWjtAk9y5yDv75/+G9jFh2kJu+T32qhcF/lFqNpPtGnhTM
         ZYzA==
X-Forwarded-Encrypted: i=1; AJvYcCWmxd7TrTfrE8VgpRiO//xWPYL4FtO8Khc6hc51f3KaWhSb+PtdqrJb0FvTQEnGUVL5hsRSpdNidoucz2sczQ==@vger.kernel.org, AJvYcCX1BA/6tp8XPSiYYddUmvbyaq8WnpkuI32HhX39z/WCi2UpLW7ClZULmaN201zS5vu0ZM6n+W+6@vger.kernel.org
X-Gm-Message-State: AOJu0YzXPMvj3FV7kt86NHUnoy7ZH5nRPHsRxKF/ASIGzPLEfYU3OQec
	ocQa4xxBtaQUvcOONER53N973sAxjSfWVefWd97GAfd8kCLj+vBFWyYlbKQuAwC6o44=
X-Gm-Gg: ASbGncs8WDhD0m/jP0bYKbC+OP26GbRx4eKFQH+LMAakpuUXdtYcV+uRb4cpw7GyRwc
	qeeyM6qGGOQVt6T/cWs0TkOlTTw16gRyfKds/WMyZQr9Rt/GkOFYU4QV41aQa1efjaRyZVRCU9N
	po7RMxiaB/C3Xh+E0YWQw4qTQA800ThKj8paEU78ym+5IZKdMHHvygYShovsSYd5X9LOqcpnsCs
	blRlq4482ry9rUqAsDrrA4tF63vQgOrsZ2yZzpLA01I9y0yjXnKEVP7ZyRk5EfC/4uYuSvKzHPp
	4f+CS1cKTZnjTGCEJtRtq3IGTPwCHV2WWuYI9CpjhmcNWvkeHnukmbb44i7GXaeLzYqN5YlyK+D
	XJ1jOwKhlptbwEP5LytarBnCaa8BgVSQMcctBG/u7vthOEZUW
X-Google-Smtp-Source: AGHT+IGWN9fy6v7NGwOl0ONAVzKNbVe/LSq5VZXMakq/bL2GcVHbmcF2yn2EHjECCTO4bHvh5RXPnw==
X-Received: by 2002:a05:600c:1da6:b0:44a:4874:bdde with SMTP id 5b1f17b1804b1-44c8ed8f474mr89872705e9.0.1748270105043;
        Mon, 26 May 2025 07:35:05 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f1ef032esm245264865e9.9.2025.05.26.07.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 07:35:04 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Karel Zak <kzak@redhat.com>
Subject: [PATCH 1/4] overlay: workaround libmount failure to remount,ro
Date: Mon, 26 May 2025 16:34:56 +0200
Message-Id: <20250526143500.1520660-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250526143500.1520660-1-amir73il@gmail.com>
References: <20250526143500.1520660-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

libmount v1.41 calls several unneeded fsconfig() calls to reconfigure
lowerdir/upperdir when user requests only -o remount,ro.

Those calls fail because overlayfs does not allow making any config
changes with new mount api, besides MS_RDONLY.

force mount(8) to use mount(2) to remount ro/rw to workaround
this issue, by setting LIBMOUNT_FORCE_MOUNT2=always.

Reported-by: André Almeida <andrealmeid@igalia.com>
Cc: Karel Zak <kzak@redhat.com>
Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay    | 4 +++-
 tests/overlay/035 | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/common/overlay b/common/overlay
index 01b6622f..2e36fa3d 100644
--- a/common/overlay
+++ b/common/overlay
@@ -127,7 +127,9 @@ _overlay_base_scratch_mount()
 _overlay_scratch_mount()
 {
 	if echo "$*" | grep -q remount; then
-		$MOUNT_PROG $SCRATCH_MNT $*
+		# force mount(8) to use mount(2), to workaround libmount v1.41
+		# failed fsconfig() calls to reconfigure lowerdir/upperdir
+		LIBMOUNT_FORCE_MOUNT2=always $MOUNT_PROG $SCRATCH_MNT $*
 		return
 	fi
 
diff --git a/tests/overlay/035 b/tests/overlay/035
index 0b3257c4..2a4df99a 100755
--- a/tests/overlay/035
+++ b/tests/overlay/035
@@ -42,7 +42,7 @@ mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 # Verify that overlay is mounted read-only and that it cannot be remounted rw.
 _overlay_scratch_mount_opts -o"lowerdir=$lowerdir2:$lowerdir1"
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
-$MOUNT_PROG -o remount,rw $SCRATCH_MNT 2>&1 | _filter_ro_mount
+_scratch_remount rw 2>&1 | _filter_ro_mount
 $UMOUNT_PROG $SCRATCH_MNT
 
 # Make workdir immutable to prevent workdir re-create on mount
-- 
2.34.1

