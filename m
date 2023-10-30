Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0439CC4167B
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 12:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbjJ3MEf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJ3MEe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 08:04:34 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C6CCC
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 05:04:31 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c6b5841f61so18138451fa.0
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 05:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698667470; x=1699272270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2gaz+8ySPkjcai+MGhU1S3p8ECbq3qb5yzD7A9TrT0=;
        b=cP7W+UijCFGtVh+GbAj5JcevFT7cWCgbGFRfnsU06l9o+f3fptPw+1rqpLiKgumbLk
         dfc3fnNlZcXi2nqQ1I/mCzqX4CWUfiAodDgkHBLqXxG2i+J4wIT4PDcreqp5RhO/xwXG
         5qTUofAdokKUNluOkAh+4Vm0p6J4P3yeD1Rc1oa80sbCpXvtjzA99ScV3d/o4BylQADk
         Q5ft4vJVl/AUGt2x5urE/WNoML9fD14r4ls8AsQBqRmkotmA6iOToh4NFV015mFp0P8n
         YnS4qhVEKY6mnQlVfGuTtTX0F9zytryYzENcsjG/Ztjad+F4fRp5T2b/+ur5ufSppqne
         gEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698667470; x=1699272270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/2gaz+8ySPkjcai+MGhU1S3p8ECbq3qb5yzD7A9TrT0=;
        b=gq17rQeObj5D4tHq/vwpPxz0VODUIwXtCDmL0tS9Je7zuq5g12NYWS7oa6rbW+Wqt2
         exRoSQlO2Xub6/jBGFppvoJZKiK/FwxkJY3NDWPYrisaJwg1YnbcrHzNoCDYiluIqf0u
         dBZ5sZvBvumkIwpTBeaVjnVpZP0bVhowu10AVhHqw8sYWbjAS+70u67zekySoT0Cl3PP
         Sxe0D5WTwe4R9lGsY7HM6gSt1qn3PmoGaRREl9Ihy6xZ7O39NiOiOz2qvY6vvKlbpiB6
         m+O6MYDPVUsYZsgHfkStv+VHbdJNvO6c2ZhbEiwOSMg2iWbq1466agIGFm55nedUjha1
         hf6g==
X-Gm-Message-State: AOJu0YzI8CKWsSdrOig3D3kr8ZT36d+svXpVm1XsVzu6WuUMV5Q5DIvr
        BhHCJ+LP6BVE7Vm/k9DODIQ=
X-Google-Smtp-Source: AGHT+IEgQDUlKO3gNDleJb/Rbf4webBh57+waet7kMcF/UqpnJGYMzF3j1MTnEwF29FNq/iNuizr7g==
X-Received: by 2002:a2e:a442:0:b0:2bf:f861:f523 with SMTP id v2-20020a2ea442000000b002bff861f523mr3221119ljn.4.1698667469765;
        Mon, 30 Oct 2023 05:04:29 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l21-20020a2e7015000000b002b9e346a152sm1210753ljc.96.2023.10.30.05.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 05:04:29 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 3/4] ovl: refactor layer parsing helpers
Date:   Mon, 30 Oct 2023 14:04:18 +0200
Message-Id: <20231030120419.478228-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030120419.478228-1-amir73il@gmail.com>
References: <20231030120419.478228-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In preparation for new mount options to add lowerdirs one by one,
generalize ovl_parse_param_upperdir() into helper ovl_parse_layer()
with bool @upper argument that will be false for adding lower layers.

Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/r/CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/params.c | 116 ++++++++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 54 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 0bf754a69e91..9a9238eac730 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -43,7 +43,7 @@ module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
 MODULE_PARM_DESC(metacopy,
 		 "Default to on or off for the metadata only copy up feature");
 
-enum {
+enum ovl_opt {
 	Opt_lowerdir,
 	Opt_upperdir,
 	Opt_workdir,
@@ -238,19 +238,8 @@ static int ovl_mount_dir_noesc(const char *name, struct path *path)
 		pr_err("failed to resolve '%s': %i\n", name, err);
 		goto out;
 	}
-	err = -EINVAL;
-	if (ovl_dentry_weird(path->dentry)) {
-		pr_err("filesystem on '%s' not supported\n", name);
-		goto out_put;
-	}
-	if (!d_is_dir(path->dentry)) {
-		pr_err("'%s' not a directory\n", name);
-		goto out_put;
-	}
 	return 0;
 
-out_put:
-	path_put_init(path);
 out:
 	return err;
 }
@@ -268,7 +257,7 @@ static void ovl_unescape(char *s)
 	}
 }
 
