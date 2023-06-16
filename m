Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C97EB64D7
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 14:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjFPOTw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 10:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjFPOTv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 10:19:51 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D028230D3
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 07:19:49 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4f845060481so1032910e87.3
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686925188; x=1689517188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTvog0DZq300LY7obYnaDfA53Jo24wRUHy/TRWXdtPo=;
        b=bp8zKIt/hMXW5TpMqw5KLXyWqo3f7z3nNGHDnkiF0RqZRAguiqiR327pDqbPIbHS5+
         uUE3hJHN+Tt+r8LoQEPCwLolggn6gK02kM53hotKpfDlYq48cIFLxEvkGWjnSp6AQ9J6
         GbNdSZBBhBVqSZ5vFKCWV+Za+lhvLg/lK5evLSSbb+CKiOgN+6INi+qLd4ObyAQvrLwT
         2FAzTDMC2kZWDZ+mMHfSk+nbSo4fUYNMDnfLRIc7yzxWER1tM2CyitwxdPvSLoqRVWZX
         d+JDWEnI5+gZyA2W+2a2YYve26ksxS4Y86LgaC+KVmJtrFkUF3ohGhctHcYyMdvdbcgK
         M+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686925188; x=1689517188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tTvog0DZq300LY7obYnaDfA53Jo24wRUHy/TRWXdtPo=;
        b=KAD2ebfQ+MEqqPdT5LZwXAS9UaObeem0EjkdSSBFp/P8FhBVcLvxEcnAm2JzXNXXK1
         8hUEv8S/hPorvqT83tC0dIBwsPm9kR6TBLWc2vg8PFxrRP+83kF2kDhT4mwClzhl7Jpl
         mT9mX+xqCk47hAKO2mRrqyb6FDhF8T1ehUdJxxsLiS5p4oZXk2gm4ahN86m499S8hPEI
         pjDWtrXUy0NRWR+L5yYPU0fKjRKFbad7Vnj8x8XclFjpNz412Dtgr926WgPnj01H9jfR
         Kbq6/D15G4AadUZXRjLxDvuFrT8vYlK5dYPb+HBKmkKqJjdHDawj2EwNIydp3OypAX4L
         SIPQ==
X-Gm-Message-State: AC+VfDw6tYJUqJCI4emvL8+7cNyJ97RaMbW5ZXtt5SGDUhsWzgzzji6U
        Gr4dajLmJnGrdb18zlYPypFF0Qm8E6I=
X-Google-Smtp-Source: ACHHUZ7c9pWZ/a787QdejVqEt+mMzesl909H26lAgxTZn2+hy7dTItGQTmTorrkX5jkPV9BgqKN2Kw==
X-Received: by 2002:a19:e601:0:b0:4f6:2846:b1fb with SMTP id d1-20020a19e601000000b004f62846b1fbmr1511339lfh.18.1686925187659;
        Fri, 16 Jun 2023 07:19:47 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a05600c0b5100b003f7ec896cefsm2399269wmr.8.2023.06.16.07.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 07:19:47 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 2/2] ovl: factor out ovl_parse_options() helper
Date:   Fri, 16 Jun 2023 17:19:41 +0300
Message-Id: <20230616141941.2402664-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616141941.2402664-1-amir73il@gmail.com>
References: <20230616141941.2402664-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

For parsing a single mount option.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |   8 ++
 fs/overlayfs/super.c     | 243 ++++++++++++++++++++-------------------
 2 files changed, 135 insertions(+), 116 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e689520e3eca..8c1ab071022f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -70,6 +70,14 @@ enum {
 	OVL_XINO_ON,
 };
 
