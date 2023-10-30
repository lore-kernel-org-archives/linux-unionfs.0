Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C5BC4332F
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 12:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjJ3MEd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJ3MEd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 08:04:33 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CCEC6
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 05:04:30 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2c514cbbe7eso61355551fa.1
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 05:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698667469; x=1699272269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oca5LODFKYE3tkV1QMBGksQBXtAC5RQvjou3kBqfbUw=;
        b=gPjvDfzePSF/+/RhT9ZJvMi3dzsDU4AnxoAttXnzsYKnBzxrfNGy6pjRZoeTSLK09G
         eD4V6u5rJV5wETo1XL5caCMOK/UBp0tqKFVzMkfF0jIxsMkbBXF+yrrmWnWkm5B3AkNS
         HpljslLBu88dXUC/VRqM5VkKiR6QhZ+AXA85M4ggrLPBpAI078s+aULrxtCvmFJVe9B7
         sUk+VQLE2R0mL81vCfjOuhi+CrFOn1qLcE+z1VIHZ3cNhYZi1ax+FgvDc+jw+sUgFoIa
         FZHqyBgpCbvXlj5/FjRdcTpkwVMW8bfztgUWiPsTs2eZ5YDOSHhS+TcasfKBjRTTp+kN
         sFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698667469; x=1699272269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oca5LODFKYE3tkV1QMBGksQBXtAC5RQvjou3kBqfbUw=;
        b=gDAitB5w1C7DKorBlMPa4jUWB1r88oVS7Nm4sm4fuBW7mq9Dl/aYyP+bFx8NYtV1MQ
         o7YzcV90XqsYhQWJPlSbjTjS9l2dlkTzEKQyGQaD06emsC9QBcCzS+JavQPzDIXbYYpE
         pj5sn9J0xiU7IeZ0DyEK+C/3WXl9z2eI8RG4Bx8RXDFK5+hDIDa3uVDnQ8lwaSFVl1y1
         UadeTglfv0h1SxVS0SHdlGkuEceu5/YB8FXO0iqbFs5mKCzmiL6EccSLD0eJXbSy7HQf
         //AuzOBxLS0Pu/ZCTDIv5/bcrBj662w3WLHLsZ5U05OJpBdAJbY0ey02SMKmWLjWx9Lv
         fJzA==
X-Gm-Message-State: AOJu0YwwUvGL50uccbCyL1HrpFi2pSLu2l5sHFO8lpFXLIj6g98iGAeK
        AOKim/XNKrSFwv1CMFz4R21ZUF5EcHA=
X-Google-Smtp-Source: AGHT+IFqtuY3I8z2DfPGRwVigsJ4wr9X2dpah4GigW770UahaVS5c/C7i9c2SxGfx7tPuLRWvNtMAQ==
X-Received: by 2002:a2e:9852:0:b0:2bf:f6f6:9fd9 with SMTP id e18-20020a2e9852000000b002bff6f69fd9mr7090437ljj.0.1698667468430;
        Mon, 30 Oct 2023 05:04:28 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l21-20020a2e7015000000b002b9e346a152sm1210753ljc.96.2023.10.30.05.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 05:04:27 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 2/4] ovl: store and show the user provided lowerdir mount option
Date:   Mon, 30 Oct 2023 14:04:17 +0200
Message-Id: <20231030120419.478228-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030120419.478228-1-amir73il@gmail.com>
References: <20231030120419.478228-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

We are about to add new mount options for adding lowerdir one by one,
but those mount options will not support escaping.

For the existing case, where lowerdir mount option is provided as a colon
separated list, store the user provided (possibly escaped) string and
display it as is when showing the lowerdir mount option.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/params.c | 46 +++++++++++++++++++++----------------------
 fs/overlayfs/params.h |  1 +
 fs/overlayfs/super.c  |  5 ++++-
 3 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 0059cc405159..0bf754a69e91 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -332,12 +332,18 @@ static int ovl_parse_param_upperdir(const char *name, struct fs_context *fc,
 	return 0;
 }
 
