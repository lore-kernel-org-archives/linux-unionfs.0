Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD191D63E4;
	Tue,  3 Jun 2025 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945278; cv=none; b=vB1mos8j89Infi1GYSqek3fIeqL1PWecbC/5q4pCfrP5lA3wqN+MQxMBUgUW6gKairElh9bmhcJTpEw9zmj05Xs2EwUS+cYeSPVxjmRuqvkYue+y641IDON3gBH/hD+kFMiCIMzJLLHijedoKhrGcUSm1gIPsJqTmIOiiqcf16k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945278; c=relaxed/simple;
	bh=wddbm3nvJyxtM2VBIVR939L0xRl9+rCx6Se4lGKEJro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=khlBwqNsx9coGZuDvHypuXOx3yqEKhrS2VZBjmzZMeF3r6UDaXxapBGyNre2cPcgq4CaJaXLCnJbg0phQ2B6k1dV4LXuHszG04YYYEfvZFmiqzz1W7e+RN2nhdTqKI+6/BiXcM7wQAbWXE95gzlr8vPLPZYiDVzy5+eMmpZQyew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lwuhuc6S; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lwuhuc6S"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-450caff6336so32638505e9.3;
        Tue, 03 Jun 2025 03:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748945275; x=1749550075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w6SPQjW8lvFk9myCC+1QcuExel7OE7RmtQQM1sEzqvE=;
        b=Lwuhuc6SGpR0L3cVG+su3c/non3XaYu1qEodrbw+atu6sK6ON1X2f3fZEEjtLwqOmU
         edeOR5xbASeZTtnkzfB6kPoKIMX4xcLE2meVIoo8z9kKxhpFE/vLOv4wCQdtjVlCDixZ
         Hxy1kHT/yDRQrgZBE1nR47q8jP3qbUtJC7ZX95mAegvhH6AJtk1u956iaK3lzepeI+AT
         QOg95vxbaQRikn2T3ee6r5maB9LX7JJEzrZ28Ca0/wMXNhP0AwTJXdZn8qVnyPBFO86H
         t52tIeWcNV51GbgEvoJvjMxjTD9VJ9mtgpcDsVKpg33lcG0n946ZAZJyZKMlmBU4IIIH
         jmgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748945275; x=1749550075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6SPQjW8lvFk9myCC+1QcuExel7OE7RmtQQM1sEzqvE=;
        b=fuHEJ0aGn+HiREO8D9ZTret6djk1aXMgiVV32btBwrM3yKyvEkVYoVP/NeMBHly4NU
         AklxB73Cv9nmwGRnJDSjcwBdWDgmnks6mzjeJzdhop5XvXQVCT+EaA7WCNb2iMcUVpBd
         ktlKXBwOO3/oElLzFtS18EYCFLSdhvsF2B7UZ3qF6jRAp2ekUiEkB2BcC4VBhZTd38R8
         EWO4ndTrTLp+yxt1mhiX2MD4Y5sicOEnjiwl5MlJZ0ufs50M62VaFa6gLbwq+l/f6A24
         o96I+XjxkbkIieSQJGEVovYPtPul16yeiqZVEh852Ox6Fnjz50q07BQPRM8DPqUDpCaM
         FfBQ==
X-Forwarded-Encrypted: i=1; AJvYcCULAd2QkSjv03F0k/qO0cGetyRfO3dTIa6eWmtbIUVPW3ynIzgtvseaSN3uMWHGM3E9Yh4UGK4d67CEfvm49Q==@vger.kernel.org, AJvYcCV9Y8Vib3zjAckuDpqjnXKDpUH8Aj91dAn4cfNZdo4Zwg854k3pofCfkoIvbAapuQ6CuxV+8KpW@vger.kernel.org
X-Gm-Message-State: AOJu0YwSn5aVKHxwZzI5rRZkgpWQZ4mH7zMULMXzFD/B3ZIEWf+veEmS
	BU0Y/oBbjoJaV5VlVZ04slgZ57N+3SwjwaIMQL+Sw0iKwH+387dknXYi
X-Gm-Gg: ASbGncsVB9Si6vRqqG1d6MkXDIWFcj+BvSo+PRCjQBvkiSh6cXAyf0i8HBsaSQlaYR/
	T/GEoh9Ce9Vbmm9L+tpbbun+LgYv3ZW2EOXR7QmvekKPOxaCRuLR+TPyIsJknq/GaxZ3025Z3dD
	vGqzn4XV4Ja3NnlygxPd2f/PN/Sv41vX528zOE+LlklWaBpsLO688JMUHHbzdhdVrPBTXUiqTIJ
	JES5X3H9REft0URCluo8I9T5VsQtmyA41nJULWuY4QwbnI/4eLH7BPYeLJA7orsbBpuGpdGzM2T
	51TdTyxWtqBFpDtGmmch3AHqtUpbsWFBGev7p71xOgPZTlOi2un2pnTYw44ga+kQUp/rIVrHutE
	8CJw9r5wnh63IZZFxzKPHXQGWfyByLVI3asaH/ZaiCSw6kM7Z
X-Google-Smtp-Source: AGHT+IHK9fu+rKJrN0qf8U0X9N+dPocUvfhFrbDASOhslpXVCl2x3B3IYmoezmD2m6G1aqOL4XUSIQ==
X-Received: by 2002:a05:600c:46cb:b0:442:d9fb:d9f1 with SMTP id 5b1f17b1804b1-450d882b051mr144725745e9.4.1748945274992;
        Tue, 03 Jun 2025 03:07:54 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fa24c6sm157191525e9.12.2025.06.03.03.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 03:07:54 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2 3/6] generic/604: do not run with overlayfs
Date: Tue,  3 Jun 2025 12:07:42 +0200
Message-Id: <20250603100745.2022891-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250603100745.2022891-1-amir73il@gmail.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Overlayfs does not allow mounting over again with the same layers
until umount is fully completed, so is not appropriate for this test
which tries to mount in parallel to umount.

This is manifested as the test failure below when overlayfs strict mount
checks are enabled by enabling the index feature:

$ echo Y > /sys/module/overlay/parameters/index
...
    +mount: /vdf/ovl-mnt: /vdf already mounted or mount point busy.
    +       dmesg(1) may have more information after failed mount system call.
    +mount /vdf /vdf/ovl-mnt failed

Opt-out of this test with overlayfs and remove the hacks that were placed
by commit 06cee932 ("generic/604: Fix for overlayfs") to make the test pass
with overlayfs in the first place.

Tested-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/604 | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tests/generic/604 b/tests/generic/604
index 744d3456..481250fd 100755
--- a/tests/generic/604
+++ b/tests/generic/604
@@ -13,6 +13,9 @@ _begin_fstest auto quick mount
 # Import common functions.
 . ./common/filter
 
+# Overlayfs does not allow mounting over again with the same layers
+# until umount is fully completed, so is not appropriate for this test.
+_exclude_fs overlay
 
 # Modify as appropriate.
 _require_scratch
@@ -22,11 +25,9 @@ _scratch_mount
 for i in $(seq 0 500); do
 	$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/$i >/dev/null
 done
-# For overlayfs, avoid unmounting the base fs after _scratch_mount tries to
-# mount the base fs.  Delay the mount attempt by a small amount in the hope
-# that the mount() call will try to lock s_umount /after/ umount has already
-# taken it.
-_unmount $SCRATCH_MNT &
+# Delay the mount attempt by a small amount in the hope that the mount() call
+# will try to lock s_umount /after/ umount has already taken it.
+_scratch_unmount &
 sleep 0.01s ; _scratch_mount
 wait
 
-- 
2.34.1

