Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DEDC4332F
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 12:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjJ3MEg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjJ3MEf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 08:04:35 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D5CC6
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 05:04:33 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2c50fbc218bso60327191fa.3
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 05:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698667471; x=1699272271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rPoWK/oN4wCS+36bjhF8mAATb2NYKzbuqs0466xxHEQ=;
        b=X393bOZ27d2UMb9b7zKcA6AZ3rPGAFViBr7o0aHOdAo1fcA+wE2RluCsphEgR1ZATL
         a+hQo9+9S4mcuJEpgw3xmc4ZiI1O7Yz3mP3ozRiJpimvNRXLzBH1ek6NhQg7EPfXaCXW
         Whd8m4l3zcYNj6qK8kURuGM2RB5TV2eQmfeUsKVnUqm5tJhX+Dk3JND7pvVC803+xEnT
         Vlq6AXbYUD5vaqMm1awHEzlW1XE5l7kmCJzq225YXBmVgxBdoT8Ca9CTM3QOdf/kLboh
         yf2q7qHLEamBYPWpcUOKL+DHG5R0twNkUFbvLJLsI+koXGAAAuQIIzRKzir7y9y1zuc7
         aSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698667471; x=1699272271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rPoWK/oN4wCS+36bjhF8mAATb2NYKzbuqs0466xxHEQ=;
        b=H1+5cMMEo77n4zi0gToKYChiJw6xfJ8EUCoyL8LrKYXjcZyeM1KpoJTQ48FLNlB6ad
         0E5J4j9/+tbBp2yi8nmFeOSwL6SeyMKUUATT0pQPW7uLPqZDWTkfGorMRFyEuWo2YxwT
         bkuwO1nvhC0+vW2ACpPnU/l6E0NRmQMx4skoXajdqkWOCUhWZ8m+MCqXwegS6/hWQtpt
         gWVJVQrBW3w1JIlDbn6WtXnNALDiVA82ecM9wnyab5ZbqNkrGezJPHPbFDrupzucJC4N
         LG3JJPMuRMzhEM1Tqg66+SaguL1dlVtHAlgWYmNmk8PIczCsWphNsYd8hy3hptDbG5hn
         x1+Q==
X-Gm-Message-State: AOJu0YzsT81atCB3O1gqpBkQi2C4spsa3lNzb01owof9U2ZzbzLQ406r
        fm3DlGCPWyUcKgez+8jkf/o=
X-Google-Smtp-Source: AGHT+IGN7jB1bgJr1TZn72+IJjk5kwHYiCXwyXnx8gbhM1JhTZdmjyvcy2H7rUmRjdNKYaKKjNHm7Q==
X-Received: by 2002:a2e:a789:0:b0:2c5:18ed:180a with SMTP id c9-20020a2ea789000000b002c518ed180amr8267426ljf.33.1698667471032;
        Mon, 30 Oct 2023 05:04:31 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l21-20020a2e7015000000b002b9e346a152sm1210753ljc.96.2023.10.30.05.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 05:04:30 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 4/4] ovl: add support for appending lowerdirs one by one
Date:   Mon, 30 Oct 2023 14:04:19 +0200
Message-Id: <20231030120419.478228-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030120419.478228-1-amir73il@gmail.com>
References: <20231030120419.478228-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Add new mount options lowerdir+ and datadir+ that can be used to add
layers to lower layers stack one by one.

Unlike the legacy lowerdir mount option, special characters (i.e. colons
and cammas) are not unescaped with these new mount options.

The new mount options can be repeated to compose a large stack of lower
layers, but they may not be mixed with the lagacy lowerdir mount option,
because for displaying lower layers in mountinfo, we do not want to mix
escaped with unescaped lower layers path syntax.

Similar to data-only layer rules with the lowerdir mount option, the
datadir+ option must follow at least one lowerdir+ option and the
lowerdir+ option must not follow the datadir+ option.

If the legacy lowerdir mount option follows lowerdir+ and datadir+
mount options, it overrides them.  Sepcifically, calling:

  fsconfig(FSCONFIG_SET_STRING, "lowerdir", "", 0);