+/* The set of options that user requested explicitly via mount options */
+struct ovl_opt_set {
+	bool metacopy;
+	bool redirect;
+	bool nfs_export;
+	bool index;
+};
+
 /*
  * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
  * where:
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index cc7d7d8af711..41459ae41c9c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -514,131 +514,142 @@ static char *ovl_next_opt(char **s)
 	return sbegin;
 }
 
-static int ovl_parse_opt(char *opt, struct ovl_config *config)
+static int ovl_parse_opt(char *opt, struct ovl_config *config,
+			 struct ovl_opt_set *set)
 {
-	char *p;
-	bool metacopy_opt = false, redirect_opt = false;
-	bool nfs_export_opt = false, index_opt = false;
-
-	while ((p = ovl_next_opt(&opt)) != NULL) {
-		int token;
-		substring_t args[MAX_OPT_ARGS];
-
-		if (!*p)
-			continue;
+	int err = 0;
+	int token;
+	substring_t args[MAX_OPT_ARGS];
 
-		token = match_token(p, ovl_tokens, args);
-		switch (token) {
-		case OPT_UPPERDIR:
-			kfree(config->upperdir);
-			config->upperdir = match_strdup(&args[0]);
-			if (!config->upperdir)
-				return -ENOMEM;
-			break;
+	if (!*opt)
+		return 0;
 
-		case OPT_LOWERDIR:
-			kfree(config->lowerdir);
-			config->lowerdir = match_strdup(&args[0]);
-			if (!config->lowerdir)
-				return -ENOMEM;
-			break;
+	token = match_token(opt, ovl_tokens, args);
+	switch (token) {
+	case OPT_UPPERDIR:
+		kfree(config->upperdir);
+		config->upperdir = match_strdup(&args[0]);
+		if (!config->upperdir)
+			return -ENOMEM;
+		break;
+
+	case OPT_LOWERDIR:
+		kfree(config->lowerdir);
+		config->lowerdir = match_strdup(&args[0]);
+		if (!config->lowerdir)
+			return -ENOMEM;
+		break;
+
+	case OPT_WORKDIR:
+		kfree(config->workdir);
+		config->workdir = match_strdup(&args[0]);
+		if (!config->workdir)
+			return -ENOMEM;
+		break;
+
+	case OPT_DEFAULT_PERMISSIONS:
+		config->default_permissions = true;
+		break;
+
+	case OPT_REDIRECT_DIR_ON:
+		config->redirect_mode = OVL_REDIRECT_ON;
+		set->redirect = true;
+		break;
+
+	case OPT_REDIRECT_DIR_OFF:
+		config->redirect_mode = ovl_redirect_always_follow ?
+			OVL_REDIRECT_FOLLOW :
+			OVL_REDIRECT_NOFOLLOW;
+		set->redirect = true;
+		break;
+
+	case OPT_REDIRECT_DIR_FOLLOW:
+		config->redirect_mode = OVL_REDIRECT_FOLLOW;
+		set->redirect = true;
+		break;
+
+	case OPT_REDIRECT_DIR_NOFOLLOW:
+		config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
+		set->redirect = true;
+		break;
 
-		case OPT_WORKDIR:
-			kfree(config->workdir);
-			config->workdir = match_strdup(&args[0]);
-			if (!config->workdir)
-				return -ENOMEM;
-			break;
+	case OPT_INDEX_ON:
+		config->index = true;
+		set->index = true;
+		break;
 
-		case OPT_DEFAULT_PERMISSIONS:
-			config->default_permissions = true;
-			break;
+	case OPT_INDEX_OFF:
+		config->index = false;
+		set->index = true;
+		break;
 
-		case OPT_REDIRECT_DIR_ON:
-			config->redirect_mode = OVL_REDIRECT_ON;
-			redirect_opt = true;
-			break;
+	case OPT_UUID_ON:
+		config->uuid = true;
+		break;
 
-		case OPT_REDIRECT_DIR_OFF:
-			config->redirect_mode = ovl_redirect_always_follow ?
-						OVL_REDIRECT_FOLLOW :
-						OVL_REDIRECT_NOFOLLOW;
-			redirect_opt = true;
-			break;
+	case OPT_UUID_OFF:
+		config->uuid = false;
+		break;
 
-		case OPT_REDIRECT_DIR_FOLLOW:
-			config->redirect_mode = OVL_REDIRECT_FOLLOW;
-			redirect_opt = true;
-			break;
+	case OPT_NFS_EXPORT_ON:
+		config->nfs_export = true;
+		set->nfs_export = true;
+		break;
 
-		case OPT_REDIRECT_DIR_NOFOLLOW:
-			config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
-			redirect_opt = true;
-			break;
+	case OPT_NFS_EXPORT_OFF:
+		config->nfs_export = false;
+		set->nfs_export = true;
+		break;
 
-		case OPT_INDEX_ON:
-			config->index = true;
-			index_opt = true;
-			break;
+	case OPT_XINO_ON:
+		config->xino = OVL_XINO_ON;
+		break;
 
-		case OPT_INDEX_OFF:
-			config->index = false;
-			index_opt = true;
-			break;
+	case OPT_XINO_OFF:
+		config->xino = OVL_XINO_OFF;
+		break;
 
-		case OPT_UUID_ON:
-			config->uuid = true;
-			break;
+	case OPT_XINO_AUTO:
+		config->xino = OVL_XINO_AUTO;
+		break;
 
-		case OPT_UUID_OFF:
-			config->uuid = false;
-			break;
+	case OPT_METACOPY_ON:
+		config->metacopy = true;
+		set->metacopy = true;
+		break;
 
-		case OPT_NFS_EXPORT_ON:
-			config->nfs_export = true;
-			nfs_export_opt = true;
-			break;
-
-		case OPT_NFS_EXPORT_OFF:
-			config->nfs_export = false;
-			nfs_export_opt = true;
-			break;
-
-		case OPT_XINO_ON:
-			config->xino = OVL_XINO_ON;
-			break;
-
-		case OPT_XINO_OFF:
-			config->xino = OVL_XINO_OFF;
-			break;
+	case OPT_METACOPY_OFF:
+		config->metacopy = false;
+		set->metacopy = true;
+		break;
 
-		case OPT_XINO_AUTO:
-			config->xino = OVL_XINO_AUTO;
-			break;
+	case OPT_VOLATILE:
+		config->ovl_volatile = true;
+		break;
 
-		case OPT_METACOPY_ON:
-			config->metacopy = true;
-			metacopy_opt = true;
-			break;
+	case OPT_USERXATTR:
+		config->userxattr = true;
+		break;
 
-		case OPT_METACOPY_OFF:
-			config->metacopy = false;
-			metacopy_opt = true;
-			break;
+	default:
+		pr_err("unrecognized mount option \"%s\" or missing value\n",
+		       opt);
+		return -EINVAL;
+	}
 
-		case OPT_VOLATILE:
-			config->ovl_volatile = true;
-			break;
+	return err;
+}
 
-		case OPT_USERXATTR:
-			config->userxattr = true;
-			break;
+static int ovl_parse_options(char *opt, struct ovl_config *config)
+{
+	char *p;
+	int err;
+	struct ovl_opt_set set = {};
 
-		default:
-			pr_err("unrecognized mount option \"%s\" or missing value\n",
-					p);
-			return -EINVAL;
-		}
+	while ((p = ovl_next_opt(&opt)) != NULL) {
+		err = ovl_parse_opt(p, config, &set);
+		if (err)
+			return err;
 	}
 
 	/* Workdir/index are useless in non-upper mount */
