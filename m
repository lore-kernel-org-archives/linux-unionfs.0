Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B105722B8C5
	for <linux-unionfs@vger.kernel.org>; Tue,  8 Apr 2025 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744126826; cv=none; b=lIJoRqZXOjUjRfx0qJoPbtcS7FKcOPrRqbSUYAGoGwSD+U6M+WodygMbREpQbhLaVs9UdcjuUETC7NMhgs4baz/O4Xoa08ANVagntj6+tVLPbyVR31n+ohrmt35TjsH/FKdZzABcWjvG4+tNq63a6Ml1KIPVp7q8qayOt/A5AcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744126826; c=relaxed/simple;
	bh=3OqX7/HXnAJ7kWQYc8jrodPhsTz38Nm57Ur1bhCHh+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVm0XVLTmB4aN5IISfoSO4keZxN6bs0qba9nKyE7jMe2g9ofrqsXNqgaonqrXygv59iLxq10P5Lkn87MXWCvH7vNqlEtxPQrDahdwF4iu5Pkza8QZhIKSUXq7/KMJGwm6wWNGn4inDjqcDlYmccJBr3H4H7Q0pAJSQixdim0u/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OWsrBGyQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OWsrBGyQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744126823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PN6AWjrtRHghDIIvCf4IOAVUwqVcmDLtwrlJMGXZbVE=;
	b=OWsrBGyQ0vP1lAmQxJl7gXQE65+HAz64M98taD2TSmayixamQYX2R30v9Q/WSVtZbWYbPY
	fYc+xVp5JaaSqYkxz0ePn6i41SEFABjArtoaD4h0z0sOIBxwIh6UHyvJwsyNbD6UVffeZS
	JlnQsQ8G51lSHh6Ml5TWO81DI7c/XFc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-163tjmhCM_OSPZ4boJYADQ-1; Tue, 08 Apr 2025 11:40:18 -0400
X-MC-Unique: 163tjmhCM_OSPZ4boJYADQ-1
X-Mimecast-MFC-AGG-ID: 163tjmhCM_OSPZ4boJYADQ_1744126817
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ac25852291cso578331166b.2
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Apr 2025 08:40:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744126816; x=1744731616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PN6AWjrtRHghDIIvCf4IOAVUwqVcmDLtwrlJMGXZbVE=;
        b=PrYlfzAbBxRlc2biSt5FTUS39GBjfeRe0qgWFdP7yBKqCLpMdWYodvzXzLdtpSpIrR
         N2mT4h8044BCH0xrb0X2lQtQ1b+uMgJIeGq780BpnQGlbH6Of2tMtUI0iqYWFFIilPLl
         JRqsWvXKTmzV9PM5i63RaFNIP00vj7EXotlQFBvO//mAON2c9UL7FDp6qPuKIQNKNVzW
         1ECHCHNYFN4psOm+um0JWgAMSIPHqutKCQkheGlwOlD1LuT0Sg1ZIX2kot0y6BfFVpC/
         aLqTM1i0kcrAF6Ef9ljjgsinwF/DluvWybPX2qLsw74s3oQLPtjYm6pNOzGl/PYFawPs
         ml3w==
X-Gm-Message-State: AOJu0Yxb1JsbKw5+Q4YxhOuYwLt4R9G3oNgXELTooYxvU2G6JDKXSXLo
	bYLuG/HIUuA2uWPSunkCiCIt8FVVvBFAJ5N85NmdXpLXuWw/jSVDZnfcpoT6F+Owqjp0uyHKplI
	NremYH9Kh3AEr5b4ULJQXXtB8LZNM4l3kmTaWB4dzK3uXWxy6bDYvlfS+apY/8NcT+Q+kiaE2ku
	WsjSGTZS+FA3rSkcf/X9LVtFi8u83w+V+jZZY0z0hTN7P47Ss=