-static int ovl_mount_dir(const char *name, struct path *path, bool upper)
+static int ovl_mount_dir(const char *name, struct path *path)
 {
 	int err = -ENOMEM;
 	char *tmp = kstrdup(name, GFP_KERNEL);
@@ -276,60 +265,81 @@ static int ovl_mount_dir(const char *name, struct path *path, bool upper)
 	if (tmp) {
 		ovl_unescape(tmp);
 		err = ovl_mount_dir_noesc(tmp, path);
-
-		if (!err && upper && path->dentry->d_flags & DCACHE_OP_REAL) {
-			pr_err("filesystem on '%s' not supported as upperdir\n",
-			       tmp);
-			path_put_init(path);
-			err = -EINVAL;
-		}
 		kfree(tmp);
 	}
 	return err;
 }
 
-static int ovl_parse_param_upperdir(const char *name, struct fs_context *fc,
-				    bool workdir)
+static int ovl_mount_dir_check(struct fs_context *fc, const struct path *path,
+			       enum ovl_opt layer, const char *name, bool upper)
 {
-	int err;
-	struct ovl_fs *ofs = fc->s_fs_info;
-	struct ovl_config *config = &ofs->config;
-	struct ovl_fs_context *ctx = fc->fs_private;
-	struct path path;
-	char *dup;
+	if (ovl_dentry_weird(path->dentry))
+		return invalfc(fc, "filesystem on %s not supported", name);
 
-	err = ovl_mount_dir(name, &path, true);
-	if (err)
-		return err;
+	if (!d_is_dir(path->dentry))
+		return invalfc(fc, "%s is not a directory", name);
 
 	/*
 	 * Check whether upper path is read-only here to report failures
 	 * early. Don't forget to recheck when the superblock is created
 	 * as the mount attributes could change.
 	 */
-	if (__mnt_is_readonly(path.mnt)) {
-		path_put(&path);
-		return -EINVAL;
+	if (upper) {
+		if (path->dentry->d_flags & DCACHE_OP_REAL)
+			return invalfc(fc, "filesystem not supported as %s", name);
+		if (__mnt_is_readonly(path->mnt))
+			return invalfc(fc, "%s is read-only", name);
 	}
+	return 0;
+}
 
-	dup = kstrdup(name, GFP_KERNEL);
-	if (!dup) {
-		path_put(&path);
-		return -ENOMEM;
-	}
+static void ovl_add_layer(struct fs_context *fc, enum ovl_opt layer,
+			 struct path *path, char **pname)
+{
+	struct ovl_fs *ofs = fc->s_fs_info;
+	struct ovl_config *config = &ofs->config;
+	struct ovl_fs_context *ctx = fc->fs_private;
 
-	if (workdir) {
-		kfree(config->workdir);
-		config->workdir = dup;
-		path_put(&ctx->work);
-		ctx->work = path;
-	} else {
-		kfree(config->upperdir);
-		config->upperdir = dup;
-		path_put(&ctx->upper);
-		ctx->upper = path;
+	switch (layer) {
+	case Opt_workdir:
+		swap(config->workdir, *pname);
+		swap(ctx->work, *path);
+		break;
+	case Opt_upperdir:
+		swap(config->upperdir, *pname);
+		swap(ctx->upper, *path);
+		break;
+	default:
+		WARN_ON(1);
 	}
-	return 0;
+}
+
+static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
+			   enum ovl_opt layer, bool upper)
+{
+	char *name = kstrdup(param->string, GFP_KERNEL);
+	struct path path;
+	int err;
+
+	if (!name)
+		return -ENOMEM;
+
+	err = ovl_mount_dir(name, &path);
+	if (err)
+		goto out_free;
+
+	err = ovl_mount_dir_check(fc, &path, layer, param->key, upper);
+	if (err)
+		goto out_put;
+
+	/* Store the user provided path string in ctx to show in mountinfo */
+	ovl_add_layer(fc, layer, &path, &name);
+
+out_put:
+	path_put(&path);
+out_free:
+	kfree(name);
+	return err;
 }
 
 static void ovl_reset_lowerdirs(struct ovl_fs_context *ctx)
@@ -417,7 +427,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	for (nr = 0; nr < nr_lower; nr++, l++) {
 		memset(l, 0, sizeof(*l));
 
-		err = ovl_mount_dir(iter, &l->path, false);
+		err = ovl_mount_dir(iter, &l->path);
 		if (err)
 			goto out_put;
 
@@ -505,10 +515,8 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		err = ovl_parse_param_lowerdir(param->string, fc);
 		break;
 	case Opt_upperdir:
-		fallthrough;
 	case Opt_workdir:
-		err = ovl_parse_param_upperdir(param->string, fc,
-					       (Opt_workdir == opt));
+		err = ovl_parse_layer(fc, param, opt, true);
 		break;
 	case Opt_default_permissions:
 		config->default_permissions = true;
-- 
2.34.1

