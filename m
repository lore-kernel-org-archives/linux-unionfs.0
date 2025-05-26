Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED9320D516;
	Mon, 26 May 2025 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748270109; cv=none; b=eJfxsX+0pNs+tZrHvQPd8dtFp58EleKi91aWGKnEP0yKuSE8Ij1OAABhZs/CosQK304klZWS/jW/A86SHATfeoivKQP+505m/0HpibKlUAzEjqbHBlH70L4jmxpNNbYmKovzhOdQczs0bGWHIvg9zzu/vx0EPgmKZqdLf/O6mu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748270109; c=relaxed/simple;
	bh=k5vgbovlJ67Hmia3DtoU0YbPIEaJ8H4I3fXFtWV+/mc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rz/IQJUcB1zC8Ix/KClGa+BR5UxCiJfxae9umDeV/0ky7ndvV3UgLqETJfZ7Vxq3ts92Hyjoq3MglcK2qePFWEwQl7ofY8vlfEhYUG9T3D2A0V3Bfct6jTt4UuJfI/r9vGsSxUOoWnu9+tu1oz+UTK4gkvY6OtyEV7J8hrQDYmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BUlwzBRM; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUlwzBRM"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-44b1ff82597so21228695e9.3;
        Mon, 26 May 2025 07:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748270106; x=1748874906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lFUepdz79RTjcAX2ZspaNLCqoZxjqfsR2YfpOLgmb0g=;
        b=BUlwzBRMdg1nXH37R1duwO5H2saXCYge29XVMZ5Wcvca1gIevJ1w52YRsCHrJU12MV
         wbfpo73nKY0vKY0tg/TurMPMDYLflon09DHcmQRmKDk63d+XrVo5+a4hA6Em43kNTeHZ
         h1rQ1z7yvgn1913qU7qccrHisSAUMNVLpNFaSqhinM+Y73LPqRrrNnJVHp6Mp/C1dSJk
         Z8hffWyzyYwYciCEQbK4zGX1Qbd22fhgfyYJw/CFcze+ayT4MOxkkFwYc0MmM/9+6BUA
         suOcYxT3ByK/uZ3ePrpQVopVTNohtSDE1/Dv9XrCcujNpysl7rC2kt4A2ctJawIrY4qC
         W63A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748270106; x=1748874906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFUepdz79RTjcAX2ZspaNLCqoZxjqfsR2YfpOLgmb0g=;
        b=KTcZgBb9vvWKeigClJ21p5meBAfqfUNzwYbUIjtIdUHE3DkxH5Be2XAU0lAg00MQjp
         9H0GvH7MRRlo/FT/HysjNMiQwVG1Fq9gL3VDcsMDPozG+/K0oB0BDF5tmj5cxxFIPWhD
         RUTT/vsMMFJU0QtSCSNKeJKyMpUVTLQllJjHfIdjFR67P0Fv5CBpf9MtT1T90Y4px9z1
         29pRQsnmrI1rCPHrMibwf6UpqoFIerb+Ocrkro1wup5vNiH1oQqzhxDr7GB8cMKvyMAc
         PUvc2DhydQbZMLHWqNNgbMnSziJhgByswX/fjx464ux9EXtWhtt0dz9zkN8L7D+xG3zC
         w+Qw==
X-Forwarded-Encrypted: i=1; AJvYcCVXU69HQFHv5pnDfJowwz3lZaxloJKf8VfItKzmeXPB1pjhi4QJV4rBo/i+nKh5F/6aazLV61Qw@vger.kernel.org, AJvYcCWy4GaIjfNZ70K9JnoeF3eoVm0kepet52sQHsYonh5doayxDj7YS/S5LHgPsyks+myRbyO2aK93Gcdm29NQig==@vger.kernel.org
X-Gm-Message-State: AOJu0YzM1duhfbESggJtwyog6kryX0SeQ5ujVlXN8YF4KzU8HWKLEOss
	7cU+SHuH3ZeMb0i0gcf/xjBnMzjfwIt8u34V/9f9lnQ0cZgk1NM0X7YL
X-Gm-Gg: ASbGncu3hNDAOq5gfFZan7bv+rA1rcA/kHQmVv8nvB6nm8k48u5+6/Umh+ATXS2QDar
	vrnWT7haUFWZdBRC2iOb2EIZDv8IiD+hqRnfGgAsM+yIA+5NN9zMpTgsq9cQ9pwNfHKQJYKhHEa
	IH1OlVjzUrwFYMHoOiwQ2RV/H4Uwmm7wD44wOq0kUxu9u40zhq3gjlRJqWPB0K/Af5aad8yVB6c
	pb1cRrafGcCkU44Ks1k7tK5scHX2WBS78lHcdkmZGHAWbZd92Q21g1sgaGRpqzltY/7l+kCjncy
	3HypiqHc0MqOZqZEvkxxzFNZp1qBDcRAdrsatE+x4xFEs5997YVeakTmNy5rftqo4DCVbprPF4W
	oPArlh2LwER2pHGLdYqp3ehNM62MAAz/vSne3xKXdwDHP+bnt
X-Google-Smtp-Source: AGHT+IHTNfZR0f6L+2exMYDb3rgZP8vBpM2wZTNmkxm75zsueXC0B+2IOr/oiasElHFuE0/EPwXwpg==
X-Received: by 2002:a05:600c:6216:b0:43d:ac5:11e8 with SMTP id 5b1f17b1804b1-44c92f21e4dmr78703685e9.21.1748270105912;
        Mon, 26 May 2025 07:35:05 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f1ef032esm245264865e9.9.2025.05.26.07.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 07:35:05 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 2/4] overlay: fix regression in _repair_overlay_scratch_fs
Date: Mon, 26 May 2025 16:34:57 +0200
Message-Id: <20250526143500.1520660-3-amir73il@gmail.com>
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

_repair_overlay_scratch_fs assumed that the base fs is mounted.
This was a wrong assumption to make, and that was exposed by commit
4c6bc456 ("fstests: clean up mount and unmount operations") that
converted open coded umount in generic/332 to _scratch_unmount.

After this change, there errors were observed when running generic/332
if fsck.overlay is installed:

     Check for damage
    +fsck.overlay:[Error]: Faile to resolve upperdir:/vdf/ovl-upper:
                           No such file or directory
    +fsck.overlay failed, err=8
    +umount: /vdf: not mounted.

Fix this by making sure that base fs is mounted before running the
layers check and fix test generic/330 to conform with the umount
conversion patch.

Fixes: 4c6bc456 ("fstests: clean up mount and unmount operations")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay    | 2 ++
 tests/generic/330 | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/common/overlay b/common/overlay
index 2e36fa3d..f05f8180 100644
--- a/common/overlay
+++ b/common/overlay
@@ -433,6 +433,8 @@ _check_overlay_scratch_fs()
 
 _repair_overlay_scratch_fs()
 {
+	# Base fs needs to be mounted for overlayfs check
+	_overlay_base_scratch_mount
 	_overlay_fsck_dirs $OVL_BASE_SCRATCH_MNT/$OVL_LOWER \
 		$OVL_BASE_SCRATCH_MNT/$OVL_UPPER \
 		$OVL_BASE_SCRATCH_MNT/$OVL_WORK -y
diff --git a/tests/generic/330 b/tests/generic/330
index c67defc4..901b17b1 100755
--- a/tests/generic/330
+++ b/tests/generic/330
@@ -61,7 +61,7 @@ md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 
 echo "Check for damage"
-umount $SCRATCH_MNT
+_scratch_unmount
 _repair_scratch_fs >> $seqres.full
 
 # success, all done
-- 
2.34.1

