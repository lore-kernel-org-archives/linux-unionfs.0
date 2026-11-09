Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794225149;
	b=RE+7BChMHCacE3zaXXdP1lZFaikpnrairJeozsLHxOYz3TvM8282Veg4nwTA34f+Wpko
	 obZ+Mp1FpPvXEjxwxm8BqwxdwyAnMI13BzdcBVhNdxcTC1npTommFUTeC54MmMCoy4O9d
	 DdH0KTTL2z4nlo0e+0qtGX5nQUdhjtcSKMegDxLoWuT1tRgJoXkgBY+pksg5iFywd95NQ
	 m5wonAgK3HUJWCThgFDfD4oPaA3XYDbSo/bbdnJ5dpH9DzdjC+eJXxnOYWniwFX7iNh4P
	 Fcsb0G33RgaZONpMsvKvJKSwhDhQerxwirepG8/Mkli5K3rjTNoDG7OC0WtKaK02TUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794225149;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=U2EoyYDK7Cd8CqerOesnBjtnC3+XQJwuHrS5Rz0SBio=;
	b=4+GDts5nK7LtNGJttV+hgzFIy+1199iUXlz5yi0uD/7tHtvo0k6A2V8ICvafjzVfp/rh
	 Ff6T4GSLwD+Bl99Vv5FUo7MX1pZwm8P3hfeiue4oKQ9XrINTIM3+UWxyllZ+kucHxGINr
	 qUBCeJqkBVhgB2WXrVryziCvvlOcAuxEUyfAtQemiQXG5nF1hVoVbamXqXhYnsl9fAMHT
	 Ss6KiQbXBB8HzK59s0mIsLPJZ+KjakHOI8TMMeJJ2UygyIeZh4wlDUhyiQvzvrMP/O8Cc
	 DRpDR6X2aPmnbDgd+QfCiyA8s2//tTW+Ge+ITRIS0Yg6k4upHJrvomQJBYEcDXVZUzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iZmZGX6F;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADF4606A330
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Nov 2026 11:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EADF4606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iZmZGX6F
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4d30639709so87013266b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Nov 2026 03:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794225147; x=1794829947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U2EoyYDK7Cd8CqerOesnBjtnC3+XQJwuHrS5Rz0SBio=;
        b=iZmZGX6FLxDh4pH7C+bq0omojsZes7VEq8qQ6bGXhXod6BPJ99BYYrKvDIFQW+24KN
         J/kc5oMK+F3oYqNGQ+U8mmHyJ3biR5VJFxeFl2m6IWjs5uLEPSHJEJ/8ewsaXRylhCOJ
         r8UoXDeYhNbMcpKUyXizGymMVdKyAz33Ulg1QRpdLPAv1HG9R0+4n79rgLwIWxqVgygF
         JW/mOoMg9Ng6b2HPAsV6QNgl6eX0V5C77x6bk5y40yjeeSByskCMJNy4zpEUgR5n4ZQU
         q+5BARnthJRH81+1UBmoZkZJCZUNjOujTZTn70yTkgNba+Ck8QrzUXCbN2UYq4j+jrM7
         pPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794225147; x=1794829947;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U2EoyYDK7Cd8CqerOesnBjtnC3+XQJwuHrS5Rz0SBio=;
        b=kCZ8SvHLVLi9adFFWgibcZL4jGBR1fFD/jULftnePgEoNPgkIlRMu1cNrHLy61cErZ
         MWeBwhaFww4LRziwGUW1HgMEV6lYZDfju7eKLya6jMzIJlrSuzWIvQDTQmKFe2UB5g2/
         CQCtC+rnkd9VBzUu8dhmsk35iiTKehXGddGIrTWlZiVZDqrGtizJMMAtbBBZn6Xs7OtK
         dOvy7aP5yu0eofjn/ks4x7IbwCFl9mr9uyNHPTKcaWI1jTlzIQhAcNy5ZkVYrNy1TmyW
         jg9G6Qm7jh3PwSsmS3xs8TFUck3U3TcxJIuHjYzBGVgpWZz2RWqfPQSC8mYFdf7PKLME
         kinw==
