Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E031DC9BB;
	Tue,  3 Jun 2025 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945279; cv=none; b=rLT5OzFk0Cb3CMXe3BRWQF4c1/voSjnqYu8DCwjCJhV4pt2PXlilTw5VkG7ub8BHT4R7jNQOVJHqyq1j5k4NbgSBOeKGdxe7+SV9vq9bpHSQBIcziP8F31MX5z11cZzGvuRRAU4+kLwX1ijfygxu58BDXUCtUimBZOSI6Iv1Es8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945279; c=relaxed/simple;
	bh=Abi6+ksyMiOvnDtaHitx+7VyzwuUQ+TnG0w/e3HKSWo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uD5hK/lANiJBe0AE62i8G4NMn6BS6yI9VPLC0918X6THZRmOGq/PqtyFccqJeK0lnhn3Lxwf7jQHX/SUVo3qWXYla2D5zFxeuJ7b7gVu8e8R0+1O8nMHuBNfisVlRhTiErj8lM/xMNSMYuCE2EiLQeI9WCbcnprw8JQdzXlotIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UavSurV4; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UavSurV4"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-450caff6336so32638435e9.3;
        Tue, 03 Jun 2025 03:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748945275; x=1749550075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0qKfF93hS7P9Jq+BBkHsjnvqg1VJ+dx+VpScwbQGeQ=;
        b=UavSurV4K+iHsDX9VMe62SWmh68AVRmTm3Jg46hhcRGnFtUdmMoNelUxirM6CgQ0/3
         kaFs5CgoLPh+O4Pn8wdYG+4U3Vm8qqDh6FL/og7wgkpqwkvxfyhtTT6A5TdTtMIrtdCI
         tTyFSQF6prdvEkDQ1Gu8u+ktQHSvoupqprhlTmeejK4a3CDk19McYl5R0vumzPxf72vY
         LDZYKWuEoRT7OW9tXFBcKO0YEMGZ/73IfWO2lq4sBa/77kFA98Eb6owoh1uutKjG+mvq
         GO0JqU79dXgf8d4ZkYRnW+FzuZgCTPW7fV17PVrvZKuuKJ0ewDa3b5QLGugJRRea5LgQ
         29nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748945275; x=1749550075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n0qKfF93hS7P9Jq+BBkHsjnvqg1VJ+dx+VpScwbQGeQ=;
        b=ZC/zOO9vY8E2FheDnFei6ZPLhdz/brMGNQtv+W76ONIpcbfkQqkbgy1/qRAVcTcgki
         19KBN7PR1W+PmC6TbgNzYJbyLaXXBiiE06sY3LkTxiBt3RuL1HXpZFuSCYo9dbyTGfRK
         8i4ncwz40LmqAHK47aEl0mHFvhjQHI1mvjsM0uvJb5zDNe8Nz38ZNFGPWwmMJG8ValV3
         k0Dz2+eS4apaAS5qdhuiFgOb6gy0xBJQzvCbOm5BmkDazlCHhYQpLWPgnP5sxBJrQOFp
         syiDzlg/hlqNmbjeUeBAUq9wQlxuagFzzLEZ1t5z6llgM+J97Tdix3nkmdkDm1OwNyHu
         C2dA==
X-Forwarded-Encrypted: i=1; AJvYcCVYSWMUhLJQ4ieQz/eEtT3nM4ovBNAFU0GTU/M6v6hILabBq+M+BECsIJjFqtIoi7r+dzWaK7OhGbAYNbhqkA==@vger.kernel.org, AJvYcCWqkh6Xuttt+h2N+byicMkaCXlTEAMwp5T90740j6jkfX0OyXpsOtUC/ekoj1VXaX4gb/dsBXyJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzqI2bcBNzpldYCotOu+qef1UFmVLIXfRBgw2coeHXquGDghNcN
	vKBMFSEh+GYw9FcaJs0cuiCZTikE43OZdHA18/sZF0P6qc2peu3yg/PZ
X-Gm-Gg: ASbGncuRfGXS0FL1bz7ESALXbfoFgilMOgMdwFI2Il1heBem4THm0ta1QdwzevVaKit
	vNCJw9U7MgZ02f2EeIFYsxSzkqvQOIeS+HOJX2TgtSCJRs+NRBZty+k+d7y6vKS1BZUWNBotTpv
	tE3RRPVLM+zQdn89MgarG7/cyV63xCgOt9HYElLaQxP4ed4BCXS/tcNlE7XdvT2Jr2UXfMSa2St
	8LGlUJ0NJfEeV3/ng93qGlMopBD9z3jEOlTJnHyTaS3l38IxTm2v6/j2bJxBEM57AB/COlw66n/
	0j6N1tXA0jrMbekIFXNcNcbSsP2a1Z7duqtgAgN11c0PUX2LMhMS505EzIH6YLxuhf4C4FqRNEn
	tzL9Xl6n08zZ/+pOzJHl0TuIEX0fHPlXzE/yeaQulIGROB/Hl2exCltnsmvs=
X-Google-Smtp-Source: AGHT+IFrDtcoOrcGyeue/6ArMONifXbkFLkxDMJgD5K8Q304wc4Z45JtjcPvmMTWlNqzBzmoobuK6A==
X-Received: by 2002:a05:600c:4fce:b0:450:d4a6:79ad with SMTP id 5b1f17b1804b1-450d887a68bmr130188335e9.23.1748945274234;
        Tue, 03 Jun 2025 03:07:54 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fa24c6sm157191525e9.12.2025.06.03.03.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 03:07:53 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2 2/6] overlay: fix regression in _repair_overlay_scratch_fs
Date: Tue,  3 Jun 2025 12:07:41 +0200
Message-Id: <20250603100745.2022891-3-amir73il@gmail.com>
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
Tested-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay    | 2 ++
 tests/generic/330 | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/common/overlay b/common/overlay
index 0fad6e70..0be943b1 100644
--- a/common/overlay
+++ b/common/overlay
@@ -434,6 +434,8 @@ _check_overlay_scratch_fs()
 
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

