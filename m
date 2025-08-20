Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865ED2D9488;
	Wed, 20 Aug 2025 09:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755682169; cv=none; b=hr/7xqJ0zuYNViz83T7RGS4R6V1Zb4OaDtX5z3ZSQookqOSRBL4Mt0xNBBQMRUbmGiWCmhaH4lQLVXo2B0BdC8PPrVvgY5Fkpl0K7NpgHueR28G845kYFUhRruEcVroP40qvGMzkYs96wPO5F46ajJICVvpLHyYKj/10AAlLLGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755682169; c=relaxed/simple;
	bh=GkLjC+KujJhxq+DPeb9PooDpqdQAPzuF/3QH6BnY+UA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GzU6reWg83fR6EUAjpknBO2rRG3pcDhLPALWzBHU0blE0h+l+a4lA789XfpZjQVFaBv3Nv2R3E1UToG8ySAgCAkRckAbboeTH8b2RR0jzaDCNFMkMsy03FqUogjwurwwkLfV1aU7r/buqgt0KJrpB611tZc+AIuHrnye2Y2MYzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hqU6/gMJ; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hqU6/gMJ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-76e2e614b84so5942721b3a.0;
        Wed, 20 Aug 2025 02:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755682167; x=1756286967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FsexL88QY+SMath9De6iu++b8EvHqE86irPkpuaoREQ=;
        b=hqU6/gMJB3eh2DhM8AbgzJblLAjntti47X/haLSnndHt4RGrYppVIg9yavxk28uT/w
         KNRh45pYk2KA3nDPY5CcVKj2QBPnHkLm6gsYMyS8FI4YHMh5TEMI1Qa7z8cHlndmGFB2
         QlpyvcTFbpTiEysVoMGVIDc5es5V3+QmrHFKyFE1czkd1QDwnEMKyhR+feRargrlJQfb
         u5a8d6BPY9oOXjZD5hUMpf+9gAw01ATXFgF3Ze3Y8c4No0JpvANPynjyKFmc1cVWDEPv
         Ght2udbKzTVuUyQ1jA3tac+w0oPRJRe261Ao1n/gPr2UGDwBzor2c7i3lJ8U3AqZ1Z34
         OHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755682167; x=1756286967;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FsexL88QY+SMath9De6iu++b8EvHqE86irPkpuaoREQ=;
        b=SElndIutVQRgxSlJxn3cdfWbBnhjlaKZDAM00H21TtwfaBdzy2uAia+8ixFkPOIg75
         pgGEx8Qb1GxU5RFpSH/M72/8smtaM5t0Gr7/RbN8rzdVeRg8owL3Y+gr9Wq7YJ2DnWHj
         nosseaXlcDXHIUbCWyJAHb1b4UHqU+e2X36XulrktVJ+O/8pLUu2gYjpCVUkHmBan02j
         GCMhWZIdUPbHFp8sBn/BuXJjajU8xd3MxSWjkmNTXU6IgkmuoMNHQT0XNAfEsAP7VS1E
         Yw1oBviKE3h4Su7JYA1gRJhrT2wjGWOmHR9vSu5buc3Du0SQBlhPXB1UBEuKvSpsWhgR
         ksMw==
X-Forwarded-Encrypted: i=1; AJvYcCVgWhsbKIf/xsPzXd6BfvkH1IecVyG4WmYVb0jjdlyNSuqN82bUiULHT9rr1DXo93eoqjBFBH/eDIOnToU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yze1DmqB7RBfdOdyyQMaK9tJVSdpCUOZjRxvOz1U0S94DxkVY2Z
	eBimEjN78jwVCfgAk3wANn+pBDPWvcyTuxvgKSE95n4Le626OITJbzCB/EOcNnxEzY8=
X-Gm-Gg: ASbGncsVp0nwbWSDJR6x6316M983kV8TYPNZh61mradEN4np9QM+rzt3q7ytafr8plQ
	6HmqcTLEe10VcoyZLdagiYOi/bDZQa30oYWl5QBXeL7CUift8cHBgYOwECqZ4BKQd2n/n93DTsh
	yV5B0YvRCdpjBWViX2N+pyHLFxOwPmKtvlv5fPp4FqNzTGRINVSme2TcIsqGXVFiOyiy9hMGEIs
	cLesXMxQVNIIO8GxfqzVMlnWNmo3hTWXLFGmIv3Jdrk3/n1xuUCvHG9eXxSm/ISzEwFrc+FZu6z
	FhAGij8lY0kw3Mj96ORkZXNZLNZWWopNI4zJGU26l8UwsSxfwD8OdwosP5jaP5LCI+sfQ5Th6EX
	tyjP4dVbDkaQ0WRIPLSo6mDmliDG94kC6eOUNHrZ5KYo=
X-Google-Smtp-Source: AGHT+IGn68JTaRs07pPDRgCFtcGlNztT0yxQqHiSVS8QoTercV4jLxhlp4WSufdOVbDcRu2BeAYBOA==
X-Received: by 2002:a05:6a00:17a5:b0:76e:885a:c344 with SMTP id d2e1a72fcca58-76e8dd4cb80mr3161982b3a.26.1755682166705;
        Wed, 20 Aug 2025 02:29:26 -0700 (PDT)
Received: from hh.localdomain ([223.153.149.237])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d0ffe93sm4830240b3a.28.2025.08.20.02.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 02:29:26 -0700 (PDT)
From: huhai <hhtracer@gmail.com>
X-Google-Original-From: huhai <huhai@kylinos.cn>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	huhai <huhai@kylinos.cn>
Subject: [PATCH] ovl: only assign err on error path
Date: Wed, 20 Aug 2025 17:28:48 +0800
Message-Id: <20250820092848.534-1-huhai@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ovl_get_upper(), the result of clone_private_mount() was
unconditionally assigned to 'err' using PTR_ERR(), even when the
returned 'upper_mnt' was valid. This assignment is unnecessary in
the success path and can be avoided.

Move the 'err = PTR_ERR(upper_mnt)' assignment inside the
IS_ERR(upper_mnt) branch so that 'err' is only set when an
error actually occurred.

No functional change intended.

Signed-off-by: huhai <huhai@kylinos.cn>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index df85a76597e9..a29ce0bce6a5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -512,9 +512,9 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 		goto out;
 
 	upper_mnt = clone_private_mount(upperpath);
-	err = PTR_ERR(upper_mnt);
 	if (IS_ERR(upper_mnt)) {
 		pr_err("failed to clone upperpath\n");
+		err = PTR_ERR(upper_mnt);
 		goto out;
 	}
 
-- 
2.40.1

