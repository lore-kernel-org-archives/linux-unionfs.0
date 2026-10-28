Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217111;
	b=0+mN7xvbGzEUflfrViVlfkbzK/BibcRWipJJUqSKVXmAOPxwtl+kugFToUEOqh/jAoWN
	 yGMs+BMLG37Y01y7+loONUQIGnt+yM2YkK8f3C4h+h0rT6PVbEYrVJruKewC3kUVtac/U
	 WhA0Ws0bwrN87/Sa5s8G24HE5M+sNnlcY9ruSITEhH2fDjBW2DmWMbHYVCYZxxC7J8q0O
	 ml7Rnm1Oa/gNpfDKojk96oUHG0XJDThnVbskZnubOXWJYJEOSpwc6ZXM+NlymBO0mZ3kN
	 7OrRFTxI4zup6uNm2k8xJfbKkPowi0VndlPbajgefqX0xqqOtCLgdMMJ4ZrBqjiLcuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217111;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Nvrn4WRxmRYyXZvqlPwtDdIMr3RH/GbiGM7fkNtVFmY=;
	b=fDxJZKRjM/LVaIao9uYQUHS61LIAFq54yt2DorC0SAMscrKgQ2yzLw+JIA2z32FftdMA
	 qaua3nKZfujzEvL4h4Oh3/dkyf0xeAe6mlrV4G2FPZkia0sqwH0PlNRTc1rurg7fKr2gp
	 a3BXfKqYDtMstljFNFwRscX306ymJCovavHBe3oCJpkJVmjAadM11Nef4pFOuwJR/V7Ki
	 FPT5VnTGGKYITUM2wH4gDLfh4amysLDiZfMqDCruiHziIlARoTngSQLOR/xD3/LP+p7TG
	 B37d1TxcXtIb0yyr3seXZ6WliA/V4/x7i/E/0gaacODg9EkfR2Bwx/+wAAMQiFG2K8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wdi9apkS;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB47606A31C
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 19:51:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EB47606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wdi9apkS
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-36888ae05e7so429956eec.0
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 12:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793217110; x=1793821910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nvrn4WRxmRYyXZvqlPwtDdIMr3RH/GbiGM7fkNtVFmY=;
        b=wdi9apkSCNG+WQgHHVCA4gASRfPqBR9MTVe5qJGMyZ/AQVSrF/+6IyE6JTTMYREoU5
         dh5hKPiIf3d9eihVt6bFn/5qBCWy3fQ0Y0c1dQET5FZd4Hx/n2u/rGunZ8DJdy77wfrC
         pylW7aaWBmHles8P7pDCGhBgXvs2yzBcwChqiEhig98DyfPrDBmsW5OLmJ4kh0bv0v7v
         oHaxe4oKD3m6Qa6aP6I44Q5MCbSTrg07nfXV5jxdhcG+/4EeWJuMu+BQyjkt672S+Q0m
         iqwbyRP0jyqgyX7gXhhLtLhSCZfgfvD6skxxJKH158WN1xTnGgXPpKf28gaFsJl+ov7H
         HGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793217110; x=1793821910;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nvrn4WRxmRYyXZvqlPwtDdIMr3RH/GbiGM7fkNtVFmY=;
        b=wn7I3LQjMJYmMEq/NPTJLR1Hz12jFlauUKyTjMfaiRIBt2CLTgvTQ8iFsxWc2o0/OG
         MUKDmxWY/7gaCMyIxsMXZZMn32VDLw7DYseSKJENm9Z3zIjXOdms+S07kN8fXShUHcT4
         ibpLBzX6rNaicb7NBPDZZWzUKMIQFQaYJ9WWXsq0OtR92dgPEDeGsJ1bmZuxFSUrlRsk
         jKklDGcM7t0BJCCbl/AzuHZ6CL/Yg+kO5c0y05vEMzP4jIs0LZ8jEbVTRuQue90b/o2T
         t25UAKQGq7nVlAocuCcH181XJAg4AX4wROXIKtqgxqORZgouKTb9Xpj4+PcZojB1/eG7
         TWYQ==
