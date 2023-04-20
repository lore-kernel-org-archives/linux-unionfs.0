Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11D5C77B73
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 07:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbjDTHp2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 03:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbjDTHp0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 03:45:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E414215
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681976680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFfDzOpN8AwDMI+ALL6ukZpiGMzVGxyEj03IiSzNlGw=;
        b=f1HGX4lUPjUl0ScPVXrL4IAX2q/LbR/FOAEkERAwHZzGh+xib50C/Sq8Kqz1ZMngxTtRV9
        x7J1U1cNHvLh+BPJNvmtP2d+VXxCaMGaDW2dTfDCuxVlsFjDpJGGJLrBnONxfb7T8WHgyt
        G7WfJvuqlqIJBCoZDOPUf16Panb91K0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-9YxYPh2eOVm1pjl2mClafQ-1; Thu, 20 Apr 2023 03:44:33 -0400
X-MC-Unique: 9YxYPh2eOVm1pjl2mClafQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4ec9d0d7e29so206642e87.0
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681976672; x=1684568672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFfDzOpN8AwDMI+ALL6ukZpiGMzVGxyEj03IiSzNlGw=;
        b=Pdivx6u7KCjSCaal88rVvtT2vaxazU/ypVkZy02rgEP0qgGVnJtx1IWGdbirw/hBtE
         DQV+Z8rbU9vqlz/ERBgZ9e6EjR1SB0ekslqLYBPJ20QcOYRjclg4PKDYqC8GSt2MgzHc
         hgnvV22bLiGQI75QqtNTVkgbsQ8cg1yI2GCvK1dTM7Uo5z8CJUMLQ/wVfsvZuM2C/E2h
         ybOp/46paRsPZ3f9b+G3cHzt1os4qdbENRwzkU5IBMC4B/zD1B4cOxRPnupVKyKCYlBQ
         FppOmpit55n2AUB9IVVZgjrnPr0WIBgN/a8JTaNXTBO29mZwQnr8/E24OC4PTtGWNLZr
         ioeQ==
X-Gm-Message-State: AAQBX9dgTl0ibwufne8T3HCvEW5WipcXn1bLAPmPKgdb/KoWl2ZiRu5V
        yU8EZ1C7biOZ1+mRxQ+U20PO9m3fgRTlAtUw6Ez+6WhpSQdRIatoUmjdnG6SqxusMlFjsbG/HU6
        wGunBoUCoZgrzg9cjUULRqzJwgQ==
X-Received: by 2002:a05:6512:3886:b0:4eb:3149:cbe1 with SMTP id n6-20020a056512388600b004eb3149cbe1mr138668lft.10.1681976671835;
        Thu, 20 Apr 2023 00:44:31 -0700 (PDT)
X-Google-Smtp-Source: AKy350bodfiYKk0aA7KBUWiNExoQs+d7MhpL+4rQ400F7a2voyFHpnkxqEbkvm+A2gTJfpfSU1IHaQ==
X-Received: by 2002:a05:6512:3886:b0:4eb:3149:cbe1 with SMTP id n6-20020a056512388600b004eb3149cbe1mr138659lft.10.1681976671621;
        Thu, 20 Apr 2023 00:44:31 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id x24-20020ac24898000000b004edc7247778sm129468lfc.79.2023.04.20.00.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 00:44:30 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 4/6] ovl: Add framework for verity support
Date:   Thu, 20 Apr 2023 09:44:03 +0200
Message-Id: <2b2c5ecaf80f810f46791a94d8638ec4027a3a0e.1681917551.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681917551.git.alexl@redhat.com>
References: <cover.1681917551.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This adds the scaffolding (docs, config, mount options) for supporting
for a new overlay xattr "overlay.verity", which contains a fs-verity
digest. This is used for metacopy files, and the actual fs-verity
digest of the lowerdata file needs to match it. The mount option
"verity" specifies how this xattrs is handled.