X-Forwarded-Encrypted: i=1; AL+hErHO05LRpATlyB/tyvp6Q32EPeQxjqRUrSzYec0adJYF4pL8ksJHFa3PZdx2fDHpJhRh3GGFhnHtiPWpMMqM@vger.kernel.org
X-Gm-Message-State: APuU4Z8SQ1d2SreI0YG+AvKLhNuHGcUIphFxIAQ7ofkdF9kYeOn/z66t
	TevsKntR/oUR/jgmastHsG0bbWaYJd0tzcKIXzDCG48eU3fYKPhdfRBY
X-Gm-Gg: AYBFou3T1B4jUTtFNPTc82EzuY4WWA7Umm1+9/Sjo+VF9qqMDH3Z1SckB1tmoTh1+Aj
	1Iu7J2VXVG/EmNGVCE6vZbpDPvuad+hfwTJD3mKIeFk+lRTJvJ5SMeKsV0LyEFflZoSoGcKFQws
	cGLbhI5N2qES/50NJ6M5ok8eOibnkS/jRxxHUbdGFkS+gs6k+U7nu7mt+X7MlNU5T9zNNOCegSR
	vY/IJCvIGwLkKe5B2pkFnbu1hVIDZqgA/0ubgvS9fWkZ9i93fjbSvHJOptz1omY5SQC/4atmNVP
	W1F52D29tgd9q8yt2Z0ZyiRP3o8x3wYqvwahlAtZ11vL9tYOfho4l9klsGmBK5Ewl8e8XG0rioj
	rfVrumXzehhdZDw6fhh3KMklKebpIXQjLubvosvSfezzcV+sWddQQXfuOdB8uxXL5AkEXl5WT8A
	JMa7Qr/mvkfxZ7WJD+9nCei7la58P8L/+zThqzR871MdsUAqM/pTsSaetYfU+t/iTmgmhqihiCr
	k20BtdRPeKytxebioZp4y74yB1Z2S5h6f51H1SFiUvZ4+/yo8GiQCEFvdMSP7dljSSsgkGXOuH4
	WLbAdkRF7UMgCdZt9HZknELsSZMvMeS8AIEY9XVjuAsqLoVzU5cZspZP2VUnPE1HXVbqjewHx0A
	Y0RWt4u6I47IF
X-Received: by 2002:a17:907:3d0e:b0:c2e:61e:f4fd with SMTP id a640c23a62f3a-c4d6da63193mr273957266b.5.1794225147191;
        Mon, 09 Nov 2026 03:52:27 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b721ea368csm1382016a12.10.2026.11.09.03.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 03:52:26 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Giuseppe Scrivano <giuseppe@scrivano.org>,
	linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ovl: report the requested redirect_dir mode in conflicting options
Date: Mon,  9 Nov 2026 12:52:26 +0100
Message-ID: <20261109115226.4031954-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Since the redirect_dir mode is stored as an enum, "off" is translated to
"follow" or "nofollow" when parsing the option and redirect_dir=follow is
translated to "on" for a non-upper mount, so the errors about options
that conflict with an explicit redirect_dir= report a mode that the user
did not request.

Translate "off" when verifying the mount options instead of when parsing
them and report the requested mode in those errors.

Fixes: af5f2396b671 ("ovl: store enum redirect_mode in config instead of a string")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h | 10 +++++++---
 fs/overlayfs/params.c    | 43 ++++++++++++++++++++++++++++------------
 2 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d1ced6d07f1e4..2c65056ae9361 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -76,9 +76,13 @@ enum ovl_entry_flag {
 };
 
 enum {
-	OVL_REDIRECT_OFF,	/* "off" mode is never used. In effect	*/
-	OVL_REDIRECT_FOLLOW,	/* ...it translates to either "follow"	*/
-	OVL_REDIRECT_NOFOLLOW,	/* ...or "nofollow".			*/
+	/*
+	 * "off" mode is never used after mount options are verified. In effect
+	 * it translates to either "follow" or "nofollow".
+	 */
+	OVL_REDIRECT_OFF,
+	OVL_REDIRECT_FOLLOW,
+	OVL_REDIRECT_NOFOLLOW,
 	OVL_REDIRECT_ON,
 };
 
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 7a4e1be5225fa..27ef3b0651e2a 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -112,18 +112,28 @@ const struct constant_table ovl_parameter_redirect_dir[] = {
 	{}
 };
 