X-Forwarded-Encrypted: i=1; AKwUvBzeSUNXtTLASGGKn7aAJS1mqcv4aUs43yOMf2etFVFdWkxTPuXGQuiT/sXUtRjTmR5BYU9gW6IyJvpbpWSL@vger.kernel.org
X-Gm-Message-State: AFq9FYJklW2W33yxduWt0koEKrDK0dbUHV6nrkW1qkLZ6jV3f/AfOk+m
	AxBB3NRfEhaH9pJgtjJ2RUXS2GWh/mL6/dq2QYu2Oj4acZ5etiJzWWM6
X-Gm-Gg: AYBFou12qzBfVl1V5OZ3g17oqlxM2VpBC+tfyt/3XjRSFcl3kbcI4MAJ1+N/KTe0qjL
	VLKcvPKr0l8dYIBnIjkJcvJTcPUeAeAvQnBVqlY2FKPMI+SltHHghL/6Yz8RJioVH1oAAsicj+x
	QJEXwGx5m0Q5QoJXhTcUDroYb4ycvPGZz02+NUUF+bmMMFpNSys3liOUim0QJXUW3kPxhNEkYet
	iHWiiD3KbFAIsJV6huFKvyezodP+f/sS1HdXaVzSEpQqeNfG22cFd9mTtdpWo5sxMfiFjTWgAeI
	koW26n7nlvIgBj+v2mY27mMXJnqXaIV5rl/UUg3tSzqNk6vS5JEFWF7UGpcHOyRdYJ88ROs764S
	K0UUyVf0a81sToBIBuLEA2uDIhh+AIn3XBjRAewCtEcFswEGyL/A7c8M1v+iD1pIKf2HXQHLzGR
	vk/tIJquA+Krkobn5X+e+EMNYDx8TSFkgJ0jZJM+VuEX8FZAwgQnrn+ux8n+rtbstLHG0Yy49wy
	c9iC2JuSadUCXjYU5ReZlkjM+Ypphp7aImkcgbnx7FSBKeh+StTs89eiLH8dFLp87aTpuag6isv
	doxl1wNkNlIxSt//uah7UdsHZcGXLiR0X9tmRH0oFDBPiCpcLsqQvYxH
X-Received: by 2002:a05:7301:1622:b0:36a:1807:75a4 with SMTP id 5a478bee46e88-36a20075471mr4923982eec.20.1793217109527;
        Wed, 28 Oct 2026 12:51:49 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a2398fa4csm10895569eec.24.2026.10.28.12.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 12:51:48 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: miklos@szeredi.hu
Cc: amir73il@gmail.com,
	andrealmeid@igalia.com,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] ovl: reserve space for the casefolded name terminator
Date: Wed, 28 Oct 2026 19:51:33 +0000
Message-ID: <20261028195133.86636-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ovl_casefold() allocates NAME_MAX bytes and passes that capacity to
utf8_casefold(), which also needs room for a terminating NUL. A valid
name whose folded form is exactly NAME_MAX bytes therefore fails to
fold, and ovl_fill_merge() falls back to comparing the original bytes.

For example, when two casefolded layers contain directories named with
255 uppercase and lowercase ASCII letters respectively, readdir lists
both names even though lookup treats them as the same directory. The
same names merge correctly at 254 bytes.

Reserve one additional byte in both the allocation and the folding
capacity so that NAME_MAX-byte folded names use the canonical merge key.

Fixes: ee95c5fc86dd ("ovl: Create ovl_casefold() to support casefolded strncmp()")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 fs/overlayfs/readdir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 7d6f7f6022eb..6113d690f8ad 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -81,13 +81,13 @@ static int ovl_casefold(struct ovl_readdir_data *rdd, const char *str, int len,
 	    name_is_dot_dotdot(str, len))
 		return 0;
 
-	cf_name = kmalloc(NAME_MAX, GFP_KERNEL);
+	cf_name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
 	if (!cf_name) {
 		rdd->err = -ENOMEM;
 		return -ENOMEM;
 	}
 
-	cf_len = utf8_casefold(rdd->map, &qstr, cf_name, NAME_MAX);
+	cf_len = utf8_casefold(rdd->map, &qstr, cf_name, NAME_MAX + 1);
 	if (cf_len > 0)
 		*dst = cf_name;
 	else
-- 
2.43.0

