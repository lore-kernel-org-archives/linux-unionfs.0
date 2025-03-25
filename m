Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98B7255227
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 10:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742899606; cv=none; b=jbChyQcKbkpLMlifWdbKyJ1TE/bcm8+b0taYkPXTxMknmNv/4OLa0M7oiSeVZt9nOYJ3iDYdD0oysR6arcW91ikI/OWoRJtpvd4ht7+HHF/thr56h9gPxovvWfdJ3i+UAHDQ/HAvE2vYdW4mje6FK+Mo4XN1yOIAKMWYkPKP8YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742899606; c=relaxed/simple;
	bh=BkHIWKTP9JRXYjCX+MS6IytA1TJGjHbxJmx3B3dQ84k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKurdVGI+nVupDX9NWoIPR0o8F7tcXnYDKdlIcajs0ik0nQfQTP+BkhGVFu5ICMIODR0SoTvHHjgBY0qZdI+nz1+/dlWlnsYazzZWObUeR+ISJd7sPeus+PKwTHRMtRHwrEZ+d8+jTOJ+/uAXV19kuJAiwd5al3Q0DVOHMUW2pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R5dJct+k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R5dJct+k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742899604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WidvnqpHK1LBXH72ChmjyjnYZOjoCQtbOYDynNLa4zo=;
	b=R5dJct+kDD+EfyAvwzQUOrG5TdF11yYt5srg+I3V0Onvq5diL1/E+iaNkyTQrwO1rMnYyL
	MQhifT1dQlCtUJaMwwOfjfrzfiBQzaMhySlcRcGhvKxHgmTdS1EJ2Uo2IR3jKli2CBr/nV
	u1KrsafMF2oqnZytWaWHxvTWshBzgGU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-ZCFHosx8PnimPHUqhUttvg-1; Tue, 25 Mar 2025 06:46:42 -0400
X-MC-Unique: ZCFHosx8PnimPHUqhUttvg-1
X-Mimecast-MFC-AGG-ID: ZCFHosx8PnimPHUqhUttvg_1742899602
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3978ef9a284so2081159f8f.3
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 03:46:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742899601; x=1743504401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WidvnqpHK1LBXH72ChmjyjnYZOjoCQtbOYDynNLa4zo=;
        b=rgLxCeIIEvasVFGwNt5JQbRFchdk28T93PXBHI7yjrOBk7dmf25XJy5aJdKiMO1vnx
         RFpbFuSOJIQHKhMpE6hyZOwHtj6WKsYDxRGcD1323nVH0XPtCjpLBYZ48ytjSyzXYaZ7
         dfo/R7hEGg0GOqvo22YmQqo2+l+vn9O9r89NCkmkGJ3hME0BMtqSy5s/f+U5ASNzkdaW
         Z9JfWMZ/a3SNYrg/EvLAn14L8SQjWjz1VboaHmXJv+NgF3NP49P5sbBoBddzd9IFgh2b
         QxdszpMN1gjvISlVYsk6STPiALyyx0eRRPx0CZt0daVSCqXkr/4XkKuvWNoLfgDVLcSp
         5r1A==
X-Gm-Message-State: AOJu0YzfmunJjrG8xSZCLrAZtnwoGU+g7GUvIiQv2EG8WpW3v8oqNXp/
	T+mENQ8ZXN+r4FVNfQjbh3g1i0vf3GplfZYtToEWGglwRv8HMeDEsfRwaRyIHEgbWaMbAA7jxtS
	1+bC9yQ/tcx8bhrIZaholBbhBp/6vZMwtUZ7OHxDHEDCgvJA+qnrLc2cYFI/wThtMh2Uk9o0rDh
	S5AUH29WyAW3DArPNDpmLsMn0HvTIfs8J/NqltGq4QieUKyro=
X-Gm-Gg: ASbGncuI2HJF2o8y6N3zPO0ycGoDDdGMf23lKMFCEXj9fYdf6Va/b2nk0PHNrtYYj3c
	h4xvrz2zDaFVM3Fh3+zAC+rvZqBE7afoNPxbZA8in/9Pcc8VaTYq1J/0xjA/uNB1+YN+Hd05aWw
	4eoo2N9y/8TocszbD7KiF8+/s0u+1PxeUsjQ+41AnZMbayHwa9AyjD+Ocw8P3jTb5Fppw+660IP
	N0fgWNJj4ZXQpgMmySjNpM2a+LulAVg5GcSSglbGlMDKPFdtPpfwJeALAHorGkcQeBuL77PMoo8
	Z8mehNdPzShUDHkugzxwPxqjkcWG76Zra0Py1TJ3lkVOQiF59u2E8DY7GMss0AleDy8=
X-Received: by 2002:a5d:588e:0:b0:38f:5057:5810 with SMTP id ffacd0b85a97d-3997f908f1fmr15015028f8f.25.1742899601511;
        Tue, 25 Mar 2025 03:46:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOqzs/UB9hDXfXqPQHH68eV/UQBGIP2lwnTzM8ArMxc4vQh3QnISBv6xLSA0bOPMzdEOH4ug==
X-Received: by 2002:a5d:588e:0:b0:38f:5057:5810 with SMTP id ffacd0b85a97d-3997f908f1fmr15014989f8f.25.1742899601049;
        Tue, 25 Mar 2025 03:46:41 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (87-97-53-119.pool.digikabel.hu. [87.97.53.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a50c1sm13572203f8f.38.2025.03.25.03.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 03:46:40 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 5/5] ovl: don't require "metacopy=on" for "verity"
Date: Tue, 25 Mar 2025 11:46:33 +0100
Message-ID: <20250325104634.162496-6-mszeredi@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325104634.162496-1-mszeredi@redhat.com>
References: <20250325104634.162496-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow the "verity" mount option to be used with "userxattr" data-only
layer(s).

Previous patches made sure that with "userxattr" metacopy only works in the
lower -> data scenario.

In this scenario the lower (metadata) layer must be secured against
tampering, in which case the verity checksums contained in this layer can
ensure integrity of data even in the case of an untrusted data layer.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/params.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 54468b2b0fba..8ac0997dca13 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -846,8 +846,8 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		config->uuid = OVL_UUID_NULL;
 	}
 
-	/* Resolve verity -> metacopy dependency */
-	if (config->verity_mode && !config->metacopy) {
+	/* Resolve verity -> metacopy dependency (unless used with userxattr) */
+	if (config->verity_mode && !config->metacopy && !config->userxattr) {
 		/* Don't allow explicit specified conflicting combinations */
 		if (set.metacopy) {
 			pr_err("conflicting options: metacopy=off,verity=%s\n",
@@ -945,7 +945,7 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	}
 
 
-	/* Resolve userxattr -> !redirect && !metacopy && !verity dependency */
+	/* Resolve userxattr -> !redirect && !metacopy dependency */
 	if (config->userxattr) {
 		if (set.redirect &&
 		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
@@ -957,11 +957,6 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			pr_err("conflicting options: userxattr,metacopy=on\n");
 			return -EINVAL;
 		}
-		if (config->verity_mode) {
-			pr_err("conflicting options: userxattr,verity=%s\n",
-			       ovl_verity_mode(config));
-			return -EINVAL;
-		}
 		/*
 		 * Silently disable default setting of redirect and metacopy.
 		 * This shall be the default in the future as well: these
-- 
2.49.0

