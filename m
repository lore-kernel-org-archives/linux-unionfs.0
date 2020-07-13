Return-Path: <SRS0=r5kD=AY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 109F4C433E4
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 14:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5DBE2072D
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 14:19:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fn/5AGH9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbgGMOT6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 10:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMOT6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 10:19:58 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4467AC061755
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 07:19:58 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l2so13346889wmf.0
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 07:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1WLhOB9PzKPta2ftgYeuCUWbc4QSl4ovVQAAeLd63xE=;
        b=Fn/5AGH9py4YxWQ4FsYD4as345eyBaCgft6UOYtecO4pC+1uqbhvimKJmXcwYhY1WT
         sAdBHS3YZwWGrMjhCIeE8xOSJoMtNkUvgyHxNCW1hRn1nu5did0uD4OaTnANUIWqlxav
         Jl5s4GqSvu1MxyGsQtMqr2HHAxq1xPwhswCkxLOGvKAVB9+ScQo7FJDB3H6m07D40kkR
         uB55e1h1jvCIwdEMx6nP7dv0UYK2zkLb9QlB2X9MFt/rH20LQnUjzGBn0j1szJcfR+dv
         KDdA4NotrDoaqL7tpaHsln9YhRT5QMCFROsaeQwZ+KpVE2RqZDLzRAzau0qh09qUiV7+
         9FlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1WLhOB9PzKPta2ftgYeuCUWbc4QSl4ovVQAAeLd63xE=;
        b=Ne9dugUEJXUHAiCcCzTzcKT6L6QCphRhLfGiS6n8j3ubnvf4RJaOSQSg/DB4zdiK+0
         4tOV5u3KlqFrDY9SILg3iJ9XH4q3zKL7g6RxPGgtcYg+wUUEdvkfKIB9Cl58h5i/cOKe
         9uVnVeD3p8sSyEsqYJmY8OpyaASpXzvKuDJ/s4mZGKEQBjRHJ/h4i1/UdcmX4+36HosK
         fOG6gVix3AJiLLiOj6Swn+eCrTVhkRLHOD6S8o8IwiIA7naxYY/2auhdr31o3NdwhNmp
         jN6M4sV60FBfnwPycuCSJYvqW+ag0fkdcZApEaTYJZZTH4jVxsePBN6LtG06KsQAeEjH
         if6A==
X-Gm-Message-State: AOAM532+inlL2rq2QbhLI5y7IfLTgsu3bNwaTdBoQyRGGs2/nIXXZkIS
        KuU0OIXglNlMJTLzxFTJcz8=
X-Google-Smtp-Source: ABdhPJw70j0of1pIW+v8FiyNPJN5lWAvgXpZ59L7S7BdasLY+UlHdp7GBNy88AYlwMzZYopSXOkjgg==
X-Received: by 2002:a1c:720e:: with SMTP id n14mr211227wmc.144.1594649996983;
        Mon, 13 Jul 2020 07:19:56 -0700 (PDT)
Received: from localhost.localdomain ([141.226.183.23])
        by smtp.gmail.com with ESMTPSA id 1sm21681024wmf.21.2020.07.13.07.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:19:56 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 2/3] ovl: fix mount option checks for nfs_export with no upperdir
Date:   Mon, 13 Jul 2020 17:19:44 +0300
Message-Id: <20200713141945.11719-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713141945.11719-1-amir73il@gmail.com>
References: <20200713141945.11719-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Without upperdir mount option, there is no index dir and the dependency
checks nfs_export => index for mount options parsing are incorrect.

Allow the combination nfs_export=on,index=off with no upperdir and move
the check for dependency redirect_dir=nofollow for non-upper mount case
to mount options parsing.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst |  4 ++--
 fs/overlayfs/super.c                    | 31 ++++++++++++++-----------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 660dbaf0b9b8..fcda5d6ba9ac 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -560,8 +560,8 @@ When the NFS export feature is enabled, all directory index entries are
 verified on mount time to check that upper file handles are not stale.
 This verification may cause significant overhead in some cases.
 
-Note: the mount options index=off,nfs_export=on are conflicting and will
-result in an error.
+Note: the mount options index=off,nfs_export=on are conflicting for a
+read-write mount and will result in an error.
 
 
 Testsuite
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 41d7fe2b8129..3c8b48a2766b 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -602,12 +602,19 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		}
 	}
 
-	/* Workdir is useless in non-upper mount */
-	if (!config->upperdir && config->workdir) {
-		pr_info("option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
-			config->workdir);
-		kfree(config->workdir);
-		config->workdir = NULL;
+	/* Workdir/index are useless in non-upper mount */
+	if (!config->upperdir) {
+		if (config->workdir) {
+			pr_info("option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
+				config->workdir);
+			kfree(config->workdir);
+			config->workdir = NULL;
+		}
+		if (config->index && index_opt) {
+			pr_info("option \"index=on\" is useless in a non-upper mount, ignore\n");
+			index_opt = false;
+		}
+		config->index = false;
 	}
 
 	err = ovl_parse_redirect_mode(config, config->redirect_mode);
@@ -644,11 +651,13 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 	/* Resolve nfs_export -> index dependency */
 	if (config->nfs_export && !config->index) {
-		if (nfs_export_opt && index_opt) {
+		if (!config->upperdir && config->redirect_follow) {
+			pr_info("NFS export requires \"redirect_dir=nofollow\" on non-upper mount, falling back to nfs_export=off.\n");
+			config->nfs_export = false;
+		} else if (nfs_export_opt && index_opt) {
 			pr_err("conflicting options: nfs_export=on,index=off\n");
 			return -EINVAL;
-		}
-		if (index_opt) {
+		} else if (index_opt) {
 			/*
 			 * There was an explicit index=off that resulted
 			 * in this conflict.
@@ -1616,10 +1625,6 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	if (!ofs->config.upperdir && numlower == 1) {
 		pr_err("at least 2 lowerdir are needed while upperdir nonexistent\n");
 		return ERR_PTR(-EINVAL);
-	} else if (!ofs->config.upperdir && ofs->config.nfs_export &&
-		   ofs->config.redirect_follow) {
-		pr_warn("NFS export requires \"redirect_dir=nofollow\" on non-upper mount, falling back to nfs_export=off.\n");
-		ofs->config.nfs_export = false;
 	}
 
 	stack = kcalloc(numlower, sizeof(struct path), GFP_KERNEL);
-- 
2.17.1