Unless you explicitly disable it ("verity=off") all existing xattrs
are validated before use. This is all that happens by default
("verity=validate"), but, if you turn on verity ("verity=on") then
during metacopy we generate verity xattr in the upper metacopy file if
the source file has verity enabled. This means later accesses can
guarantee that the correct data is used.

Additionally you can use "verity=require". In this mode all metacopy
files must have a valid verity xattr. For this to work metadata
copy-up must be able to create a verity xattr (so that later accesses
are validated). Therefore, in this mode, if the lower data file
doesn't have fs-verity enabled we fall back to a full copy rather than
a metacopy.

Actual implementation follows in a separate commit.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 Documentation/filesystems/overlayfs.rst | 33 +++++++++++++++++
 fs/overlayfs/Kconfig                    | 14 +++++++
 fs/overlayfs/ovl_entry.h                |  4 ++
 fs/overlayfs/super.c                    | 49 +++++++++++++++++++++++++
 4 files changed, 100 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index c8e04a4f0e21..66895bf71cd1 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -403,6 +403,39 @@ when a "metacopy" file in one of the lower layers above it, has a "redirect"
 to the absolute path of the "lower data" file in the "data-only" lower layer.
 
 
+fs-verity support
+----------------------
+
+When metadata copy up is used for a file, then the xattr
+"trusted.overlay.verity" may be set on the metacopy file. This
+specifies the expected fs-verity digest of the lowerdata file. This
+may then be used to verify the content of the source file at the time
+the file is opened. If enabled, overlayfs can also set this xattr
+during metadata copy up.
+
+This is controlled by the "verity" mount option, which supports
+these values:
+
+- "off":
+    The verity xattr is never used.
+- "validate":
+    Whenever a metacopy files specifies an expected digest, the
+    corresponding data file must match the specified digest.
+- "on":
+    Same as validate, but additionally, when generating a metacopy
+    file the verity xattr will be set from the source file fs-verity
+    digest (if it has one).
+- "require":
+    Same as "on", but additionally all metacopy files must specify a
+    verity xattr. Additionally metadata copy up will only be used if
+    the data file has fs-verity enabled, otherwise a full copy-up is
+    used.
+
+There are two ways to tune the default behaviour. The kernel config
+option OVERLAY_FS_VERITY, or the module option "verity=BOOL". If
+either of these are enabled, then verity mode is "on" by default,
+otherwise it is "validate".
+
 Sharing and copying layers
 --------------------------
 
diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 6708e54b0e30..98d6b1a7baf5 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -124,3 +124,17 @@ config OVERLAY_FS_METACOPY
 	  that doesn't support this feature will have unexpected results.
 
 	  If unsure, say N.
+
+config OVERLAY_FS_VERITY
+	bool "Overlayfs: turn on verity feature by default"
+	depends on OVERLAY_FS
+	depends on OVERLAY_FS_METACOPY
+	help
+	  If this config option is enabled then overlay filesystems will
+	  try to copy fs-verity digests from the lower file into the
+	  metacopy file at metadata copy-up time. It is still possible
+	  to turn off this feature globally with the "verity=off"
+	  module option or on a filesystem instance basis with the
+	  "verity=off" or "verity=validate" mount option.
+
+	  If unsure, say N.
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index a7b1006c5321..f759e476dfc7 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -13,6 +13,10 @@ struct ovl_config {
 	bool redirect_dir;
 	bool redirect_follow;
 	const char *redirect_mode;
+	bool verity_validate;
+	bool verity_generate;
+	bool verity_require;
+	const char *verity_mode;
 	bool index;
 	bool uuid;
 	bool nfs_export;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ef78abc21998..953d76f6a1e3 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -59,6 +59,11 @@ module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
 MODULE_PARM_DESC(metacopy,
 		 "Default to on or off for the metadata only copy up feature");
 
+static bool ovl_verity_def = IS_ENABLED(CONFIG_OVERLAY_FS_VERITY);
+module_param_named(verity, ovl_verity_def, bool, 0644);
+MODULE_PARM_DESC(verity,
+		 "Default to on or validate for the metadata only copy up feature");
+
 static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode)
 {
@@ -235,6 +240,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	kfree(ofs->config.upperdir);
 	kfree(ofs->config.workdir);
 	kfree(ofs->config.redirect_mode);
+	kfree(ofs->config.verity_mode);
 	if (ofs->creator_cred)
 		put_cred(ofs->creator_cred);
 	kfree(ofs);
@@ -325,6 +331,11 @@ static const char *ovl_redirect_mode_def(void)
 	return ovl_redirect_dir_def ? "on" : "off";
 }
 
