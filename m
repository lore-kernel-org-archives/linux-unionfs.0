Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088D01366
	for <linux-unionfs@vger.kernel.org>; Thu, 11 Jul 2024 04:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720670726; cv=none; b=XFiQnKNqDn5jSxP7sZOMCJA+21916fy9AMfX3DNxcgItIIWdkL/iIELq5LFBI5TOoQ0Zyv/WSscEz9CACHxJDkV2AmuA4OfhA4zndERPIPN8fNQEYoLyOR9u4mFN144ZLmkJz/FUf4oAQan1h9Irv8RL0IuCTcgUslNSxW073UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720670726; c=relaxed/simple;
	bh=xo+iTEkITioQ/POaG1OZHnhaz02utSNb5wZODWrypr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sKsuKK/CCha1VdrbN6vGGh+A6gnAaDE1GwJjjGtH0AZFhNxhAnKKoz/4fQBaBDOVcbJTpkEWAbkOGyXlIpXHYuBKgLB3jedGWPIqW9weUx4pk2v7el6IlzpdJpPzxcr2NXQ5R9fBrd04pQifnze3P/6tGajiPA2jR83HAOsUHyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=2V3uI47r; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="2V3uI47r"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8076cee8088so9512039f.0
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Jul 2024 21:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1720670723; x=1721275523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zj4dMQBLH5GfHsT3CdKQItS+EyOnYW9SMSeond0KEU=;
        b=2V3uI47rvwcnkRuAFcewBMW/uL5WeAsQ36KgLADW2lvSX//wngjT3Rz63j3qmYQmDh
         G+kZWcQy8/vuH98V5caIOAYwEHay4kLEbcnrvR0cS/6UTQCnpMiwzkOlog5HWwjdAWqW
         NhFEqHFiRGtY0TwBHru1Hy/k8H8SNmdCiyUYSFvaZwtHjp7lig2gBRHW3znyiFO0fSq0
         mt82D9NVO35+1cxUb7qvA+CMLW2IYTiMQ4WswcCZ5utnQyRF+Xwg3217NIg4bOQFT8v3
         Wz6DFtNz8QBdrV4wyoxQ/RltZ7GBRsJfF84265nJUljaKkhNHgqJrPYCVFBCqU6phLo2
         dr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720670723; x=1721275523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7zj4dMQBLH5GfHsT3CdKQItS+EyOnYW9SMSeond0KEU=;
        b=XiVavM2WMhVXJS9wagf+ZXHoR5492tiFDe+65VnUs3aIpY193zPM5wO9KOTx8eao6U
         KfbuxQa8P8oz/urOL7oiAt24gKZFVl6XOO3Toa7kxmjiJmHzXZmFmg/lSfFfog+RYfTm
         ixwWtsNzwGqV0maKQJaJqurT1SyAz5nlvbQFK9tkzlYriJRHTgYVYyu+U4cHjFT+Ak56
         IZCMft9BozJJ5nndFuxOj6j1jdXyStNOOxs5u1xm+fOnKFGHUuTn948KrzeiZVRV6m4j
         cudg9Grbs4CTWlT+Q5+ZXYfHOEw9mQ4Mw0nqc2gclDDQMCAwXAt5C/LDlDjkBWL4Xxf3
         4+Ig==
X-Gm-Message-State: AOJu0YwhNxbarcbjCnn3BEeyNLZfUENyLvraWwXlD7lBT2b8TCvDtYau
	3x9RWx7ccHwt9Ys2c9Z5lyLVI/u6/XztV1gJPvHCy9x2l8zk7PG1Z6uFal4WD0BzQnJZ8f08pV0
	mWgU=
X-Google-Smtp-Source: AGHT+IGDeMVSRkmKIGR0cdw5CdVslvnzLIFScVr2o3ai3PjUaAbCCv3LyDKek8ZkGUBx6EKtcHvCfQ==
X-Received: by 2002:a5d:9b84:0:b0:7fb:8ff7:8f85 with SMTP id ca18e2360f4ac-80003abbe16mr722306939f.21.1720670723419;
        Wed, 10 Jul 2024 21:05:23 -0700 (PDT)
