Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C4728EB;
	Mon, 26 May 2025 14:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748270110; cv=none; b=Eog6Drj/0LJ8s3ZZ6c9nTtP93FRyQeAMnugxaLh8/9lSm2Vm5zYx6j21udF6kV1ifbKPDRzYfwya7PKyy/tPFvizKHOPnd8Vaw8RI70yy6FQazTs/tRBPZpuLeFYWkQNiOHBtr0Qkv6ClYAx+ls8XoCHyA8oSNfXrfg9IlK4trM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748270110; c=relaxed/simple;
	bh=Gc9IE++rCFZ5DGL2F8lhL+TVcaJdmHR6ZKu010M+fWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sJyEmV7AAergXuQz6nyiSSjDYsY1QNNCNCGUTOtZx3MpaCa8EZbnH0RUonVEgbK0bLrMOiwvMPgm7aaLHGs83w5jI+3t3b3POGT53dUaJizZOeir4ahEnMK0YO/h9KpI7J+paxqeTFWZeWupT+VpfE2gGSVI3a9qf63Gt5Tp8jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KgRnf8JU; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KgRnf8JU"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cfe63c592so30633245e9.2;
        Mon, 26 May 2025 07:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748270107; x=1748874907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR5bUdiSmhX1URrwVgsxxS+HHRIyPs+GseYGYuEbtMI=;
        b=KgRnf8JUA7a2Y6be1e0V33NSA9dZugaEauGHQQLk4CoHWMEI+JDusl8qW6CqFhZDws
         S0b9Xmind4WwG8TUC5mgYhPHrpi+GAuenr94KDTDPGrqoWWbXywxfYOoZZg2+dbuYbMh
         dLos0aSSrrlvfugYJO0X20ty3Fgysy2zPbLzSnbybwiwgIrQ229fB7vIH/ztCqOcjLTf
         4s0oBkN5sTCT5RUBp92or79tdEyNka1nAqgCe/V+YI88zImE1BaKqROYeV3sNrseQ/z5
         BmQgBC7tD2B97+ygyAzntUpxaYFr7Dxcw9f/WaZdgbCWVoq7zXIOBB31+fHWL910dUn8
         ieOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748270107; x=1748874907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vR5bUdiSmhX1URrwVgsxxS+HHRIyPs+GseYGYuEbtMI=;
        b=wnD8Zf0qQcpNdx9qA0rqnEl1+NuYeMszEw1oeQF2PoijVUx0w0b5v1kaPQqZSCLM3M
         p09jCwf8YCWV5VxNXpVmR/dUjXFEnWBcKpnkPgRqXLFW43fOIgMTgQobZl+hni5TIxbE
         Rtx/lZMK3pMEIujv4MbN73otDxzQU2AqrKX3ntnhTPzqoTwjWPjSlJx5MiCsNAXeOWRy
         gfdav34hRoxC0LKkkE2df7ifhM1ZRNWBzFZPnOxVihpHtiexLqXMgXGewWZtE/ZHNqy/
         tk6IlihSLWCRU9kFONhn6/DuygH+we3j7b+hhIAi8BCb0kSN1by1AmGFFUkdErx+W3A/
         P2XA==
X-Forwarded-Encrypted: i=1; AJvYcCVI1rrkdJPy6difAtNZEvSvaKWIHb7wSv6Dbyp04RuCClwiIkrtaSCt0LFlj4HKNTcvHyuLIWpH@vger.kernel.org, AJvYcCXTaDVN/N0OcTu729GtCnHeGQA6KCQet71XlNmYls+UH0OZGRk28I/PXBvpgvgJu4//QAK3g9Q49yrvnQOkzg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwppUv1zq4fjXA+6xVOKg8/Fa5YeqFnePn2HA4c0GBWxzVB4yww
	/TeZsifWeAAU8XuqMnH1ujLWnB/pK3+73QfsUaBw6FrpM6wh0Q9nIcGNrDQPoO3TL8M=
X-Gm-Gg: ASbGncuuatZC8jJ3RckPymo1C503B8fvI2PJw8+uFvhhVhGpEJomku+P74n8bQAfXLd
	cAg6b2zESfwDXTBOSeIJZaXQXeTh9/D/lLyNdoc9o56a9gT1mfkg1eyMHLRXWwFCz5jM02m3dEf
	LtkAvjdIrjO0odYnuP8PpFJSPcBzbZlPH2cD/X13sv6lTGeEXflgc1GHSPLrlzICKCnBVKpfGku
	cWp+Ht8lrrbWN4mTVGkOdyAZdcHcklSGAIHOtRzN21Pc1BpiFwnI4khGUtZySGNSzvyE3/A+egM
	jziEOVLoSmMDASY6ABnlGdgb9BCI7JyvHBc9IW3zG3SR5R/rdC/2V9apMZWFPFI69aeDcfmVGjZ
	6YCKAnogZ7ra8CX1rY2zg46o/Q3tkxW+06JMDopzDJdz/MOaB0e33K8Zj+mE=
X-Google-Smtp-Source: AGHT+IEjfpIHYBudvZygl+rhbFPGoE/FvTg0qnMtUuA2gkOvs+wfaCRtd9L+M8WjoChnorEMSBleYQ==
X-Received: by 2002:a05:600c:3f07:b0:442:f4d4:522 with SMTP id 5b1f17b1804b1-44c916072e2mr69497925e9.5.1748270106948;
        Mon, 26 May 2025 07:35:06 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f1ef032esm245264865e9.9.2025.05.26.07.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 07:35:06 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 3/4] generic/604: do not run with overlayfs
Date: Mon, 26 May 2025 16:34:58 +0200
Message-Id: <20250526143500.1520660-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250526143500.1520660-1-amir73il@gmail.com>
References: <20250526143500.1520660-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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

