Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E7624C683
	for <linux-unionfs@vger.kernel.org>; Mon, 10 Feb 2025 19:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739216724; cv=none; b=Pzh0Cyd4TfxWRdnaAVBkYeSkWtHiK80ImCts5IhT9rwx9y1u/eUpZ2cL37QLdyIUvnADjQNc95iLoiL1k6yvtWKLG0WFeCFQZCc/t8Zm9c0wBbd35Zujm1UVlfBiBvffku5Ha5SXzi45DRjPE4a0zKbHdzAYc46+0WUhHFfFjdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739216724; c=relaxed/simple;
	bh=YmxZVquIfuzN0yi8pIPoqE/kuWCEjwQIrkVF8kUQOhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gs1d8YLinume8awFz3daTp6rm4+y6VHeB7xGVjmXTTrzI9tZLpTsoqTRRHrjGAj+oEBF2ptL7Z/h/t8kMfsOx+5OUwyKQ2qLUWEzHYXDRayE5hZv8UxjGy1mps0XPk71O1qkZBOSF24WVYW58VD/EaGWFekhqcEh0sv7yXmCflk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YFSjluhs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YFSjluhs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739216722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=syWQXAn3cOmG6FhmrbnuZsvrrh5ERmXR+dINB6h2IWY=;
	b=YFSjluhs7fnFDqdzVdL79k9lFBEDmZwoKHNDyLPORVB6LYhKUQrQrf4SeMTK6fVQA4A6ti
	y48xOVkPRR8K3IfKBafQg6TgWGuq2VC2Vuv2SO7qUZCGSfP7I37F6J1jCk48Vot9WV9LGB
	7Ybw419ib9bZipGfOv8rtDr1saEJ3Uc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-diWAPWxINkK3x1YU5is0Cg-1; Mon, 10 Feb 2025 14:45:20 -0500
X-MC-Unique: diWAPWxINkK3x1YU5is0Cg-1
X-Mimecast-MFC-AGG-ID: diWAPWxINkK3x1YU5is0Cg
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ab79e8c2ee0so201352766b.2
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Feb 2025 11:45:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739216719; x=1739821519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=syWQXAn3cOmG6FhmrbnuZsvrrh5ERmXR+dINB6h2IWY=;
        b=NInxLaV/O3jIkuOCHghHisRfrexGcJm5T4DJ34vzvVbhanpZTVqapBLo8oMJm6bj2/
         6XHcMyShI27Nrs8OAO8a/WE/sUXKMaETDo9VbRdzBA46kmxrR1jTvZI6gn33p2csWYvd
         Uq+FdXY5duXd68Z4vEwFEKCMeAlrVsvJj3PaVuhZMQqn+Sw9XHuoEWGS1IzOoe83LWKG
         sAqpqnqMN7XiqndjwOHmFhh46vb9mnk0+yOZUnOwsvjcpZVQeWpC6ZdkcU+pPD52xZ9o
         ep+aVzlgsLtE6WQyGCaDRsIfcmRfubScL/UGRVwZLqu/F2Pr43r4ojkht5O4ihPX/sk9
         O9rw==
X-Gm-Message-State: AOJu0YycuQRPhx/EJGYYxqy6yrqKvAjj5kmGT4GMj+J0At3Rn1NS6BCC
	IertIZiEJMgPRZyiBXCJrT5jLIZxZXAalNHDs3dZ3z52DKJdeDkNudvnC9zbL7VvnZXkT3qVmsg
	e0aQ1NkYavHN/wlKG0bD8sYKaxYuGS3WyrOqHcFuappBVkAHqDYUZRJ/BC+ov4omPTQa5o2EIwY
	GdmwP6iGFzbrRzAkQxHBZliv1SNWVPFDB0Lvv56vu6DqAiQGBQOg==
X-Gm-Gg: ASbGncsRq540MpYy7nWY5q1cJVArp1eq8NbVAfT4AuCpoCARq+j7MBtMuFR0m+e3YrX
	U5RSCrM4csispGGU9+2QV893wm4sNY7wLY+PlB9eCajkzjlCeq60TYIPShjJiELHQcgqK6oB/xy
	e6oZEo0WGWsjNh0RDGapnYqsdlrwdNGKofX0JSX/sMffLNPTyVa4O8lnNvgFfp2ezibLjUzimh0
	SQxme/5UjjRBe3SJw3gVdLwj7TUFGPvcUoSb926ncDr2b9qyzeWv3kQf3YcF5HbMeOYhO2Ltcaa
	qnVWv5O9XuBFukrqWinNJ8xI8+MLdx/ioNnHu5Wp8rrnzFQlctEgYg==
X-Received: by 2002:a17:907:94d5:b0:ab7:6c50:5f19 with SMTP id a640c23a62f3a-ab789aed850mr1685235166b.31.1739216719252;
        Mon, 10 Feb 2025 11:45:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTh1rYRjxqc9Hckzii4MFPMys+FRZP22pUg+8f92LmqHsvmatwOVrUh70dujPwDuo2gFVTqw==
X-Received: by 2002:a17:907:94d5:b0:ab7:6c50:5f19 with SMTP id a640c23a62f3a-ab789aed850mr1685233166b.31.1739216718890;
        Mon, 10 Feb 2025 11:45:18 -0800 (PST)
Received: from maszat.piliscsaba.szeredi.hu (84-236-3-29.pool.digikabel.hu. [84.236.3.29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7922efbb7sm702006666b.2.2025.02.10.11.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 11:45:18 -0800 (PST)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/5] ovl: don't require "metacopy=on" for "verity"
Date: Mon, 10 Feb 2025 20:45:09 +0100
Message-ID: <20250210194512.417339-5-mszeredi@redhat.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210194512.417339-1-mszeredi@redhat.com>
References: <20250210194512.417339-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow the "verity" mount option to be used with "userxattr" data-only
layer(s).

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/params.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 54468b2b0fba..7300ed904e6d 100644
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
@@ -986,10 +981,6 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			pr_err("metacopy requires permission to access trusted xattrs\n");
 			return -EPERM;
 		}
-		if (config->verity_mode) {
-			pr_err("verity requires permission to access trusted xattrs\n");
-			return -EPERM;
-		}
 		if (ctx->nr_data > 0) {
 			pr_err("lower data-only dirs require permission to access trusted xattrs\n");
 			return -EPERM;
-- 
2.48.1