can be used to reset previously setup lower layers.

Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/r/CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/params.c | 78 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 9a9238eac730..1c390e93d060 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -45,6 +45,8 @@ MODULE_PARM_DESC(metacopy,
 
 enum ovl_opt {
 	Opt_lowerdir,
+	Opt_lowerdir_add,
+	Opt_datadir_add,
 	Opt_upperdir,
 	Opt_workdir,
 	Opt_default_permissions,
@@ -140,8 +142,11 @@ static int ovl_verity_mode_def(void)
 #define fsparam_string_empty(NAME, OPT) \
 	__fsparam(fs_param_is_string, NAME, OPT, fs_param_can_be_empty, NULL)
 
+
 const struct fs_parameter_spec ovl_parameter_spec[] = {
 	fsparam_string_empty("lowerdir",    Opt_lowerdir),
+	fsparam_string("lowerdir+",         Opt_lowerdir_add),
+	fsparam_string("datadir+",          Opt_datadir_add),
 	fsparam_string("upperdir",          Opt_upperdir),
 	fsparam_string("workdir",           Opt_workdir),
 	fsparam_flag("default_permissions", Opt_default_permissions),
@@ -273,6 +278,8 @@ static int ovl_mount_dir(const char *name, struct path *path)
 static int ovl_mount_dir_check(struct fs_context *fc, const struct path *path,
 			       enum ovl_opt layer, const char *name, bool upper)
 {
+	struct ovl_fs_context *ctx = fc->fs_private;
+
 	if (ovl_dentry_weird(path->dentry))
 		return invalfc(fc, "filesystem on %s not supported", name);
 
@@ -289,16 +296,44 @@ static int ovl_mount_dir_check(struct fs_context *fc, const struct path *path,
 			return invalfc(fc, "filesystem not supported as %s", name);
 		if (__mnt_is_readonly(path->mnt))
 			return invalfc(fc, "%s is read-only", name);
+	} else {
+		if (ctx->lowerdir_all)
+			return invalfc(fc, "%s cannot follow lowerdir mount option", name);
+		if (ctx->nr_data && layer == Opt_lowerdir_add)
+			return invalfc(fc, "regular lower layers cannot follow data layers");
+		if (ctx->nr == OVL_MAX_STACK)
+			return invalfc(fc, "too many lower directories, limit is %d",
+				       OVL_MAX_STACK);
 	}
 	return 0;
 }
 
+static int ovl_ctx_realloc_lower(struct fs_context *fc)
+{
+	struct ovl_fs_context *ctx = fc->fs_private;
+	struct ovl_fs_context_layer *l;
+	size_t nr;
+
+	if (ctx->nr < ctx->capacity)
+		return 0;
+
+	nr = min(max(4096 / sizeof(*l), ctx->capacity * 2), (size_t) OVL_MAX_STACK);
+	l = krealloc_array(ctx->lower, nr, sizeof(*l), GFP_KERNEL_ACCOUNT);
+	if (!l)
+		return -ENOMEM;
+
+	ctx->lower = l;
+	ctx->capacity = nr;
+	return 0;
+}
+
 static void ovl_add_layer(struct fs_context *fc, enum ovl_opt layer,
 			 struct path *path, char **pname)
 {
 	struct ovl_fs *ofs = fc->s_fs_info;
 	struct ovl_config *config = &ofs->config;
 	struct ovl_fs_context *ctx = fc->fs_private;
+	struct ovl_fs_context_layer *l;
 
 	switch (layer) {
 	case Opt_workdir:
@@ -309,6 +344,16 @@ static void ovl_add_layer(struct fs_context *fc, enum ovl_opt layer,
 		swap(config->upperdir, *pname);
 		swap(ctx->upper, *path);
 		break;
+	case Opt_datadir_add:
+		ctx->nr_data++;
+		fallthrough;
+	case Opt_lowerdir_add:
+		WARN_ON(ctx->nr >= ctx->capacity);
+		l = &ctx->lower[ctx->nr++];
+		memset(l, 0, sizeof(*l));
+		swap(l->name, *pname);
+		swap(l->path, *path);
+		break;
 	default:
 		WARN_ON(1);
 	}
@@ -324,7 +369,10 @@ static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
 	if (!name)
 		return -ENOMEM;
 
-	err = ovl_mount_dir(name, &path);
+	if (upper)
+		err = ovl_mount_dir(name, &path);
+	else
+		err = ovl_mount_dir_noesc(name, &path);
 	if (err)
 		goto out_free;
 
@@ -332,6 +380,12 @@ static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
 	if (err)
 		goto out_put;
 
+	if (!upper) {
+		err = ovl_ctx_realloc_lower(fc);
+		if (err)
+			goto out_put;
+	}
+
 	/* Store the user provided path string in ctx to show in mountinfo */
 	ovl_add_layer(fc, layer, &path, &name);
 
@@ -514,6 +568,10 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_lowerdir:
 		err = ovl_parse_param_lowerdir(param->string, fc);
 		break;
+	case Opt_lowerdir_add:
+	case Opt_datadir_add:
+		err = ovl_parse_layer(fc, param, opt, false);
+		break;
 	case Opt_upperdir:
 	case Opt_workdir:
 		err = ovl_parse_layer(fc, param, opt, true);
@@ -889,13 +947,29 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 {
 	struct super_block *sb = dentry->d_sb;
 	struct ovl_fs *ofs = OVL_FS(sb);
+	size_t nr, nr_merged_lower, nr_lower = 0;
 	char **lowerdirs = ofs->config.lowerdirs;
 
 	/*
 	 * lowerdirs[0] holds the colon separated list that user provided
 	 * with lowerdir mount option.
+	 * lowerdirs[1..numlayer] hold the lowerdir paths that were added
+	 * using the lowerdir+ and datadir+ mount options.
+	 * For now, we do not allow mixing the legacy lowerdir mount option
+	 * with the new lowerdir+ and datadir+ mount options.
 	 */
-	seq_show_option(m, "lowerdir", lowerdirs[0]);
+	if (lowerdirs[0]) {
+		seq_show_option(m, "lowerdir", lowerdirs[0]);
+	} else {
+		nr_lower = ofs->numlayer;
+		nr_merged_lower = nr_lower - ofs->numdatalayer;
+	}
+	for (nr = 1; nr < nr_lower; nr++) {
+		if (nr < nr_merged_lower)
+			seq_show_option(m, "lowerdir+", lowerdirs[nr]);
+		else
+			seq_show_option(m, "datadir+", lowerdirs[nr]);
+	}
 	if (ofs->config.upperdir) {
 		seq_show_option(m, "upperdir", ofs->config.upperdir);
 		seq_show_option(m, "workdir", ofs->config.workdir);
-- 
2.34.1