Received: from mike-laptop.lan.mbaynton.com ([2601:444:600:440:7e60:221c:a402:54fb])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c0bc1dac10sm1251250173.166.2024.07.10.21.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 21:05:22 -0700 (PDT)
From: Mike Baynton <mike@mbaynton.com>
To: linux-unionfs@vger.kernel.org
Cc: Mike Baynton <mike@mbaynton.com>
Subject: [PATCH v2] ovl: Fail if trusted xattrs are needed but caller lacks permission
Date: Wed, 10 Jul 2024 22:52:04 -0500
Message-Id: <20240711035203.3367360-1-mike@mbaynton.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2e8c4e8b-3292-4ccf-bb63-12d7c0009ae9@mbaynton.com>
References: <2e8c4e8b-3292-4ccf-bb63-12d7c0009ae9@mbaynton.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some overlayfs features require permission to read/write trusted.*
xattrs. These include redirect_dir, verity, metacopy, and data-only
layers. This patch adds additional validations at mount time to stop
overlays from mounting in certain cases where the resulting mount would
not function according to the user's expectations because they lack
permission to access trusted.* xattrs (for example, not global root.)

Similar checks in ovl_make_workdir() that disable features instead of
failing are still relevant and used in cases where the resulting mount
can still work "reasonably well." Generally, if the feature was enabled
through kernel config or module option, any mount that worked before
will still work the same; this applies to redirect_dir and metacopy. The
user must explicitly request these features in order to generate a mount
failure. Verity and data-only layers on the other hand must be explictly
requested and have no "reasonable" disabled or degraded alternative, so
mounts attempting either always fail.

"lower data-only dirs require metacopy support" moved down in case
userxattr is set, which disables metacopy.

Signed-off-by: Mike Baynton <mike@mbaynton.com>
---

 v1 -> v2 not specific to data-only layers, punt on metacopy disable
          due to xattr write errors creating a conflicting configuration
          when data-only layers are present.

 fs/overlayfs/params.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 4860fcc4611b..107c43e5e4cb 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -782,11 +782,6 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 {
 	struct ovl_opt_set set = ctx->set;
 
-	if (ctx->nr_data > 0 && !config->metacopy) {
-		pr_err("lower data-only dirs require metacopy support.\n");
-		return -EINVAL;
-	}
-
 	/* Workdir/index are useless in non-upper mount */
 	if (!config->upperdir) {
 		if (config->workdir) {
@@ -910,7 +905,6 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		}
 	}
 
-
 	/* Resolve userxattr -> !redirect && !metacopy && !verity dependency */
 	if (config->userxattr) {
 		if (set.redirect &&
@@ -938,6 +932,39 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		config->metacopy = false;
 	}
 
+	/*
+	 * Fail if we don't have trusted xattr capability and a feature was
+	 * explicitly requested that requires them.
+	 */
+	if (!config->userxattr && !capable(CAP_SYS_ADMIN)) {
+		if (set.redirect &&
+		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
+			pr_err("redirect_dir requires permission to access trusted xattrs\n");
+			return -EPERM;
+		}
+		if (config->metacopy && set.metacopy) {
+			pr_err("metacopy requires permission to access trusted xattrs\n");
+			return -EPERM;
+		}
+		if (config->verity_mode) {
+			pr_err("verity requires permission to access trusted xattrs\n");
+			return -EPERM;
+		}
+		if (ctx->nr_data > 0) {
+			pr_err("lower data-only dirs require permission to access trusted xattrs\n");
+			return -EPERM;
+		}
+		/*
+		 * Other xattr-dependent features should be disabled without
+		 * great disturbance to the user in ovl_make_workdir().
+		 */
+	}
+
+	if (ctx->nr_data > 0 && !config->metacopy) {
+		pr_err("lower data-only dirs require metacopy support.\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.34.1