@@ -649,9 +660,9 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			kfree(config->workdir);
 			config->workdir = NULL;
 		}
-		if (config->index && index_opt) {
+		if (config->index && set.index) {
 			pr_info("option \"index=on\" is useless in a non-upper mount, ignore\n");
-			index_opt = false;
+			set.index = false;
 		}
 		config->index = false;
 	}
@@ -670,12 +681,12 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 	/* Resolve metacopy -> redirect_dir dependency */
 	if (config->metacopy && !config->redirect_mode != OVL_REDIRECT_ON) {
-		if (metacopy_opt && redirect_opt) {
+		if (set.metacopy && set.redirect) {
 			pr_err("conflicting options: metacopy=on,redirect_dir=%s\n",
 			       ovl_redirect_mode(config));
 			return -EINVAL;
 		}
-		if (redirect_opt) {
+		if (set.redirect) {
 			/*
 			 * There was an explicit redirect_dir=... that resulted
 			 * in this conflict.
@@ -695,10 +706,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
 			pr_info("NFS export requires \"redirect_dir=nofollow\" on non-upper mount, falling back to nfs_export=off.\n");
 			config->nfs_export = false;
-		} else if (nfs_export_opt && index_opt) {
+		} else if (set.nfs_export && set.index) {
 			pr_err("conflicting options: nfs_export=on,index=off\n");
 			return -EINVAL;
-		} else if (index_opt) {
+		} else if (set.index) {
 			/*
 			 * There was an explicit index=off that resulted
 			 * in this conflict.
@@ -713,11 +724,11 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 	/* Resolve nfs_export -> !metacopy dependency */
 	if (config->nfs_export && config->metacopy) {
-		if (nfs_export_opt && metacopy_opt) {
+		if (set.nfs_export && set.metacopy) {
 			pr_err("conflicting options: nfs_export=on,metacopy=on\n");
 			return -EINVAL;
 		}
-		if (metacopy_opt) {
+		if (set.metacopy) {
 			/*
 			 * There was an explicit metacopy=on that resulted
 			 * in this conflict.
@@ -737,13 +748,13 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 	/* Resolve userxattr -> !redirect && !metacopy dependency */
 	if (config->userxattr) {
-		if (redirect_opt &&
+		if (set.redirect &&
 		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
 			pr_err("conflicting options: userxattr,redirect_dir=%s\n",
 			       ovl_redirect_mode(config));
 			return -EINVAL;
 		}
-		if (config->metacopy && metacopy_opt) {
+		if (config->metacopy && set.metacopy) {
 			pr_err("conflicting options: userxattr,metacopy=on\n");
 			return -EINVAL;
 		}
@@ -1982,7 +1993,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
 	ofs->config.metacopy = ovl_metacopy_def;
-	err = ovl_parse_opt((char *) data, &ofs->config);
+	err = ovl_parse_options((char *) data, &ofs->config);
 	if (err)
 		goto out_err;
 
-- 
2.34.1