X-Gm-Gg: ASbGncul2iFekaD5cofmJkJyXILdMQ4t2lIEC+IINpW0ZbTOu2arTNY5XLuYZCeJBLL
	kSIp53CBlJs8a6+FQygAya93d4lODPMtszadC3poQ40+dLBSxYEHkh+kaSKd1sFIhmfS7PE5Gl+
	lZT0CAxKnpJIEWStTegY8W3eprogmLzR3QqeVkgOyxCfVQNqjX7J99kkMHJEDJOd6h5nZr4UkZS
	Dvyca9fp1jX7irezK5IB/r6cX4+EtI8yfth68XD5o6uzyeQ7SBf/QN3FPdvOsLORg+Zhb7P3wEv
	mQNazaacpPPexfMlhQOcsI3mrAcq1ZQbtmTQ/Ad1DfiDBoku+jY94TD0k3i09d4VgvkG4yhp
X-Received: by 2002:a17:906:5a4b:b0:ac7:e492:40d with SMTP id a640c23a62f3a-ac7e49209ddmr1102001866b.32.1744126816473;
        Tue, 08 Apr 2025 08:40:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHj8lXffDci56FA1P0NxUfnXmOBj0Hc3hmrjp4qZZ1KQy4AcmxFhC8j1v3veuCkfZ6qbLKmOw==
X-Received: by 2002:a17:906:5a4b:b0:ac7:e492:40d with SMTP id a640c23a62f3a-ac7e49209ddmr1101999166b.32.1744126815959;
        Tue, 08 Apr 2025 08:40:15 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (193-226-212-63.pool.digikabel.hu. [193.226.212.63])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c01bb793sm927553766b.161.2025.04.08.08.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 08:40:15 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 3/3] ovl: don't require "metacopy=on" for "verity"
Date: Tue,  8 Apr 2025 17:40:04 +0200
Message-ID: <20250408154011.673891-4-mszeredi@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408154011.673891-1-mszeredi@redhat.com>
References: <20250408154011.673891-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows the "verity" mount option to be used with "userxattr" data-only
layer(s).

Also it allows dropping the "metacopy=on" option when the "datadir+" option
is to be used.  This cleanly separates the two features that have been
lumped together under "metacopy=on":

 - data-redirect: data access is redirected to the data-only layer

 - meta-copy: copy up metadata only if possible

Previous patches made sure that with "userxattr" metacopy only works in the
lower -> data scenario.

In this scenario the lower (metadata) layer must be secured against
tampering, in which case the verity checksums contained in this layer can
ensure integrity of data even in the case of an untrusted data layer.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/params.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 2468b436bb13..e297681ecac7 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -871,18 +871,6 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		config->uuid = OVL_UUID_NULL;
 	}
 
-	/* Resolve verity -> metacopy dependency */
-	if (config->verity_mode && !config->metacopy) {
-		/* Don't allow explicit specified conflicting combinations */
-		if (set.metacopy) {
-			pr_err("conflicting options: metacopy=off,verity=%s\n",
-			       ovl_verity_mode(config));
-			return -EINVAL;
-		}
-		/* Otherwise automatically enable metacopy. */
-		config->metacopy = true;
-	}
-
 	/*
 	 * This is to make the logic below simpler.  It doesn't make any other
 	 * difference, since redirect_dir=on is only used for upper.
@@ -890,18 +878,13 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	if (!config->upperdir && config->redirect_mode == OVL_REDIRECT_FOLLOW)
 		config->redirect_mode = OVL_REDIRECT_ON;
 
-	/* Resolve verity -> metacopy -> redirect_dir dependency */
+	/* metacopy -> redirect_dir dependency */
 	if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON) {
 		if (set.metacopy && set.redirect) {
 			pr_err("conflicting options: metacopy=on,redirect_dir=%s\n",
 			       ovl_redirect_mode(config));
 			return -EINVAL;
 		}
-		if (config->verity_mode && set.redirect) {
-			pr_err("conflicting options: verity=%s,redirect_dir=%s\n",
-			       ovl_verity_mode(config), ovl_redirect_mode(config));
-			return -EINVAL;
-		}
 		if (set.redirect) {
 			/*
 			 * There was an explicit redirect_dir=... that resulted
@@ -970,7 +953,7 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	}
 
 
-	/* Resolve userxattr -> !redirect && !metacopy && !verity dependency */
+	/* Resolve userxattr -> !redirect && !metacopy dependency */
 	if (config->userxattr) {
 		if (set.redirect &&
 		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
@@ -982,11 +965,6 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
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