+static const char *ovl_redirect_mode_name(int redirect_mode)
+{
+	return ovl_parameter_redirect_dir[redirect_mode].name;
+}
+
 static const char *ovl_redirect_mode(struct ovl_config *config)
 {
-	return ovl_parameter_redirect_dir[config->redirect_mode].name;
+	return ovl_redirect_mode_name(config->redirect_mode);
 }
 
-static int ovl_redirect_mode_def(void)
+static int ovl_redirect_follow_mode(void)
 {
-	return ovl_redirect_dir_def	  ? OVL_REDIRECT_ON :
-	       ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
+	return ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
 					    OVL_REDIRECT_NOFOLLOW;
 }
 
+static int ovl_redirect_mode_def(void)
+{
+	return ovl_redirect_dir_def ? OVL_REDIRECT_ON :
+				      ovl_redirect_follow_mode();
+}
+
 static const struct constant_table ovl_parameter_verity[] = {
 	{ "off",	OVL_VERITY_OFF     },
 	{ "on",		OVL_VERITY_ON      },
@@ -659,11 +669,6 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		break;
 	case Opt_redirect_dir:
 		config->redirect_mode = result.uint_32;
-		if (config->redirect_mode == OVL_REDIRECT_OFF) {
-			config->redirect_mode = ovl_redirect_always_follow ?
-						OVL_REDIRECT_FOLLOW :
-						OVL_REDIRECT_NOFOLLOW;
-		}
 		ctx->set.redirect = true;
 		break;
 	case Opt_index:
@@ -819,7 +824,13 @@ int ovl_init_fs_context(struct fs_context *fc)
 	if (!ofs)
 		goto out_err;
 
-	ofs->config.redirect_mode	= ovl_redirect_mode_def();
+	/*
+	 * The module default determines only if new redirects are created in
+	 * upper dir.  If they are not, the redirect follow mode will be
+	 * determined after parsing mount options.
+	 */
+	ofs->config.redirect_mode	= ovl_redirect_dir_def ?
+					  OVL_REDIRECT_ON : OVL_REDIRECT_OFF;
 	ofs->config.index		= ovl_index_def;
 	ofs->config.uuid		= ovl_uuid_def();
 	ofs->config.nfs_export		= ovl_nfs_export_def;
@@ -877,6 +888,8 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			 struct ovl_config *config)
 {
 	struct ovl_opt_set set = ctx->set;
+	/* The requested redirect_dir=, for reporting conflicts with it */
+	int redirect_opt = config->redirect_mode;
 
 	/* Workdir/index are useless in non-upper mount */
 	if (!config->upperdir) {
@@ -903,6 +916,10 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		config->uuid = OVL_UUID_NULL;
 	}
 
+	/* Resolve redirect_dir=off to the default redirect follow mode */
+	if (config->redirect_mode == OVL_REDIRECT_OFF)
+		config->redirect_mode = ovl_redirect_follow_mode();
+
 	/*
 	 * This is to make the logic below simpler.  It doesn't make any other
 	 * difference, since redirect_dir=on is only used for upper.
@@ -914,7 +931,7 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON) {
 		if (set.metacopy && set.redirect) {
 			pr_err("conflicting options: metacopy=on,redirect_dir=%s\n",
-			       ovl_redirect_mode(config));
+			       ovl_redirect_mode_name(redirect_opt));
 			return -EINVAL;
 		}
 		if (set.redirect) {
@@ -923,7 +940,7 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			 * in this conflict.
 			 */
 			pr_info("disabling metacopy due to redirect_dir=%s\n",
-				ovl_redirect_mode(config));
+				ovl_redirect_mode_name(redirect_opt));
 			config->metacopy = false;
 		} else {
 			/* Automatically enable redirect otherwise. */
@@ -1000,7 +1017,7 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		if (set.redirect &&
 		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
 			pr_err("conflicting options: userxattr,redirect_dir=%s\n",
-			       ovl_redirect_mode(config));
+			       ovl_redirect_mode_name(redirect_opt));
 			return -EINVAL;
 		}
 		if (config->metacopy && set.metacopy) {
-- 
2.56.0