-static void ovl_parse_param_drop_lowerdir(struct ovl_fs_context *ctx)
+static void ovl_reset_lowerdirs(struct ovl_fs_context *ctx)
 {
-	for (size_t nr = 0; nr < ctx->nr; nr++) {
-		path_put(&ctx->lower[nr].path);
-		kfree(ctx->lower[nr].name);
-		ctx->lower[nr].name = NULL;
+	struct ovl_fs_context_layer *l = ctx->lower;
+
+	// Reset old user provided lowerdir string
+	kfree(ctx->lowerdir_all);
+	ctx->lowerdir_all = NULL;
+
+	for (size_t nr = 0; nr < ctx->nr; nr++, l++) {
+		path_put(&l->path);
+		kfree(l->name);
+		l->name = NULL;
 	}
 	ctx->nr = 0;
 	ctx->nr_data = 0;
@@ -366,7 +372,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	 */
 
 	/* drop all existing lower layers */
-	ovl_parse_param_drop_lowerdir(ctx);
+	ovl_reset_lowerdirs(ctx);
 
 	if (!*name)
 		return 0;
@@ -376,6 +382,11 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 		return -EINVAL;
 	}
 
+	// Store user provided lowerdir string to show in mount options
+	ctx->lowerdir_all = kstrdup(name, GFP_KERNEL);
+	if (!ctx->lowerdir_all)
+		return -ENOMEM;
+
 	dup = kstrdup(name, GFP_KERNEL);
 	if (!dup)
 		return -ENOMEM;
@@ -448,7 +459,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	return 0;
 
 out_put:
-	ovl_parse_param_drop_lowerdir(ctx);
+	ovl_reset_lowerdirs(ctx);
 
 out_err:
 	kfree(dup);
@@ -554,7 +565,7 @@ static int ovl_get_tree(struct fs_context *fc)
 
 static inline void ovl_fs_context_free(struct ovl_fs_context *ctx)
 {
-	ovl_parse_param_drop_lowerdir(ctx);
+	ovl_reset_lowerdirs(ctx);
 	path_put(&ctx->upper);
 	path_put(&ctx->work);
 	kfree(ctx->lower);
@@ -870,24 +881,13 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 {
 	struct super_block *sb = dentry->d_sb;
 	struct ovl_fs *ofs = OVL_FS(sb);
-	size_t nr, nr_merged_lower = ofs->numlayer - ofs->numdatalayer;
+	char **lowerdirs = ofs->config.lowerdirs;
 
 	/*
-	 * lowerdirs[] starts from offset 1, then
-	 * >= 0 regular lower layers prefixed with : and
-	 * >= 0 data-only lower layers prefixed with ::
-	 *
-	 * we need to escase comma and space like seq_show_option() does and
-	 * we also need to escape the colon separator from lowerdir paths.
+	 * lowerdirs[0] holds the colon separated list that user provided
+	 * with lowerdir mount option.
 	 */
-	seq_puts(m, ",lowerdir=");
-	for (nr = 1; nr < ofs->numlayer; nr++) {
-		if (nr > 1)
-			seq_putc(m, ':');
-		if (nr >= nr_merged_lower)
-			seq_putc(m, ':');
-		seq_escape(m, ofs->config.lowerdirs[nr], ":, \t\n\\");
-	}
+	seq_show_option(m, "lowerdir", lowerdirs[0]);
 	if (ofs->config.upperdir) {
 		seq_show_option(m, "upperdir", ofs->config.upperdir);
 		seq_show_option(m, "workdir", ofs->config.workdir);
diff --git a/fs/overlayfs/params.h b/fs/overlayfs/params.h
index 8750da68ab2a..c96d93982021 100644
--- a/fs/overlayfs/params.h
+++ b/fs/overlayfs/params.h
@@ -32,6 +32,7 @@ struct ovl_fs_context {
 	size_t nr_data;
 	struct ovl_opt_set set;
 	struct ovl_fs_context_layer *lower;
+	char *lowerdir_all; /* user provided lowerdir string */
 };
 
 int ovl_init_fs_context(struct fs_context *fc);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 60bd7331e20f..26bb429c78dc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1320,8 +1320,11 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	ofs->layers = layers;
 	/*
 	 * Layer 0 is reserved for upper even if there's no upper.
-	 * For consistency, config.lowerdirs[0] is NULL.
+	 * config.lowerdirs[0] is used for storing the user provided colon
+	 * separated lowerdir string.
 	 */
+	ofs->config.lowerdirs[0] = ctx->lowerdir_all;
+	ctx->lowerdir_all = NULL;
 	ofs->numlayer = 1;
 
 	sb->s_stack_depth = 0;
-- 
2.34.1