+static const char *ovl_verity_mode_def(void)
+{
+	return ovl_verity_def ? "on" : "validate";
+}
+
 static const char * const ovl_xino_str[] = {
 	"off",
 	"auto",
@@ -374,6 +385,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 		seq_puts(m, ",volatile");
 	if (ofs->config.userxattr)
 		seq_puts(m, ",userxattr");
+	if (strcmp(ofs->config.verity_mode, ovl_verity_mode_def()) != 0)
+		seq_printf(m, ",verity=%s", ofs->config.verity_mode);
 	return 0;
 }
 
@@ -429,6 +442,7 @@ enum {
 	OPT_METACOPY_ON,
 	OPT_METACOPY_OFF,
 	OPT_VOLATILE,
+	OPT_VERITY,
 	OPT_ERR,
 };
 
@@ -451,6 +465,7 @@ static const match_table_t ovl_tokens = {
 	{OPT_METACOPY_ON,		"metacopy=on"},
 	{OPT_METACOPY_OFF,		"metacopy=off"},
 	{OPT_VOLATILE,			"volatile"},
+	{OPT_VERITY,			"verity=%s"},
 	{OPT_ERR,			NULL}
 };
 
@@ -500,6 +515,25 @@ static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
 	return 0;
 }
 
+static int ovl_parse_verity_mode(struct ovl_config *config, const char *mode)
+{
+	if (strcmp(mode, "validate") == 0) {
+		config->verity_validate = true;
+	} else if (strcmp(mode, "on") == 0) {
+		config->verity_validate = true;
+		config->verity_generate = true;
+	} else if (strcmp(mode, "require") == 0) {
+		config->verity_validate = true;
+		config->verity_generate = true;
+		config->verity_require = true;
+	} else if (strcmp(mode, "off") != 0) {
+		pr_err("bad mount option \"verity=%s\"\n", mode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int ovl_parse_opt(char *opt, struct ovl_config *config)
 {
 	char *p;
@@ -511,6 +545,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 	if (!config->redirect_mode)
 		return -ENOMEM;
 
+	config->verity_mode = kstrdup(ovl_verity_mode_def(), GFP_KERNEL);
+	if (!config->verity_mode)
+		return -ENOMEM;
+
 	while ((p = ovl_next_opt(&opt)) != NULL) {
 		int token;
 		substring_t args[MAX_OPT_ARGS];
@@ -611,6 +649,13 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->userxattr = true;
 			break;
 
+		case OPT_VERITY:
+			kfree(config->verity_mode);
+			config->verity_mode = match_strdup(&args[0]);
+			if (!config->verity_mode)
+				return -ENOMEM;
+			break;
+
 		default:
 			pr_err("unrecognized mount option \"%s\" or missing value\n",
 					p);
@@ -642,6 +687,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 	if (err)
 		return err;
 
+	err = ovl_parse_verity_mode(config, config->verity_mode);
+	if (err)
+		return err;
+
 	/*
 	 * This is to make the logic below simpler.  It doesn't make any other
 	 * difference, since config->redirect_dir is only used for upper.
-- 
2.39.2

